#!/bin/bash

echo "Hook triggered: user-prompt-required"

# Read JSON input from stdin
INPUT=$(cat)

# Extract hook data
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path')

# Get the current process ID for this session
PROCESS_TRACKING_DIR="/tmp/claude-current-process"
CURRENT_PROCESS_ID=$(cat "$PROCESS_TRACKING_DIR/$SESSION_ID" 2>/dev/null)

# Only send webhook if we have a process ID
if [ -n "$CURRENT_PROCESS_ID" ]; then
  # Send webhook to update process status to WAITING_FOR_INPUT
  # Note: The hook doesn't provide the specific prompt/question,
  # so we use a generic message. For detailed input requests,
  # agents should explicitly call the webhook with input_request details.

  curl -X POST https://agent-meeting-room.up.railway.app/webhooks/process/status \
    -H "Content-Type: application/json" \
    -d "{
      \"process_id\": \"$CURRENT_PROCESS_ID\",
      \"status\": \"WAITING_FOR_INPUT\",
      \"timestamp\": $(date +%s),
      \"reason\": \"Agent requires user input\",
      \"input_request\": {
        \"prompt\": \"Agent is waiting for your input. Please check the conversation.\",
        \"options\": []
      }
    }" \
    --silent --output /dev/null
fi

exit 0
