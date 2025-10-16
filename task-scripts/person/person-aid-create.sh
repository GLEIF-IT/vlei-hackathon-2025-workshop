#!/bin/bash

# Create Person AID using SignifyTS
# This script uses the headless SignifyTS wallet to create the Person AID

set -e

echo "🎯 Creating Person AID"

# Check if required info files exist
if [ ! -f "./geda-info.json" ] || [ ! -f "./qvi-info.json" ] || [ ! -f "./le-info.json" ]; then
    echo "❌ Required info files not found. Please run create-geda-aid.sh, create-qvi-aid.sh, and create-le-aid.sh first."
    exit 1
fi

# Change to headless wallet directory
cd ./sig-wallet

# Install dependencies if needed
if [ ! -d "./node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Run the Person AID creation script
echo "🔑 Creating Person AID using SignifyTS..."
deno run --allow-net --allow-read --allow-write ./src/create-person-aid.ts

echo "✅ Person AID created successfully!"
echo "💾 Person info saved to ./person-info.json"

# Return to parent directory
cd ..

