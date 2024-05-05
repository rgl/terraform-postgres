#!/bin/ash
set -euxo pipefail

wait-postgres

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
  quotes <<'EOF'
-- list roles.
\dg
-- list databases.
\l
-- list relations.
\d
-- list relations access privileges.
\dp
-- list default access privileges.
\ddp
EOF

export PGUSER="$QUOTES_WRITER_USERNAME"
export PGPASSWORD="$QUOTES_WRITER_PASSWORD"
psql \
  --no-password \
  --echo-all \
  --variable ON_ERROR_STOP=1 \
  quotes \
  <quotes-data.sql
