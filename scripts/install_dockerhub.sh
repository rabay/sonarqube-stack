#!/bin/bash

### REQUISITOS (CentOS / Red Hat) ###
# Pacote bind-utils => yum install -y bind-utils
# Docker => 
# Docker Compose => 

echo -e "\n================================================================"
docker-compose -f docker-compose.yml -p sonarstack config
# docker-compose -f docker-compose.yml -p sonarstack config > docker-compose-config.yml
echo "================================================================"

echo "Iniciando container Sonarqube..."
docker-compose -f docker-compose.yml -p sonarstack down --remove-orphans -v

docker-compose -f docker-compose.yml -p sonarstack up -d lcl-postgresql
echo "Aguardando 10 segundos para a inicializacao do banco de dados..."
for i in {0..10}; do echo -ne "$i"'\r'; sleep 1; done; echo 

docker-compose -f docker-compose.yml -p sonarstack up -d lcl-sonar
echo "Aguardando 100 segundos para a inicializacao do Sonarqube (não cancele esta operação!)..."
for i in {0..100}; do echo -ne "$i"'\r'; sleep 1; done; echo 

echo "Configurando opcoes default do Sonarqube..."
docker exec -it lcl-sonar bash -c "/opt/sonarqube/bin/config.sh"

echo -e "\n\nInstalacao realizada com sucesso. Para acessar, entre com a URL http://localhost:9000, usuario e senha 'admin'\n"