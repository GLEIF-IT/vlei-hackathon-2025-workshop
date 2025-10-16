#!/bin/bash

# Create LE AID using SignifyTS
# This script uses the headless SignifyTS wallet to create the LE AID

set -e

echo "🎯 Creating LE AID"

# Check if required info files exist
if [ ! -f "./geda-info.json" ] || [ ! -f "./qvi-info.json" ]; then
    echo "❌ Required info files not found. Please run create-geda-aid.sh and create-qvi-aid.sh first."
    exit 1
fi

# Change to headless wallet directory
cd ./sig-wallet

# Install dependencies if needed
if [ ! -d "./node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Run the LE AID creation script
echo "🔑 Creating LE AID using SignifyTS..."
deno run --allow-net --allow-read --allow-write ./src/create-le-aid.ts

echo "✅ LE AID created successfully!"
echo "💾 LE info saved to ./le-info.json"

# Return to parent directory
cd ..

