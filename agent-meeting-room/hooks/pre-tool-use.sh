#!/bin/bash

echo "Hook triggered: pre-tool-use"

# Debug log file
DEBUG_LOG="/tmp/claude-hook-debug.log"

# Read JSON input from stdin
INPUT=$(cat)

# Extract hook data
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id')
TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input')
CWD=$(echo "$INPUT" | jq -r '.cwd')
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path')

# Log hook trigger
echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] PRE-TOOL-USE: Hook fired for tool '$TOOL_NAME' in session '$SESSION_ID'" >> "$DEBUG_LOG"

# Get the current process ID for this session
PROCESS_TRACKING_DIR="/tmp/claude-current-process"
CURRENT_PROCESS_ID=$(cat "$PROCESS_TRACKING_DIR/$SESSION_ID" 2>/dev/null)

echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] PRE-TOOL-USE: Current process ID = '$CURRENT_PROCESS_ID'" >> "$DEBUG_LOG"

# Mark that at least one tool has been executed for this process
TOOL_EXECUTION_DIR="/tmp/claude-tool-executed"
mkdir -p "$TOOL_EXECUTION_DIR"
echo "1" > "$TOOL_EXECUTION_DIR/$CURRENT_PROCESS_ID"

# Only process Task tool invocations (agent spawning)
if [ "$TOOL_NAME" = "Task" ]; then
  echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] PRE-TOOL-USE: Task tool detected! Processing agent spawn..." >> "$DEBUG_LOG"

  # Extract task details
  DESCRIPTION=$(echo "$TOOL_INPUT" | jq -r '.description // "Untitled Task"')
  PROMPT=$(echo "$TOOL_INPUT" | jq -r '.prompt // ""')

  echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] PRE-TOOL-USE: Task description = '$DESCRIPTION'" >> "$DEBUG_LOG"

  # Get project name from environment variable, fallback to CWD basename
  PROJECT_NAME="${CLAUDE_HOOK_PROJECT_NAME:-}"
  if [ -z "$PROJECT_NAME" ] && [ -n "$CWD" ]; then
    PROJECT_NAME=$(basename "$CWD")
  fi

  # Store parent process context for subagent-stop hook to use
  # The subprocess will read this when it stops to link itself to the current process
  MAPPING_DIR="/tmp/claude-agent-sessions"
  mkdir -p "$MAPPING_DIR"

  # Use a timestamp-based key to handle multiple concurrent tasks
  TASK_KEY="task-$(date +%s%N)"

  echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] PRE-TOOL-USE: Creating metadata files with key '$TASK_KEY'" >> "$DEBUG_LOG"

  echo "$CURRENT_PROCESS_ID" > "$MAPPING_DIR/${TASK_KEY}.parent"
  echo "$SESSION_ID" > "$MAPPING_DIR/${TASK_KEY}.session"
  echo "$DESCRIPTION" > "$MAPPING_DIR/${TASK_KEY}.description"
  echo "$PROMPT" > "$MAPPING_DIR/${TASK_KEY}.prompt"
  echo "$CWD" > "$MAPPING_DIR/${TASK_KEY}.cwd"
  echo "$TRANSCRIPT_PATH" > "$MAPPING_DIR/${TASK_KEY}.transcript"
  echo "$PROJECT_NAME" > "$MAPPING_DIR/${TASK_KEY}.project"

  # Verify files were created
  if [ -f "$MAPPING_DIR/${TASK_KEY}.parent" ] && [ -f "$MAPPING_DIR/${TASK_KEY}.session" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] PRE-TOOL-USE: SUCCESS - Metadata files created at '$MAPPING_DIR/${TASK_KEY}.*'" >> "$DEBUG_LOG"
    echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] PRE-TOOL-USE: Files in directory: $(ls -1 $MAPPING_DIR | wc -l)" >> "$DEBUG_LOG"
  else
    echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] PRE-TOOL-USE: ERROR - Failed to create metadata files!" >> "$DEBUG_LOG"
  fi
else
  echo "[$(date '+%Y-%m-%d %H:%M:%S.%N')] PRE-TOOL-USE: Not a Task tool (tool='$TOOL_NAME'), skipping agent tracking" >> "$DEBUG_LOG"
fi

# Exit 0 to allow the tool to proceed
exit 0
