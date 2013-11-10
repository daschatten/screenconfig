#!/bin/bash


# output names extracted from 'xrandr -q'
IN="LVDS1"
EXT1="VGA1"
EXT2="HDMI3"

USER="myuser"

export XAUTHORITY=/home/$USER/.Xauthority
export DISPLAY=:0.0

statusIN="$(cat /sys/class/drm/card0-LVDS-1/status)"
statusEXT1="$(cat /sys/class/drm/card0-VGA-1/status)"
statusEXT2="$(cat /sys/class/drm/card0-HDMI-A-3/status)"

if ( ( [ "${statusEXT1}" = "connected" ] ) && ( [ "${statusEXT2}" = "connected" ] ))
then
    echo "Found two external outputs: '$EXT1' and '$EXT2'"
    xrandr --output $IN --off
    xrandr --output $EXT1 --auto
    xrandr --output $EXT2 --auto --right-of $EXT1 --primary
elif ( [ "${statusEXT1}" = "connected" ] )
then
    echo "Found one external output: '$EXT1'"
    xrandr --output $EXT2 --off
    xrandr --output $IN --auto
    xrandr --output $EXT1 --auto --right-of $IN --primary
elif ( [ "${statusEXT2}" = "connected" ] )
then
    echo "Found one external output: '$EXT2'"
    xrandr --output $EXT1 --off
    xrandr --output $IN --auto
    xrandr --output $EXT2 --auto --right-of $IN --primary
else
    echo "Found no external output."
    xrandr --output $EXT1 --off
    xrandr --output $EXT2 --off
    xrandr --output $IN --auto
fi
