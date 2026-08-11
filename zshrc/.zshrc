# shellcheck shell=bash
# ─────────────────────────────────────────────────────────────────────────────
# .zshrc - Optimized with inheritance guards
# ─────────────────────────────────────────────────────────────────────────────

# PATH dedup helper to prevent duplicates
add_to_path() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$1:$PATH" ;;
  esac
}

# ─────────────────────────────────────────────────────────────────────────────
# 1. BREW & MISE FIRST (so their tools are on PATH for everything else)
# ─────────────────────────────────────────────────────────────────────────────
eval "$(brew shellenv)"
eval "$(mise activate zsh)"

# ─────────────────────────────────────────────────────────────────────────────
# 2. SYNTAX HIGHLIGHTING (load early for proper coloring)
# ─────────────────────────────────────────────────────────────────────────────
# shellcheck source=/dev/null
source "$HOME/.zsh/catppuccin_frappe-zsh-syntax-highlighting.zsh"

# ─────────────────────────────────────────────────────────────────────────────
# 3. BASIC ENVIRONMENT
# ─────────────────────────────────────────────────────────────────────────────
# PATH already has $HOME/bin and /usr/local/bin from .zprofile, don't re-add
TMPDIR="$(getconf DARWIN_USER_TEMP_DIR)"
export TMPDIR
CASE_SENSITIVE="true"  # Used by completion system
COMPLETION_WAITING_DOTS="true"  # Used by completion system
export PAGER="moor"
fpath+=(~/.zfunc)
MANPATH="/usr/local/man:${MANPATH:-}"
export MANPATH
LANG=en_US.UTF-8
export LANG
EDITOR=hx
export EDITOR

# ─────────────────────────────────────────────────────────────────────────────
# 4. TOOL ENV VARS & PATHS (no duplicates)
# ─────────────────────────────────────────────────────────────────────────────
# Node
NODE_CERTS="$(mkcert -CAROOT)/rootCA.pem"
export NODE_EXTRA_CA_CERTS="$NODE_CERTS"

# Deno
EMSDK_QUIET=1
export EMSDK_QUIET
DENO_INSTALL="$HOME/.deno"
export DENO_INSTALL
add_to_path "$DENO_INSTALL/bin"

# PSP
PSPDEV=/usr/local/pspdev
export PSPDEV
add_to_path "$PSPDEV/bin"

# Bun
BUN_INSTALL="$HOME/.bun"
export BUN_INSTALL
add_to_path "$BUN_INSTALL/bin"
add_to_path "$HOME/bun/bin"

# Android & Java
ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_HOME
NDK_HOME="$ANDROID_HOME/ndk/29.0.13846066"
export NDK_HOME
add_to_path "$ANDROID_HOME/tools"
add_to_path "$ANDROID_HOME/tools/bin"
OPEN_JDK_HOME="/usr/local/opt/openjdk"
export OPEN_JDK_HOME
JAVA_HOME="$OPEN_JDK_HOME"
export JAVA_HOME
add_to_path "$OPEN_JDK_HOME/bin"
CPPFLAGS="-I$OPEN_JDK_HOME/include"
export CPPFLAGS

# Misc tools
add_to_path "$HOME/.console-ninja/.bin"
add_to_path "$HOME/.composer/vendor/bin"
add_to_path "/Applications/Docker.app/Contents/Resources/bin"

# Go
GOPATH="$HOME/go"
export GOPATH
add_to_path "$GOPATH/bin"
ATAC_MAIN_DIR="$HOME/atac/http"
export ATAC_MAIN_DIR

# Dev tools
add_to_path "$HOME/.config/v-analyzer/bin"
add_to_path "$HOME/omnisharp"
add_to_path "/usr/local/opt/llvm/bin"
add_to_path "/opt/local/bin"
add_to_path "$HOME/tools"
add_to_path "$HOME/.config/scripts"
add_to_path "$HOME/.spicetify"
add_to_path "$HOME/.gem/ruby/2.6.0/bin"
add_to_path "/usr/local/opt/ruby@3.3/bin"
add_to_path "/Library/Frameworks/Python.framework/Versions/3.11/bin"
add_to_path "$HOME/pmd-bin-7.13.0/bin"
add_to_path "$HOME/.dotnet/tools"
add_to_path "$HOME/.local/bin"

# Dprint
DPRINT_INSTALL="$HOME/.dprint"
export DPRINT_INSTALL
add_to_path "$DPRINT_INSTALL/bin"

# pnpm
PNPM_HOME="$HOME/Library/pnpm"
export PNPM_HOME
add_to_path "$PNPM_HOME"

# libpq
add_to_path "/usr/local/opt/libpq/bin"
LDFLAGS="-L/usr/local/opt/libpq/lib"
export LDFLAGS
CPPFLAGS="$CPPFLAGS -I/usr/local/opt/libpq/include"
export CPPFLAGS
PKG_CONFIG_PATH="/usr/local/opt/libpq/lib/pkgconfig"
export PKG_CONFIG_PATH

# Tex
MANTPATH="${MANTPATH:+$MANTPATH:}$HOME/2025/texmf-dist/doc/man"
export MANTPATH
INFOPATH="${INFOPATH:+$INFOPATH:}$HOME/2025/texmf-dist/doc/info"
export INFOPATH

# Piper
PIPER_DATA="$HOME/piper_data"
export PIPER_DATA
alias piper="piper --data-dir $PIPER_DATA"

# Helix
HELIX_RUNTIME="$HOME/.config/helix/runtime"
export HELIX_RUNTIME

# Penpot
PENPOT_DIR="penpot"
export PENPOT_DIR

# Walk
WALK_EDITOR=hx
export WALK_EDITOR

# ─────────────────────────────────────────────────────────────────────────────
# 5. EVALS THAT DEFINE FUNCTIONS (must run per shell - NOT inherited)
# ─────────────────────────────────────────────────────────────────────────────
# fzf (defines key bindings + __fzf_* functions)
eval "$(fzf --zsh)"

# zoxide (defines z() function)
eval "$(zoxide init zsh)"

# oh-my-posh (defines prompt)
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config.omp.toml)"

# ─────────────────────────────────────────────────────────────────────────────
# 6. ZINIT + PLUGINS (must run per shell - NOT inherited)
# ─────────────────────────────────────────────────────────────────────────────
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
[ ! -d "$ZINIT_HOME" ] && mkdir -p "$(dirname "$ZINIT_HOME")"
[ ! -d "$ZINIT_HOME/.git" ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
# shellcheck source=/dev/null
source "${ZINIT_HOME}/zinit.zsh"

zinit snippet OMZP::fzf
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab

# compinit - use cache if fresh (within 24h), otherwise rebuild
autoload -U compinit
if [[ -s "$HOME/.zcompdump" ]] && [[ $(find "$HOME/.zcompdump" -mmin -1440 2>/dev/null) ]]; then
  compinit -C  # fast: use cache (~50ms)
else
  compinit     # slow: rebuild cache (~2.5s, but only once per day)
fi

zinit cdreplay -q

# ─────────────────────────────────────────────────────────────────────────────
# 7. BROOT & ENVMAN
# ─────────────────────────────────────────────────────────────────────────────
# shellcheck source=/dev/null
source "$HOME/.config/broot/launcher/bash/br"
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# ─────────────────────────────────────────────────────────────────────────────
# 8. MOLE COMPLETION (guarded - only in fresh shells, saves 610ms)
# ─────────────────────────────────────────────────────────────────────────────
if [[ -z "$__ZSHRC_LOADED" ]]; then
  if output="$(mole completion zsh 2>/dev/null)"; then eval "$output"; fi
fi

# ─────────────────────────────────────────────────────────────────────────────
# 9. ALIASES & FUNCTIONS (not inherited, must redefine per shell)
# ─────────────────────────────────────────────────────────────────────────────
# shellcheck source=/dev/null
source "$HOME/.config/aliases.zsh"

# Yazi wrapper
yaz() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd" || return
  fi
  rm -f -- "$tmp"
}

# tere wrapper
tere() {
  local result
  result="$(command tere "$@")"
  [ -n "$result" ] && cd -- "$result" || return
}

# walk wrapper
lk() {
  if [ -n "$*" ]; then
    cd "$(walk --icons "$*")" || return
  else
    cd "$(walk)" || return
  fi
}

# glow in obsidian vault
gn() {
  (cd "$HOME/ObsidianVault/David's Vault" && glow) || return
}

# penpot
penpot_start() { z "$PENPOT_DIR" && podman-compose -p penpot -f docker-compose.yaml up -d; }
penpot_stop() { z "$PENPOT_DIR" && podman-compose -p penpot -f docker-compose.yaml down; }
dotconfigs() { hx ~/.dotfiles; }

# ollama status
ollama-status() {
  if pgrep -x "ollama" > /dev/null; then
    local count
    count="$(pgrep -c ollama)"
    if [ "$count" -gt 1 ]; then
      echo "running ($count)"
    else
      echo "idle"
    fi
  else
    echo "offline"
  fi
}

# ─────────────────────────────────────────────────────────────────────────────
# 10. SHELL OPTIONS & BINDINGS (not inherited)
# ─────────────────────────────────────────────────────────────────────────────
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE  # Used by zsh history system
HISTDUP=erase  # Used by zsh history system
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups hist_find_no_dups auto_cd

# ─────────────────────────────────────────────────────────────────────────────
# 11. COMPLETION STYLING (not inherited)
# ─────────────────────────────────────────────────────────────────────────────
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# shellcheck disable=SC2296
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
# shellcheck disable=SC2016
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept

# ─────────────────────────────────────────────────────────────────────────────
# 12. FZF OPTIONS
# ─────────────────────────────────────────────────────────────────────────────
export FZF_DEFAULT_OPTS=" \
--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
--color=marker:#babbf1,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284 \
--color=selected-bg:#51576d \
--multi"

# ─────────────────────────────────────────────────────────────────────────────
# 13. EMAIL / MISC ENV
# ─────────────────────────────────────────────────────────────────────────────
POP_FROM=pop@lakubudavid.me
export POP_FROM
POP_SIGNATURE="Sent with [Pop](https://github.com/charmbracelet/pop)!"
export POP_SIGNATURE

# ─────────────────────────────────────────────────────────────────────────────
# 14. API KEYS VIA PASS (commented out - too slow, ~7.3s)
#     Uncomment if you need these API keys
# ─────────────────────────────────────────────────────────────────────────────
if [[ -z "$__ZSHRC_LOADED" ]]; then
  RESEND_API_KEY="$(pass show ApiKeys/RESEND_API_KEY)"
  export RESEND_API_KEY
  OPENROUTER_API_KEY="$(pass show ApiKeys/OpenRouter)"
  export OPENROUTER_API_KEY
  OPENCODE_API_KEY="$(pass show ApiKeys/OpencodeZen)"
  export OPENCODE_API_KEY
  export __ZSHRC_LOADED=1
fi

# ─────────────────────────────────────────────────────────────────────────────
# 15. STARTUP MESSAGE (only in fresh terminal windows, not zellij/tmux)
# ─────────────────────────────────────────────────────────────────────────────
if [[ -z "$ZELLIJ" && -z "$TMUX" ]]; then
  # shellcheck source=/dev/null
  source "$HOME/.config/startup.sh"
fi
