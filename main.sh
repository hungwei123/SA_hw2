#!/bin/sh

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
	cname=$(echo $one_cos | awk 'BEGIN{FS=":"}{print $2}') 
#	echo $cname
	cinfo=$(echo $one_cos | awk 'BEGIN{FS=":"}{print $1}' | sed 's/,/ /g')
	> pre_cos_table.txt
	collision=0
	for one in $cinfo
	do
		day=$(echo $one | awk 'BEGIN{FS="-"}{print $1}' | sed 's/[A-Z]/ /g')

		tim=$(echo $one | awk 'BEGIN{FS="-"}{print $1}' | sed 's/[0-9]/ /g')
		place=$(echo $one | awk 'BEGIN{FS="-"}{print $2}')
		cnt=1
		for d in $day
		do
			t=$(echo $tim | awk -v i="$cnt" '{print $i}')
#			echo $t
			echo "$d $t $place"-"$cname" >> pre_cos_table.txt
			cnt=$(( $cnt + 1 ))

			exist=$(cat cos_table.txt | grep "^$d" | awk '{print $2}' | grep "[$t]") 
			if [ "$exist" != "" ];then
				collision=$(( $collision + 1))
			fi
		done
	done

	if [ $collision == 0 ];then
	       insert
#	       echo "done"
	else
		echo $one_cos >> conflict.txt
	fi
}

get_rm_cos_info() {
	rm_cname=$(echo $rm_cos | awk 'BEGIN{FS=":"}{print $2}') 
	rm_cinfo=$(echo $rm_cos | awk 'BEGIN{FS=":"}{print $1}' | sed 's/,/ /g')
	for rm_one in $rm_cinfo
	do
		rm_day=$(echo $rm_one | awk 'BEGIN{FS="-"}{print $1}' | sed 's/[A-Z]/ /g')

		rm_tim=$(echo $rm_one | awk 'BEGIN{FS="-"}{print $1}' | sed 's/[0-9]/ /g')
		rm_place=$(echo $rm_one | awk 'BEGIN{FS="-"}{print $2}')
		rm_cnt=1
		for rm_d in $rm_day
		do
			rm_t=$(echo $rm_tim | awk -v i="$rm_cnt" '{print $i}')
#			echo $rm_t
			echo "$rm_d $rm_t $rm_place"-"$rm_cname" >> cos_table.txt
			rm_cnt=$(( $rm_cnt + 1 ))
		done
	done

	cat cos_table.txt | sort -n | uniq -u > not_r_w_simul.txt
	cat not_r_w_simul.txt > cos_table.txt
	rm not_r_w_simul.txt

	cat have_selected.txt | grep -v "$rm_cos" > not_r_w_simul.txt
	cat not_r_w_simul.txt > have_selected.txt
	rm not_r_w_simul.txt 
}

show_menu () {

	dialog --menu "Menu" 20 60 14 1 "Show Your Timetable" 2 "Show Expanded Timetable" 3 "Add New Courses" 4 "Remove Selected Courses" 5 "Reset Your Timetable" 2> menu_select.txt

	case $(cat menu_select.txt) in
	1)
		dialog --title "Timetable" --textbox formal_table.txt 150 70
		show_menu
		;;
	2)
		sh print_expand.sh	
		dialog --title "Expanded Timetable" --textbox expand_formal_table.txt 200 90
		show_menu
		;;
	3)
		> conflict.txt
		dialog --checklist "Add New Courses" 80 80 10 \
			$(cat checklist.txt) 2>chosen_num.txt
		if [ "$?" == "0" ];then
			for num in $(cat chosen_num.txt)
			do
				one_cos=$(grep "^$num " checklist.txt)
				one_cos=$(echo $one_cos | awk '{print $2}')
#				echo $one_cos
				get_cos_info
			done
			dialog --title "Conflict Courses:" --textbox conflict.txt 80 80
#			sleep 5
			sh print.sh
			dialog --title "Timetable" --textbox formal_table.txt 150 70
		fi
		show_menu
		;;
	4)
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
			dialog --title "Timetable" --textbox formal_table.txt 150 70
		fi
		show_menu
		;;
	5)
		> cos_table.txt
		> have_selected.txt
		sh print.sh
		dialog --title "Timetable" --textbox formal_table.txt 150 70
		show_menu
		;;	
	*)
		;;
	esac

}

##### build up checklist.txt

> checklist.txt

list=$(cat all_cos.txt)

id=1
for line in $list
do
	echo "$id $line off" >> checklist.txt
	id=$(( $id + 1 ))
done

##### start up

show_menu

##### end
