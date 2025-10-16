#!/usr/bin/env bash
# qvi-get-oobi.sh - Get the OOBI for the QVI AID

set -e
echo "Getting OOBI for QVI AID"
source ./task-scripts/workshop-env-vars.sh
docker compose exec tsx-shell \
  /vlei/tsx-script-runner.sh qvi-get-oobi.ts 'docker' "${QVI_SALT}"