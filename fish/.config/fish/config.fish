if status is-interactive
    # Commands to run in interactive sessions can go here
    
    if test -f ~/.config/fish/myScript/mountVM.fish
        source ~/.config/fish/myScript/mountVM.fish
    end
    ### 环境初始化 & 路径设置
    # 设置编辑器
    set -gx EDITOR /usr/bin/vim

    # 基础路径
    fish_add_path $HOME/.local/bin

    ### xbps (Void Linux)
    if type -q xbps-install
        alias xbps-install='sudo xbps-install -S && sudo xbps-install'
    end

    ### Homebrew
    if test -e "/home/linuxbrew/.linuxbrew/bin/brew"
        /home/linuxbrew/.linuxbrew/bin/brew shellenv | source
    end

    ### 包管理工具 (fnm, pnpm, bun)
    if type -q fnm
        fnm env --use-on-cd | source
    end

    if type -q pnpm
        set -gx PNPM_HOME "$HOME/.local/pnpm"
        if not contains $PNPM_HOME $PATH
            set -gx PATH $PNPM_HOME $PATH
        end
    end

    if type -q bun
        set -gx PATH $HOME/.bun/bin $PATH
    end

    ### 颜色变量 (使用 set -gx 替代 export)
    set -gx COLOR_H1_0 '\e[1;35;42m'
    set -gx COLOR_H1_1 '\e[4;30;46m'
    set -gx COLOR_H2_0 '\e[1;35;40m'
    set -gx COLOR_H2_1 '\e[1;32;40m'
    set -gx COLOR_END '\e[0m'

    ### Shell 主题 (Starship / Oh My Posh)
    if test -f "$HOME/.config/starship.toml"; and type -q starship
        starship init fish | source
    else if test -f "$HOME/.config/zsh/theme/timwhite.omp.toml"; and type -q oh-my-posh
        oh-my-posh init fish --config "$HOME/.config/zsh/theme/timwhite.omp.toml" | source
    end

    ### 效率工具应用
    # Atuin
    if type -q atuin
        set -gx ATUIN_NOBIND "true"
        atuin init fish | source
        # Fish 的绑定语法不同
        bind \cf _atuin_search
    end

    # FZF
    if type -q fzf
        set -gx FZF_COMPLETION_TRIGGER '@@'
        set -gx FZF_CTRL_T_OPTS "
        --height 50% --tmux bottom,50% --layout reverse --border top
        --walker-skip .git,node_modules,target
        --preview '[[ (file --mime {}) =~ binary ]] && echo $COLOR_H1_1{}$COLOR_END is a binary file || bat -n --color always -r :30 {}'"
        
        # Fish 版本的 fzf 集成通常通过插件或以下命令
        fzf --fish | source
    end

    # Zoxide
    if type -q zoxide
        zoxide init fish --cmd cd | source
    end

    ### 别名 (Aliases)
    alias rmdel='rm'

    # LS / Exa
    if type -q exa
        function ls
            command eza --icons $argv
        end
        alias ll='exa -lh --color always -aa -s type --icons'
        alias ls='exa -s type --icons'
        alias tree='exa -T --icons -L 2 -s type'
        alias lst='exa -T --icons -L 2 -s type'
        alias lln='exa -l --color always -aa -s type'
        alias lsn='exa -s type'
    end

    # 其他工具替换
    if type -q dysk; alias lfs='dysk'; end
    if type -q rg; alias grep='rg'; end
    if type -q procs; alias psui='procs'; end
    if type -q dust; alias du='dust'; end
    if type -q macchina; alias a='macchina -t Lithium'; end

    # 垃圾桶逻辑
    if type -q gomi
        alias rm='gomi'
        alias rml='gomi --restore'
    else
        alias mv='mv -i'
    end

    ### 函数 (Functions)
    # Yazi 快速切换目录
    if type -q yazi
        function ya
            set tmp (mktemp -t "yazi-cwd.XXXXX")
            yazi $argv --cwd-file="$tmp"
            if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
                cd -- "$cwd"
            end
            rm -f -- "$tmp"
        end
    end

end