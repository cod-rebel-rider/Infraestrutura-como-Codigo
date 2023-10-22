# Script de Criação de Estrutura de Usuários, Diretórios e Permissões

## O que o Script deve fazer?

* Excluir diretórios, arquivos, grupos e usuários criados anteriormente;
* Criar Grupos de Usuários;
* Criar Usuários
* Adicionar Usuários em grupos especificos;
* Criar Diretórios
* Condigurar as permissões dos usuários e dos grupos em cada diretório.

## Requisitos 

* Todo provisionamento deve ser feito em um arquivo do tipo Bash Script;
* O dono de todos os diretórios criados será o usuário root;
* Todos os usuários terão permissão total dentro do diretório publico;
* Os usuários de cada grupo terão permissão total dentro de seu respectivo diretório;
* Os usuários não poderão ter permissão de leitura, escrita e execução em diretórios de departamentos que eles não pertencem;

## Estrutura Final

| Diretórios  | Grupos      | Usuários                     |
|-------------|-------------|------------------------------|
| /publico    | n/a         | Todos                        |
| /adm        | GRP_ADM     | carlos, maria e joao         |
| /ven        | GRP_VEN     | debora, sebastiana e roberto |
| /sec        | GRP_SEC     | josefina, amanda e rogerio   |

## Explicando Meu Código

Meu script foi testado em uma máquina virtual __Debian__. A máquina virtual já possuía um usuário padrão com certos privilégios, então adaptei o código para não afetar essa estrutura. Qualquer outra coisa no sistema foi removida e uma nova estrutura foi criada, conforme descrito neste desafio.

### 1- Exclusão incial

Nas três fases de exclusão, utilizei um loop __for__ para repetir a exclusão de todos os itens em uma lista.

Nas duas primeiras fases (grupos e usuários), usei o comando __awk__ para analisar o arquivo __/etc/passwd__. A parte __'{if ($3 >= 1000) print $1}'__ extrai os nomes de usuário __(campo 1)__ das linhas em que o __ID__ do usuário __(campo 3)__ seja maior ou igual a __1000__. Isso evita a exclusão de usuários de sistema, como __"root"__, que geralmente têm IDs menores que 1000.

Para garantir que o usuário root ou o usuário matheus (usado para acessar via SSH) não fossem afetados, usei uma instrução __if__ para garantir que o comando de exclusão só fosse executado em usuários diferentes dos mencionados.

Usei o comando __userdel -r__ para excluir o usuário e __groupdel__ para excluir o grupo. O __"-r"__ indica que o diretório home do usuário deve ser removido junto com o usuário. A saída dos comandos é armazenada na variável __result__ para verificação posterior.

Para manter o controle do processo, adicionei um __contador__ que é __incrementado__ toda vez que a condição do __if__ é verdadeira. No final do código, é verificado se o contador é igual a zero. Se for igual a zero, significa que o __if__ responsável pela exclusão do grupo ou usuário não foi acionado nenhuma vez, o que indica que nenhum usuário ou grupo estava disponível para exclusão.

__O código final é o seguinte:__
```
for user in $(awk -F: '{if ($3 >= 1000) print $1}' /etc/passwd); do

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
```
__Observação:__ Durante os testes, para evitar a exclusão acidental de alguns usuários ou grupos do sistema, eles foram adicionados às condicionais como solução __temporária__.

Para a terceira fase, que envolve a exclusão de diretórios, a estrutura é mais simples. Usei um loop para percorrer todos os diretórios localizados em __/home__. As verificações antes da exclusão seguem os mesmos princípios das fases anteriores.

Utilizei o comando __rm -rf__ para excluir o diretório encontrado. O __rm é__ um comando para remover arquivos e diretórios, o __-r__ indica que a exclusão deve ser recursiva (para remover diretórios e seu conteúdo) e o __-f__ força a exclusão sem solicitar confirmação. A saída do comando também é armazenada na variável __result__ para verificação.

__A estrutura final é a seguinte:__
```
for dir in /home/*; do

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
```
### 2- Criação dos Diretórios

Para facilitar, optei por verificar se os diretórios que vou criar já existem ou não. Usei um bloco __if__ para verificar se o diretório __/home/publico__ existe, com a flag __-d__ para verificar se o caminho especificado é de um diretório. Se o diretório existir, o script exibirá a mensagem "O diretório existe". Se não existir, o script entrará na cláusula __else__, indicando que o diretório não existe e precisa ser criado.

Em seguida, usei o comando __mkdir__ para criar o diretório. O __-m__ seguido por três números define as __permissões__ do diretório.

__As permissões foram definidas como:__
| Diretórios  | -m  | Descrição                                                               |
|-------------|-----|-------------------------------------------------------------------------|
| /publico    | 707 | Proprietários e usuários têm permissões de leitura, gravação e execução |
| /adm        | 770 | Proprietário e grupo têm permissões de leitura, gravação e execução     |
| /ven        | 770 | Proprietário e grupo têm permissões de leitura, gravação e execução     |
| /sec        | 770 | Proprietário e grupo têm permissões de leitura, gravação e execução     |

A saída do comando também é armazenada na variável __result__ para verificação.

__O código final é o seguinte:__
```
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
```

### 3- Criação dos Grupos

Utilizei o comando __getent__ para obter informações sobre grupos. A parte __>/dev/null 2>&1__ redireciona as saídas deste comando para a __"nulidade"__, ou seja, suprime a exibição de qualquer saída na tela. Se a saída do comando for positiva, significa que o grupo já existe; caso contrário, ele seguirá para a criação do grupo.

O comando __groupadd__ é usado para criar o grupo. Assim como nas situações anteriores, a saída deste comando é armazenada na variável __result__ para tratamento posterior.

Após a criação do grupo, usei o comando __chown__ para vincular o grupo recém-criado ao seu diretório. O script verifica se a vinculação do grupo ao diretório foi bem-sucedida, verificando o código de saída do comando. Se a vinculação for bem-sucedida, o script exibe a mensagem "Grupo foi vinculado ao diretório com sucesso."

__O código final é o seguinte:__
```
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
  result=$(chown :GRP_ADM /home/adm 2>&1)
  if [ $? -eq 0 ]; then
    echo "Grupo GRP_ADM foi vinculado ao diretório /adm com sucesso."
  else
    echo "Falha ao vincular GRP_ADM a um diretório: $result "
  fi
fi
```

### 4- Criação dos Usuários

Como havia uma quantidade __"alta"__ de usuários e grupos, para evitar a repetição da mesma estrutura nove vezes, optei por criar três __arrays__ para conter os nomes dos __usuários__ em seus respectivos __grupos__: __adm_users, ven_users e sec_users__.

Em seguida, criei loops __for__ para percorrer os nomes de usuários em cada grupo e executar comandos para sua criação. Utilizei o __useradd__ para criar um usuário.

Se o usuário for criado com sucesso, uma mensagem informa que o usuário foi criado com sucesso. Caso contrário, uma mensagem de falha é exibida, incluindo os detalhes do erro contidos em __result__. Para adicionar o usuário recém-criado a um grupo, usei o __usermod -aG__.

__O código final é o seguinte:__
```
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
```

### 5- Extra

Para facilitar, criei um __arquivo__ com usuários e senhas, onde um comando lê e configura a senha para o respectivo usuário. O objetivo disso é apenas permitir o login nos usuários e testar se as permissões foram definidas com sucesso.

O arquivo __senhas.txt__ contém os pares usuário-senha:
```
carlos:adm123
maria:adm123
joao:adm123
debora:ven123
sebastiana:ven123
roberto:ven123
josefina:sec123
amanda:sec123
rogerio:sec123
```

__O comando para configurar as senhas é o seguinte:__
```
sudo chpasswd < /home/matheus/senhas.txt
```

## Conclusão

Este é meu primeiro script de __Infraestrutura como Código (IaC)__. Durante a revisão, percebi que existem muitas melhorias que posso fazer para otimizá-lo. Agradeço pelo interesse em ler até aqui. Não se esqueça de deixar uma __estrela__ no meu __repositório__ e me seguir no __GitHub__ e nas minhas outras __redes sociais__.

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
