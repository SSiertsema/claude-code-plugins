#!/bin/bash

echo "Hook triggered: subagent-stop"

# Debug log file
DEBUG_LOG="/tmp/claude-hook-debug.log"

# Read JSON input from stdin
INPUT=$(cat)

# Extract hook data
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')

echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] SUBAGENT-STOP: Hook fired for session '$SESSION_ID'" >> "$DEBUG_LOG"

# Find the oldest task mapping (FIFO - first task that started is first to finish)
MAPPING_DIR="/tmp/claude-agent-sessions"
LOCK_DIR="/tmp/claude-agent-sessions-locks"
mkdir -p "$LOCK_DIR"

if [ -d "$MAPPING_DIR" ]; then
  # Count files before processing
  FILE_COUNT=$(ls -1 "$MAPPING_DIR"/*.parent 2>/dev/null | wc -l)
  echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] SUBAGENT-STOP: Found $FILE_COUNT metadata files in $MAPPING_DIR" >> "$DEBUG_LOG"

  # Try to acquire a lock on the oldest available mapping file
  OLDEST_MAPPING=""
  MAX_WAIT_MS=500
  START_TIME=$(date +%s%N)

  while [ -z "$OLDEST_MAPPING" ]; do
    # Check if we've waited too long
    CURRENT_TIME=$(date +%s%N)
    ELAPSED_MS=$(( (CURRENT_TIME - START_TIME) / 1000000 ))
    if [ $ELAPSED_MS -gt $MAX_WAIT_MS ]; then
      echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] SUBAGENT-STOP: Timeout waiting for available metadata file" >> "$DEBUG_LOG"
      break
    fi

    # Get all .parent files sorted by age (oldest first when using tail -1)
    for CANDIDATE in $(ls -t "$MAPPING_DIR"/*.parent 2>/dev/null | tac); do
      CANDIDATE_KEY=$(basename "${CANDIDATE%.parent}")
      LOCK_FILE="$LOCK_DIR/$CANDIDATE_KEY.lock"

      # Try to create lock file atomically
      if mkdir "$LOCK_FILE" 2>/dev/null; then
        OLDEST_MAPPING="$CANDIDATE"
        echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] SUBAGENT-STOP: Acquired lock for $CANDIDATE_KEY" >> "$DEBUG_LOG"
        break 2
      fi
    done

    # If no file was available, sleep briefly and retry
    if [ -z "$OLDEST_MAPPING" ]; then
      sleep 0.01
    fi
  done

  if [ -n "$OLDEST_MAPPING" ]; then
    # Extract the base key (remove .parent extension)
    BASE_KEY="${OLDEST_MAPPING%.parent}"
    TASK_KEY=$(basename "$BASE_KEY")

    echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] SUBAGENT-STOP: Processing metadata file '$BASE_KEY'" >> "$DEBUG_LOG"

    # Read the mapping data
    PARENT_PROCESS_ID=$(cat "${BASE_KEY}.parent" 2>/dev/null || echo "")
    PARENT_SESSION_ID=$(cat "${BASE_KEY}.session" 2>/dev/null || echo "")
    DESCRIPTION=$(cat "${BASE_KEY}.description" 2>/dev/null || echo "Agent Task")
    PROMPT=$(cat "${BASE_KEY}.prompt" 2>/dev/null || echo "")
    CWD=$(cat "${BASE_KEY}.cwd" 2>/dev/null || echo "")
    TRANSCRIPT_PATH=$(cat "${BASE_KEY}.transcript" 2>/dev/null || echo "")
    PROJECT_NAME=$(cat "${BASE_KEY}.project" 2>/dev/null || echo "")

    # Generate unique child process ID from task key
    CHILD_PROCESS_ID="$TASK_KEY"

    echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] SUBAGENT-STOP: Parent session ID = '$PARENT_SESSION_ID'" >> "$DEBUG_LOG"
    echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] SUBAGENT-STOP: Parent process ID = '$PARENT_PROCESS_ID'" >> "$DEBUG_LOG"
    echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] SUBAGENT-STOP: Child process ID (generated) = '$CHILD_PROCESS_ID'" >> "$DEBUG_LOG"
    echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] SUBAGENT-STOP: Task description = '$DESCRIPTION'" >> "$DEBUG_LOG"

    START_TIMESTAMP=$(date +%s)
    COMPLETE_TIMESTAMP=$((START_TIMESTAMP + 1))

    # Create the subprocess (agent) linked to the parent process
    echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] SUBAGENT-STOP: Sending webhook to create child process (parent_session='$PARENT_SESSION_ID', child_process='$CHILD_PROCESS_ID')" >> "$DEBUG_LOG"

    # Escape special characters in JSON strings
    DESCRIPTION_ESCAPED=$(echo "$DESCRIPTION" | jq -Rs .)
    PROMPT_ESCAPED=$(echo "$PROMPT" | jq -Rs .)
    TRANSCRIPT_PATH_ESCAPED=$(echo "$TRANSCRIPT_PATH" | jq -Rs .)
    CWD_ESCAPED=$(echo "$CWD" | jq -Rs .)
    PROJECT_NAME_ESCAPED=$(echo "$PROJECT_NAME" | jq -Rs .)

    # Build JSON payload using jq for proper escaping
    PAYLOAD=$(jq -n \
      --arg process_id "$CHILD_PROCESS_ID" \
      --arg session_id "$PARENT_SESSION_ID" \
      --arg parent_process_id "$PARENT_PROCESS_ID" \
      --arg agent_id "claude-agent" \
      --arg title "$DESCRIPTION" \
      --arg prompt "$PROMPT" \
      --arg tool_name "Task" \
      --argjson timestamp "$START_TIMESTAMP" \
      --arg transcript_path "$TRANSCRIPT_PATH" \
      --arg cwd "$CWD" \
      --arg project_name "$PROJECT_NAME" \
      '{
        process_id: $process_id,
        session_id: $session_id,
        parent_process_id: $parent_process_id,
        agent_id: $agent_id,
        title: $title,
        prompt: $prompt,
        tool_name: $tool_name,
        timestamp: $timestamp,
        transcript_path: $transcript_path,
        cwd: $cwd,
        project_name: $project_name
      }')

    HTTP_STATUS=$(curl -X POST https://agent-meeting-room.up.railway.app/webhooks/process/start \
      -H "Content-Type: application/json" \
      -d "$PAYLOAD" \
      --silent --output /dev/null --write-out "%{http_code}")

    echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] SUBAGENT-STOP: Webhook /process/start returned HTTP $HTTP_STATUS" >> "$DEBUG_LOG"

    # Immediately mark it as completed (use +1 second to avoid duplicate status change IDs)
    COMPLETE_PAYLOAD=$(jq -n \
      --arg process_id "$CHILD_PROCESS_ID" \
      --arg status "COMPLETED" \
      --argjson timestamp "$COMPLETE_TIMESTAMP" \
      '{
        process_id: $process_id,
        status: $status,
        timestamp: $timestamp
      }')

    HTTP_STATUS=$(curl -X POST https://agent-meeting-room.up.railway.app/webhooks/process/complete \
      -H "Content-Type: application/json" \
      -d "$COMPLETE_PAYLOAD" \
      --silent --output /dev/null --write-out "%{http_code}")

    echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] SUBAGENT-STOP: Webhook /process/complete returned HTTP $HTTP_STATUS" >> "$DEBUG_LOG"

    # Clean up the mapping files and lock
    rm -f "${BASE_KEY}".* 2>/dev/null
    rmdir "$LOCK_DIR/$TASK_KEY.lock" 2>/dev/null
    echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] SUBAGENT-STOP: Cleaned up metadata files and lock for '$BASE_KEY'" >> "$DEBUG_LOG"
  else
    # No unlocked mapping found
    echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] SUBAGENT-STOP: WARNING - No available metadata file (timeout or no files)" >> "$DEBUG_LOG"
    # Don't create orphan process - just exit silently
    exit 0
  fi
else
  echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] SUBAGENT-STOP: ERROR - Mapping directory does not exist!" >> "$DEBUG_LOG"
  exit 0
fi

exit 0
