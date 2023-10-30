# Script de Script de Provisionamento de Servidor Apache

## O que o Script deve fazer?

* Atualizar o servidor;
* Instalar o apache2;
* Instalar o unzip;
* Baixar a aplicação disponível no endereço https://github.com/denilsonbonatti/linux-site-dio/archive/refs/heads/main.zip no diretório /tmp;
* Copiar os arquivos da aplicação no diretório padrão do apache.

## Requisitos 

* Todo provisionamento deve ser feito em um arquivo do tipo Bash Script;

## Explicando Meu Código

Este script contém comandos simples que são comuns para administradores de sistemas Linux no dia a dia.

### 1- Atualização do Sistema:

A atualização do sistema é feita usando `apt update` e `apt upgrade`. No início, usamos `sudo` para garantir privilégios de __superadministrador__. O argumento `-y` indica que o script deve responder __"sim"__ automaticamente para qualquer pergunta feita durante o processo de atualização.

```
#Update
echo "Verificando atualizações..."
echo ""
sudo apt update
echo ""
echo "Verificação concluida!"
```

```
#Upgrade
echo "Atualizando Sistema"
echo ""
sudo apt upgrade -y
echo ""
echo "Atalização concluida!"
```

### 2- Instalação de Pacotes

Três pacotes são fundamentais para a conclusão do objetivo deste script: __apache2__, __unzip__ e __wget__. O __wget__ é geralmente um pacote padrão na maioria das distribuições Linux. No entanto, é feita uma verificação para garantir que ele esteja presente, assim como os outros pacotes.

Utilizamos um __array__ chamado __pacotes__, que contém os nomes dos pacotes a serem instalados. Em seguida, usamos um loop `for` para percorrer esse array e verificar se cada pacote está instalado usando o comando `dpkg -l`.

Se um pacote não estiver instalado, ele é instalado usando `sudo apt install`. Caso contrário, o script informa que o pacote já está instalado.

```
pacotes=("apache2" "unzip" "wget")

echo "Instalando pacotes necessários...."

for pacote in "${pacotes[@]}"; do
    if dpkg -l | grep -q $pacote; then
        echo ""
        echo "$pacote já está instalado."
        echo ""
    else
        echo ""
        echo "$pacote não foi encontrado e precisa ser instalado."
        echo "Iniciando instalação..."
        echo ""
        sudo apt install $pacote -y
    fi
    echo ""
done
```

### 3- Baixar e Descompactar Arquivos:

O script verifica se um arquivo chamado __"main.zip"__ já existe no diretório __/tmp__. Se existir, informa que o arquivo já está lá.

Se o arquivo não existir, ele usa o comando `sudo wget` para baixar um arquivo __ZIP__ de uma __URL__ da web e salvá-lo em __/tmp__.

Em seguida, o comando `sudo unzip` é usado para descompactar o arquivo ZIP baixado no diretório __/var/www/__.

O diretório __/var/www/html__ é excluído, se existir. O diretório descompactado é então renomeado para __/var/www/html__.

```
echo "Baixando arquivos para pasta temporária..."
echo ""

if [[ -e "/tmp/main.zip" ]]; then
  echo "O arquivo main.zip já existe!"
else
  echo "Iniciando wget..."
  sudo wget -P /tmp https://github.com/denilsonbonatti/linux-site-dio/archive/refs/heads/main.zip
fi

echo ""
echo "Descompactando arquivos..."
echo ""
sudo unzip /tmp/main.zip -d /var/www/
sudo rm -rf /var/www/html
sudo mv /var/www/linux-site-dio-main/ /var/www/html
```


## Conclusão

Esse código foi concluído com sucesso e é menos desafiador do que o desafio anterior (__m2__). Para tarefas comuns, existem muitas ferramentas de __código aberto__ disponíveis na Internet, como __Ansible__ e __Jenkins__, que podem automatizar a configuração do __ambiente web__ e a __implantação de aplicativos__. Portanto, a necessidade de escrever um __script__ para isso é quase nula, __a menos que seja para um cenário muito específico__ ou para fins de laboratório, como este teste.

Agradeço pelo interesse em ler até aqui. Não se esqueça de deixar uma __estrela__ no meu __repositório__ e me seguir no __GitHub__ e nas minhas outras __redes sociais__.


## Sobre o Bootcamp
![Formação Linux Fundamentals](https://hermes.dio.me/tracks/cover/5182e012-d0f3-42b5-aec1-600b8653f498.png)

### Detalhes da formação
Aprenda a trabalhar com o principal sistema operacional utilizado em servidores de aplicações, da Instalação ao passo a passo de como gerenciar usuários para ter mais segurança, manipular arquivos de maneira segura e os principais comandos Linux que são essenciais para a sua jornada como desenvolvedor. Veja o poder do Linux de maneira prática e direcionada com os principais temas que um profissional de mercado deve saber.

__Atividades:__
- Desafio de Código: Coloque em prática todo o conhecimento adquirido nas aulas e teste o seu conhecimento na resolução de um desafio.

- Desafio de Projeto: Construa o seu portfólio construindo projetos práticos com o conhecimento adquirido ao longo das aulas.

__Ferramentas para o seu aprendizado:__
- Fórum: Espaço para você interagir e tirar suas dúvidas técnicas com a nossa comunidade.

- Rooms: Espaço para você conversar com outros matriculados no bootcamp e aumentar o seu networking.

- Matriculados: Saiba quem está participando da mesma jornada educacional que você.

- Certificado: Baixe e compartilhe os certificados de todas as suas conquistas ao longo dessa formação.


__Clique aqui e saiba mais:__
https://bit.ly/dio-me-linux-fundamentals
