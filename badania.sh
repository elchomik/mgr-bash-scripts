#!/bin/bash

start_time=$(date +%s) #początek rozpoczęcia wykonywania skryptu

VIRT_sum=0
RES_sum=0
SHR_sum=0
CPU_sum=0.0
MEM_sum=0.0
counter=0

while true
do
	current_time=$(date +%s) #aktualny czas
		
	if [ $((current_time - start_time)) -ge 180 ] #jeśli minęły 3 minuty zakończ badanie
	then 
		break
	fi
	
	if adb shell dumpsys window windows | grep -E 'mCurrentFocus|mFocusedApp' | grep com.mgr_app >/dev/null
	then
		result=$(adb shell top -n 1 -d 5 | grep com.mgr_app | awk '{ printf "%s,%s,%s,%s,%s,%s,%s,%s,%s,%.2f,%s,%s\n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12 }') 
		echo $result >> ~/Desktop/wyniki/wyniki_react/dane_$1.txt
		counter=$((counter+1)) #zwiększ licznik służący do sprawdzania ilości zapisanych rekordów
		
		VIRT_col=$(echo $result | awk -F',' '{print $5}' | sed 's/[a-zA-Z]//g') #wyłączenie string z wartości $5
		RES_col=$(echo $result | awk -F',' '{print $6}' | sed 's/[a-zA-Z]//g')
		SHR_col=$(echo $result | awk -F',' '{print $7}' | sed 's/[a-zA-Z]//g')
		CPU_col=$(echo $result | awk -F',' '{print $9}')
		MEM_col=$(echo $result | awk -F',' '{print $10}')
		
		VIRT_sum=$((VIRT_sum + VIRT_col))
		RES_sum=$((RES_sum + RES_col))
		SHR_sum=$((SHR_sum + SHR_col))
		CPU_sum=$(awk "BEGIN { printf \"%.2f\", $CPU_sum + $CPU_col }")
		MEM_sum=$(awk "BEGIN { printf \"%.2f\", $MEM_sum + $MEM_col }")
	else
		difference=$((current_time - start_time)) # jeśli użytkwonik wcześniej skończył badanie wtedy do oddzielnego pliku 
		echo "Nastąpiło wyjście z aplikacji po $difference sekundach od rozpoczęcia badania ilość kolumn to $counter" >> ~/Desktop/wyniki/wyniki_react/$1.txt
		break
	fi
done	

srednia_VIRT=$((VIRT_sum / counter))
srednia_RES=$((RES_sum / counter))
srednia_SHR=$((SHR_sum / counter))
srednia_CPU=$(awk "BEGIN { printf \"%.2f\", $CPU_sum / $counter }")
srednia_MEM=$(awk "BEGIN { printf \"%.2f\", $MEM_sum / $counter }")

echo "Zarejestrowano $counter rekordów"
echo "Suma VIRT $VIRT_sum"
echo "Suma RES $RES_sum"
echo "Suma SHR $SHR_sum"
echo "Suma CPU $CPU_sum"
echo "Suma MEM $MEM_sum"
echo ""
echo "Średnia VIRT $srednia_VIRT"
echo "Średnia RES $srednia_RES"
echo "Średnia SHR $srednia_SHR"
echo "Średnia CPU $srednia_CPU"
echo "Średnia MEM $srednia_MEM"

echo "Badanie zostało zakończone!!!!!!!!"