#!/bin/sh

#expand_num=1

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
			printf "|%s" $seek >> expand_formal_table.txt
		else
			printf "|-" >> expand_formal_table.txt
		fi
		print_cos_time_info=$(( $print_cos_time_info + 1 ))
		
		for col in $@
		do
			printf "|%-10s" $(echo $col | cut -c $begin-$end) >> expand_formal_table.txt
		done
		printf "|\n" >> expand_formal_table.txt
		begin=$(( $begin + 10 ))
		end=$(( $end + 10 ))
		row=$(( $row + 1 ))
	done
}

cos_expand() {

	while [ $expand_num -le $block_cos_num ]
	do
		seek=$(awk 'BEGIN{printf "%c", 64+'$expand_num'}')
		
		a=$( put_in_table 1) # 1 for Monday
		b=$( put_in_table 2)
		c=$( put_in_table 3)
		d=$( put_in_table 4)
		e=$( put_in_table 5)
		
		f=$( put_in_table 0) # 0 for Sunday
		g=$( put_in_table 6) # 6 for Saturday
		
		a=$(printf "%-35s\n" $a)
		b=$(printf "%-35s\n" $b)
		c=$(printf "%-35s\n" $c)
		d=$(printf "%-35s\n" $d)
		e=$(printf "%-35s\n" $e)
		
		f=$(printf "%-35s\n" $f)
		g=$(printf "%-35s\n" $g)
		
		CutString $f $a $b $c $d $e $g
		echo "   ---------- ---------- ---------- ---------- ---------- ---------- ----------" >> expand_formal_table.txt
		expand_num=$(( $expand_num + 1 ))
	done
}


>expand_formal_table.txt

echo "   .Sun       .Mon       .Tue       .Wed       .Thr       .Fri      .Sat           " >> expand_formal_table.txt
echo "   ========== ========== ========== ========== ========== ========== ==========" >> expand_formal_table.txt

expand_num=13;block_cos_num=14
cos_expand
expand_num=1;block_cos_num=4
cos_expand
expand_num=24;block_cos_num=24
cos_expand
expand_num=5;block_cos_num=8
cos_expand
expand_num=25;block_cos_num=25
cos_expand
expand_num=9;block_cos_num=12
cos_expand
