#!/bin/sh

ls -ARl | grep "^[-d]" | awk '/^-/{print $5,$9}/^d/{print "dir"}' | sort -n -r | awk 'BEGIN{dir_num=0;total=0}NR<=5{print NR": "$1,$2}$1=="dir"{++dir_num}$1!="dir"{total+=$1}END{print "Dir num: "dir_num"\nFile num: "NR-dir_num"\nTotal: "total}'
