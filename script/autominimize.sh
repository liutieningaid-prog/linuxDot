#!/bin/bash

# sudo pacman -S socat


# 记录上一个窗口的地址
last_address=""

# 监听 Hyprland 事件流
# activewindowv2 事件会在焦点改变时发出窗口地址和类名
handle() {
  case $1 in
    activewindowv2*)
      # 提取当前新获得焦点的窗口地址
      current_address="0x${1#*v2>>}"
      current_address="${current_address%,*}"

      # 如果上一个窗口地址存在，且不等于当前窗口
      if [[ -n "$last_address" && "$last_address" != "$current_address" ]]; then
        # 检查上一个窗口是否依然存在，且是否为浮动窗口
        is_floating=$(hyprctl clients -j | jq -r ".[] | select(.address == \"$last_address\") | .floating")
        
        if [[ "$is_floating" == "true" ]]; then
          # 将失去焦点的浮动窗口移入特殊工作区
          hyprctl dispatch movetoworkspacesilent special:minimized,address:$last_address
        fi
      fi
      
      # 更新上一个窗口地址
      last_address="$current_address"
      ;;
  esac
}

# 通过 socat 监听 Hyprland 的事件 socket
socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done