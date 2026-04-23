
## 子系统

```bash
sudo pacman -S --needed fuse3 distrobox podman
sudo systemctl enable --now dbus.socket
# 选择crun

# 查看subid有没有用户
cat /etc/subgid
cat /etc/subuid
# 如果为空
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 $(whoami)


# 挂载
sudo pacman -S --needed fuse-overlayfs
mkdir -p ~/.config/containers
vim ~/.config/containers/storage.conf

"""conf
[storage]
driver = "overlay"
# 指向你想要的位置，确保你的用户对该目录有读写权限
graphroot = "/home/tim/vbox/podman/"

[storage.options.overlay]
mount_program = "/usr/bin/fuse-overlayfs"
"""
podman system migrate

# distrobox
distrobox create -n void-dev --image ghcr.io/void-linux/void-glibc-full:latest --home ~/vbox/distrobox-void/
distrobox create --name arch-dev --init --image archlinux:latest --home ~/vbox/distrobox-arch/


distrobox rm -f debian-test
distrobox rm -f arch-dev
# 开启
distrobox enter void-dev
# ctrl c 关闭,  此时系统已经在后台了
distrobox list
```


## bug

### 默认文件夹被修改
```bash
xdg-mime query default inode/directory
xdg-mime default thunar.desktop inode/directory
```