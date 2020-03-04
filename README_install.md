# Guia de Instalação

Descompacte o arquivo "sonar-package.tar.gz" em um diretório e o use como diretório de trabalho. Siga os passos abaixo.

1. **Habilitar o Hyper-V**  
Execute o script "scripts/EnableHyperV.bat" como administrador para habilitar o Hyper-V em sua estação Windows 10 Pro. Após a execução, reinicie seu computador. Caso esteja executando esta solução num ambiente Linux, este passo é desnecessário.  

2. **Instalar o Docker Desktop / Docker Engine**  
No Windows, você precisará ter o Docker Desktop instalado para poder executar os containeres desta solução. Para isso, baixe o instalador [aqui](https://download.docker.com/win/stable/Docker%20Desktop%20Installer.exe) e o execute. Siga os passos apresentados na tela e, ao término, reinicie seu computador. No Linux, instale o Docker Engine de acordo com sua distribuição. Neste [link](https://docs.docker.com/install/) você terá mais informações de como fazer isso.

3. **Configure o Docker Desktop**  
Dependendo do seu ambiente de trabalho, você precisará configurar alguns itens em sua instalação do Docker. Para acessar a área de configurações do Docker for Windows, clique com o botão direito no ícone da aplicação na bandeja do sistema e depois escolha a opção "Settings".

	- *Proxy*  
	Caso acesse à internet através de um proxy, você precisará informá-lo ao Docker para que ele consiga acessar os repositórios de imagens de containeres. Você insere essa informação na opção "Proxies" da tela de configuração do Docker for Desktop. Talvez precise configurar um proxy local alternativo caso faça uso de um proxy corporativo com autenticação NTLM. Neste [artigo](http://www.rabay.net/2020/03/instalando-e-configurando-o-cntlm-no.html) você poderá ver como instalar o [CNTLM](http://cntlm.sourceforge.net) e contornar essa situação.
	- *Daemon*  
	Recomenda-se inserir o exemplo abaixo como código base abaixo, para limitar o tamanho e a quantidade de arquivos de log gerados pelos containeres. Acesse a área "Daemon" da tela de configurações, altere o modo de edição de "Basic" para "Advanced" e cole o bloco de texto abaixo na área indicada. Clique em "Apply" quando concluir.

			{
				"registry-mirrors": [],  
				"insecure-registries": [],  
				"debug": true,  
				"experimental": true,
				"log-driver": "json-file",
				"log-opts": {
					"max-size": "10m",
					"max-file": "3"
				}
			}  

4. **Instalar a aplicação do pacote**  
Execute o script "install.bat" para que a aplicação Sonarqube seja instalada em sua estação. Aguarde o término do processo. Após, você poderá acessar a interface web do Sonarqube pelo endereço http://localhost:9000, e se autenticar usando tanto como usuário e senha "*admin*".
<br>
<br>
<br>
O pacote foi construído e testado num ambiente com Windows 10 Pro, com os requisitos acima instalados e configurados. Porém, o mesmo pode ser executado num ambiente Linux nativo sem nenhuma ou com poucas alterações.