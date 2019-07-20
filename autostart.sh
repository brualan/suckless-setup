#!/bin/sh

export _JAVA_AWT_WM_NONREPARENTING=1

ID=`xinput list | grep Touchpad | awk '{print substr($6,4)}'`

TAPING_ID=`xinput list-props $ID | grep "Tapping Enabled (" | awk '{print substr($4, 2, length($4)-3)}'`
NATURAL_SCROLLING_ID=`xinput list-props $ID | grep "Natural Scrolling Enabled (" | awk '{print substr($5, 2, length($5)-3)}'`
MIDDLE_CLICK_ID=`xinput list-props $ID | grep "Middle Emulation Enabled (" | awk '{print substr($5, 2, length($5)-3)}'`

xinput set-prop $ID $TAPING_ID 1
xinput set-prop $ID $NATURAL_SCROLLING_ID 1
xinput set-prop $ID $MIDDLE_CLICK_ID 1

# autoconnect to external monitor if present
[ `hostname` = "Aspire-E5-571" ] && /home/$USER/utils/monitors/autochoose

OLD_STATUSBAR=""
BATTERY_DEVICE=`upower -e | grep BAT`

while sleep 1; do
	DATETIME=`date +"%a %b%_d %H:%M"`
	BATTERYSTATE=`for x in /sys/class/power_supply/BAT?/capacity; do cat $x; done`
	BATTERY_LEFT=`upower -i $BATTERY_DEVICE | grep time | sed 's/[^0-9]*//'`
	VOLUME=`pactl list sinks | egrep "(Громкость|Volume)" | awk '{print "Vol:" $5}'`

	NEW_STATUSBAR=" Bat: $BATTERYSTATE% (left: $BATTERY_LEFT) || $VOLUME || $DATETIME"

	if [ "$NEW_STATUSBAR" != "$OLD_STATUSBAR" ]; then
		OLD_STATUSBAR=$NEW_STATUSBAR 
		xsetroot -name "$NEW_STATUSBAR"
	fi
done
