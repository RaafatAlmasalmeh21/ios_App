#!/bin/bash

echo "===== GitHub Push Helper ====="
echo "This script will help you push your project to GitHub"
echo ""

# Check if we're in the right directory
if [ ! -d ".git" ]; then
  echo "Error: Git repository not found in the current directory."
  echo "Make sure you run this script from the root of your project."
  exit 1
fi

# Check remote
REMOTE_URL=$(git remote get-url origin 2>/dev/null)
if [ $? -ne 0 ]; then
  echo "Error: No remote named 'origin' found."
  echo "Please set up your remote first with:"
  echo "  git remote add origin https://github.com/RaafatAlmasalmeh21/ios_App.git"
  exit 1
fi

echo "Current remote: $REMOTE_URL"
echo ""

echo "1. Making sure everything is committed..."
git status

echo ""
echo "2. Attempting to push to GitHub..."
echo "   (You will be prompted for your GitHub username and password/token)"
echo "   Note: When prompted for password, use a GitHub Personal Access Token,"
echo "   not your regular GitHub password."
echo ""
echo "   If you need to create a Personal Access Token:"
echo "   1. Go to GitHub.com → Settings → Developer Settings → Personal Access Tokens"
echo "   2. Generate a new token with 'repo' permissions"
echo ""

read -p "Press Enter to continue with the push, or Ctrl+C to cancel..."

# Push to GitHub
git push -u origin main

# Check if push succeeded
if [ $? -eq 0 ]; then
  echo ""
  echo "Success! Your code has been pushed to GitHub."
  echo "View your repository at: https://github.com/RaafatAlmasalmeh21/ios_App"
else
  echo ""
  echo "Push failed. You might need to:"
  echo "1. Create a Personal Access Token on GitHub"
  echo "2. Use that token as your password when prompted"
  echo ""
  echo "For more help, see: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token"
fi 