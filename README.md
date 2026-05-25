# AI Trash Generator

Autonomous AI coding agent that writes code, commits to git, and pushes to GitHub in an infinite loop. Uses MiniMax API via OpenCode.

## Setup

### 1. Configure `.env`

```bash
cp .env.example .env
# Edit .env — paste your MINIMAX_API_KEY
# Set PUSH_ENABLED=true for GitHub push, false for local-only
```

### 2. Set up SSH (for push mode only)

```bash
ssh-keygen -t ed25519 -C "ai-trash-deploy-key" -f ./ai_trash -N ""
```

Add `ai_trash.pub` as a **Deploy Key** on your GitHub repo with **write access** enabled.

### 3. Clone your repo

```bash
GIT_SSH_COMMAND="ssh -i ./ai_trash" git clone git@github.com:YOUR_USERNAME/YOUR_REPO.git ./repo
```

### 4. Add files to the repo

```bash
cp GOAL.md ./repo/GOAL.md
cp run_loop.sh ./repo/run_loop.sh
cd ./repo
git add GOAL.md run_loop.sh
git commit -m "Add AI automation scripts"
git push
```

### 5. Launch

```bash
docker compose up --build -d
```

Everything is auto-configured: git identity, SSH known_hosts, OpenCode API.

### 6. Start the loop

```bash
docker compose exec opencode-agent bash -c "bash /workspace/repo/run_loop.sh"
```

Stop with `Ctrl+C`.

## Configuration

All settings live in `.env`:

| Variable | Default | Description |
|----------|---------|-------------|
| `MINIMAX_API_KEY` | (required) | MiniMax API key |
| `MINIMAX_API_BASE` | `https://api.minimax.io/v1` | API endpoint |
| `GIT_USER_NAME` | `AI Trash Generator` | Git commit author |
| `GIT_USER_EMAIL` | `ai-trash@localhost` | Git commit email |
| `PUSH_ENABLED` | `true` | Set to `false` for local-only |
| `AGENT_LOOP_INTERVAL` | `5` | Seconds between iterations |
| `AGENT_RETRY_DELAY` | `60` | Seconds before retry on failure |

## Bonus: MiniMax API scripts

The container mounts `../minimax_scripts` at `/minimax_scripts`. You can call:

```bash
docker compose exec opencode-agent bash
/minimax_scripts/scripts/01_chat.py "Hello"
/minimax_scripts/scripts/03_tts.py "Hello world" -o /tmp/test.mp3
```

## Docker Compose commands

```bash
docker compose up --build -d      # Build and start
docker compose exec ... bash      # Enter container
docker compose logs -f            # Follow logs
docker compose down               # Stop and remove
docker compose down -v            # Stop, remove, delete volumes
```
