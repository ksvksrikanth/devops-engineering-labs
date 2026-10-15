#requires -Version 5.1
<# .SYNOPSIS
Validate/import a PFX and optionally replace one existing IIS HTTPS binding.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$PfxPath,
    [Parameter(Mandatory)][securestring]$Password,
    [ValidateRange(1,3650)][int]$MinimumDays = 7,
    [string]$SiteName,
    [string]$BindingInformation,
    [string]$BackupDirectory = '.\certificate-backups',
    [switch]$Apply
)
$ErrorActionPreference = 'Stop'
if ([bool]$SiteName -ne [bool]$BindingInformation) { throw 'Specify both SiteName and BindingInformation, or neither.' }
$path = (Resolve-Path -LiteralPath $PfxPath).Path
$pfx = Get-PfxData -FilePath $path -Password $Password
$leafs = @($pfx.EndEntityCertificates)
if ($leafs.Count -ne 1) { throw 'Provide a PFX with exactly one end-entity certificate.' }
$leaf = $leafs[0]
if ($leaf.NotBefore -gt (Get-Date) -or $leaf.NotAfter -lt (Get-Date).AddDays($MinimumDays)) { throw 'Certificate is not valid now or expires too soon.' }
$eku = $leaf.Extensions | Where-Object { $_.Oid.Value -eq '2.5.29.37' }
if (!$eku -or '1.3.6.1.5.5.7.3.1' -notin @($eku.EnhancedKeyUsages | ForEach-Object {$_.Value})) { throw 'An explicit Server Authentication EKU is required.' }
$chain = [Security.Cryptography.X509Certificates.X509Chain]::new()
try {
    $chain.ChainPolicy.ApplicationPolicy.Add([Security.Cryptography.Oid]::new('1.3.6.1.5.5.7.3.1'))
    $chain.ChainPolicy.UrlRetrievalTimeout = [TimeSpan]::FromSeconds(15)
    foreach ($certificate in $pfx.OtherCertificates) { [void]$chain.ChainPolicy.ExtraStore.Add($certificate) }
    if (!$chain.Build($leaf)) { throw "Certificate chain/revocation validation failed: $($chain.ChainStatus.Status -join ', ')" }
} finally { $chain.Dispose() }
$binding = $null
if ($SiteName) {
    Import-Module WebAdministration -ErrorAction Stop
    $matches = @(Get-WebBinding -Name $SiteName -Protocol https | Where-Object { $_.bindingInformation -eq $BindingInformation })
    if ($matches.Count -ne 1) { throw 'Expected exactly one existing HTTPS binding.' }
    $binding = $matches[0]
    if ([int]$binding.sslFlags -band 2) { throw 'Central Certificate Store bindings are not supported.' }
    if (!$binding.certificateHash) { throw 'Existing binding has no certificate to restore.' }
}
$leaf | Select-Object Subject,Issuer,Thumbprint,NotAfter,DnsNameList
if (!$Apply) { Write-Output 'Preview only. Verify the DNS names, then supply -Apply to import/rebind.'; return }
if (!$PSCmdlet.ShouldProcess("LocalMachine\My; IIS site '$SiteName' binding '$BindingInformation'",'Import TLS certificate and optionally rebind')) { return }
# Keep old certificates and keys in place for rollback. Do not mark new keys exportable.
$imported = @(Import-PfxCertificate -FilePath $path -Password $Password -CertStoreLocation 'Cert:\LocalMachine\My')
$installed = @($imported | Where-Object { $_.Thumbprint -eq $leaf.Thumbprint -and $_.HasPrivateKey })
if ($installed.Count -ne 1) { throw 'Import did not yield the expected certificate with private key; binding unchanged.' }
if ($binding) {
    $oldHash = if ($binding.certificateHash -is [byte[]]) { ([BitConverter]::ToString($binding.certificateHash)).Replace('-','') } else { [string]$binding.certificateHash }
    $oldStore = [string]$binding.certificateStoreName
    New-Item -ItemType Directory -Path $BackupDirectory -Force | Out-Null
    $record = Join-Path $BackupDirectory ("iis-binding-{0}-{1}.json" -f (Get-Date -Format 'yyyyMMddTHHmmss'),[guid]::NewGuid().ToString('N'))
    [pscustomobject]@{SiteName=$SiteName;BindingInformation=$BindingInformation;OldThumbprint=$oldHash;OldStore=$oldStore;NewThumbprint=$leaf.Thumbprint} | ConvertTo-Json | Set-Content -LiteralPath $record -Encoding UTF8
    try { $binding.AddSslCertificate($leaf.Thumbprint,'My') }
    catch {
        $failure = $_
        try { $binding.AddSslCertificate($oldHash,$oldStore) } catch { Write-Warning "Automatic binding rollback failed. Use backup record $record." }
        throw $failure
    }
    Write-Output "Updated binding. Rollback record: $record"
}
Write-Output "Installed certificate: $($leaf.Thumbprint). Verify the live endpoint before removing any old certificate."
