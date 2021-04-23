SELECT * From tabela_de_clientes;
select tc.nome, tc.endereco_1 from tabela_de_clientes tc; -- Select básico

-- Select com filtros cláusula where
SELECT * from tabela_de_produtos WHERE sabor = 'Laranja';
SELECT * FROM tabela_de_produtos WHERE preco_de_lista > 19.50;

