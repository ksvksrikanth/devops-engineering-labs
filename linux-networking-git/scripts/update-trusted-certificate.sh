#!/usr/bin/env bash
# Ubuntu/Debian: install an independently verified public root CA. Preview by default.
# Usage: bash update-trusted-certificate.sh CA.crt EXPECTED_SHA256 [--apply]
set -euo pipefail
[[ $# -ge 2 && $# -le 3 ]] || { echo 'Usage: CA.crt EXPECTED_SHA256 [--apply]' >&2; exit 2; }
cert=$(realpath -- "$1")
expected=${2^^}
[[ "$expected" =~ ^[A-F0-9]{64}$ ]] || { echo 'Expected SHA256 must contain 64 hexadecimal characters.' >&2; exit 2; }
[[ $# -lt 3 || "$3" == --apply ]] || { echo 'Unknown option.' >&2; exit 2; }
[[ $(grep -c '^-----BEGIN CERTIFICATE-----' "$cert") == 1 ]] || { echo 'Provide one PEM CA certificate.' >&2; exit 2; }
if grep -q 'PRIVATE KEY' "$cert"; then echo 'Public certificate only; private keys are not allowed.' >&2; exit 2; fi
actual=$(openssl x509 -in "$cert" -noout -fingerprint -sha256 | cut -d= -f2 | tr -d ':')
[[ "$actual" == "$expected" ]] || { echo 'Fingerprint mismatch.' >&2; exit 1; }
openssl x509 -in "$cert" -noout -ext basicConstraints | grep -q 'CA:TRUE' || { echo 'Not a CA certificate.' >&2; exit 1; }
openssl x509 -in "$cert" -noout -checkend 604800
openssl verify -check_ss_sig -CAfile "$cert" "$cert"
openssl x509 -in "$cert" -noout -subject -issuer -dates -fingerprint -sha256
target="/usr/local/share/ca-certificates/devops-${actual,,}.crt"
if [[ "${3:-}" != --apply ]]; then printf 'Preview: install to %s and run update-ca-certificates\n' "$target"; exit 0; fi
[[ $EUID == 0 ]] || { echo 'Run with sudo to apply.' >&2; exit 2; }
command -v update-ca-certificates >/dev/null || { echo 'This script requires Debian/Ubuntu update-ca-certificates.' >&2; exit 2; }
[[ ! -L "$target" ]] || { echo 'Destination must not be a symlink.' >&2; exit 2; }
if [[ -e "$target" ]]; then
    existing=$(openssl x509 -in "$target" -noout -fingerprint -sha256 | cut -d= -f2 | tr -d ':')
    [[ "$existing" == "$actual" ]] || { echo 'Existing destination differs.' >&2; exit 2; }
    update-ca-certificates
    exit
fi
install -o root -g root -m 0644 -- "$cert" "$target"
if ! update-ca-certificates; then
    rm -f -- "$target"
    update-ca-certificates || true
    echo 'Trust-store refresh failed; new certificate file removed.' >&2
    exit 1
fi
echo 'CA installed. Existing CA certificates were retained.'
