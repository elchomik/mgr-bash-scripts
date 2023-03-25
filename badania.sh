#!/bin/bash

while true
do
	if adb shell dumpsys window windows | grep -E 'mCurrentFocus|mFocusedApp' | grep com.mgr_app >/dev/null
	then
		adb shell top -n 1 -d 5 | grep com.mgr_app | awk '{ print $1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11","$12 }' >> ~/Desktop/wyniki/wyniki_react/user1.csv
	fi
done	