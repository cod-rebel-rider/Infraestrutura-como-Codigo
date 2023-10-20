#!/bin/bash
contador=0
#Vamos começar limpando os grupos, usuários e diretórios do servidor

echo "=================Verificando Grupos==================="
for group in $(awk -F: '{if ($3 >= 1000) print $1}' /etc/group); do
  if [ "$group" != "root" ]; then
  contador+=1
    echo "Grupos $group encontrado! "
#    groupdel "$group"
  fi
  if [ "$contador" = 0]; then
    echo "Com base nos parametros informados não foram encontrados usuários disponiveis para exclusão! "
  fi

done
contador=0
echo "================Verificando Usuários===================="

for user in $(awk -F: '{if ($3 >= 1000) print $1}' /etc/passwd); do
#Meu acesso ao servidor é via SSH usando o usuário matheus
#A ideia é não mexer com o usuário root tão pouco com o usuário matheus

  if [ "$user" != "root" ] && [ "$user" != "matheus" ]; then 
    contador+=1
    echo "Usuário $user encontrado! "
#    userdel -r "$user"
#    result=$(userdel -r "$user" 2>&1)
#    if [ $? -eq 0 ]; then
#      echo "Usuário $user foi excluído com sucesso."
#    else
#      echo "Falha ao excluir o usuário $user: $result"
  fi

  if [ "$contador" = 0]; then
    echo "Com base nos parametros informados não foram encontrados usuários disponiveis para exclusão! "
  fi

done

contador=0
echo "===============Verificando Diretorios====================="

for dir in /home/*; do
#Aqui a mesma coisa do usuário, o script ta sendo carregado na home do usuário matheus
#e por isso não pode ser excluido
  if [ "$dir" != "/home/root" ] && [ "$dir" != "/home/matheus" ]; then
    contador+=1
    echo "Diretório $dir encontrado! "
#    rm -rf "$dir""
  fi

  if [ "$contador" = 0]; then
    echo "Com base nos parametros informados não foram encontrados diretórios disponiveis para exclusão! "
  fi

done
