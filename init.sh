#!/bin/ash
set -euxo pipefail

test-postgres wait

terraform apply -auto-approve

psql \
  --no-password \
  --echo-all \
  --variable ON_ERROR_STOP=1 \
  quotes \
  <quotes-schema.sql

psql \
  --no-password \
  --echo-all \
  --variable ON_ERROR_STOP=1 \
  quotes \
  <quotes-data.sql
