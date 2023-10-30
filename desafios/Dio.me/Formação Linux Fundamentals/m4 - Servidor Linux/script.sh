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