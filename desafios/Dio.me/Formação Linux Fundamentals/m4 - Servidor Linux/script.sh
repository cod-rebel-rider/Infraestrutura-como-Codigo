#!/bin/bash

echo ""
echo "========================================"
echo ""

#Update
echo "Verificando atualizações..."
echo ""
sudo apt update
echo ""
echo "Verificação concluida!"

echo ""
echo "========================================"
echo ""

#Upgrade
echo "Atualizando Sistema"
echo ""
sudo apt upgrade -y
echo ""
echo "Atalização concluida!"

echo ""
echo "========================================"
echo ""

#Instalando pacotes necessários
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

#Baixando e descompactando arquivos

echo ""
echo "========================================"
echo ""
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

echo ""
echo "========================================"
echo ""