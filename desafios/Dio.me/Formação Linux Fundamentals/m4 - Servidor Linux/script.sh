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

