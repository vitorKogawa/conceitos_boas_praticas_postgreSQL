create table if not exists banco(
	numero integer not null,
	nome varchar(50) not null,
	ativo boolean not null default true,
	data_criacao timestamp not null default current_timestamp,
	primary key (numero)
);

create table if not exists agencia(
	banco_numero integer not null,
	numero integer not null,
	nome varchar(80) not null,
	ativo boolean not null default true,
	data_criacao timestamp not null default current_timestamp,
	primary key (banco_numero, numero),
	foreign key (banco_numero) references banco (numero)
);

create table if not exists cliente(
	numero bigserial primary key,
	nome varchar(120) not null,
	email varchar(250) not null,
	ativo boolean not null default true,
	data_criacao timestamp not null default current_timestamp
); 

create table if not exists conta_corrente(
	banco_numero integer not null,
	agencia_numero integer not null,
	numero bigint not null,
	digito smallint not null,
	cliente_numero bigint not null,
	ativo boolean not null default true,
	data_criacao timestamp not null default current_timestamp,
	primary key (banco_numero, agencia_numero, numero, digito, cliente_numero),
	foreign key (banco_numero, agencia_numero) references agencia (banco_numero, numero),
	foreign key (cliente_numero) references cliente(numero)
);

create table if not exists tipo_transacao(
	id smallserial primary key,
	nome varchar(50) not null,
	ativo boolean not null default true,
	data_criacao timestamp not null default current_timestamp
);

create table if not exists cliente_transacoes(
	id bigserial primary key,
	banco_numero integer not null,
	agencia_numero integer not null,
	conta_corrente_numero bigint not null,
	conta_corrente_digito smallint not null,
	cliente_numero bigint not null,
	tipo_transacao_id smallint not null,
	valor numeric(15,2) not null,
	data_criacao timestamp not null default current_timestamp,
	foreign key (banco_numero, agencia_numero, conta_corrente_numero, conta_corrente_digito, cliente_numero) references conta_corrente(banco_numero, agencia_numero, numero, digito, cliente_numero)
);

