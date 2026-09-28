# Network Services - project notes

## 2026-09-28: first build

- Repo: `drmogie/network-services`. Add-on repo, no HACS.
- Name picked from "Network Services" (no `ha-` prefix, per add-on rule).
- Add-on: `technitium_dns`. Feature plan: project doc
  `claude/technitium-dns-addon-plan.md`.
- Version 1 only: basics. Wraps `technitium/dns-server:latest`.
- Start script runs `dotnet DnsServerApp.dll /data/dns`.
- Host network. Watchdog and web button on port 5380.
- No Ingress yet. Technitium's web page may not work under an Ingress
  path. Needs a live test on ha-pi4 before adding it.
- NOT tested end to end. No Docker in the cloud container. Test on ha-pi4.
- Env var names checked against Technitium's docs 2026-09-28:
  `DNS_SERVER_ADMIN_PASSWORD`, `DNS_SERVER_DOMAIN`,
  `DNS_SERVER_LOG_USING_LOCAL_TIME`. They only apply on first start
  (when no config file exists yet).
- Base image checked: aspnet 10.0 (Debian), workdir `/opt/technitium/dns`,
  entrypoint `dotnet DnsServerApp.dll`, no STOPSIGNAL (docker stop sends
  SIGTERM). Not confirmed that Technitium shuts down cleanly on SIGTERM.
  Watch for slow stops on ha-pi4.

## 2026-09-28: admin_username option (2026.09.28.02)

- Technitium always makes the first user `admin`. Env vars only set the
  password. So `run.sh` now starts the server in the background, waits for
  port 5380, logs in as `admin`, and calls
  `/api/admin/users/set?user=admin&newUser=<name>` (checked in APIDOCS.md).
- Idempotent: first tries to log in as the new name. If that works, done.
- If login or rename fails, it only logs a message. `admin` keeps working.
- Login uses `admin_password`, or `admin` if empty. If the user changed the
  password in the web page and the option does not match, it skips.
- Added curl to the image. The script now forwards SIGTERM to dotnet
  instead of using `exec`.
- Not confirmed: usernames are made lowercase by Technitium (script
  lowercases the name itself). NOT tested live. Test on ha-pi4.

## 2026-09-28: logo and icon (2026.09.28.03)

- Source: Technitium's own public repo,
  `DnsServerCore/www/img/logo.png` (48x48 PNG). technitium.com is blocked
  from the cloud container and the PC shell, so no larger version.
- `icon.png` = 128x128 (upscaled from 48x48, a bit soft).
- `logo.png` = 250x100, logo centered on transparent background.
- If a bigger official logo is found, replace both files and bump the version.
- Release order lesson: commit and push FIRST, then create the release.
  On .02 a stuck git lock stopped the commit and the release was made
  anyway, so tag .02 points at the old commit.
