#!/bin/bash

echo "=== Fixing Info.plist duplicate references in AiTrading.xcodeproj ==="

# Backup original project file
cp AiTrading.xcodeproj/project.pbxproj AiTrading.xcodeproj/project.pbxproj.backup

# Remove Info.plist from Copy Bundle Resources phase
echo "Modifying project file to remove duplicate Info.plist references..."
grep -n "Info.plist" AiTrading.xcodeproj/project.pbxproj > plist_references.txt

# Clean Derived Data
echo "Cleaning Xcode derived data for AiTrading..."
rm -rf ~/Library/Developer/Xcode/DerivedData/AiTrading-*

# Create an updated project.pbxproj with only one Info.plist reference
# This sed command will remove Info.plist from the Copy Bundle Resources section
# while keeping it in the processing section
sed -i '' '/Copy Bundle Resources/,/End Copy Bundle Resources/ s/.*Info\.plist.*//g' AiTrading.xcodeproj/project.pbxproj

echo "Cleaning project..."
xcodebuild clean -project AiTrading.xcodeproj -scheme AiTrading

echo "=== Done ==="
echo "Now open Xcode and try building the project again." 