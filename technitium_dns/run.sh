#!/bin/sh
# Start script for the Technitium DNS Home Assistant add-on.
set -e

OPTIONS=/data/options.json
DATA_DIR=/data/dns
API=http://127.0.0.1:5380

# Read the add-on options.
ADMIN_PASSWORD=""
ADMIN_USERNAME=""
TIMEZONE=""
SERVER_DOMAIN=""
if [ -f "$OPTIONS" ]; then
    ADMIN_PASSWORD="$(jq -r '.admin_password // empty' "$OPTIONS")"
    ADMIN_USERNAME="$(jq -r '.admin_username // empty' "$OPTIONS")"
    TIMEZONE="$(jq -r '.timezone // empty' "$OPTIONS")"
    SERVER_DOMAIN="$(jq -r '.dns_server_domain // empty' "$OPTIONS")"
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

# Server name (used on first start). The option wins if it is set.
export DNS_SERVER_DOMAIN="${SERVER_DOMAIN:-${DNS_SERVER_DOMAIN:-technitium-dns}}"

# Log in and print the session token. Prints nothing if login fails.
# Usage: api_login <user> <password>
api_login() {
    curl -fsS -m 10 -G "$API/api/user/login" \
        --data-urlencode "user=$1" \
        --data-urlencode "pass=$2" 2>/dev/null \
        | jq -r 'select(.status == "ok") | .token // empty' 2>/dev/null
}

# Rename the built-in "admin" user to the name chosen in the options.
# Safe to run on every start. If anything fails, "admin" keeps working.
setup_admin_username() {
    WANT="$(printf '%s' "$ADMIN_USERNAME" | tr 'A-Z' 'a-z')"
    if [ -z "$WANT" ] || [ "$WANT" = "admin" ]; then
        return 0
    fi

    # Wait up to 60 seconds for the web service.
    i=0
    while ! curl -fsS -m 3 -o /dev/null "$API/" 2>/dev/null; do
        i=$((i + 1))
        if [ "$i" -ge 30 ]; then
            echo "[technitium_dns] Username setup skipped: web service did not start in time."
            return 0
        fi
        sleep 2
    done

    # Use the password from the options, or the Technitium default.
    PASS="${ADMIN_PASSWORD:-admin}"

    # Already renamed on an earlier start?
    if [ -n "$(api_login "$WANT" "$PASS")" ]; then
        echo "[technitium_dns] Admin user '$WANT' is ready."
        return 0
    fi

    TOKEN="$(api_login admin "$PASS")"
    if [ -z "$TOKEN" ]; then
        echo "[technitium_dns] Username setup skipped: could not log in as 'admin'."
        echo "[technitium_dns] If you changed the password in the web page, set admin_password to match, or rename the user in the web page."
        return 0
    fi

    RESULT="$(curl -fsS -m 10 -G "$API/api/admin/users/set" \
        --data-urlencode "token=$TOKEN" \
        --data-urlencode "user=admin" \
        --data-urlencode "newUser=$WANT" 2>/dev/null \
        | jq -r '.status // "error"' 2>/dev/null || echo error)"

    if [ "$RESULT" = "ok" ]; then
        echo "[technitium_dns] Renamed user 'admin' to '$WANT'. Log in with '$WANT' from now on."
    else
        echo "[technitium_dns] Rename failed. The user 'admin' still works."
    fi
}

# Keep the server domain in step with the dns_server_domain option.
# The environment variable only works on the very first start, so this
# sets it through the API on later starts. Does nothing if the option is
# empty. If anything fails, the current name stays.
apply_server_domain() {
    [ -n "$SERVER_DOMAIN" ] || return 0

    i=0
    while ! curl -fsS -m 3 -o /dev/null "$API/" 2>/dev/null; do
        i=$((i + 1))
        if [ "$i" -ge 30 ]; then
            echo "[technitium_dns] Server domain skipped: web service did not start in time."
            return 0
        fi
        sleep 2
    done

    PASS="${ADMIN_PASSWORD:-admin}"
    WANT_USER="$(printf '%s' "$ADMIN_USERNAME" | tr 'A-Z' 'a-z')"
    TOKEN=""
    if [ -n "$WANT_USER" ]; then
        TOKEN="$(api_login "$WANT_USER" "$PASS" || true)"
    fi
    if [ -z "$TOKEN" ]; then
        TOKEN="$(api_login admin "$PASS" || true)"
    fi
    if [ -z "$TOKEN" ]; then
        echo "[technitium_dns] Server domain skipped: could not log in."
        return 0
    fi

    CURRENT="$(curl -fsS -m 10 -G "$API/api/settings/get" \
        --data-urlencode "token=$TOKEN" 2>/dev/null \
        | jq -r '.response.dnsServerDomain // empty' 2>/dev/null || true)"
    if [ "$CURRENT" = "$SERVER_DOMAIN" ]; then
        echo "[technitium_dns] Server domain is already '$SERVER_DOMAIN'."
        return 0
    fi

    RESULT="$(curl -fsS -m 10 -G "$API/api/settings/set" \
        --data-urlencode "token=$TOKEN" \
        --data-urlencode "dnsServerDomain=$SERVER_DOMAIN" 2>/dev/null \
        | jq -r '.status // "error"' 2>/dev/null || echo error)"
    if [ "$RESULT" = "ok" ]; then
        echo "[technitium_dns] Server domain set to '$SERVER_DOMAIN'."
    else
        echo "[technitium_dns] Could not set the server domain. It stays '${CURRENT:-unknown}'."
    fi
}

mkdir -p "$DATA_DIR"

echo "[technitium_dns] Starting Technitium DNS Server."
echo "[technitium_dns] Config folder: $DATA_DIR"
echo "[technitium_dns] Web page: port 5380"

cd /opt/technitium/dns
/usr/bin/dotnet DnsServerApp.dll "$DATA_DIR" &
SERVER_PID=$!

# Pass stop signals on to the server so it can shut down cleanly.
trap 'kill -TERM "$SERVER_PID" 2>/dev/null; wait "$SERVER_PID"; exit $?' TERM INT

( setup_admin_username; apply_server_domain ) &

wait "$SERVER_PID"
