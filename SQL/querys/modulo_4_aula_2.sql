select numero, nome, ativo from banco order by numero;
update banco set ativo = false where numero = 0;

begin;
	update banco set ativo = true where numero = 0;
	select numero, nome, ativo from banco where numero = 0;
rollback;

begin;
	update banco set ativo = true where numero = 0;
	select numero, nome, ativo from banco where numero = 0;
commit;

select column_name, data_type from information_schema.columns where table_name = 'cliente';

select numero, nome, email from cliente;

begin;
	update cliente set nome = 'vitor roberto kogawa de moraes', email = 'vitor.kogawa.roberto33@gmail.com' where numero = 1;
rollback;