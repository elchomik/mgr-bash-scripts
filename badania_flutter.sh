#!/bin/bash

start_time=$(date +%s) #początek rozpoczęcia wykonywania skryptu

VIRT_sum=0.0
RES_sum=0
SHR_sum=0
CPU_sum=0.0
MEM_sum=0.0
counter=0
wynik=""

while true
do
	current_time=$(date +%s) #aktualny czas
		
	if [ $((current_time - start_time)) -ge 500 ] #jeśli minęły 3 minuty zakończ badanie
	then 
		break
	fi
	
	if adb shell dumpsys window windows | grep -E 'mCurrentFocus|mFocusedApp' | grep com.example.mgr_app_flutter >/dev/null
	then
		result=$(adb shell top -n 1 -d 1 | grep com.example.mgr+ | awk '{ printf "%s,%s,%s,%s,%.2f,%s,%s,%s,%s,%.2f,%s,%s\n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12 }') 
		
		if [ -n "$result" ]; then 
			echo $result >> ~/Desktop/wyniki/wyniki_flutter/dane_szczegolowe_user_$1.txt
			counter=$((counter+1)) #zwiększ licznik służący do sprawdzania ilości zapisanych rekordów
		
			VIRT_col=$(echo $result | awk -F',' '{print $5}' | sed 's/[a-zA-Z]//g') #wyłączenie string z wartości $5
			RES_col=$(echo $result | awk -F',' '{print $6}' | sed 's/[a-zA-Z]//g')
			SHR_col=$(echo $result | awk -F',' '{print $7}' | sed 's/[a-zA-Z]//g')
			CPU_col=$(echo $result | awk -F',' '{print $9}')
			MEM_col=$(echo $result | awk -F',' '{print $10}')
		
			VIRT_sum=$(awk "BEGIN { printf \"%.2f\", $VIRT_sum + $VIRT_col }")
			RES_sum=$((RES_sum + RES_col))
			SHR_sum=$((SHR_sum + SHR_col))
			CPU_sum=$(awk "BEGIN { printf \"%.2f\", $CPU_sum + $CPU_col }")
			MEM_sum=$(awk "BEGIN { printf \"%.2f\", $MEM_sum + $MEM_col }")
		fi
	else
			difference=$((current_time - start_time)) # jeśli użytkwonik wcześniej skończył badanie wtedy do oddzielnego pliku 
			wynik+="Nastąpiło wyjście z aplikacji po $difference sekundach od rozpoczęcia badania ilość kolumn to $counter"
			break
	fi
done	

srednia_VIRT=$(awk "BEGIN { printf \"%.2f\", $VIRT_sum / $counter }")
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

echo "Zebrane dane podczas badania zostaną zapisane do pliku "
echo ""
wynik+="Suma VIRT $VIRT_sum, Srednia VIRT $srednia_VIRT "
wynik+="Suma RES $RES_sum, Srednia RES $srednia_RES "
wynik+="Suma SHR $SHR_sum, Srednia SHR $srednia_SHR "
wynik+="Suma CPU $CPU_sum, Srednia CPU $srednia_CPU "
wynik+="Suma MEM $MEM_sum, Srednia MEM $srednia_MEM "

echo $wynik >> ~/Desktop/wyniki/wyniki/wyniki_flutter/dane_usrednione_user_$1.txt

echo "Badanie zostało zakończone!!!!!!!!"