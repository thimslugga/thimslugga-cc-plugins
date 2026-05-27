#!/bin/bash
set -u

# format.sh - PostToolUse hook (matcher: Edit|Write)
# Auto-formats the file Claude just wrote, using whichever formatter is
# installed for that file type. Missing formatters are skipped silently.
# This hook always exits 0: a formatting failure must never block the
# workflow.
#
# Reads the tool-call JSON on stdin and pulls .tool_input.file_path.

input=$(cat)

cmd_exist() {
  command -v "$1" >/dev/null 2>&1;
}

# Fail open if jq is missing rather than breaking every Bash call.
if ! cmd_exist jq; then
  exit 0
fi

file=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty')
[ -z "$file" ] && exit 0
[ -f "$file" ] || exit 0

case "$file" in
  *.js|*.mjs|*.cjs|*.ts|*.css|*.scss|*.html|*.htm|*.json|*.jsonc|*.json5|*.yaml|*.yml|.ansible-lint|.yamllint|*.bu|*.butane|*.ign|*.ignition)
    if cmd_exist oxfmt; then
      oxfmt --write -- "$file" >/dev/null 2>&1 ;
    elif [ -x "./node_modules/.bin/oxfmt" ]; then
      ./node_modules/.bin/oxfmt --write -- "$file" >/dev/null 2>&1 ;
    # Only use a project-local or globally installed prettier. Do not invoke
    # npx here: it can trigger a slow network download inside the hook.
    elif cmd_exist prettier; then
      prettier --write --log-level silent -- "$file" >/dev/null 2>&1
    elif [ -x "./node_modules/.bin/prettier" ]; then
      ./node_modules/.bin/prettier --write --log-level silent -- "$file" >/dev/null 2>&1
    fi
    ;;
  *.sh|*.bash|*.zsh)
    cmd_exist shfmt && shfmt -w -i 2 -ci -sr -- "$file" >/dev/null 2>&1
    ;;
  *.py|*.pyi)
    if cmd_exist ruff; then
      ruff format -- "$file" >/dev/null 2>&1
      ruff check --fix --quiet -- "$file" >/dev/null 2>&1
    elif cmd_exist black; then
      black --quiet -- "$file" >/dev/null 2>&1
    fi
    ;;
  *.rs)
    cmd_exist rustfmt && rustfmt --quiet -- "$file" >/dev/null 2>&1
    ;;
  *.go)
    cmd_exist gofmt && gofmt -w -- "$file" >/dev/null 2>&1
    ;;
esac

exit 0
