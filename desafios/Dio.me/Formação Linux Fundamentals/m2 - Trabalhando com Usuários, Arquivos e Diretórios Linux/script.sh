#!/bin/bash

#Exclusão

#contador vai servir para contar o resultados positivos nas condicionais
#em seguida vou usar ele para realizar o tratamento, se o contador for igual a 0 significa que não foi encontrado resultados com base nos parametros informados.
#contador deve sempre começar com zero
contador=0
echo -e " ================= Verificando Usuários ================= \n"

for user in $(awk -F: '{if ($3 >= 1000) print $1}' /etc/passwd); do
#Meu acesso ao servidor é via SSH usando o usuário matheus
#A ideia é não mexer com o usuário root tão pouco com o usuário matheus

  if [ "$user" != "root" ] && [ "$user" != "matheus" ] && [ "$user" != "nobody" ]; then 
    contador+=1
    echo "Usuário $user encontrado! "
    result=$(userdel -r "$user" 2>&1)
    if [ $? -eq 0 ]; then
      echo "Usuário $user foi excluído com sucesso. "
    else
      echo "Falha ao excluir o usuário $user: $result "
    fi
  fi
done

if [ "$contador" = 0 ]; then
    echo -e "\n Com base nos parametros informados não foram encontrados usuários disponiveis para exclusão! "
fi

echo -e "\n"

contador=0
echo -e " ================= Verificando Grupos ================= \n"

for group in $(awk -F: '{if ($3 >= 1000) print $1}' /etc/group); do
  if [ "$group" != "root" ] && [ "$group" != "matheus" ] && [ "$group" != "nogroup" ]; then
  #fazendo incremento de 1 para cada vez que 
  contador+=1
    echo -e "Grupo $group encontrado! "
    result=$(groupdel "$group" 2>&1)
    if [ $? -eq 0 ]; then
      echo "Grupo $group foi excluído com sucesso."
    else
      echo "Falha ao excluir o grupo $group: $result "
    fi
  fi
done

if [ "$contador" = 0 ]; then
    echo -e "\nCom base nos parametros informados não foram encontrados grupos disponiveis para exclusão! "
fi

echo -e "\n"

contador=0
echo -e " ================= Verificando Diretorios =================\n "
for dir in /home/*; do
#Aqui a mesma coisa do usuário, o script ta sendo carregado na home do usuário matheus
#e por isso não pode ser excluido
 if [ "$dir" != "/home/root" ] && [ "$dir" != "/home/matheus" ]; then
    contador+=1
    echo "Diretório $dir encontrado! "
    result=$(rm -rf "$dir" 2>&1)
    if [ $? -eq 0 ]; then
      echo "Diretório $dir foi excluído com sucesso."
    else
      echo "Falha ao excluir o Diretório $dir: $result "
    fi
  fi
done

if [ "$contador" = 0 ]; then
    echo -e "\n Com base nos parametros informados não foram encontrados diretórios disponiveis para exclusão! "
fi

echo -e "\n"

#Criação

# Criar grupos

#1º Grupo
if getent group GRP_ADM >/dev/null 2>&1; then
    echo "O grupo GRP_ADM existe."
else
    echo "O grupo GRP_ADM não existe. "
    echo "Criando novo grupo..."
    result=$(sudo groupadd GRP_ADM 2>&1)
    if [ $? -eq 0 ]; then
      echo "Grupo GRP_ADM foi criado com sucesso."
    else
      echo "Falha ao criar GRP_ADM: $result "
    fi
fi

#2º Grupo
if getent group GRP_VEN >/dev/null 2>&1; then
    echo "O grupo GRP_VEN existe."
else
    echo "O grupo GRP_VEN não existe. "
    echo "Criando novo grupo..."
    result=$(sudo groupadd GRP_VEN 2>&1)
    if [ $? -eq 0 ]; then
      echo "Grupo GRP_VEN foi criado com sucesso."
    else
      echo "Falha ao criar GRP_VEN: $result "
    fi
fi

#3º Grupo
if getent group GRP_SEC >/dev/null 2>&1; then
    echo "O grupo GRP_SEC existe."
else
    echo "O grupo GRP_SEC não existe. "
    echo "Criando novo grupo..."
    result=$(sudo groupadd GRP_SEC 2>&1)
    if [ $? -eq 0 ]; then
      echo "Grupo GRP_SEC foi criado com sucesso."
    else
      echo "Falha ao criar GRP_SEC: $result "
    fi
fi

