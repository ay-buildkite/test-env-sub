#!/bin/bash

# Define strict bash behavior:
# -e: Exit on any error
# -u: Error on undefined variables
# -o pipefail: Return error if any command in a pipe fails
# WHY: This helps us catch errors early and prevents silent failures
set -eo pipefail

# Check if required env vars exists
check_env_var() {
  # $1 the variable name passed to the function
  if [[ -z "${!1:-}" ]]; then
    echo "Error: Required env var $1 is not set."
    exit1
  fi
}

# Safely get metadata to get consistent error handling for
# metadata ops.
get_metadata() {
  local key=$1
  local value

  # Try to get metadata. Fail gracefully otherwise
  if ! value=$(buildkite-agent meta-data get "$key"); then
    echo "Error: failed to retrieve metadata key: $key"
    exit 1
  fi

  # Check for empty value
  if [[ -z "$value" ]]; then
    echo "Error: Metadata key '$key' exists but has not value."
    exit 1
  fi

  echo "The value for key '$key' is:"
  echo "$value"
}

# Define our required environment variables
# Makes it clear what the script expect from its caller
readonly required_env_vars=(
  "DEPLOY_VERSION"
  "ENVIRONMENT"
  "GIT_COMMIT"
)

echo "Checking required env vars..."
for var in "${required_env_vars[@]}"; do
  check_env_var "$var"
done

echo "Fetching metadata..."
# version=$(get_metadata "version")
# build_time=$(get_metadata "build_time")

# Display configuration for logging and debugging purposes
# WHY: This helps with troubleshooting and creates an audit trail
echo "Deployment Configuration:"
echo "------------------------"
echo "Environment Variables:"
echo "Deploy Version: $DEPLOY_VERSION"
echo "Environment: $ENVIRONMENT"
echo "Git Commit: $GIT_COMMIT"
echo ""
echo "Metadata Values:"
echo "Build Version: $VERSION"
echo "Build Time: $BUILD_TIME"

# Simulate deployment
echo "Starting deployment..."
sleep 5

echo "Deployment complete!"
