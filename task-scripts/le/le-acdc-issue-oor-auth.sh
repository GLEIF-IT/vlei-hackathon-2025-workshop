#!/bin/bash

# Create LE ACDC Credential
# This script issues the LE credential from the QVI AID to the LE AID, chaining the LE to the QVI credential

set -e

echo "🎯 Creating LE ACDC Credential"

# Check if required info files exist
if [ ! -f "./qvi-info.json" ] || [ ! -f "./le-info.json" ] || [ ! -f "./qvi-credential-info.json" ]; then
    echo "❌ Required info files not found. Please run create-qvi-aid.sh, create-le-aid.sh, and create-qvi-acdc-credential.sh first."
    exit 1
fi

# Change to headless wallet directory
cd ./sig-wallet

# Install dependencies if needed
if [ ! -d "./node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Run the LE credential creation script
echo "🔑 Creating LE credential using SignifyTS..."
deno run --allow-net --allow-read --allow-write ./src/create-le-credential.ts

echo "✅ LE credential created successfully!"
echo "💾 LE credential info saved to ./le-credential-info.json"

# Return to parent directory
cd ..

