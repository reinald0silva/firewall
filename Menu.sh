#!/bin/bash
while true;do
var=$(sed -n '/consulta.sh/p' /etc/crontab) 
echo "|--------------------------------------|"
echo "|    Monitor de Recursos  - Script     |"
echo "|--------------------------------------|"
if echo $var | egrep 'consulta.sh'&>/dev/null;then
echo "|  1 - Parar monitoramento             |" 
else
echo "|  1 - Iniciar Monitoramento           |" 
fi
echo "|  2 - Visualizar Arquivo de Log       |"
echo "|  3 - Pesquisar Por data              |"
echo "|  4 - Limpar dados Anteriores         |"
echo "|  0 - Sair                            |"
echo "|--------------------------------------|"
read -p "Opção:" a
case $a in
1) clear;
if echo $var | egrep 'consulta.sh'&>/dev/null;then
sed -i '/consulta.sh/d' /etc/crontab
echo "Monitoramento parado"

else
echo "Monitoramento Iniciado"
echo "As consultas Snmp serão feitas a cada 1 minuto ..."
echo "E os dados serão gravados no arquivo db_clientes."
echo '*/1 * * * *  root  /root/consulta.sh'>> /etc/crontab
fi
;;
2)clear; echo "Visualizar Dados anteriores"
cat db_cliente.txt | more
clear
;;
3)clear;echo "Pesquisar por Data"
db=$(ls /root/)
if echo $db | egrep 'db_cliente.txt'&>/dev/null;then
read -p "Insira a data - Ex:(Jan 1 12:01:59)" data
numero=$(wc -l db_cliente.txt | cut -f1 -d" ")
grep -A $numero $data db_cliente.txt | more
clear
else
echo "Arquivo não encontrado"
echo "Inicie o Monitoramento e Pesquise novamente"
fi
;;
4)clear; echo "Logs Anteriores Limpos"
rm db_cliente.txt
;;
0)clear;echo "Finalizado" && exit 0;;
*) echo "Opção Invalida !";;
esac
done
