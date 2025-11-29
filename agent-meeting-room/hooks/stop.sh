#!/bin/bash

echo "Hook triggered: stop"

# Set up logging
LOG_FILE="/tmp/claude-hooks.log"

# Read JSON input from stdin
INPUT=$(cat)

# Log that hook was triggered
echo "[$(date '+%Y-%m-%d %H:%M:%S')] stop hook triggered" >> "$LOG_FILE"
echo "  Input: $INPUT" >> "$LOG_FILE"

# Extract hook data
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // ""')

# Get the current process ID that we created for this user prompt
PROCESS_TRACKING_DIR="/tmp/claude-current-process"
CURRENT_PROCESS_ID=$(cat "$PROCESS_TRACKING_DIR/$SESSION_ID" 2>/dev/null)

# Detect if the process was interrupted using multiple methods
INTERRUPTED=false
INTERRUPT_REASON=""

# Method 1: Check if a tool was interrupted (flag set by post-tool-use hook)
# Now using process ID instead of session ID
INTERRUPT_DIR="/tmp/claude-interrupted"
INTERRUPT_FLAG="$INTERRUPT_DIR/$CURRENT_PROCESS_ID"
if [ -f "$INTERRUPT_FLAG" ]; then
  INTERRUPTED=true
  INTERRUPT_REASON="Tool execution interrupted by user"
  rm -f "$INTERRUPT_FLAG"
fi

# Method 2: Parse transcript file for interruption markers
# Only check the LAST 5 lines to avoid false positives from conversation history
if [ "$INTERRUPTED" = false ] && [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
  # Check if the last few lines of transcript contain interruption text
  if tail -5 "$TRANSCRIPT_PATH" 2>/dev/null | grep -q "Request interrupted by user"; then
    INTERRUPTED=true
    INTERRUPT_REASON="Process interrupted (detected in transcript)"
  fi
fi

# Method 3: Removed - Don't assume short processes without tools are interrupted
# This was causing false positives for simple text responses

# Check if Claude's last message is a question (waiting for user input)
WAITING_FOR_INPUT=false

if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
  # Get the last assistant message from the transcript
  LAST_ASSISTANT_MESSAGE=$(tac "$TRANSCRIPT_PATH" | grep -m1 '"role":"assistant"' | jq -r '.message.content[] | select(.type=="text") | .text' 2>/dev/null)

  if [ -n "$LAST_ASSISTANT_MESSAGE" ]; then
    echo "  Last assistant message: ${LAST_ASSISTANT_MESSAGE:0:100}..." >> "$LOG_FILE"

    # Check if the message ends with a question mark or contains question patterns
    if echo "$LAST_ASSISTANT_MESSAGE" | grep -qE '\?[[:space:]]*$'; then
      WAITING_FOR_INPUT=true
      echo "  Detected question (ends with ?)" >> "$LOG_FILE"
    fi
  fi
fi

# The stop hook fires when Claude finishes responding to a user prompt
# Mark the current process as completed or interrupted, or waiting for input
if [ -n "$CURRENT_PROCESS_ID" ]; then
  if [ "$INTERRUPTED" = true ]; then
    STATUS="INTERRUPTED"
    RESULT="$INTERRUPT_REASON"

    echo "  Process ID: $CURRENT_PROCESS_ID" >> "$LOG_FILE"
    echo "  Status: $STATUS" >> "$LOG_FILE"
    echo "  Result: $RESULT" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"

    curl -X POST https://agent-meeting-room.up.railway.app/webhooks/process/complete \
      -H "Content-Type: application/json" \
      -d "{
        \"process_id\": \"$CURRENT_PROCESS_ID\",
        \"status\": \"$STATUS\",
        \"timestamp\": $(date +%s),
        \"result\": \"$RESULT\"
      }" \
      --silent --output /dev/null

    # Cleanup tracking files (using process ID)
    TOOL_EXECUTION_DIR="/tmp/claude-tool-executed"
    PROCESS_TIME_DIR="/tmp/claude-process-times"
    rm -f "$TOOL_EXECUTION_DIR/$CURRENT_PROCESS_ID" 2>/dev/null
    rm -f "$PROCESS_TIME_DIR/$CURRENT_PROCESS_ID" 2>/dev/null
    rm -f "$PROCESS_TRACKING_DIR/$SESSION_ID" 2>/dev/null
  elif [ "$WAITING_FOR_INPUT" = true ]; then
    # Don't mark as completed - send a webhook to indicate waiting for input
    echo "  Status: WAITING_FOR_INPUT (question detected)" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"

    curl -X POST https://agent-meeting-room.up.railway.app/webhooks/process/status \
      -H "Content-Type: application/json" \
      -d "{
        \"process_id\": \"$CURRENT_PROCESS_ID\",
        \"status\": \"WAITING_FOR_INPUT\",
        \"timestamp\": $(date +%s),
        \"reason\": \"Agent asked a question\",
        \"input_request\": {
          \"prompt\": \"Agent is waiting for your input. Please check the conversation.\",
          \"options\": []
        }
      }" \
      --silent --output /dev/null

    # Don't send process/complete webhook or cleanup tracking files yet
    # The process is still active, waiting for user input
  else
    STATUS="COMPLETED"
    RESULT="Request completed successfully"

    echo "  Process ID: $CURRENT_PROCESS_ID" >> "$LOG_FILE"
    echo "  Status: $STATUS" >> "$LOG_FILE"
    echo "  Result: $RESULT" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"

    curl -X POST https://agent-meeting-room.up.railway.app/webhooks/process/complete \
      -H "Content-Type: application/json" \
      -d "{
        \"process_id\": \"$CURRENT_PROCESS_ID\",
        \"status\": \"$STATUS\",
        \"timestamp\": $(date +%s),
        \"result\": \"$RESULT\"
      }" \
      --silent --output /dev/null

    # Cleanup tracking files (using process ID)
    TOOL_EXECUTION_DIR="/tmp/claude-tool-executed"
    PROCESS_TIME_DIR="/tmp/claude-process-times"
    rm -f "$TOOL_EXECUTION_DIR/$CURRENT_PROCESS_ID" 2>/dev/null
    rm -f "$PROCESS_TIME_DIR/$CURRENT_PROCESS_ID" 2>/dev/null
    rm -f "$PROCESS_TRACKING_DIR/$SESSION_ID" 2>/dev/null
  fi
fi

exit 0
