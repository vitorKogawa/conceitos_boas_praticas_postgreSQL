CREATE OR REPLACE FUNCTION fc_somar(num1 INTEGER, num2 INTEGER)
RETURNS INTEGER
SECURITY DEFINER
CALLED ON NULL INPUT
LANGUAGE SQL
AS $$ 
	SELECT num1 + num2
$$;

select fc_somar(230, null);

create or replace function banco_add(p_numero integer, p_nome varchar, p_ativo boolean)
returns integer
security invoker
language plpgsql
called on null input
as $$
declare variavel_id integer;
begin
	if p_nome is null or p_ativo is null or p_numero is null then
		return 0;
	end if;
	
	select into variavel_id numero
	from banco
	where numero = p_numero;
	
	if variavel_id is null then
		insert into banco(numero, nome , ativo)
		values (p_numero, p_nome, p_ativo);
	else
		return variavel_id;
	end if;
	
	select into variavel_id numero
	from banco
	where numero = p_numero;
	
	return variavel_id;
end; $$;

select banco_add(5433, 'banco novo 2', true);








