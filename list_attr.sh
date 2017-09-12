#!/bin/bash



echo "---" > dirs.yml
echo "dirs:" >> dirs.yml
dtab="       - "
ctab="         "

work_dir=/home/srv
list_dirs=$(find ${work_dir} -mindepth 1 -maxdepth 1 -type d )
for item in ${list_dirs}
do
  declare -a out
  declare nonroot_owner
  declare nonroot_group
  cd ${item}
  sub_items=($( find . -maxdepth 1 -type d ))
  num=${#sub_items[*]}
  for ((b=0;b<num;b++))
  do
    fd_own_u=$(stat -c%U ${sub_items[${b}]})
    fd_own_g=$(stat -c%G ${sub_items[${b}]})
    fd_chmod=$(stat -c%a ${sub_items[${b}]})
    out[${b}]="${item#\/home\/srv\/} ${sub_items[${b}]#\.\/} $fd_own_u $fd_own_g $fd_chmod" 
  done
  for ((b=0;b<num;b++))
  do
    fd_item=$(echo ${out[${b}]}| awk '{print $1}')
    fd_sub_item=$(echo ${out[${b}]}| awk '{print $2}')
    fd_own_u=$(echo ${out[${b}]}| awk '{print $3}')
    fd_own_g=$(echo ${out[${b}]}| awk '{print $4}')
    fd_chmod=$(echo ${out[${b}]}| awk '{print $5}')
    if [[ ${fd_own_u} == "root" ]] 
      then 
      fd_own_u=$(echo ${out[1]}| awk '{print $3}')
      fd_own_g=$(echo ${out[1]}| awk '{print $4}')
    fi
    echo "${dtab} path: ${item}/${fd_sub_item}"
    echo "${ctab} owner: ${fd_own_u}"
    echo "${ctab} group: ${fd_own_g}"
    echo "${ctab} mode: ${fd_chmod}"
    echo 
  done
done

