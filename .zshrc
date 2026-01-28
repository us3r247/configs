# --- Performance: Explicit typeset for Highlighting (Prevents Error 71) ---
typeset -gA ZSH_HIGHLIGHT_STYLES

# --- Editor ---
export EDITOR=nvim
export VISUAL=nvim
export GIT_EDITOR="$EDITOR"

# --- Locales ---
export LANG=en_IN.UTF-8
export LC_ALL=en_IN.UTF-8

# --- Environment Variables (Placeholder) ---

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

# --- Autocompletion (Built-in System) ---
autoload -Uz compinit
zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ -s "$zcompdump" && (! "$zcompdump" -ot ~/.zshrc) ]]; then
  compinit -C -d "$zcompdump"
else
  compinit -d "$zcompdump"
fi

# --- Color Support ---
autoload -Uz colors && colors

# --- Prompt (Original Pastel Style) ---
PROMPT='%B%F{magenta}%n@%m%f:%F{blue}%~%f%b$ '

# --- PLUGIN 1: Autosuggestions ---
# Source: [zsh-autosuggestions GitHub](https://github.com)
source ~/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#585b70'

# --- PLUGIN 2: History Substring Search (Arrow Keys) ---
# Source: [zsh-history-substring-search GitHub](https://github.com)
source ~/.zsh_plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# --- PLUGIN 3: Completions (External Contrib) ---
# Note: This uses the additional completions found in your plugin folder
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
zstyle ':completion:*' menu select

# Completion Behavior
zmodload zsh/complist
setopt AUTO_MENU
setopt MENU_COMPLETE

# --- PLUGIN 4: Syntax Highlighting (Load LAST) ---
# Source: [zsh-syntax-highlighting GitHub](https://github.com)
source ~/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Your exact Syntax Highlighting Styles
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

# --- Aliases (Placeholder) ---
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias python='python3'
