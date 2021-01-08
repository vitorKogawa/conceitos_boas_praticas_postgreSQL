select numero, nome from banco;
select banco_numero, numero, nome from agencia;
select numero, nome, email from cliente;
select banco_numero, agencia_numero, cliente_numero from cliente_transacoes;

select column_name, data_type from information_schema.columns where table_name = 'banco';