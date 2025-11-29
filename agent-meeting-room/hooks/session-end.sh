#!/bin/bash

echo "Hook triggered: session-end"

# Read JSON input from stdin
INPUT=$(cat)

# Extract hook data
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')
REASON=$(echo "$INPUT" | jq -r '.reason // "unknown"')

# End the Claude Code session in the database
TIMESTAMP=$(date +%s)
curl -X POST https://agent-meeting-room.up.railway.app/webhooks/session/end \
  -H "Content-Type: application/json" \
  -d "{
    \"session_id\": \"$SESSION_ID\",
    \"timestamp\": $TIMESTAMP
  }" \
  --silent --output /dev/null

exit 0
