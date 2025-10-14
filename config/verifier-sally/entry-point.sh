#!/bin/bash
# entry-point.sh - Entry point script for Sally verifier
# This script initializes Sally with the correct configuration
# The below configuration should cause inception of an AID with the prefix
#   EMrjKv0T43sslqFfhlEHC9v3t9UoxHWrGznQ1EveRXUO

set -e

EXPECTED_AID=EMrjKv0T43sslqFfhlEHC9v3t9UoxHWrGznQ1EveRXUO
GEDA_PRE="${GEDA_PRE:-ED1e8pD24aqd0dCZTQHaGpfcluPFD2ajGIY3ARgE5Yvr}"
SALLY_KS_NAME="${SALLY_KS_NAME:-sally}"
SALLY_SALT="${SALLY_SALT:-0ABVqAtad0CBkhDhCEPd514T}"
SALLY_PASSCODE="${SALLY_PASSCODE:-4TBjjhmKu9oeDp49J7Xdy}"
SALLY_PORT="${SALLY_PORT:-9723}"
WEBHOOK_URL="${WEBHOOK_URL:-http://resource:9923}"

if [ -z "${GEDA_PRE}" ]; then
  echo "GEDA_PRE auth AID is not set. Exiting."
  exit 1
else
  echo "GEDA_PRE auth AID is set to: ${GEDA_PRE}"
fi

echo "Starting Sally verifier..."

# Set environment variables
echo "Configuration:"
echo "   EXPECTED AID: ${EXPECTED_AID}"
echo "   SALLY KEYSTORE NAME: ${SALLY_KS_NAME}"
echo "   GEDA_PRE: ${GEDA_PRE}"
echo "   SALLY_PORT: ${SALLY_PORT}"
echo "   WEBHOOK_URL: ${WEBHOOK_URL}"

export DEBUG_KLI=true

# Set up keystore and AID for Sally verifier
# This manually calls init and incept in order to have a deterministic AID.

# Create Habery / keystore
kli init \
    --name "${SALLY_KS_NAME}" \
    --salt "${SALLY_SALT}" \
    --passcode "${SALLY_PASSCODE}" \
    --config-dir /sally/conf \
    --config-file "${SALLY_KS_NAME}.json"

# Create sally identifier
kli incept \
    --name "${SALLY_KS_NAME}" \
    --alias "${SALLY_KS_NAME}" \
    --passcode "${SALLY_PASSCODE}" \
    --config /sally/conf \
    --file "/sally/conf/incept-no-wits.json"

ACTUAL_PASSCODE=$(kli aid --name "${SALLY_KS_NAME}" --alias "${SALLY_KS_NAME}" --passcode "${SALLY_PASSCODE}")

if [[ "${ACTUAL_PASSCODE}" != "${EXPECTED_AID}" ]]; then
  echo "Sally AID prefix mismatch!"
  echo "   Expected: ${EXPECTED_AID}"
  echo "   Actual:   ${ACTUAL_PASSCODE}"
  exit 1
else
  echo "Sally AID prefix matches expected value: ${EXPECTED_AID}"
fi

# Start Sally in direct mode
sally server start \
  --direct \
  --name "${SALLY_KS_NAME}" \
  --alias "${SALLY_KS_NAME}" \
  --passcode "${SALLY_PASSCODE}" \
  --http "${SALLY_PORT}" \
  --config-dir /sally/conf \
  --config-file verifier.json \
  --web-hook "${WEBHOOK_URL}" \
  --auth "${GEDA_PRE}" \
  --loglevel INFO
