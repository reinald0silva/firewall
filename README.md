# PROJETO DE PROGRAMAÇÃO DE SCRIPT

gerenciador de firewall com com iptables.

# COLOCANDO O SCRIPT PARA INICIAR COM O SISTEMA
# EXECUTE OS COMANDO ABAIXO COMO ROOT.

BAIXE OS ARQUIVO COM O COMANDO: 

# CRIE O DIRETORIO:
mkdir /etc/firewall

# COPIAR O ARQUIVO PARA /etc/firewall/: 
cp /home/diretorio/firewall.sh /etc/firewall/

# CRIE UM LINK SIMBOLICO DO ARQUIVO PARA O DIRETORI /etc/init.d
ln -s /etc/firewall/firewall.sh /etc/init.d

# ENTRE NO DIRETORI /etc/init.d
cd /etc/init.d


# COLOCANDO O SCRIPT NA INICIALIZAÇÃO
update-rc.d firewall.sh defaults

# TORNE O SCRIPT EXECUTAVEL
 chmod +x /etc/firewall/firewall.sh




