# ==============================================================================
#                                ~/.zshrc
# ==============================================================================

# ------------------------------------------------------------------------------
# Auto-compile .zshrc
# ------------------------------------------------------------------------------
# Helper function to compile plugins (Defined first so zsh knows it exists)
compile_if_needed() {
    local file="$1"
    [[ -f "$file" ]] || return
    [[ ! -f "${file}.zwc" || "$file" -nt "${file}.zwc" ]] && zcompile "$file"
}

if [[ ! -f ~/.zshrc.zwc || ~/.zshrc -nt ~/.zshrc.zwc ]]; then
    zcompile ~/.zshrc
fi

# Prevent Error 71 from zsh-syntax-highlighting
typeset -gA ZSH_HIGHLIGHT_STYLES

# ------------------------------------------------------------------------------
# Editor
# ------------------------------------------------------------------------------
export EDITOR=nvim
export VISUAL=nvim
export GIT_EDITOR=nvim

# ------------------------------------------------------------------------------
# Locale
# ------------------------------------------------------------------------------
export LANG=en_IN.UTF-8
export LC_ALL=en_IN.UTF-8

# ------------------------------------------------------------------------------
# Environment Arrays (Unique filtering enabled)
# ------------------------------------------------------------------------------
typeset -U path fpath

path=(
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    $path
)

fpath=(
    ~/.zsh_plugins/zsh-completions/src
    $fpath
)

# ------------------------------------------------------------------------------
# History
# ------------------------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_FIND_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt EXTENDED_HISTORY
setopt HIST_VERIFY

# ------------------------------------------------------------------------------
# Shell Options
# ------------------------------------------------------------------------------
setopt AUTO_CD
setopt COMPLETE_IN_WORD
setopt INTERACTIVE_COMMENTS
setopt AUTO_MENU
setopt MENU_COMPLETE      # Fast inline Mac-style tab cycling style!

# ------------------------------------------------------------------------------
# Colors & Completions (Mirrored from Mac)
# ------------------------------------------------------------------------------
autoload -Uz colors && colors

# macOS uses LSCOLORS, Linux uses LS_COLORS. Setting both ensures compatibility:
export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS="di=36:ln=35:ex=32:fi=0:*.sh=36:ow=34"

# ------------------------------------------------------------------------------
# Core Completion Optimization Engine
# ------------------------------------------------------------------------------
autoload -Uz compinit
zmodload zsh/complist

zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"

if [[ ! -f "$zcompdump" || ! -s "$zcompdump" || "$zcompdump" -ot ~/.zshrc ]]; then
    compinit -d "$zcompdump"
    zcompile "$zcompdump"
else
    compinit -C -d "$zcompdump"
    if [[ ! -f "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc" ]]; then
        zcompile "$zcompdump"
    fi
fi

mkdir -p ~/.zsh/cache

zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|=*' 'l:|=*'

# ------------------------------------------------------------------------------
# Git Support (Native & Fast)
# ------------------------------------------------------------------------------
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' enable git

# FIXED: Removed the accidental '%%b' formatting bug causing duplication
zstyle ':vcs_info:git:*' formats ' %B%F{yellow}(%b)%f'
zstyle ':vcs_info:*' check-for-changes false  
zstyle ':vcs_info:*' check-for-staged-changes false

# ------------------------------------------------------------------------------
# Prompt (Updated with Git)
# ------------------------------------------------------------------------------
PROMPT='%B%F{magenta}%n@%m%f:%F{blue}%~%f%b${vcs_info_msg_0_}
$ '

precmd() {
    vcs_info
}

# ------------------------------------------------------------------------------
# Keybindings (Core Operational Maps)
# ------------------------------------------------------------------------------
zmodload zsh/terminfo

bindkey '^H' backward-kill-word

# Ctrl + Arrow keys (Word boundaries jumping)
[[ -n "$terminfo[kRIT5]" ]] && bindkey "$terminfo[kRIT5]" forward-word
[[ -n "$terminfo[kLFT5]" ]] && bindkey "$terminfo[kLFT5]" backward-word

# ------------------------------------------------------------------------------
# Aliases (Placed above plugins so syntax highlighter evaluates them accurately)
# ------------------------------------------------------------------------------
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias diff='diff --color=auto'
alias less='less -R'
alias ip='ip --color=auto'

alias python='python3'

# ------------------------------------------------------------------------------
# Plugin 1 - Autosuggestions
# ------------------------------------------------------------------------------
compile_if_needed ~/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242,bg=none'

# ------------------------------------------------------------------------------
# Plugin 2 - History Substring Search
# ------------------------------------------------------------------------------
compile_if_needed ~/.zsh_plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.zsh_plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# History substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ------------------------------------------------------------------------------
# Plugin 3 - Syntax Highlighting (Sourced ABSOLUTE LAST)
# ------------------------------------------------------------------------------
compile_if_needed ~/.zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
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

# ------------------------------------------------------------------------------
# PATH Export
# ------------------------------------------------------------------------------
export PATH

# ------------------------------------------------------------------------------
# End
# ------------------------------------------------------------------------------
