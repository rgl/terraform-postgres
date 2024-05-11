#!/bin/bash
set -euo pipefail

echo "destroying the existing environment..."
docker compose down --volumes --remove-orphans
rm -f terraform.{log,tfstate,tfstate.backup} tfplan
