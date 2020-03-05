@ECHO OFF

REM set PACKAGE_DIR="%~dp0"

docker build -t rabay/sonarqube:latest ..\

del "..\package\docker-images-latest.tar" /q /f
docker save rabay/sonarqube-stack:latest postgres:alpine -o "..\package\docker-images-latest.tar"
docker load -i "..\package\docker-images-latest.tar"

REM 7z a -tgzip -sdel -mx=7 -mmt=on "..\package\docker-images-latest.tar.gz" "..\package\docker-images-latest.tar"
..\resources\7za.exe a -tgzip -sdel -mx=7 -mmt=on "..\package\docker-images-latest.tar.gz" "..\package\docker-images-latest.tar"
..\resources\7za.exe a -tzip -mx=7 -mmt=on "..\package\sonar-package-win.zip" "..\package\docker-images-latest.tar.gz" "..\scripts\install.*" "..\scripts\docker-compose.yml"
del "..\package\docker-images-latest.tar.gz" /q /f

PAUSE