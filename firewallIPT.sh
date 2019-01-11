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

IPT=$(which iptables) #/sbin/iptables

function _menu_firewall()
{
	clear
		echo "+-----------------------------------------------+"
		echo "|               FIREWALL-IPTABLES               |"
		echo "+-----------------------------------------------+"
		echo "| [ 1 ] » INICIAR FIREWALL.                     |"
		echo "| [ 2 ] » DESATIVAR FIREWALL.                   |"
		echo "| [ 3 ] » LISTAR REGRAS HABILITADAS.            |"
		echo "| [ 4 ] » REMOVER REGRA HABILITADA.             |"
		echo "| [ 5 ] » ADICIONAR NOVA REGRA.                 |"
		echo "| [ 0 ] » FINALIZAR.                            |"
		echo "+-----------------------------------------------+"
}
function _start_fw()
{
	




}
