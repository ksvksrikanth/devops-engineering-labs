#requires -Version 7.0
<#
.SYNOPSIS
Send an HTTP request and display its status, headers, body, and elapsed time.
.EXAMPLE
./Invoke-HttpCheck.ps1 -Uri https://example.com
.EXAMPLE
./Invoke-HttpCheck.ps1 -Uri http://localhost:8080/api -Method POST -Body '{"name":"demo"}'
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][uri]$Uri,
    [ValidateSet('GET','HEAD','POST','PUT','PATCH','DELETE')][string]$Method = 'GET',
    [string]$Body,
    [hashtable]$Headers = @{},
    [ValidateRange(1,300)][int]$TimeoutSeconds = 15
)
$ErrorActionPreference = 'Stop'
if ($Uri.Scheme -notin 'http','https') { throw 'Use an HTTP or HTTPS URL.' }
$request = @{ Uri=$Uri; Method=$Method; Headers=$Headers; TimeoutSec=$TimeoutSeconds; SkipHttpErrorCheck=$true }
if ($PSBoundParameters.ContainsKey('Body')) { $request.Body=$Body; $request.ContentType='application/json' }
$timer = [Diagnostics.Stopwatch]::StartNew()
try {
    $response = Invoke-WebRequest @request
    $timer.Stop()
    [pscustomobject]@{ StatusCode=[int]$response.StatusCode; ElapsedMs=$timer.ElapsedMilliseconds; Headers=$response.Headers; Body=$response.Content }
    if ([int]$response.StatusCode -ge 400) { exit 1 }
} catch { Write-Error "HTTP request failed: $($_.Exception.Message)"; exit 1 }
