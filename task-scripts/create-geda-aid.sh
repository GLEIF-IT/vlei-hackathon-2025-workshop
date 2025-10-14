#!/bin/bash
# create-geda-aid.sh - Create GEDA AID using KERIpy KLI through Docker
# This script creates the GLEIF External Delegated AID using the KERIpy KLI tool
# It should equal EAQRpV-M8AAN-_OkHmUb8-ulTEyz9foI_BM1ckhrDetr

set -e

echo "Creating GEDA AID using KERIpy KLI"

# Fixed configuration for consistent root of trust
GEDA_NAME="geda"
GEDA_SALT="0AD45YWdzWSwNREuAoitH_CC"
GEDA_PASSCODE="VVmRdBTe5YCyLMmYRqTAi"

# Initialize keystore
echo "Initializing keystore for GEDA..."
docker compose exec vlei-shell \
  kli init \
    --name "${GEDA_NAME}" \
    --salt "${GEDA_SALT}" \
    --passcode "${GEDA_PASSCODE}" \
    --config-dir "/vlei/config" \
    --config-file "geda.json"

# Create AID
echo "Creating GEDA AID EAQRpV-M8AAN-_OkHmUb8-ulTEyz9foI_BM1ckhrDetr..."
docker compose exec vlei-shell \
  kli incept \
    --name "${GEDA_NAME}" \
    --alias "${GEDA_NAME}" \
    --passcode "${GEDA_PASSCODE}" \
    --file "/vlei/config/geda-incept.json"

# Get the prefix
GEDA_PREFIX=$(docker compose exec vlei-shell \
  kli status --name "${GEDA_NAME}" --alias "${GEDA_NAME}" --passcode "${GEDA_PASSCODE}" \
  | awk '/Identifier:/ {print $2}' | tr -d " \t\n\r")

if [[ "${GEDA_PREFIX}" != "EAQRpV-M8AAN-_OkHmUb8-ulTEyz9foI_BM1ckhrDetr" ]]; then
  echo "Error: GEDA AID prefix mismatch!"
  echo "   Expected: EAQRpV-M8AAN-_OkHmUb8-ulTEyz9foI_BM1ckhrDetr"
  echo "   Actual:   ${GEDA_PREFIX}"
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
echo "   Prefix: ${GEDA_PREFIX}"
echo "   OOBI: ${GEDA_OOBI}"

# Save to file for other scripts
cat > ./geda-info.json << EOF
{
  "prefix": "${GEDA_PREFIX}",
  "oobi": "${GEDA_OOBI}",
  "alias": "${GEDA_NAME}",
  "salt": "${GEDA_SALT}",
  "passcode": "${GEDA_PASSCODE}"
}
EOF

echo "GEDA info saved to ./geda-info.json"

