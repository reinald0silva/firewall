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
echo "Limpando as Regras .....................................[ ${VERD}OK${NC} ]"
#Limpando Chains
	$IPT4 -X
	$IPT4 -t nat -X
	$IPT4 -t mangle -X
echo "Limpando as Chains .....................................[ ${VERD}OK${NC} ]"
# Zerando contadores
	$IPT4 -Z
	$IPT4 -t nat -Z
	$IPT4 -t mangle -Z
echo "Zerando Contadores .....................................[ ${VERD}OK${NC} ]"
# Descartando tudo! Politica padrao.
	$IPT4 -P INPUT DROP
	$IPT4 -P OUTPUT ACCEPT
	$IPT4 -P FORWARD DROP
echo "Descartando Politicas ..................................[ ${VERD}OK${NC} ]"
# Liberando loopback:
	$IPT4 -A INPUT -i lo -j ACCEPT
	$IPT4 -A OUTPUT -o lo -j ACCEPT
echo "Liberando Loopback .....................................[ ${VERD}OK${NC} ]"
# Bloqueando ping requests:
	$IPT4 -A INPUT -p icmp -icmp-type echo-request -j DROP
echo "Bloqueando Ping Requests ...............................[ ${VERD}OK${NC} ]"
# Bloqueando traceroute
	$IPT4 -A INPUT -p udp -s 0/0 -i eth1 --dport 33435:33525 -j DROP
echo "Bloqueando Traceroute ..................................[ ${VERD}OK${NC} ]"
# Bloqueando pacotes invalidos.
	$IPT4 -A INPUT -m state --state INVALID -j DROP
echo "Bloqueando Pacotes Invalidos............................[ ${VERD}OK${NC} ]"
# Log firewall
	$IPT4 -A INPUT -p tcp --dport 22 -j LOG --log-prefix "Serviço: SSH"
echo "Ativando LOG na porta 22................................[ ${VERD}OK${NC} ]"

echo -e "\t [ ${VERD} Criando Regras Ipv6 ${NC} ]"
# Limpando regras Existentes:
	$IPT6 -F
	$IPT6 -t nat -F
	$IPT6 -t mangle -F
echo "Limpando as Regras .....................................[ ${VERD}OK${NC} ]"
#Limpando Chains
	$IPT6 -X
	$IPT6 -t nat -X
	$IPT6 -t mangle -X
echo "Limpando as Chains .....................................[ ${VERD}OK${NC} ]"
# Zerando contadores
	$IPT6 -Z
	$IPT6 -t nat -Z
	$IPT6 -t mangle -Z
echo "Zerando Contadores .....................................[ ${VERD}OK${NC} ]"
# Descartando tudo! Politica padrao.
	$IPT6 -P INPUT DROP
	$IPT6 -P OUTPUT ACCEPT
	$IPT6 -P FORWARD DROP
echo "Descartando Politicas ..................................[ ${VERD}OK${NC} ]"
# Liberando loopback:
	$IPT6 -A INPUT -i lo -j ACCEPT
	$IPT6 -A OUTPUT -o lo -j ACCEPT
echo "Liberando Loopback .....................................[ ${VERD}OK${NC} ]"
# Bloqueando ping requests:
	$IPT6 -A INPUT -p icmp -icmp-type echo-request -j DROP
echo "Bloqueando Ping Requests ...............................[ ${VERD}OK${NC} ]"
# Bloqueando tracertroute
	$IPT6 -A INPUT -p udp -s 0/0 -i eth1 --dport 33435:33525 -j DROP
echo "Bloqueando Traceroute ..................................[ ${VERD}OK${NC} ]"
# Bloqueando pacotes invalidos.
	$IPT6 -A INPUT -m state --state INVALID -j DROP
echo "Bloqueando Pacotes Invalidos............................[ ${VERD}OK${NC} ]"
# Log firewall
	$IPT6 -A INPUT -p tcp --dport 22 -j LOG --log-prefix "Serviço: SSH"
echo "Ativando LOG na porta 22................................[ ${VERD}OK${NC} ]"
}

function _stop()
{
echo -e "\t [ ${VERM} Removendo Regras Ipv4 ${NC} ]"
# Limpando regras Existentes:
	$IPT4 -F
	$IPT4 -t nat -F
	$IPT4 -t mangle -F
echo "Limpando as Regras .....................................[ ${VERD}OK${NC} ]"
#Limpando Chains
	$IPT4 -X
	$IPT4 -t nat -X
	$IPT4 -t mangle -X
echo "Limpando as Chains .....................................[ ${VERD}OK${NC} ]"
# Zerando contadores
	$IPT4 -Z
	$IPT4 -t nat -Z
	$IPT4 -t mangle -Z
echo "Zerando Contadores .....................................[ ${VERD}OK${NC} ]"
# Descartando tudo! Politica padrao.
	$IPT4 -P INPUT DROP
	$IPT4 -P OUTPUT ACCEPT
	$IPT4 -P FORWARD DROP
echo "Descartando Politicas ..................................[ ${VERD}OK${NC} ]"

echo -e "\t [ ${VERD} Removendo Regras Ipv6 ${NC} ]"
# Limpando regras Existentes:
	$IPT6 -F
	$IPT6 -t nat -F
	$IPT6 -t mangle -F
echo "Limpando as Regras .....................................[ ${VERD}OK${NC} ]"
#Limpando Chains
	$IPT6 -X
	$IPT6 -t nat -X
	$IPT6 -t mangle -X
echo "Limpando as Chains .....................................[ ${VERD}OK${NC} ]"
# Zerando contadores
	$IPT6 -Z
	$IPT6 -t nat -Z
	$IPT6 -t mangle -Z
echo "Zerando Contadores .....................................[ ${VERD}OK${NC} ]"
# Descartando tudo! Politica padrao.
	$IPT6 -P INPUT DROP
	$IPT6 -P OUTPUT ACCEPT
	$IPT6 -P FORWARD DROP
echo "Descartando Politicas ..................................[ ${VERD}OK${NC} ]"
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
			1) _help_add;read -p "REGRA: " regra; $IPT4 ${regra}; echo -e "${VERD} *Regra adicionada ${NC}\n";;
			2) _help_add;read -p "REGRA: " regra; $IPT6 ${regra}; echo -e "${VERD} *Regra adicionada ${NC}\n";;
			3) _help_add;break ;;
			*) echo " * Opção inválida!" exit 1
		esac
	done
}
function _remove_regras()
{
	echo -e "Obs: informe a regra como no ex.: (-D OUTPUT -p tcp --dport 22 -j DROP).\n"
	select op in add_ipv4 add_ipv6 sair; do
		case op in
			1) _help_remove;read -p "REGRA IPV4: " regra; $IPT4 ${regra}; echo -e "${VERM} *Regra removida ${NC}\n";;
			2) _help_remove;read -p "REGRA IPV6: " regra; $IPT6 ${regra}; echo -e "${VERM} *Regra removida ${NC}\n";;
			3) break ;;
			*) echo " * Opção inválida!" exit 1
		esac
	done
}
function _help_add()
{
	echo "-A -> Adiciona uma regra no fim da lista."
	echo "-I -> Insere uma regra no início da lista."
	echo "-i -> Especifica a interface de entrada utilizada pela regra. "
	echo "-o -> Especifica a interface de saída utilizada pela regra."
	echo "-s -> Especifica o endereço ou a rede de origem utilizada pela regra."
	echo "-d -> Especifica o endereço ou a rede de destino utilizado pela regra."
	echo "-j -> Utilizado para aplicar um alvo a regra, ser ACCEPT, DROP, REJECT e LOG. Ex: -j ACCEPT."
	echo "--sport -> Especifica a porta de origem utilizada. Ex: -p tcp --sport 25."
	echo "--dport -> Especifica a porta de destino utilizada. Ex: -p tcp --dport 25."
	echo "ACCEPT -> Aceita a entrada ou passagem do pacote."
	echo "DROP -> Descarta o pacote."
	echo "REJECT -> Descarta o pacote, porém diferente de DROP."
	echo "LOG -> Gera um log no sistema."
	echo "RETURN -> Retorna o processamento da chain anterior."
	echo "QUEUE -> Encarrega um programa de administrar o fluxo atribuído ao mesmo."
	echo "SNAT -> Altera o endereço de origem do pacote."
	echo "DNAT -> Altera o endereço de destino do pacote."
	echo "REDIRECT -> Redireciona a porta do pacote juntamente com a opção --to-port."
	echo "TOS -> Prioriza a entrada e saída de pacotes baseado em seu tipo de serviço."
}

function _help_remove()
{
	echo "-D , --delete  cadeia  regra-especificação" 
	echo "-D , --delete  cadeia  rulenum"
    echo "Exclua uma ou mais regras da cadeia selecionada. "
    echo "Existem duas versões deste comando: a regra pode ser especificada "
    echo "como um número na cadeia (começando em 1 para a primeira regra) ou "
    echo "uma regra para partida."
    echo
    echo "-R , --replace  cadeia  rulenum  regra-especificação"
    echo "Substitua uma regra na cadeia selecionada."
    echo "As regras são numeradas começando em 1. iptables --line-numbers"
    echo
    echo " iptables -L  --line-numbers. Ao listar regras, adicionA números de" 
    echo "linha ao início de cada regra, correspondendo a essa regra posição na cadeia."
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
