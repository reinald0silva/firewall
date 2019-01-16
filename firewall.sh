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
#      update-rc.d firewall.sh defaults
#      Colocando script na inicializacao
#      Tonar executavel chmod +x /etc/firewall/firewall.sh
#
# local dos logs do iptables que por padrão estarão em /var/log/messages ou 
# em /var/log/kern.log, dependendo da sua distro.
#
#CORES PARA IMPLEMENTAÇÃO DO CODIGO.
VM='\033[1;31m' #vermelho
VD='\033[1;32m' #verde
AZ='\033[1;36m' #azul
AM='\033[1;33m' #amarelo
RS='\033[1;35m' #rosa
NC='\033[0m' #cor neutra
PS='\033[5;30m' # piscar
#|
#BUSCA POR EXECUTÁVEIS COMO O COMANDO WICH NOS PATHs EXPORTADOS.
IPT4=$(which iptables) #/sbin/iptables
IPT6=$(which ip6tables) #/sbin/ip6tables
IPTS4=$(which iptables-save) #/sbin/iptables-save
IPTR4=$(which iptables-restore) #/sbin/iptables-restore
IPTS6=$(which ip6tables-save) #/sbin/ip6tables-save
IPTR6=$(which ip6tables-restore) #/sbin/ip6tables-restore

#FUNÇÃO DO CABEÇALHO DO SCRIPT.
function _top()
{
	clear
	echo -e "\t${VD}    FIREWALL ${NC}"
	echo -e "\t${VM}┬┴┬┴┤${NC}${AZ}(◣_◢)${NC}${VM}├┬┴┬┴${NC}\n"
}

#FUNÇÃO MENU PRINCIPAL, AO INICIAR O SERVIÇO IRA APARECER PRIMEIRO.
function _menu_principal()
{
	for ((i=1;i>0;i++)); do
		_top
		echo -e "${VM}[1]${NC} - ${AM}Iniciar Firewall.${NC}" #FEITO
		echo -e "${VM}[2]${NC} - ${AM}Parar Firewall. ${NC} " #FEITO
		echo -e "${VM}[3]${NC} - ${AM}Status Firewall.${NC}" #FEITO
		echo -e "${VM}[4]${NC} - ${AM}Salvar Regras Atuais.${NC}" #FEITO
		echo -e "${VM}[5]${NC} - ${AM}Restaurar Regras Salvas.${NC}" #FEITO
		echo -e "${VM}[6]${NC} - ${AM}Adicionar Regras.${NC}"
		echo -e "${VM}[7]${NC} - ${AM}Remover Regras.${NC}" #FEITO
		echo -e "${VM}[0]${NC} - ${VM}Sair.${NC}" #FEITO
		read -p "Selecione uma opção: " OP
			case $OP in
				1) _start_question ;; #Iniciar Firewall
				2) _stop_firewall ;; #Parar Firewall.
				3) _status ;; #Status Firewall.
				4) _salvar_regras_atu ;; #Salvar Regras Atuais.
				5) _restaurar_regras_sv ;; #Restaurar Regras Salvas.
				6) _adicionar_regras ;; #Adicionar Regras.
				7) _remove_regras_cadeias ;; #Remover Regras.
				0) break ;; #Sair.
				*)  echo -e "${VM}Opção Invalida!${NC}" #Caso seja informado um opção diferente das informada no menu dará como invalida!
			esac
	done
}
#FUNÇÃO PARA PERGUNTAR SE DESEJA OU NÃO ATIVAR O FIREWALL.
function _start_question()
{
	PS3="Deseja Iniciar o Firewall: "
	select OP in sim nao; do
		case ${REPLY} in #REPLY = RESPOSTA, PODERIA SER USADO 'OP' OU 'REPLY'.
			1|sim|s) _start; break;;
			2|nao|n) echo -e "${VM}Firewall Não Abilitado!${NC}"
					read -p "Precione Enter Para Contiunar..." x; break ;;
			*) echo -e "${VM}Opção Invalida!${NC}"
		esac
	done
}

#FUNÇÃO INICIA O FIREWALL COM ALGUMAS REGRAS DEFINIDAS POR PADRÃO.
function _start()
{
	_top
	echo -e "\t[${VD}Iniciando Firewall${NC}]\n"
	sleep 3
	
	echo -e "\t[${VD}Definindo Politicas Padrões${NC}]\n"
	$IPT4  -P  INPUT DROP  # Consultado para dados que chegam a máquina Bloqueados ipv4.
	$IPT4  -P  FORWARD DROP  #Consultado para dados que são redirecionados para outra interface de rede ou outra máquina Bloqueado ipv4.
	$IPT4  -P  OUTPUT ACCEPT # Consultado para dados que saem da máquina Liberado ipv4.
	$IPT6 -P INPUT DROP # Consultado para dados que chegam a máquina Bloqueados ipv6.
	$IPT6 -P FORWARD DROP #Consultado para dados que são redirecionados para outra interface de rede ou outra máquina Bloqueado ipv6.
	$IPT6 -P OUTPUT ACCEPT # Consultado para dados que saem da máquina Liberado ipv6.
	echo -e "Politicas ....................................[${PS}${VD}OK${NC}]\n"
	
	echo -e "\t[${VD}Liberando loopback${NC}]\n"
	$IPT4 -A  INPUT -i lo -j ACCEPT #Libera acesso de entrada na interface loopback
	$IPT4 -A OUTPUT -o lo -j ACCEPT #Libera acesso de saida na interface loopback
	
	# -j (Isso especifica o alvo da regra).
	# -i interface de rede.
	# -o Nome de uma interface através da qual um pacote será enviado.
	# -A (Anexa uma ou mais regras para o final da cadeia).
	# ACCEPT (deixar o pacote passar pela porta especificada).
	
	echo -e "Loopback......................................[${PS}${VD}OK${NC}]\n"
	
	echo -e "\t[${VD}Liberando o Estabelecimento de Novas Conexões${NC}]\n"
	$IPT4 -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
	$IPT4 -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED,NEW -j ACCEPT
	
	# -A (Anexa uma ou mais regras para o final da cadeia).
	# ACCEPT (deixar o pacote passar pela porta especificada).
	# DROP (não deixar o pacote passar pela porta especificada).
	# -j (Isso especifica o alvo da regra).
	
	#--ctstate statelist: statelist é uma lista separada por vírgulas dos estados de conexão para combinar
	
	# ESTABLISHED: Significa que o pacote está associado com uma conexão que tem pacotes vindos de ambas direções.
	# RELATED: Significa que o pacote está começando uma nova conexão, mas está associado a uma conexão existente, 
	# como uma transferência de dados de FTP, ou um erro ICMP.
	# NEW: Significa que o pacote começou uma nova conexão ou está associado a uma conexão que não tem pacotes vindos de ambas as direções.
	
	# O iptables pode usar módulos correspondentes para pacotes grandes, implicitamente, quando "-p" ou "-protocol" for especificado; 
	# ou com as opções "-m" ou "--match" seguidas pelo nome do módulo correspondente: -m conntrack"
	
	echo -e "\t[${VD}Liberando Portas${NC}]\n"
	$IPT4 -A INPUT -p tcp --dport 22 -j ACCEPT
	# -A (Anexa uma ou mais regras para o final da cadeia).
	# ACCEPT (deixar o pacote passar pela porta especificada).
	# DROP (não deixar o pacote passar pela porta especificada).
	# -j (Isso especifica o alvo da regra).
	# -p (protocolo a ser usado).
	# --dport (Porta de destino ou especificação do intervalo de portas.)
	# --dport
	
	echo -e "Porta 22 SSH................................[${PS}${VD}Open${NC}]\n"
	$IPT4 -A INPUT -p tcp --dport 115 -j ACCEPT
	
	# -A (Anexa uma ou mais regras para o final da cadeia).
	# ACCEPT (deixar o pacote passar pela porta especificada).
	# DROP (não deixar o pacote passar pela porta especificada).
	# -j (Isso especifica o alvo da regra).
	# -p (protocolo a ser usado).
	# --dport (Porta de destino ou especificação do intervalo de portas.)
	echo -e "Porta 115 SFTP..............................[${PS}${VD}Open${NC}]\n"
	
	echo -e "\t[${VD}Criando LOGs${NC}]\n"
	$IPT4 -A INPUT -p tcp --dport=22 -j LOG --log-level warning --log-prefix "Acesso SSH pela porta 22-TCP"
	$IPT4 -A INPUT -p udp --dport=22 -j LOG --log-level warning --log-prefix "Acesso SSH pela porta 22-UDP"
	$IPT4 -A INPUT -p tcp --dport=115 -j LOG --log-level warning --log-prefix "Acesso SFTP pela porta 115"
	$IPT4 -A INPUT -p icmp  -j LOG --log-level warning --log-prefix "Tentativa de Ping"
	
	# -A (Anexa uma ou mais regras para o final da cadeia).
	# -p (protocolo a ser usado).
	# -j (Isso especifica o alvo da regra).
	
	#--log level <level>: O nível descreve a gravidade da mensagem e é uma palavra-chave da seguinte ordem
    # list (maior para menor): emerg, alert, crit, err, warning, notice e debug.
    
    #LOG: Ativa o registro do kernel de pacotes correspondentes. Quando esta opção está definida para uma regra, o Linux
    #kernel irá imprimir algumas informações sobre todos os pacotes correspondentes (como a maioria dos campos de cabeçalho IP)
    #através do log do kernel (onde ele pode ser lido com dmesg ou syslogd.
    
    # prefixo --log-  prefixPrefixo mensagens de log com o prefixo especificado; até 29 cartas, e útil para
    # distinguindo mensagens nos logs.
	echo -e "LOGs..........................................[${PS}${VD}OK${NC}]\n"
	read -p "Precione Enter Para Contiunar..." x
}
#FUNÇÃO LIMPA TODAS AS REGRAS DAS CADEIAS E TABELAS DEFINIDAS, FICANDO COMO DESATIVADO.
function _stop_firewall()
{
	_top
	echo -e "\t[${PS}${VD}Limpando Regras${NC}]\n"
	$IPT4 -P INPUT ACCEPT #Esta cadeia é usada para controlar o comportamento das conexões de entrada. ACCEPT libera a entrada.
	$IPT4 -P FORWARD ACCEPT # Essa cadeia é usada para conexões de entrada que não estão sendo entregues localmente. ACCEPT libera a entrada.
	$IPT4 -P OUTPUT ACCEPT #Esta cadeia é usada para conexões de saída. ACCEPT libera a entrada.
	$IPT6 -P INPUT ACCEPT # Mesma definição de cima ↑, só que no ipv6.
	$IPT6 -P FORWARD ACCEPT # Mesma definição de cima ↑, só que no ipv6.
	$IPT6 -P OUTPUT ACCEPT # Mesma definição de cima ↑, só que no ipv6.
	$IPT4 -F #Limpa todas as regras atualmente configuradas, no ipv4.
	$IPT4 -X #Elimina uma específicada chain(cadeia) criada pelo usuário. 
	$IPT6 -F #Limpa todas as regras atualmente configuradas, no ipv6.
	$IPT6 -X #Elimina uma específicada chain(cadeia) criada pelo usuário ipv6.
	$IPT4 -t nat -F #Limpa todas as regras atualmente configuradas, na tabela nat no ipv4 .
	$IPT4 -t nat -X #Elimina uma específicada chain(cadeia) criada pelo usuário na tabela nat ipv4.
	$IPT4 -t mangle -F #mangle:Esta tabela é usada para a alteração especializada do pacote. Elimina as regras definidas. 
	$IPT4 -t mangle -X #Elimina uma específicada chain(cadeia) criada pelo usuário na tabela mangle ipv4.
	$IPT6 -t mangle -F #Elimina regras na tabela mangle do ipv6.
	$IPT6 -t mangle -X #Elimina uma específicada chain(cadeia) criada pelo usuário na tabela mangle ipv6.
	echo -e "${AZ}Firewall Desativando${NC}...........................[${PS}${VD}OK${NC}]\n"
	read -p "Precione Enter Para Contiunar..." x	
}

#FUNÇÃO ONDE MOSTRA AS REGRAS JÁ ABILITADAS NO FIREWALL-IPTABLES.
function _status()
{
	_top
	echo -e "\t[${PS}${VD}Regras IPv4${NC}]\n"
   	${IPT4} -nL --line-numbers
	echo -e "\n\t[${PS}${VD}Regras IPv6${NC}]\n"
    ${IPT6} -nL --line-numbers
    echo
    read -p "Precione Enter Para Contiunar..." x
    
    # -n --> Saída numérica.IP e porta impressos em formato numérico.
    # -L --> Listar todas as regras na cadeia selecionada.
    # --line-numbers --> Ao listar regras, adiciona números de linha ao início de cada regra, correspondendo a posição da regra na cadeia.
}
#FUNÇÃO PARA FAZER O BACKUP DAS REGRAS ANTERIOS ANTES DAS MUDANÇAS, PARA CASO DE ERROS.
#TAMBÉN INSTALA OS PROGRAMAS NECESSÁRIOS CASO ELES NÃO ESTEJA INSTALADO NO SISTEMA.
function _salvar_regras_atu()
{
	_top
	if [ $(which iptables-save) ]; then  #localiza o comando iptables-save, caso ele exista salva as regras ipv4 no /etc/iptables-save.
		echo -e "${AZ}iptables-save${NC} [${PS}${VD}OK${NC}]"
		${IPTS4} > /etc/iptables-save; echo -e "${VM} *Regras ipv4 atuais salva ${NC}\n"
	
	else # Caso não exista ele pergunta se deseja instalar ou não o iptables-save, caso instale ele em seguida salva as regras no /etc/iptables-save.
		PS3="Selecione uma opção acima: "
		select OP in "sim(s) nao(n) sair(0)"; do
			case ${REPLY} in  
				sim|s) apt install -y iptables-save &> /dev/null 
					   echo -e "${AZ}iptables-save${NC} [${PS}${VD}OK${NC}]"
					   ${IPTS4} > /etc/iptables-save
					   echo -e "${VM} *Regras ipv4 atuais salva ${NC}\n"; break ;;
					   
				nao|n) echo -e "${AZ}iptables-save${NC} [${PS}${VD}BAD${NC}]"; break ;;
				sair|0) break ;;
				*) echo -e "${VM}Opção Invalida!${NC}" #Caso seja informado um opção diferente das informada no menu dará como invalida!
			esac
		done
	fi
	if [ $(which iptables-save) ]; then #localiza o comando ip6tables-save, caso ele exista salva as regras ipv4 no /etc/iptables-save.
		echo -e "${AZ}ip6tables-save${NC} [${PS}${VD}OK${NC}]"
		${IPTS6} > /etc/ip6tables-save; echo -e "${VM} *Regras ipv6 atuais salva ${NC}\n"
	
	else # Caso não exista ele pergunta se deseja instalar ou não o ip6tables-save, caso instale ele em seguida salva as regras no /etc/ip6tables-save.
		PS3="Selecione uma opção acima: "
		select OP in "sim(s) nao(n) sair(0)"; do
			case ${REPLY} in 
				sim|s) apt install -y ip6tables-save &> /dev/null 
				       echo -e "${AZ}ip6tables-save${NC} [${PS}${VD}OK${NC}]"
				       ${IPTS6} > /etc/ip6tables-save 
				       echo -e "${VM} *Regras ipv6 atuais salva ${NC}\n"; break ;;
				       
				nao|n) echo -e "${AZ}ip6tables-save${NC} [${PS}${VD}BAD${NC}]"; break ;;
				sair|0) break ;;
				*) echo -e "${VM}Opção Invalida!${NC}" #Caso seja informado um opção diferente das informada no menu dará como invalida!
			esac
		done
	fi
	read -p "Precione Enter Para Contiunar..." x
}
#RESTAURA O BACKUP DAS REGRAS SALVAR PELA FUNÇÃO ANTERIOR.
function _restaurar_regras_sv()
{
	_top
	if [ $(which iptables-restore) ]; then #localiza o comando iptables-restore, caso ele exista restaura as regras ipv4 no /etc/iptables-save.
		echo -e "${AZ}iptables-restore${NC} [${PS}${VD}OK${NC}]"
		$IPTR4 < /etc/iptables-save; echo -e "${VERM} *Regras ipv4 atuais restauradas ${NC}\n"
	else # Caso não exista ele pergunta se deseja instalar ou não o ip6tables-restore, caso instale ele em seguida restaura as regras no /etc/iptables-save.
		echo -e "${AZ}iptables-restore${NC} [${PS}${VM}BAD${NC}]"
		echo -e "${VM} iptables-restore não encotrado use:${NC}${VD}sudo apt install iptables-restore${NC}."
		PS3="Selecione uma opção acima: "
		select OP in "sim(s) nao(n) sair(0)"; do
			case ${REPLY} in 
				sim|s) apt install -y iptables-restore &> /dev/null 
					   echo -e "${AZ}iptables-restore${NC} [${PS}${VD}OK${NC}]\n"
					   $IPTR4 < /etc/iptables-save 
					   echo -e "${VERM} *Regras ipv4 atuais restauradas ${NC}\n"; break ;;
					   
				nao|n) echo -e "${AZ}iptables-restore${NC} [${PS}${VM}BAD${NC}]"; break ;;
				sair|0) break ;;
				*) echo -e "${VM}Opção Invalida!${NC}" #Caso seja informado um opção diferente das informada no menu dará como invalida!
			esac
		done
	fi
	if [ $(which ip6tables-restore) ]; then #localiza o comando ip6tables-restore, caso ele exista restaura as regras ipv6 no /etc/ip6tables-save.
		echo -e "${AZ}ip6tables-restore${NC} [${PS}${VD}OK${NC}]"
		$IPTR6 < /etc/ip6tables-save; echo -e "${VERM} *Regras ipv6 atuais restauradas ${NC}\n"
	
	else # Caso não exista ele pergunta se deseja instalar ou não o ip6tables-restore, caso instale ele em seguida restaura as regras no /etc/ip6tables-save.
		echo -e "${AZ}ip6tables-restore${NC} [${PS}${VM}BAD${NC}]"
		echo -e "${VM} ip6tables-restore não encotrado use:${NC}${VD}sudo apt install ip6tables-restore${NC}."
		PS3="Selecione uma opção acima: "
		select OP in "sim(s) nao(n) sair(0)"; do
			case ${REPLY} in 
				sim|s) apt install -y ip6tables-restore &> /dev/null 
					   echo -e "${AZ}ip6tables-restore${NC} [${PS}${VD}OK${NC}]"
					   $IPTR6 < /etc/ip6tables-save 
					   echo -e "${VERM} *Regras ipv6 atuais restauradas ${NC}\n"; break ;;
					   
				nao|n) echo -e "${AZ}ip6tables-restore${NC} [${PS}${VM}BAD${NC}]"; break ;;
				sair|0) break ;;
				*) echo -e "${VM}Opção Invalida!${NC}" #Caso seja informado um opção diferente das informada no menu dará como invalida!
			esac
		done	
	fi
	echo
	read -p "Precione Enter Para Contiunar..." x
}
#FUNÇÃO COM MENU DE OPÇÕES PARA ADICIONAR NOVAS REGRAS AO FIREWALL.
function _adicionar_regras()
{
	_top
	echo -e "\t[${VD}Adicionar Regras ao Firewall${NC}]\n"
	for ((i=1;i>0;i++));do
		echo -e "${VM}[1]${NC} - ${AM}Abrir ou Bloquear uma porta.${NC}"
		echo -e "${VM}[2]${NC} - ${AM}Abrir ou Bloquear Ping. ${NC} " 
		echo -e "${VM}[3]${NC} - ${AM}Abrir ou Bloquer um conjunto de portas.${NC}" 
		echo -e "${VM}[4]${NC} - ${AM}Abrir ou Bloquear para uma faixa de endereços.${NC}"
		echo -e "${VM}[5]${NC} - ${AM}Abrir ou Bloquear uma porta para um IP específico.${NC}"
		echo -e "${VM}[6]${NC} - ${AM}Verificar IP e MAC antes de autorizar a conexão.${NC}"
		echo -e "${VM}[7]${NC} - ${AM}Abrir ou Bloquear um intervalo de portas.${NC}"
		echo -e "${VM}[8]${NC} - ${AM}Abrir LOG para uma porta.${NC}"
		echo -e "${VM}[0]${NC} - ${VM}Sair.${NC}"
		read -p "Selecione uma opção: " OP
		case $OP in
			1) _AB_PORT;break ;; #Abrir ou Bloquear uma porta
			2) _AB_PING ;break ;; #Abrir ou Bloquear Ping.
			3) _AB_CONJ_PORT;break ;; #Abrir ou Bloquer um conjunto de portas.
			4) _AB_FAIX_END_IP;break ;; #brir ou Bloquear para uma faixa de endereços.
			5) _AB_PORT_FOR_IP_ESPC;break ;; #}Abrir ou Bloquear uma porta para um IP específico.
			6) _VERIFY_IP_MAC;break ;; #Verificar IP e MAC antes de autorizar a conexão.
			7) _AB_INTERVALO_PORT;break ;; #Abrir ou Bloquear um intervalo de portas.
			8) _LOG_PORT;break ;; #Abrir LOG para uma porta. 
			0) break ;; #Sair.
			*)  echo -e "${VM}Opção Invalida!${NC}" #Caso seja informado um opção diferente das informada no menu dará como invalida!
		esac
	done
}
#FUNÇÃO PARA ABRIR OU BLOQUEAR PORTAS NO FIREWALL, É INFORMADO UMA PORTA COM ISSO IRÁ ABRI-LA OU BLOQUEA-LA.
function _AB_PORT()
{
	_top
	PS3="Escolha uma opção acima: "
	echo -e "\t${AZ}Abrir ou Bloquear uma porta.${NC}\n"
	select OP in ABRIR BLOQUEAR sair; do
		case ${REPLY} in 
			1) read -p "Informe a porta: " PORT
			   $IPT4 -A INPUT -p tcp --dport $PORT -j ACCEPT
			   echo -e "${AZ}Status Porta${NC} ${AM}$PORT${NC}......................[${PS}${VD}Open${NC}]\n"
			   read -p "Precione Enter Para Contiunar..." x; break ;;
			2) read -p "Informe a porta: " PORT
			   $IPT4 -A INPUT -p tcp --dport $PORT -j DROP
			   echo -e "${AZ}Status Porta${NC} ${AM}$PORT${NC}...................[${PS}${VM}Blocked${NC}]\n"
			   read -p "Precione Enter Para Contiunar..." x; break ;;
			3) break ;;
			*) echo -e "${VM}Opção Invalida!${NC}" #Caso seja informado um opção diferente das informada no menu dará como invalida!
		esac
	done
	# -A (Anexa uma ou mais regras para o final da cadeia), INPUT(CADEIA DE ENTRADA), -p (protocolo a ser utilizado).
	# --dport (Porta de destino ou especificação do intervalo de portas.)
	# -j (Isso especifica o alvo da regra), ACCEPT (deixar o pacote passar pela porta especificada).
	# DROP (não deixar o pacote passar pela porta especificada).
}
#FUNÇÃO PARA LIBERAÇÃO OU BLOQUEIO DE PING NA MAQUINA, OUTRAS MAQUINAS PODEM OU NÃO PINGAR ESTA MAQUINA.
function _AB_PING()
{
	_top
	PS3="Escolha uma opção acima: "
	echo -e "\t${AZ}Abrir ou Bloquear Ping.${NC}\n"
	select OP in ABRIR BLOQUEAR sair; do
		case ${REPLY} in 
			1) $IPT4 -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
			echo -e "${AZ}Status Ping${NC}......................[${PS}${VD}Open${NC}]\n"
			   read -p "Precione Enter Para Contiunar..." x;break ;;
			2) $IPT4 -A INPUT -p icmp --icmp-type echo-request -j DROP
			echo -e "${AZ}Status Ping${NC}...................[${PS}${VM}Blocked${NC}]\n"
			   read -p "Precione Enter Para Contiunar..." x;break ;;
			3) break ;;
			*) echo -e "${VM}Opção Invalida!${NC}" #Caso seja informado um opção diferente das informada no menu dará como invalida!
		esac
	done
	# -A (Anexa uma ou mais regras para o final da cadeia), INPUT(CADEIA DE ENTRADA).

	# --icmp-type (Permite a especificação do tipo ICMP, que pode ser um tipo numérico ICMP, 
	# par tipo/código, ou um dos nomes ICMP mostrados pelo comando: iptables -p icmp -h.
	
	# echo-request(solicitação de eco ou ping ), -j (Isso especifica o alvo da regra), ACCEPT (deixar o pacote passar pela porta especificada).
	# DROP (não deixar o pacote passar pela porta especificada).
}

#FUNÇÃO PARA ABRIR OU BLOQUEAR UM CONJUNTO DE PROTAS NO FIREWALL.
function _AB_CONJ_PORT()
{
	_top
	PS3="Escolha uma opção acima: "
	echo -e "\t${AZ}Abrir ou Bloquer um conjunto de portas.${NC}\n"
	select OP in ABRIR BLOQUEAR sair; do
		case ${REPLY} in 
			1) read -p "Informe as porta ex. (22,80,...): " PORTS
			   $IPT4 -A INPUT -m multiport -p tcp --dport ${PORTS} -j ACCEPT
			   echo -e "${AZ}Status Portas:${NC} ${AM}${PORTS}${NC}.........................[${PS}${VD}Open${NC}]\n"
			   read -p "Precione Enter Para Contiunar..." x; break ;;
			2) read -p "Informe as porta ex. (22,80,...): " PORTS
			   $IPT4 -A INPUT -m multiport -p tcp --dport ${PORTS} -j DROP
			   echo -e "${AZ}Status Portas:${NC} ${AM}${PORTS}${NC}......................[${PS}${VM}Blocked${NC}]\n"
			   read -p "Precione Enter Para Contiunar..." x;break ;;
			3) break ;;
			*) echo -e "${VM}Opção Invalida!${NC}" #Caso seja informado um opção diferente das informada no menu dará como invalida!
		esac
	done
	# -j (Isso especifica o alvo da regra)
	# -A (Anexa uma ou mais regras para o final da cadeia), INPUT(CADEIA DE ENTRADA), -p (protocolo a ser utilizado).
	# --dport (Porta de destino ou especificação do intervalo de portas.)
	# multiport: Este módulo corresponde à um conjunto de portas de origem ou destino. Até 15 portas podem ser especificadas. 
	# O iptables pode usar módulos correspondentes para pacotes grandes, implicitamente, quando "-p" ou "-protocol" for especificado; 
	# ou com as opções "-m" ou "--match" seguidas pelo nome do módulo correspondente: -m multiport"
	# ACCEPT (deixar o pacote passar pela porta especificada).
	# DROP (não deixar o pacote passar pela porta especificada).
}

#FUNÇÃO PARA ABRIR OU BLOQUEAR ENTRADA PARA UMA FAIXA DE ENDEREÇOS IP.
function _AB_FAIX_END_IP()
{
	_top
	PS3="Escolha uma opção acima: "
	echo -e "\t${AZ}Abrir ou Bloquear para uma faixa de endereços.${NC}\n"
	select OP in ABRIR BLOQUEAR sair; do
		case ${REPLY} in 
			1) read -p "Informe a faixa de endereços ex.(192.168.1.0/255.255.255.0): " FAIXAENDIP
			   $IPT4 -A INPUT -s ${FAIXAENDIP} -j ACCEPT
			   echo -e "${AZ}Status Faixa:${NC} ${AM}${FAIXAENDIP}${NC}.........................[${PS}${VD}Open${NC}]\n"
			   read -p "Precione Enter Para Contiunar..." x; break ;;
			2) read -p "Informe a faixa de endereços ex.(192.168.1.0/255.255.255.0): " FAIXAENDIP
			   $IPT4 -A INPUT -s ${FAIXAENDIP} -j DROP
			   echo -e "${AZ}Status Faixa:${NC} ${AM}${FAIXAENDIP}${NC}......................[${PS}${VM}Blocked${NC}]\n"
			   read -p "Precione Enter Para Contiunar..." x; break ;;
			3) break ;;
			*) echo -e "${VM}Opção Invalida!${NC}" #Caso seja informado um opção diferente das informada no menu dará como invalida!
		esac
	done
	# -j (Isso especifica o alvo da regra)
	# -A (Anexa uma ou mais regras para o final da cadeia), INPUT(CADEIA DE ENTRADA).
	# ACCEPT (deixar o pacote passar pela porta especificada).
	# DROP (não deixar o pacote passar pela porta especificada).
	# -s , --source [address/mask], Especificação de fonte. O endereço pode ser um nome de rede, um nome de host, 
	# um endereço IP de rede (com/ mask ) ou um endereço IP simples. Hostnames serão resolvidos apenas uma vez, antes 
	# que a regra seja enviada para o kernel.
}

#FUNÇÃO PARA ABRIR PORTAS PARA UM ENDEREÇO IP ESPECIFICO.
function _AB_PORT_FOR_IP_ESPC()
{
	_top
	PS3="Escolha uma opção acima: "
	echo -e "\t${AZ}Abrir ou Bloquear uma porta para um IP específico.${NC}\n"
	select OP in ABRIR BLOQUEAR sair; do
		case ${REPLY} in 
			1) read -p "Informe a porta: " PORT
			   read -p "Informe o ip: " IP
			   $IPT4 -A INPUT -p tcp -s ${IP} --dport $PORT -j ACCEPT
			   echo -e "${AZ}Status IP:${NC}${AM}${IP}${NC} ${AZ}para MAC:${NC}${AM}${PORT}${NC}.........................[${PS}${VD}Open${NC}]\n"
			   read -p "Precione Enter Para Contiunar..." x;break ;;
			2) read -p "Informe a porta: " PORT
			   read -p "Informe o ip: " IP
			   $IPT4 -A INPUT -p tcp -s ${IP} --dport $PORT -j DROP
			   echo -e "${AZ}Status IP:${NC}${AM}${IP}${NC} ${AZ}para MAC:${NC}${AM}${PORT}${NC}......................[${PS}${VM}Blocked${NC}]\n"
			   read -p "Precione Enter Para Contiunar..." x;break ;;
			3) break ;;
			*) echo  -e "${VM}Opção Invalida!${NC}" #Caso seja informado um opção diferente das informada no menu dará como invalida!
		esac
	done
	
	# --dport (Porta de destino ou especificação do intervalo de portas.)
	# -j (Isso especifica o alvo da regra)
	# -A (Anexa uma ou mais regras para o final da cadeia), INPUT(CADEIA DE ENTRADA), -p (protocolo a ser utilizado).
	# ACCEPT (deixar o pacote passar pela porta especificada).
	# DROP (não deixar o pacote passar pela porta especificada).
	# -s , --source [address/mask], Especificação de fonte. O endereço pode ser um nome de rede, um nome de host, 
	# um endereço IP de rede (com/ mask ) ou um endereço IP simples. Hostnames serão resolvidos apenas uma vez, antes 
	# que a regra seja enviada para o kernel.
}

#FUNÇÃO PARA VERIFICAR O IP E MAC DE UMA MAQUINA ANTES DE DAR AUTORIZAÇÃO DE ACESSO A MAQUINA SOLICITANTE.
function _VERIFY_IP_MAC()
{
	_top
	PS3="Escolha uma opção acima: "
	echo -e "\t${AZ}Verificar IP e MAC antes de autorizar a conexão.${NC}\n"
	select OP in ABRIR BLOQUEAR sair; do
		case ${REPLY} in 
			1) read -p "Informe a mac: " MAC
			   read -p "Informe o ip: " IP
			   $IPT4 -A INPUT -s ${IP} -m mac --mac-source ${MAC} -j ACCEPT
			   echo -e "${AZ}Status IP:${NC}${AM}${IP}${NC} ${AZ}para MAC:${NC}${AM}${MAC}${NC}.........................[${PS}${VD}Open${NC}]\n"
			   read -p "Precione Enter Para Contiunar..." x; break ;;
			2) read -p "Informe a mac: " MAC
			   read -p "Informe o ip: " IP
			   $IPT4 -A INPUT -s ${IP} -m mac --mac-source ${MAC} -j DROP
			   echo -e "${AZ}Status IP:${NC}${AM}${IP}${NC} ${AZ}para MAC:${NC}${AM}${MAC}${NC}......................[${PS}${VM}Blocked${NC}]\n"
			   read -p "Precione Enter Para Contiunar..." x; break ;;
			3) break ;;
			*) echo -e "${VM}Opção Invalida!${NC}" #Caso seja informado um opção diferente das informada no menu dará como invalida!
		esac
	done
	
	# -A (Anexa uma ou mais regras para o final da cadeia), INPUT(CADEIA DE ENTRADA).
	# ACCEPT (deixar o pacote passar pela porta especificada).
	# DROP (não deixar o pacote passar pela porta especificada).
	# -j (Isso especifica o alvo da regra)
	
	# -s , --source [address/mask], Especificação de fonte. O endereço pode ser um nome de rede, um nome de host, 
	# um endereço IP de rede (com/ mask ) ou um endereço IP simples. Hostnames serão resolvidos apenas uma vez, antes 
	# que a regra seja enviada para o kernel.
	
	# O iptables pode usar módulos correspondentes para pacotes grandes, implicitamente, quando "-p" ou "-protocol" for especificado; 
	# ou com as opções "-m" ou "--match" seguidas pelo nome do módulo correspondente: mac --mac-source"
	
	# mac --mac-source : Corresponder endereço MAC de origem. Deve ser da forma XX: XX: XX: XX: XX: XX. Note que isso só faz
    # sentido para pacotes provenientes de um dispositivo Ethernet e inserindo as cadeias PREROUTING ,   FORWARD   ou   INPUT.
}

#FUNÇÃO PARA ABRIR OU BLOQUEAR UM INTERVALO DE PORTAS NO FIREWALL.
function _AB_INTERVALO_PORT()
{
	_top
	PS3="Escolha uma opção acima: "
	echo -e "\t${AZ}Abrir ou Bloquear um intervalo de portas.${NC}\n"
	select OP in ABRIR BLOQUEAR sair; do
		case ${REPLY} in 
			1) read -p "Informe o intervalo ex. (6881:6889): " INTER
			   $IPT4 -A INPUT -p tcp --dport ${INTER} -j ACCEPT
			   echo -e "${AZ}Status intervalo:${NC}${AM}${INTER}${NC}........................[${PS}${VD}Open${NC}]\n"
			   read -p "Precione Enter Para Contiunar..." x; break ;;
			2) read -p "Informe o intervalo ex. (6881:6889): " INTER
			   $IPT4 -A INPUT -p tcp --dport ${INTER} -j DROP
			   echo -e "${AZ}Status intervalo:${NC}${AM}${INTER}${NC}.....................[${PS}${VM}Blocked${NC}]\n"
			   read -p "Precione Enter Para Contiunar..." x; break ;;
			3) break ;;
			*) echo -e "${VM}Opção Invalida!${NC}" #Caso seja informado um opção diferente das informada no menu dará como invalida!
		esac
	done
	# -j (Isso especifica o alvo da regra)
	# --dport (Porta de destino ou especificação do intervalo de portas.)
	# -A (Anexa uma ou mais regras para o final da cadeia), INPUT(CADEIA DE ENTRADA), -p (protocolo a ser utilizado).
	# ACCEPT (deixar o pacote passar pela porta especificada).
	# DROP (não deixar o pacote passar pela porta especificada).
}

#FUNÇÃO PARA ADICIONAR LOG EM UMA PORTA DE ACESSO DO SISTEMA.
function _LOG_PORT()
{
	_top
	echo -e "\t${AZ}Abrir LOG para uma porta.${NC}\n"
	read -p "Informe a porta: " PORT
	read -p "Informe o prefixo para log ex.( acesso ssh): " PREFIX
	$IPT4 -A INPUT -p tcp --dport=${PORT} -j LOG --log-level warning --log-prefix "${PREFIX}"
	echo -e "${AZ}Status Log port:${NC}${AM}${PORT}${NC}.....................[${PS}${VD}Log Accept${NC}]\n"
	read -p "Precione Enter Para Contiunar..." x;
	# -j (Isso especifica o alvo da regra)
	# --dport (Porta de destino ou especificação do intervalo de portas.)
	# -A (Anexa uma ou mais regras para o final da cadeia), INPUT(CADEIA DE ENTRADA), -p (protocolo a ser utilizado).
	# ACCEPT (deixar o pacote passar pela porta especificada).
	# DROP (não deixar o pacote passar pela porta especificada).
	
	#--log level <level> O nível descreve a gravidade da mensagem e é uma palavra-chave da seguinte ordem
    # list (maior para menor): emerg, alert, crit, err, warning, notice e debug.
    
    #LOG: Ativa o registro do kernel de pacotes correspondentes. Quando esta opção está definida para uma regra, o Linux
    #kernel irá imprimir algumas informações sobre todos os pacotes correspondentes (como a maioria dos campos de cabeçalho IP)
    #através do log do kernel (onde ele pode ser lido com dmesg ou syslogd.
    
    # prefixo --log-  prefixPrefixo mensagens de log com o prefixo especificado; até 29 cartas, e útil para
    # distinguindo mensagens nos logs.
	
}
#FUNÇÃO COM MENU DE SELEÇÃO PARA ESCOLHER QUAL CADEIA IRA ESCOLHER DENTRE (INPUT FORWARD OUTPUT) PARA FAZER A REMOÇÃO DAS REGRAS.
#AO ESCOLHER SERÁ LISTADO TODAS AS REGRAS DA REFERIDA CADEIA COM O NUMÉRO INDICANDO A POSIÇÃO, ONDE SERÁ INFORMADA ESTE NUMÉRO PARA REMOÇÃO.
function _remove_regras_cadeias()
{
	_top
	PS3="Selecione uma cadeia acima: "
	select OP in INPUT FORWARD OUTPUT sair; do
		case ${REPLY} in 
			1) _INPUT_RM; break ;; #Remoção da regrada cadeia [INPUT]
			2) _FORWARD_RM; break ;; #Remoção da regrada cadeia [FORWARD]
			3) _OUTPUT_RM; break ;; #Remoção da regrada cadeia [OUTPUT]
			4) break ;; #Finaliza
			*) echo -e "${VM}Opção Invalida!${NC}" #Caso seja informado um opção diferente das informada no menu dará como invalida!
		esac
	done
}

#FUNÇÃO PARA EXECUTAR A REMOÇÃO DAS REGRAS PELO INDICE DE CADA REGRAS DA CADEIA INPUT.
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
	
	# -D, --delete chain rulenum :: Exclui uma ou mais regras da chain(cadeia) especificada. Existem duas versões deste comando: 
	# a regra pode ser especificada como um número na chain (rulenum - começando em 1 para a primeira regra) ou o nome da 
	# regra para combinar (rule-specification).
	#CADEIAS -> (INPUT OUTPUT FORWARD).
}

#FUNÇÃO PARA EXECUTAR A REMOÇÃO DAS REGRAS PELO INDICE DE CADA REGRAS DA CADEIA FORWARD.
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
	# -D, --delete chain rulenum :: Exclui uma ou mais regras da chain(cadeia) especificada. Existem duas versões deste comando: 
	# a regra pode ser especificada como um número na chain (rulenum - começando em 1 para a primeira regra) ou o nome da 
	# regra para combinar (rule-specification).
	#CADEIAS -> (INPUT OUTPUT FORWARD).
}

#FUNÇÃO PARA EXECUTAR A REMOÇÃO DAS REGRAS PELO INDICE DE CADA REGRAS DA CADEIA OUTPUT.
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
	# -D, --delete chain rulenum :: Exclui uma ou mais regras da chain(cadeia) especificada. Existem duas versões deste comando: 
	# a regra pode ser especificada como um número na chain (rulenum - começando em 1 para a primeira regra) ou o nome da 
	# regra para combinar (rule-specification).
	#CADEIAS -> (INPUT OUTPUT FORWARD).
}

case $1 in
	start) _menu_principal break ;;
	*) echo " * Opção inválida, use: $0 {start}"; exit 1
esac
