#!/usr/bin/env bash
# Usage: bash system-health.sh
set -euo pipefail
printf '\nHost and uptime\n'
hostname
uptime
printf '\nMemory\n'
free -h
printf '\nDisk space\n'
df -h -x tmpfs -x devtmpfs
printf '\nTop processes by CPU (sample reported by ps)\n'
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | sed -n '1,11p'
printf '\nListening TCP ports\n'
ss -ltn
