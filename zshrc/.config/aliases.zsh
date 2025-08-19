alias zshconfig="hx ~/.zshrc"
alias mtmrconfig="hx ~/Library/Application\ Support/MTMR/items.json"
alias zd=zed
alias f=fuck
alias c=code
alias air='~/go/bin/air'
# Eza and zoxide
alias ls="eza --icons=always --all"
alias cd=z
#pip
alias python="python3"
alias clr="clear && exec zsh"
alias pmd="$HOME/pmd-bin-7.13.0/bin/pmd"

alias zhx="zewrap hx"

# Ollama aliases
function mistral(){
	clear && tgpt --provider ollama --model mistral -i
}

function llama3-1(){
	clear && tgpt --provider ollama --model llama3.1 -i
}
# function codellama(){
# 	clear && tgpt --provider ollama --model codellama -i
# }
function granitecode(){
	clear && tgpt --provider ollama --model granite-code:3b -i
}
function phi3(){
	clear && tgpt --provider ollama --model phi3:mini -i
}
function smollm(){
	clear && tgpt --provider ollama --model smollm:1.7b -i
}
function phi3-5(){
	clear && tgpt --provider ollama --model phi3.5:latest -i
}


psay() {
	# Check if a text argument was provided
if [ -z "$1" ]; then
  echo "Usage: $0 'text to speak'"
	return
fi

# PSAY_MODEL="en_US-libritts-high"
PSAY_SPEAKER="0"
PSAY_MODEL="en_GB-alba-medium"
# PSAY_MODEL="en_GB-cori-high.onnx"
# Combine all input arguments into a single string
	TEXT="$*"
	# Define the temporary wav file
TEMP_WAV_FILE="$PIPER_DATA/tmp_say.wav"

# Call piper-tts with the input text and output to a wav file
echo "$TEXT" | piper \
	--model $PSAY_MODEL \
	--speak $PSAY_SPEAKER \
	--output-file $TEMP_WAV_FILE \
	>/dev/null 2>&1
# Play the wav file using afplay
afplay "$TEMP_WAV_FILE" 
# Clean up by removing the wav file
rm "$TEMP_WAV_FILE" >/dev/null 2>&1
}

# Git Aliases
alias gs="git status --short"
alias ga="git add"
alias gaa="git add ."
alias gc="git commit"

alias gp="git push"
alias gu="git pull"

alias gi="git init"
alias gcl="git clone"

alias gd="git diff"

alias gl="git log --all --graph --pretty=format:'%C(magenta)%h %C(white) %an %ar%C(auto) %D%n%s%n'"
