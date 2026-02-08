-- 1. CRIANDO AS TABELAS (DDL)

-- Tabela de Clientes Geral
CREATE TABLE Clientes (
    id_cliente SERIAL PRIMARY KEY,
    endereco VARCHAR(255),
    tipo_cliente VARCHAR(2) NOT NULL CHECK (tipo_cliente IN ('PF', 'PJ'))
);

-- Tabela Pessoa Física (Refinamento do desafio)
CREATE TABLE Pessoa_Fisica (
    id_pf SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES Clientes(id_cliente) ON DELETE CASCADE,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) UNIQUE NOT NULL
);

-- Tabela Pessoa Jurídica (Refinamento do desafio)
CREATE TABLE Pessoa_Juridica (
    id_pj SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES Clientes(id_cliente) ON DELETE CASCADE,
    razao_social VARCHAR(100) NOT NULL,
    cnpj CHAR(14) UNIQUE NOT NULL
);

-- Tabela de Pedidos
CREATE TABLE Pedidos (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES Clientes(id_cliente),
    descricao VARCHAR(255),
    status_pedido VARCHAR(50) DEFAULT 'Em elaboração',
    frete FLOAT DEFAULT 10.0
);

-- Tabela de Pagamentos (Pode ter mais de uma forma)
CREATE TABLE Pagamentos (
    id_pagamento SERIAL PRIMARY KEY,
    id_pedido INT REFERENCES Pedidos(id_pedido),
    forma_pagamento VARCHAR(50) NOT NULL, -- Cartão, Boleto, Pix
    valor_pago DECIMAL(10,2)
);

-- Inserindo um cliente PF
INSERT INTO Clientes (endereco, tipo_cliente) VALUES ('Rua A, 123', 'PF');
INSERT INTO Pessoa_Fisica (id_cliente, nome, cpf) VALUES (1, 'Renato Silva', '12345678901');

-- Inserindo um pedido para esse cliente
INSERT INTO Pedidos (id_cliente, descricao) VALUES (1, 'Compra de Teclado Gamer');

-- Inserindo o pagamento desse pedido
INSERT INTO Pagamentos (id_pedido, forma_pagamento, valor_pago) VALUES (1, 'Pix', 150.00);

SELECT 
    pf.nome AS Nome_Cliente,
    p.descricao AS Produto,
    pay.forma_pagamento,
    pay.valor_pago
FROM Clientes c
JOIN Pessoa_Fisica pf ON c.id_cliente = pf.id_cliente
JOIN Pedidos p ON c.id_cliente = p.id_cliente
JOIN Pagamentos pay ON p.id_pedido = pay.id_pedido;