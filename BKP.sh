#!bin/bash

nome=$(cat hosts.txt | sed '1 d' | sed -e "s/ /@/g" | sed -e "s/\t/@/g" | sed -e "s/@\+/@/g" | cut -d@ -f 1)
cat hosts.txt | sed '1 d' | sed -e "s/ /@/g" | sed -e "s/\t/@/g" | sed -e "s/@\+/@/g" > host.txt

/backup &> /dev/null

while true
do
	while read linha
	do
		rsync -avzhe ssh $linha:/home/* /backup/$nome.bkp
		exit	
	done < host.txt
	sleep 60
done

rmdir -r hosts.txt
