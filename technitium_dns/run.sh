#!/bin/sh
# Start script for the Technitium DNS Home Assistant add-on.
set -e

OPTIONS=/data/options.json
DATA_DIR=/data/dns

# Read the add-on options.
ADMIN_PASSWORD=""
TIMEZONE=""
if [ -f "$OPTIONS" ]; then
    ADMIN_PASSWORD="$(jq -r '.admin_password // empty' "$OPTIONS")"
    TIMEZONE="$(jq -r '.timezone // empty' "$OPTIONS")"
fi

# Time zone.
if [ -n "$TIMEZONE" ]; then
    export TZ="$TIMEZONE"
    export DNS_SERVER_LOG_USING_LOCAL_TIME=true
fi

# The admin password is only used the very first time the server starts.
# After that it is stored inside the Technitium config, and you change it
# in the Technitium web page.
if [ -n "$ADMIN_PASSWORD" ]; then
    export DNS_SERVER_ADMIN_PASSWORD="$ADMIN_PASSWORD"
fi

# Set this so the server has a friendly name on first start.
export DNS_SERVER_DOMAIN="${DNS_SERVER_DOMAIN:-technitium-dns}"

mkdir -p "$DATA_DIR"

echo "[technitium_dns] Starting Technitium DNS Server."
echo "[technitium_dns] Config folder: $DATA_DIR"
echo "[technitium_dns] Web page: port 5380"

cd /opt/technitium/dns
exec /usr/bin/dotnet DnsServerApp.dll "$DATA_DIR"
