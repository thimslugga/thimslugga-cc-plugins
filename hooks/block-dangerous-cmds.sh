#!/bin/bash
set -u

# block-dangerous-cmds.sh - PreToolUse hook (matcher: Bash)
# Blocks a small set of catastrophic shell commands. Reads the tool-call
# JSON on stdin and exits 2 to block, which feeds the stderr message back
# to Claude. Exit 0 means "no opinion" and the normal permission flow continues.
#
# This is a convenience guard, not a security boundary. Keep the pattern list
# short and obvious so it is easy to audit and reason about.

input=$(cat)

cmd_exist() {
  command -v "$1" >/dev/null 2>&1
}

# Fail open if jq is missing rather than breaking every Bash call.
if ! cmd_exist jq; then
  exit 0
fi


cmd=$(printf '%s' "$input" | jq -r '.tool_input.command // empty')
[ -z "$cmd" ] && exit 0

block_cmd() {
  echo "BLOCKED by block-dangerous-cmds.sh: $1" >&2
  echo "Command: $cmd" >&2
  echo "If this is genuinely intended, run it yourself outside Claude Code." >&2
  exit 2
}

# Normalise whitespace so simple patterns are easier to match.
norm=$(printf '%s' "$cmd" | tr -s '[:space:]' ' ')

# Helper: test $norm against a regex.
matches() {
  printf '%s' "$norm" | grep -Eq "$1";
}

# Deletion targeting the whole filesystem root or the whole home directory.
# Matches: rm <flags> followed by exactly /, ~, or $HOME with an optional
# trailing slash or /*. A scoped path like rm -rf $HOME/cache is NOT matched
# (rm is already in the settings.json "ask" list, so it still prompts).
# Note: /home/user/... paths are not matched; this catches only / ~ and $HOME.
# shellcheck disable=SC2016  # $HOME is a literal regex token, not a shell expansion
if matches 'rm +(-[^ ]+ +)*(/|~|\$HOME)/?\*?( |$)'; then
  block_cmd "recursive delete targeting / or \$HOME"
fi

# Classic fork bomb. Note: unusual whitespace variants may not be caught.
if matches ':\(\) *\{ *:\|: *& *\} *;:'; then
  block_cmd "fork bomb"
fi

# Filesystem creation / raw device writes.
if matches '\bmkfs(\.[a-z0-9]+)?\b'; then
  block_cmd "mkfs (filesystem format)"
fi
if matches '\bdd\b.* of=/dev/'; then
  block_cmd "dd writing to a raw device"
fi
if matches '> */dev/(sd|nvme|hd|disk)'; then
  block_cmd "redirect into a raw block device"
fi

# Overwriting system directories.
if matches '> */(etc|bin|sbin|boot|usr)/'; then
  block_cmd "redirect overwriting a system path"
fi
if matches '\bchmod +(--recursive|-R +)?0?777 +/'; then
  block_cmd "chmod 777 on a root path"
fi

# Piping a remote download straight into a shell.
if matches '(curl|wget)\b.*\|[[:space:]]*(sudo[[:space:]]+)?(sh|bash|zsh|python3?)\b'; then
  block_cmd "piping a remote download into a shell interpreter"
fi

# Force-pushing to a protected branch.
if matches 'git +push\b.*(--force|-f)\b.*\b(main|master|production|release)\b'; then
  block_cmd "force-push to a protected branch"
fi

exit 0
