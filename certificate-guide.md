# Certificate update examples

These scripts install **already issued certificates**. They do not obtain certificates, renew a CA-issued certificate, disable TLS validation, or remove old trust anchors. All default to preview. Use a lab first, then apply within an approved maintenance window.

Run Windows examples from `windows-powershell` and Linux examples from `linux-networking-git/scripts`.

## Windows PowerShell

Use Windows PowerShell 5.1 (`powershell.exe`) with the PKI module. IIS binding updates also require WebAdministration/IIS Management Scripts and Tools. LocalMachine changes and IIS updates require an elevated session. PowerShell 7 compatibility depends on the installed Windows modules; Windows PowerShell 5.1 is the intended host.

### Install an updated CA certificate

Obtain the public `.cer` certificate and its SHA-256 certificate fingerprint through independent trusted channels. Supply the 64 hexadecimal digits without colons. This fingerprint hashes the DER certificate bytes, not the PEM file's text bytes.

```powershell
./Update-TrustedCertificate.ps1 -CertificatePath C:\certs\company-ca.cer -ExpectedSha256 VERIFIED_64_HEX_DIGITS
./Update-TrustedCertificate.ps1 -CertificatePath C:\certs\company-root.cer -ExpectedSha256 VERIFIED_64_HEX_DIGITS -Scope LocalMachine -StoreName Root -Apply -WhatIf
# Remove -WhatIf to install after checking the preview.
```

`CA` (intermediate certification authorities) and CurrentUser are defaults. Select `Root` only for an intentionally trusted root; importing into Root grants broad trust to certificates issued by that CA. Dates, CA constraints, and fingerprint are checked. Identical installed certificates are left alone, and older CAs are retained. Browsers, Java, containers, and apps with private trust stores may need separate configuration. A fingerprint placeholder is intentionally invalid until replaced.

### Import a replacement server PFX; optionally update IIS

```powershell
$password = Read-Host 'PFX password' -AsSecureString
./Update-TlsCertificate.ps1 -PfxPath C:\certs\replacement.pfx -Password $password
./Update-TlsCertificate.ps1 -PfxPath C:\certs\replacement.pfx -Password $password -Apply -WhatIf
./Update-TlsCertificate.ps1 -PfxPath C:\certs\replacement.pfx -Password $password -SiteName 'My App' -BindingInformation '*:443:app.example.com' -Apply -WhatIf
```

The script requires one leaf certificate, an explicit Server Authentication EKU, at least seven days remaining, and a valid chain with Windows revocation checks. The PFX should include intermediate certificates. Preview displays certificate identity/DNS names; **verify SAN coverage of the binding hostname yourself** before applying. No hostname match is automatically enforced by this PowerShell example. CRL/OCSP network access may be needed for chain validation.

With `-Apply`, import goes to `LocalMachine\My`, without marking private keys exportable. Without SiteName, importing alone does not configure an application to use the certificate. For IIS, specify an exact existing HTTPS binding; Central Certificate Store bindings are rejected. Existing certificates remain for rollback, and a timestamped binding record is written under `certificate-backups`. On a binding-update exception, the script attempts to restore the previous binding. If import succeeds but later steps fail, the imported certificate may remain; it is not automatically deleted.

IIS/HTTP.sys bindings can be shared by IP/port or SNI hostname across sites. Review sharing before updating. Validate the endpoint afterward. If manual rollback is needed, read the JSON record and call `AddSslCertificate(OldThumbprint, OldStore)` on that same binding. Do not delete the old certificate until verification is complete. No IIS restart is performed.

## Linux Bash

Dependencies: Bash, OpenSSL 1.1.1+/3.x, GNU coreutils; the nginx updater also uses `flock`, nginx, and systemd. Use root/sudo only for `--apply`.

### Install an updated root CA (Ubuntu/Debian)

```bash
bash update-trusted-certificate.sh ./company-root.crt VERIFIED_64_HEX_DIGITS
sudo bash update-trusted-certificate.sh ./company-root.crt VERIFIED_64_HEX_DIGITS --apply
```

Provide one PEM public CA certificate and an independently verified SHA-256 fingerprint. The script checks the fingerprint, CA constraint, validity/signature and seven-day minimum lifetime. It writes a fingerprint-named `.crt` in `/usr/local/share/ca-certificates`, then runs `update-ca-certificates`. If refresh fails, it removes the newly added file and attempts a refresh again. Existing roots remain. This CA script targets Debian/Ubuntu; RHEL/Fedora use a different trust-store update mechanism.

### Replace an nginx server certificate/key

```bash
bash update-tls-certificate.sh ./new-fullchain.pem ./new-key.pem /etc/nginx/tls/app.crt /etc/nginx/tls/app.key app.example.com
# For an internal CA, add --ca-file ./company-root.pem from a trusted source.
sudo bash update-tls-certificate.sh ./new-fullchain.pem ./new-key.pem /etc/nginx/tls/app.crt /etc/nginx/tls/app.key app.example.com --apply
```

Use leaf-first fullchain PEM and the matching **unencrypted** key staged outside the live paths. The script checks expiration (seven days minimum), current validity/chain, server purpose, DNS hostname, and key match. OpenSSL chain verification here does not perform online OCSP/CRL revocation checks. The target files must already exist and be regular files, not symlinks. It does not edit nginx configuration. Use dedicated files referenced by your intended virtual host; replacing shared files affects every host using them.

Apply checks nginx configuration, locks concurrent runs of this script, backs up the pair under a root-only `/var/backups/devops-tls-*` directory, writes replacements, checks configuration again, and reloads nginx. Failure after replacement triggers a best-effort restore and reload. The private key gets mode 0600; this example assumes conventional nginx with a root master process. Do not use it for a rootless service that needs group-readable keys without adapting permissions.

Two-file replacement is not atomic: pause other deployers/reload jobs during the change. A process kill, power loss, or failed rollback may require manual recovery from the displayed backup. Preserve backups securely because they contain private keys. Check the live HTTPS endpoint after any update; a successful reload alone is not an end-to-end test.

For certbot-managed symlinks, use the existing certbot renewal/deploy-hook mechanism instead of overwriting managed files. These scripts intentionally reject symlink targets.

## Reading and sources

- User-supplied reading: [15 PowerShell scripts for beginner DevOps engineers](https://medium.com/@osomudeyazudonu/15-powershell-scripts-every-beginner-devops-engineer-can-use-to-automate-workflows-09811603ff65). Only the introduction was accessible; the scripts here are original examples, not copied from the member-only article.
- [Microsoft Import-PfxCertificate](https://learn.microsoft.com/en-us/powershell/module/pki/import-pfxcertificate)
- [Ubuntu: install a root CA](https://ubuntu.com/server/docs/how-to/security/install-a-root-ca-certificate-in-the-trust-store/)
- [OpenSSL certificate verification](https://docs.openssl.org/3.0/man1/openssl-verification-options/)

No live certificate stores, production keys, nginx services, or IIS bindings were changed while adding these examples.
