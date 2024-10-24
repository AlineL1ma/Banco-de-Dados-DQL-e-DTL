-- Relatórios Banco de Dados DQL e DTL --

-- Relatório 1 - Lista dos empregados admitidos entre 2019-01-01 e 2022-03-31, trazendo as colunas (Nome Empregado, CPF Empregado, Data Admissão, Salário, Departamento, Número de Telefone), ordenado por data de admissão decrescente; --
SELECT 
    e.nome AS 'Nome Empregado',
    e.cpf AS 'CPF Empregado',
    e.dataAdm AS 'Data Admissao',
    e.salario AS 'Salário',
    d.nome AS 'Departamento',
    t.numero AS 'Número Telefone'
FROM 
    petshop.Empregado e
JOIN 
    Departamento d ON e.Departamento_idDepartamento = d.idDepartamento
JOIN 
    Telefone t ON e.cpf = t.Empregado_cpf
WHERE 
    e.dataAdm BETWEEN '2019-01-01' AND '2022-03-31'
ORDER BY 
    e.dataAdm DESC;


-- Relatório 2 - Lista dos empregados que ganham menos que a média salarial dos funcionários do Petshop, trazendo as colunas (Nome Empregado, CPF Empregado, Data Admissão,  Salário, Departamento, Número de Telefone), ordenado por nome do empregado; --
SELECT
    e.nome AS "Nome Empregado",
    e.cpf AS "CPF Empregado",
    e.dataAdm AS "Data Admissão",
    e.salario AS "Salário",
    d.nome AS "Departamento",
    t.numero AS "Número de Telefone"
FROM 
    Empregado e
JOIN 
    Departamento d ON e.Departamento_idDepartamento = d.idDepartamento
JOIN 
    Telefone t ON e.cpf = t.Empregado_cpf
WHERE 
    e.salario < (SELECT AVG(salario) FROM Empregado)
ORDER BY 
    e.nome ASC;


-- Relatório 3 - Lista dos departamentos com a quantidade de empregados total por cada departamento, trazendo também a média salarial dos funcionários do departamento e a média de comissão recebida pelos empregados do departamento, com as colunas (Departamento, Quantidade de Empregados, Média Salarial, Média da Comissão), ordenado por nome do departamento; --
SELECT 
    d.nome AS "Departamento",
    COUNT(e.cpf) AS "Quantidade de Empregados",
    AVG(e.salario) AS "Média Salarial",
    AVG(e.comissao) AS "Média da Comissão"
FROM 
    Departamento d
LEFT JOIN 
    Empregado e ON d.idDepartamento = e.Departamento_idDepartamento
GROUP BY 
    d.nome
ORDER BY 
    d.nome ASC;


-- Relatório 4 - Lista dos empregados com a quantidade total de vendas já realiza por cada Empregado, além da soma do valor total das vendas do empregado e a soma de suas comissões, trazendo as colunas (Nome Empregado, CPF Empregado, Sexo, Salário, Quantidade Vendas, Total Valor Vendido, Total Comissão das Vendas), ordenado por quantidade total de vendas realizadas; --
SELECT 
    e.nome AS "Nome Empregado",
    e.cpf AS "CPF Empregado",
    e.sexo AS "Sexo",
    e.salario AS "Salário",
    COUNT(v.idVenda) AS "Quantidade Vendas",
    SUM(v.valor) AS "Total Valor Vendido",
    SUM(v.comissao) AS "Total Comissão das Vendas"
FROM 
    Empregado e
LEFT JOIN 
    Venda v ON e.cpf = v.Empregado_cpf
GROUP BY 
    e.nome, e.cpf, e.sexo, e.salario
ORDER BY 
    COUNT(v.idVenda) DESC;


-- Relatório 5 - Lista dos empregados que prestaram Serviço na venda computando a quantidade total de vendas realizadas com serviço por cada Empregado, além da soma do valor total apurado pelos serviços prestados nas vendas por empregado e a soma de suas comissões, trazendo as colunas (Nome Empregado, CPF Empregado, Sexo, Salário, Quantidade Vendas com Serviço, Total Valor Vendido com Serviço, Total Comissão das Vendas com Serviço), ordenado por quantidade total de vendas realizadas; --
SELECT 
    e.nome AS "Nome Empregado",
    e.cpf AS "CPF Empregado",
    e.sexo AS "Sexo",
    e.salario AS "Salário",
    COUNT(DISTINCT isv.Venda_idVenda) AS "Quantidade Vendas com Serviço",
    SUM(isv.valor) AS "Total Valor Vendido com Serviço",
    SUM(isv.desconto) AS "Total Comissão das Vendas com Serviço"
FROM 
    Empregado e
JOIN 
    itensServico isv ON e.cpf = isv.Empregado_cpf
JOIN 
    Venda v ON isv.Venda_idVenda = v.idVenda
GROUP BY 
    e.nome, e.cpf, e.sexo, e.salario
ORDER BY 
    COUNT(DISTINCT isv.Venda_idVenda) DESC;


-- Relatório 6 - Lista dos serviços já realizados por um Pet, trazendo as colunas (Nome do Pet, Data do Serviço, Nome do Serviço, Quantidade, Valor, Empregado que realizou o Serviço), ordenado por data do serviço da mais recente a mais antiga; --
SELECT 
    p.nome AS "Nome do Pet",
    v.data AS "Data do Serviço",
    s.nome AS "Nome do Serviço",
    isv.quantidade AS "Quantidade",
    isv.valor AS "Valor",
    e.nome AS "Empregado que realizou o Serviço"
FROM 
    PET p
JOIN 
    itensServico isv ON p.idPET = isv.PET_idPET
JOIN 
    Venda v ON isv.Venda_idVenda = v.idVenda
JOIN 
    Servico s ON isv.Servico_idServico = s.idServico
JOIN 
    Empregado e ON isv.Empregado_cpf = e.cpf
ORDER BY 
    v.data DESC;


-- Relatório 7 - Lista das vendas já realizados para um Cliente, trazendo as colunas (Data da Venda, Valor, Desconto, Valor Final, Empregado que realizou a venda), ordenado por data do serviço da mais recente a mais antiga; --
SELECT 
    v.data AS 'Data Venda',
    v.valor AS 'Valor',
    v.desconto AS 'Desconto',
    (v.valor - v.desconto) AS 'Valor Final',
    e.nome AS 'Empregado Realizou Venda'
FROM 
    Venda v
JOIN 
    Empregado e ON v.Empregado_cpf = e.cpf
WHERE 
    v.Cliente_cpf = "005.710.583-96"
ORDER BY 
    v.data DESC;


-- Relatório 8 - Lista dos 10 serviços mais vendidos, trazendo a quantidade vendas cada serviço, o somatório total dos valores de serviço vendido, trazendo as colunas (Nome do Serviço, Quantidade Vendas, Total Valor Vendido), ordenado por quantidade total de vendas realizadas; --
SELECT 
    s.nome AS "Nome do Serviço",
    SUM(isv.quantidade) AS "Quantidade Vendas",
    SUM(isv.valor) AS "Total Valor Vendido"
FROM 
    itensServico isv
JOIN 
    Servico s ON isv.Servico_idServico = s.idServico
GROUP BY 
    s.nome
ORDER BY 
    SUM(isv.quantidade) DESC
LIMIT 10;


-- Relatório 9 - Lista das formas de pagamentos mais utilizadas nas Vendas, informando quantas vendas cada forma de pagamento já foi relacionada, trazendo as colunas (Tipo Forma Pagamento, Quantidade Vendas, Total Valor Vendido), ordenado por quantidade total de vendas realizadas; --
SELECT 
    f.tipo AS "Tipo Forma Pagamento",
    COUNT(v.idVenda) AS "Quantidade Vendas",
    SUM(f.valorPago) AS "Total Valor Vendido"
FROM 
    FormaPgVenda f
JOIN 
    Venda v ON f.Venda_idVenda = v.idVenda
GROUP BY 
    f.tipo
ORDER BY 
    COUNT(v.idVenda) DESC;


-- Relatório 10 - Balaço das Vendas, informando a soma dos valores vendidos por dia, trazendo as colunas (Data Venda, Quantidade de Vendas, Valor Total Venda), ordenado por Data Venda da mais recente a mais antiga; --
SELECT 
    DATE(v.data) AS 'Data Venda',
    COUNT(v.idVenda) AS 'Quantidade Vendas',
    SUM(v.valor) AS 'Valor Total Venda'
FROM 
    venda v
GROUP BY 
    DATE(v.data)
ORDER BY 
    DATE(v.data) DESC;


-- Relatório 11 - Lista dos Produtos, informando qual Fornecedor de cada produto, trazendo as colunas (Nome Produto, Valor Produto, Categoria do Produto, Nome Fornecedor, Email Fornecedor, Telefone Fornecedor), ordenado por Nome Produto; --
SELECT
    p.nome AS 'Nome Produto',
    p.valorVenda AS 'Valor Produto',
    p.marca AS 'Categoria Produto',
    f.nome AS 'Nome Fornecedor',
    f.email AS 'Email Fornecedor',
    t.numero AS 'Número Telefone'
FROM
    Produtos p
INNER JOIN
    ItensCompra ic ON p.idProduto = ic.Produtos_idProduto
INNER JOIN
    Compras c ON ic.Compras_idCompra = c.idCompra
INNER JOIN
    Fornecedor f ON c.Fornecedor_cpf_cnpj = f.cpf_cnpj
INNER JOIN
    Telefone t ON c.Fornecedor_cpf_cnpj = t.Fornecedor_cpf_cnpj
ORDER BY
    p.nome;


-- Relatório 12 - Lista dos Produtos mais vendidos, informando a quantidade (total) de vezes que cada produto participou em vendas e o total de valor apurado com a venda do produto, trazendo as colunas (Nome Produto, Quantidade (Total) Vendas, Valor Total Recebido pela Venda do Produto), ordenado por quantidade de vezes que o produto participou em vendas; --
SELECT 
    p.nome AS `Nome Produto`,
    SUM(iv.quantidade) AS `Quantidade (Total) Vendas`,
    SUM(iv.quantidade * iv.valor) AS `Valor Total Recebido pela Venda do Produto`
FROM 
    petshop.Produtos p
JOIN 
    petshop.ItensVendaProd iv ON p.idProduto = iv.Produto_idProduto
JOIN 
    petshop.Venda v ON iv.Venda_idVenda = v.idVenda
GROUP BY 
    p.idProduto, p.nome
ORDER BY 
    `Quantidade (Total) Vendas` DESC;
