#requires -Version 5.1
<# .SYNOPSIS
Report uptime, free memory, disk space, and the busiest processes on Windows.
#>
[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$os = Get-CimInstance Win32_OperatingSystem
[pscustomobject]@{
    ComputerName=$env:COMPUTERNAME
    Uptime=(Get-Date)-$os.LastBootUpTime
    FreeMemoryGB=[math]::Round($os.FreePhysicalMemory/1MB,2)
    TotalMemoryGB=[math]::Round($os.TotalVisibleMemorySize/1MB,2)
    Disks=@(Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | Select-Object DeviceID,@{N='FreeGB';E={[math]::Round($_.FreeSpace/1GB,2)}},@{N='SizeGB';E={[math]::Round($_.Size/1GB,2)}})
    TopProcessesByCumulativeCPU=@(Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 Name,Id,CPU,WorkingSet64)
}
