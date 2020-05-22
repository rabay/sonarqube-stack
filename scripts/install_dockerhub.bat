@ECHO OFF
TITLE Instalando o Sonarqube

ECHO Iniciando stack do Sonarqube...
docker-compose -f docker-compose.yml -p sonarstack down --remove-orphans -v

ECHO Atualizando imagens a partir do Docker Hub...
docker-compose -f docker-compose.yml -p sonarstack pull

ECHO Aguardando a inicializacao do PostgreSQL...
docker-compose -f docker-compose.yml -p sonarstack up -d lcl-postgresql
timeout /t 15 /nobreak

ECHO Aguardando a inicializacao do Sonarqube...
docker-compose -f docker-compose.yml -p sonarstack up -d lcl-sonar
timeout /t 100 /nobreak

ECHO Configurando opcoes default do Sonarqube...
docker exec -it lcl-sonar bash -c "/opt/sonarqube/bin/config.sh"

ECHO Instalacao realizada com sucesso. Para acessar, entre com a URL http://localhost:9090, usuario e senha "admin"
PAUSE