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
