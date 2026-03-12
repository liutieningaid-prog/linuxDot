#!/bin/bash

# 1. 指定一个临时的文件路径来保存截图
TEMP_IMG="/home/tom/Pictures/tmp/screenshot-$(date +%s).png"

# 2. 启动 gnome-screenshot 进行区域截屏，并将图片保存到临时文件
# 脚本会在这里暂停，等待你完成截屏
gnome-screenshot -a -f "$TEMP_IMG"

if [ -f "$TEMP_IMG" ]; then
    # 3. 使用 loupe 第一次打开图片。
    sushi "$TEMP_IMG"
    
    notify-send -t 500 -a sushi "截图成功" "$TEMP_IMG"
else
    # 如果用户取消了截屏（文件未创建），发送一个失败通知
    notify-send -i "dialog-error" "截图已取消" "未保存任何图片。"
fi


EXIT
# 4. 删除临时文件，确保进程结束后执行
# trap 'rm -f "$TEMP_IMG"' EXIT
