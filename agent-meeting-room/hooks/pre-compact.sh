#!/bin/bash

echo "Hook triggered: pre-compact"

# Read JSON input from stdin
INPUT=$(cat)

# Extract hook data
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')

# The pre-compact hook fires before Claude Code compacts conversation history
# This is an internal housekeeping operation
# For agent session tracking, this event is not critical

# Uncomment to log:
# echo "[$(date)] Pre-compact triggered - Session: $SESSION_ID" >> /tmp/claude-hooks.log

exit 0
