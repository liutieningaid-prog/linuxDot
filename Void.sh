
## ROOT
# update-for SYS
cp /usr/share/xbps.d/*-repository-*.conf /etc/xbps.d/
sed -i 's|https://repo-default.voidlinux.org|https://mirrors.tuna.tsinghua.edu.cn/voidlinux|g' /etc/xbps.d/*-repository-*.conf
xbps-install -S
xbps-remove -R grub-i386-efi grub-x86_64-efi grub efibootmgr libefivar lvm2 os-prober thin-provisioning-tools
xbps-remove -R iptables openssh
# voidlinux
xbps-install fuse curl wget vim exa zoxide procs dust glow vsv unzip openssh openssl hexyl gitui helix
xbps-install bottom tmux fastfetch bash-preexec
xbps-install uv 

# service
rm -f /etc/localtime
ln -sf /usr/share/zoneinfo/America/Toronto /etc/localtime
xbps-install -y openssh
xbps-install -S socklog-void dcron
ln -s /etc/sv/nanoklogd    /var/service/
ln -s /etc/sv/socklog-unix /var/service/
ln -s /etc/sv/crond /var/service/
ln -s /etc/sv/sshd /var/service/

rm /var/service/agetty-tty{2,3,4,5,6}


# zsh environment
xbps-install starship exa zoxide ripgrep fd zsh atuin

# config
xbps-install stow git
git clone --depth=1 https://github.com/tom-temp/linux-dotfiles.git ~/dotfiles
git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
# git -C ~/dotfiles pull

# Bash
mv ~/.bashrc ~/bashrc.bac
cd dotfiles
stow vim
stow bash
~/.bash_it/install.sh -a
cp ./bash/.config/theme-bashit/powerline-multiline.base.bash ../.bash_it/themes/powerline-multiline/
cp ./bash/.config/theme-bashit/powerline-multiline.theme.bash ../.bash_it/themes/powerline-multiline/
sed -i '$i'"export BASH_IT_THEME='powerline-multiline'" ~/.bashrc
source ~/.bashrc
bashit disable alias general

# brew
# (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> ~/.profile

# user
useradd tom
passwd  tom
usermod -a -G wheel,bin,disk,dialout,audio,video,adm,storage,scanner,network,kvm,input,plugdev,usbmon,sgx,users tom
usermod -a -G socklog tom
chown tom:tom /opt

###############################################################################
# Tom
###############################################################################
git clone --depth=1 https://github.com/tom-temp/linux-dotfiles.git ~/dotfiles
# git -C ~/dotfiles pull
cd ~/dotfiles
stow vim

# zsh
mkdir -p ~/.config/zsh
git clone --depth=1 https://github.com/zdharma-continuum/zinit.git ~/.config/zsh/zinit
stow zsh_gnome
touch ~/.config/path_custom.zsh

# tmux
mkdir -p ~/.local/bin/
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cd ~/dotfiles
stow tmux
ln -s ~/.config/tmux/layout.default.sh ~/.local/bin/tm
chmod +x ~/.local/bin/tm
chmod +x ~/.config/tmux/layout.default.sh


# "配置SSH 密钥"
cd ~
mkdir -p ~/.ssh
echo "# thinkbook" >> ~/.ssh/authorized_keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDcyPDkNkkzMfm+yZYGN6jyxAY09xQV8rkngYd7TAlrs tom@tom.tom" >> ~/.ssh/authorized_keys
echo "# conestoga" >> ~/.ssh/authorized_keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHxDqMbKbKljkIkaMkn5nezfA4Uziy7TXZymDpTzQgts tom@202404" >> ~/.ssh/authorized_keys
echo "# office365" >> ~/.ssh/authorized_keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHxDqMbKbKljkIkaMkn5nezfA4Uziy7TXZymDpTzQgts tom@202404" >> ~/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6Jxi836pB6Fgw/wHlzPGCGxi002RGHUwaFcmS1CyXMJh5L8YwQacIxTHNR80CZSD/gfxBZww07Z16fyYpQ9m3Bh3Z0Ikv/Pa5VGdJzEoehOijyyo819vVZC5MgYOqxhkQhmNBwPBzTiSonMFGqHuLyW2oIunsXBW4nUtLurLjOO+J1IavQuOJM5jjMeqy3lCyTeXibEdPjOT68hNzfvitj9dzRJ715VnFUSJJOnbr9PYCAelvuRH6xkIHvIG0P4CAhAyXc31S4aV3flv0zF5Or5jbjYbdI6qHp2GbjA393F6JnwkzVnC8/piObCS70BHbzkO0DR5J1aiyd9Nnfhlp ssh-key-2024-04-08" >> ~/.ssh/authorized_keys

# brew
cd ~
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/tom/.profile
brew install oh-my-posh
brew install fnm
fnm install 24
corepack enable pnpm

pnpm -v
# cd ~




# yazi
# -----------------------------------------------------------
xbps-install viu jq atool

sudo mkdir -p ~/.config/yazi/plugins
git clone https://github.com/DreamMaoMao/keyjump.yazi.git ~/.config/yazi/plugins/keyjump.yazi
git clone https://github.com/Reledia/glow.yazi.git ~/.config/yazi/plugins/glow.yazi

xbps-install void-repo-nonfree
sudo cp /usr/share/xbps.d/10-repository-nonfree.conf /etc/xbps.d
xbps-install unrar

## 临时方法
sudo mkdir -p /opt/app-shell/bin
sudo chmod 777 /opt/app-shell -R
cd /opt/app-shell/
wget https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip
unzip yazi-x86_64-unknown-linux-gnu.zip
sudo cp yazi-x86_64-unknown-linux-gnu/yazi bin/
rm -r yazi-x86_64-unknown-linux-gn
rm yazi-x86_64-unknown-linux-gnu.zip

# gpu
xbps-install nvtop python3-pipx
pipx install rich-cli





pnpm install opcua-commander -g 