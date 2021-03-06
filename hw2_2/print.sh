#!/bin/sh

eleven=1

put_in_table (){
	group=$(cat cos_table.txt | grep "^$1")
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

	begin=1;end=10
	row=1
	print_cos_time_info=1

	while [ $row -le 7 ]
	do
		if [ $print_cos_time_info -eq 1 ];then
			printf "|%s" $seek >> formal_table.txt
		else
			printf "|-" >> formal_table.txt
		fi
		print_cos_time_info=$(( $print_cos_time_info + 1 ))
		
		for col in $@
		do
			printf "|%-10s" $(echo $col | cut -c $begin-$end) >> formal_table.txt
		done
		printf "|\n" >> formal_table.txt
		begin=$(( $begin + 10 ))
		end=$(( $end + 10 ))
		row=$(( $row + 1 ))
	done
}

>formal_table.txt

echo "   .Mon       .Tue       .Wed       .Thr       .Fri      " >> formal_table.txt
echo "   ========== ========== ========== ========== ==========" >> formal_table.txt

while [ $eleven -le 11 ]
do
	seek=$(awk 'BEGIN{printf "%c", 64+'$eleven'}')
	
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
	echo "   ---------- ---------- ---------- ---------- ----------" >> formal_table.txt
	eleven=$(( $eleven + 1 ))
done
