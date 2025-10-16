#!/bin/bash

# Create OOR ACDC Credential
# This script issues the OOR Auth credential from the LE AID to the QVI AID, 
# chaining the OOR Auth credential to the LE credential, and then issues the 
# OOR credential from the QVI AID to the Person AID, chaining the OOR credential to the OOR Auth credential

set -e

echo "🎯 Creating OOR ACDC Credential"

# Check if required info files exist
if [ ! -f "./le-info.json" ] || [ ! -f "./qvi-info.json" ] || [ ! -f "./person-info.json" ] || [ ! -f "./le-credential-info.json" ]; then
    echo "❌ Required info files not found. Please run create-le-aid.sh, create-qvi-aid.sh, create-person-aid.sh, and create-le-acdc-credential.sh first."
    exit 1
fi

# Change to headless wallet directory
cd ./sig-wallet

# Install dependencies if needed
if [ ! -d "./node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Run the OOR credential creation script
echo "🔑 Creating OOR credential using SignifyTS..."
deno run --allow-net --allow-read --allow-write ./src/create-oor-credential.ts

echo "✅ OOR credential created successfully!"
echo "💾 OOR credential info saved to ./oor-credential-info.json"
echo "💾 OOR Auth credential info saved to ./oor-auth-credential-info.json"

# Return to parent directory
cd ..

