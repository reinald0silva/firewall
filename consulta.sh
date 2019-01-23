#!/bin/bash
echo "|    Consulta Feita em : "$(date)"  |">>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
echo "|          Dados do sistema Operacional            | " >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
snmpwalk -v2c -c public cliente .1.3.6.1.2.1.1.1 | cut -f2 -d":" >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
echo "|          Horario da Maquina                      | " >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
snmpwalk -v2c -c public cliente .1.3.6.1.4.1.2021.100.4 | cut -f2-4 -d":" >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
echo "|          Contato do Administrador da Maquina     | " >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
snmpwalk -v2c -c public cliente .1.3.6.1.2.1.1.4.0 | cut -f2 -d":" >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
echo "|          Nome da Maquina                         | " >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
snmpwalk -v2c -c public cliente .1.3.6.1.2.1.1.5 | cut -f2 -d":" >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
echo "|          Porcentagem de CPU ociosa               | " >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
snmpwalk -v2c -c public cliente .1.3.6.1.4.1.2021.11.11 | cut -f2 -d":" >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
echo "|          Tempo desde a ultima inicialização      | " >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
snmpwalk -v2c -c public cliente .1.3.6.1.2.1.25.1.1 | cut -f2 -d")" >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
echo "|          Numero de Usuários Logados na Maquina    | " >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
snmpwalk -v2c -c public cliente .1.3.6.1.2.1.25.1.5 | cut -f2 -d":" >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
echo "|          Numero de Interfaces                     | " >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
snmpwalk -v2c -c public cliente .1.3.6.1.2.1.2.1 | cut -f2 -d":" >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
echo "|          Descrição das Placas de Rede             | " >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
snmpwalk -v2c -c public cliente .1.3.6.1.2.1.31.1.1.1.1>>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
echo "|          Descrição das Interfaces de Rede         | " >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
snmpwalk -v2c -c public cliente .1.3.6.1.2.1.2.2.1.2 | cut -f2 -d":" >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
echo "|          Status das Interface 1-up,2-down         | " >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
snmpwalk -v2c -c public cliente .1.3.6.1.2.1.2.2.1.8 | cut -f2 -d":" >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
echo "|          Quantidade de Bytes de Saida             | " >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
snmpwalk -v2c -c public cliente .1.3.6.1.2.1.2.2.1.16 | cut -f2 -d":" >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
echo "|          Quantidade de Bytes de Entrada           | " >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
snmpwalk -v2c -c public cliente .1.3.6.1.2.1.2.2.1.10 | cut -f2 -d":" >>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
echo "|          Nome dos Discos                         | ">>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
snmpwalk -v2c -c public cliente .1.3.6.1.4.1.2021.13.15.1.1.2 | cut -f2 -d":">>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
echo "|          Processos                               | ">>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
snmpwalk -v2c -c public cliente .1.3.6.1.2.1.25.4.2.1.2 | cut -f2 -d":">>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
echo "|          Softwares Instalados e versão           | ">>db_cliente.txt
echo "-----------------------------------------------------">>db_cliente.txt
snmpwalk -v2c -c public cliente .1.3.6.1.2.1.25.6.3.1.2 | cut -f2 -d":">>db_cliente.txt

echo '#'>>db_cliente.txt
