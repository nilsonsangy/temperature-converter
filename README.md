# Conversor de Temperatura

### Sobre o Projeto

Conversor de temperatura desenvolvido em NodeJS. O projeto tem como objetivo ser um exemplo para a criação de ambiente com containers usando NodeJS.

### Observações do projeto

Os containers utilizam a porta 8080.

O service mapeia para a porta 80.

O service expõe o cluster Kubernetes para a porta 30000.

### Diretório /src/

O diretório /src/ armazena todos os arquivos necessários para construir a imagem do container.

Para construir a imagem, execute o comando:

`docker build -t conversor .`