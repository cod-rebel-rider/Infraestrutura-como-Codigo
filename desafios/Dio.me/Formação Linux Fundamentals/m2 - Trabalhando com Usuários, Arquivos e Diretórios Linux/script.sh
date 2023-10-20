#!/bin/bash

#contador vai servir para contar o resultados positivos nas condicionais
#em seguida vou usar ele para realizar o tratamento, se o contador for igual a 0 significa que não foi encontrado resultados com base nos parametros informados.
#contador deve sempre começar com zero
contador=0

echo "=================Verificando Grupos==================="
for group in $(awk -F: '{if ($3 >= 1000) print $1}' /etc/group); do
  if [ "$group" != "root" ] && [ "$group" != "matheus" ]; then
  #fazendo incremento de 1 para cada vez que 
  contador+=1
    echo "Grupos $group encontrado! "
#    groupdel "$group"
  fi
done

if [ "$contador" = 0 ]; then
    echo "Com base nos parametros informados não foram encontrados usuários disponiveis para exclusão! "
fi

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
done

if [ "$contador" = 0 ]; then
    echo "Com base nos parametros informados não foram encontrados usuários disponiveis para exclusão! "
fi

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
done

if [ "$contador" = 0 ]; then
    echo "Com base nos parametros informados não foram encontrados diretórios disponiveis para exclusão! "
fi