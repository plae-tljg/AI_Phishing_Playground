#!/bin/bash
set -e

REPO_DIR="/workspace/repo"
GOAL_FILE="$REPO_DIR/GOAL.md"

if [ ! -f "$GOAL_FILE" ]; then
    echo "ERROR: GOAL.md not found at $GOAL_FILE"
    exit 1
fi

cd "$REPO_DIR"

echo "[$(date)] Starting AI agent loop..."
echo "  PUSH_ENABLED=${PUSH_ENABLED:-false}"
echo "  LOOP_INTERVAL=${AGENT_LOOP_INTERVAL:-5}s"
echo ""

while true; do
    echo "[$(date)] Running opencode..."

    opencode run "Read GOAL.md and NEXT.md (if exists). Execute tasks. Update NEXT.md with progress. Commit changes with clear messages."

    if [ $? -eq 0 ]; then
        if [ "${PUSH_ENABLED:-false}" = "true" ]; then
            echo "[$(date)] Pushing to GitHub..."
            git push 2>&1 || echo "[$(date)] Push failed (will retry next loop)"
        else
            echo "[$(date)] PUSH_ENABLED=false — skipping push"
        fi
        echo "[$(date)] Iteration complete"
    else
        echo "[$(date)] Task failed, retrying in ${AGENT_RETRY_DELAY:-60}s..."
        sleep "${AGENT_RETRY_DELAY:-60}"
    fi

    sleep "${AGENT_LOOP_INTERVAL:-5}"
done
