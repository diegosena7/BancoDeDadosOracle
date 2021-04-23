    SELECT * From tabela_de_clientes;
    select tc.nome, tc.endereco_1 from tabela_de_clientes tc; -- Select básico
    
    -- Select com filtros cláusula where
    SELECT * from tabela_de_produtos WHERE sabor = 'Laranja';
    SELECT * FROM tabela_de_produtos WHERE preco_de_lista > 19.50;
    SELECT * FROM tabela_de_produtos WHERE sabor = 'Manga' OR tamanho = '470 ml';
    SELECT * FROM tabela_de_produtos WHERE sabor = 'Manga' AND embalagem = 'PET';
    -- Usando a negação da condição com o comando NOT
    SELECT * FROM tabela_de_produtos WHERE NOT sabor = 'Manga' AND embalagem = 'PET';
    -- Retorna resultados com sabor = Manga e tamanho não seja = 470 ml com o comando NOT
    SELECT * FROM tabela_de_produtos WHERE sabor = 'Manga' AND NOT (tamanho = '470 ml');
    
    -- O operador IN permite que você especifique vários valores em uma cláusula WHERE.
    SELECT * FROM tabela_de_produtos WHERE sabor in ('Manga', 'Laranja');
    SELECT * FROM tabela_de_clientes WHERE cidade in ('Sao Paulo','Rio de Janeiro') and idade > 20;
    
    -- O comando LIKE é usado em uma cláusula WHERE para pesquisar um padrão texto (Char/String) especificado em uma coluna.
    SELECT * from tabela_de_clientes WHERE nome like '%Carvalho%'; --Qualquer parte da palavra
    SELECT * FROM tabela_de_clientes WHERE nome like '%Silva'; -- Fim da palavra
    SELECT * FROM tabela_de_produtos where sabor like '%Maca' and embalagem = 'PET';
    SELECT * from tabela_de_clientes WHERE nome like '%Mattos%';
    SELECT * from tabela_de_clientes WHERE nome like 'Cesar%'; -- Inicio da palavra
    
    -- O comando ROWNUM serve para limitar o número de linhas de uma consulta com menor ou menor/igual
    SELECT tp.codigo_do_produto, tp.nome_do_produto FROM tabela_de_produtos tp WHERE ROWNUM <= 5;
    SELECT * FROM notas_fiscais WHERE data_venda = TO_DATE('2017-01-01','YYYY-MM-DD') and rownum <= 10;
    
    /* O comando ORDER BY retorna a consulta ordenado pelos campos determinado pelo ORDER BY, sendo que...
    o mesmo deve ser usado no fim da query, após o where.*/
    SELECT * from tabela_de_produtos ORDER BY preco_de_lista;
    SELECT * FROM tabela_de_produtos ORDER BY tamanho desc;
    select * from tabela_de_clientes ORDER BY nome;
    select * from tabela_de_vendedores ORDER BY matricula desc, data_admissao asc;
    
    /*O comando GROUP BY comando é usado para agrupar o conjunto de resultados
    (usado com funções agregadas: COUNT, MAX, MIN, SUM, AVG).*/
    select tc.estado, sum(tc.limite_de_credito) as "Soma" from tabela_de_clientes tc GROUP BY tc.estado;
    select embalagem, max(preco_de_lista) as "Maior preço" from tabela_de_produtos group by embalagem;
    select embalagem, count(*) as "Contagem" from tabela_de_produtos group by embalagem;
    select bairro, sum(limite_de_credito) as "Total Credito" from tabela_de_clientes where cidade = 'Rio de Janeiro' GROUP BY bairro;
    select estado, bairro, sum(limite_de_credito) as "Total Credito" from tabela_de_clientes GROUP BY estado, bairro order BY estado, bairro;
    SELECT quantidade, count(*) as "Contagem" from itens_notas_fiscais where codigo_do_produto = 1101035 and quantidade = 99 group by quantidade;
        
    -- Usando condições para classificar resultados, com o case podemos testar várias condições...
    select nome_do_produto, preco_de_lista,
    (case when preco_de_lista >= 12 then 'Produto Caro'
        when preco_de_lista >= 7 and preco_de_lista < 12 then 'Produto em Conta'
        else 'Produto Barato'
        end) as Status_Preco
        from tabela_de_produtos
        where sabor = 'Manga';
    
    -- Buscamos embalagem e preco de lista, condicionamos por preco
    select embalagem, preco_de_lista,
    (case when preco_de_lista >= 12 then 'Produto Caro'
        when preco_de_lista >= 7 and preco_de_lista < 12 then 'Produto em Conta'
        else 'Produto Barato'
        end) as Status_Preco,
        preco_de_lista
        from tabela_de_produtos;
    
    -- Na condição abaixo o case entra dentro da condição do group by
    -- Buscamos as embalagens, condicionamos os precos e agrupamos por embalagens
     select embalagem,
    (case when preco_de_lista >= 12 then 'Produto Caro'
        when preco_de_lista >= 7 and preco_de_lista < 12 then 'Produto em Conta'
        else 'Produto Barato'
        end) as Status_Preco,
        avg(preco_de_lista) as Preco
        from tabela_de_produtos
        group by embalagem, (case when preco_de_lista >= 12 then 'Produto Caro'
        when preco_de_lista >= 7 and preco_de_lista < 12 then 'Produto em Conta'
        else 'Produto Barato'
        end);
    -- Filtra por nome e classifica de acordo com a faixa etária por ano de nascimento
    select nome,
    (case when TO_CHAR(data_de_nascimento, 'YYYY') < 1990 then 'Velhos'
        when TO_CHAR(data_de_nascimento, 'YYYY') >= 1990 and TO_CHAR(data_de_nascimento, 'YYYY') <= 1995 then 'Jovens'
        else 'Crianças'
        end) as Classificassao
    from tabela_de_clientes c;
    
    
    /*O comando having é uma condição (filtro) que se aplica ao resultado de uma agregação com agrupamento*/ 
    -- Inserindo uma condição (having) com groupby
    select estado, sum(limite_de_credito)as Soma from tabela_de_clientes group by estado having sum(limite_de_credito) >= 900000;
    --Retorna os preços condicionados por maior e menor valor, onde os precos de lista sejam menores/igual a 80
    select embalagem, max(preco_de_lista) as MaiorPreco, min(preco_de_lista) as MenorPreco from tabela_de_produtos
    group by embalagem having sum(preco_de_lista) <= 80;
    -- Cpf do clientes que fizeram mais de 2000 compras em 2016
    select cpf, count(*) from notas_fiscais where TO_CHAR(data_venda, 'YYYY') = '2016' group by cpf HAVING count(*)  > 2000;
    
    select embalagem from tabela_de_produtos;
    -- Filtra e retira os valores em duplicidade da tabela de produtos
    select DISTINCT embalagem from tabela_de_produtos;
    -- Filta e retira os valores em duplicidade onde o sabor for igual a laranja
    select DISTINCT sabor from tabela_de_produtos where sabor = 'Laranja';
    select DISTINCT embalagem, sabor from tabela_de_produtos;
    --Limita o numero de linhas da consulta
    select ROWNUM, codigo_do_produto, nome_do_produto from tabela_de_produtos where ROWNUM <= 5;
    --Ordena por preço
    SELECT preco_de_lista, codigo_do_produto, nome_do_produto from tabela_de_produtos order by preco_de_lista;
    --Ordena por preço em ordem decrescente
    SELECT preco_de_lista, codigo_do_produto, nome_do_produto from tabela_de_produtos order by preco_de_lista desc;
    --Ordena por nome do produto
    select * from tabela_de_produtos order by nome_do_produto;
    --Retorna a consulta por ordem decrescente
    select * from tabela_de_produtos order by nome_do_produto desc;
     --Retorna a consulta por ordem crescente
    select * from tabela_de_produtos order by embalagem desc, nome_do_produto asc;
    --Retorna o total de credito
    select estado, sum(limite_de_credito) as TotalCredito from tabela_de_clientes group by estado;
    --Retorna o maior limite de credito
    select estado, max(limite_de_credito) as ValorMaximo from tabela_de_clientes group by estado;
    --Contando o numero de embalagem
    select embalagem, count(*) as NumProdutos from tabela_de_produtos group by embalagem;
    --Agrupamento por 1 coluna
    select bairro, sum(limite_de_credito) as Total from tabela_de_clientes WHERE cidade = 'Rio de Janeiro' group by bairro;
    --Agrupamento por 2 colunas
    select estado, bairro, sum(limite_de_credito) as Total from tabela_de_clientes group by estado, bairro order by estado, bairro;
    -- Filta a consulta usando como critério o valor do parâmetro agrupado por estado, onde limite_de_credito > 900000
    select estado, sum(limite_de_credito) as TotalCredito from tabela_de_clientes group by estado having sum (limite_de_credito) > 900000;
    -- Filtra os resultados por parâmetro, agrupa por estado onde a soma de preco de lista for <= 80
    select embalagem, max(preco_de_lista) as MaiorPreco, min(preco_de_lista) as MenorPreco from tabela_de_produtos 
    group by embalagem HAVING sum(preco_de_lista) <= 80;
    
    --Select usando case, retorna o status de preco de acordo com as condições
    SELECT NOME_DO_PRODUTO, PRECO_DE_LISTA, 
(CASE WHEN PRECO_DE_LISTA >= 12 THEN 'PRODUTO CARO'
    WHEN PRECO_DE_lISTA >= 7 AND PRECO_DE_LISTA < 12 THEN 'PRODUTO EM CONTA'
    ELSE 'PRODUTO BARATO'
    END
) AS STATUS_PRECO
FROM TABELA_DE_PRODUTOS 
WHERE SABOR = 'Manga';
-- Usando condicionais com agrupamento
SELECT EMBALAGEM,
(CASE WHEN PRECO_DE_LISTA >= 12 THEN 'PRODUTO CARO'
    WHEN PRECO_DE_lISTA >= 7 AND PRECO_DE_LISTA < 12 THEN 'PRODUTO EM CONTA'
    ELSE 'PRODUTO BARATO'
    END
) AS STATUS_PRECO,
AVG(PRECO_DE_LISTA) AS MEDIA_PRECO
FROM TABELA_DE_PRODUTOS
GROUP BY EMBALAGEM,
(CASE WHEN PRECO_DE_LISTA >= 12 THEN 'PRODUTO CARO'
    WHEN PRECO_DE_lISTA >= 7 AND PRECO_DE_LISTA < 12 THEN 'PRODUTO EM CONTA'
    ELSE 'PRODUTO BARATO'
    END
);

/*O comando INNER JOIN retorna o resultado de dados provenientes de duas ou mais tabelas, baseado em um relacionamento
 (colunas extistentes em ambas as tabelas) entre colunas destas tabelas*/
 --Usando inner join para verificar a quantidade de vendas e o nome dos vendedores, utilizando a matricula para acessar as tabelas
 select v.matricula, v.nome, count(*) from tabela_de_vendedores v
 inner join notas_fiscais f
 on v.matricula = f.matricula
 group by v.matricula, v.nome;
    
SELECT * FROM notas_fiscais;
SELECT * FROM itens_notas_fiscais;

/*Levando em consideração que o valor financeiro das vendas consiste em multiplicar a quantidade pelo preço,
obtenha o faturamento anual da empresa*/
select to_char(nf.data_venda, 'YYYY') as Ano, SUM(inf.quantidade * inf.preco) as FaturamentoAnual
from notas_fiscais nf inner join itens_notas_fiscais inf
on nf.numero = inf.numero
group by to_char(nf.data_venda, 'YYYY');


/*O comando LEFT JOIN, retorna todos os resultados na tabela da esquerda e os dados relacionados com a tabela
do lado direito da consulta*/
SELECT DISTINCT a.cpf as CPF_CADASTRO, a.nome, b.cpf as CPF_NOTA
FROM tabela_de_clientes a left join notas_fiscais b 
on a.cpf = b.cpf;

SELECT DISTINCT a.cpf as CPF_CADASTRO, a.nome, b.cpf as CPF_NOTA
FROM tabela_de_clientes a left join notas_fiscais b 
on a.cpf = b.cpf WHERE b.cpf is null;
-- Retorna todos os vendedores e os clientes que possuem bairro = ao cliente
select v.nome as NomeVendedor, v.bairro as BairroVendedor, c.nome as NomeCliente, c.bairro as BairroCliente
from tabela_de_vendedores v left join tabela_de_clientes c
on v.bairro = c.bairro;

/*O comando RIGHT JOIN, retorna todos os resultados na tabela da direita e os dados relacionados com a tabela
do lado esquerdo da consulta*/
SELECT DISTINCT a.cpf as CPF_CADASTRO, a.nome, b.cpf as CPF_NOTA
FROM notas_fiscais b right join tabela_de_clientes a
on a.cpf = b.cpf;

SELECT DISTINCT a.cpf as CPF_CADASTRO, a.nome, b.cpf as CPF_NOTA
FROM notas_fiscais b right join tabela_de_clientes a
on a.cpf = b.cpf WHERE b.cpf is null;
-- Retorna todos os clientes e os vendedores qye possuem bairro = ao cliente
select v.nome as NomeVendedor, v.bairro as BairroVendedor, c.nome as NomeCliente, c.bairro as BairroCliente
from tabela_de_vendedores v right join tabela_de_clientes c
on v.bairro = c.bairro;

/*Retorna todos os registros quando houver uma correspondência na tabela esquerda ou direita.
A cláusula FULL JOIN retorna todas as linhas das tabelas unidas, correspondidas ou não, ou seja,
você pode dizer que a FULL JOIN combina as funções da LEFT JOIN e da RIGHT JOIN*/

select v.nome as NomeVendedor, v.bairro as BairroVendedor, c.nome as NomeCliente, c.bairro as BairroCliente
from tabela_de_vendedores v full join tabela_de_clientes c
on v.bairro = c.bairro;

/*O comando UNION faz a união de duas ou mais tabelas, retornando todas as linhas pertencentes a todas as
queries envolvidas na execução, unindo os resultados.
OBS: É importante que as tabelas que serão unidas tenha o mesmo número e tipo de campo.
OBS: o UnionAll trás todos os campos sem distinguir a duplicidade entre eles*/
select distinct bairro from tabela_de_clientes union select distinct bairro from tabela_de_vendedores;
select distinct bairro from tabela_de_clientes union all select distinct bairro from tabela_de_vendedores;

select distinct bairro as BAIRRO, 'Cliente' as TIPO from tabela_de_clientes
union
all select distinct bairro, 'Vendedor' as TIPO  from tabela_de_vendedores;

/*Subquery é um comando SELECT que foi "embutido" noutro comando SELECT, UPDATE, DELETE ou dentro de outra subquery.
A finalidade da subquery é retornar um conjunto de linhas para a query principal*/
SELECT * FROM tabela_de_clientes WHERE bairro in
(SELECT DISTINCT bairro from tabela_de_vendedores);

SELECT z.embalagem, z.SOMAPRECO FROM
(SELECT embalagem, sum (preco_de_lista) as SOMAPRECO from tabela_de_produtos group by embalagem) z
where z.somapreco <= 80;

SELECT f.cpf, f.Contagem FROM
(SELECT CPF, COUNT(*) as Contagem FROM NOTAS_FISCAIS WHERE TO_CHAR(DATA_VENDA, 'YYYY') = '2016' GROUP BY CPF) f
WHERE f.Contagem > 2000;

/*A VIEW é uma tabela lógica, resultado de uma consulta que podemos utilizar em outras consultas
é utilizada em comandos SELECT, INSERT, UPDATE e DELETE */
select embalagem from vw_embalagens where somapreco > 20;
-- View (vw_embalagens) com inner join
select p.codigo_do_produto, p.nome_do_produto, e.somapreco as SomaEmb 
from tabela_de_produtos p INNER JOIN vw_embalagens e on p.embalagem = e.embalagem;
-- View (vw_vendedores) com inner join
select f.cpf, f.matricula, f.imposto, v.data_admissao as DataVend
from notas_fiscais f inner join vw_vendedores v on f.matricula = v.matricula;
-- View (vw_vendedores) com inner join e count
select f.cpf, f.matricula, f.imposto, v.data_admissao, count(*) from notas_fiscais f 
inner join vw_vendedores v on f.matricula <> v.matricula
group by f.cpf, f.matricula, f.imposto, v.data_admissao; 
-- View com full join
select v.nome, v.bairro, c.nome, c.bairro
from vw_vendedores v full join tabela_de_clientes c on v.bairro = c.bairro;

