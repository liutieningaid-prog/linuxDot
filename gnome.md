# 安装

## 镜像系统设置
```bash
### 连接wifi
iwctl
station wlan0 connect <wifiname> 
### 同步时间
timedatectl set-ntp true 
```

## 分区
```bash
cfdisk
mkfs.fat -F 32 /dev/nvme0n1p1
### 格式化btrfs根分区
mkfs.btrfs /dev/nvme0n1p2

### btrfs设置
mount -t btrfs -o compress=zstd /dev/nvme0n1p2 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@swap
btrfs subvolume list -p /mnt
umount /mnt

### 挂载
mount -t btrfs -o subvol=/@,compress=zstd /dev/nvme0n1p2 /mnt #根目录
mount --mkdir -t btrfs -o subvol=/@home,compress=zstd /dev/nvme0n1p2 /mnt/home #/home目录
mount --mkdir -t btrfs -o subvol=/@swap,compress=zstd /dev/nvme0n1p2 /mnt/swap #/swap目录
mount --mkdir /dev/nvme0n1p1 /mnt/boot/EFI    #EFI目录，/dev/nvme0n1p1替换为自己对应的efi分区名
sudo btrfs filesystem label /mnt Arch
```

## 安装
```bash

reflector -a 24 -c ca -f 10 --sort score --save /etc/pacman.d/mirrorlist --v

# -a（age） 24 指定最近24小时更新过的源
# -c（country） cn 指定国家为中国（可以增加邻国）
# -f（fastest） 10 筛选出下载速度最快的10个
# --sort score 按照下载速度和同步时间综合评分并排序，比单纯按照下载速度排序更可靠
# --save /etc/pacman.d/mirrorlist 将结果保存到/etc/pacman.d/mirrorlist
# --v（verbose） 过程可视化

vim /etc/pacman.conf
[archlinuxcn]
Server = https://repo.archlinuxcn.org/$arch

### 更新密钥
pacman -Sy archlinux-keyring
### 安装
pacstrap -K /mnt base base-devel linux-zen linux-firmware btrfs-progs
pacstrap /mnt networkmanager vim sudo # amd-ucode intel-ucode

# -K 复制密钥
# base-devel是编译其他软件的时候用的
# linux是内核，可以更换
# linux-firmware是固件
# btrfs-progs是btrfs文件系统的管理工具
```

## 交换空间
```bash
# btrfs
btrfs filesystem mkswapfile --size 4g --uuid clear /mnt/swap/swapfile
swapon /mnt/swap/swapfile
genfstab -U /mnt > /mnt/etc/fstab

# 其他
dd if=/dev/zero of=/mnt/swapfile bs=1M count=8192 status=progress
chmod 600 /mnt/swapfile
mkswap /mnt/swapfile
swapon /mnt/swapfile
genfstab -U /mnt > /mnt/etc/fstab
```

## 进入系统

```bash
cp /etc/pacman.conf  /mnt/etc/pacman.conf 
arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc #系统时钟写入主板硬件时钟
vim /etc/hostname

### 本地化
vim /etc/locale.gen
#### 插入 
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8


locale-gen
vim /etc/locale.conf
#### 插入
LANG=en_US.UTF-8

passwd
```

### grub引导

```bash
pacman -S grub efibootmgr os-prober
grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=ARCH 
--target指定架构
--efi-directory指定目录
--bootloader-id任意取一个启动项在bios里显示的名字

vim /etc/default/grub
```
1. GRUB_DEFAULT=0改成saved，再取消GRUB_SAVEDEFAULT=true的注释。这一步是记住开机的选择。
2. GRUB_CMDLINE_LINUX_DEFAULT里面去掉quiet以显示开机日志，loglevel设置日志等级为5。再添加nowatchdog modprobe.blacklist=sp5100_tco，禁用watchdog。intelcpu用户把sp5100_tco换成iTCO_wdt。
  - loglevel共7级，5级是一个信息量的平衡点。watchdog的目的简单来说是在系统死机的时候自动重启系统。这在服务器或者嵌入式上有用，但是对个人用户来说没有意义，禁用以节省系统资源、提高开机和关机速度
3. 手动写入或者取消最后一行GRUB_DISABLE_OS_PROBER=false的注释。这一步让grub使用os-prober生成其他系统的启动项

#### 生成配置文件
```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

### refind引导

```bash
pacman -S refind efibootmgr
refind-install --alldrivers --usedefault /dev/sdXY # 将 rEFInd 的文件复制到 esp/EFI/BOOT/ efi默认的启动项目
```
> 默认情况下 refind-install 只会为内核所在的文件系统安装驱动。 其他的文件系统需要手动安装，通过将 /usr/share/refind/drivers_x64/ 复制到 esp/EFI/refind/drivers_x64/, 或者你可以以 --alldrivers 选项安装。 这对于可启动的 USB 驱动器有帮助。
> 将 rEFInd 的文件安装到 ESP 后，验证 rEFInd 是否在与内核相同的目录中创建了包含内核参数的 refind_linux.conf。如果您使用 --usedefault 选项，则不会创建此配置文件，以 root 身份运行 mkrlconf 来创建它。

#### 配置可以查找的内核

1. 因为 Arch Linux 的内核文件名通常会带有特定的后缀，比如：vmlinuz-linux-zen，所以需要修改 extra_kernel_version_strings
```bash
vim /boot/EFI/efi/Boot/refind.conf

# 取消下面这行的注释
extra_kernel_version_strings linux-hardened,linux-zen,linux-lts,linux
```

2. 编辑/boot/refind_linux.conf
```bash
mkrlconf # 生成默认的配置文件
# 如果可以引导进入安装好的系统可以用，镜像系统中会变为镜像系统启动

lsblk -o NAME,PARTUUID,UUID # 查看PARTUUID

"Boot using default options"     "root=PARTUUID=50ad4c6c-b054-4df3-9bc1-3d840e4195c1 rootflags=subvol=@ rw add_efi_memmap initrd=boot\intel-ucode.img initrd=boot\initramfs-linux-zen.img nowatchdog modprobe.blacklist=iTCO_wdt"
"Boot using fallback initramfs"  "root=PARTUUID=50ad4c6c-b054-4df3-9bc1-3d840e4195c1 rootflags=subvol=@ rw add_efi_memmap initrd=boot\initramfs-linux-zen-fallback.img"
"Boot to terminal"               "root=PARTUUID=50ad4c6c-b054-4df3-9bc1-3d840e4195c1 rootflags=subvol=@ rw add_efi_memmap systemd.unit=multi-user.target"
```



> 重启

---

# 控制台

## 启动网络
```bash
systemctl enable --now NetworkManager 
nmtui
```

## 用户
```bash
useradd -m -g wheel <username> 
passwd <username>
vim /etc/sudoers
%wheel ALL=（ALL：ALL） ALL
```

## 安装字体与显卡驱动
```sh
sudo pacman -S openssh vim linux-headers 
# intel
sudo pacman -S mesa mesa-utils vulkan-mesa-layers
sudo pacman -S vulkan-intel lib32-vulkan-intel vulkan-tools 
sudo pacman -S libvdpau-va-gl  #将ffmpeg对nvidia的以来转移到intel gpu上
sudo pacman -S intel-gpu-tools # gputop 查看gpu使用
# sudo pacman -S xf86-video-intel intel-media-driver

# amd AMD Radeon 680M [Integrated]
pacman -S --needed mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon
pacman -S opencl-mesa lib32-opencl-mesa


## 虚拟机下安装驱动Virtio
sudo pacman -S qemu-guest-agent xf86-video-qxl spice-vdagent mesa vulkan-intel vulkan-virtio vulkan-tools virglrenderer
sudo systemctl status qemu-guest-agent spice-vdagentd 
sudo systemctl enable --now qemu-guest-agent
sudo systemctl enable --now spice-vdagentd


## 虚拟机下安装驱动VMware
sudo pacman -S  open-vm-tools xf86-input-vmmouse mesa vulkan-mesa-layers lib32-vulkan-mesa-layers vulkan-tools xf86-video-vesa
systemctl enable sshd vmtoolsd vmware-vmblock-fuse
# lib32-vulkan-virtio pacman -S 

# 查看vulkan与opengl输出
vulkaninfo
eglinfo -B
glxinfo | grep "OpenGL renderer"
```

## paru 与 font
```sh
pacman -Sy
pacman -S archlinuxcn-keyring 
pacman -S paru 
pacman -S wqy-zenhei  noto-fonts-emoji ttf-hack-nerd ttf-liberation ttf-maplemono ttf-maplemono-nf-unhinted ttf-maplemono-nf-cn-unhinted # noto-fonts
```


# 桌面环境
```sh
pacman -S gnome-desktop gdm  gnome-control-center ghostty #  foot
pacman -S  flatpak gnome-software
systemctl start gdm
systemctl enable gdm

pacman -S gvfs-smb gvfs-goa gvfs-google gvfs-dnssd
pacman -S menulibre 
paru -S nautilus-hide
# xdg-user-dirs-update
```
- gvfs-smb 文件夹smba支持
- gvfs-goa 文件夹支持与设置中账号的联动
- gvfs-google 文件中支持google
- gvfs-dnssd  文件中支持webdav
- menulibre 想隐藏的图标


## 安装声音与网络配置固件 与 服务

```
sudo pacman -S sof-firmware alsa-firmware alsa-ucm-conf
sudo pacman -S pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber

systemctl --user enable pipewire pipewire-pulse wireplumber
systemctl --user start pipewire pipewire-pulse wireplumber
# 图形界面
sudo pacman -S pavucontrol 
sudo pacman -S network-manager-applet dnsmasq
```
- 设置跃点
> 启动安装的软件或输入nm-connection-editor
> 跃点需手动设置为100,默认的-999会导致网络速率异常

## 蓝牙
```sh
sudo pacman -S bluez
lsmod | grep btusb
sudo systemctl enable --now bluetooth.service
```

## 桌面软件
```
sudo pacman -S mission-center gnome-text-ditor gnome-disk-utility gnome-clocks gnome-calculator loupe snapshot showtime file-roller zen-browser zen-browser-i18n-zh-cn gst-plugin-pipewire gst-plugins-good amberol gnome-calendar gnome-screenshot mpv sushi
sudo pacman -S tesseract-data-chi_sim tesseract-data-chi_tra tesseract-data-eng pot-translation
paru -S microsoft-edge-stable-bin 
paru -S appimagelauncher
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
- tesseract-data-chi_sim tesseract-data-chi_tra tesseract-data-eng pot-translation 翻译与OCR，不能直接截图，需要与gnome-screenshot搭配

### 未安装
- baobab磁盘使用情况分析工具，
- fragments是符合gnome设计理念的种子下载器
- foliate 电子书阅读器
- papers 精简的pdf阅读器
- linuxqq-appimage 是appimgae版qq
- wechat-appimage 是appimage版微信
- wps-office-cn 是wps
- wps-office-mui-zh-cn 是wps的中文语言包
- typora-free 是markdown编辑器
- albert 是一个启动器，类似plasma的kruner。在桌面弹出一个置顶的搜索框，有一系列功能
- imv 简易的图片播放器，不好用

## sublime
> https://blog.csdn.net/yelon_/article/details/130831525

1. 下载 Sublime Text 4143
2. 二进制编辑器bless打开
3. 807805000f94c1，替换为c64005014885c9


## flap 商店
- gradia
- refine
- Flatseal 管理flatpak应用的权限、环境变量之类的
- gradia编辑截图使用方法
可以对截图进行一些简单的添加文字、马赛克、图表、背景之类的操作
设置自定义快捷键的时候命令写：
```
flatpak run be.alexandervanhee.gradia --screenshot=INTERACTIVE
```
- refine 分数缩放 ，可变刷新率
- gpu_screen_recorder 类似nvidiaApp的录屏软件


## 关于字体

从网上搜索常用办公字体，下载解压后存放到~/.local/share/fonts里面（在这个目录下新建文件夹整理字体文件）。放进去之后刷新字体缓存 。
```bash
fc-cache --force
```



## open in any terminal

[GitHub - Stunkymonkey/nautilus-open-any-terminal](https://github.com/Stunkymonkey/nautilus-open-any-terminal)

这是一个在文件管理器“右键在此处打开终端”的功能

- 如果用的是ghostty
```bash
sudo pacman -S nautilus-python

# 其他终端仿真器
yay -S nautilus-open-any-terminal 
sudo glib-compile-schemas /usr/share/glib-2.0/schemas 
sudo pacman -S dconf-editor

# 修改配置，路径为/com/github/stunkymonkey/nautilus-open-any-terminal
# 重载nautilus
nautilus -q 
```

# 系统硬件设置
## 视频播放器开启硬件编解码
1. 方法一：配置文件

编辑mpv配置文件（记得打开一次mpv生成目录）
```bash
vim ~/.config/mpv/mpv.config

# 写入：
#使用vulkan后端
gpu-api=vulkan
#通用自动模式硬解
hwdec=auto-safe
```
celluloid首选项的配置文件页面，激活“加载mpv配置文件”，手动指定一下路径
2. 方法二：celluloid首选项

在首选项的杂项页面写入

hwdec=yes


## 快照 snapper
```bash
sudo pacman -S snapper btrfs-assistant
sudo btrfs subvolume create /.snapshots # 只在@子卷（root）创建镜像
````

- snapper 是创建快照的主要程序
- btrfs-assistant 是图形化管理btrfs和快照的软件
- snap-pac 是利用钩子在进行一些pacman命令的时候自动创建快照

```bash
# 自动生成快照启动项
sudo pacman -S grub-btrfs inotify-tools
reboot
sudo systemctl enable --now grub-btrfsd
```
具体使用方法
1. 打开btrfs assistant，切换到snapper settings页面。
2. 我们创建子卷的时候至少创建了一个@子卷和一个@home子卷，所以需要两个config（配置）。创建一个root配置，再创建一个home配置。
3. 然后到snapper页面下的New/Delete页面就可以新建和管理快照了，Browse/Restore页面选中快照后点restore可以恢复到那个快照的状态。
4. 如果你要同时快照root和home的话就分别创建一个root快照和home快照，恢复的时候各自恢复就行了。

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

## 性能模式切换工具 power-profiles-daemon
性能模式切换，有三个档位，performance性能、balance平衡、powersave节电。一般平衡档位就够用了，也不需要调节风扇什么的。

```bash
sudo pacman -S power-profiles-daemon
sudo systemctl enable --now power-profiles-daemon
```
不建议使用tlp或者auto-cpufreq，意义不大，这个易用而且足够。如果想折腾的话可以看附录TLP相关。tlp和auto-cpufreq都有对应的gnome扩展，但未经验证，不保证能用。

### 实用插件扩展
power tracker 显示电池充放电 auto power profile 配合powerProfilesDaemon使用，可以自动切换模式 power profile indicator 配合powerProfilesDaemon使用，面板显示当前模式


# 美化
sudo pacman -S  gnome-tweaks
paru -S la-capitaine-icon-theme
sudo pacman -S gnome-shell-extension-appindicator gnome-shell-extension-caffeine gnome-shell-extension-dash-to-dock gnome-shell-extension-desktop-icons-ng gnome-shell-extension-vitals
sudo pacman -S gnome-shell-extension-pano-git

## 拓展
⚠️ 警告：扩展在gnome桌面环境大版本更新的时候大概率会大面积失效，如果出现gnome桌面环境的更新，一定要先关闭所有扩展，谨慎行事
从商店安装蓝色的扩展管理器
flatpak 商店安装 ExtensionManager

1. input method panel 输入法拓展
2. AppIndicator and KStatusNotifierItem Support 状态上显示后台应用
3. caffeine 防止熄屏
4. lock keys 显示大写锁定和小键盘锁定。设置里把指示器风格改成show/hide cap-locks only
5. clipboard indicator 剪贴板历史
6. GNOME Fuzzy App Search 模糊搜索
7. steal my focus window 如果打开窗口时窗口已经被打开则置顶
8. tiling shell
  - 窗口平铺，tilingshell是用布局平铺,另一个叫forge是hyprland那种自动平铺但是很卡。推荐用tilingshell，记得自定义快捷键，我快捷键是super+w/a/s/d对应上下左右移动窗口，Super+Alt+w/a/s/d对应上下左右扩展窗口，super+c取消平铺。⚠️ 一定要取消智能边角弧度
9. color picker
10. vitals 系统资源
11. dask to dock
12. emoji copy
13. blur my shell 透明全任务
14. Arch Linux Updates Indicator 在面板上显示一个和arch更新相关的图标
15. quick close in overview  在概览里面不用点窗口右上角的叉关闭窗口了，而是使用鼠标中键
16. bottom overview 鼠标滑到屏幕底部边缘激活概览
17. logo menu 在面板显示一个logo，好玩
18. desktop cube 把工作区切换从平铺变成一个可以旋转的方块的面。设置的overview里把透明度（opacity）都改成50%，超级酷！
19. rounded window corners reborn 让所有窗口变成圆角。这个扩展是真神。 设置里取消激活skip libadwaita applications，然后把corner radius改成14，这样就和gnome的圆角没区别了
20. desktop icons ng
实现windows那样的桌面快捷方式。如果快捷方式打了个叉让你设置执行权限的话在终端去到~/Desktop目录，然后运行这个命令设置相信元数据。这是gnome的一个安全措施。
```bash
gio set ~/Desktop/*.desktop "metadata::trusted" true
```

21. 可选：arcmenu 这是功能强大的开始菜单扩展。需要pacman安装gnome-menus。

22. 可选：just perfection 功能强大的自定义扩展，可以设置gnome各个元素的开关。不过根据gnome版本的不同能设置的选项会有所不同，稳定性堪忧。

## 快捷键
右键桌面打开设置，选择键盘>查看及自定义快捷键
我的配置：

- 导航
```
super+shift+数字键 #将窗口移到工作区
super+shift+A/D #将窗口左右移动工作区
Super+数字键 #切换工作区
gnome默认super+滚轮上下可以左右切换工作区
alt+tab #切换应用程序
super+M #隐藏所有正常窗口
alt+` #在应用程序的窗口之间切换窗口
```
- 截图
```
ctrl+alt+A #交互式截图
```
- 打字
```
禁用快捷键
在fcitx5的configtool里面设置super+space切换输入法
```
- 无障碍
```
全部backspace退格键禁用
```
- 窗口
```
super+Q #关闭窗口
super+F #切换最大化
super+alt+F #切换全屏
```
- 系统
```
ctrl+super+S #打开快速设置菜单
super+G #显示全部应用
```
- 自定义快捷键<快捷键>   <命令>
```
super+B   zen
super+T   ghostty
ctrl+alt+S    missioncenter
super+E   nautilus
super+shift+S   flatpak run be.alexandervanhee.gradia --screenshot=INTERACTIVE
```

# 输入法

## ibus-rime
参考：Rime - Arch Linux 中文维基 | 可选配置（基础篇） | archlinux 简明指南 | RIME · GitHub

```bash
sudo pacman -S ibus ibus-rime
```
- ibus是ibus输入法的基本包
- ibus-rime是中州韵
然后重启

### 雾凇输入法
```bash
git clone https://github.com/iDvel/rime-ice.git ~/Project-DL/rime
ln -s ~/Project-DL/rime ~/.config/ibus/
```
将下载好的配置连接到配置目录

### extention
Customize IBus

## fcitx5
```
sudo pacman -S fcitx5-im fcitx5-chinese-addons fcitx5-rime rime-ice-pinyin-git # fcitx5-mozc 
```
1. mozc是g谷歌日语输入法的开源版本
2. fcitx5-rime是输入法引擎
3. rime-ice-pinyin-git是雾凇拼音输入法

### 设置为雾凇输入法
编辑rime的配置文件设置输入法方案为雾凇拼音，如果没有文件夹和文件的话自己创建文件夹，然后编辑配置文件
``` bash
vim ~/.local/share/fcitx5/rime/default.custom.yaml 

# 写入
patch:
  # 这里的 rime_ice_suggestion 为雾凇方案的默认预设
  __include: rime_ice_suggestion:/
``

### 其他设置
- 安装gnome扩展：[input method panel](https://extensions.gnome.org/extension/261/kimpanel/)
- 在fcitx5配置里面添加输入法，没有的话登出重新载入一次
- 编辑环境变量
```bash
sudo vim /etc/environment

XIM="fcitx" #解决wechat用不了输入法的问题
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
XDG_CURRENT_DESKTOP=GNOME #解决某些软件里面输入法吞字的问题
```
重启电脑


### wps用不了fcitx5
由于wps自身的问题，我们需要手动设置变量：
- 文字 (Writer): `/usr/bin/wps`
- 表格 (Spreadsheets): `/usr/bin/et`
- 演示 (Presentation): `/usr/bin/wpp`
```
export XMODIFIERS=@im=fcitx 
export QT_IM_MODULE=fcitx 
export GTK_IM_MODULE=fcitx
```

### 卸载fcitx5
```bash
sudo pacman -Rns fcitx5-im fcitx5-chinese-addons fcitx5-mozc fcitx5-rime rime-ice-pinyin-git
删除残留文件

sudo rm -rfv ~/.config/fcitx5 ~/.local/fcitx5
清理环境变量

sudo vim /etc/environment
```

# KVM

```bash
# sudo pacman -S qemu-full qemu-emulators-full virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat libvirt
sudo pacman -S  qemu-full virt-manager virglrenderer
sudo systemctl enable --now libvirtd
sudo virsh net-start default #开启nat网络
sudo virsh net-autostart default #自动启动nat网络
virsh net-edit default

sudo usermod -a -G libvirt $(whoami)
sudo vim /etc/libvirt/qemu.conf
```
```conf
#修改
user = "tom"
group = "libvirt"
```
```sh
sudo systemctl restart libvirtd
# 零时开启嵌套虚拟化
modprobe kvm_intel nested=1
# 永久生效
sodu vim /etc/modprobe.d/kvm_intel.conf
## 写入
options kvm_intel nested=1
# 重新生成
sudo mkinitcpio -P
```



```bash
sudo apt update
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients virt-manager bridge-utils virt-viewer dnsmasq libosinfo-bin

sudo usermod -aG libvirt $(whoami)
sudo usermod -aG kvm $(whoami)

sudo vim /etc/libvirt/qemu.conf
# 找到并修改为你的用户名
user = "your_username"
group = "libvirt"

sudo systemctl enable --now libvirtd
sudo systemctl restart libvirtd

#3. 配置虚拟网络 (NAT)
sudo virsh net-start default
sudo virsh net-autostart default

#4. 开启嵌套虚拟化 (Nested Virtualization)
# 以 Intel 为例
echo "options kvm_intel nested=1" | sudo tee /etc/modprobe.d/kvm_intel.conf
sudo update-initramfs -u
```


## 显卡直通

1. 确认iommu是否开启，有输出说明开启
```
sudo dmesg | grep -e DMAR -e IOMMU
```

2. 获取显卡的硬件id，如果是显卡所在group的所有设备的id都记下。如果group里有cpu的话去看wiki。
```
for d in /sys/kernel/iommu_groups/*/devices/*; do 
    n=${d#*/iommu_groups/*}; n=${n%%/*}
    printf 'IOMMU Group %s ' "$n"
    lspci -nns "${d##*/}"
done
```

3. 隔离GPU
```bash
sudo vim /etc/modprobe.d/vfio.conf
options vfio-pci ids=10de:25a9

cat /etc/mkinitcpio.conf
MODULES=(vfio_pci vfio vfio_iommu_type1)
HOOKS=(... modconf ...)
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck)

sudo mkinitcpio -P
```

4. 安装和配置ovmf
```bash
sudo pacman -S edk2-ovmf
sudo vim /etc/libvirt/qemu.conf

nvram = [
	"/usr/share/ovmf/x64/OVMF_CODE.fd:/usr/share/ovmf/x64/OVMF_VARS.fd"
]

sudo systemctl restart libvirtd
```

5. 虚拟机内检查
```bash
dmesg | grep drm
```

# shell
```sh
sudo pacman -S pacman-contrib havn bluetui # stew fnt
```
- pacman-contrib 是pacman的一些小工具 pactree, pacsearch checkupdates
- havn    #端口扫描
- bluetui #蓝牙管理
- stew    #github二进制安装
- fnt     #适用于字体的字体管理器

```sh
sudo pacman -S oh-my-posh curl wget ripgrep fd zsh atuin stow # git
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

# 脚本与自定义

## 剪贴板通过管道计算
```bash
pacman -Ss wl-clipboard


```


## launcher-albert
```bash
pacman -S albert qt6-wayland qt5-wayland


```

## 翻墙
```bash
paru -S flclash-bin

```
