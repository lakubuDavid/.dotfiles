# MIGRATION.md — new machine / OS switch

## Quick start

```bash
# Fresh machine — one-liner (handles brew + lua + dotfiles checkout)
curl -fsSL https://raw.githubusercontent.com/lakubudavid/.dotfiles/main/bootstrap.sh | sh -- --stow

# Existing setup — just re-run bootstrap with args
# bootstrap.sh --stow

# Manual steps (if preferred)
# macOS: Xcode CLT first
xcode-select --install

# Install Homebrew (macOS or Linux)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install lua git

# Clone dotfiles and run bootstrap
git clone https://github.com/lakubudavid/.dotfiles.git ~/.dotfiles
lua ~/.dotfiles/bootstrap.lua --stow
```

## What `bootstrap.lua` does

1. Installs Homebrew if missing (Linux: filters casks & mac-only taps from Brewfile)
2. Pulls latest dotfiles
3. `brew bundle` (all formulae + casks on macOS)
4. Stows packages — portable set everywhere, `borders/karabiner/skhd/yabai` macOS-only
5. `mise install` (all ~80 tools from `.config/mise/config.toml`)

Flags: `--dry` (print only), `--stow` (restow after conflicts).

## Manual steps (never automated — secrets)

| Step | Command / notes |
|---|---|
| GPG key | `gpg --import <key>` — required before pass works |
| pass store | `git clone https://github.com/lakubuDavid/pass-store.git ~/.password-store` |
| SSH keys | restore `~/.ssh/`, `chmod 600` |
| macOS perms | Karabiner-Elements + Accessibility + Input Monitoring prompts |
| Logins | App Store, JetBrains, licensed apps |

## Linux differences

- Casks don't exist — GUI apps (kitty, zed, browsers) come from distro packages
- `yabai/skhd/borders/karabiner` are skipped (mac-only)
- Brewfile is auto-filtered to `/tmp/Brewfile.linux`

## Restoring on this machine

Everything is stowed. If a config conflicts, delete the real file and:
`lua ~/.dotfiles/bootstrap.lua --stow`
