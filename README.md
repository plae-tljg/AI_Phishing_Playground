# AI Trash Generator

让 OpenCode 自动帮你写代码并推送到 GitHub。

## 准备工作

### 1. 生成 SSH 密钥

```bash
ssh-keygen -t ed25519 -C "ai-trash-deploy-key" -f ./ai_trash -N ""
```

### 2. 添加 Deploy Key 到 GitHub

1. 打开你的 GitHub 仓库 → **Settings** → **Deploy keys** → **Add key**
2. 粘贴 `ai_trash.pub` 的内容
3. **勾选 "Allow write access"**
4. 点击 **Add key**

### 3. 克隆你的仓库

```bash
GIT_SSH_COMMAND="ssh -i ./ai_trash" git clone git@github.com:YOUR_USERNAME/YOUR_REPO.git ./repo
```

### 4. 添加必要的文件到仓库

```bash
# 复制 GOAL.md 到 repo (如果没有的话)
cp GOAL.md ./repo/GOAL.md

# 复制自动化脚本到 repo
cp run_loop.sh ./repo/run_loop.sh
```

### 5. 修改 GOAL.md

编辑 `./repo/GOAL.md`，填入你希望 AI 执行的任务指令。

### 6. 提交并推送这些文件

```bash
cd ./repo
git add GOAL.md run_loop.sh
git commit -m "添加 AI 自动化脚本"
git push
```

## 启动

```bash
docker compose up --build -d
```

容器启动后会保持运行。

## 进入容器

```bash
docker compose exec opencode-agent bash
```

## 首次配置 (只做一次)

在容器内运行：

```bash
ssh-keyscan -t ed25519 github.com >> ~/.ssh/known_hosts 2>/dev/null
chmod 600 ~/.ssh/id_ed25519
git config --global user.email "ai-trash@localhost"
git config --global user.name "AI Trash Generator"
opencode
```

进入 opencode 后用 `/connect` 配置你的 AI API。

## 开始自动化

```bash
bash /workspace/repo/run_loop.sh
```

会无限循环：AI 根据 GOAL.md 开发 → 提交 → 推送 → 重复。

按 `Ctrl+C` 停止。