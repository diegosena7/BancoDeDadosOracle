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

--Funções de Strings
select nome, UPPER(nome) from tabela_de_clientes;-- Transforma em maiúscula
select nome, LOWER(nome) from tabela_de_clientes;-- Transforma em minúscula
select nome_do_produto, initcap(nome_do_produto) from tabela_de_produtos;-- Transforma a ŕimeira letra da palavra com letra maiúscula
select CONCAT(endereco_1, bairro) from tabela_de_clientes;-- Concatena strings
-- Concatenação com pipes para juntar os dados da tabela
select nome, 'Endereço: ' || endereco_1 || ' ' || bairro || ' ' || cidade ||  ' ' || estado || ', CEP: ' || cep as Endereço from tabela_de_clientes;
--Substr recorta a string receb como parâmetro o indice da letra a ser recortada
select nome_do_produto, SUBSTR(nome_do_produto, 3, 8) from tabela_de_produtos;
--Instr informa a posição do arâmetro informado
select nome_do_produto, INSTR(nome_do_produto, 'a') from tabela_de_produtos;
--Replace serve para substituir caracter ou palavras 
select nome_do_produto, replace(nome_do_produto, 'Litro', 'L') from tabela_de_produtos;

-- Trabalhando com Datas
/*O Oracle armazena as datas num formato nnumérico com 7 bytes na seguinte ordem: Ano, Mês, Dia, Horas, Minutos e Segundos
A parte inteira do número corresponde a ano+mes+dia e a parte decimal corresponde a horas+minutos+segundos
Podemos utilizar a função TO_CHAR() para alterar o formato de saída em string de acorodo com a fornatação inserida na função.
Funções mais usadas: Months_Between, Add_Months, Next_Day, Last_Day, Trunc, Round.*/
select sysdate from dual;
select to_char(sysdate, 'DD MM YYYY HH:MM:SS') from dual;
select sysdate + 5 from dual;-- adiciona 5 dias a data atual
select sysdate - 5 from dual;-- diminui 5 dias da data atual
select MONTHS_BETWEEN(SYSDATE, TO_DATE('2021/01/01', 'YYYY/MM/DD')) from dual;--retorna a qtidade de meses entre sysdate e o parâmetro (2021/01/01)
select add_months(sysdate, 5) from dual;--adiciona meses ao sysdate
select NEXT_DAY(SYSDATE, 'QUINTA') from dual;--retorna a próxima quinta feira do mês
select LAST_DAY(SYSDATE) from dual;--retorna o último dia do mês
select trunc(sysdate, 'MONTH') from dual;--retorna o primeiro dia do mês (o parâmetro mês pode ser ano ou dia)

--Retorne a idade dos clientes
select c.nome, MONTHS_BETWEEN(SYSDATE, c.data_de_nascimento)/12 as Idade_Clientes from tabela_de_clientes c;

--Funções Matemárticas
select ROUND(3.4) from dual;
select ROUND(3.5) from dual;
--A função TRUNC vai arredondar para baixo o valor do parâmetro.
select trunc(3.4) from dual;
select trunc(3.8) from dual;
--A função CEIL é usada para arredondar um número para o número inteiro seguinte.
select ceil(3.4) from dual;
select ceil(3.8) from dual;
--A função FLOOR la vai retornar sempre o número arredondado para baixo.
select FLOOR(3.4) from dual;
select FLOOR(3.8) from dual;
--A função POWER retorna a potência indicada pelo segundo parâmetro.
select POWER(10, 2) from dual;
select POWER(10, 4) from dual;
--A função SQRT serve para selecionarmos valores e automaticamente obter sua raiz quadrada.
select SQRT(9) from dual;
select SQRT(25) from dual;
--A função ABS retorna o valor absoluto do parâmetro
select ABS(25) from dual;
select ABS(-25) from dual;
--A função MOD retorna o resto da divisão do parâmetro
select MOD(10, 6) from dual;
select MOD(10, 5) from dual;
--Calcule o valor do imposto pago no ano de 2016, arredondando para o menor inteiro.
SELECT TO_CHAR(DATA_VENDA, 'YYYY') as ANO, FLOOR(SUM(IMPOSTO * (QUANTIDADE * PRECO))) as VALOR_IMPOSTO
FROM NOTAS_FISCAIS NF
INNER JOIN ITENS_NOTAS_FISCAIS INF ON NF.NUMERO = INF.NUMERO
WHERE TO_CHAR(DATA_VENDA, 'YYYY') = 2016
GROUP BY TO_CHAR(DATA_VENDA, 'YYYY');

--Conversão de dados
select to_date('16/05/2021', 'DD/MM/YYYY') from dual;
select to_char(sysdate, 'MM/DD/YYYY HH12:MM:SS AM') from dual;
select extract(month from to_date('12/11/2019', 'DD/MM/YYYY'))from dual;--extraindo o mês
select extract(year from to_date('12/11/2019', 'DD/MM/YYYY'))from dual;--extraindo o ano
select to_number('10') + 100 from dual;--converte o caracter em número e soma com 100
select to_char(10, '00000') from dual;--cria uma máscara com 5 digitos
--Usando o NVL
select nvl(tabela_de_vendedores.nome, 'Vendedor NULL') as nomevendedor, 
nvl(tabela_de_vendedores.bairro, 'Bairro Vendedor NULL') as bairrovendedor,
nvl(tabela_de_clientes.nome, 'Cliente NULL') as nomecliente,
nvl(tabela_de_clientes.bairro, 'Bairro Cliente NULL') as bairrocliente
from tabela_de_vendedores full join tabela_de_clientes
on tabela_de_vendedores.bairro = tabela_de_clientes.bairro;
--Usando o GREATEST
select c.volume_de_compra, c.limite_de_credito, greatest(c.volume_de_compra, c.limite_de_credito) as maior from tabela_de_clientes c;

--Retorna o faturamento para cada cliente em 2016
SELECT 'O cliente ' || TC.NOME || ' faturou ' || 
TO_CHAR(ROUND(SUM(INF.QUANTIDADE * INF.preco),2)) || ' no ano de ' || TO_CHAR(DATA_VENDA, 'YYYY') AS SENTENCA 
FROM notas_fiscais NF
INNER JOIN ITENS_NOTAS_FISCAIS INF ON NF.NUMERO = INF.NUMERO
INNER JOIN TABELA_DE_CLIENTES TC ON NF.CPF = TC.CPF
WHERE TO_CHAR(DATA_VENDA, 'YYYY') = '2016'
GROUP BY TC.NOME, TO_CHAR(DATA_VENDA, 'YYYY');

--Exemplos
SELECT NOME, UPPER(NOME) FROM TABELA_DE_CLIENTES;
SELECT NOME, LOWER(NOME) FROM TABELA_DE_CLIENTES;
SELECT NOME_DO_PRODUTO, INITCAP(NOME_DO_PRODUTO) FROM TABELA_DE_PRODUTOS;
SELECT CONCAT(ENDERECO_1 || ' - ', BAIRRO) as "Endereco-Bairro" FROM TABELA_DE_CLIENTES;
SELECT NOME, 'Endereço: ' || ENDERECO_1 || ' ' || BAIRRO || ' ' || CIDADE || ' ' || ESTADO || ', CEP: ' || CEP FROM TABELA_DE_CLIENTES;
SELECT NOME_DO_PRODUTO, LPAD(NOME_DO_PRODUTO, 40, '*') as "Completa_Caracteres_Left" FROM TABELA_DE_PRODUTOS;
SELECT NOME_DO_PRODUTO, RPAD(NOME_DO_PRODUTO, 60, '*') as "Completa_Caracteres_Right" FROM TABELA_DE_PRODUTOS;
SELECT NOME_DO_PRODUTO, SUBSTR(NOME_DO_PRODUTO,3,5) as "Recorta_Strings" FROM TABELA_DE_PRODUTOS;
SELECT NOME_DO_PRODUTO, INSTR(NOME_DO_PRODUTO, 'a') as "Posição do Parâmetro" FROM TABELA_DE_PRODUTOS;
SELECT NOME_DO_PRODUTO, REPLACE(REPLACE(NOME_DO_PRODUTO, 'Litro', 'L'),'Ls','L') as "Substitui Caracteres" FROM TABELA_DE_PRODUTOS;

select nf.cpf, to_char(nf.data_venda, 'MM/YYYY') as "Mes_Ano", SUM(inf.quantidade) as "Volume_Vendido" from notas_fiscais nf 
inner join itens_notas_fiscais inf on nf.numero = inf.numero group by nf.cpf, to_char(nf.data_venda, 'MM/YYYY');

--Relatório porcentagem de vendas sabor/ano
SELECT
    venda_sabor.sabor,
    venda_sabor.ano,
    venda_sabor.quantidade_vendida,
    round(((venda_sabor.quantidade_vendida / total_venda.quantidade_vendida) * 100), 2) AS patricipacao
FROM
    (
        SELECT
            tp.sabor,
            to_char(nf.data_venda, 'YYYY') AS ano,
            SUM(inf.quantidade) AS quantidade_vendida
        FROM
            itens_notas_fiscais   inf
            INNER JOIN tabela_de_produtos    tp ON inf.codigo_do_produto = tp.codigo_do_produto
            INNER JOIN notas_fiscais         nf ON nf.numero = inf.numero
        WHERE
            to_char(nf.data_venda, 'YYYY') = '2016'
        GROUP BY
            to_char(nf.data_venda, 'YYYY'),
            tp.sabor
        ORDER BY
            SUM(inf.quantidade) DESC
    ) venda_sabor
    INNER JOIN (
        SELECT
            to_char(nf.data_venda, 'YYYY') AS ano,
            SUM(inf.quantidade) AS quantidade_vendida
        FROM
            itens_notas_fiscais   inf
            INNER JOIN tabela_de_produtos    tp ON inf.codigo_do_produto = tp.codigo_do_produto
            INNER JOIN notas_fiscais         nf ON nf.numero = inf.numero
        WHERE
            to_char(nf.data_venda, 'YYYY') = '2016'
        GROUP BY
            to_char(nf.data_venda, 'YYYY')
        ORDER BY
            SUM(inf.quantidade) DESC
    ) total_venda ON venda_sabor.ano = total_venda.ano
ORDER BY
    venda_sabor.quantidade_vendida;

--Relatório de vendas válidas/inválidas
SELECT CADASTRO.CPF, CADASTRO.NOME, VENDAS.MES_ANO, CADASTRO.VOLUME_DE_COMPRA,
VENDAS.VOLUME_VENDIDO AS VOLUME_LIMITE,
CASE WHEN CADASTRO.VOLUME_DE_COMPRA <= VENDAS.VOLUME_VENDIDO THEN 'Vendas Válidas'
ELSE 'Vendas Inválidas' END AS RESULTADO
FROM (
    SELECT NF.CPF, 
    TO_CHAR(NF.DATA_VENDA, 'YYYY-MM') AS MES_ANO, 
    SUM(INF.QUANTIDADE) AS VOLUME_VENDIDO 
    FROM NOTAS_FISCAIS NF
    INNER JOIN ITENS_NOTAS_FISCAIS INF ON NF.NUMERO = INF.NUMERO
    GROUP BY NF.CPF, TO_CHAR(NF.DATA_VENDA, 'YYYY-MM')
) VENDAS
INNER JOIN (
    SELECT CPF, NOME, VOLUME_DE_COMPRA FROM TABELA_DE_CLIENTES
) CADASTRO
ON VENDAS.CPF = CADASTRO.CPF
WHERE VENDAS.MES_ANO = '2018-01';







