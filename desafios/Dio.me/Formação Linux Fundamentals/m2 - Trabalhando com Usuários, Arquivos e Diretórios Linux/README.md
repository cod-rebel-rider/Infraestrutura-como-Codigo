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

Meu script foi testando em uma maquina virtual usando Debian. Essa maquina já possui um usuário padrão com certos privilégios, então pricisei adaptar meu código para que ele não veizesse alterações no nessa extrutura, mas qualquer outra coisa ele iria remover e contriur a nova extrutura conforme orientado na descrição desse desafio.

### 1- Exclusão incial

Nas 3 fases dessa exclusão fiz o uso de um for para ter um laço de repetição que pudesse executar a exclusão de todos os itens de uma "lista".

Nas 2 priemiras fases (grupos e usuários) fiz o uso do comando awk para analisar o arquivo /etc/passwd. A parte '{if ($3 >= 1000) print $1}' extrai os nomes de usuário (campo 1) de linhas em que o ID do usuário (campo 3) seja maior ou igual a 1000. Isso é feito para evitar a exclusão dos usuários de sistema, como "root", que geralmente têm IDs menores que 1000.

Para ter certeza que o usuário root ou usuário matheus (usuário que uso para fazer acesso via ssh) iriam ser afetados, usei um if para garantir que o comando de exclusão só iria executar em usuários diferentes dos mencionados.

Usei o comando userdel -r para excluir o usuário e groupdel para excluir o grupo. O -r indica que o diretório home do usuário deve ser removido juntamente com o usuário. A saída dos comandos é armazenada na variável result para ser verificada em seguida.

Procurando ter o controle de tudo que esta acontecendo foi pensado em uma verificação para garantir que a exclusão foi bem-sucedida, verificando o código de saída do comando com if [ $? -eq 0 ], onde qualquer código diferente de zero significa o comadno anterior terminou com erro.

Dentro do if foi adicionado um contador que faz um autoincremento toda vez que a condição do if for verdadeira. No final do código ele verifica se essa contador é igual a zero, se verdadeira significa que o IF responsável por iniciar a exclusão do grupo ou usuário não aconteseu nenhuma vez, logo ele não encontrou nenhum usuário ou grupo disponivel para ser excluido.

No final o código ficou assim:
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
Essa é a estrura para exclusão de usuários e grupos.

Obs.: Durante os testes apenas para que o script.sh retorna-se o os objetos encontrados pelo awk, alguns usuários/grupos do sistema continuaram aparecendo, então foram adicionados nas condicionais como solução temporária.

Para a 3 fase, exclusão dos diretórios a estrutura foi mais simples.

Usei um loop para percorrer todos os diretórios localizados em /home.

As verificações antes de iniciar a exclusão seguem as mesmas das fases anteriores.

Usei o rm -rf para excluir o diretório encontrado. O rm é um comando para remover arquivos e diretórios, o -r indica que a exclusão deve ser recursiva (para remover diretórios e seu conteúdo) e o -f força a exclusão sem solicitar confirmação.

A saída do comando também é armazenada na variável result para que seja verificado se o comando foi concluido com sucesso.

O contador de execuções esta presente nas 3 fases e o objetivo é o mesmo, indicar no final se foram encontrados objetos para serem excluidos.

O Código da 3ª fase ficou assim: 
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
Pode ser redundante, mas optei por faz uma verificação se os diretórios que vou criar existem ou não.

Usei IF para verificar se o diretório /home/adm existe. A flag -d é para verificar se o caminho especificado a seguir é de um diretório.

Se o diretório existir, o script exibirá a mensagem "O diretório existe."

Se o diretório não existir, o script entrará na cláusula else. Isso significa que o diretório não existe e precisa ser criado.

Em seguida, é usado o comando mkdir. O -m seguido por 3 numeros define as permissões do diretório.

As permissões para o diretório ficaram definidas desse jeito:

| Diretórios  | -m  | Descrição                                                               |
|-------------|-----|-------------------------------------------------------------------------|
| /publico    | 707 | Proprietários e usuários têm permissões de leitura, gravação e execução |
| /adm        | 770 | Proprietário e grupo têm permissões de leitura, gravação e execução     |
| /ven        | 770 | Proprietário e grupo têm permissões de leitura, gravação e execução     |
| /sec        | 770 | Proprietário e grupo têm permissões de leitura, gravação e execução     |


A saída do comando também é armazenada na variável result para que seja verificado se o comando foi concluido com sucesso.

### 3- Exclusão incial

### 4- Exclusão incial

### 5- Exclusão incial



## Sobre o Bootcamp
![Formação Linux Fundamentals](https://hermes.dio.me/tracks/cover/5182e012-d0f3-42b5-aec1-600b8653f498.png)

### Detalhes da formação
Aprenda a trabalhar com o principal sistema operacional utilizado em servidores de aplicações, da Instalação ao passo a passo de como gerenciar usuários para ter mais segurança, manipular arquivos de maneira segura e os principais comandos Linux que são essenciais para a sua jornada como desenvolvedor. Veja o poder do Linux de maneira prática e direcionada com os principais temas que um profissional de mercado deve saber.

Atividades:
- Desafio de Código: Coloque em prática todo o conhecimento adquirido nas aulas e teste o seu conhecimento na resolução de um desafio.

- Desafio de Projeto: Construa o seu portfólio construindo projetos práticos com o conhecimento adquirido ao longo das aulas.

Ferramentas para o seu aprendizado:
- Fórum: Espaço para você interagir e tirar suas dúvidas técnicas com a nossa comunidade.

- Rooms: Espaço para você conversar com outros matriculados no bootcamp e aumentar o seu networking.

- Matriculados: Saiba quem está participando da mesma jornada educacional que você.

- Certificado: Baixe e compartilhe os certificados de todas as suas conquistas ao longo dessa formação.


Clique aqui e saiba mais:
https://bit.ly/dio-me-linux-fundamentals
