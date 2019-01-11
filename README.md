PROJETO DE PROGRAMAÇÃO DE SCRIPT

gerenciador de firewall com com iptables.

COLOCANDO O SCRIPT PARA INICIAR COM O SISTEMA
EXECUTE OS COMANDO ABAIXO COMO ROOT.

1 - BAIXE OS ARQUIVO COM O COMANDO: git clone https://github.com/elizot/Projeto-Programacao-de-Script.git

2 - CRIE O DIRETORIO:
mkdir /etc/firewall

3 - COPIAR O ARQUIVO: 
cp /home/diretorio/firewall.sh /etc/firewall/

4 - CRIE UM LINK SIMBOLICO DO ARQUIVO PARA O DIRETORIO: 
ln -s /etc/firewall/firewall.sh /etc/init.d

5 - ENTRE NO DIRETORIO: 
cd /etc/init.d


6 - COLOCANDO O SCRIPT NA INICIALIZAÇÃO: 
update-rc.d firewall.sh defaults

7 - TORNE O SCRIPT EXECUTAVEL: 
 chmod +x /etc/firewall/firewall.sh
 
8 - CASO QUEIRA REMOVER O SCRIPT DA INICIALIZAÇÃO: 
update-rc.d -f firewall.sh remove




