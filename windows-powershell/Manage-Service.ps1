#requires -Version 5.1
<#
.SYNOPSIS
Inspect, start, stop, or restart one Windows service by its exact service name.
.EXAMPLE
./Manage-Service.ps1 -Name Spooler -Action Restart -WhatIf
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][ValidatePattern('^[a-zA-Z0-9_.-]+$')][string]$Name,
    [ValidateSet('Status','Start','Stop','Restart')][string]$Action = 'Status',
    [ValidateRange(1,300)][int]$TimeoutSeconds = 30
)
$ErrorActionPreference = 'Stop'
$service = Get-Service -Name $Name -ErrorAction Stop
if ($Action -ne 'Status' -and $PSCmdlet.ShouldProcess($Name,"$Action service")) {
    switch ($Action) {
        Start { Start-Service -InputObject $service }
        Stop { Stop-Service -InputObject $service }
        Restart { Restart-Service -InputObject $service }
    }
    $target = if ($Action -eq 'Stop') { 'Stopped' } else { 'Running' }
    $service.WaitForStatus($target,[TimeSpan]::FromSeconds($TimeoutSeconds))
    $service.Refresh()
}
$service | Select-Object Name,DisplayName,Status,StartType
