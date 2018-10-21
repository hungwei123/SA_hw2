#!/bin/sh

i=1
n=12

#j="A"
#k=2

set a,b,c,d,e

check() {
	#$(cat wow.txt | grep ""
}	

insert(){


}

func () {
	day=$(echo $wow | awk 'BEGIN{FS=" |,"}{print $2}' | sed 's/[A-Z]/ /g')
	cos=$(echo $wow | awk 'BEGIN{FS=" |,"}{print $2}' | sed 's/[0-9]/ /g')
	echo $day > day_cos.txt
	echo $cos > day_cos.txt
	day1=$(echo $day | awk 'print $1')

#	if [ $k == 1 ];then a="Intro to Phy"
#	elif [ $k == 2 ]; then a="Competitive Programming"
#	else a="Algorithm"	
#	fi
}

#exec < test2

#rm output.txt

#p=1
#while read line
#do
	#line=$line | sed 's/ //'
#	echo "$p $line"
#	p=$(( $p + 1 ))
#done

#cat output.txt
#rm output.txt

> output2.txt

#var=$(cat test1 | sed 's/[ ]$//g')
var=$(cat test1 | sed 's/[[:space:]]/,/g')

p=1
for line in $var
do
	#line=$(echo $line | sed 's/,/ /g')
	echo "$p $line off" >> output2.txt
	p=$(( $p + 1 ))
done

#cat output2.txt

#cat 'test1' | awk 'BEGIN{FS=","}{print $1}'

dialog --checklist "Choose one:" 80 80 10 \
	$(cat output2.txt) 2>res.txt

>see_res.txt
wow.txt
class_table.txt

for num in $(cat res.txt)
do
	echo $num >> see_res.txt
	wow=$(grep "^$num " output2.txt)
	#func
	#echo $wow >> wow2.txt
	echo $wow | awk '{for(i=2;i<NF;i++)print $i}' >> wow.txt
	# class_table.txt
done

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

		
while [ $i -le $n ]
do
	if [ $i == 1]
	then
		echo ".Mon   .Tue   .Wed   .Thr   .Fri  "
	else
		echo "====== ====== ====== ====== ======"
	fi

#	func

	echo "|$a    |$b    |$c    |$d    |$e   "
	echo "|      |      |      |      |     "
	echo "|      |      |      |      |     "
	echo "|      |      |      |      |     "
	echo "|      |      |      |      |     "
	i=$(( $i + 1 ))
done

