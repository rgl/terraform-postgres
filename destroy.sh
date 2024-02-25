#!/bin/bash
set -euo pipefail

echo "destroying the existing environment..."
docker compose down --volumes --remove-orphans
docker compose down --volumes --remove-orphans destroy
rm -f terraform.{log,tfstate,tfstate.backup} tfplan
