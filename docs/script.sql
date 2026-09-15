-- 1 Tabela central de usuários (para Autenticação e Login)
CREATE TABLE users (
    id_user SERIAL PRIMARY KEY,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    user_type VARCHAR(20) NOT NULL CHECK (user_type IN ('CLIENTE', 'TECNICO', 'FORNECEDOR', 'ADMIN')),
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2 Perfis Especificos
CREATE TABLE clients (
    id_client SERIAL PRIMARY KEY,
    id_user INT UNIQUE REFERENCES users(id_user) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    telephone VARCHAR(20)
);

CREATE TABLE technicians (
    id_technician SERIAL PRIMARY KEY,
    id_user INT UNIQUE REFERENCES users(id_user) ON DELETE CASCADE,
    name_comercial VARCHAR(100) NOT NULL,
    cnpj_cpf VARCHAR(18) UNIQUE NOT NULL,
    city VARCHAR(100) NOT NULL,
    description TEXT,
    average_rating DECIMAL(3,2) DEFAULT 0.00
);

-- 3 especialidades dos técnicos (relação N:N)
CREATE TABLE specialties (
    id_specialty SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE -- ex: 'iPhone', 'PS5', 'Notebook'
);

CREATE TABLE tecnico_specialties (
    id_technician INT REFERENCES technicians(id_technician) ON DELETE CASCADE,
    id_specialty INT REFERENCES specialties(id_specialty) ON DELETE CASCADE,
    PRIMARY KEY (id_technician, id_specialty)
);

-- 4 Serviços (Ordem de serviço entre cliente e técnico)
CREATE TABLE services (
    id_service SERIAL PRIMARY KEY,
    id_client INT REFERENCES clients(id_client),
    id_technician INT REFERENCES technicians(id_technician),
    equipment VARCHAR(100) NOT NULL,
    problem_description TEXT NOT NULL,
    status VARCHAR(30) DEFAULT 'SOLICITADO' CHECK (status IN ('SOLICITADO', 'EM_ANALISE', 'APROVADO', 'EM_REPARO', 'FINALIZADO', 'CANCELADO')),
    total_value DECIMAL(10,2) DEFAULT 0.00,
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5 Avaliações
CREATE TABLE reviews (
    id_review SERIAL PRIMARY KEY,
    id_service INT UNIQUE REFERENCES services(id_service),
    id_client INT REFERENCES clients(id_client),
    id_technician INT REFERENCES technicians(id_technician),
    score INT CHECK (score BETWEEN 1 AND 5),
    comment TEXT,
    evaluation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 6 Perfis de fornecedores (suppliers) que fornecem peças para os técnicos
CREATE TABLE suppliers (
    id_supplier SERIAL PRIMARY KEY,
    id_user INT UNIQUE REFERENCES users(id_user) ON DELETE CASCADE,
    company_name VARCHAR(100) NOT NULL,
    cnpj VARCHAR(18) UNIQUE NOT NULL,
    city VARCHAR(100) NOT NULL,
    telephone VARCHAR(20)
);

-- 7 Catalogo de produtos. peças oferecidas pelos suppliers
CREATE TABLE products (
    id_product SERIAL PRIMARY KEY,
    id_supplier INT REFERENCES suppliers(id_supplier) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL, -- ex: 'Tela OLED iPhone 11', 'Porta HDMI PS5'
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0
);

-- 8 Pedidos de Compras (técnico comprando do fornecedor)
CREATE TABLE purchase_orders (
    id_purchase_order SERIAL PRIMARY KEY,
    id_technician INT REFERENCES technicians(id_technician),
    id_supplier INT REFERENCES suppliers(id_supplier),
    status VARCHAR(30) DEFAULT 'PENDENTE' CHECK (status IN ('PENDENTE', 'PAGO', 'ENVIADO', 'ENTREGUE', 'CANCELADO')),
    total_value DECIMAL(10,2) NOT NULL,
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 9 Itens do Pedido (Relação N:N entre pedido e produto)
CREATE TABLE order_items (
    id_order_item SERIAL PRIMARY KEY,
    id_purchase_order INT REFERENCES purchase_orders(id_purchase_order) ON DELETE CASCADE,
    id_product INT REFERENCES products(id_product),
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_order_item, id_product)
);

-- 10 Transações Financeiras
CREATE TABLE financial_transactions (
    id_transaction SERIAL PRIMARY KEY,
    id_technician INT REFERENCES technicians(id_technician) ON DELETE CASCADE,
    id_service INT REFERENCES services(id_service) ON DELETE SET NULL, -- Receita ou despesa atrelada a um serviço
    id_order_item SERIAL PRIMARY KEY,
    id_purchase_order INT REFERENCES purchase_orders(id_purchase_order) ON DELETE SET NULL, -- Despesa atrelada a um pedido de peça
    tipo VARCHAR(10) NOT NULL CHECK (tipo IN ('RECEITA', 'DESPESA')),
    description VARCHAR(150) NOT NULL,
    value DECIMAL(10,2) NOT NULL,
    category VARCHAR(50), -- ex: 'Peça', 'Serviço', 'Aluguel', 'Ferramenta'
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);