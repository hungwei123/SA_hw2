#!/bin/sh

check() {
	exist1=$(cat cos_table.txt | awk '{print $1,$2}' | grep ${day1} |  grep "[$tim1]") 
	if [ $day_n > 1 ];then
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

insert(){
	echo "insert here"
	cat pre_cos_table.txt
	cat pre_cos_table.txt >> cos_table.txt 
}

get_cos_info() {
	cname=$(echo $one_cos | awk 'BEGIN{FS=" |,"}{for(i=3;i<=NF;i++)print $i}') 
	cname=$(echo $cname | sed 's/[[:space:]]/_/g')
	echo $cname
	day=$(echo $one_cos | awk 'BEGIN{FS=" |,"}{print $1}' | sed 's/[A-Z]/ /g')
	tim=$(echo $one_cos | awk 'BEGIN{FS=" |,"}{print $1}' | sed 's/[0-9]/ /g')
	echo $day
	echo $tim
	day_n=$( echo $day | awk '{print NF}')
	echo $day_n
	day1=$(echo $day | awk '{print $1}')
	echo $day1
	tim1=$(echo $tim | awk '{print $1}')
	echo $tim1
	echo "$day1 $tim1 $cname" > pre_cos_table.txt
	
	if [ $day_n > 1];then
		day2=$(echo $day | awk '{print $2}')
		echo $day2
		tim2=$(echo $tim | awk '{print $2}')
		echo $tim2
		echo "$day2 $tim2 $cname" >> pre_cos_table.txt
	fi
	res=$( check )
	echo $res
	if [ "$res" == "Not Exist!" ];then
	       insert
	       echo "done"
	fi
}

> checklist.txt

list=$(cat all_cos.txt | sed 's/[[:space:]]/,/g')

id=1
for line in $list
do
	echo "$id $line off" >> checklist.txt
	id=$(( $id + 1 ))
done

dialog --checklist "Choose one:" 80 80 10 \
	$(cat checklist.txt) 2>chosen_num.txt

if [ "$?" == "0" ];then
	for num in $(cat chosen_num.txt)
		do
		one_cos=$(grep "^$num " checklist.txt)
		one_cos=$(echo $one_cos | awk '{for(i=2;i<NF;i++)print $i}')
		echo $one_cos
		get_cos_info
	done
	sleep 5
	sh print.sh

	dialog --title "Timetable" --textbox formal_table.txt 150 100
fi
