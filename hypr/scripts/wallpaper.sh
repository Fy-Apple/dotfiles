#!/bin/bash

# 壁纸目录
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
# 配置文件路径
CONFIG_FILE="$HOME/.config/hypr/hyprpaper.conf"

# 获取所有壁纸文件
wallpapers=("$WALLPAPER_DIR"/*)

# 检查目录是否非空
if [ ${#wallpapers[@]} -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# 定义函数从 hyprctl 的输出中提取显示器名称
get_monitors() {
    hyprctl monitors | grep 'Monitor ' | awk '{print $2}'
}

change_wallpaper() {
    # 初始化配置文件
    echo "splash = false" > "$CONFIG_FILE"

    # 按照显示器设置壁纸
    for monitor in $(get_monitors); do
        random_wallpaper=${wallpapers[RANDOM % ${#wallpapers[@]}]}
        # 预加载壁纸
        hyprctl hyprpaper preload "$random_wallpaper"
         # 写入配置文件
        echo "preload = $random_wallpaper" >> "$CONFIG_FILE"
        echo "wallpaper = $monitor,$random_wallpaper" >> "$CONFIG_FILE"
        sleep 0.5
        hyprctl hyprpaper wallpaper "$monitor,$random_wallpaper"
    done
    
    # 卸载未使用的壁纸
    hyprctl hyprpaper unload unused
}

case "$1" in
    init)
        # 初次启动 hyprpaper，并加载配置文件
        hyprpaper &
        sleep 2 # 让 hyprpaper 有时间启动

        if [ -f "$CONFIG_FILE" ]; then
            source "$CONFIG_FILE"
        fi
        ;;
    random)
        # 随机更换壁纸
        change_wallpaper
        ;;
    *)
        echo "Usage: $0 {init|random}"
        exit 1
        ;;
esac