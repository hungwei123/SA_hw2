#!/bin/sh

check() {
	exist1=$(cat cos_table.txt | grep "^$day1" | awk '{print $2}' | grep "[$tim1]") 
	if [ $day_n -gt 1 ];then
		exist2=$(cat cos_table.txt | grep "^$day2" | awk '{print $2}' | grep "[$tim2]")
	else
		exist2=""
	fi
	if [ "$exist1" == "" -a "$exist2" == "" ];then
		echo "Not Exist!"
	else
		echo "Exist."
	fi
}	

insert() {
#	echo "insert here"
#	cat pre_cos_table.txt
	cat pre_cos_table.txt >> cos_table.txt
	echo $one_cos >> have_selected.txt
}

remove() {
	cos_selected=$(cat have_selected.txt)
	> remove_checklist.txt

	id2=1
	for line_cos in $cos_selected
	do
		echo "$id2 $line_cos off" >> remove_checklist.txt
		id2=$(( $id2 + 1 ))
	done
}

get_cos_info() {
	cname=$(echo $one_cos | awk 'BEGIN{FS=" |,"}{for(i=2;i<=NF;i++)print $i}') 
	cname=$(echo $cname | sed 's/[[:space:]]/_/g')
#	echo $cname
	day=$(echo $one_cos | awk 'BEGIN{FS=" |,"}{print $1}' | sed 's/[A-Z]/ /g')
	tim=$(echo $one_cos | awk 'BEGIN{FS=" |,"}{print $1}' | sed 's/[0-9]/ /g')
#	echo $day
#	echo $tim
	day_n=$( echo $day | awk '{print NF}')
#	echo $day_n
	day1=$(echo $day | awk '{print $1}')
#	echo $day1
	tim1=$(echo $tim | awk '{print $1}')
#	echo $tim1
	echo "$day1 $tim1 $cname" > pre_cos_table.txt
	
	if [ $day_n -gt 1 ];then
#		echo "have 2 days"
		day2=$(echo $day | awk '{print $2}')
#		echo $day2
		tim2=$(echo $tim | awk '{print $2}')
#		echo $tim2
		echo "$day2 $tim2 $cname" >> pre_cos_table.txt
	fi
	res=$( check )
#	echo $res
	if [ "$res" == "Not Exist!" ];then
	       insert
#	       echo "done"
	fi
}

get_rm_cos_info() {
	rm_cname=$(echo $rm_cos | awk 'BEGIN{FS=" |,"}{for(i=2;i<=NF;i++)print $i}') 
	rm_cname=$(echo $rm_cname | sed 's/[[:space:]]/_/g')
	rm_day=$(echo $rm_cos | awk 'BEGIN{FS=" |,"}{print $1}' | sed 's/[A-Z]/ /g')
	rm_tim=$(echo $rm_cos | awk 'BEGIN{FS=" |,"}{print $1}' | sed 's/[0-9]/ /g')
	rm_day_n=$( echo $rm_day | awk '{print NF}')
	rm_day1=$(echo $rm_day | awk '{print $1}')
	rm_tim1=$(echo $rm_tim | awk '{print $1}')
	echo "$rm_day1 $rm_tim1 $rm_cname" >> cos_table.txt
	
	if [ $rm_day_n -gt 1 ];then
		rm_day2=$(echo $rm_day | awk '{print $2}')
		rm_tim2=$(echo $rm_tim | awk '{print $2}')
		echo "$rm_day2 $rm_tim2 $rm_cname" >> cos_table.txt
	fi
	uniq -u cos_table.txt > cos_table.txt
}

show_menu () {

	dialog --menu "Menu" 20 60 14 1 "Show Your Timetable" 2 "Add New Courses" 3 "Remove Selected Courses" 4 "Reset Your Timetable" 5 "Exit" 2> menu_select.txt

	case $(cat menu_select.txt) in
	1)
		dialog --title "Timetable" --textbox formal_table.txt 150 100
		show_menu
		;;
	2)
		dialog --checklist "Add New Courses" 80 80 10 \
			$(cat checklist.txt) 2>chosen_num.txt
		if [ "$?" == "0" ];then
			for num in $(cat chosen_num.txt)
			do
			one_cos=$(grep "^$num " checklist.txt)
			one_cos=$(echo $one_cos | awk '{print $2}')
#			echo $one_cos
			get_cos_info
			done
#			sleep 5
			sh print.sh
			dialog --title "Timetable" --textbox formal_table.txt 150 100
		fi
		show_menu
		;;
	3)
		remove
		dialog --checklist "Removed Selected Courses" 80 80 10 \
			$(cat remove_checklist.txt) 2>remove_num.txt
		if [ $? == 0 ];then
			for rn in $(cat remove_num.txt)
			do
			rm_cos=$(grep "^$rn " remove_checklist.txt)
			rm_cos=$(echo $rm_cos | awk '{print $2}')
#			echo $rm_cos
			get_rm_cos_info
			done
#			sleep 5
			sh print.sh
			dialog --title "Timetable" --textbox formal_table.txt 150 100
		fi
		show_menu
		;;
	4)
		> cos_table.txt
		> have_selected.txt
		sh print.sh
		dialog --title "Timetable" --textbox formal_table.txt 150 100
		show_menu
		;;	
	5)
		dialog --title "Exit?" --yesno "Sure to exit?" 5 25 
		if [ $? == 1 ];then
			show_menu
		fi
		;;
	esac

}

##### build up checklist.txt

> checklist.txt

list=$(cat all_cos.txt | sed 's/[[:space:]]/,/g')

id=1
for line in $list
do
	echo "$id $line off" >> checklist.txt
	id=$(( $id + 1 ))
done


##### start up

show_menu
