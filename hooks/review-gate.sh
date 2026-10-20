#!/bin/bash
# Stop hook: block once per diff state when there are uncommitted changes and code-review hasn't run this session.
input=$(cat)
[ "$(jq -r '.stop_hook_active // false' <<<"$input")" = "true" ] && exit 0
cwd=$(jq -r '.cwd // empty' <<<"$input")
tp=$(jq -r '.transcript_path // empty' <<<"$input")
sid=$(jq -r '.session_id // "nosession"' <<<"$input")
cd "$cwd" 2>/dev/null || exit 0
git rev-parse --verify -q HEAD >/dev/null 2>&1 || exit 0
git diff HEAD --quiet 2>/dev/null && exit 0
if [ -n "$tp" ] && grep -qE '"skill":"[^"]*code-review|<command-name>/[^<]*code-review' "$tp" 2>/dev/null; then exit 0; fi
state=~/.claude/hooks/state
find "$state" -type f -mtime +7 -delete 2>/dev/null
hash=$(git diff HEAD 2>/dev/null | { shasum 2>/dev/null || sha1sum; } | cut -c1-12)
mark="$state/review-$sid-$hash"
[ -e "$mark" ] && exit 0
touch "$mark"
n=$(git diff HEAD --name-only | wc -l | tr -d ' ')
jq -n --arg r "Uncommitted changes in $n file(s) and code-review has not run this session. Run the code-review skill on the diff before calling this done, or say in one line why it is skipped." '{decision:"block",reason:$r}'
