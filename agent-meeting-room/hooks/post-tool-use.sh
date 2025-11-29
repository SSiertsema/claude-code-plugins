#!/bin/bash

echo "Hook triggered: post-tool-use"

# Read JSON input from stdin
INPUT=$(cat)

# Extract hook data
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')
TOOL_RESPONSE=$(echo "$INPUT" | jq -r '.tool_response')

# Get the current process ID for this session
PROCESS_TRACKING_DIR="/tmp/claude-current-process"
CURRENT_PROCESS_ID=$(cat "$PROCESS_TRACKING_DIR/$SESSION_ID" 2>/dev/null)

# Check if the tool was interrupted by the user
if echo "$TOOL_RESPONSE" | grep -q "\[Request interrupted by user"; then
  # Mark this process as interrupted (use process ID, not session ID)
  if [ -n "$CURRENT_PROCESS_ID" ]; then
    INTERRUPT_DIR="/tmp/claude-interrupted"
    mkdir -p "$INTERRUPT_DIR"
    echo "interrupted" > "$INTERRUPT_DIR/$CURRENT_PROCESS_ID"
  fi
fi

# post-tool-use fires in the PARENT session context after a tool completes
# For Task tools, the spawned agent is handled by subagent-stop hook
# This hook could be used to track tool usage statistics or logging
# For now, we don't need to send any webhooks here

exit 0
