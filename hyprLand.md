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
pacman -S bluez
lsmod | grep btusb
sudo systemctl enable bluetooth.service
```

## su

```bash
su tom
systemctl --user enable pipewire pipewire-pulse wireplumber
paru -S noctalia-shell
```


# sys
```bash
systemctl --user start pipewire pipewire-pulse wireplumber
```

sudo pacman -S mission-center gnome-text-ditor gnome-disk-utility gnome-clocks gnome-calculator loupe snapshot showtime file-roller zen-browser zen-browser-i18n-zh-cn gst-plugin-pipewire gst-plugins-good amberol gnome-calendar gnome-screenshot mpv sushi
sudo pacman -S tesseract-data-chi_sim tesseract-data-chi_tra tesseract-data-eng pot-translation
paru -S microsoft-edge-stable-bin vscodium-bin
paru -S appimagelauncher

