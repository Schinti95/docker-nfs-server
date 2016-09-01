#!/bin/bash

set -e
declare -a hosts=('*');
if [ -n "$ALLOWED_HOSTS" ];
	then 
	unset hosts;
	IFS=';' read -r -a hosts <<< "$ALLOWED_HOSTS"
	echo "Specific Hosts enabled!"; 

	else 
	echo "Wildcard Hosts enabled!"; 
fi

mounts="${@}"

for mnt in "${mounts[@]}"; do
  src=$(echo $mnt | awk -F':' '{ print $1 }')
  echo -n "$src " >> /etc/exports
  for host in "${hosts[@]}"; do
    echo -n "$host(rw,sync,no_subtree_check,fsid=0,no_root_squash)" >> /etc/exports
  done
  echo "" >> /etc/exports
done

exec runsvdir /etc/sv
