#!/bin/sh
# bootstrap.sh - Self-contained machine setup helper
# Usage:
#   Fresh machine:   curl -fsSL https://raw.githubusercontent.com/lakubudavid/.dotfiles/main/bootstrap.sh | sh
#   Reactivation:    curl -fsSL .../bootstrap.sh | sh -- --stow
#   Existing setup:  ./bootstrap.sh --stow

set -eu

DOTFILES_REPO="https://github.com/lakubudavid/.dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

# If we're running from a cloned repo, use that
if [ -f "$DOTFILES_DIR/bootstrap.lua" ]; then
  exec lua "$DOTFILES_DIR/bootstrap.lua" "$@"
fi

# Fresh machine: bootstrap.lua not found locally
# Install brew + lua if missing, clone repo, then run bootstrap.lua
echo "bootstrap.lua not found — bootstrapping fresh machine..."

# 1. Install Homebrew if missing
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Make brew available
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi

# 2. Install lua if missing
if ! command -v lua >/dev/null 2>&1; then
  echo "Installing lua..."
  brew install lua
fi

# 3. Clone dotfiles repo
echo "Cloning dotfiles..."
git clone "$DOTFILES_REPO" "$DOTFILES_DIR"

# 4. Run bootstrap.lua with all args
exec lua "$DOTFILES_DIR/bootstrap.lua" "$@"