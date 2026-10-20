#!/bin/bash
# Stop hook: once per session, when context passes 66% (written by statusline.sh), ask for docs/dave/handoff.md if it is stale.
input=$(cat)
[ "$(jq -r '.stop_hook_active // false' <<<"$input")" = "true" ] && exit 0
cwd=$(jq -r '.cwd // empty' <<<"$input")
sid=$(jq -r '.session_id // "nosession"' <<<"$input")
state=~/.claude/hooks/state
pct=$(cat "$state/ctx-$sid" 2>/dev/null || echo 0)
[ "${pct%.*}" -ge 66 ] 2>/dev/null || exit 0
cd "$cwd" 2>/dev/null && git rev-parse --git-dir >/dev/null 2>&1 || exit 0
[ -e "$state/handoff-$sid" ] && exit 0
f=docs/dave/handoff.md
[ -f "$f" ] && [ -n "$(find "$f" -mmin -30 2>/dev/null)" ] && exit 0
touch "$state/handoff-$sid"
jq -n --arg r "Context is at ${pct%.*}%. Write docs/dave/handoff.md now (where the work got to, decisions and why, parked list, open loops, exact next step; ten lines), then carry on." '{decision:"block",reason:$r}'
