#!/bin/bash

# load-env.sh - Load environment variables from .env file
# Usage: source ./scripts/load-env.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: .env file not found at $ENV_FILE"
  echo "Please copy .env.example to .env and fill in your values:"
  echo "  cp .env.example .env"
  echo "  nano .env  # or your preferred editor"
  return 1
fi

# Load all variables from .env file (ignore comments and empty lines)
set -a
source "$ENV_FILE"
set +a

# Validate required variables
REQUIRED_VARS=(
  "TF_VAR_subscription_id"
  "ARM_CLIENT_ID"
  "ARM_TENANT_ID"
  "ARM_SUBSCRIPTION_ID"
)

MISSING_VARS=()
for var in "${REQUIRED_VARS[@]}"; do
  if [ -z "${!var}" ]; then
    MISSING_VARS+=("$var")
  fi
done

if [ ${#MISSING_VARS[@]} -gt 0 ]; then
  echo "ERROR: Missing required environment variables:"
  for var in "${MISSING_VARS[@]}"; do
    echo "  - $var"
  done
  echo "Please update your .env file with the missing values."
  return 1
fi

echo "✓ Environment variables loaded successfully"
echo "  Subscription ID: ${TF_VAR_subscription_id:0:8}..."
echo "  Client ID: ${ARM_CLIENT_ID:0:8}..."
echo "  Tenant ID: ${ARM_TENANT_ID:0:8}..."
