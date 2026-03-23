# chroot

```bash
pacman -S wqy-zenhei  noto-fonts-emoji ttf-hack-nerd ttf-liberation ttf-maplemono ttf-maplemono-nf-unhinted ttf-maplemono-nf-cn-unhinted # noto-fonts
pacman -S less
```
## 安装声音与网络配置固件 与 服务

```bash
pacman -S sof-firmware alsa-firmware alsa-ucm-conf
pacman -S pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber
pacman -S hyprland ghostty 

# 图形界面
pacman -S pavucontrol 
pacman -S network-manager-applet dnsmasq
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
paru -S hyprshell-bin
```

# sys
```bash
systemctl --user start pipewire pipewire-pulse wireplumber
```

## hyperland设置
```conf
xwayland{
	force_zero_scaling=true
}

input{
    ...
    numlock_by_default = true
    accel_profile = flat
    natural_scroll=true
}

exec-once = qs -c noctalia-shell
exec-once = /usr/lib/hyprpolkitagent/hyprpolkitagent
exec-once = fcitx5 -d
dolphin -> thunar

env = LANG,zh_CN.UTF-8
env = LC_CTYPE,en_US.UTF-8
env = XMODIFIERS,@im=fcitx
```


## 安装框架
```bash
sudo pacman -S xdg-desktop-portal-hyprland hyprpolkitagent qt5-wayland qt6-wayland
sudo pacman -S xdg-desktop-portal-gtk thunar tumbler ffmpegthumbnailer poppler-glib gvfs-smb file-roller thunar-archive-plugin gnome-keyring

sudo ln -s /usr/bin/ghostty /usr/bin/gnome-terminal

sudo pacman -S xdg-user-dirs
LANGUAGE=en_US.UTF-8 xdg-user-dirs-update --force
```

## 截图

```bash
paru -S satty slurp grim
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

# 字体查看
sudo pacman -S gucharmap gnome-font-viewer

sudo pacman -S mission-center gnome-text-ditor gnome-disk-utility gnome-clocks gnome-calculator loupe snapshot showtime file-roller zen-browser zen-browser-i18n-zh-cn gst-plugin-pipewire gst-plugins-good amberol gnome-calendar gnome-screenshot mpv sushi
sudo pacman -S tesseract-data-chi_sim tesseract-data-chi_tra tesseract-data-eng pot-translation
paru -S microsoft-edge-stable-bin 
paru -S appimagelauncher

