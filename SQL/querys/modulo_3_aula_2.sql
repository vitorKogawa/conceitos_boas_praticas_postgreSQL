--AVG
	select avg(valor) from cliente_transacoes;
	
-- COUNT (HAVING)
	select count(numero), email
	from cliente
	where email like '%gmail.com'
	group by email;

	select count(id), tipo_transacao_id
	from cliente_transacoes
	group by tipo_transacao_id
	having count(id) > 150;
	
--MAX
	select max(numero) from cliente;
	select max(valor), tipo_transacao_id
	from cliente_transacoes
	group by tipo_transacao_id;
	
--MIN
	select min(numero) from cliente;
	select min(valor), tipo_transacao_id
	from cliente_transacoes
	group by tipo_transacao_id;
	
--SUM
	select sum(valor), tipo_transacao_id
	from cliente_transacoes
	group by tipo_transacao_id
	order by tipo_transacao_id desc





