#!/bin/bash

echo "Hook triggered: user-prompt-submit"

# Set up logging
LOG_FILE="/tmp/claude-hooks.log"

# Read JSON input from stdin
INPUT=$(cat)

# Log that hook was triggered
echo "[$(date '+%Y-%m-%d %H:%M:%S')] user-prompt-submit hook triggered" >> "$LOG_FILE"

# Extract hook data
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')
PROMPT=$(echo "$INPUT" | jq -r '.prompt')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // ""')
CWD=$(echo "$INPUT" | jq -r '.cwd // ""')

# Get project name from environment variable, fallback to CWD basename
PROJECT_NAME="${CLAUDE_HOOK_PROJECT_NAME:-}"
if [ -z "$PROJECT_NAME" ] && [ -n "$CWD" ]; then
  PROJECT_NAME=$(basename "$CWD")
fi

# Log the extracted data
echo "  Session ID: $SESSION_ID" >> "$LOG_FILE"
echo "  Prompt: $PROMPT" >> "$LOG_FILE"
echo "  CWD: $CWD" >> "$LOG_FILE"
echo "  Project Name: $PROJECT_NAME" >> "$LOG_FILE"

# Check if there's a process waiting for input in this session
WAITING_PROCESS=$(curl -s "https://agent-meeting-room.up.railway.app/api/sessions/$SESSION_ID/waiting-process" | jq -r '.process')

if [ "$WAITING_PROCESS" != "null" ] && [ -n "$WAITING_PROCESS" ]; then
  # Resume the existing process
  PROCESS_ID=$(echo "$WAITING_PROCESS" | jq -r '.id')
  echo "  Resuming existing process: $PROCESS_ID" >> "$LOG_FILE"

  # Update the process status back to RUNNING
  RESPONSE=$(curl -X POST https://agent-meeting-room.up.railway.app/webhooks/process/status \
    -H "Content-Type: application/json" \
    -d "{
      \"process_id\": \"$PROCESS_ID\",
      \"status\": \"RUNNING\",
      \"timestamp\": $(date +%s),
      \"reason\": \"User provided input: $PROMPT\"
    }" \
    --silent -w "\nHTTP_CODE:%{http_code}" 2>&1)

  echo "  Resume response: $RESPONSE" >> "$LOG_FILE"
else
  # Create a new process
  PROCESS_ID=$(uuidgen 2>/dev/null || cat /proc/sys/kernel/random/uuid)
  echo "  Creating new process: $PROCESS_ID" >> "$LOG_FILE"

  # Create a unique process for each user request
  # process_id = unique process ID, session_id = Claude Code terminal session
  RESPONSE=$(curl -X POST https://agent-meeting-room.up.railway.app/webhooks/process/start \
    -H "Content-Type: application/json" \
    -d "{
      \"process_id\": \"$PROCESS_ID\",
      \"session_id\": \"$SESSION_ID\",
      \"parent_process_id\": null,
      \"agent_id\": \"claude\",
      \"title\": \"$PROMPT\",
      \"prompt\": \"$PROMPT\",
      \"tool_name\": null,
      \"timestamp\": $(date +%s),
      \"transcript_path\": \"$TRANSCRIPT_PATH\",
      \"cwd\": \"$CWD\",
      \"project_name\": \"$PROJECT_NAME\"
    }" \
    --silent -w "\nHTTP_CODE:%{http_code}" 2>&1)

  echo "  Create response: $RESPONSE" >> "$LOG_FILE"

  # Store process start time for interruption detection
  PROCESS_TIME_DIR="/tmp/claude-process-times"
  mkdir -p "$PROCESS_TIME_DIR"
  date +%s > "$PROCESS_TIME_DIR/$PROCESS_ID"
fi

echo "" >> "$LOG_FILE"

# Store the current process ID for other hooks to access
# This allows pre-tool-use to know which process spawned an agent
PROCESS_TRACKING_DIR="/tmp/claude-current-process"
mkdir -p "$PROCESS_TRACKING_DIR"
echo "$PROCESS_ID" > "$PROCESS_TRACKING_DIR/$SESSION_ID"

exit 0
