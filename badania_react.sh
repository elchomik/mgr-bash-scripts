#!/bin/bash

start_time=$(date +%s) #początek rozpoczęcia wykonywania skryptu

VIRT_sum=0
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
	
	if adb shell dumpsys window windows | grep -E 'mCurrentFocus|mFocusedApp' | grep com.mgr_app >/dev/null
	then
		result=$(adb shell top -n 1 -d 1 | grep com.mgr_app | awk '{ printf "%s,%s,%s,%s,%s,%s,%s,%s,%s,%.2f,%s,%s\n", $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12 }') 
		if [ -n "$result" ]; then
			echo $result >> ~/Desktop/wyniki/wyniki_react/dane_usrednione/dane_szczegolowe_$1.txt
			counter=$((counter+1)) #zwiększ licznik służący do sprawdzania ilości zapisanych rekordów
		
			VIRT_col=$(echo $result | awk -F',' '{print $5}' | sed 's/[a-zA-Z]//g') #wyłączenie string z wartości $5
			RES_col=$(echo $result | awk -F',' '{print $6}' | sed 's/[a-zA-Z]//g')
			SHR_col=$(echo $result | awk -F',' '{print $7}' | sed 's/[a-zA-Z]//g')
			CPU_col=$(echo $result | awk -F',' '{print $9}')
			MEM_col=$(echo $result | awk -F',' '{print $10}')
			TIME=$((current_time - start_time))
			
			#zapisanie danych do pliku tymczasowego, z którego odczytuje skrypt Pythona
			echo "$VIRT_col,$RES_col,$SHR_col,$CPU_col,$MEM_col,$TIME" >> ~/Desktop/wyniki/wyniki_react/dane_python/user_$1.csv
			
			VIRT_sum=$((VIRT_sum + VIRT_col))
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

echo "Zebrane dane podczas badania zostaną zapisane do pliku "
echo ""
wynik+="Suma VIRT $VIRT_sum, Srednia VIRT $srednia_VIRT \n"
wynik+="Suma RES $RES_sum, Srednia RES $srednia_RES \n"
wynik+="Suma SHR $SHR_sum, Srednia SHR $srednia_SHR \n"
wynik+="Suma CPU $CPU_sum, Srednia CPU $srednia_CPU \n"
wynik+="Suma MEM $MEM_sum, Srednia MEM $srednia_MEM \n"

sumy="$VIRT_sum,$RES_sum,$SHR_sum,$CPU_sum,$MEM_sum,$difference"
srednie="$srednia_VIRT,$srednia_RES,$srednia_SHR,$srednia_CPU,$srednia_MEM,$difference"

echo $wynik >> ~/Desktop/wyniki/wyniki_react/wyniki_react.txt
echo $sumy >> ~/Desktop/wyniki/wyniki_react/wyniki_react_sumy.txt
echo $srednie >> ~/Desktop/wyniki/wyniki_react/wyniki_react_srednie.txt

#Uruchomienie skryptu w Pythonie w tle
nohup python react.py user_$1.csv & 

echo "Badanie zostało zakończone!!!!!!!!"
