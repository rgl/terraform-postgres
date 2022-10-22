#!/bin/ash
set -euxo pipefail

test-postgres wait

terraform plan -out=tfplan

terraform apply tfplan

psql \
  --no-password \
  --variable ON_ERROR_STOP=1 \
  quotes \
  <quotes.sql
