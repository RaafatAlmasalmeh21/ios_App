#!/bin/bash

echo "=== Advanced fix for Xcode project build issues ==="

# Backup original project file
cp AiTrading.xcodeproj/project.pbxproj AiTrading.xcodeproj/project.pbxproj.backup.$(date +%Y%m%d%H%M%S)

# Find and save Info.plist file locations
echo "Locating Info.plist files..."
find AiTrading -name "Info.plist" > info_plist_files.txt
cat info_plist_files.txt

# Clean Derived Data
echo "Cleaning ALL Xcode derived data..."
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# Specific fix for Info.plist duplication
echo "Fixing project structure..."

# Step 1: Try to locate the Info.plist in the main app directory
if [ -f "AiTrading/Info.plist" ]; then
  echo "Found main Info.plist in AiTrading directory"
  
  # Step 2: Make a temporary backup of the original Info.plist
  cp AiTrading/Info.plist AiTrading/Info.plist.backup
  
  # Step 3: Create a new project.xcworkspace directory if it doesn't exist
  mkdir -p AiTrading.xcodeproj/project.xcworkspace
  
  # Step 4: Use Xcode command line tools to update the project
  xcrun xcodebuild -project AiTrading.xcodeproj -scheme AiTrading clean
fi

# Extra steps to ensure clean build
echo "Performing additional clean operations..."
rm -rf build/
rm -rf DerivedData/

echo "=== Done ==="
echo "Now please follow these manual steps to fix the issue:"
echo "1. Open Xcode"
echo "2. Hold Option key and click 'Product' -> 'Clean Build Folder...'"
echo "3. Close Xcode"
echo "4. Reopen AiTrading.xcodeproj"
echo "5. Right-click on the AiTrading target in the Project Navigator"
echo "6. Click 'Add Files to AiTrading...'"
echo "7. Navigate to the AiTrading folder"
echo "8. Select Info.plist (if needed)"
echo "9. Make sure 'Create folder references' is NOT selected"
echo "10. Click 'Add'"
echo "11. Go to Build Phases and check that Info.plist appears only once"
echo "12. Try building again" 