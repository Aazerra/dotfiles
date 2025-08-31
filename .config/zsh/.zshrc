# Prompt colors (OneDark inspired with enhanced git info)
autoload -U colors && colors
source /usr/share/git/completion/git-prompt.sh 2>/dev/null || true
setopt PROMPT_SUBST
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_DESCRIBE_STYLE="branch"

# Enhanced prompt with execution time and status
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' (%b%u%c)'
zstyle ':vcs_info:git:*' actionformats ' (%b|%a%u%c)'
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' stagedstr '+'

# Command execution timer
function preexec() {
  timer=$(($(date +%s%0N)/1000000))
  echo -ne '\e[5 q'
}

function precmd() {
  vcs_info
  if [ $timer ]; then
    now=$(($(date +%s%0N)/1000000))
    elapsed=$(($now-$timer))
    if [ $elapsed -gt 5000 ]; then
      timer_show=" %{$fg[red]%}${elapsed}ms%{$reset_color%}"
    elif [ $elapsed -gt 1000 ]; then
      timer_show=" %{$fg[yellow]%}${elapsed}ms%{$reset_color%}"
    else
      timer_show=""
    fi
    unset timer
  fi
}

# Dynamic prompt with git info and execution time
PS1='%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[blue]%}%m%{$reset_color%}:%{$fg[yellow]%}%~%{$reset_color%}${vcs_info_msg_0_}${timer_show} %(?..%{$fg[red]%}[%?]%{$reset_color%} )$ '

stty stop undef
setopt interactive_comments

# Enhanced history configuration with timestamps
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.cache/zsh/zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt inc_append_history

# Smart history substring search (install zsh-history-substring-search if available)
if [[ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=green,fg=white,bold'
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
fi

# History search
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# Enhanced auto completion with fuzzy matching
autoload -U compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zmodload zsh/complist
compinit -d ~/.cache/zsh/zcompdump-$ZSH_VERSION
_comp_options+=(globdots)

bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function  zle-keymap-select() {
    RPS1="${${KEYMAP/vicmd/[N]}/(main|viins)/[I]}"
	case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
    zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-init() {
	RPS1="${${KEYMAP/vicmd/[N]}/(main|viins)/[I]}"
	zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
	zle reset-prompt
}
zle -N zle-line-init

echo -ne '\e[5 q' # Use beam shape cursor on startup.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

bindkey -s '^o' 'lfcd\n'

bindkey '^[[P' delete-char

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey '^w' backward-kill-word

bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M vicmd '^e' edit-command-line
bindkey -M visual '^[[P' vi-delete


# allow ctrl-r and ctrl-s to search the history
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward


# zsh rehash
zshcache_time="$(date +%s%N)"

autoload -Uz add-zsh-hook

rehash_precmd() {
  if [[ -a /var/cache/zsh/pacman ]]; then
    local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
    if (( zshcache_time < paccache_time )); then
      rehash
      zshcache_time="$paccache_time"
    fi
  fi
}

add-zsh-hook -Uz precmd rehash_precmd


autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

# ================================
# TRICKY ZSH FEATURES & OPTIMIZATIONS
# ================================

# Smart directory navigation - type directory name to cd into it
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Advanced globbing
setopt EXTENDED_GLOB
setopt GLOB_DOTS
setopt NUMERIC_GLOB_SORT

# Performance optimizations
setopt NO_BEEP
setopt NO_HIST_BEEP
setopt NO_LIST_BEEP
setopt HASH_LIST_ALL
setopt HASH_EXECUTABLES_ONLY

# Magic space - expand history on space
bindkey ' ' magic-space

# Smart word selection (Alt+left/right for word movement)
autoload -U select-word-style
select-word-style bash
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word

# Fancy Ctrl+Z - toggle between fg and background
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# Smart sudo - Ctrl+X Ctrl+S to add/remove sudo (vi-mode friendly)
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
bindkey "^X^S" sudo-command-line

# Alternative sudo binding for vi command mode
bindkey -M vicmd 's' sudo-command-line

# Find and kill process by name
fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    if [ "x$pid" != "x" ]; then
        echo $pid | xargs kill -${1:-9}
    fi
}

# Directory size
dirsize() {
    du -sh ${1:-.} | sort -hr
}

# Create and enter directory
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Backup file
backup() {
    cp "$1"{,.backup-$(date +%Y%m%d-%H%M%S)}
}

# Load local configuration if it exists
[[ -f ~/.config/zsh/local.zsh ]] && source ~/.config/zsh/local.zsh

# Auto-suggestions and syntax highlighting (install if available)
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

[[ -f /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ]] && \
    source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null

# Configure auto-suggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666,underline"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# Load command-not-found if available
[[ -f /usr/share/doc/pkgfile/command-not-found.zsh ]] && \
    source /usr/share/doc/pkgfile/command-not-found.zsh

# Performance: compile .zshrc for faster loading
if [[ ~/.config/zsh/.zshrc -nt ~/.config/zsh/.zshrc.zwc ]]; then
    zcompile ~/.config/zsh/.zshrc
fi

# Create cache directory if it doesn't exist
[[ ! -d ~/.cache/zsh ]] && mkdir -p ~/.cache/zsh

# source aliasrc if it exists
[[ -f ~/.config/shell/aliasrc ]] && source ~/.config/shell/aliasrc

# source hashrc if it exists
[[ -f ~/.config/shell/hashrc ]] && source ~/.config/shell/hashrc


[ -s "${XDG_DATA_HOME:-$HOME/.local/share}/bun/_bun" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/bun/_bun"
eval "$(zoxide init zsh --cmd cd)"
eval "$(fnm env --use-on-cd --shell zsh)"