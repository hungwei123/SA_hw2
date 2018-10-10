#!/bin/sh

eleven=1

put_in_table (){
	group=$(cat cos_table.txt | grep "^$1")
	seek=$(awk 'BEGIN{printf "%c", 64+'$eleven'}')
	cat cos_table.txt | grep "^$1" > cos_n.txt
	cos_name=$(awk -v pat="$seek" '$2 ~ pat{print $3}' cos_n.txt)

	if [ "$cos_name" == "" ];then
		cos_name="-"
	else
		cos_name=$(echo $cos_name | awk '{print $1}')
	fi
	echo $cos_name
}

CutString (){

	begin=1;end=7
	row=1
	
	while [ $row -le 5 ]
	do
		for col in $@
		do
			printf "|%-7s" $(echo $col | cut -c $begin-$end)
		done
		printf "\n"
		begin=$(( $begin + 7 ))
		end=$(( $end + 7 ))
		row=$(( $row + 1 ))
	done
}

echo " .Mon    .Tue    .Wed    .Thr    .Fri   "
echo " ======= ======= ======= ======= ======="

while [ $eleven -le 11 ]
do
	a=$( put_in_table 1)
	b=$( put_in_table 2)
	c=$( put_in_table 3)
	d=$( put_in_table 4)
	e=$( put_in_table 5)
	
	a=$(printf "%-35s\n" $a)
	b=$(printf "%-35s\n" $b)
	c=$(printf "%-35s\n" $c)
	d=$(printf "%-35s\n" $d)
	e=$(printf "%-35s\n" $e)
	
	CutString $a $b $c $d $e
	echo " ------- ------- ------- ------- -------"
	eleven=$(( $eleven + 1 ))
done
