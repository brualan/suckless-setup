#!/bin/sh

$HOME/utils/monitors/autochoose

export _JAVA_AWT_WM_NONREPARENTING=1

ID=`xinput list | awk '/Touchpad/ {print substr($6,4)}'`

TAPING_ID=`xinput list-props $ID | awk '/Tapping Enabled \(/ {print substr($4, 2, length($4)-3)}'`
NATURAL_SCROLLING_ID=`xinput list-props $ID | awk '/Natural Scrolling Enabled \(/ {print substr($5, 2, length($5)-3)}'`
MIDDLE_CLICK_ID=`xinput list-props $ID | awk '/Middle Emulation Enabled \(/ {print substr($5, 2, length($5)-3)}'`

xinput set-prop $ID $TAPING_ID 1
xinput set-prop $ID $NATURAL_SCROLLING_ID 1
xinput set-prop $ID $MIDDLE_CLICK_ID 1

OLD_STATUSBAR=""

ophelia
