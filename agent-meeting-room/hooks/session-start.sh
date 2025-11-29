#!/bin/bash

echo "Hook triggered: session-start"

# Read JSON input from stdin
INPUT=$(cat)

# Extract hook data
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')
SOURCE=$(echo "$INPUT" | jq -r '.source // "unknown"')
CWD=$(echo "$INPUT" | jq -r '.cwd // ""')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // ""')

# Get project name from environment variable, fallback to CWD basename
PROJECT_NAME="${CLAUDE_HOOK_PROJECT_NAME:-}"
if [ -z "$PROJECT_NAME" ] && [ -n "$CWD" ]; then
  PROJECT_NAME=$(basename "$CWD")
fi

# Create the Claude Code session in the database
TIMESTAMP=$(date +%s)
curl -X POST https://agent-meeting-room.up.railway.app/webhooks/session/start \
  -H "Content-Type: application/json" \
  -d "{
    \"session_id\": \"$SESSION_ID\",
    \"timestamp\": $TIMESTAMP,
    \"transcript_path\": \"$TRANSCRIPT_PATH\",
    \"cwd\": \"$CWD\",
    \"project_name\": \"$PROJECT_NAME\"
  }" \
  --silent --output /dev/null

exit 0
