#!/bin/bash
set -e

cd /app/Infrastructure
terraform init

exec "$@"
