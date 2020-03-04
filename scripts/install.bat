@ECHO OFF
TITLE Instalando o Sonarqube

ECHO Importando imagem Docker do Sonarqube na instalacao local do Docker..
docker load -i docker-images-latest.tar.gz

ECHO Iniciando stack do Sonarqube...
docker-compose -f docker-compose.yml -p sonarstack down --remove-orphans -v

docker-compose -f docker-compose.yml -p sonarstack up -d lcl-postgresql
ECHO Aguardando a inicializacao do PostgreSQL...
timeout /t 15 /nobreak

docker-compose -f docker-compose.yml -p sonarstack up -d lcl-sonar

ECHO Aguardando a inicializacao do Sonarqube...
timeout /t 100 /nobreak

ECHO Configurando opcoes default do Sonarqube...
docker exec -it lcl-sonar bash -c "/opt/sonarqube/bin/config.sh"

ECHO Instalacao realizada com sucesso. Para acessar, entre com a URL http://localhost:9090, usuario e senha "admin"
PAUSE