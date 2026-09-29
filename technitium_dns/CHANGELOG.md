# Changelog

## 2026.09.28.05

- New: Home Assistant Ingress. A Technitium DNS item in the sidebar.
- Uses a small nginx proxy on port 5381. Only Home Assistant can connect.
- The old web page on port 5380 still works.

## 2026.09.28.04

- New option: dns_server_domain.
- The name is set on first start and on every later start.
- Empty means the add-on leaves the name alone.

## 2026.09.28.03

- Added the Technitium logo and icon.

## 2026.09.28.02

- New option: admin_username.
- On start, the built-in admin user is renamed to that name.
- If the rename fails, the user "admin" still works.

## 2026.09.28.01

- First release.
- Runs the official Technitium DNS Server in a Home Assistant add-on.
- Uses host network, so DNS on port 53 works right.
- Settings are kept in the add-on data folder, so updates keep them.
- Options: admin password (first start only) and time zone.
- Included in Home Assistant backups.
- Web page opens from the "Open web UI" button (port 5380).
