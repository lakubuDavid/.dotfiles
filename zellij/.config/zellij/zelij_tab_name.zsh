# zellij tab names: folder when idle, program when busy, aggregated per tab.
# 1 pane: <own> | 2 panes: ▸ <cur> :: <other> | 3+: <cur> :: <second> [+N]
# Editors keep their file arg (hx src/main.rs → hx:main.rs); sibling panes prefer an
# app-set OSC title (nvim filename, pi's π - dir) over the raw command.
# Clamped to $ZELLIJ_TAB_MAXLEN (default 30). First name is always the current pane.
# ponytail: per-prompt `list-panes` scan is O(panes) in a background (&!) subshell so the
# prompt never blocks; upgrade path is a persistent zjstatus query if lag ever shows.

: "${ZELLIJ_TAB_MAXLEN:=30}"

__zellij_tab_folder() {
  [[ $PWD == $HOME ]] && { print -r -- "~"; return; }
  print -r -- "${PWD##*/}"
}

# Programs whose first file argument is worth showing (hx src/main.rs → hx:main.rs).
__zellij_tab_fileprogs=(hx helix nvim vim vi view code cursor zed subl nano micro emacs emacsclient yazi)

__zellij_tab_prog() {
  local -a w; w=(${(z)1})
  local p prog="" a
  for p in $w; do
    if [[ -z $prog ]]; then
      case $p in
        sudo|env|command|nohup|time|nice|stdbuf|*=*|-*) continue ;;
        *) prog="${${p##*/}:-zsh}" ;;
      esac
    elif (( ${__zellij_tab_fileprogs[(I)$prog]} )); then
      case $p in
        -*|*=*) continue ;;
        *)
          a="${p%/}"; a="${a##*/}"
          if [[ -n $a && $a != . ]]; then print -r -- "$prog:$a"; else print -r -- "$prog"; fi
          return ;;
      esac
    else
      print -r -- "$prog"; return
    fi
  done
  print -r -- "${prog:-zsh}"
}

__zellij_tab_rename_bg() {
  emulate -L zsh
  local own="$1"
  [[ -n $ZELLIJ && -n $own ]] || return 0
  (
    local name="$own" json
    export ZELLIJ_OWN="$own" ZELLIJ_TAB_MAXLEN="$ZELLIJ_TAB_MAXLEN" ZELLIJ_PANE_ID="$ZELLIJ_PANE_ID"
    if json="$(command zellij action list-panes -t -c -s -j 2>/dev/null)"; then
      name="$(print -r -- "$json" | command python3 -c '
import json,os,sys
SHELLS={"zsh","bash","sh","fish","dash","nu","ksh","tcsh","elvish","xonsh","pwsh","powershell"}
FILEPROGS={"hx","helix","nvim","vim","vi","view","code","cursor","zed","subl","nano","micro","emacs","emacsclient","yazi"}
try:
    panes=json.load(sys.stdin)
except Exception:
    print(os.environ.get("ZELLIJ_OWN","")); raise SystemExit
home=os.path.expanduser("~")
def cmd_name(cmd):
    prog=""
    for tok in cmd.strip().split():
        if not prog:
            b=tok.rsplit("/",1)[-1]
            if b in ("sudo","env","command","nohup","time","nice","stdbuf") or "=" in tok or tok.startswith("-"):
                continue
            prog=b or "zsh"
            continue
        if prog in FILEPROGS and not tok.startswith("-") and "=" not in tok:
            f=tok.rstrip("/").rsplit("/",1)[-1]
            return prog+":"+f if f and f!="." else prog
        return prog
    return prog or "zsh"
def prog(p):
    t=(p.get("title") or "").strip()
    # ponytail: " :: " is the shell-default title shape (cwd :: cmd); app-set OSC
    # titles (nvim filename, pi π - dir) never use it. A filename containing it would misroute.
    if t and " :: " not in t:
        return t
    c=(p.get("pane_command") or "").strip()
    if c:
        b=cmd_name(c)
        if b and b not in SHELLS and not b.startswith("-"):
            return b
    w=p.get("pane_cwd") or ""
    if w==home:
        return "~"
    return w.rsplit("/",1)[-1] or "zsh"
own=os.environ.get("ZELLIJ_OWN","")
pid=os.environ.get("ZELLIJ_PANE_ID","")
try:
    me_id=int(pid.rsplit("_",1)[-1]); me_plug=pid.startswith("plugin_")
except Exception:
    print(own); raise SystemExit
me=next((p for p in panes if p.get("id")==me_id and bool(p.get("is_plugin"))==me_plug),None)
if me is None:
    print(own); raise SystemExit
sibs=[p for p in panes if not p.get("is_plugin") and p.get("tab_id")==me.get("tab_id") and not p.get("exited")]
sibs.sort(key=lambda p:p.get("id",0))
others=[prog(p) for p in sibs if p.get("id")!=me_id]
n=len(sibs)
try:
    mx=int(os.environ.get("ZELLIJ_TAB_MAXLEN","30") or 30)
except Exception:
    mx=30
if n<=1:
    name=own
elif n==2:
    name="▸ "+own+" :: "+others[0]
else:
    name=own+" :: "+others[0]+" [+"+str(n-2)+"]"
if len(name)>mx:
    name=name[:mx-1]+"…"
print(name)
')"
      [[ -n $name ]] || name="$own"
    fi
    (( ${#name} > ZELLIJ_TAB_MAXLEN )) && name="${name[1,$((ZELLIJ_TAB_MAXLEN-1))]}…"
    command zellij action rename-tab "$name" >/dev/null 2>&1
  ) &!
}

__zellij_tab_precmd() { __zellij_tab_rename_bg "$(__zellij_tab_folder)"; }
__zellij_tab_preexec() { __zellij_tab_rename_bg "$(__zellij_tab_prog "$1")"; }

if [[ -n $ZELLIJ ]]; then
  autoload -Uz add-zsh-hook
  add-zsh-hook -d precmd __zellij_tab_precmd 2>/dev/null
  add-zsh-hook -d preexec __zellij_tab_preexec 2>/dev/null
  add-zsh-hook precmd __zellij_tab_precmd
  add-zsh-hook preexec __zellij_tab_preexec
fi
