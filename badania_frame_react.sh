#!/bin/bash

start_time=$(date +%s) #początek rozpoczęcia wykonywania skryptu

wynik=""
srednie_wynik_user=""
total_frames_sum=0
janky_frames_sum=0
percentile_50_sum=0
percentile_90_sum=0
percentile_95_sum=0
percentile_99_sum=0
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
		result=$(adb shell dumpsys gfxinfo com.mgr_app)
	
		if [ -n "$result" ]; then
			counter=$((counter + 1))
			
			total_frame=$(echo "$result" | grep "Total frames rendered:" | awk '{print $4}')
			janky_frames=$(echo "$result" | grep "Janky frames:" | awk '{print $3}')
			janky_percent=$(echo "$result" | grep "Janky frames:" | awk '{print $4}' | sed 's/[()]//g')
			percentile_50=$(echo "$result" | grep "50th percentile:" | awk '{print $3}' | sed 's/ms//g')
			percentile_90=$(echo "$result" | grep "90th percentile:" | awk '{print $3}' | sed 's/ms//g')
			percentile_95=$(echo "$result" | grep "95th percentile:" | awk '{print $3}' | sed 's/ms//g')
			percentile_99=$(echo "$result" | grep "99th percentile:" | awk '{print $3}' | sed 's/ms//g')
			
			total_frames_sum=$((total_frames_sum + total_frame))
			janky_frames_sum=$((janky_frames_sum + janky_frames))
			percentile_50_sum=$((percentile_50_sum + percentile_50))
			percentile_90_sum=$((percentile_90_sum + percentile_90))
			percentile_95_sum=$((percentile_95_sum + percentile_95))
			percentile_99_sum=$((percentile_99_sum + percentile_99))
			
			wynik+="Total frames rendered: $total_frame, "
			wynik+="Janky frames: $janky_frames, "
			wynik+="Janky frames percentage: $janky_percent, "
			wynik+="50th percentile: $percentile_50, "
			wynik+="90th percentile: $percentile_90, "
			wynik+="95th percentile: $percentile_95, "
			wynik+="99th perentile:  $percentile_99, "
			wynik+="\n"
			
			echo $wynik >> ~/Desktop/wyniki/wyniki_react/wyniki_frame/dane_szczegolowe_user_$1.txt
		fi
	else
		difference=$((current_time - start_time)) # jeśli użytkwonik wcześniej skończył badanie wtedy do oddzielnego pliku 
		wynik+="Nastąpiło wyjście z aplikacji po $difference sekundach od rozpoczęcia badania "
		break
	fi
done	

srednia_total_frames=$(( total_frames_sum / counter))
srednia_janky_frames=$(( janky_frames_sum / counter))
srednia_percent_50=$(( percentile_50_sum / counter))
srednia_percent_90=$(( percentile_90_sum / counter))
srednia_percent_95=$(( percentile_95_sum / counter))
srednia_percent_99=$(( percentile_99_sum / counter))

srednie_procent_janky=$(awk "BEGIN { printf \"%.2f\", ($srednia_janky_frames / $srednia_total_frames) * 100 }")

srednie_wynik_user+="Średnia total_frame: $srednia_total_frames, "
srednie_wynik_user+=" Średnia janky_frame: $srednia_janky_frames, "
srednie_wynik_user+=" Średnia janky_frame(%): ${srednie_procent_janky}(%), "
srednie_wynik_user+=" Średnia percentage_50: ${srednia_percent_50}ms, "
srednie_wynik_user+=" Średnia percentage_90: ${srednia_percent_90}ms, "
srednie_wynik_user+=" Średnia percentage_95: ${srednia_percent_95}ms, "
srednie_wynik_user+=" Średnia percentile_99: ${srednia_percent_99}ms, "

echo $srednie_wynik_user >> ~/Desktop/wyniki/wyniki_react/wyniki_frame/dane_srednie_user_$1.txt
echo "Badanie zostało zakończone!!!!!!!!"