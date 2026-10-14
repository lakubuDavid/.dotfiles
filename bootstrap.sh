#!/bin/sh
set -eu

DOTFILES_REPO="https://github.com/lakubudavid/.dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

# Check for local bootstrap.lua
if [ -f "$DOTFILES_DIR/bootstrap.lua" ]; then
  exec lua "$DOTFILES_DIR/bootstrap.lua" "$@"
fi

echo "Bootstrap initializing (arguments: $#)"

# Install Homebrew if missing
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
fi

# Install lua if missing
if ! command -v lua >/dev/null 2>&1; then
  echo "Installing lua..."
  brew install lua
fi

# Clone dotfiles repo if missing
if [ ! -d "$DOTFILES_DIR" ]; then
  echo "Cloning dotfiles..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# Update to latest
cd "$DOTFILES_DIR"
git pull --ff-only origin main

# Run bootstrap.lua with all arguments
exec lua "$DOTFILES_DIR/bootstrap.lua" "$@"