#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Scripts for volume controls for audio and mic 

print_error ()
{
cat << "EOF"
    ./volumecontrol.sh -[device] <actions>
    ...valid device are...
        i   -- input device
        o   -- output device
        p   -- player application
    ...valid actions are...
        i   -- increase volume [+5]
        d   -- decrease volume [-5]
        m   -- mute [x]
EOF
exit 1
}

# # Get icons
# get_icon() {
#     current=$(get_volume)
#     if [[ "$current" == "Muted" ]]; then
#         echo "$iDIR/volume-mute.png"
#     elif [[ "${current%\%}" -le 30 ]]; then
#         echo "$iDIR/volume-low.png"
#     elif [[ "${current%\%}" -le 60 ]]; then
#         echo "$iDIR/volume-mid.png"
#     else
#         echo "$iDIR/volume-high.png"
#     fi
# }

# # Notify
# notify_user() {
#     if [[ "$(get_volume)" == "Muted" ]]; then
#         notify-send -e -h string:x-canonical-private-synchronous:volume_notif -u low -i "$(get_icon)" "Volume: Muted"
#     else
#         notify-send -e -h int:value:"$(get_volume | sed 's/%//')" -h string:x-canonical-private-synchronous:volume_notif -u low -i "$(get_icon)" "Volume: $(get_volume)"
#         "$sDIR/Sounds.sh" --volume
#     fi
# }



# Toggle Mute
toggle_mute() {
	if [ "$(pamixer --get-mute)" == "false" ]; then
		pamixer -m #&& notify-send -e -u low -i "$iDIR/volume-mute.png" "Volume Switched OFF"
	elif [ "$(pamixer --get-mute)" == "true" ]; then
		pamixer -u #&& notify-send -e -u low -i "$(get_icon)" "Volume Switched ON"
	fi
}


# # Get Mic Icon
# get_mic_icon() {
#     current=$(pamixer --default-source --get-volume)
#     if [[ "$current" -eq "0" ]]; then
#         echo "$iDIR/microphone-mute.png"
#     else
#         echo "$iDIR/microphone.png"
#     fi
# }

# # Get Microphone Volume
# get_mic_volume() {
#     volume=$(pamixer --default-source --get-volume)
#     if [[ "$volume" -eq "0" ]]; then
#         echo "Muted"
#     else
#         echo "$volume%"
#     fi
# }

# # Notify for Microphone
# notify_mic_user() {
#     volume=$(get_mic_volume)
#     icon=$(get_mic_icon)
#     notify-send -e -h int:value:"$volume" -h "string:x-canonical-private-synchronous:volume_notif" -u low -i "$icon" "Mic-Level: $volume"
# }


# Execute accordingly
case $1 in
i)  # increase the volume
    if [ "$(pamixer --get-mute)" == "true" ]; then
        # unlock the volume if muted
        toggle_mute
    fi
    # increase the volume by 5% otherwise
    pamixer -i 5 --allow-boost --set-limit 150
    send_notification ;;
d)  # decrease the volume
    if [ "$(pamixer --get-mute)" == "true" ]; then
        # unlock the volume if muted
        toggle_mute
    fi
    pamixer -d 5
    send_notification ;;
m)  # mute the volume
    toggle_mute
    send_notification ;;
*)  # print error
    print_error ;;
esac