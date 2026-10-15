# Common DevOps Scripts — Windows and Linux

These six Python tools handle jobs that come up often: checking disk space, testing an endpoint, clearing old logs, collecting metrics, validating configuration, and taking a backup. They work on Windows and Linux with Python 3.10 or later.

Run the examples from this folder. Each tool runs once and exits, although the metrics collector can take several samples. To run checks regularly, schedule them with Task Scheduler, cron, or a systemd timer.

## Setup

Windows PowerShell:

```powershell
python -m venv .venv
.venv\Scripts\python.exe -m pip install -r requirements.txt
.venv\Scripts\Activate.ps1
```

Linux/WSL:

```bash
python3 -m venv .venv
.venv/bin/python -m pip install -r requirements.txt
source .venv/bin/activate
```

If activation is unavailable, use the virtual environment's Python executable directly in the commands below. Dependencies: `psutil` for portable disk/CPU/RAM access and `PyYAML` for safe YAML parsing. No administrator privileges are normally required for local checks.

| Script | Behavior | Exit codes |
| --- | --- | --- |
| `disk_monitor.py` | Discover local volumes or check explicit paths; print/append JSON alerts | 0 healthy, 1 threshold met, 2 error |
| `health_check.py` | HTTP GET expecting 200, or TCP connection; optional failure webhook | 0 healthy, 1 failed check, 2 configuration/notification error |
| `log_cleanup.py` | Preview old matching logs, delete only with `--apply` | 0 successful scan/apply, 2 error |
| `collect_metrics.py` | Timestamped CPU and memory CSV samples | 0 collected, 2 error |
| `validate_environment.py` | Environment presence, config syntax, and TCP checks | 0 passed, 1 validation failed, 2 usage error |
| `backup_archive.py` | Timestamped ZIP, integrity check, SHA-256 sidecar | 0 created, 2 error |

Use `python SCRIPT.py --help` for options. JSON/log timestamps use UTC. Log and CSV output parent directories must already exist. Keep one writer per log/CSV file. Do not commit tokens, metrics containing private hostnames, logs, archives, or real config secrets.

## Disk usage and storage alerts

```bash
python disk_monitor.py --threshold 80
python disk_monitor.py --path . --threshold 80 --log disk-alerts.jsonl
```

Usage at or above the threshold produces `WARNING` and exit 1. Repeated `--path` checks selected paths instead of discovered local mounts. Use `--path C:/` on Windows or `--path /` on Linux. Unreadable/unavailable volumes produce error records and exit 2. Filesystem reserved space may make the percentage differ from `df`'s capacity percentage.

## HTTP/TCP health checks

```bash
python health_check.py --url http://localhost:8080/health --timeout 5 --log health.jsonl
python health_check.py --tcp-host localhost --port 5432
python health_check.py --url http://localhost:8080/ready --expected-status 204
```

HTTP checks require the exact expected status, default 200; redirects are not followed and TLS certificates are verified. TCP only checks whether a connection opens: it does not authenticate to a database or execute a query. Network timeouts are per operation, not a strict end-to-end deadline including DNS lookup.

Optional Slack-compatible notification on failure:

```bash
python health_check.py --url http://localhost:8080/health --webhook-env DEVOPS_ALERT_WEBHOOK
```

Set `DEVOPS_ALERT_WEBHOOK` securely in your shell or scheduler environment. The script sends a generic `{"text":"..."}` JSON payload only on failure. Teams workflows must be configured to accept that payload; other Teams connectors may need a different adapter. No webhook is called unless this option is supplied. Service restarts are deliberately manual: use the companion Windows `Manage-Service.ps1` or Linux `manage-service.sh` after diagnosis.

## Log cleanup and retention

```bash
python log_cleanup.py ./logs --days 30
python log_cleanup.py ./logs --days 30 --pattern '*.log.*'
python log_cleanup.py ./logs --days 30 --apply
```

Start with the preview to see which files would be removed. The script checks modification times and looks for `*.log` by default. Keep the pattern in quotes so your shell passes it to the script unchanged. Only matching regular files older than the cutoff are deleted. Empty folders are retained. Symlinks and Windows junction/reparse points are skipped. Root/home cleanup targets are rejected. Use a dedicated directory you control and pause competing log writers/rotation during deletion; these checks are not protection against hostile concurrent filesystem changes. The script implements retention cleanup, not live log rotation. Use logrotate or the application's logging framework to roll actively written logs. Archive logs first with the backup tool if retention requires keeping them.

## CPU and memory metrics

```bash
python collect_metrics.py --output metrics.csv --samples 5 --interval 1
```

CPU is sampled across all CPUs over each interval. Memory includes total, available, and used bytes; used is defined as total minus available (including the OS's available-memory estimate). Records append with one header. An incompatible existing CSV header is rejected. Use separate output files for concurrent collectors.

## Deployment pre-flight validation

```bash
python validate_environment.py --env APP_ENV --env DATABASE_URL --config examples/app.json --config examples/app.yaml
python validate_environment.py --tcp localhost 5432 --tcp localhost 6379
```

The validator checks whether each required variable has a value, without printing that value. Empty values and values containing only whitespace fail. JSON and YAML checks validate syntax only, not application schema or semantic correctness; YAML uses a safe loader. Empty YAML documents are syntactically valid. TCP checks do not validate credentials, database readiness, or query results. Invalid config contents are not echoed.

## Timestamped backups

```bash
python backup_archive.py ./examples --destination ../backups
```

The ZIP destination must be outside the source tree. Each run creates a unique UTC-timestamped ZIP, verifies member CRCs, and writes a `.zip.sha256` checksum. Empty subdirectories are preserved; links/junctions/special files are excluded. Archives include source file contents without filtering secrets and are not encrypted. Store them appropriately. ZIP is not a full-fidelity backup of Linux ownership/ACLs or Windows security descriptors. Pause application writes if you need a consistent backup. For a running database, first use its own export or dump tool, then archive the resulting file. This is not a database snapshot tool.

Once you have checked the backup, you can upload it with a configured cloud CLI. Replace the example filename and destination:

```bash
aws s3 cp "../backups/ARCHIVE.zip" "s3://YOUR-BUCKET/devops-backups/ARCHIVE.zip"
az storage blob upload --auth-mode login --account-name YOUR_ACCOUNT --container-name backups --name ARCHIVE.zip --file "../backups/ARCHIVE.zip"
```

Upload the matching checksum as well. Cloud upload is a separate explicit command; no cloud resources or transfers are performed by the Python tool.

## Verification

```bash
python -m unittest discover -s tests -v
```

Tests use temporary files and a loopback HTTP server. They cover threshold exit codes, exact HTTP status, config validation, CSV append, cleanup preview/apply, and backup integrity. They do not contact external servers or send webhooks.
