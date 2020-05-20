# Sonarqube Stack

A ideia deste stack é prover uma versão offline do Sonarqube com plugins atualizados para a execução de análises de códigos Java e Javascript, além de permitir a análise de verificação de dependências.

Este pacote é composto por uma imagem Docker baseada em Debian, contentdo o Sonarqube e diversos plugins que são baixados e instalados durante o build da imagem. Faz uso também de uma imagem PostgreSQL para armazenamento dos dados.

O ambiente tem a finalidade de ser imutável, servindo apenas para análises locais. Caso se deseje atualizar um dos serviços incluídos, deverá ser gerada uma nova imagem, recriando o stack no Docker em seguida. Não há configuração para persistência dos dados de análises e de configurações personalizadas.

## Requisitos de ambiente build da imagem Docker

- **Para ambientes Windows**
  - Hyper-V habilitado;
  - [Docker Desktop e Docker compose](https://docs.docker.com/docker-for-windows/install/);
  - Compactador [7zip standalone](https://www.7-zip.org/a/7z1900-extra.7z) (somente executável - 7za.exe) no diretório "resources", 

- **Para ambientes Linux**
  - [Docker Engine](https://docs.docker.com/install/linux/docker-ce/centos/);
  - [Docker Compose](https://docs.docker.com/compose/install/);
  - Pacotes: pv, bind-utils, gzip, zip


## Build do pacote

Para construir o pacote offline de instalação, execute o script "scripts/build.sh", caso use Linux, ou "scripts/build.bat", se estiver no Windows. Um arquivo com o nome "sonar-package.tar.gz" deverá ser gerado no diretório "packages".

## Instalação do pacote

[Clique aqui](README_install.md) para abrir o guia de instalação.