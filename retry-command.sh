#!/bin/bash

# Check if command is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <command> [max_retries]"
    echo "Example: $0 'git push' 5"
    echo "Example: $0 'npm test' 3"
    exit 1
fi

# Get command from first argument
COMMAND="$1"

# Set max number of retries (default to 5 if not provided)
MAX_RETRIES=${2:-5}
RETRY_COUNT=0
SUCCESS=false

echo "Starting '$COMMAND' with auto-retry (max: $MAX_RETRIES attempts)..."

while [ $RETRY_COUNT -lt $MAX_RETRIES ] && [ "$SUCCESS" = false ]; do
    # Increment retry counter
    RETRY_COUNT=$((RETRY_COUNT + 1))
    
    echo "Attempt $RETRY_COUNT of $MAX_RETRIES"
    
    # Execute the command
    eval "$COMMAND"
    
    # Check if command was successful
    if [ $? -eq 0 ]; then
        echo "Command '$COMMAND' executed successfully!"
        SUCCESS=true
    else
        echo "Command '$COMMAND' failed. Retrying in 3 seconds..."
        sleep 3
    fi
done

if [ "$SUCCESS" = true ]; then
    echo "Command completed successfully after $RETRY_COUNT attempt(s)."
    exit 0
else
    echo "Failed to execute '$COMMAND' after $MAX_RETRIES attempts."
    exit 1
fi