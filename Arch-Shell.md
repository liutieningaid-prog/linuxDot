
# 软件
```bash
sudo pacman -S --needed curl wget vim eza zoxide procs dust glow unzip hexyl fd atuin starship fish  bash-preexec
sudo pacman -S --needed helix fastfetch stow git
```

## 配置文件
```bash
git clone --depth=1 https://github.com/liutieningaid-prog/linuxDot.git ~/dotfiles
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
```

### root bash
```bash
cd dotfiles
stow vim
stow bash

~/.bash_it/install.sh -a
cp ./bash/.config/theme-bashit/powerline-multiline.base.bash ../.bash_it/themes/powerline-multiline/
cp ./bash/.config/theme-bashit/powerline-multiline.theme.bash ../.bash_it/themes/powerline-multiline/
sed -i '$i'"export BASH_IT_THEME='powerline-multiline'" ~/.bashrc
source ~/.bashrc
bashit disable alias all
```

### user fish
```bash
cd dotfiles
stow vim
stow helix
stow fish
```


## 开发环境
```bash
sudo pacman -S --needed uv fnm

fnm install 24
corepack enable pnpm

pnpm -v
```