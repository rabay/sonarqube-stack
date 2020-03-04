#!/bin/bash

# docker pull xetusoss/archiva:latest
# docker build -t bradesco/mailhog:latest ../../MailHog
# docker build -t bradesco/cntlm:latest ../../CNTLM
docker build -t bradesco/sonarqube:latest ../

PACKAGE_DIR=../package

cd $PACKAGE_DIR

echo "Exportando imagens do Docker..."
rm -fv sonarqube-latest.tar
#docker save -o ../package/sonarqube-latest.tar bradesco/cntlm:latest bradesco/mailhog:latest bradesco/sonarqube:latest xetusoss/archiva:latest
docker save bradesco/sonarqube:latest postgres:alpine | (pv -p --timer --rate --bytes > docker-images-latest.tar)

echo "Testando integridade das imagens exportadas..."
pv -p --timer --rate --bytes docker-images-latest.tar | docker load

echo "Compactando imagens exportada..."
rm -fv docker-images-latest.tar.gz
pv -p --timer --rate --bytes docker-images-latest.tar | gzip -9 > docker-images-latest.tar.gz \
    && rm -fv sonarqube-latest.tar

echo "Gerando pacote para instalação no cliente..."
rm -fv sonar-package.tar.gz
tar -zcvf - ../docs/*.pdf docker-compose.yml docker-images-latest.tar.gz install.sh | (pv -p --timer --rate --bytes > sonar-package.tar.gz)