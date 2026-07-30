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
# Useful shell options
# ------------------------------------------------------------------------------
setopt AUTO_CD
setopt COMPLETE_IN_WORD
setopt INTERACTIVE_COMMENTS
setopt AUTO_MENU
unsetopt MENU_COMPLETE

# ------------------------------------------------------------------------------
# Completion
# ------------------------------------------------------------------------------
autoload -Uz compinit

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

zstyle ':completion:*' matcher-list \
    'm:{a-z}={A-Z}' \
    'r:|=*' \
    'l:|=*'

zmodload zsh/complist

# ------------------------------------------------------------------------------
# Colors
# ------------------------------------------------------------------------------
autoload -Uz colors && colors

if command -v dircolors >/dev/null 2>&1; then
    eval "$(dircolors -b)"
fi

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# --- Git Support (Native & Fast) ---
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' enable git

# FIXED: Removed the accidental '%%b' formatting bug causing duplication
zstyle ':vcs_info:git:*' formats ' %B%F{yellow}(%b)%f'
zstyle ':vcs_info:*' check-for-changes false  
zstyle ':vcs_info:*' check-for-staged-changes false

# --- Prompt (Updated with Git) ---
PROMPT='%B%F{magenta}%n@%m%f:%F{blue}%~%f%b${vcs_info_msg_0_}
$ '

precmd() {
    vcs_info

    if [[ -f /tmp/launch_start ]]; then
        local start=$(cat /tmp/launch_start)
        local now=$(date +%s%3N)

        echo "\e[1;33mTotal Launch Time: $((now-start))ms\e[0m"

        rm /tmp/launch_start
    fi
}

# ------------------------------------------------------------------------------
# Plugin Paths
# ------------------------------------------------------------------------------
fpath=(
    ~/.zsh_plugins/zsh-completions/src
    $fpath
)

# ------------------------------------------------------------------------------
# Plugin 1 - Autosuggestions
# ------------------------------------------------------------------------------
compile_if_needed ~/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#585b70'

# ------------------------------------------------------------------------------
# Plugin 2 - History Substring Search
# ------------------------------------------------------------------------------
compile_if_needed ~/.zsh_plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.zsh_plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# ------------------------------------------------------------------------------
# Plugin 3 - Syntax Highlighting (MUST BE LAST)
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
# Aliases
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
# Keybindings
# ------------------------------------------------------------------------------
zmodload zsh/terminfo

bindkey '^H' backward-kill-word

# Ctrl + Arrow
[[ -n "$terminfo[kRIT5]" ]] && bindkey "$terminfo[kRIT5]" forward-word
[[ -n "$terminfo[kLFT5]" ]] && bindkey "$terminfo[kLFT5]" backward-word

bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Alt + Arrow
bindkey '^[^[[C' forward-word
bindkey '^[^[[D' backward-word

# History substring search
[[ -n "$terminfo[kcuu1]" ]] && bindkey "$terminfo[kcuu1]" history-substring-search-up
[[ -n "$terminfo[kcud1]" ]] && bindkey "$terminfo[kcud1]" history-substring-search-down

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OA' history-substring-search-up
bindkey '^[OB' history-substring-search-down

# Completion menu navigation
bindkey -M menuselect '^[[A' up-line-or-history
bindkey -M menuselect '^[[B' down-line-or-history
bindkey -M menuselect '^[[C' forward-char
bindkey -M menuselect '^[[D' backward-char

# ------------------------------------------------------------------------------
# PATH
# ------------------------------------------------------------------------------
path=(
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    $path
)

export PATH

# ------------------------------------------------------------------------------
# End
# ------------------------------------------------------------------------------
