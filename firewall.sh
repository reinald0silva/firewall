#!/bin/bash
### BEGIN INIT INFO
# Provides:          firewall.sh
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start firewall.sh at boot time
# Description:       Enable service provided by firewall.sh.
### END INIT INFO

IPT4=$(which iptables) #/sbin/iptables
IPT6=$(which ip6tables) #/sbin/iptables

#Cores.
VERM='\033[1;31m'
VERD='\033[1;32m'
AZUL='\033[1;36m'
AMAR='\033[1;33m'
ROSA='\033[1;35m'
NC='\033[0m'

function _menu_firewall()
{
	clear
		echo "+-----------------------------------------------+"
		echo "|               FIREWALL-IPTABLES               |"
		echo "+-----------------------------------------------+"
		echo "| [ 1 ] » INICIAR FIREWALL PADRÃO.              |"
		echo "| [ 2 ] » DESATIVAR FIREWALL.                   |"
		echo "| [ 3 ] » LISTAR REGRAS HABILITADAS.            |"
		echo "| [ 4 ] » REMOVER REGRA HABILITADA.             |"
		echo "| [ 5 ] » ADICIONAR NOVA REGRA.                 |" #DROP PORT, ACCEPT PORT, DROP IP, ACCEPT IP, 
		echo "| [ 0 ] » FINALIZAR.                            |"
		echo "+-----------------------------------------------+"
}

function _start_fw()
{
echo -e "\t [ ${VERM} Regras Ipv4 ${NC} ]"
# Limpando regras Existentes:
	$IPT4 -t filter -F
	$IPT4 -t nat -F
	$IPT4 -t mangle -F
# Descartando tudo! Politica padrao.
	$IPT4 -P INPUT DROP
	$IPT4 -P FORWARD DROP
	$IPT4 -P OUTPUT DROP
# Liberando loopback:
	$IPT4 -A INPUT -i lo -j ACCEPT
	$IPT4 -A OUTPUT -o lo -j ACCEPT
# Bloqueando ping requests:
	$IPT4 -A INPUT -p icmp -icmp-type echo-request -j DROP
# Bloqueando tracertroute
	$IPT4 -A INPUT -p udp -s 0/0 -i eth1 --dport 33435:33525 -j DROP
# Bloqueando pacotes invalidos.
	$IPT4 -A INPUT -m state --state INVALID -j DROP

echo -e "\t [ ${VERD} Regras Ipv6 ${NC} ]"

# Limpando regras Existentes:
	$IPT6 -t filter -F
	$IPT6 -t nat -F
	$IPT6 -t mangle -F
# Descartando tudo! Politica padrao.
	$IPT6 -P INPUT DROP
	$IPT6 -P FORWARD DROP
	$IPT6 -P OUTPUT DROP
# Liberando loopback:
	$IPT6 -A INPUT -i lo -j ACCEPT
	$IPT6 -A OUTPUT -o lo -j ACCEPT
# Bloqueando ping requests:
	$IPT6 -A INPUT -p icmp -icmp-type echo-request -j DROP
# Bloqueando tracertroute
	$IPT6 -A INPUT -p udp -s 0/0 -i eth1 --dport 33435:33525 -j DROP
# Bloqueando pacotes invalidos.
	$IPT6 -A INPUT -m state --state INVALID -j DROP
	
}
