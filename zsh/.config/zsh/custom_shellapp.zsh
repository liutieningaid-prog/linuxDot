# package
## xbps
if [ "$(command -v xbps-install)" ]; then
  alias xbps-install='sudo xbps-install -S && sudo xbps-install'
fi

## brew
if [ -e "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi


# PATH
export MAIN_DIR=/opt
export WAPP_DIR="$MAIN_DIR/app-webgo"

SAPP_DIR=${MAIN_DIR}/app-shell

# 环境变量
export SAPP_DIR=${SAPP_DIR}
export PATH=$PATH:${SAPP_DIR}/bin:$HOME/.local/bin

if [ "$(command -v fnm)" ]; then
    eval "$(fnm env --use-on-cd)"
fi
if [ "$(command -v pnpm)" ]; then
    export PNPM_HOME="/home/tom/.local/pnpm"
    case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
    esac
fi
if [ "$(command -v bun)" ]; then
    export PATH="/home/tom/.bun/bin:$PATH"
fi

export COLOR_H1_0='\e[1;35;42m'
export COLOR_H1_1='\e[4;30;46m'
export COLOR_H2_0='\e[1;35;40m'
export COLOR_H2_1='\e[1;32;40m'
export COLOR_END='\e[0m'

export GITUL=http://github.opsp.eu.org/

# default programe
export EDITOR='/usr/bin/vim'


# Theme =========================================================
# if [ -e "~/.config/starship.toml" && "$(command -v starship)"  ]; then
#     eval "$(starship init zsh)"
# elif [ -e "~/.config/zsh/theme/timwhite.omp.toml" && "$(command -v oh-my-posh)"  ];
#     eval "$(oh-my-posh init zsh --config ~/.config/zsh/theme/timwhite.omp.toml )"
# fi

if [[ -f "$HOME/.config/starship.toml" && -n "$(command -v starship)" ]]; then
    eval "$(starship init zsh)"
# 检查 Oh My Posh
elif [[ -f "$HOME/.config/zsh/theme/timwhite.omp.toml" && -n "$(command -v oh-my-posh)" ]]; then
    eval "$(oh-my-posh init zsh --config "$HOME/.config/zsh/theme/timwhite.omp.toml")"
fi

# APP =======================================================================================================================
# atuin
if [ "$(command -v atuin)" ]; then
    export ATUIN_NOBIND="true"
    eval "$(atuin init zsh)"
    # eval "$(atuin init zsh --disable-up-arrow)"
    bindkey '^f' atuin-search
    # bindkey '^f' _atuin_search_widget # if atuin <18.0
fi
if [ "$(command -v fzf)" ]; then
    # 使用默认程序打开
    # open $(fzf)
    # 发送至剪贴板
    # fzf | tr -d '\n' | tee > (pbcopy)
    # 多个输出
    # fzf --multi --bind='ctrl-a:select-all'
    # fzf --multi --bind='ctrl-a:select-all' --layout=reverse
    # $ 以什么结尾
    # ! 取反
    export FZF_COMPLETION_TRIGGER='@@'
    # export FZF_DEFAULT_OPTS='--height 40% --tmux bottom,40% --layout reverse --border top'
    export FZF_CTRL_T_OPTS='
    --height 50% --tmux bottom,50% --layout reverse --border top
    --walker-skip .git,node_modules,target
    --preview "[[ $(file --mime {}) =~ binary ]] && echo $COLOR_H1_1{}$COLOR_END is a binary file || bat -n --color always -r :30 {}"'
    source <(fzf --zsh)
fi
# sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
# sudo chmod +x /usr/local/bin/oh-my-posh
# if [ "$(command -v oh-my-posh)" ]; then
#   eval "$(oh-my-posh init zsh --config ~/.config/zsh/my-night-owl.omp.json )"
# fi

# 命令设置 =======================================================================================================================
HISTTIMEFORMAT="[%m-%d %H:%M] "

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
# if [ "$(command -v lsd)" ]; then
#     alias lsd='lsd -Al --group-dirs first'
#     alias lsa='lsd -AXl --group-dirs first'
#     alias lst='lsd --tree --group-dirs first --depth 2'
# fi
if [ "$(command -v zoxide)" ]; then
    unalias zi || echo "zinit 没有设置zi别名"
    eval "$(zoxide init zsh)"
fi
if [ "$(command -v dysk)" ]; then
    alias lfs='dysk'
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
# if [ "$(command -v trash)" ]; then
#     alias rm='trash'
#     alias rml='trash-list'
# fi
if [ "$(command -v gomi)" ]; then
    alias rm='gomi'
    alias rml='gomi --restore'
else
    alias mv='mv -i'
fi
if [ "$(command -v macchina)" ]; then
    alias a='macchina -t Lithium'
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

# rust环境变量 ==================================================================================================================
export CARGO_HTTP_MULTIPLEXING=false
export CARGO_HOME=${SAPP_DIR}/_env_make/rust-cargo
export RUSTUP_HOME=${SAPP_DIR}/_env_make/rust-main
CARGO=${SAPP_DIR}/_env_make/rust-cargo/bin
# . "${SAPP_DIR}/_env_make/rust-cargo/env"

# completion
# sudo ln -s ${SAPP_DIR}/zoxide/completions/_zoxide /usr/share/zsh/site-functions/
# source ${SAPP_DIR}/zoxide/completions/zoxide.bash
# sudo ln -s $SAPP_DIR/lsd/autocomplete/_lsd /usr/share/zsh/site-functions

alias supervisorctl="$WAPP_DIR/supervisord/supervisord ctl -s http://127.0.0.1:18080 -u tom -P  tom-tom@"

