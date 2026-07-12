# --- Auto-Recompile .zshrc if modified ---
if [[ ! -f ~/.zshrc.zwc || ~/.zshrc -nt ~/.zshrc.zwc ]]; then
  zcompile ~/.zshrc
fi

# --- Performance: Explicit typeset for Highlighting (Prevents Error 71) ---
typeset -gA ZSH_HIGHLIGHT_STYLES

# --- Editor ---
export EDITOR=gedit
export VISUAL=gedit
export GIT_EDITOR="$EDITOR"

# --- Locales ---
export LANG=en_IN.UTF-8
export LC_ALL=en_IN.UTF-8

# --- History Configuration ---
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_FIND_NO_DUPS

# --- Autocompletion (Maximum Speed) ---
autoload -Uz compinit
zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"

# Rebuild cache only once a day OR if .zshrc changed
if [[ ! -f "$zcompdump" || ! -s "$zcompdump" || "$zcompdump" -ot ~/.zshrc ]]; then
  compinit -d "$zcompdump"
  # Compile immediately after rebuilding
  zcompile "$zcompdump"
else
  compinit -C -d "$zcompdump"
  # Auto-recompile dump if source is newer than compiled version
  if [[ ! -f "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc" ]]; then
    zcompile "$zcompdump"
  fi
fi

# --- Color Support ---
autoload -Uz colors && colors

# --- Git Support (Native & Fast) ---
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' %B%F{yellow}(%b)%f%%b'
zstyle ':vcs_info:*' check-for-changes false  # Disable expensive checks
zstyle ':vcs_info:*' check-for-staged-changes false

# --- Prompt (Updated with Git) ---
PROMPT='%B%F{magenta}%n@%m%f:%F{blue}%~%f%b${vcs_info_msg_0_}$ '

# --- precmd hook for vcs_info ---
precmd() {
  vcs_info
  # Timing information (only on first launch)
  if [[ -f /tmp/launch_start ]]; then
    local start=$(cat /tmp/launch_start)
    local now=$(date +%s%3N)
    echo "\e[1;33mTotal Launch Time: $((now - start))ms\e[0m"
    rm /tmp/launch_start
  fi
}

# --- PLUGIN 1: Autosuggestions ---
# Auto-compile plugin if needed
if [[ ! -f ~/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh.zwc ||
      ~/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh -nt ~/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh.zwc ]]; then
  zcompile ~/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
source ~/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#585b70'

# --- PLUGIN 2: Completions (External Contrib) ---
fpath=(~/.zsh_plugins/zsh-completions/src $fpath)

# --- Color Output & LS_COLORS (Original Theme) ---
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ip='ip --color=auto'
alias less='less -R'
export LS_COLORS="di=36:ln=35:ex=32:fi=0:*.sh=36:ow=34"

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# --- Fixed Menu Selection Configuration ---
zmodload zsh/complist
zstyle ':completion:*' menu select   # Turns on the visual grid grid menu
setopt AUTO_MENU                     # Show menu on successive tabs
unsetopt MENU_COMPLETE               # Prevents autoselecting the first option blindly

# --- PLUGIN 3: Syntax Highlighting (Load LAST) ---
# Auto-compile plugin if needed
if [[ ! -f ~/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh.zwc ||
      ~/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh -nt ~/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh.zwc ]]; then
  zcompile ~/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
source ~/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_STYLES[command]='fg=#4caf50'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#6182e0'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#dea656'
ZSH_HIGHLIGHT_STYLES[default]='fg=#d58ca3'
ZSH_HIGHLIGHT_STYLES[option]='fg=#d6883d'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#d6883d'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#d6883d'
ZSH_HIGHLIGHT_STYLES[separator]='fg=#b9474f'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#bd84e6'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#bd84e6'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#a46cc9'
ZSH_HIGHLIGHT_STYLES[path]='fg=#4ccac3'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#dea656'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#a46cc9'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#dea656'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#cb5e66,bold'

# --- PLUGIN 4: History Substring Search ---
# Auto-compile plugin if needed
if [[ ! -f ~/.zsh_plugins/zsh-history-substring-search/zsh-history-substring-search.zsh.zwc ||
      ~/.zsh_plugins/zsh-history-substring-search/zsh-history-substring-search.zsh -nt ~/.zsh_plugins/zsh-history-substring-search/zsh-history-substring-search.zsh.zwc ]]; then
  zcompile ~/.zsh_plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
fi
source ~/.zsh_plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# --- Aliases ---
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias python='python3'

# --- Key Bindings ---

# Force Zsh to catch Ctrl+Backspace and delete a word backward
bindkey '^H' backward-kill-word

# Bind Ctrl + Right Arrow to move forward one word
bindkey ';5C' forward-word
bindkey '^[[1;5C' forward-word

# Bind Ctrl + Left Arrow to move backward one word
bindkey ';5D' backward-word
bindkey '^[[1;5D' backward-word

# Substring Search Bindings (Fallback setup using terminfo)
[[ -n "${terminfo[kcuu1]}" ]] && bindkey "${terminfo[kcuu1]}" history-substring-search-up
[[ -n "${terminfo[kcud1]}" ]] && bindkey "${terminfo[kcud1]}" history-substring-search-down

# Substring Search Bindings (Universal escape codes)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Allow arrow keys to navigate completion menus when a menu is active
bindkey -M menuselect '^[[A' up-line-or-history
bindkey -M menuselect '^[[B' down-line-or-history
bindkey -M menuselect '^[[C' forward-char
bindkey -M menuselect '^[[D' backward-char

# --- Path Additions ---
