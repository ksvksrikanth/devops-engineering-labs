#!/usr/bin/env bash
# Usage: bash remote-operations.sh USER@HOST [health|services|logs] [PORT]
set -euo pipefail
target=${1:?Usage: remote-operations.sh USER@HOST [health|services|logs] [PORT]}
operation=${2:-health}
port=${3:-22}
[[ "$target" =~ ^[a-zA-Z0-9_][a-zA-Z0-9_.-]*@[a-zA-Z0-9][a-zA-Z0-9.-]*$ ]] || { echo 'Use user@hostname or user@IPv4-address.' >&2; exit 2; }
[[ "$port" =~ ^[0-9]{1,5}$ ]] && (( 10#$port >= 1 && 10#$port <= 65535 )) || { echo 'Invalid SSH port.' >&2; exit 2; }
case "$operation" in health|services|logs) ;; *) echo 'Unsupported operation.' >&2; exit 2;; esac
# Fixed operations prevent arbitrary command injection. Authenticate with SSH keys/agent.
ssh -o BatchMode=yes -o ConnectTimeout=10 -p "$port" "$target" "bash -s -- $operation" <<'REMOTE'
set -euo pipefail
case "$1" in
    health) hostname; uptime; free -h; df -h -x tmpfs -x devtmpfs ;;
    services) systemctl --no-pager --failed ;;
    logs) journalctl --no-pager -p err --since '24 hours ago' -n 30 ;;
esac
REMOTE
