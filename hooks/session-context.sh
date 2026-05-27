#!/usr/bin/env bash
set -u

# session-context.sh - SessionStart hook
# Prints a short snapshot of the working tree so Claude
# starts each session knowing the branch, recent history, and what is dirty.
# For SessionStart, anything printed to stdout is added to Claude's context.
#
# Keep this fast: it runs on every session start and resume.

cmd_exist() {
  command -v "$1" >/dev/null 2>&1;
}

# Fail open if git is missing rather than breaking every Bash call.
if ! cmd_exist git; then
  exit 0
fi

# Not a git repo: nothing useful to report.
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

branch=$(git branch --show-current 2>/dev/null)
echo "Repository state at session start"
echo "  branch: ${branch:-(detached HEAD)}"

upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null)
if [ -n "$upstream" ]; then
  counts=$(git rev-list --left-right --count "HEAD...$upstream" 2>/dev/null)
  ahead=$(printf '%s' "$counts" | awk '{print $1}')
  behind=$(printf '%s' "$counts" | awk '{print $2}')
  echo "  vs $upstream: ${ahead:-0} ahead, ${behind:-0} behind"
fi

dirty=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
echo "  uncommitted changes: $dirty file(s)"
if [ "${dirty:-0}" -gt 0 ] && [ "${dirty:-0}" -le 12 ]; then
  git status --porcelain 2>/dev/null | sed 's/^/    /'
fi

echo "  recent commits:"
git log --oneline -n 3 2>/dev/null | sed 's/^/    /'

# Flag a Python virtualenv that exists but is not active, a common footgun.
if { [ -d .venv ] || [ -d venv ]; } && [ -z "${VIRTUAL_ENV:-}" ]; then
  echo "  Note: A python virtual environment directory exists but is not activated."
fi

exit 0
