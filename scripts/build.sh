#!/bin/bash

RELEASE_VRSN=1.0.2
PACKAGE_DIR=../package

docker build -t rabay/sonarqube-stack:latest -t rabay/sonarqube-stack:v$RELEASE_VRSN ../

### Gera pacote de release com arquivos de instalação necessários
zip -D $PACKAGE_DIR/sonar-package-v$RELEASE_VRSN.zip docker-compose.yml install_dockerhub.sh install_dockerhub.bat

# echo "Exportando imagens do Docker..."
# rm -fv sonarqube-latest.tar
# docker save rabay/sonarqube-stack:latest postgres:alpine | (pv -p --timer --rate --bytes > docker-images-latest.tar)

# echo "Testando integridade das imagens exportadas..."
# pv -p --timer --rate --bytes docker-images-latest.tar | docker load

# echo "Compactando imagens exportada..."
# rm -fv docker-images-latest.tar.gz
# pv -p --timer --rate --bytes docker-images-latest.tar | gzip -9 > docker-images-latest.tar.gz \
#     && rm -fv sonarqube-latest.tar

# echo "Gerando pacote para instalação no cliente..."
# rm -fv sonar-package.tar.gz
# # tar -zcvf - ../scripts/install.* ../scripts/docker-compose.yml docker-images-latest.tar.gz | (pv -p --timer --rate --bytes > sonar-package.tar.gz)
# zip -9 -v -D -j sonar-package-lnx.zip ../scripts/install.* ../scripts/docker-compose.yml docker-images-latest.tar.gz

# echo "Apagando arquivos intmediários..."
# rm -f docker-images-latest.tar docker-images-latest.tar.gz