#!/bin/bash
### BEGIN INIT INFO
# Provides:          firewall.sh
# Required-Start:
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Iniciar firewall.sh ao iniciar
# Description:       executar script firewall.sh ao iniciar.
### END INIT INFO
#
#      Nome do arquivo firewall.sh
#      Criar arquivo no /etc/firewall/
#      ln -s /etc/firewall/firewall.sh /etc/init.d
#      cd /etc/init.d
#      chkconfig firewall.sh on
#      Colocando script na inicializacao
#      Tonar executavel chmod +x /etc/firewall/firewall.sh
#
# local dos logs do iptables que por padrão estarão em /var/log/messages ou 
# em /var/log/kern.log, dependendo da sua distro.
#
IPT4=$(which iptables) #/sbin/iptables
IPT6=$(which ip6tables) #/sbin/iptables

#Cores.
VERM='\033[1;31m'
VERD='\033[1;32m'
AZUL='\033[1;36m'
AMAR='\033[1;33m'
ROSA='\033[1;35m'
NC='\033[0m'

function _start()
{
echo -e "\t [ ${VERM} Criando Regras Ipv4 ${NC} ]"
# Limpando regras Existentes:
	$IPT4 -F
	$IPT4 -t nat -F
	$IPT4 -t mangle -F
#Limpando Chains
	$IPT4 -X
	$IPT4 -t nat -X
	$IPT4 -t mangle -X
# Zerando contadores
	$IPT4 -Z
	$IPT4 -t nat -Z
	$IPT4 -t mangle -Z
# Descartando tudo! Politica padrao.
	$IPT4 -P INPUT DROP
	$IPT4 -P OUTPUT ACCEPT
	$IPT4 -P FORWARD DROP
# Liberando loopback:
	$IPT4 -A INPUT -i lo -j ACCEPT
	$IPT4 -A OUTPUT -o lo -j ACCEPT
# Bloqueando ping requests:
	$IPT4 -A INPUT -p icmp -icmp-type echo-request -j DROP
# Bloqueando tracertroute
	$IPT4 -A INPUT -p udp -s 0/0 -i eth1 --dport 33435:33525 -j DROP
# Bloqueando pacotes invalidos.
	$IPT4 -A INPUT -m state --state INVALID -j DROP
# Log firewall
	$IPT4 -A INPUT -p tcp --dport 22 -j LOG --log-prefix "Serviço: SSH"

echo -e "\t [ ${VERD} Criando Regras Ipv6 ${NC} ]"

# Limpando regras Existentes:
	$IPT6 -F
	$IPT6 -t nat -F
	$IPT6 -t mangle -F
#Limpando Chains
	$IPT6 -X
	$IPT6 -t nat -X
	$IPT6 -t mangle -X
# Zerando contadores
	$IPT6 -Z
	$IPT6 -t nat -Z
	$IPT6 -t mangle -Z
# Descartando tudo! Politica padrao.
	$IPT6 -P INPUT DROP
	$IPT6 -P OUTPUT ACCEPT
	$IPT6 -P FORWARD DROP
# Liberando loopback:
	$IPT6 -A INPUT -i lo -j ACCEPT
	$IPT6 -A OUTPUT -o lo -j ACCEPT
# Bloqueando ping requests:
	$IPT6 -A INPUT -p icmp -icmp-type echo-request -j DROP
# Bloqueando tracertroute
	$IPT6 -A INPUT -p udp -s 0/0 -i eth1 --dport 33435:33525 -j DROP
# Bloqueando pacotes invalidos.
	$IPT6 -A INPUT -m state --state INVALID -j DROP
# Log firewall
	$IPT6 -A INPUT -p tcp --dport 22 -j LOG --log-prefix "Serviço: SSH"
}

function _stop()
{
echo -e "\t [ ${VERM} Removendo Regras Ipv4 ${NC} ]"
# Limpando regras Existentes:
	$IPT4 -F
	$IPT4 -t nat -F
	$IPT4 -t mangle -F
#Limpando Chains
	$IPT4 -X
	$IPT4 -t nat -X
	$IPT4 -t mangle -X
# Zerando contadores
	$IPT4 -Z
	$IPT4 -t nat -Z
	$IPT4 -t mangle -Z
# Descartando tudo! Politica padrao.
	$IPT4 -P INPUT ACCEPT
	$IPT4 -P OUTPUT ACCEPT
	$IPT4 -P FORWARD ACCEPT

echo -e "\t [ ${VERD} Removendo Regras Ipv6 ${NC} ]"
# Limpando regras Existentes:
	$IPT6 -F
	$IPT6 -t nat -F
	$IPT6 -t mangle -F
#Limpando Chains
	$IPT6 -X
	$IPT6 -t nat -X
	$IPT6 -t mangle -X
# Zerando contadores
	$IPT6 -Z
	$IPT6 -t nat -Z
	$IPT6 -t mangle -Z
# Descartando tudo! Politica padrao.
	$IPT6 -P INPUT ACCEPT
	$IPT6 -P OUTPUT ACCEPT
	$IPT6 -P FORWARD ACCEPT
}

function _status()
{
	echo -e "[${VERDE} Regras IPv4 ${NC}]\n"; echo
   	$IPT4 -nL
	echo -e "[${VERDE} Regras IPv6 ${NC}]\n"; echo
    $IPT6 -nL
}

function  _add_regras()
{
	echo -e "Obs: informe a regra como no ex.: (-A OUTPUT -p tcp --dport xxx -j DROP).\n"
	select op in add_ipv4 add_ipv6 sair; do
		case op in
			1) read -p "REGRA: " regra; $IPT4 ${regra}; echo -e "${VERD} *Regra adicionada ${NC}\n";;
			2) read -p "REGRA: " regra; $IPT6 ${regra}; echo -e "${VERD} *Regra adicionada ${NC}\n";;
			3) break ;;
			*) echo " * Opção inválida!" exit 1
		esac
	done
}
function _remove_regras()
{
	echo -e "Obs: informe a regra como no ex.: (-D OUTPUT -p tcp --dport 22 -j DROP).\n"
	select op in add_ipv4 add_ipv6 sair; do
		case op in
			1) read -p "REGRA IPV4: " regra; $IPT4 ${regra}; echo -e "${VERM} *Regra removida ${NC}\n";;
			2) read -p "REGRA IPV6: " regra; $IPT6 ${regra}; echo -e "${VERM} *Regra removida ${NC}\n";;
			3) break ;;
			*) echo " * Opção inválida!" exit 1
		esac
	done
}

case "$1" in
	start) echo -e " ${VERD}* Iniciando Firewall ${NC}\n"; _start; echo -e "\nUse: /etc/init.d/firewall status\n"; echo "para verificar as regras" ;;
	stop)  echo -e "${VERM} * Desativando Firewall ${NC}\n"; _stop;;
	restart|reload) echo -e "${AMAR} * Reiniciando Firewall ${NC}\n"; _stop;_start;;
	status) echo -e "${AZUL}Status Firewall ${NC}\n"; _status;;
	add) echo -e "${ROZA} Adicionar Novas Regras ao Firewall ${NC}\n"; _status;;
	remove) echo -e "${VERM} Remover Regras do Firewall ${NC}\n"; _remove;;
	*) echo " * Opção inválida, use: $0 {start|stop|restart|reload|status|add|remove}"; exit 1
esac

exit 0
