# --- Editor ---
export EDITOR=nvim
export VISUAL=nvim
export GIT_EDITOR="$EDITOR"  # Added for consistency with git

# --- History Configuration ---
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# --- Autocompletion (with cache) ---
autoload -Uz compinit
zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ ! -s "$zcompdump" || "$zcompdump" -ot ~/.zshrc ]]; then
  compinit -d "$zcompdump"
else
  compinit -C -d "$zcompdump"
fi

# --- Color Support ---
autoload -Uz colors && colors

# --- Key Bindings ---
bindkey '^R' history-incremental-search-backward

# --- Prompt (Pastel style) ---
PROMPT='%B%F{magenta}%n@%m%f:%F{blue}%~%f%b$ '

# Lazy-load Conda only when needed
conda() {
  unset -f conda
  source "/home/atharv/miniconda3/etc/profile.d/conda.sh" || return 1
  command conda "$@"
}

# --- Plugins: Autosuggestions + Syntax Highlighting ---
# Autosuggestions
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#585b70'

# Command Output Color
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias ip='ip --color=auto'
alias less='less -R'

# --- Clean & universal LS_COLORS (no background) ---
export LS_COLORS="di=36:ln=35:ex=32:fi=0:*.sh=36:ow=34"

# Match autocomplete suggestions to LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select

# Enable scrollable completion with keyboard
zmodload zsh/complist
bindkey '^I' expand-or-complete

# --- Completion Behavior Enhancements ---
setopt AUTO_MENU        # Tab cycles through completions
setopt MENU_COMPLETE    # Show menu on full completion

# --- Syntax Highlighting Styles (match WezTerm theme) ---
# Load last to prevent override
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Commands and arguments
ZSH_HIGHLIGHT_STYLES[command]='fg=#4caf50'             # material green
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#6182e0'                # cobalt blue
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#dea656'       # warm gold
ZSH_HIGHLIGHT_STYLES[default]='fg=#d58ca3'             # vintage pink

# Options and separators
ZSH_HIGHLIGHT_STYLES[option]='fg=#d6883d'              # ochre
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#d6883d'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#d6883d'
ZSH_HIGHLIGHT_STYLES[separator]='fg=#b9474f'           # rich red

# Quoting and paths
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#bd84e6'  # pastel purple
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#bd84e6'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#a46cc9'    # lavender
ZSH_HIGHLIGHT_STYLES[path]='fg=#4ccac3'                    # clean teal

# Globbing, aliasing, history
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#dea656'            
ZSH_HIGHLIGHT_STYLES[alias]='fg=#a46cc9'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#dea656'

# Errors
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#cb5e66,bold'   # bold red (error)
