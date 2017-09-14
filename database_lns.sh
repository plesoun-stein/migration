#!/bin/bash
cat databaze-umisteni.txt |
while read line 
do 
    l=${line%% *}
    p=${line##* }
    echo "    - src: ${l}"
    echo "      dest: ${p}" 
done  
