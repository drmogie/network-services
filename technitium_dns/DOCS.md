# Technitium DNS add-on

Runs the official Technitium DNS Server.

## First start

1. Install and start the add-on.
2. Click **Open web UI**, or go to `http://<your-ha-ip>:5380`.
3. Log in.
   - If you set **admin_password**, use that. The user is `admin`.
   - If you left it empty, the user is `admin` and the password is `admin`.
     Change it right away.

## Options

- **admin_password**
  - Sets the first admin password.
  - It only works on the very first start.
  - After that, change the password in the Technitium web page.
  - Changing this option later does nothing.
- **timezone**
  - Example: `America/Los_Angeles`.
  - Used for log times.

## Ports

This add-on uses the host network. These ports are used:

- `53` TCP and UDP: DNS.
- `5380` TCP: web page.

Other ports open only if you turn on that feature in Technitium:

- `53443` web page over HTTPS.
- `443` DNS over HTTPS.
- `853` DNS over TLS.
- `67` DHCP.

## Use it as your network DNS

1. Give your Home Assistant computer a fixed IP address.
2. In your router, set that IP as the DNS server.
3. Or set it only on the devices you want.

## Backups

- Settings live in the add-on data folder.
- Home Assistant backups include it.

## Trouble

- **Add-on will not start, port 53 in use:**
  something else on the host uses port 53. Check the add-on log.
- **Lost the password:**
  stop the add-on, remove it and its data, then install again.
  This wipes your Technitium settings.
- **DHCP:**
  do not turn on Technitium DHCP while your router DHCP is on.
  Two DHCP servers cause problems.

## Not in this version

- Home Assistant Ingress (the sidebar item) is not set up yet.
  Use the **Open web UI** button or port 5380.
- This version has not been tested on a live Home Assistant yet.
  Please report what you see in the add-on log.
