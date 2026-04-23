#!/bin/bash

# 获取当前活动窗口的工作区名称
ADDR=$(hyprctl activewindow -j | jq -r '.address')
WORKSPACE=$(hyprctl activewindow -j | jq -r '.workspace.name')

if [[ "$WORKSPACE" == "special:minimized" ]]; then
    # 如果在特殊工作区，就把它抓回当前普通工作区
    hyprctl dispatch movetoworkspace e+0
else
    # 如果在普通工作区，就把它送进特殊工作区
    hyprctl dispatch movetoworkspacesilent special:minimized
fi