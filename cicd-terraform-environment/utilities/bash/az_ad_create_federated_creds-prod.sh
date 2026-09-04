#!/bin/bash

# Get user inputs
read -p "Enter the Github organization name: " GITHUB_ORG
read -p "Enter the Github repository name: " GITHUB_REPO
read -p "Enter the Github organization ID: " GITHUB_ORG_ID
read -p "Enter the Github repository ID: " GITHUB_REPO_ID

# Get the App ID from the first github-actions-terraform app (most recent)
APP_ID=$(az ad app list --display-name "github-actions-terraform" --query "[0].appId" -o tsv 2>/dev/null)
if [ -z "$APP_ID" ]; then
  echo "ERROR: Could not find github-actions-terraform app. Please run az_ad_app_registration.sh first." >&2
  exit 1
fi

echo "Using App ID: $APP_ID"

# Create federated credential
az ad app federated-credential create --id "$APP_ID" --parameters '{
  "name": "github-actions-production",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:'"$GITHUB_ORG"'@'"$GITHUB_ORG_ID"'/'"$GITHUB_REPO"'@'"$GITHUB_REPO_ID"':environment:production",
  "audiences": ["api://AzureADTokenExchange"],
  "description": "Github Actions - production environment"
}' 2>/dev/null

if [ $? -eq 0 ]; then
  echo "Federated credential created successfully"
else
  echo "ERROR: Failed to create federated credential" >&2
  exit 1
fi
