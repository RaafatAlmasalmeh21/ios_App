#!/bin/bash

# Create group folders in Xcode's preferred way
cd AiTrading
mkdir -p Models Services Views

# Move current files if they exist
if [ -d "../temp_backup/Models" ]; then
  cp -R ../temp_backup/Models/* Models/ 2>/dev/null
fi

if [ -d "../temp_backup/Services" ]; then
  cp -R ../temp_backup/Services/* Services/ 2>/dev/null
fi

if [ -d "../temp_backup/Views" ]; then
  cp -R ../temp_backup/Views/* Views/ 2>/dev/null
fi

# Go back to main directory
cd ..

# Instructions for the user to follow in Xcode
echo "==== INSTRUCTIONS TO FIX THE PROJECT ===="
echo "1. Open AiTrading.xcodeproj in Xcode"
echo "2. Right-click on the AiTrading folder in the Project Navigator"
echo "3. Select 'Add Files to AiTrading...'"
echo "4. Navigate to and select the Models, Services, and Views folders"
echo "5. Make sure 'Create groups' is selected (not folder references)"
echo "6. Click 'Add'"
echo "7. Clean the build folder (Shift + Command + K)"
echo "8. Build the project (Command + B)"
echo "=====================================" 