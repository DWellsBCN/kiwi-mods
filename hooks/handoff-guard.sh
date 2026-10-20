#!/bin/bash
# PreCompact hook: block a manual /compact in a git repo while docs/dave/handoff.md is missing or over 30 minutes old.
# Auto compaction is never blocked: blocking it can fail a request that is recovering from a context-limit error.
input=$(cat)
[ "$(jq -r '.trigger // empty' <<<"$input")" = "manual" ] || exit 0
cwd=$(jq -r '.cwd // empty' <<<"$input")
cd "$cwd" 2>/dev/null && git rev-parse --git-dir >/dev/null 2>&1 || exit 0
f=docs/dave/handoff.md
[ -f "$f" ] && [ -n "$(find "$f" -mmin -30 2>/dev/null)" ] && exit 0
echo "Handoff is missing or stale. Ask Claude to write docs/dave/handoff.md, then /compact again." >&2
exit 2
