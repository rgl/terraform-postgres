# see https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/postgresql_database
resource "postgresql_database" "quotes" {
  name     = "quotes"
  template = "template1"
}

# see https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/postgresql_grant
# NB this is equivalent to:
#       revoke all privileges on database quotes from public;
resource "postgresql_grant" "quotes_public" {
  database    = postgresql_database.quotes.name
  object_type = "database"
  role        = "public"
  privileges  = []
}

# see https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/postgresql_role
resource "postgresql_role" "quotes_reader" {
  name = "quotes_reader"
}

# see https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/postgresql_grant
# NB this is equivalent to:
#       grant connect on database quotes to quotes_reader;
resource "postgresql_grant" "quotes_reader_database" {
  database    = postgresql_database.quotes.name
  object_type = "database"
  role        = postgresql_role.quotes_reader.name
  privileges  = ["CONNECT"]
}

# see https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/postgresql_grant
# NB this is equivalent to:
#       \connect quotes;
#       grant usage on schema public to "quotes_reader";
resource "postgresql_grant" "quotes_reader_schema" {
  database    = postgresql_database.quotes.name
  object_type = "schema"
  schema      = "public"
  role        = postgresql_role.quotes_reader.name
  privileges  = ["USAGE"]
}

# see https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/postgresql_default_privileges
# NB this is equivalent to:
#       \connect quotes;
#       alter default privileges for role "postgres" in schema public grant select on tables to "quotes_reader";
resource "postgresql_default_privileges" "quotes_reader_tables" {
  database    = postgresql_database.quotes.name
  object_type = "table"
  schema      = "public"
  role        = postgresql_role.quotes_reader.name
  owner       = postgresql_database.quotes.owner
  privileges  = ["SELECT"]
}

# see https://registry.terraform.io/providers/cyrilgdn/postgresql/latest/docs/resources/postgresql_role
resource "postgresql_role" "alice" {
  name     = "alice"
  password = "alice"
  login    = true
  roles = [
    postgresql_role.quotes_reader.name
  ]
}
