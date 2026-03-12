#!/bin/bash

# 定义OCR服务缓存目录和截图文件名
CACHE_DIR="$HOME/.cache/com.pot-app.desktop"
SCREENSHOT_FILE="pot_screenshot_cut.png"
SCREENSHOT_PATH="$CACHE_DIR/$SCREENSHOT_FILE"

# 确保缓存目录存在
mkdir -p "$CACHE_DIR"

# 移除旧的截图文件，避免误用
rm -f "$SCREENSHOT_PATH"

# 使用 gnome-screenshot 截图并保存到指定路径
gnome-screenshot -a -f "$SCREENSHOT_PATH"

# 检查截图是否成功
if [ ! -f "$SCREENSHOT_PATH" ]; then
    notify-send -i "dialog-error" "截图失败或已取消。"
    exit 1
fi

# 调用OCR服务
# 请根据您的实际情况修改端口号（例如：60828）
curl "127.0.0.1:60828/ocr_recognize?screenshot=false"


exit 0
