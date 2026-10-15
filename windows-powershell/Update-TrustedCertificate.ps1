#requires -Version 5.1
<# .SYNOPSIS
Validate and optionally install a CA certificate with a verified SHA-256 fingerprint.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$CertificatePath,
    [Parameter(Mandatory)][ValidatePattern('^[a-fA-F0-9]{64}$')][string]$ExpectedSha256,
    [ValidateSet('CurrentUser','LocalMachine')][string]$Scope = 'CurrentUser',
    [ValidateSet('CA','Root')][string]$StoreName = 'CA',
    [ValidateRange(1,3650)][int]$MinimumDays = 7,
    [switch]$Apply
)
$ErrorActionPreference = 'Stop'
$path = (Resolve-Path -LiteralPath $CertificatePath).Path
$certificate = [Security.Cryptography.X509Certificates.X509Certificate2]::new($path)
try {
    if ($certificate.HasPrivateKey) { throw 'Use a public CA certificate, not a PFX/private key.' }
    $sha = [Security.Cryptography.SHA256]::Create()
    try { $fingerprint = ([BitConverter]::ToString($sha.ComputeHash($certificate.RawData))).Replace('-','') } finally { $sha.Dispose() }
    if ($fingerprint -ne $ExpectedSha256) { throw 'SHA-256 fingerprint does not match the independently verified value.' }
    $constraints = $certificate.Extensions | Where-Object { $_.Oid.Value -eq '2.5.29.19' }
    if (!$constraints -or !$constraints.CertificateAuthority) { throw 'Certificate is not a CA.' }
    if ($certificate.NotBefore -gt (Get-Date) -or $certificate.NotAfter -lt (Get-Date).AddDays($MinimumDays)) { throw 'Certificate is not valid now or expires too soon.' }
    $store = "Cert:\$Scope\$StoreName"
    $certificate | Select-Object Subject,Issuer,Thumbprint,NotBefore,NotAfter
    Write-Output "SHA256: $fingerprint; destination: $store"
    if (Test-Path -LiteralPath "$store\$($certificate.Thumbprint)") { Write-Output 'Certificate already installed.'; return }
    if (!$Apply) { Write-Output 'Preview only. Supply -Apply to install this CA certificate.'; return }
    if ($PSCmdlet.ShouldProcess($store,"Trust CA $fingerprint")) {
        Import-Certificate -FilePath $path -CertStoreLocation $store | Select-Object Subject,Thumbprint
    }
} finally { $certificate.Dispose() }
