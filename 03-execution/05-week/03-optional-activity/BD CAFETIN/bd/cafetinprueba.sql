DROP DATABASE IF EXISTS cafetinprueba;
CREATE DATABASE cafetinprueba;
\c cafetinprueba;

DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- TYPE DOCUMENT
CREATE TABLE type_document (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_by UUID,
    updated_by UUID,
    deleted_by UUID,
    status UUID,

    name VARCHAR(60) NOT NULL


);

-- PERSON
CREATE TABLE person (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_by UUID,
    updated_by UUID,
    deleted_by UUID,
    status UUID,

    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(60) NOT NULL,
    email VARCHAR(100) UNIQUE,
    identity VARCHAR(20) NOT NULL UNIQUE

    type_document_id UUID NOT NULL,
    FOREIGN KEY (type_document_id) REFERENCES type_document(id)
);

-- FILE
CREATE TABLE file (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_by UUID,
    updated_by UUID,
    deleted_by UUID,
    status UUID,

    name VARCHAR(120),
    path TEXT{
    
-- ← relaciones agregadas (ambas opcionales)
    product_id  UUID,
    person_id   UUID,

    FOREIGN KEY (product_id) REFERENCES product(id),
    FOREIGN KEY (person_id)  REFERENCES person(id),

    -- Opcional: evita que un archivo quede huérfano
    CONSTRAINT chk_file_relacionado
        CHECK (product_id IS NOT NULL OR person_id IS NOT NULL)
    }
);

-- USER
CREATE TABLE "user" (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_by UUID,
    updated_by UUID,
    deleted_by UUID,
    status UUID,

    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(120) NOT NULL,

    person_id UUID NOT NULL UNIQUE,
    FOREIGN KEY (person_id) REFERENCES person(id)
);

-- ROLE
CREATE TABLE role (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_by UUID,
    updated_by UUID,
    deleted_by UUID,
    status UUID,

    name VARCHAR(60) NOT NULL UNIQUE
);

-- MODULE
CREATE TABLE module (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_by UUID,
    updated_by UUID,
    deleted_by UUID,
    status UUID,

    name VARCHAR(60) NOT NULL
);

-- VIEW
CREATE TABLE view (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_by UUID,
    updated_by UUID,
    deleted_by UUID,
    status UUID,

    name VARCHAR(60) NOT NULL
);

-- USER ROLE
CREATE TABLE user_role (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_by UUID,
    updated_by UUID,
    deleted_by UUID,
    status UUID,

    user_id UUID NOT NULL,
    role_id UUID NOT NULL,

    FOREIGN KEY (user_id) REFERENCES "user"(id),
    FOREIGN KEY (role_id) REFERENCES role(id)
);

-- ROLE MODULE
CREATE TABLE role_module (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_by UUID,
    updated_by UUID,
    deleted_by UUID,
    status UUID,

    role_id UUID NOT NULL,
    module_id UUID NOT NULL,

    FOREIGN KEY (role_id) REFERENCES role(id),
    FOREIGN KEY (module_id) REFERENCES module(id)
);

-- MODULE VIEW

CREATE TABLE module_view (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_by UUID,
    updated_by UUID,
    deleted_by UUID,
    status UUID,

    module_id UUID NOT NULL,
    view_id UUID NOT NULL,

    FOREIGN KEY (module_id) REFERENCES module(id),
    FOREIGN KEY (view_id) REFERENCES view(id)
);

-- CATEGORY
CREATE TABLE category (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_by UUID,
    updated_by UUID,
    deleted_by UUID,
    status UUID,

    name VARCHAR(60) NOT NULL
);

-- PRODUCT
CREATE TABLE product (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_by UUID,
    updated_by UUID,
    deleted_by UUID,
    status UUID,

    name VARCHAR(60) NOT NULL,
    price DOUBLE PRECISION NOT NULL,

    supplier_id     UUID,
    category_id UUID NOT NULL,

    FOREIGN KEY (category_id) REFERENCES category(id),
    FOREIGN KEY (supplier_id) REFERENCES supplier(id)
);

-- SUPPLIER
CREATE TABLE supplier (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_by UUID,
    updated_by UUID,
    deleted_by UUID,
    status UUID,

    name VARCHAR(100) NOT NULL,
    phone VARCHAR(30),
    
);


-- INVENTORY
CREATE TABLE inventory (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_by UUID,
    updated_by UUID,
    deleted_by UUID,
    status UUID,

    product_id UUID NOT NULL,
    quantity INT NOT NULL,

    FOREIGN KEY (product_id) REFERENCES product(id)
);

-- CUSTOMER
CREATE TABLE customer (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_by UUID,
    updated_by UUID,
    deleted_by UUID,
    status UUID,

    name VARCHAR(120),
    email VARCHAR(120)
);

-- ORDER
CREATE TABLE "order" (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_by UUID,
    updated_by UUID,
    deleted_by UUID,
    status UUID,

    customer_id UUID,
    total DOUBLE PRECISION,

    FOREIGN KEY (customer_id) REFERENCES customer(id)
);

-- ORDER ITEM
CREATE TABLE order_item (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_by UUID,
    updated_by UUID,
    deleted_by UUID,
    status UUID,

    order_id UUID,
    product_id UUID,
    quantity INT,
    price DOUBLE PRECISION,

    FOREIGN KEY (order_id) REFERENCES "order"(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);

-- METHOD PAYMENT
CREATE TABLE method_payment (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_by UUID,
    updated_by UUID,
    deleted_by UUID,
    status UUID,

    name VARCHAR(60) NOT NULL
);

-- INVOICE
CREATE TABLE invoice (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_by UUID,
    updated_by UUID,
    deleted_by UUID,
    status UUID,

    order_id UUID,
    total DOUBLE PRECISION,

    FOREIGN KEY (order_id) REFERENCES "order"(id)
);

-- INVOICE ITEM
CREATE TABLE invoice_item (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_by UUID,
    updated_by UUID,
    deleted_by UUID,
    status UUID,

    invoice_id UUID,
    product_id UUID,
    quantity INT,
    price DOUBLE PRECISION,

    FOREIGN KEY (invoice_id) REFERENCES invoice(id),
    FOREIGN KEY (product_id) REFERENCES product(id)
);

-- PAYMENT
CREATE TABLE payment (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ,
    created_by UUID,
    updated_by UUID,
    deleted_by UUID,
    status UUID,

    invoice_id UUID,
    method_payment_id UUID,
    amount DOUBLE PRECISION,

    FOREIGN KEY (invoice_id) REFERENCES invoice(id),
    FOREIGN KEY (method_payment_id) REFERENCES method_payment(id)
);