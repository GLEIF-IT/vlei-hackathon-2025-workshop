#!/bin/bash
# create-geda-aid.sh - Create GEDA AID using KERIpy KLI through Docker
# This script creates the GLEIF External Delegated AID using the KERIpy KLI tool
# It should equal EAQRpV-M8AAN-_OkHmUb8-ulTEyz9foI_BM1ckhrDetr

set -e

echo "Creating GEDA AID using KERIpy KLI"

source ./task-scripts/workshop-env-vars.sh
# gets GEDA_NAME, GEDA_SALT, GEDA_PASSCODE, GEDA_PREFIX


# Initialize keystore
echo "Initializing keystore for GEDA..."
docker compose exec vlei-shell \
  kli init \
    --name "${GEDA_NAME}" \
    --salt "${GEDA_SALT}" \
    --passcode "${GEDA_PASSCODE}" \
    --config-dir "/vlei/config" \
    --config-file "geda.json"

# Create GEDA AID
echo "Creating GEDA AID ${GEDA_PREFIX}..."
docker compose exec vlei-shell \
  kli incept \
    --name "${GEDA_NAME}" \
    --alias "${GEDA_NAME}" \
    --passcode "${GEDA_PASSCODE}" \
    --file "/vlei/config/geda-incept.json"

# Get the prefix
ACT_GEDA_PREFIX=$(docker compose exec vlei-shell \
  kli status --name "${GEDA_NAME}" --alias "${GEDA_NAME}" --passcode "${GEDA_PASSCODE}" \
  | awk '/Identifier:/ {print $2}' | tr -d " \t\n\r")

if [[ "${ACT_GEDA_PREFIX}" != "${GEDA_PREFIX}" ]]; then
  echo "Error: GEDA AID prefix mismatch!"
  echo "   Expected: ${GEDA_PREFIX}"
  echo "   Actual:   ${ACT_GEDA_PREFIX}"
  exit 1
fi

# Generate OOBI
GEDA_OOBI=$(docker compose exec vlei-shell \
  kli oobi generate \
  --name "${GEDA_NAME}" \
  --passcode "${GEDA_PASSCODE}" \
  --alias "${GEDA_NAME}" \
  --role witness)

echo "GEDA AID created successfully!"
echo "   Prefix: ${ACT_GEDA_PREFIX}"
echo "   OOBI: ${GEDA_OOBI}"

# Save to file for other scripts
cat > ./task-data/geda-info.json << EOF
{
  "prefix": "${ACT_GEDA_PREFIX}",
  "oobi": "${GEDA_OOBI}"
}
EOF

echo "GEDA info saved to ./task-data/geda-info.json"

