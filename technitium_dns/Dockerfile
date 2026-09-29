# Technitium DNS Home Assistant add-on.
# Wraps the official technitium/dns-server image. Technitium itself is
# not modified. This add-on only adds a small start script.
ARG TECHNITIUM_TAG=latest
FROM technitium/dns-server:${TECHNITIUM_TAG}

USER root

# jq reads the add-on options. curl talks to the Technitium API.
# tzdata makes the time zone option work.
# nginx is the small proxy for Home Assistant Ingress.
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl jq tzdata nginx-light \
    && rm -rf /var/lib/apt/lists/*

COPY run.sh /usr/local/bin/ha-run.sh
COPY ingress.conf /etc/technitium-ingress.conf
RUN chmod a+x /usr/local/bin/ha-run.sh

ENTRYPOINT ["/usr/local/bin/ha-run.sh"]
