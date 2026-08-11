#!/bin/sh
# bootstrap.sh - Self-contained machine setup helper
# Usage:
#   1. Fresh machine: curl -fsSL https://raw.githubusercontent.com/lakubudavid/.dotfiles/main/bootstrap.sh | sh
#   2. Reactivation: curl -fsSL .../bootstrap.sh | sh -- --stow
#   3. Existing setup: ./bootstrap.sh --play <steps>

set -eu

# Determine bootstrap.lua location
BOOTSTRAP_DIR="${HOME:.dotfiles}"  # Should resolve to ~/.dotfiles when cloned
if [ ! -f "$BOOTSTRAP_DIR/bootstrap.lua" ]; then
  BOOTSTRAP_DIR="$HOME/.dotfiles"
fi

# Ensure bootstrap.lua exists
if [ ! -f "$BOOTSTRAP_DIR/bootstrap.lua" ]; then
  echo "ERROR: bootstrap.lua not found in $BOOTSTRAP_DIR" >&2
  echo "Run 'curl -fsSL .../bootstrap.sh | sh' to install bootstrap.lua" >&2
  exit 1
fi

# Execute with all passed arguments
exec lua "$BOOTSTRAP_DIR/bootstrap.lua" "$@"