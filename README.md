# About

[![Build status](https://github.com/rgl/terraform-postgres/workflows/build/badge.svg)](https://github.com/rgl/terraform-postgres/actions?query=workflow%3Abuild)

This initializes a PostgreSQL database using the [cyrilgdn/terraform-provider-postgresql](https://github.com/cyrilgdn/terraform-provider-postgresql) Terraform provider.

This will:

* Create a test PostgreSQL instance inside a docker container using docker compose.
* Create the `alice` and `bob` users.
* Create the `quotes` database.
  * Create the `quotes_reader` and `quotes_writer` roles.
  * Grant the `alice` user the `quotes_reader` role.
  * Grant the `bob` user the `quotes_writer` role.
* Create the `quotes` database schema as the `postgres` user using `psql`.
* Populate the `quotes` database data as the `bob` user using `psql`.
* Read a random quote from the `quotes` database as the `alice` user using a python application.

# Usage

Install docker compose.

Use as:

```bash
./test.sh
```

When anything goes wrong, you can execute psql commands as:

```bash
docker compose exec -T postgres psql -U postgres quotes <<'EOF'
\dt+ public.*
\d+ public.*
select * from quote;
EOF
docker compose exec -T postgres pg_dump -U postgres -s quotes
```
