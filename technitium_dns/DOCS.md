# Technitium DNS add-on

Runs the official Technitium DNS Server.

## First start

1. Install and start the add-on.
2. Click **Open web UI**, or go to `http://<your-ha-ip>:5380`.
3. Log in.
   - The user is `admin`, or the name you set in **admin_username**.
   - If you set **admin_password**, use that.
   - If you left it empty, the password is `admin`.
     Change it right away.

## Options

- **admin_username**
  - Default: `admin`.
  - Set a different name to rename the built-in admin user.
  - The name is made lowercase.
  - It renames the user on start. It does not add a second user.
  - It logs in with `admin_password` (or `admin` if empty) to do this.
  - If you changed the password in the web page, set `admin_password`
    to the same password. Or rename the user in the web page.
  - If the rename fails, `admin` still works. Check the add-on log.
- **admin_password**
  - Sets the first admin password.
  - It only works on the very first start.
  - After that, change the password in the Technitium web page.
  - Changing this option later does nothing.
- **dns_server_domain**
  - The name of the DNS server, for example `mogie.io`.
  - Default: empty. Empty means the add-on does not change it.
  - If you set it, the add-on sets it on every start.
    It logs in with the same rules as the admin username step.
  - If the login fails, the name stays as it is.
  - You can also change it in the Technitium web page.
- **timezone**
  - Example: `America/Los_Angeles`.
  - Used for log times.

## Ports

You choose which ports are open. Each port is a switch.

- Open the add-on, then the **Configuration** tab, then **Network**.
- Type a port number to turn a port on.
- Clear the box to turn a port off.
- You can also type a different host port, such as `5354` for DNS.

On by default:

- `5380` TCP: web page.
- `53` TCP and UDP: DNS.

Off by default (turn on what you use):

- `53443` TCP: web page over HTTPS.
- `853` TCP: DNS over TLS.
- `853` UDP: DNS over QUIC.
- `443` TCP and UDP: DNS over HTTPS.
- `80` TCP: DNS over HTTP (reverse proxy or certbot).
- `8053` TCP: DNS over HTTP (reverse proxy).
- `67` UDP: DHCP.

Notes:

- A port only works if the matching feature is also on in Technitium.
- Ports 80 and 443 may already be used by another add-on, such as a proxy.
- The sidebar (Ingress) always works. It does not need a port.
- DHCP: the add-on no longer uses the host network. Devices cannot
  reach DHCP by broadcast. It works only with a DHCP relay on your router.
- Old version note: before 2026.09.30.01 the add-on used the host network.

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

## Sidebar (Ingress)

- The add-on adds a **Technitium DNS** item to the Home Assistant sidebar.
- It shows the Technitium web page inside Home Assistant.
- Only admin users in Home Assistant see it.
- You still log in to Technitium itself.
- The old way still works: **Open web UI**, or port 5380.
- Port 5381 is used inside the add-on for this. Only Home Assistant
  can use it.
- If the sidebar page looks broken, use port 5380 and tell me what you saw.

## Not in this version
- This version has not been tested on a live Home Assistant yet.
  Please report what you see in the add-on log.
