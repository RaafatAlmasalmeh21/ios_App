#!/bin/bash

echo "==== GitHub Token Push Helper ===="
echo "This script will help you push to GitHub using a personal access token"
echo ""

# Prompt for token
echo "Please enter your GitHub Personal Access Token:"
read -s GITHUB_TOKEN
echo ""

if [ -z "$GITHUB_TOKEN" ]; then
  echo "Error: No token provided."
  exit 1
fi

# Extract username from remote URL
REMOTE_URL=$(git remote get-url origin)
USERNAME=$(echo $REMOTE_URL | sed -n 's/.*github.com\/\([^\/]*\)\/.*/\1/p')
REPO=$(echo $REMOTE_URL | sed -n 's/.*github.com\/[^\/]*\/\(.*\)\.git/\1/p')

echo "Username: $USERNAME"
echo "Repository: $REPO"
echo ""

# Set up the remote with token
TOKEN_URL="https://${USERNAME}:${GITHUB_TOKEN}@github.com/${USERNAME}/${REPO}.git"

# Add the token URL as a new remote
echo "Setting up a temporary remote with your token..."
git remote add token_origin $TOKEN_URL

# Push to the token remote
echo "Pushing to GitHub..."
git push -u token_origin main

# Check if push succeeded
if [ $? -eq 0 ]; then
  echo ""
  echo "Success! Your code has been pushed to GitHub."
  echo "View your repository at: https://github.com/${USERNAME}/${REPO}"
  
  # Clean up the temporary remote
  git remote remove token_origin
else
  echo ""
  echo "Push failed. Please check your token and try again."
  
  # Clean up the temporary remote
  git remote remove token_origin
fi 