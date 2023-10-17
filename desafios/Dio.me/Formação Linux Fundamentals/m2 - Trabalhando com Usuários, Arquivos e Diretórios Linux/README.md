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
