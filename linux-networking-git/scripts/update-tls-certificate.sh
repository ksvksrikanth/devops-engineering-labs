#!/usr/bin/env bash
# Update an existing nginx certificate/key pair on Linux. Preview by default.
# Usage: NEW_FULLCHAIN NEW_KEY EXISTING_CERT EXISTING_KEY DNS_NAME [--ca-file CA.pem] [--apply]
set -euo pipefail
[[ $# -ge 5 ]] || { echo 'Usage: NEW_FULLCHAIN NEW_KEY EXISTING_CERT EXISTING_KEY DNS_NAME [--ca-file CA.pem] [--apply]' >&2; exit 2; }
new_cert=$(realpath -- "$1"); new_key=$(realpath -- "$2")
old_cert=$3; old_key=$4; dns=$5; shift 5
apply=false; ca_args=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        --apply) apply=true; shift ;;
        --ca-file) [[ $# -ge 2 ]] || exit 2; ca_args=(-CAfile "$(realpath -- "$2")"); shift 2 ;;
        *) echo "Unknown option: $1" >&2; exit 2 ;;
    esac
done
[[ "$dns" =~ ^[a-zA-Z0-9][a-zA-Z0-9.-]*$ ]] || { echo 'Provide a DNS hostname.' >&2; exit 2; }
# Do not overwrite certbot-managed symlinks; use certbot renew for those deployments.
for path in "$old_cert" "$old_key"; do
    [[ -f "$path" && ! -L "$path" ]] || { echo 'Existing targets must be regular files, not symlinks.' >&2; exit 2; }
done
old_cert=$(realpath -- "$old_cert"); old_key=$(realpath -- "$old_key")
[[ "$old_cert" != "$old_key" && "$new_cert" != "$old_cert" && "$new_key" != "$old_key" ]] || { echo 'Use distinct staging and destination files.' >&2; exit 2; }
openssl x509 -in "$new_cert" -noout -checkend 604800
openssl verify "${ca_args[@]}" -purpose sslserver -verify_hostname "$dns" -untrusted "$new_cert" "$new_cert"
cert_pub=$(openssl x509 -in "$new_cert" -pubkey -noout | openssl pkey -pubin -outform DER | openssl dgst -sha256)
key_pub=$(openssl pkey -in "$new_key" -passin pass: -pubout -outform DER | openssl dgst -sha256)
[[ "$cert_pub" == "$key_pub" ]] || { echo 'Certificate and private key do not match.' >&2; exit 1; }
openssl x509 -in "$new_cert" -noout -subject -issuer -dates
if ! $apply; then printf 'Preview: replace %s and %s; test nginx configuration and reload nginx.\n' "$old_cert" "$old_key"; exit 0; fi
[[ $EUID == 0 ]] || { echo 'Run with sudo to apply.' >&2; exit 2; }
command -v nginx >/dev/null; command -v systemctl >/dev/null
nginx -t
# Serialize this script's updates. Pause other deployment tools during replacement.
exec 9>/run/lock/devops-tls-update.lock
flock -n 9 || { echo 'Another TLS update is in progress.' >&2; exit 2; }
backup=$(mktemp -d /var/backups/devops-tls-XXXXXXXX)
chmod 700 "$backup"
cp -p -- "$old_cert" "$backup/cert.pem"
cp -p -- "$old_key" "$backup/key.pem"
printf '%s\n%s\n' "$old_cert" "$old_key" > "$backup/targets.txt"
chmod 600 "$backup/targets.txt"
rollback() {
    status=$?
    trap - EXIT
    if [[ $status -ne 0 ]]; then
        echo "Update failed; restoring from $backup" >&2
        cp -p -- "$backup/cert.pem" "$old_cert" || echo 'Certificate restore failed.' >&2
        cp -p -- "$backup/key.pem" "$old_key" || echo 'Key restore failed.' >&2
        nginx -t && systemctl reload nginx || echo 'Rollback reload failed; inspect nginx manually.' >&2
    fi
    exit "$status"
}
trap rollback EXIT
# Write through existing files to retain their ownership and mode.
cat -- "$new_cert" > "$old_cert"
cat -- "$new_key" > "$old_key"
chmod 600 "$old_key"
nginx -t
systemctl reload nginx
trap - EXIT
printf 'Updated nginx TLS files. Backup: %s\nVerify the live HTTPS endpoint.\n' "$backup"
