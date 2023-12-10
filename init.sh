#!/bin/ash
set -euxo pipefail

test-postgres wait

terraform apply -auto-approve

psql \
  --no-password \
  --variable ON_ERROR_STOP=1 \
  quotes \
  <quotes.sql
