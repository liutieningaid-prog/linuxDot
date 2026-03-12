
export PATH=$PATH:~/.local/bin
export CARGO_HOME=/home/tom/.local/rust-cargo
export RUSTUP_HOME=/home/tom/.local/rust-main



# 环境变量
MAIN_DIR=/opt
MAPP_DIR=/opt/local-app
export PATH=$PATH:/opt/local-app/bin
# 环境变量
eval "$(starship init bash)"
export PS0='\n\e[100m#==========[out]==========#\[\e[0m\]\n'

# ls命令
if [ "$(command -v exa)" ]; then
    # unalias -m 'll'
    # unalias -m 'l'
    # unalias -m 'la'
    # unalias -m 'ls'
    # alias ls='exa -G  --color auto --icons -a -s type'
    # alias ll='exa -l --color always --icons -a -s type'
    
    # alpine配置
    # unalias 'll'
    # unalias 'l'
    # unalias 'la'
    # unalias 'ls'
    alias ll='exa -l --color always -a -s type'
    alias ls='exa'
    alias tree='exa -T'
fi

# zoxide
eval "$(zoxide init bash)"
# zoxide --cmd
source $MAPP_DIR/zoxide/completions/zoxide.bash

alias du='dust'
alias grep='rg'
alias psui='procs'
