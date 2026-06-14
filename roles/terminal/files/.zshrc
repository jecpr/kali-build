# ~/.zshrc - Kali Linux custom configuration

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# Shell options
setopt AUTO_CD
setopt CORRECT
setopt NO_BEEP
setopt INTERACTIVE_COMMENTS

# Completion
autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Key bindings - emacs mode (standard for interactive use)
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# Environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=vim
export PATH="$HOME/.local/bin:/snap/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/usr/share/games:/usr/local/sbin:/usr/sbin:/sbin:$HOME/.npm-global/bin:$PATH"

# Colored man pages
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'
export LESS_TERMCAP_ue=$'\e[0m'

# ls colors
eval "$(dircolors -b 2>/dev/null || true)"
alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# grep colors
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Useful aliases
alias ip='ip -c'
alias diff='diff --color=auto'
alias ports='ss -tulnp'
alias myip='curl -s ifconfig.me'
alias serve='python3 -m http.server 80'
alias clip='xclip -selection clipboard'

# VPN-aware prompt
function precmd() {
    local vpn_ip
    vpn_ip=$(ip -4 addr show tun0 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

    local vpn_display
    if [[ -n "$vpn_ip" ]]; then
        vpn_display="%F{cyan}VPN%f %F{blue}${vpn_ip}%f"
    else
        vpn_display="%F{cyan}VPN%f %F{red}Disconnected%f"
    fi

    local ssh_display=""
    if [[ -n "$SSH_CLIENT" ]]; then
        local ssh_ip="${SSH_CLIENT%% *}"
        ssh_display="─(%F{magenta}SSH%f %F{yellow}${ssh_ip}%f)"
    fi

    local prompt_char="%F{green}$%f"
    [[ $UID -eq 0 ]] && prompt_char="%F{red}#%f"

    PROMPT=$'\n┌──('"${vpn_display}"$')─(%F{red}%n%f:%F{yellow}%~%f)'"${ssh_display}"$'\n└─'"${prompt_char} "
    RPROMPT="%F{8}%*%f"
}

# Window title
function preexec() {
    print -Pn "\e]0;%n@%m: $1\a"
}
