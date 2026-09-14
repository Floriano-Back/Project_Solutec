-- 1 Tabela central de usuários (para Autenticação e Login)
CREATE TABLE usuarios (
    id_usuario SERIAL PRIMARY KEY,
    email VARCHAR(150) UNIQUE NOT NULL,
    senha_hash VARCHAR(255) NOT NULL,
    tipo_usuario VARCHAR(20) NOT NULL CHECK (tipo_usuario IN ('CLIENTE', 'TECNICO', 'FORNECEDOR', 'ADMIN')),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2 Prrfis Especificos
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    id_usuario INT UNIQUE REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    telefone VARCHAR(20)
);

CREATE TABLE tecnicos (
    id_tecnico SERIAL PRIMARY KEY,
    id_usuario INT UNIQUE REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    nome_comercial VARCHAR(100) NOT NULL,
    cnpj_cpf VARCHAR(18) UNIQUE NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    descricao TEXT,
    avaliacao_media DECIMAL(3,2) DEFAULT 0.00
);

-- 3 Especialidades dos técnicos (relação N:N)
CREATE TABLE especialidades (
    id_especialidade SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE -- ex: 'iPhone', 'PS5', 'Notebook'
);

CREATE TABLE tecnico_especialidades (
    id_tecnico INT REFERENCES tecnicos(id_tecnico) ON DELETE CASCADE,
    id_especialidade INT REFERENCES especialidades(id_especialidade) ON DELETE CASCADE,
    PRIMARY KEY (id_tecnico, id_especialidade)
);

-- 4 Serviços (Ordem de serviço entre cliente e técnico)
CREATE TABLE servicos (
    id_servico SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES clientes(id_cliente),
    id_tecnico INT REFERENCES tecnicos(id_tecnico),
    equipamento VARCHAR(100) NOT NULL,
    descricao_problema TEXT NOT NULL,
    status VARCHAR(30) DEFAULT 'SOLICITADO' CHECK (status IN ('SOLICITADO', 'EM_ANALISE', 'APROVADO', 'EM_REPARO', 'FINALIZADO', 'CANCELADO')),
    valor_total DECIMAL(10,2) DEFAULT 0.00,
    data_solicitacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5 Avaliações
CREATE TABLE avaliacoes (
    id_avaliacao SERIAL PRIMARY KEY,
    id_servico INT UNIQUE REFERENCES servicos(id_servico),
    id_cliente INT REFERENCES clientes(id_cliente),
    id_tecnico INT REFERENCES tecnicos(id_tecnico),
    nota INT CHECK (nota BETWEEN 1 AND 5),
    comentario TEXT,
    data_avaliacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6 Transações Financeiras (Controle de caixa do técnico)
CREATE TABLE transacoes_financeiras (
    id_transacao SERIAL PRIMARY KEY,
    id_tecnico INT REFERENCES tecnicos(id_tecnico) ON DELETE CASCADE,
    id_servico INT REFERENCES servicos(id_servico) ON DELETE SET NULL, -- Opcional: vincula a receita a um serviço
    tipo VARCHAR(10) NOT NULL CHECK (tipo IN ('RECEITA', 'DESPESA')),
    descricao VARCHAR(150) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    categoria VARCHAR(50), -- ex: 'Peça', 'Serviço', 'Aluguel', 'Ferramenta'
    data_transacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7 Perfis de Fornecedores
CREATE TABLE fornecedores (
    id_fornecedor SERIAL PRIMARY KEY,
    id_usuario INT UNIQUE REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    nome_empresa VARCHAR(100) NOT NULL,
    cnpj VARCHAR(18) UNIQUE NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    telefone VARCHAR(20)
);

-- 8 Catalogo de Produtos. peças oferecidas pelos fornecedores
CREATE TABLE produtos (
    id_produto SERIAL PRIMARY KEY,
    id_fornecedor INT REFERENCES fornecedores(id_fornecedor) ON DELETE CASCADE,
    nome VARCHAR(100) NOT NULL, -- ex: 'Tela OLED iPhone 11', 'Porta HDMI PS5'
    descricao TEXT,
    preco DECIMAL(10,2) NOT NULL,
    quantidade_estoque INT DEFAULT 0
);

-- 9 Pedidos de Compras (técnico comprando do fornecedor)
CREATE TABLE pedidos_compra (
    id_pedido SERIAL PRIMARY KEY,
    id_tecnico INT REFERENCES tecnicos(id_tecnico),
    id_fornecedor INT REFERENCES fornecedores(id_fornecedor),
    status VARCHAR(30) DEFAULT 'PENDENTE' CHECK (status IN ('PENDENTE', 'PAGO', 'ENVIADO', 'ENTREGUE', 'CANCELADO')),
    valor_total DECIMAL(10,2) NOT NULL,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 10 Itens do Pedido (Relação N:N entre pedido e produto)
CREATE TABLE pedido_itens (
    id_pedido INT REFERENCES pedidos_compra(id_pedido) ON DELETE CASCADE,
    id_produto INT REFERENCES produtos(id_produto),
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pedido, id_produto)
);

-- 11 Transações Financeiras (Atualizada com Vinculos)
-- Dropei e recriei a tabela para incluir a chave de id_pedido
DROP TABLE IF EXISTS transacoes_financeiras;

CREATE TABLE transacoes_financeiras (
    id_transacao SERIAL PRIMARY KEY,
    id_tecnico INT REFERENCES tecnicos(id_tecnico) ON DELETE CASCADE,
    id_servico INT REFERENCES servicos(id_servico) ON DELETE SET NULL, -- Receita ou despesa atrelada a um serviço
    id_pedido INT REFERENCES pedidos_compra(id_pedido) ON DELETE SET NULL, -- Despesa atrelada a um pedido de peça
    tipo VARCHAR(10) NOT NULL CHECK (tipo IN ('RECEITA', 'DESPESA')),
    descricao VARCHAR(150) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    categoria VARCHAR(50), -- ex: 'Peça', 'Serviço', 'Aluguel', 'Ferramenta'
    data_transacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);