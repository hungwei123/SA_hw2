#!/bin/sh

cat json.txt | awk 'BEGIN{FS="teacher|brief"}{for(i=1;i<=NF;i++)print $i}' | grep "cos_time" | awk 'BEGIN{FS=",\""}{print $2,$4}' | awk 'BEGIN{FS="\""}{print $3":"$6}' | sed 's/ /_/g' > all_cos.txt


