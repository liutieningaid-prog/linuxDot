
function vmmount --description "挂载固定的 VMware 虚拟硬盘"
    # --- 请在这里修改你的固定路径 ---
    set -l VMDK_FILE "/mnt/data/vbox-disk/Win10_Automation.vmdk"
    set -l MNT_DIR "/media/tom/autoDisk"
    set -l PART "nbd0p2"
    # ------------------------------

    # 1. 检查文件是否存在
    if not test -f "$VMDK_FILE"
        echo "❌ 错误：路径不存在 -> $VMDK_FILE"
        return 1
    end

    # 2. 准备挂载目录
    if not test -d "$MNT_DIR"
        sudo mkdir -p "$MNT_DIR"
    end

    # 3. 加载内核模块并连接设备
    echo "正在连接虚拟硬盘..."
    sudo modprobe nbd max_part=8 nbds_max=2
    sudo qemu-nbd --read-only --connect=/dev/nbd0 "$VMDK_FILE"

    sleep 0.5
    # 4. 挂载
    if sudo mount -t ntfs-3g /dev/$PART "$MNT_DIR" -o ro,nls=utf8 # -o uid=(id -u),gid=(id -g),nobarrier
        echo "✅ 挂载成功！"
        echo "路径：$MNT_DIR"
    else
        echo "❌ 挂载失败，正在断开连接..."
        sudo qemu-nbd --disconnect /dev/nbd0
    end
end


function vmumount --description "卸载 VMware 虚拟硬盘"
    set -l MNT_DIR "/media/tom/autoDisk"

    # 尝试卸载目录（即使目录不存在或已手动卸载，也继续执行断开 nbd）
    sudo umount "$MNT_DIR" 2>/dev/null

    # 彻底断开 nbd 设备
    if sudo qemu-nbd --disconnect /dev/nbd0
        echo "✅ 设备已成功断开"
    else
        echo "⚠️ 断开设备时出现问题或设备未连接"
    end
end