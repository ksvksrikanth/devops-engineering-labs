#requires -Version 5.1
<#
.SYNOPSIS
Use Windows PowerShell remoting to inspect a server or restart one service.
.EXAMPLE
./Invoke-RemoteOperations.ps1 -ComputerName server01 -Operation Health
.EXAMPLE
./Invoke-RemoteOperations.ps1 -ComputerName server01 -Operation RestartService -ServiceName Spooler -WhatIf
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)][string]$ComputerName,
    [ValidateSet('Health','Services','RecentErrors','RestartService')][string]$Operation = 'Health',
    [ValidatePattern('^[a-zA-Z0-9_.-]+$')][string]$ServiceName,
    [pscredential]$Credential,
    [switch]$UseSSL
)
$ErrorActionPreference = 'Stop'
if ($Operation -eq 'RestartService' -and !$ServiceName) { throw 'RestartService requires -ServiceName.' }
if ($Operation -eq 'RestartService' -and !$PSCmdlet.ShouldProcess($ComputerName,"Restart service $ServiceName")) { return }
$connection = @{ ComputerName=$ComputerName; UseSSL=[bool]$UseSSL; ErrorAction='Stop' }
if ($Credential) { $connection.Credential=$Credential }
Invoke-Command @connection -ArgumentList $Operation,$ServiceName -ScriptBlock {
    param($Operation,$ServiceName)
    $ErrorActionPreference = 'Stop'
    switch ($Operation) {
        Health {
            Get-CimInstance Win32_OperatingSystem | Select-Object CSName,LastBootUpTime,FreePhysicalMemory,TotalVisibleMemorySize
            Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | Select-Object DeviceID,Size,FreeSpace
        }
        Services { Get-Service | Select-Object Name,Status,StartType }
        RecentErrors { Get-WinEvent -FilterHashtable @{LogName='System';Level=2;StartTime=(Get-Date).AddDays(-1)} -MaxEvents 20 | Select-Object TimeCreated,Id,ProviderName,Message }
        RestartService {
            $service = Get-Service -Name $ServiceName
            Restart-Service -InputObject $service
            $service.WaitForStatus('Running',[TimeSpan]::FromSeconds(30))
            $service.Refresh()
            $service | Select-Object Name,Status
        }
    }
}
