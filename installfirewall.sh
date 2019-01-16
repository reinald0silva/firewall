#!/bin/bash
#CORES PARA IMPLEMENTAÇÃO DO CODIGO.
VM='\033[1;31m' #vermelho
VD='\033[1;32m' #verde
AZ='\033[1;36m' #azul
AM='\033[1;33m' #amarelo
RS='\033[1;35m' #rosa
NC='\033[0m' #cor neutra
PS='\033[5;30m' # piscar

function _top()
{
	clear
	echo -e "\t${VD}    FIREWALL ${NC}"
	echo -e "\t${VM}┬┴┬┴┤${NC}${AZ}(◣_◢)${NC}${VM}├┬┴┬┴${NC}\n"
}

if [ $(ls "firewall.sh") ]; then
	_top
	echo -e "\t${AZ}CRIANDO DIRETORIOS....................${NC}[${PS}${VD}Aguarde${NC}]\n"
	mkdir /etc/firewall/
	sleep 2
	echo -e "\tDIRETORIO CRIADO.....................................[${PS}${VD}OK${NC}]\n"
	
	echo -e "\t${AZ}COPIANDO ARQUIVOS.....................${NC}[${PS}${VD}Aguarde${NC}]\n"
	cp ./firewall.sh /etc/firewall/
	sleep 2
	echo -e "\tARQUIVOS COPIADOS....................................[${PS}${VD}OK${NC}]\n"
	
	echo -e "\t${AZ}CRIANDO LINK DO ARQUIVO...............${NC}[${PS}${VD}Aguarde${NC}]\n"
	ln -s /etc/firewall/firewall.sh /etc/init.d
	sleep 2
	echo -e "\tLINK CRIANDO.........................................[${PS}${VD}OK${NC}]\n"
	
	echo -e "\t${AZ}COLOCANDO SCRIPT NA INICIALIZAÇÃO.....${NC}[${PS}${VD}Aguarde${NC}]\n"
	cd /etc/init.d && update-rc.d firewall.sh defaults
	chmod +x /etc/firewall/firewall.sh
	sleep 1
	echo -e "\tSCRIPT INICIALIZADO..................................[${PS}${VD}OK${NC}]\n"
	exit 1

else
	clear
	echo -e "\t${AZ}ARQUIVO [firewall.sh] NÃO ENCONTRADO...........${NC}[${PS}${VM}BAD${NC}]\n"
	exit 1
fi
