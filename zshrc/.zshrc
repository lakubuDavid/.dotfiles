source ~/.zsh/catppuccin_frappe-zsh-syntax-highlighting.zsh
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH


# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# User configuration

export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

export NODE_EXTRA_CA_CERTS="$(mkcert -CAROOT)/rootCA.pem"
export EMSDK_QUIET=1
export DENO_INSTALL="/Users/davidlakubu/.deno"
export GRADLE_INSTALL="/Users/davidlakubu/gradle-7.5"
export PSPDEV=/usr/local/pspdev
export PATH="$GRADLE_INSTALL/bin:$DENO_INSTALL/bin:$PSPDEV/bin:$PATH"
# HELIX AS DEFAULT EDITOR FOR CLI TOOLS
export EDITOR=hx


if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

export PATH="$PATH:/Users/davidlakubu/flutter/bin"
# bun completions
# [ -s "/Users/davidlakubu/.bun/_bun" ] && source "/Users/davidlakubu/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# bun apps
export PATH="$HOME/bun/bin:$PATH"
alias love-export=/Users/davidlakubu/love-export/main.sh
alias love-export=/Users/davidlakubu/tools/love-export/main.sh

#php
export PATH="/Applications/XAMPP/bin:$PATH"

#zsh colors
# autoload -Uz vcs_info
# precmd() { vcs_info }

# zstyle ':vcs_info:git:*' formats '(%b)'

# setopt PROMPT_SUBST
# PROMPT='%F{green}%*%f %F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '
# PROMPT=' %F{green}%n%f %F{magenta}%~%f %B%F{cyan}${vcs_info_msg_0_}%f%b %F{magenta}•%f '
# PROMPT='%F{magenta}%~%f%B%F{cyan}${vcs_info_msg_0_}%f%b%F{cyan} ❯%f'


# android
# export JAVA_HOME="$HOME/Applications/Android Studio.app/Contents/jbr/Contents/Home"
# export JAVA_HOME="/usr/local/opt/openjdk/bin"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export NDK_HOME="$ANDROID_HOME/ndk/29.0.13846066"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/tools/bin"

export OPEN_JDK_HOME="/usr/local/opt/openjdk"
export JAVA_HOME="$OPEN_JDK_HOME"
export PATH="$OPEN_JDK_HOME/bin:$PATH"
export CPPFLAGS="-I$OPEN_JDK_HOME/include"

PATH="~/.console-ninja/.bin:$PATH"
export PATH="$PATH:$HOME/.composer/vendor/bin"

#Docker
export PATH="$PATH:/usr/local/Cellar/docker/26.1.1/bin"

# test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# luarocks
export LUAROCKS="/usr/local/Cellar/luarocks/3.11.0/share/lua/5.4/luarocks"

# torch
# ./Users/davidlakubu/torch/install/bin/torch-activate

# yazi

function yaz() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

#STARTUP MESSAGE
source ~/.config/startup.sh

# Shell integration
eval "$(brew shellenv)"
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
# eval "$(thefuck --alias)"
# eval "$(chezmoi completion zsh)"
# tere
echo " • Loaded Shell integration"

tere() {
    local result=$(command tere "$@")
    [ -n "$result" ] && cd -- "$result"
}

# glow custom command

function gn() {
    (cd "$~/Users/davidlakubu/ObsidianVault/David's Vault/David's Vault" && glow)
}

# walk

function lk {
	if [ -n "$@" ]; then
    cd "$(walk --icons "$@")"
	else
    cd "$(walk "$@")"
	fi
  #cd "$(walk --icons "$@")"
}

export WALK_EDITOR=hx

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

#zellij

#eval "$(zellij setup --generate-auto-start zsh)"

#docker
export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"

#penpot
export PENPOT_DIR="penpot"

function penpot_start {
	z "${PENPOT_DIR}"

	podman-compose -p penpot -f docker-compose.yaml up -d
}

function penpot_stop {
	z "${PENPOT_DIR}"

	podman-compose -p penpot -f docker-compose.yaml down
}


function dotconfigs() {
	hx ~/.dotfiles
}

# For go apps
export GOPATH=$HOME/go
export PATH="$PATH:$GOPATH/bin"

# Atac : TUI Postman like HTTP client
export ATAC_MAIN_DIR=$HOME/atac/http


#Ollama status TUI icon
function ollama-status() {
  if pgrep -x "ollama" > /dev/null; then
    if [ $(ps aux | grep -c '[o]llama') -gt 1 ]; then
      echo "running ($(ps aux | grep -c '[o]llama'))"
    else
      echo "idle"
    fi
  else
    echo "offline"
  fi
}

# V lang config
export PATH="$PATH:/Users/davidlakubu/.config/v-analyzer/bin/"

# Omnisharp
export PATH="$PATH:/Users/davidlakubu/omnisharp"

# eval "$(oh-my-posh init zsh --config https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/tokyonight_storm.omp.json)"
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config.omp.toml)"

# #fastfetch
# fastfetch

#pipx
# eval "$(register-python-argcomplete pipx)"
export COPILOT_API_KEY="$(pass ApiKeys/Github/Copilot)"


#netcoredbg
export PATH="$HOME/netcoredbg/:$PATH"

#llvm
export PATH="/usr/local/opt/llvm/bin:$PATH"

#macport
export PATH="/opt/local/bin:$PATH"

#piper tts alias
export PIPER_DATA="~/piper_data"
alias piper="piper --data-dir $PIPER_DATA"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# (( ! ${+functions[p10k]} )) || p10k finalize

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# zinit snippet OMZP::ssh
zinit snippet OMZP::fzf
# zinit snippet OMZP::themes
# zinit snippet OMZP::chezmoi

zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
# zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab
### End of Zinit's installer chunk
autoload -U compinit; compinit

# For better performance: (check zinit documentation)
zinit cdreplay -q


#My tools
export PATH="$PATH:/Users/davidlakubu/tools"

source /Users/davidlakubu/.config/broot/launcher/bash/br

#tere
tere() {
    local result=$(command tere "$@")
    [ -n "$result" ] && cd -- "$result"
}


# Emacs keybind
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

#history
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_find_no_dups
setopt auto_cd

#completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
echo " • Intialized zsh plugins"
#fzf
export FZF_DEFAULT_OPTS=" \
--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
--color=marker:#babbf1,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284 \
--color=selected-bg:#51576d \
--multi"

export PATH=$PATH:/Users/davidlakubu/.spicetify
# source "$(gopass completion zsh)"

source "/Users/davidlakubu/.config/zellij_tab_name.zsh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

echo " • Intialized nvm"

export HELIX_RUNTIME=~/.config/helix/runtime

source "/Users/davidlakubu/.config/aliases.zsh"
echo " • Intialized aliases"

# Python path
export PATH="$PATH:/Library/Frameworks/Python.framework/Versions/3.11/bin"
# alias tsgo="/Users/davidlakubu/Code/typescript-go/built/local/tsgo"

# PMD
export PATH="$PATH:$HOME/pmd-bin-7.13.0/bin"

# dotnet ttools
export PATH="$PATH:$HOME/.dotnet/tools"

export RESEND_API_KEY=$(pass show ApiKeys/RESEND_API_KEY)

export PATH="$PATH:$HOME/.local/bin"
# tput cuu 4
clear

# Dprint

export DPRINT_INSTALL="/Users/davidlakubu/.dprint"
export PATH="$DPRINT_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/davidlakubu/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

PATH=~/.console-ninja/.bin:$PATH
