#!/usr/bin/env bash
# Usage: bash manage-service.sh SERVICE [status|start|stop|restart] [--dry-run]
set -euo pipefail
service=${1:?Usage: manage-service.sh SERVICE [status|start|stop|restart] [--dry-run]}
action=${2:-status}
[[ "$service" =~ ^[a-zA-Z0-9_@.-]+$ && "$service" != -* ]] || { echo 'Use an exact service/unit name.' >&2; exit 2; }
case "$action" in status|start|stop|restart) ;; *) echo 'Unsupported action.' >&2; exit 2;; esac
[[ $# -le 3 && ( $# -lt 3 || "$3" == --dry-run ) ]] || { echo 'Unknown argument.' >&2; exit 2; }
command -v systemctl >/dev/null || { echo 'This script requires systemd/systemctl.' >&2; exit 2; }
if [[ "${3:-}" == --dry-run ]]; then printf 'Would run: systemctl %s %s\n' "$action" "$service"; exit 0; fi
if [[ "$action" == status ]]; then systemctl --no-pager status "$service"; exit; fi
sudo systemctl "$action" "$service"
# A successful stop should return success even though the service is inactive.
systemctl --no-pager show "$service" --property=Id,ActiveState,SubState
