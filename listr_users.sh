#!/bin/bash  

echo ---
echo users:

for each in balda charles emil estanor maika mcrassus nowitch olaph steiner sylvaen tomi vault zip  
  do
   user=${each}
   uid=$(id -u ${each})
   group=$(id -ng ${each})
   groups=$(id -nG ${each} | sed 's/ /,/g')
   
   echo "        - username: $user"
   echo "          uid: $uid"
   echo "          group: $group"
   echo "          groups: $groups"
   echo "          shell: /bin/bash"
   echo "          createhome: yes"
   echo
done
