#!/bin/bash

#Exclusão Inicial

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

# Criar Diretórios

#1º Diretório
if [[ -d "/home/adm" ]]; then
  echo "O diretório /home/adm existe."
else
  echo "O diretório /home/adm não existe."
  echo "Criando diretório... "
  result=$(mkdir -m 770 /home/adm 2>&1)
    if [ $? -eq 0 ]; then
      echo "Diretório /adm foi criado com sucesso."
    else
      echo "Falha ao criar /adm: $result "
    fi
fi

#2º Diretório
if [[ -d "/home/ven" ]]; then
  echo "O diretório /home/ven existe."
else
  echo "O diretório /home/ven não existe."
  echo "Criando diretório... "
  result=$(mkdir -m 770 /home/ven 2>&1)
    if [ $? -eq 0 ]; then
      echo "Diretório /ven foi criado com sucesso."
    else
      echo "Falha ao criar /ven: $result "
    fi
fi

#3º Diretório
if [[ -d "/home/sec" ]]; then
  echo "O diretório /home/sec existe."
else
  echo "O diretório /home/sec não existe."
  echo "Criando diretório... "
  result=$(mkdir -m 770 /home/sec 2>&1)
    if [ $? -eq 0 ]; then
      echo "Diretório /sec foi criado com sucesso."
    else
      echo "Falha ao criar /sec: $result "
    fi
fi

#4º Diretório
if [[ -d "/home/publico" ]]; then
  echo "O diretório /home/publico existe."
else
  echo "O diretório /home/publico não existe."
  echo "Criando diretório... "
  result=$(mkdir -m 707 /home/publico 2>&1)
    if [ $? -eq 0 ]; then
      echo "Diretório /publico foi criado com sucesso."
    else
      echo "Falha ao criar /publico: $result "
    fi
fi

# Criar grupos

#1º Grupo
if getent group GRP_ADM >/dev/null 2>&1; then
    echo "O grupo GRP_ADM existe."
else
    echo "O grupo GRP_ADM não existe. "
    echo "Criando novo grupo..."
    result=$(groupadd GRP_ADM 2>&1)
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
    result=$(groupadd GRP_VEN 2>&1)
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
    result=$(groupadd GRP_SEC 2>&1)
    if [ $? -eq 0 ]; then
      echo "Grupo GRP_SEC foi criado com sucesso."
    else
      echo "Falha ao criar GRP_SEC: $result "
    fi
fi

#Criação de usuários

adm_users=("carlos" "maria" "joao")
ven_users=("debora" "sebastiana" "roberto")
sec_users=("josefina" "amanda" "rogerio")

#Adm
for adm_user in "${adm_users[@]}"; do
  echo "Preparando para criar usuário $adm_user..."
  result=$(useradd $adm_user 2>&1)
    if [ $? -eq 0 ]; then
      echo "Usuário  $adm_user foi criado com sucesso."
    else
      echo "Falha ao criar $adm_user: $result "
    fi
  echo "Configurando permissões..." 
  result=$(usermod -aG GRP_ADM $adm_user 2>&1)
    if [ $? -eq 0 ]; then
      echo "Usuário foi adicionado ao grupo GRP_ADM com sucesso e as devidas permissões foram concedidas! "
    else
      echo "Falha ao adicionar $adm_user: $result "
    fi
done

#Ven
for ven_user in "${ven_users[@]}"; do
  echo "Preparando para criar usuário $ven_user..."
  result=$(useradd $ven_user 2>&1)
    if [ $? -eq 0 ]; then
      echo "Usuário  $ven_user foi criado com sucesso."
    else
      echo "Falha ao criar $ven_user: $result "
    fi
  echo "Configurando permissões..."
  result=$(usermod -aG GRP_VEN $ven_user 2>&1)
    if [ $? -eq 0 ]; then
      echo "Usuário foi adicionado ao grupo GRP_VEN com sucesso e as devidas permissões foram concedidas! "
    else
      echo "Falha ao adicionar $ven_user: $result "
    fi
done

#Sec
for sec_user in "${sec_users[@]}"; do
  echo "Preparando para criar usuário $sec_user..."
  result=$(useradd $sec_user 2>&1)
    if [ $? -eq 0 ]; then
      echo "Usuário  $sec_user foi criado com sucesso."
    else
      echo "Falha ao criar $sec_user: $result "
    fi
  echo "Configurando permissões..."
  result=$(usermod -aG GRP_SEC $sec_user 2>&1)
    if [ $? -eq 0 ]; then
      echo "Usuário foi adicionado ao grupo GRP_SEC com sucesso e as devidas permissões foram concedidas! "
    else
      echo "Falha ao adicionar $sec_user: $result "
    fi
done

#definir senha padrão para testes dos usuários
sudo chpasswd < /home/matheus/senhas.txt
