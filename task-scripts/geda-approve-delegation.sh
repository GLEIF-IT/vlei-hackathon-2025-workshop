#!/usr/bin/env bash
# geda-approve-delegation.sh - Approve delegation from GEDA to QVI AID

set -3
echo "Approving delegation from GEDA to QVI AID"
source ./task-scripts/workshop-env-vars.sh
docker compose exec vlei-shell \
  kli delegate confirm --name geda --alias geda --passcode "${GEDA_PASSCODE}"
