#!/usr/bin/env bash
# qvi-finish-delegation.sh - Finish delegation from GEDA to QVI AID

set -env

echo "Finishing delegation from GEDA to QVI AID"
docker compose exec tsx-shell \
  /vlei/tsx-script-runner.sh qvi-finish-delegation.ts 'docker' "${QVI_SALT}" "/task-data"