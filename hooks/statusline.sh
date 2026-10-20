#!/bin/bash
# Status line: model · repo:branch · Jira key · context % · cost. Also saves context % for handoff-nudge.sh.
input=$(cat)
model=$(jq -r '.model.display_name // "?"' <<<"$input")
dir=$(jq -r '.workspace.current_dir // .cwd // empty' <<<"$input")
sid=$(jq -r '.session_id // "nosession"' <<<"$input")
pct=$(jq -r '.context_window.used_percentage // 0' <<<"$input")
cost=$(jq -r '.cost.total_cost_usd // 0' <<<"$input")
pct=${pct%.*}
mkdir -p ~/.claude/hooks/state && echo "$pct" > ~/.claude/hooks/state/ctx-$sid
out="$model"
if branch=$(git -C "$dir" symbolic-ref --short -q HEAD 2>/dev/null); then
  out="$out · $(basename "$dir"):$branch"
  key=$(grep -oE '[A-Z][A-Z0-9]+-[0-9]+' <<<"$branch" | head -1)
  [ -n "$key" ] && out="$out · $key"
else
  out="$out · $(basename "$dir")"
fi
printf '%s · ctx %s%% · US$%.2f' "$out" "$pct" "$cost"
