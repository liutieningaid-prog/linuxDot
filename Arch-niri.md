hyprland
paru -S hyprshell-bin
sudo pacman -S xdg-desktop-portal-hyprland hyprpolkitagent 



# chroot

```bash
pacman -S wqy-zenhei  noto-fonts-emoji ttf-hack-nerd ttf-liberation ttf-maplemono ttf-maplemono-nf-unhinted ttf-maplemono-nf-cn-unhinted # noto-fonts
pacman -S less
```
## 安装声音与网络配置固件 与 服务

```bash
pacman -S sof-firmware alsa-firmware alsa-ucm-conf
pacman -S pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber
pacman -S niri xwayland-satellite xdg-desktop-portal-gnome polkit-gnome
pacman -S wev # 按键代码查看
# 图形界面
pacman -S pavucontrol ghostty 
# pacman -S network-manager-applet dnsmasq
```
- 设置跃点
> 启动安装的软件或输入nm-connection-editor
> 跃点需手动设置为100,默认的-999会导致网络速率异常

## 蓝牙
```sh
pacman -S bluez #blueman
lsmod | grep btusb
sudo systemctl enable bluetooth.service
```


## su
```bash
su tom
systemctl --user enable pipewire pipewire-pulse wireplumber
pacman -S upower cliphist 
paru -S noctalia-shell  # nwg-drawer
```

# sys
```bash
systemctl --user start pipewire pipewire-pulse wireplumber
```

## 睡眠到硬盘
硬盘上必须有交换空间才能睡眠到硬盘

1. 添加hook
```bash
sudo vim /etc/mkinitcpio.conf
# 在HOOKS()内添加resume,注意需要添加在udev的后面
HOOKS( udev ... resume)
# 重新生成initramfs
sudo mkinitcpio -P
reboot
```
2. 使用命令进行睡眠
```bash
systemctl hibernate
```

## 安装框架
```bash
sudo pacman -S qt5-wayland qt6-wayland
sudo pacman -S xdg-desktop-portal-gtk thunar tumbler ffmpegthumbnailer poppler-glib gvfs-smb file-roller thunar-archive-plugin gnome-keyring

sudo ln -s /usr/bin/ghostty /usr/bin/gnome-terminal

sudo pacman -S xdg-user-dirs
LANGUAGE=en_US.UTF-8 xdg-user-dirs-update --force
```

## 截图

```bash
paru -S satty slurp grim

grim -g "$(slurp)" - | satty -f -
```

## flatpak
```bash
sudo pacman -S flatpak bazaar # gnome-software
```

## 中文输入法
```bash
sudo pacman -S fcitx5-im fcitx5-rime rime-ice-git
mkdir -p ~/.local/share/fcitx5/rime
vim ~/.local/share/fcitx5/rime/default.custom.yaml 

"""
patch:
  # 这里的 rime_ice_suggestion 为雾凇方案的默认预设
  __include: rime_ice_suggestion:/
"""

sudo vim /etc/environment

"""
XMODIFIERS=@im=fcitx
"""

mkdir -p ~/code/githubdl
cd ~/code/githubdl
git clone https://github.com/sanweiya/fcitx5-inflex-themes.git
cd fcitx5-inflex-themes/
mkdir -p ~/.local/share/fcitx5/themes && cp -r ./inflex-* ~/.local/share/fcitx5/themes
```

## 文件管理器

```bash
sudo pacman -S gvfs gvfs-smb smbclient thunar-volman
```

## SDDM

```bash
sudo pacman -S sddm
paru -S sddm-theme-greenleaf sddm-old-breeze-theme
sudo mkdir /etc/sddm.conf.d 
sudo sh -c "echo '[Theme]' > /etc/sddm.conf.d/theme.conf"
sudo sh -c "echo 'Current=greenleaf' >> /etc/sddm.conf.d/theme.conf"
sudo cp Pictures/test.png /usr/share/sddm/themes/greenleaf/background.png
```

## 程序
```bash
sudo pacman -S gnome-text-editor gnome-disk-utility gnome-clocks gnome-calculator loupe snapshot showtime file-roller zen-browser zen-browser-i18n-zh-cn amberol gnome-calendar 

sushi 
paru -S vscodium-bin

# 字体查看
sudo pacman -S gucharmap gnome-font-viewer
```

- mission-center 类似win11的任务管理器
- gnome-text-ditor记事本
- gnome-disk-utility磁盘管理
- gnome-clocks时钟
- gnome-calculator计算器
- loupe图像查看
- snapshot相机，摄像头
- showtime 极度简洁的视频播放器，要强大功能可以用MPV,不推荐使用VLC
- file-roller解压
- gst-plugin-pipewire gst-plugins-good gnome截图工具自带的录屏，需登出
- amberol 音乐播放器
- zen-browser zen-browser-i18n-cn 基于firefox的浏览器和cn语言包
  - zen浏览器一定要在设置>zen模组里面安装transparent zen模组，可以获得特别流畅的动画效果
- gnome-screenshot  可以命令行中进行截图的操作
- sushi 快速浏览

## niri.kdl
```ini
gestures {
    hot-corners {
        bottom-right
    }
}
output "eDP-1" {
    mode "1920x1200@60"
    scale 1
    position x=0 y=0
    focus-at-startup
}

// --- startup
// Add lines like this to spawn processes at startup.
// Note that running niri as a session supports xdg-desktop-autostart,

spawn-at-startup "qs" "-c" "noctalia-shell"
spawn-at-startup "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
spawn-at-startup "fcitx5" "-d"
spawn-at-startup "~/.local/bin/niri-sidebar" "listen"

hotkey-overlay {
    // Uncomment this line to disable the "Important Hotkeys" pop-up at startup.
    skip-at-startup
}
// --- window-rule
window-rule {
    // This app-id regular expression will work for both:
    // - host Firefox (app-id is "firefox")
    // - Flatpak Firefox (app-id is "org.mozilla.firefox")
    match app-id=r#"firefox$"# title="^Picture-in-Picture$"
    match app-id="thunar"
    match app-id="com.gabm.satty"
    open-floating true

    // Rounded corners for a modern look.
    geometry-corner-radius 20

    // Clips window contents to the rounded corner boundaries.
    clip-to-geometry true
}

window-rule {
    match is-floating=true
    min-width 100
    min-height 100
}

window-rule {
    //圆角
    geometry-corner-radius 8
    //剪掉圆角外的窗口内容
    clip-to-geometry true
    //透明度
    // opacity 0.99
    //禁止边框画到窗口后面
    draw-border-with-background false
}

binds {
    Mod+F2 { spawn-sh "pkill fcitx5 || fcitx5"; }
    // Suggested binds for running programs: terminal, app launcher, screen locker.
    Mod+T hotkey-overlay-title="Open a Terminal: alacritty" { spawn "ghostty"; }
    //Mod+Enter hotkey-overlay-title="Open a Terminal: alacritty" { spawn "ghostty"; }
    Super+Alt+L hotkey-overlay-title="Lock the Screen: swaylock" { spawn-sh "qs -c noctalia-shell ipc call lockScreen lock"; }

    // Core Noctalia binds
    Mod+Space { spawn-sh "qs -c noctalia-shell ipc call launcher toggle"; }

    // Toggle the focused window into/out of the sidebar
    Mod+B { spawn-sh "~/.local/bin/niri-sidebar toggle-window"; }
    // Toggle sidebar visibility (hide/show)
    Mod+N { spawn-sh "~/.local/bin/niri-sidebar toggle-visibility"; }
    // Flip the order of the sidebar
    Mod+Ctrl+S { spawn-sh "~/.local/bin/niri-sidebar flip"; }
    // Force reorder (useful if something gets misaligned manually)
    Mod+Alt+R { spawn-sh "~/.local/bin/niri-sidebar reorder"; }

    // --- screenshot
    F1 { spawn-sh "grim -g \"$(slurp)\" - | satty -f -"; }
    Mod+Ctrl+F1 { screenshot-screen; }
    Mod+Alt+F1 { screenshot-window; }
}

environment {
    // LANG "zh_CN.UTF-8" //会出现异常
    LC_MESSAGES "zh_CN.UTF-8"
    LC_CTYPE "en_US.UTF-8"
    GTK_IM_MODULE "fcitx"
    QT_IM_MODULE "fcitx"
    XMODIFIERS "@im=fcitx"
    XDG_CURRENT_DESKTOP "GNOME"
    XIM "fcitx"
}
```


## KVM

```bash
sudo pacman -S  qemu-full virt-manager dnsmasq nm-connection-editor
sudo systemctl enable --now libvirtd
sudo virsh net-start default #开启nat网络
sudo virsh net-autostart default #自动启动nat网络
sudo usermod -a -G libvirt $(whoami)
sudo vim /etc/libvirt/qemu.conf

"""conf
#修改
user = "tom"
group = "libvirt"
"""

sudo systemctl restart libvirtd
# 零时开启嵌套虚拟化
modprobe kvm_intel nested=1
# 永久生效
sodu vim /etc/modprobe.d/kvm_intel.conf
sudo vim /etc/modprobe.d/kvm_amd.conf

## 写入
options kvm_intel nested=1
options kvm_amd nested=1

# 重新生成
sudo mkinitcpio -P

sudo reboot
```

# shell
```sh

sudo pacman -S pacman-contrib havn bluetui stow # fnt
```
- pacman-contrib 是pacman的一些小工具 pactree, pacsearch checkupdates
- havn    #端口扫描
- bluetui #蓝牙管理
- stow    #github二进制安装
- fnt     #适用于字体的字体管理器

```sh
sudo pacman -S oh-my-posh curl wget ripgrep fd zsh atuin # git
sudo pacman -S exa zoxide procs dust glow hexyl
sudo pacman -S bottom tmux fastfetch
 
```

倒入配置
```bash
git clone --depth=1 https://github.com/tom-temp/linux-dotfiles.git ~/dotfiles
# git -C ~/dotfiles pull
cd ~/dotfiles
stow vim

# zsh
mkdir -p ~/.config/zsh
git clone --depth=1 https://github.com/zdharma-continuum/zinit.git ~/.config/zsh/zinit
stow zsh_gnome

# tmux
mkdir -p ~/.local/bin/
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cd ~/dotfiles
stow tmux
ln -s ~/.config/tmux/layout.default.sh ~/.local/bin/tm
chmod +x ~/.local/bin/tm
chmod +x ~/.config/tmux/layout.default.sh


# "配置SSH 公钥"
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
```

## 其他应用
```bash
sudo pacman -S q-dns
```

## 脚本与自定义

## 剪贴板通过管道计算
```bash
pacman -Ss wl-clipboard

```