#!/usr/bin/env zsh
pieces_url="http://localhost:1000/.well-known/health"
clear
# pfetch
# fastfetch -c examples/10 -l none
fastfetch -l small
#Ollama status TUI icon
function ollama-status() {
  if pgrep -x "ollama" > /dev/null; then
    if [ $(ps aux | grep -c '[o]llama') -gt 1 ]; then
      echo -e "\e[32m running ($(ps aux | grep -c '[o]llama'))\e[0m"
    else
      echo -e "\e[30m idle\e[0m"
    fi
  else
    echo -e "\e[30m offline\e[0m"
  fi
}

# figlet -w$(tput cols) -f  small  " $(date '+%A')"
# echo " $USER"
# echo " -----------"
echo " • Ollama Status :$(ollama-status) \n • Pieces Status :$(if curl --silent --head --fail "$pieces_url" > /dev/null; then
  echo -e "\e[32m running\e[0m"
else
  echo -e "\e[30m offline\e[0m"
fi)"
