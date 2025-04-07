#!/bin/bash

echo "=== Fixing duplicate resource references in AiTrading.xcodeproj ==="

# Backup original project file
cp AiTrading.xcodeproj/project.pbxproj AiTrading.xcodeproj/project.pbxproj.backup

# Clean Derived Data
echo "Cleaning Xcode derived data for AiTrading..."
rm -rf ~/Library/Developer/Xcode/DerivedData/AiTrading-*

# If you need to modify the project file directly, you can use sed commands here
# For example:
# sed -i '' 's/duplicate_reference_pattern/corrected_pattern/g' AiTrading.xcodeproj/project.pbxproj

echo "Cleaning project..."
xcodebuild clean -project AiTrading.xcodeproj -scheme AiTrading

echo "=== Done ==="
echo "Now open Xcode and try building the project again."
echo "If the issue persists, please follow these steps manually:"
echo "1. Open AiTrading.xcodeproj in Xcode"
echo "2. Go to Project Navigator and check for duplicated files"
echo "3. Select the AITrading target and go to Build Phases"
echo "4. Check 'Copy Bundle Resources' for duplicated entries"
echo "5. Clean build folder (Shift+Cmd+K) and build again" 