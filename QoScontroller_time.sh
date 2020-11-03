#! /bin/bash

INPUT_FILE=$1
#OUTPUT_FILE=$2

strfiltered=`grep -E -i "timer|Sending queued|Killing|Sending acknowledgement for status update TASK_STARTING|ACK for task status update TASK_GONE" $INPUT_FILE`

IFS=$'\n'
readarray  array <<< $strfiltered


	for str in ${array[@]}
	do

		instance=`echo -n $str|grep -P -o '[A-Za-z0-9]+\.instance.*?\..*?\.[0-9]+'| head -1 | tr -d "\n"`
		key_word=`echo $str|grep -E -o "timer_start_module|timer_end_module|timer_start_script|timer_end_script|Sending queued|Killing|TASK_STARTING|TASK_GONE"` 
		case $key_word in
			"Sending queued")
				echo -n "Sending queue  "
			;;
			"TASK_STARTING")
				echo -n "Task starting  "
			;;
			"TASK_GONE")
				echo -n "task gone      "
			;;
			"Killing")
				echo -n "killing signal "
			;;
			"timer_start_module")
				echo -n "start module   "
			;;
			 "timer_end_module")
				echo -n "end module     "
			;;
			 "timer_start_script")
				echo -n "start script   "
			;;
			 "timer_end_script")
				echo -n "end script     "
			;;
			
		esac
#make an array corresponding to task name having array corresponding to task status
		echo -n ", "
		echo -n $str|grep -E -o '[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{6}'|tr -d "\n"
		
		if case $key_word in timer*)false;;*) true;; esac; then
			echo -n ", "
			echo  $instance
		else
			echo ""
		fi
	done
