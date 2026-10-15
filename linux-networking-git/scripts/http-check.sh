#!/usr/bin/env bash
# Usage: bash http-check.sh URL [GET|HEAD|POST|PUT|PATCH|DELETE] [JSON_FILE]
set -euo pipefail
url=${1:?Usage: http-check.sh URL [METHOD] [JSON_FILE]}
method=${2:-GET}
case "$url" in http://*|https://*) ;; *) echo 'Use an HTTP or HTTPS URL.' >&2; exit 2;; esac
case "$method" in GET|HEAD|POST|PUT|PATCH|DELETE) ;; *) echo 'Unsupported method.' >&2; exit 2;; esac
command -v curl >/dev/null || { echo 'Install curl first.' >&2; exit 2; }
args=(--silent --show-error --connect-timeout 5 --max-time 30 --include)
if [[ "$method" == HEAD ]]; then args+=(--head); else args+=(--request "$method"); fi
if [[ $# -ge 3 ]]; then
    [[ -r "$3" ]] || { echo 'JSON file is not readable.' >&2; exit 2; }
    args+=(--header 'Content-Type: application/json' --data-binary "@$3")
fi
# Keep error response bodies visible while returning a failure exit code.
tmp=$(mktemp)
trap 'rm -f -- "$tmp"' EXIT
status=$(curl "${args[@]}" --output "$tmp" --write-out '%{http_code}' "$url") || { cat "$tmp"; exit 1; }
cat "$tmp"
printf '\nHTTP status: %s\n' "$status"
[[ "$status" -lt 400 ]]
