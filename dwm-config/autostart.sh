#!/bin/sh

$HOME/utils/monitors/autochoose

export _JAVA_AWT_WM_NONREPARENTING=1

ID=`xinput list | mawk '/Touchpad/ {print substr($6,4)}'`

TAPING_ID=`xinput list-props $ID | mawk '/Tapping Enabled \(/ {print substr($4, 2, length($4)-3)}'`
NATURAL_SCROLLING_ID=`xinput list-props $ID | mawk '/Natural Scrolling Enabled \(/ {print substr($5, 2, length($5)-3)}'`
MIDDLE_CLICK_ID=`xinput list-props $ID | mawk '/Middle Emulation Enabled \(/ {print substr($5, 2, length($5)-3)}'`

xinput set-prop $ID $TAPING_ID 1
xinput set-prop $ID $NATURAL_SCROLLING_ID 1
xinput set-prop $ID $MIDDLE_CLICK_ID 1

OLD_STATUSBAR=""

while sleep 1; do
	DATETIME=`date +"%a %b %_d %H:%M"`
	BATTERYSTATE=`for x in /sys/class/power_supply/BAT?/capacity; do cat $x; done`
	VOLUME=`pactl list sinks | mawk '/^\t*(Громкость|Volume)/ {print "Vol:" $5}'`
	WIFI_NAME=`iwgetid -r`
	FREE_MEM=`free | mawk '/^Mem/ { if ($7 < 700000) { print " !!! LOW MEMORY !!! ||" } else { print "" } }'`

	NEW_STATUSBAR="$FREE_MEM ⚡ $BATTERYSTATE% || wifi: $WIFI_NAME || $VOLUME || $DATETIME"

	if [ "$NEW_STATUSBAR" != "$OLD_STATUSBAR" ]; then
		OLD_STATUSBAR=$NEW_STATUSBAR 
		xsetroot -name "$NEW_STATUSBAR"
	fi
done
