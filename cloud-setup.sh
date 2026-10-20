#!/bin/bash
# Cloud environment setup script: installs David's Claude Code mods on a fresh cloud VM.
# Paste into the environment's setup script field:
#   curl -fsSL https://raw.githubusercontent.com/DWellsBCN/kiwi-mods/main/cloud-setup.sh | bash
set -euo pipefail
DEST="$HOME/.claude/kiwi-mods"
mkdir -p "$HOME/.claude"
rm -rf "${DEST:?}"
if ! git clone -q --depth 1 https://github.com/DWellsBCN/kiwi-mods.git "$DEST" 2>/dev/null; then
  mkdir -p "$DEST" && curl -fsSL https://codeload.github.com/DWellsBCN/kiwi-mods/tar.gz/refs/heads/main | tar -xz -C "$DEST" --strip-components=1
fi
mkdir -p "$HOME/.claude/hooks/state"
cp "$DEST"/hooks/*.sh "$HOME/.claude/hooks/" && chmod +x "$HOME/.claude/hooks/"*.sh

# merge into any existing user settings rather than replacing them
S="$HOME/.claude/settings.json"
[ -s "$S" ] || echo '{}' > "$S"
jq --arg plug "$DEST/plugins/predator-free" '
  .env = ((.env // {}) + {CLAUDE_CODE_PLUGIN_DIRS: $plug})
  | .statusLine = {type: "command", command: "~/.claude/hooks/statusline.sh"}
  | .hooks = (.hooks // {})
  | .hooks.Stop = [{hooks: [
      {type: "command", command: "~/.claude/hooks/review-gate.sh", timeout: 15},
      {type: "command", command: "~/.claude/hooks/handoff-nudge.sh", timeout: 10}]}]
  | .hooks.PreCompact = [{matcher: "manual", hooks: [
      {type: "command", command: "~/.claude/hooks/handoff-guard.sh", timeout: 10}]}]
' "$S" > "$S.tmp" && mv "$S.tmp" "$S"
echo "kiwi-mods installed: hooks, status line, predator-free (/kiwi)"
