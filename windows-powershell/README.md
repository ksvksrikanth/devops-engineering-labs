# Windows PowerShell DevOps Scripts

Start here when you want to check an API response, restart a lab service, inspect a remote Windows server, or collect a quick health report. Run the examples from this folder.

The HTTP script needs PowerShell 7 (`pwsh`). The service, remote-operation, and health-report scripts also work in Windows PowerShell 5.1. The certificate guide below explains the Windows module requirements for those scripts.

| Script | Purpose |
| --- | --- |
| `Invoke-HttpCheck.ps1` | Send requests; inspect response status, headers, body, and timing |
| `Manage-Service.ps1` | Status, start, stop, or restart a local Windows service |
| `Invoke-RemoteOperations.ps1` | Inspect Windows servers or restart a named remote service using WinRM |
| `Get-SystemHealth.ps1` | Uptime, memory, disk capacity, and process CPU totals |

## HTTP requests and responses

```powershell
./Invoke-HttpCheck.ps1 -Uri https://example.com | Format-List
./Invoke-HttpCheck.ps1 -Uri http://localhost:8080/health
./Invoke-HttpCheck.ps1 -Uri http://localhost:8080/api -Method POST -Body '{"name":"demo"}'
# Use an environment variable for a token; do not save credentials in scripts.
./Invoke-HttpCheck.ps1 -Uri https://api.example.com/status -Headers @{Authorization="Bearer $env:API_TOKEN"}
```

Use a local application that implements the example endpoints. HTTP 400+ and connection failures return a nonzero exit code. Redirect handling follows Invoke-WebRequest defaults. Response bodies and headers can contain sensitive data; inspect them before saving logs.

## Windows service operations

```powershell
Get-Service                         # Discover actual service names
./Manage-Service.ps1 -Name Spooler
./Manage-Service.ps1 -Name Spooler -Action Stop -WhatIf
./Manage-Service.ps1 -Name Spooler -Action Stop
./Manage-Service.ps1 -Name Spooler -Action Start
./Manage-Service.ps1 -Name Spooler -Action Restart -Confirm
```

You will usually need to open PowerShell as administrator to change a service. Try this on a lab machine first; stopping Spooler affects printing. `-WhatIf` previews a change. The script waits up to 30 seconds for the requested state and reports failures.

## Remote Windows operations

The target must already have PowerShell remoting/WinRM enabled and an appropriate firewall rule. Use a domain server with Kerberos, or configured WinRM HTTPS with a trusted certificate and `-UseSSL`. Your account must have remoting permissions, plus service-control permissions for a restart. These scripts do not change remoting or firewall settings.

```powershell
Test-WSMan server01
./Invoke-RemoteOperations.ps1 -ComputerName server01 -Operation Health
./Invoke-RemoteOperations.ps1 -ComputerName server01 -Operation Services
./Invoke-RemoteOperations.ps1 -ComputerName server01 -Operation RecentErrors
$credential = Get-Credential
./Invoke-RemoteOperations.ps1 -ComputerName server01.example.com -UseSSL -Credential $credential -Operation Health
./Invoke-RemoteOperations.ps1 -ComputerName server01 -Operation RestartService -ServiceName Spooler -WhatIf
# Remove -WhatIf to perform the restart on your lab server.
```

`RecentErrors` examines the last 24 hours of the System log; no matching events can produce a no-events error. Access denied means the account or endpoint permissions need checking. Avoid disabling certificate checks or broadly trusting unknown hosts.

## Health report

```powershell
./Get-SystemHealth.ps1 | ConvertTo-Json -Depth 5
./Get-SystemHealth.ps1 | ConvertTo-Json -Depth 5 | Set-Content health-report.json
```

The CPU column shows how many seconds of CPU time each process has used since it started. It is not a live percentage. Run the report again whenever you need a fresh snapshot.

## Common Windows and Linux automation

See [cross-platform DevOps scripts](../common-scripts/README.md) for disk alerts, HTTP/TCP health checks, log retention cleanup, CPU/RAM CSV metrics, environment/config validation, and timestamped ZIP backups. The guide includes setup steps, examples, and tests you can run locally.

## Certificate updates

Use `Update-TrustedCertificate.ps1` for CA certificates and `Update-TlsCertificate.ps1` for a server certificate. See the [certificate update guide](../certificate-guide.md) for CA trust updates, TLS replacement, preview/apply commands, rollback behavior, and platform requirements. Start with the default preview to see what would change before applying an update.
