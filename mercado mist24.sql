-- Criar banco de dados
CREATE DATABASE Mercado_misti;
USE Mercado_misti;

-- Criar tabela Usuarios
CREATE TABLE Usuarios (
    UsuarioID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Senha VARCHAR(255) NOT NULL,
    cpf_usuario VARCHAR(14) NOT NULL UNIQUE
);

-- Criar tabela Produtos
CREATE TABLE Produtos (
    ProdutoID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Descricao TEXT,
    Preco DECIMAL(10, 2) NOT NULL,
    Estoque INT NOT NULL, 
    Imagem_url VARCHAR(255)
);

-- Criar tabela Pedidos
CREATE TABLE Pedidos (
    PedidoID INT AUTO_INCREMENT PRIMARY KEY,
    UsuarioID INT,
    DataPedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ValorTotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)
);

--  a tabela de Pedido_Produtos 
CREATE TABLE Pedido_Produtos (
    PedidoID INT,
    ProdutoID INT,
    Quantidade INT NOT NULL,
    PRIMARY KEY (PedidoID, ProdutoID),
    FOREIGN KEY (PedidoID) REFERENCES Pedidos(PedidoID),
    FOREIGN KEY (ProdutoID) REFERENCES Produtos(ProdutoID)
);

-- Inserir um usuário na tabela Usuarios (exemplo)
INSERT INTO Usuarios (Nome, Email, Senha, cpf_usuario) 
VALUES ('Arthur Teixas', 'arthur@example.com', 'senha123', '830.740.450-46');

-- Inserir um produto na tabela Produtos
INSERT INTO Produtos (Nome, Descricao, Preco, Estoque, Imagem_url) 
VALUES ('Espada de Ferro Encantada', 'Espada de ferro', 29.90, 100, 'espada.jpg');

-- Selecionar dados dos usuários
SELECT UsuarioID, Nome, Email, Cpf_usuario
FROM Usuarios;

-- Função para criar pedidos
INSERT INTO Pedidos (UsuarioID, ValorTotal) 
VALUES (1, 59.80); -- Exemplo de pedido para o usuário com ID 1

-- Adicionar produtos novos ao pedido
INSERT INTO Pedido_Produtos (PedidoID, ProdutoID, Quantidade) 
VALUES (1, 1, 2); -- Adiciona 2 espadas de ferro ao pedido 1

-- remover um produto
DELIMITER //

CREATE PROCEDURE RemoverProduto(IN produtoID INT)
BEGIN
    
    IF EXISTS (SELECT 1 FROM Produtos WHERE ProdutoID = produtoID) THEN
       
        DELETE FROM Pedido_Produtos WHERE ProdutoID = produtoID;

        -- Remove o produto da tabela Produtos
        DELETE FROM Produtos WHERE ProdutoID = produtoID;
        
        SELECT ('Produto com ID ', produtoID, ' removido com sucesso.') AS Resultado;
    ELSE
        SELECT 'O Produto não foi encontrado.' AS Resultado;
    END IF;


DELIMITER ;

--  exemplo
CALL RemoverProduto(1); -- Remove o produto com o id
