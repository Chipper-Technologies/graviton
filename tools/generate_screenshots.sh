#!/bin/bash

# Screenshot Generation Script for Graviton App
# This script processes raw screenshots and generates optimized versions

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "🚀 Graviton Screenshot Generator"
echo "📂 Project: $PROJECT_ROOT"

# Check if Python 3 is available
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is required but not installed."
    exit 1
fi

# Check if Pillow is installed, install if needed
echo "🔍 Checking dependencies..."
if ! python3 -c "import PIL" &> /dev/null; then
    echo "📦 Installing Pillow..."
    python3 -m pip install -r "$SCRIPT_DIR/requirements.txt"
else
    echo "✅ Dependencies satisfied"
fi

# Run the screenshot processor
echo "🎯 Processing screenshots..."
cd "$PROJECT_ROOT"
python3 "$SCRIPT_DIR/generate_screenshots.py" "$@"

echo "🎉 Done! Check the generated files in assets/screenshots/"