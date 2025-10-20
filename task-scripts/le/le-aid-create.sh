#!/bin/bash
# le-aid-create.sh - Create LE AID using SignifyTS and KERIA
# This script creates the Legal Entity AID using the SignifyTS client

set -e

echo "Creating LE AID using SignifyTS and KERIA"

# gets LE_SALT
source ./task-scripts/workshop-env-vars.sh

# Create LE Agent and AID
docker compose exec tsx-shell \
  /vlei/tsx-script-runner.sh le/le-aid-create.ts \
    'docker' \
    "${LE_SALT}" \
    "/task-data"

# Get the prefix
LE_PREFIX=$(cat ./task-data/le-aid.txt | tr -d " \t\n\r")
echo "   Prefix: ${LE_PREFIX}"

LE_OOBI=$(cat ./task-data/le-info.json | jq -r .oobi)
echo "   OOBI: ${LE_OOBI}"

