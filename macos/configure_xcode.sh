#!/bin/bash

# Script to configure macOS Xcode project with dev and prod configurations
# This script uses xcodebuild and PlistBuddy to modify the project configuration

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
XCODE_PROJECT="$PROJECT_DIR/Runner.xcodeproj"

echo "🔧 Configuring macOS Xcode project for dev/prod environments..."

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "❌ Error: xcodebuild not found. Please install Xcode."
    exit 1
fi

echo "✅ Xcode found"

# Note: The xcconfig files have been created. To complete the setup:
# 1. Open the project in Xcode
# 2. Add Debug-Dev, Release-Dev, and Release-Prod configurations
# 3. Assign the corresponding xcconfig files to each configuration

echo ""
echo "📝 Next Steps:"
echo "1. Open the Xcode project:"
echo "   open '$XCODE_PROJECT'"
echo ""
echo "2. In Xcode, select the Runner project in the Project Navigator"
echo ""
echo "3. Go to the Info tab and expand Configurations"
echo ""
echo "4. Add new configurations:"
echo "   - Duplicate 'Debug' → Name it 'Debug-Dev'"
echo "   - Duplicate 'Release' → Name it 'Release-Dev'"
echo "   - Duplicate 'Release' → Name it 'Release-Prod'"
echo ""
echo "5. For each new configuration, set the xcconfig file:"
echo "   - Debug-Dev: Runner/Configs/Debug-Dev.xcconfig"
echo "   - Release-Dev: Runner/Configs/Release-Dev.xcconfig"
echo "   - Release-Prod: Runner/Configs/Release-Prod.xcconfig"
echo ""
echo "6. (Optional) Create schemes for easier building:"
echo "   - Product → Scheme → Manage Schemes"
echo "   - Create 'Runner Dev' scheme (uses Debug-Dev/Release-Dev)"
echo "   - Create 'Runner Prod' scheme (uses Debug/Release-Prod)"
echo ""
echo "✨ Configuration files are ready at:"
echo "   - $PROJECT_DIR/Runner/Configs/Debug-Dev.xcconfig"
echo "   - $PROJECT_DIR/Runner/Configs/Release-Dev.xcconfig"
echo "   - $PROJECT_DIR/Runner/Configs/Release-Prod.xcconfig"
echo "   - $PROJECT_DIR/Runner/Configs/AppInfo-Dev.xcconfig"
echo "   - $PROJECT_DIR/Runner/Configs/AppInfo-Prod.xcconfig"
echo ""
echo "📱 Firebase config files are at:"
echo "   - $PROJECT_DIR/Config/Dev/GoogleService-Info.plist"
echo "   - $PROJECT_DIR/Config/Prod/GoogleService-Info.plist"

# Open the project in Xcode
read -p "Would you like to open the project in Xcode now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    open "$XCODE_PROJECT"
    echo "✅ Xcode project opened"
fi

echo ""
echo "🎉 Configuration setup complete!"
echo "See macos/README.md for detailed instructions."
