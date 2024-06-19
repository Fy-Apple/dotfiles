#!/bin/bash

# 取得所有的主题文件夹名称
theme_dirs=(~/.config/waybar/themes/*)
themes=()

# 定义不含色调的特殊主题
special_themes=("Default" "Minimal")

# 划分普通主题和特殊主题
for dir in "${theme_dirs[@]}"; do
    theme=$(basename "$dir")
    themes+=("$theme")
done

# 杀死所有正在运行的waybar实例
pkill waybar

# 读取上次的主题配置
if [ -f ~/.cache/.themestyle.sh ]; then
    themestyle=$(cat ~/.cache/.themestyle.sh)
else
    # 如果缓存文件不存在，则使用一个默认主题
    themestyle="/Top;/Top/light"
    touch ~/.cache/.themestyle.sh
    echo "$themestyle" > ~/.cache/.themestyle.sh
fi

# 随机选择一个主题
random_theme=${themes[$RANDOM % ${#themes[@]}]}

# 判断是否是特殊主题
if [[ " ${special_themes[@]} " =~ " ${random_theme} " ]]; then
    # 如果是特殊主题，不需要色调
    new_themestyle="/${random_theme};/${random_theme}"
else
    # 如果不是特殊主题，随机选择一个色调
    tones=("black" "colored" "dark" "light" "mixed" "white")
    random_tone=${tones[$RANDOM % ${#tones[@]}]}
    new_themestyle="/${random_theme};/${random_theme}/${random_tone}"
fi

IFS=';' read -ra arrThemes <<< "$new_themestyle"

# 更新缓存文件
echo "$new_themestyle" > ~/.cache/.themestyle.sh

# 启动 waybar 并加载新的配置
waybar -c ~/.config/waybar/themes${arrThemes[0]}/config -s ~/.config/waybar/themes${arrThemes[1]}/style.css&

echo "Switched to theme: ${arrThemes[0]}, style: ${arrThemes[1]}"