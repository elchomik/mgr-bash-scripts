#!/bin/bash

start_time=$(date +%s) #początek rozpoczęcia wykonywania skryptu

while true
do
	current_time=$(date +%s) #aktualny czas
	
	if [ $((current_time - start_time)) -ge 180 ] #jeśli minęły 3 minuty zakończ badanie
	then 
		break
	fi
	
	if adb shell dumpsys window windows | grep -E 'mCurrentFocus|mFocusedApp' | grep com.mgr_app >/dev/null
	then
		adb shell top -n 1 -d 5 | grep com.mgr_app | awk '{ printf "%s,%s,%s,%s,%s,%s,%s,%s,%s,%.2f,%s,%s\n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12 }' >> ~/Desktop/wyniki/wyniki_react/dane_$1.txt
	else
		difference=$((current_time - start_time)) # jeśli użytkwonik wcześniej skończył badanie wtedy do oddzielnego pliku 
		echo "Nastąpiło wyjście z aplikacji po $difference sekundach od rozpoczęcia badania" >> ~/Desktop/wyniki/wyniki_react/$1.txt
		break
	fi
done	