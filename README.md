# Compass Uol - Atividade AWS/Linux

# Sobre a Atividade.

Repositorio para a atividade de Linux, do programa de bolsas da Compass UOL. Atividade individual para implementação de requisitos sobre Linux e AWS a serem atendidos, tais como:

  Requisitos AWS:
  1. Gerar uma chave pública para acesso ao ambiente;
  2. Criar 1 instância EC2 com o sistema operacional Amazon Linux 2 (Família t3.small, 16 GB SSD);
  3. Gerar 1 elastic IP e anexar à instância EC2;
  4. Liberar as portas de comunicação para acesso público: (22/TCP, 111/TCP e UDP, 2049/TCP/UDP, 80/TCP, 443/TCP)

  Requisitos no Linux:
  1. Configurar o NFS entregue;
  2. Criar um diretorio dentro do filesystem do NFS com seu nome;
  3. Subir um apache no servidor - o apache deve estar online e rodando;
  4. Criar um script que valide se o serviço esta online e envie o resultado da validação para o seu diretorio no nfs;
  5. O script deve conter - Data HORA + nome do serviço + Status + mensagem personalizada de ONLINE ou offline;
  6. O script deve gerar 2 arquivos de saida: 1 para o serviço online e 1 para o serviço OFFLINE;
  7. Preparar a execução automatizada do script a cada 5 minutos.
  8. Fazer o versionamento da atividade;
  9. Fazer a documentação explicando o processo de instalação do Linux.

---

# Sumário.
- [Sobre a Atividade](#sobre-a-atividade)
- [Pré Requisitos AWS](#pré-requisitos-aws)
- [Gerar um Par de chaves para a instância EC2](#gerar-um-par-de-chaves-para-a-instância-ec2)
- [Criando a VPC](#criando-a-vpc)
- [Criando a Sub-Rede](#criando-a-sub-rede)
- [Criando e configurando o gateway de internet](#criando-e-configurando-o-gateway-de-internet)
- [Liberando tráfego de internet na Tabela de Roteamento](#liberando-tráfego-de-internet-na-tabela-de-roteamento)
- [Executando a Instância](#executando-a-instância)
- [Associar IP Elástico a Instância EC2](#associar-ip-elástico-a-instância-ec2)
- [Configurando acesso ao NFS](#configurando-acesso-ao-nfs)
- [Configurando o Apache](#configurando-o-apache)
- [Referências](#referências)

---

## Passo a Passo de como foi executado

### Pré Requisitos AWS.
- Foi utilizado no projeto uma vpc nova para manter organizado.
- Foi criado também um Grupo de segurança novo.
- Foi criado Sub-Rede nova.
- Foi criado um Gateway de Internet.
  
  Vamos aprofundar mais pra frente como eu fiz

### Gerar um Par de chaves para a instância EC2.
 Essa Parte é importante para acessar a instância EC2 remotamente
 
- Acessar a AWS na pagina do serviço EC2, e clicar em `Pares de chaves` no menu lateral esquerdo.
- Clicar em `Criar par de chaves`. 
- Inserir um nome para a chave, no qual eu coloquei como `Chave-Projeto`
- No formato do arquivo da chave foi colocada como `.pem` para acessar via CMD a instância.
- Feito isso, vamos clicar em `Criar par de chaves`.
- Salvar o arquivo .pem gerado em um local seguro.

### Criando a VPC.
- Acessar a AWS na pagina do serviço VPC, e clicar em `Suas VPCs` no menu lateral esquerdo e depois em `Criar VPC`
- Coloquei somente VPC para configurar tudo na mão e não ter risco de ficar faltando nada
- Coloquei o nome como `VPC-PROJETO`
- Bloco CIDR IPv4 coloquei como `Entrada manual de CIDR IPv4`
- CIDR IPv4 coloquei como 10.0.0.0/16
- finalizando marquei Bloco CIDR ipv6 como `Nenhum Bloco CIDR IPv6`
- Finalizei criando a vpc

### Criando a Sub-Rede.
- Acessar a AWS na pagina do serviço VPC, e clicar em `Sub-redes` no menu lateral esquerdo e depois clicar em `Criar Sub-rede`
- Feito isso `aloquei a VPC criada anteriormente`
- O nome da sub-rede ficou como Sub-Projeto
- Na parte da zona de disponibilidade coloquei como us-east-1a
- e por ultimo finalizei colocando o Bloco CIDR IPv4 da sub-rede como 10.0.1.0/24
- e criei a sub-rede

### Criando e configurando o gateway de internet.
- Acessar a AWS na pagina do serviço VPC, e clicar em `Gateways de internet` no menu lateral esquerdo e depois em Clicar em `Criar gateway de internet`.
- Feito isso coloquei o nome como `Projeto`.
- Depois vamos  clicar em `criar gateway de internet`
- Feito isso vamos sSelecionar o gateway criado e clicar em `Ações` depois em  `Associar à VPC`.
- Selecionar a VPC da instância EC2 criada anteriormente e clicar em `Associar`.

### Configurando a tabela de roteamento.
- Acessar a AWS na pagina do serviço VPC, e clicar em `Tabelas de rotas` no menu lateral esquerdo e depois Clicar em `Criar nova tabela de rotas`
- Feito isso vamos por o nome que eu coloquei como `Tab-Projeto`
- Pra finalizar a criação associamos a tabela a VPC criada anteriormente.                   
- Após isso, com a rota criada vamos selecionar a tabela de rotas da VPC da instância EC2 `clicar em ações` e depois em `editar rota`
- Vamos clicar em `Adicionar rota` e preencher desse jeito:
  
        - Destino: 0.0.0.0/0
        - Alvo: vamos colocar o gateway de internet criado anteriormente
  
- Após isso vamos clicar em salvar e finalizamos a parte de tráfego de internet.

### Liberando tráfego de internet na Tabela de Roteamento.
- Acessar a AWS na pagina do serviço EC2, e clicar em `Segurança`  depois clicamos em  `Grupos de segurança` no menu lateral esquerdo.
- Seleciono `criar um novo grupo de segurança`.
- Feito isso, eu coloquei o nome do meu grupo que foi `ProjetoAws`
- Coloquei a descrição como ProjetoAws também para ficar organizado.
- Feito isso, fiz a `alocação com a minha VPC criada`
- Agora eu fiz a parte principal da atividade, que é `configurar as regras de entrada`, clicando em adicionar nova regra. No caso eu eu adicionei 7 novas regras que são:

![Regras de Tráfego de Internet na Tabela de Roteamento](Regras%20Tr%C3%A1fego%20de%20internet%20na%20tabela%20de%20roteamento.png)

### Executando a Instância.
- Acessar a AWS na pagina do serviço EC2, e clicar em `Instâncias`
- Após isso vamos em `Executar Instância` e preencher dessa forma:
- Na parte de nomes e tags vamos por o padrão que é `(Name, Project e CostCenter) para instâncias e volumes`.
- Vamos por a imagem `como Amazon Linux 2 AMI (HVM), SSD Volume Type`.
- Tipo de instância vai ser colocado  como `t3.small`.
- Selecionar a chave gerada anteriormente que no caso foi criada como `Chave-Projeto`
- Feito isso na parte de configuração de rede vamos clicar em `editar` e verificar se está a vpc criada para o projeto e a sub-rede.
- Depois disso ainda nas configurações de redes vamos em `Firewall` e vamos `Selecionar grupo de segurança existente`, vai abrir uma aba e vmaos por o nosso grupo de segurança que no caso é `ProjetoAWS`
- Para finalizar a criação da EC2 vamos configurar o armazenamento mudando para `16 GIB gp2 (SSD)`
- Finalizamos em `Executar Instância`

### Associar IP Elástico a Instância EC2.
Para que uma instância adquira um endereço IPv4 público estático, é necessário associar um IP elástico a ela.
- Acessar a AWS na pagina do serviço EC2, e clicar em `IPs elásticos` no menu lateral esquerdo.
- Clicar em `Alocar endereço IP elástico`.
- Vamos marcar o ip alocado e clicar em `Ações` e depois em  `Associar endereço IP elástico`.
- Selecionar a instância EC2 criada anteriormente e clicar em `Associar`.

  Após todas essas etapas que fizemos até aqui, vamos executar a instância e configurar os requisitos de linux.
---

### Configurando acesso ao NFS.
O NFS é um sistema de arquivos virtual amplamente utilizado para compartilhar dados na rede. Na AWS, esse serviço é fornecido pelo EFS (Elastic File System).
- primeiro modo, vamos atualizar o sistema e instalar os utilitários do NFS:
  -```sudo yum update -y ```
  e depois
  ```sudo yum install -y nfs-utils```

- Feito isso vamos criar um diretório para o NFS, utilizando o comando:
  -```sudo mkdir -p /nfs/moises```

- Após criar o diretorio vamos configurar as permissões do diretório>
  -```sudo chown nobody:nobody /nfs/moises```
  e depois
  ```sudo chmod 777 /nfs/moises```

- Feito isso vamos configurar o compartilhamento da NFS da seguinte forma:
  -```echo "/nfs/moises *(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports```

- Depois eu expostei os sitemas de arquivo utilizando o
  - ```sudo exportfs -a```
 
- E finalizando a parte do NFS eu iniciei e habilitei os serviços dele utilizando os comandos:
 -```sudo systemctl start nfs-server```
  e depois
  ```sudo systemctl enable nfs-server```

### Configurando o Apache
- Primeiro utilizei o comando para instalar o apache
  -```sudo yum install -y httpd```

- Após isso iniciei e habilitei os serviços do apache
  -```sudo systemctl start httpd```
  e depois
  ```sudo systemctl enable httpd```

- Feito isso criei um diretório para o script
  -```sudo mkdir -p /usr/local/bin/```

- Agora eu criei um script para validação
  - ```sudo nano /usr/local/bin/verifica_apache.sh```
    
e dentro do arquivo script adiconei o seguinte Shell Script:

   ```bash
    
    #!/bin/bash

DIR_NFS="/nfs/moises"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
SERVICE="httpd"
STATUS=$(systemctl is-active $SERVICE)

if [ "$STATUS" == "active" ]; then
    MESSAGE="ONLINE"
    echo "$DATE $SERVICE $STATUS $MESSAGE" >> $DIR_NFS/online.log
else
    MESSAGE="OFFLINE"
    echo "$DATE $SERVICE $STATUS $MESSAGE" >> $DIR_NFS/offline.log
fi

```
- Salvar o arquivo de script.
  
- Após isso vamos tornar o script executavel utilizando o comando ```sudo chmod +x /usr/local/bin/verifica_apache.sh```

- Feito isso vamos configurar o contrab para que o script seja executado automaticamente a cada 5 minutos com privilégios de root
  -   ```sudo crontab -e```
 
Para finalizar iremos fazer esse script executar a cada 5 minuto. 
  -  ```*/5 * * * * /usr/local/bin/verificar_apache.sh```
    

### Com isso finalizamos a atividade e um dos jeitos de testar se o apache está online é pegando o ip publico da instância e jogando na web, no qual vai cair na web do apache.
---

# Referências

- [Documentação da Amazon Web Services](https://docs.aws.amazon.com/pt_br/index.html)
- [Guia para Shell Script](https://www.shellscript.sh/index.html)
- [Documentação do Amazon Linux 2](https://docs.aws.amazon.com/pt_br/AWSEC2/latest/UserGuide/amazon-linux-2-virtual-machine.html)


