# Technitium DNS Home Assistant add-on.
# Wraps the official technitium/dns-server image. Technitium itself is
# not modified. This add-on only adds a small start script.
ARG TECHNITIUM_TAG=latest
FROM technitium/dns-server:${TECHNITIUM_TAG}

USER root

# jq reads the add-on options. tzdata makes the time zone option work.
RUN apt-get update \
    && apt-get install -y --no-install-recommends jq tzdata \
    && rm -rf /var/lib/apt/lists/*

COPY run.sh /usr/local/bin/ha-run.sh
RUN chmod a+x /usr/local/bin/ha-run.sh

ENTRYPOINT ["/usr/local/bin/ha-run.sh"]
