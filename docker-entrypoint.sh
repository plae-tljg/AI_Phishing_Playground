#!/bin/bash
set -e

echo "=== AI Phishing Playground — Entrypoint ==="

# --------------------------------------------------
# 1. Git identity
# --------------------------------------------------
git config --global user.name  "${GIT_USER_NAME:-AI Trash Generator}"
git config --global user.email "${GIT_USER_EMAIL:-ai-trash@localhost}"
echo "[entrypoint] Git: ${GIT_USER_NAME:-AI Trash Generator} <${GIT_USER_EMAIL:-ai-trash@localhost}>"

# --------------------------------------------------
# 2. SSH known_hosts (only if PUSH_ENABLED)
# --------------------------------------------------
if [ "${PUSH_ENABLED:-false}" = "true" ]; then
    mkdir -p ~/.ssh
    ssh-keyscan -t ed25519 github.com >> ~/.ssh/known_hosts 2>/dev/null
    if [ -f "${SSH_KEY_PATH:-/root/.ssh/id_ed25519}" ]; then
        chmod 600 "${SSH_KEY_PATH:-/root/.ssh/id_ed25519}"
        echo "[entrypoint] SSH key configured"
    else
        echo "[entrypoint] WARNING: SSH key not found at ${SSH_KEY_PATH:-/root/.ssh/id_ed25519}"
    fi
    echo "[entrypoint] PUSH_ENABLED=true — will push to GitHub"
else
    echo "[entrypoint] PUSH_ENABLED=false — local commits only (no push)"
fi

# --------------------------------------------------
# 3. OpenCode API (from env, no /connect needed)
# --------------------------------------------------
if [ -n "${OPENAI_API_KEY}" ]; then
    echo "[entrypoint] API key detected (OPENAI_API_KEY)"
    echo "[entrypoint] API base: ${MINIMAX_API_BASE:-https://api.minimax.io/v1}"
    echo "[entrypoint] OpenCode uses OpenAI-compatible MiniMax endpoint"
else
    echo "[entrypoint] WARNING: OPENAI_API_KEY not set — run /connect inside opencode"
fi

# --------------------------------------------------
# 4. Verify mounts
# --------------------------------------------------
if [ -d /minimax_scripts/scripts ]; then
    echo "[entrypoint] minimax_scripts: mounted at /minimax_scripts"
else
    echo "[entrypoint] minimax_scripts: not mounted (optional)"
fi

if [ -f /workspace/repo/GOAL.md ]; then
    echo "[entrypoint] GOAL.md: found"
else
    echo "[entrypoint] WARNING: GOAL.md not found in /workspace/repo/"
fi

# --------------------------------------------------
# 5. Ready
# --------------------------------------------------
echo ""
echo "============================================"
echo "  Container ready"
echo ""
echo "  Start the loop:"
echo "    bash /workspace/repo/run_loop.sh"
echo ""
echo "  Manual dev:"
echo "    opencode"
echo "    /minimax_scripts/scripts/01_chat.py 'Hello'"
echo "============================================"
echo ""

exec tail -f /dev/null
