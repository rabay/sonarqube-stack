@ECHO OFF

REM set PACKAGE_DIR="%~dp0"

docker build -t bradesco/sonarqube:latest ..\

del "..\package\docker-images-latest.tar" /q /f
docker save bradesco/sonarqube:latest postgres:alpine -o "..\package\docker-images-latest.tar"
docker load -i "..\package\docker-images-latest.tar"

7z a -tgzip -sdel -mx=7 -mmt=on "..\package\docker-images-latest.tar.gz" "..\package\docker-images-latest.tar"

PAUSE