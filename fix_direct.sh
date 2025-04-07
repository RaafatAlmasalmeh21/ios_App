#!/bin/bash

echo "=== DIRECT FIX for Info.plist duplication issue ==="

# Step 1: Create a simple manual fix with instructions
cat > fix_instructions.txt << 'EOF'
HOW TO FIX THE INFO.PLIST DUPLICATION ERROR

This is a step-by-step guide to manually fix the "Multiple commands produce Info.plist" error:

1. Open Xcode
2. Select the AiTrading project in the Project Navigator
3. Select the AiTrading target
4. Go to the "Build Phases" tab
5. Expand the "Copy Bundle Resources" section
6. Look for "Info.plist" entry and REMOVE it (by clicking the - button)
7. Leave Info.plist in the "Compile Sources" section if it's there
8. Clean the build folder (Option + Product -> Clean Build Folder...)
9. Try building again

EXPLANATION: The issue occurs because Info.plist is being included in both the "Copy Bundle Resources" 
phase and also being processed by another build phase. It should typically only be processed 
and not copied directly.
EOF

echo "Created detailed fix instructions in fix_instructions.txt"

# Step 2: Clean derived data for this project
echo "Cleaning derived data..."
rm -rf ~/Library/Developer/Xcode/DerivedData/AiTrading-*

# Step 3: Create a backup of the project file
echo "Creating backup of project file..."
cp AiTrading.xcodeproj/project.pbxproj AiTrading.xcodeproj/project.pbxproj.backup.$(date +%Y%m%d%H%M%S)

# Display the instructions
cat fix_instructions.txt

echo "=== END ==="
echo "Please follow the manual steps in fix_instructions.txt"
echo "The error should be fixed after you remove Info.plist from Copy Bundle Resources section." 