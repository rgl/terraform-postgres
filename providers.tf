# see https://github.com/hashicorp/terraform
terraform {
  required_version = "1.8.3"
  required_providers {
    # see https://github.com/cyrilgdn/terraform-provider-postgresql
    # see https://registry.terraform.io/providers/cyrilgdn/postgresql
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.22.0"
    }
  }
  backend "local" {
    path = ".tfstate/terraform.tfstate"
  }
}

provider "postgresql" {
  host      = var.postgres_host
  port      = var.postgres_port
  sslmode   = "disable"
  database  = "postgres"
  username  = var.postgres_username
  password  = var.postgres_password
  superuser = false
}

variable "postgres_host" {
  type    = string
  default = "postgres"
}

variable "postgres_port" {
  type    = number
  default = 5432
}

variable "postgres_username" {
  type    = string
  default = "postgres"
}

variable "postgres_password" {
  type      = string
  default   = "postgres"
  sensitive = true
}
