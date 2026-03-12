#==============================================
# init
#==============================================
# bash bash-it disable alias general
# bash bash-it enable plugins sudo tmux

#==============================================
# 环境变量
#==============================================
export PATH=$PATH:~/.local/bin

# man theme
export LESS=-R
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;32m'

# protmp
# if [ "$(command -v starship)" ]; then
#     eval "$(starship init bash)"
# fi
export PS0='\e[100m#==========[out]==========#\[\e[0m\]\n'
HISTTIMEFORMAT="[%m-%d %H:%M] "
# default programe
export EDITOR='/usr/bin/vim'

#==============================================
# plugs
#==============================================
# BASHIT
export SHORT_TERM_LINE=true
export SHORT_HOSTNAME=$(hostname)
THEME_CHECK_SUDO='true'

#==============================================
# alias
#==============================================
# xbps
if [ "$(command -v xbps-install)" ]; then
  alias xbps-install='sudo xbps-install -S && sudo xbps-install'
fi

# atuin
[[ -f /usr/bin/bash-preexec.sh ]] && source /usr/bin/bash-preexec.sh
[[ -f /usr/bin/bash-preexec.sh ]] && if [ "$(command -v atuin)" ]; then
    export ATUIN_NOBIND="true"
    eval "$(atuin init bash)"
    bind -x '"\C-f": __atuin_history'
fi

alias rmdel='rm'
# alias rm='adfadfadsfasdf'

# ls命令
if [ "$(command -v exa)" ]; then
    alias ll='exa -l --color always -aa -s type --icons'
    alias ls='exa -s type --icons'
    alias tree='exa -T --icons -L 2 -s type'
    alias lst='exa -T --icons -L 2 -s type'
    alias lln='exa -l --color always -aa -s type '
    alias lsn='exa -s type'
fi
if [ "$(command -v zoxide)" ]; then
    eval "$(zoxide init bash)"
fi
if [ "$(command -v rg)" ]; then
    alias grep='rg'
fi
if [ "$(command -v procs)" ]; then
    alias psui='procs'
fi
if [ "$(command -v dust)" ]; then
    alias du='dust'
fi
if [ "$(command -v gomi)" ]; then
    alias rm='gomi'
    alias rml='gomi --restore'
else
    alias mv='mv -i'
fi

if [ "$(command -v yazi)" ]; then
    function ya() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            cd -- "$cwd"
        fi
        rmdel -f -- "$tmp"
    }
fi


