# syntax=docker/dockerfile:1.7

# debian 12 (bookworm).
FROM debian:12-slim

# install dependencies.
RUN <<EOF
#!/bin/bash
set -euxo pipefail
apt-get update
apt-get install -y --no-install-recommends \
  postgresql-client-common \
  python3-psycopg2
rm -rf /var/lib/apt/lists/*
EOF

# install the binaries.
COPY --chmod=0755 main.py /usr/local/bin/main

# set the entrypoint.
ENTRYPOINT ["/usr/local/bin/main"]
