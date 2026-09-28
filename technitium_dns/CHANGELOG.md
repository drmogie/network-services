# Changelog

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
