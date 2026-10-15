# Linux DevOps Scripts

These Bash scripts cover a few regular Linux tasks: checking an HTTP response, managing a service, connecting over SSH, and getting a quick health report. Run the examples from the parent `linux-networking-git` folder.

On Ubuntu, you need `curl`, `openssh-client`, `procps`, and `iproute2`. Service commands also need systemd, which may be missing in a minimal container or some WSL setups.

| Script | Purpose |
| --- | --- |
| `http-check.sh` | HTTP request, response headers/body, and status |
| `manage-service.sh` | Inspect, start, stop, or restart a systemd service |
| `remote-operations.sh` | SSH health checks, failed services, or recent error logs |
| `system-health.sh` | Host uptime, memory, disks, processes, and listening TCP ports |

## HTTP requests

```bash
bash scripts/http-check.sh https://example.com
bash scripts/http-check.sh http://localhost:8080/health
printf '%s\n' '{"name":"demo"}' > /tmp/devops-request.json
bash scripts/http-check.sh http://localhost:8080/api POST /tmp/devops-request.json
```

Run a local app that implements the example endpoints. The script displays response headers and body, then the status code. HTTP 400+ and connection failures return a nonzero exit code. Redirect responses are displayed without following them. Response data may contain secrets; avoid saving it to shared logs.

## Services

```bash
systemctl list-unit-files --type=service
bash scripts/manage-service.sh nginx status
bash scripts/manage-service.sh nginx restart --dry-run
bash scripts/manage-service.sh nginx stop
bash scripts/manage-service.sh nginx start
bash scripts/manage-service.sh nginx restart
```

Replace `nginx` with a service installed on your lab machine. Changes use `sudo` and may prompt for your password. Status returns systemctl's nonzero exit code for an inactive/missing service; a successful stop returns zero. Do not stop SSH on a server you can access only through SSH.

## SSH remote operations

The server needs SSH running and your public key installed for a permitted account. Before using the script, connect manually and check the server fingerprint against a trusted source:

```bash
ssh devops@server01.example.com
exit
bash scripts/remote-operations.sh devops@server01.example.com health
bash scripts/remote-operations.sh devops@server01.example.com services
bash scripts/remote-operations.sh devops@server01.example.com logs 22
```

The script uses key/agent authentication in batch mode; it fails instead of prompting for a password. Existing SSH config and known-host verification apply. It supports hostnames and IPv4 addresses. Remote hosts need Bash and the same health-check utilities. Services/logs require systemd; journal access depends on account permissions. All three remote operations are read-only. Run service changes interactively with the local service script on the server.

## System health

```bash
bash scripts/system-health.sh
bash scripts/system-health.sh > /tmp/devops-health.txt
```

This is a human-readable snapshot. Process CPU percentages come from `ps`, not a live sampling loop. Try taking a report before and after starting a lab application. Compare the processes and look for the new listening port.

## Certificate updates

Use `update-trusted-certificate.sh` for a CA update and `update-tls-certificate.sh` for an nginx certificate/key pair. See the [certificate update guide](../../certificate-guide.md) for CA trust updates, TLS replacement, preview/apply commands, rollback behavior, and platform requirements. Start with the default preview to see what would change before applying an update.
