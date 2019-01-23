#!bin/bash

nome=$(cat hosts.txt | sed '1 d' | sed -e "s/ /@/g" | sed -e "s/\t/@/g" | sed -e "s/@\+/@/g" | cut -d@ -f 1)
cat hosts.txt | sed '1 d' | sed -e "s/ /@/g" | sed -e "s/\t/@/g" | sed -e "s/@\+/@/g" > aux.txt
#Pega os ip e hosts do arquivo hosts.txt e deixa no formato exato para usar no SSH e manda para o arquivo aux.txt.


mkdir /backup &> /dev/null #Cria o arquivo caso não exista.

while true #While infinito.
do

	while read linha #lê a linha com o host e ip para fazer a conexão ssh.
	do
		rsync -avzhe ssh $linha:/home/* /backup/$nome.bkp
		exit	
	done < aux.txt
	sleep 60
done

rm -r aux.txt #Deleta o arquivo aux.txt.

#Rsync:
#rsync -(opções) (protocolo) (host)@(ip):(Pasta do destino de onde vai cópiar) (Pasta da maquina origem onde vai salvar os arquivos)

	# -a : Permite a cópia de arquivos de forma recursiva e também presserva links simbólicos, permissão de arquivos, posses de usuário, grupo e timestamps.
	# -z : Arquivos serão comprimidos.
	# -v : Verbose.
	# -h : Saída em formato legível para humanos. 
	# -e : Especifica um protocolo.

