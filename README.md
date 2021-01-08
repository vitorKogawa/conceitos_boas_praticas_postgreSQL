# conceitos_boas_praticas_postgreSQL
Repositório contendo experimentações, resumose tarefas baseados no curso "Conceitos e melhores práticas com bancos de dados PostgreSQL" ministrado por Daniel Roberto Costa

Arquivo postgresql.conf

Arquivo onde estão definidas e armazenadas todas as configurações do servidor PostgreSQL.

- Alguns parâmetros só podem ser alterados com uma reinicialização do banco de dados.

- A view pg_settings, acessada por dentro do banco de dados , guarda todas as configurações atuais.



## Uma view muito importante: pg_settings

Ela vai mostra aquilo que está em execução daquele dado momento, além de mostrar todas as configurações atuais do banco de dados.

```sql
SELECT name, settings FROM pg_settings;
```

### Localização do arquivo postgresql.conf

Por padrão encontra-se dentro do diretório PGDATA definido no momneto da inicilização do cluster de banco de dados.

No sistema operacional Ubuntu, se o PostgreSQL foi instalado a partir do repositório oficial, o local do arquivo postgresql.conf será diferente do diretório de dads.

```shell
/etc/postgresql/[versão]/[nome do cluster]/postgres.conf
```



## Configurações de conexão

- **LISTEN_ADDRESS**

  Endereço(s) TCP/IP das interfaces que o servidor PostgresSQL vai escutar/liberar conexões.

- **PORT**

  A porta tcp que o servidor PostgreSQL vai ouvir, O padrão é **5432**.

- **MAX_CONNECTIONS**

  Número máximo de conexões simultâneas no servidor PostgresSQL

- **SUPERUSER_RESERVED_CONNECTIONS**

  Número de conexões(slots) reservadas para conexões ao banco de dados de super usuários.

  

## Configurações de autenticação

- **AUTHENTICATION_TIMEOUT**

  Tempo máximo em segundos para o clientes conseguir uma conexão com o servidor

- **PASSWORD_ENCRYPTION**

  Algoritmo de criptografia das senhas dos novos usuários criados no banco de dados

- **SSL**

  Habilita a conexão criptografada por SSL

  (Somente se o banco de dados for compilado com SSL)



## Configuração de memória

- **SHARED_BUFFERS**

  Tamanho da memória compartilhada do servidor PostgreSQL para cache/buffer de tabelas, índices e demais relações.

- **WORK_MEM**

  Tamanho da memória para operações de agrupamento e ordenação (ORDER BY, DISTINCT, MERGE JOINS)

- **MAINTENANCE_WORK_MEM**

  Tamanho da memória para operações como VACUUM, INDEX, ALTER TABLE.



# O arquivo pg_hba.conf

Arquivo responsável pelo controle de autenticação dos usuários no servidor PostgreSQL. 

### Métodos de autenticação

- **TRUST:** conexão sem requisição de senha
- **REJECT:** rejeita conexões
- **MD5:** criptografia md5
- **PASSWORD:** senha sem criptografia
- **GSS:** generic security service application program interface
- **SSPI:** security support provider interface = somente para windows
- **KRB5:** kerberos v5
- **IDENT:** utiliza o usuário do sistema operacional do cliente via ident server
- **PEER:** utiliza o usuário do sistema operacional do cliente
- **LDAP:** ldap server
- **RADIUS:** radius server
- **CERT:** autenticação via certificado ssl do cliente
- **PAM**: pluggable authentication modules



# o arquivo pg_ident.conf

Arquivo responsável por mapear os usuários do sistema operacional com os usuários d banco de dados.

- Localizado no diretorio de dados PGDATA de sua instalação.
- A opção ident deve ser utilizada no arquivo **pg_hba.conf**



# Comando administrativos

### Ubuntu

- `pg_lscluster` : Lista todos os clusters PostgresSQL

- `pg_createcluster <version> <cluster name>`: Cria um novo cluster PostgresSQL

- `pg_dropcluster <version> <cluster>` : Apaga um cluster PostgresSQL.

- `pg_ctlcluster <version> <cluster> <action>`: pode realizar

  - Start
  - Stop
  - Status
  - Restart

  em clusters PostgresSQL

### CentOS

- `systemctl <action> <cluster>`:
  - `systemctl start postgresql-<version>`: Inicia o cluster
  - `systemctl status postgresql-<version>`: Mostra o status do cluster
  - `systemctl stop postgresql-<version>`: Para o cluster
  - `systemctl restart postgresql-<version>`: reinicia o cluster



### Windows

Abrir o gerenciador de serviços.



## Binários do PostgresSQL

//todo: estudar as funcionalidades de cada binário

- createdb:
- createuser:
- dropdb:
- dropuser:
- initdb:
- pg_ctl: start, stop , status, restart
- pg_basebackup: realiza o backup do banco
- pg_dump / pg_dumpall: extrair em um dado formato as informações daquele momento (pseudo-backup)
- pg_restore: restaurar os arquivos
- psql:
- reindexdb:
- vacuumdb:



# Arquitetura / Hierarquia

### Cluster

Coleção de banco de dados que compartilham as mesmas configurações (arquivos de configuração) do PostgreSQL e do ssitema operacional (porta, listen_addresses, etc)

### Database

Conjunto de schemas com seus objetos / relações (tabelas, funções, views, etc)

### Schema

Conjunto de schemas com seus objetos / relações (tabelas, funções, views, etc)

# Ferramenta PGAdmin

## Importante para conexão:

1. Liberar acesso ao cluster em postgresql.conf
2. Liberar acesso ao cluster para o usuário do banco de dados em pg_hba.conf
3. Criar / editar usuários



# Users / Roles / Groups

Roles(papéis ou funões), users(usuários) e grupo de usuários são "contas", papéis de atuação em um banco de dados, que possuem permissões em comum ou específicas.

Nas versões anteriores do PostgresSQL 8.1, usuários e roles tinham comportamento diferentes.

Atualmente, oles e users são alias (a mesma coisa)

É possível que roles pertençam a outras roles;



### Criação de uma role na base de dados

`CREATE ROLE name [[WITH] option [...]]`

#### As opções podem ser as seguintes:

- `SUPERUSER | NOSUPERUSER`
- `CREATEDB` | `NOCREATEDB`
- `CREATEROLE` | `NOCREATEROLE`
- `INHERIT` | `NONINHERIT`
- `LOGIN` | `NOLOGIN`
- `REPLICATION` | `NOREPLICATION`
- `BYPASSRLS` | `NO BYPASSRLS`
- `CONNECTION LIMIT connlimit`
- `[ENCRYPTED] PASSWORD "password"` | `PASSWORD NULL`
- `VALID UNTIL "timestamp" `
- `IN ROLE role_name[, ...] `
- `IN GROUP role_name [, ...]`
- `ROLE role_name[, ...]`
- `ADMIN role_name [, ...]`
- `USER role_name [, ...]`
- `SYSID uid`

### Associação entre roles

Quando uma role assume as permissões de outra role.

:warning: É  sempre necessário a presenção da opção **INHERIT**



No momento de criação da role: 

- **IN ROLE** (passa a pertencer a role informada)
- **ROLE** (a role informada passa a pertencer a nova role)

Ou após a criação da role:

- **GRANT** [role a ser concedida] TO [role a assumir as permissões]



### Exemplos da utilização das ROLES

```sql
CREATE ROLE professores
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	NOLOGIN
	NOBYPASSRLS
	CONNECTION LIMIT 1;
	
CREATE ROLE daniel LOGIN CONNECTION LIMIT 1 PASSWORD '123' IN ROLE professores;
--Aqui a role daniel passa a assumir as permissões da role professores

CREATE ROLE daniel LOGIN CONNECTION LIMIT 1 PASSWORD '123' ROLE professor:
-- A role professores passa a fazer parte da role daniel assumindo suas permissões

CREATE ROLE daniel LOGIN CONNECTION LIMIT 1 PASSWORD '123'
GRANT professores TO daniel
```



### Desassociar membros entre roles

`REVOKE [ role que será revogada] FROM [ role que terá usas permissões revogadas]`

Exemplo: `REVOKE professores FROM  daniel`



## Alteração de role

`ALTER ROLE role_que_sera_alterada [ WITH ] option [ ... ]`

As opções de alteração são as mesmas de criação



## Excluindo uma role

`DROP ROLE nome_da_role_a_ser_excluida`

Exemplo: `DROP ROLE daniel`



## Administrando Acessos (GRANT)

Grants são privilégios de acesso aos objetos do banco de dados

### Lista de privilégios que podem ser atribuídas as roles

- `--tabela`
- `--coluna`
- `--sequence`
- `--database`
- `--domain`
- `--foreign data wrapper`
- `--foreign server`
- `--function`
- `--language`
- `--large object`
- ` --schema`
- `--tablespace`
- `--type` 

### Database

```sql
GRANT {{CREATE |  CONNECT | TEMPORARY | TEMP }[, ...] | ALL [PRIVILEGES]}
ON DATABASE database_name [, ...]
TO role_especifica [, ...] [WITH GRANT OPTION]
```

### SCHEMA

```SQL
GRANT {{CREATE | USAGE }, [, ...] | ALL[PRIVILEGES]}
ON SCHEMA  schema_name[, ...]
TO role_especifica [,  ...] [WITH GRANT OPTION]
```

### TABLE

```SQL
GRANT{{SELECT | INSERT | UPDATE | DELETE | TRUNCATE | REFERENCES | TRIGGER } [, ...] | ALL [PRIVILEGES]}
ON { [TABLE] table_name[, ...] | ALL TABLE IN SCHEMA schema_name[,  ...] } TO role_especifica[, ...] [WITH GRANT OPTION]
```

### Removendo privilégios de uma role

###  Database

```SQL
REVOKE [GRANT OPTION FOR]
{{CREATE | CONNECT | TEMPORARY | TEMP}[, ...] | ALL [PRIVILEGES]}
ON  DATABASE database_name [, ...]
FROM {[GROUP]role_especifica | PUBLIC}[,  ...]
[CASCADE | RESTRICT]
```

 

### SCHEMA

```SQL 
REVOKE [GRANT OPTION FOR]
{{CREATE | USAGE}[, ...] | ALL[PRIVILEGES]}
ON SCHEMA schema_name[, ...]
FROM {[GROUP]role_especifica | PUBLIC}[, ...]
[CASCADE | RESTRICT]
```



###  Revogando todas as permissões

`REVOKE ALL ON ALL TABLES IN SCHEMA [shema] FROM [role];`

`REVOKE ALL ON SCHEMA [shema] FROM [role]`

`REVOKE ALL ON DATABASE [database] FROM [role];`



# Objetos e comandos do banco de dados

## Database , Schemas e Objetos

**Database**

É o banco de dados, um grupo de schemas e seus objetos

**Schemas**

É  um grupo de objetos, como tabelas, types, views, funções , entre outros.

**Objetos**

São tabelas, views funções , types, sequences , entre outros pertencentes ao schemas.



## Comandos Database

`CREATE DATABASE name`

`DROP DATABASE [nome]`

## Comando Schema

`CREATE SCHEMA schema_name [AUTHORIZATION role_especifica]`

`ALTER SCHEMA name RENAME TO new_name`

`DROP SCHEMA [nome]`



:arrow_forward: **É  um boa prática implementar idempotência nas tarefas realizadas dentro da base de dados, com no esquema abaixo**

`CREATE SCHEMA IF NOT EXISTS schema_name [AUTHORIZATION role_especifica]`

`DROP SCHEMA IF EXISTS [nome]`



# Tabela colunas e tipos de dados

É  um conjunto de dados dispostos em colunas e linhas referentes a um objetivo comum.

## Primary Key

No conceitos de modelo de dados relacional e obedecendo as regras de normalização , uma PK  é um conceito de um ou mais campos que nunca se repetem em uma tabea e que seus valores farantem a integridade do dado único e a utilização do mesmo como referência para o relacionamente entre demais tabela.

- Não pode haver duas ocorrências de uma mesma entidade com o mesmo conteúdo na PK
- A chave primária não pode ser composta por atributo opcional, ou seja, atributo que aceito nulo.
- Os atributos identificadores devem ser o conjunto mínimo que pode identificar cada instância de um entidade.
- Não deve ser usadas chaves externas (depende)
- Não deve conter informação volátil



## Foreign Key

Campo, ou conjunto de campos que são referências de chaves primárias de outras tabelas ou da mesma tabela.

Sua principal função é garantir a integridade referencial entre tabelas

- Sempre referencia uma PK



## Tipos de dados

![image-20210108020355318](C:\Users\vitor\AppData\Roaming\Typora\typora-user-images\image-20210108020355318.png)



# DML e DDL

![image-20210108021108895](C:\Users\vitor\AppData\Roaming\Typora\typora-user-images\image-20210108021108895.png)

### Exemplos DML

#### INSERT

![image-20210108021502867](C:\Users\vitor\AppData\Roaming\Typora\typora-user-images\image-20210108021502867.png)

***

#### UPDATE

![image-20210108021600707](C:\Users\vitor\AppData\Roaming\Typora\typora-user-images\image-20210108021600707.png)

***

#### DELETE

![image-20210108021700577](C:\Users\vitor\AppData\Roaming\Typora\typora-user-images\image-20210108021700577.png)

***

#### SELECT

![image-20210108021749112](C:\Users\vitor\AppData\Roaming\Typora\typora-user-images\image-20210108021749112.png)





### Exemplos DDL

![image-20210108021221984](C:\Users\vitor\AppData\Roaming\Typora\typora-user-images\image-20210108021221984.png)



# Conheça o DML e o Truncate

## Idempotência

Propriedade que algumas ações / operações possuem possibilitando-as de serem executadas diversas vezes sem alterar o resultado inicial.



### Melhores práticas em DDL

Importante as tabelas possuírem campos que realmente serão utilizados e que sirvam de atributo direto a um objetivo em comum.

- Criar / Acrescentar colunas que são "atributos básico" do objeto;
- Cuidado com regras (**constraints**)
- Cuidado com o excesso de FKs
- Cuidado com o tamanho indevido de FKs



## DML - CRUD (Create, Read, Update, Delete)

## SELECT 

`SELECT (campos,) FROM tabela [condições]`

### Exemplo:

- `SELECT numero, nome FROM banco;`
- `SELECT numero, nome FROM banco WHERE ativo IS TRUE;`
- `SELECT nome FROM cliente WHERE email LIKE '%gmail.com';`



:arrow_forward: `LIKE`: Respeita case sensitive

:arrow_forward: `ILIKE`: Não respeita o case sensitive



###  SELECT  - Condição (WHERE / AND / OR)

A primeira condição sempre começa com **WHERE** ,  e as demais condições com **AND** ou **OR** .

Operador possível:

-  `=`
- `>` / `>=`
- `<` /  `<=`
-  `<>` /  `!=`
- `LIKE` /  `ILIKE`
- `IN` 



## INSERT

`INSERT (campos da tabela) VALUES (valores)` ou

`INSERT (campos da tabela) SELECT (valores)`

### INSERT - Idempotência

 `INSERT INTO agencia(banco_numero, numero, nome) VALUES (341, 1, 'VITOR KOGAWA') ON CONFLICT (banco_numero, numero) DO NOTHING `

:arrow_forward: `ON CONFLICT`: Trabalha com base nas `constraints` , no exemplo acima caso ocorra algum erro com as PK a query não vai fazer nada (`DO NOTHING`) 



## UPDATE

`UPDATE (tabela) SET campo1 = novo_valor WHERE (condição)`

:warning: Sempre utilize o `UPDATE`  com alguma condição 



## DELETE

`DELETE from tabela WHERE (condição)` 



# TRUNCATE

Esvazia sua tabela

```sql
TRUNCATE [ TABLE ] [ ONLY ] name [*][, ...]
[ RESTART IDENTITY | CONTINUE IDENTITY ] [ CASCADE | RESTRICT ]
```

- `RESTART IDENTITY` : Reseta o valor do id com relação ao valor informado.
- `CASCADE`: Apaga as referências da tabela truncada em outras também (cuidado)

# Comandos úteis

`\du`: lista todas as roles criadas

`\q`: sai do banco de dados (via terminal)

`\?`: para abrir  menu de ajuda do operador

 