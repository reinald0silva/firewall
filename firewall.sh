#!/bin/bash

#Cores vermelho,verde,azul,amarelo,rosa,cor padrão.
VM='\033[1;31m' #vermelho
VD='\033[1;32m' #verde
AZ='\033[1;36m' #azul
AM='\033[1;33m' #amarelo
RS='\033[1;35m' #rosa
NC='\033[0m' #neutro
PS='\033[5;30m' # piscar
#|

IPT4=$(which iptables) #/sbin/iptables
IPT6=$(which ip6tables) #/sbin/ip6tables
IPTS4=$(which iptables-save) #/sbin/iptables-save
IPTR4=$(which iptables-restore) #/sbin/iptables-restore
IPTS6=$(which ip6tables-save) #/sbin/ip6tables-save
IPTR6=$(which ip6tables-restore) #/sbin/ip6tables-restore

function _top()
{
	clear
	echo -e "\t${VD}    FIREWALL ${NC}"
	echo -e "\t${VM}┬┴┬┴┤${NC}${AZ}(◣_◢)${NC}${VM}├┬┴┬┴${NC}\n"
}
function _status()
{
	_top
	echo -e "\t[${PS}${VD}Regras IPv4 ${NC}]\n"
   	${IPT4} -nL
	echo -e "\n\t[${PS}${VD}Regras IPv6 ${NC}]\n"
    ${IPT6} -nL
    echo
    read -p "Precione Enter Para Contiunar..." x
}


function _salvar_regras_atu()
{
	_top
	if [ $(which iptables-save) ]; then
		echo -e "${AZ}iptables-save${NC} [${PS}${VD}OK${NC}]"
		${IPTS4} > /etc/iptables-save; echo -e "${VM} *Regras ipv4 atuais salva ${NC}\n"
	else
		PS3="Selecione uma opção acima: "
		select OP in "sim(s) nao(n) sair(0)"; do
			case ${REPLY} in 
				sim|s) apt install iptables-save &> /dev/null; echo -e "${AZ}iptables-save${NC} [${PS}${VD}OK${NC}]"; break ;;
				nao|n) echo -e "${AZ}iptables-save${NC} [${PS}${VD}BAD${NC}]"; break ;;
				sair|0) break ;;
				*) echo "${VM}Opção Invalida!${NC}"
			esac
		done
	fi
	if [ $(which iptables-save) ]; then
		echo -e "${AZ}ip6tables-save${NC} [${PS}${VD}OK${NC}]"
		${IPTS6} > /etc/ip6tables-save; echo -e "${VM} *Regras ipv6 atuais salva ${NC}\n"
	else
		PS3="Selecione uma opção acima: "
		select OP in "sim(s) nao(n) sair(0)"; do
			case ${REPLY} in 
				sim|s) apt install ip6tables-save &> /dev/null; echo -e "${AZ}ip6tables-save${NC} [${PS}${VD}OK${NC}]"; break ;;
				nao|n) echo -e "${AZ}ip6tables-save${NC} [${PS}${VD}BAD${NC}]"; break ;;
				sair|0) break ;;
				*) echo "${VM}Opção Invalida!${NC}"
			esac
		done
	fi
	
	
	read -p "Precione Enter Para Contiunar..." x
}

function _restaurar_regras_sv()
{
	_top
	if [ $(which iptables-restore) ]; then
		echo -e "${AZ}iptables-restore${NC} [${PS}${VD}OK${NC}]"
		$IPTR4 < /etc/iptables-save; echo -e "${VERM} *Regras ipv4 atuais restauradas ${NC}\n"
	else
		echo -e "${AZ}iptables-restore${NC} [${PS}${VM}BAD${NC}]"
		echo -e "${VM} iptables-restore não encotrado use:${NC}${VD}sudo apt install iptables-restore${NC}."
		PS3="Selecione uma opção acima: "
		select OP in "sim(s) nao(n) sair(0)"; do
			case ${REPLY} in 
				sim|s) apt install iptables-restore &> /dev/null; echo -e "${AZ}iptables-restore${NC} [${PS}${VD}OK${NC}]"; break ;;
				nao|n) echo -e "${AZ}iptables-restore${NC} [${PS}${VM}BAD${NC}]"; break ;;
				sair|0) break ;;
				*) echo "${VM}Opção Invalida!${NC}"
			esac
		done
	fi
	
	if [ $(which ip6tables-restore) ]; then
		echo -e "${AZ}ip6tables-restore${NC} [${PS}${VD}OK${NC}]"
		$IPTR6 < /etc/ip6tables-save; echo -e "${VERM} *Regras ipv6 atuais restauradas ${NC}\n"
	else
		echo -e "${AZ}ip6tables-restore${NC} [${PS}${VM}BAD${NC}]"
		echo -e "${VM} ip6tables-restore não encotrado use:${NC}${VD}sudo apt install ip6tables-restore${NC}."
		PS3="Selecione uma opção acima: "
		select OP in "sim(s) nao(n) sair(0)"; do
			case ${REPLY} in 
				sim|s) apt install ip6tables-restore &> /dev/null; echo -e "${AZ}ip6tables-restore${NC} [${PS}${VD}OK${NC}]"; break ;;
				nao|n) echo -e "${AZ}ip6tables-restore${NC} [${PS}${VM}BAD${NC}]"; break ;;
				sair|0) break ;;
				*) echo "${VM}Opção Invalida!${NC}"
			esac
		done	
	fi
	echo
	read -p "Precione Enter Para Contiunar..." x
}

function _INPUT_RM()
{
	_top
	echo -e "\t[${PS}${VD}Regras IPUNT ${NC}]\n"
	${IPT4} -L INPUT --line-numbers
	read -p "Cadeia INPUT informe o numero da regra: " num
	${IPT4} -D INPUT $num &> /dev/null
	if [ $? -eq '0' ]; then	
		echo -e "\n${AZ}Remoção da regrada cadeia [INPUT]${NC} ${VM}$num${NC} .............[${PS}${VD}OK${NC}]"
	else
		echo -e "\n${AZ}Falha na Remoção da regra${NC} ${VM}$num${NC} .............[${PS}${VM}BAD${NC}]"
	fi	
	read -p "Precione Enter Para Contiunar..." x
}

function _FORWARD_RM()
{
	_top
	echo -e "\t[${PS}${VD}Regras FORWARD ${NC}]\n"
	${IPT4} -L FORWARD --line-numbers
	read -p "Cadeia FORWARD informe o numero da regra: " num
	${IPT4} -D FORWARD $num &> /dev/null
	if [ $? -eq 0 ]; then	
		echo -e "\n${AZ}Remoção da regra da cadeia [FORWARD]${NC} ${VM}$num${NC} .............[${PS}${VD}OK${NC}]"
	else
		echo -e "\n${AZ}Falha na Remoção da regra${NC} ${VM}$num${NC} .............[${PS}${VM}BAD${NC}]"
	fi	
	read -p "Precione Enter Para Contiunar..." x
}

function _OUTPUT_RM()
{
	_top
	echo -e "\t[${PS}${VD}Regras OUTPUT ${NC}]\n"
	${IPT4} -L OUTPUT --line-numbers
	read -p "Cadeia OUTPUT informe o numero da regra: " num
	${IPT4} -D OUTPUT $num &> /dev/null
	if [ $? -eq 0 ]; then	
		echo -e "\n${AZ}Remoção da regra da cadeia [OUTPUT]${NC} ${VM}$num${NC} .............[${PS}${VD}OK${NC}]"
	else
		echo -e "\n${AZ}Falha na Remoção da regra${NC} ${VM}$num${NC} .............[${PS}${VM}BAD${NC}]"
	fi	
	read -p "Precione Enter Para Contiunar..." x
}


function _remove_regras_cadeias()
{
	_top
	PS3="Selecione uma cadeia acima: "
	select OP in INPUT FORWARD OUTPUT; do
		case ${REPLY} in 
			1) _INPUT_RM; break ;;
			2) _FORWARD_RM; break ;;
			3) _OUTPUT_RM; break ;;
			4) break ;;
			*) echo "${VM}Opção Invalida!${NC}"
		esac
	done
}

for ((i=1;i>0;i++)); do
	_top
	echo -e "${VM}[1]${NC} - ${AM}Iniciar Firewall.${NC}"
	echo -e "${VM}[2]${NC} - ${AM}Parar Firewall.${NC} "
	echo -e "${VM}[3]${NC} - ${AM}Status Firewall.${NC}"
	echo -e "${VM}[4]${NC} - ${AM}Salvar Regras Atuais.${NC}"
	echo -e "${VM}[5]${NC} - ${AM}Restaurar Regras Salvas.${NC}"
	echo -e "${VM}[6]${NC} - ${AM}Adicionar Regras.${NC}"
	echo -e "${VM}[7]${NC} - ${AM}Remover Regras.${NC}"
	echo -e "${VM}[0]${NC} - ${VM}Sair.${NC}"
	read -p "Selecione uma opção: " OP
		case $OP in 
			3) _status ;; 
			4) _salvar_regras_atu ;;
			5) _restaurar_regras_sv ;;
			7) _remove_regras_cadeias ;;
			0) break ;;
			*)  echo "**Opção Invalida!"
		esac
done

