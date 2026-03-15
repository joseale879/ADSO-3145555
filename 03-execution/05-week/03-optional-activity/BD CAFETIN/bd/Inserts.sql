-- =====================================================
-- CONEXIÓN A LA BASE DE DATOS
-- =====================================================

-- Conectarse a la base de datos creada previamente
\c cafetinprueba;


-- =====================================================
-- INSERTAR TIPOS DE DOCUMENTO
-- =====================================================
-- Esta tabla almacena los diferentes tipos de identificación
-- utilizados por las personas dentro del sistema.

INSERT INTO type_document (id,name) VALUES
(uuid_generate_v4(),'CC'),          -- Cédula de ciudadanía
(uuid_generate_v4(),'TI'),          -- Tarjeta de identidad
(uuid_generate_v4(),'CE'),          -- Cédula de extranjería
(uuid_generate_v4(),'PASAPORTE'),
(uuid_generate_v4(),'NIT'),
(uuid_generate_v4(),'LICENCIA'),
(uuid_generate_v4(),'RUT'),
(uuid_generate_v4(),'EXTRANJERO'),
(uuid_generate_v4(),'REGISTRO'),
(uuid_generate_v4(),'OTRO');


-- =====================================================
-- INSERTAR PERSONAS
-- =====================================================
-- Se registran personas en el sistema.
-- Cada persona se asocia a un tipo de documento mediante una clave foránea.

INSERT INTO person (id,first_name,last_name,email,identity,type_document_id)
SELECT uuid_generate_v4(),'Juan','Perez','juan@mail.com','1001',id FROM type_document LIMIT 1;

INSERT INTO person (id,first_name,last_name,email,identity,type_document_id)
SELECT uuid_generate_v4(),'Ana','Gomez','ana@mail.com','1002',id FROM type_document LIMIT 1;

INSERT INTO person (id,first_name,last_name,email,identity,type_document_id)
SELECT uuid_generate_v4(),'Luis','Torres','luis@mail.com','1003',id FROM type_document LIMIT 1;

INSERT INTO person (id,first_name,last_name,email,identity,type_document_id)
SELECT uuid_generate_v4(),'Laura','Diaz','laura@mail.com','1004',id FROM type_document LIMIT 1;

INSERT INTO person (id,first_name,last_name,email,identity,type_document_id)
SELECT uuid_generate_v4(),'Pedro','Ruiz','pedro@mail.com','1005',id FROM type_document LIMIT 1;

INSERT INTO person (id,first_name,last_name,email,identity,type_document_id)
SELECT uuid_generate_v4(),'Maria','Castro','maria@mail.com','1006',id FROM type_document LIMIT 1;

INSERT INTO person (id,first_name,last_name,email,identity,type_document_id)
SELECT uuid_generate_v4(),'Carlos','Rojas','carlos@mail.com','1007',id FROM type_document LIMIT 1;

INSERT INTO person (id,first_name,last_name,email,identity,type_document_id)
SELECT uuid_generate_v4(),'Diana','Lopez','diana@mail.com','1008',id FROM type_document LIMIT 1;

INSERT INTO person (id,first_name,last_name,email,identity,type_document_id)
SELECT uuid_generate_v4(),'Jorge','Garcia','jorge@mail.com','1009',id FROM type_document LIMIT 1;

INSERT INTO person (id,first_name,last_name,email,identity,type_document_id)
SELECT uuid_generate_v4(),'Paula','Herrera','paula@mail.com','1010',id FROM type_document LIMIT 1;


-- =====================================================
-- INSERTAR ARCHIVOS
-- =====================================================
-- Esta tabla almacena archivos asociados a personas
-- por ejemplo documentos, imágenes o comprobantes.

INSERT INTO file (name,path) VALUES

INSERT INTO file (id,name,path,person_id)
SELECT uuid_generate_v4(),'file1','/f1',id FROM person LIMIT 1;

INSERT INTO file (id,name,path,person_id)
SELECT uuid_generate_v4(),'file2','/f2',id FROM person LIMIT 1;

INSERT INTO file (id,name,path,person_id)
SELECT uuid_generate_v4(),'file3','/f3',id FROM person LIMIT 1;

INSERT INTO file (id,name,path,person_id)
SELECT uuid_generate_v4(),'file4','/f4',id FROM person LIMIT 1;

INSERT INTO file (id,name,path,person_id)
SELECT uuid_generate_v4(),'file5','/f5',id FROM person LIMIT 1;

INSERT INTO file (id,name,path,person_id)
SELECT uuid_generate_v4(),'file6','/f6',id FROM person LIMIT 1;

INSERT INTO file (id,name,path,person_id)
SELECT uuid_generate_v4(),'file7','/f7',id FROM person LIMIT 1;

INSERT INTO file (id,name,path,person_id)
SELECT uuid_generate_v4(),'file8','/f8',id FROM person LIMIT 1;

INSERT INTO file (id,name,path,person_id)
SELECT uuid_generate_v4(),'file9','/f9',id FROM person LIMIT 1;

INSERT INTO file (id,name,path,person_id)
SELECT uuid_generate_v4(),'file10','/f10',id FROM person LIMIT 1;


-- =====================================================
-- INSERTAR ROLES
-- =====================================================
-- Define los roles que pueden tener los usuarios dentro del sistema.

INSERT INTO role (id,name) VALUES
(uuid_generate_v4(),'ADMIN'),
(uuid_generate_v4(),'INSTRUCTOR'),
(uuid_generate_v4(),'APRENDIZ'),
(uuid_generate_v4(),'CAJERO'),
(uuid_generate_v4(),'MESERO'),
(uuid_generate_v4(),'GERENTE'),
(uuid_generate_v4(),'SUPERVISOR'),
(uuid_generate_v4(),'CLIENTE'),
(uuid_generate_v4(),'INVITADO'),
(uuid_generate_v4(),'AUDITOR');


-- =====================================================
-- INSERTAR MÓDULOS DEL SISTEMA
-- =====================================================
-- Representan las secciones funcionales del sistema.

INSERT INTO module (id,name) VALUES
(uuid_generate_v4(),'Seguridad'),
(uuid_generate_v4(),'Ventas'),
(uuid_generate_v4(),'Inventario'),
(uuid_generate_v4(),'Usuarios'),
(uuid_generate_v4(),'Facturacion'),
(uuid_generate_v4(),'Productos'),
(uuid_generate_v4(),'Clientes'),
(uuid_generate_v4(),'Reportes'),
(uuid_generate_v4(),'Proveedores'),
(uuid_generate_v4(),'Config');


-- =====================================================
-- INSERTAR VISTAS
-- =====================================================
-- Corresponden a las interfaces o pantallas del sistema.

INSERT INTO view (id,name) VALUES
(uuid_generate_v4(),'login'),
(uuid_generate_v4(),'dashboard'),
(uuid_generate_v4(),'usuarios'),
(uuid_generate_v4(),'productos'),
(uuid_generate_v4(),'categorias'),
(uuid_generate_v4(),'ventas'),
(uuid_generate_v4(),'clientes'),
(uuid_generate_v4(),'inventario'),
(uuid_generate_v4(),'facturas'),
(uuid_generate_v4(),'reportes');


-- =====================================================
-- INSERTAR CATEGORÍAS DE PRODUCTOS
-- =====================================================
-- Agrupan los productos del cafetín según su tipo.

INSERT INTO category (id,name) VALUES
(uuid_generate_v4(),'Bebidas'),
(uuid_generate_v4(),'Postres'),
(uuid_generate_v4(),'Cafe'),
(uuid_generate_v4(),'Jugos'),
(uuid_generate_v4(),'Tortas'),
(uuid_generate_v4(),'Galletas'),
(uuid_generate_v4(),'Sandwich'),
(uuid_generate_v4(),'Helados'),
(uuid_generate_v4(),'Especiales'),
(uuid_generate_v4(),'Otros');


-- =====================================================
-- INSERTAR PROVEEDORES
-- =====================================================
-- Empresas o personas que suministran productos al sistema.

INSERT INTO supplier (id,name,phone) VALUES
(uuid_generate_v4(),'Proveedor1','3001'),
(uuid_generate_v4(),'Proveedor2','3002'),
(uuid_generate_v4(),'Proveedor3','3003'),
(uuid_generate_v4(),'Proveedor4','3004'),
(uuid_generate_v4(),'Proveedor5','3005'),
(uuid_generate_v4(),'Proveedor6','3006'),
(uuid_generate_v4(),'Proveedor7','3007'),
(uuid_generate_v4(),'Proveedor8','3008'),
(uuid_generate_v4(),'Proveedor9','3009'),
(uuid_generate_v4(),'Proveedor10','3010');


-- =====================================================
-- INSERTAR CLIENTES
-- =====================================================
-- Personas que realizan compras en el sistema.

INSERT INTO customer (id,name,email) VALUES
(uuid_generate_v4(),'Cliente1','c1@mail.com'),
(uuid_generate_v4(),'Cliente2','c2@mail.com'),
(uuid_generate_v4(),'Cliente3','c3@mail.com'),
(uuid_generate_v4(),'Cliente4','c4@mail.com'),
(uuid_generate_v4(),'Cliente5','c5@mail.com'),
(uuid_generate_v4(),'Cliente6','c6@mail.com'),
(uuid_generate_v4(),'Cliente7','c7@mail.com'),
(uuid_generate_v4(),'Cliente8','c8@mail.com'),
(uuid_generate_v4(),'Cliente9','c9@mail.com'),
(uuid_generate_v4(),'Cliente10','c10@mail.com');


-- =====================================================
-- MÉTODOS DE PAGO
-- =====================================================
-- Formas en las que un cliente puede pagar.

INSERT INTO method_payment (id,name) VALUES
(uuid_generate_v4(),'EFECTIVO'),
(uuid_generate_v4(),'NEQUI'),
(uuid_generate_v4(),'DAVIPLATA'),
(uuid_generate_v4(),'TARJETA'),
(uuid_generate_v4(),'TRANSFERENCIA'),
(uuid_generate_v4(),'QR'),
(uuid_generate_v4(),'PAYPAL'),
(uuid_generate_v4(),'PSE'),
(uuid_generate_v4(),'DEBITO'),
(uuid_generate_v4(),'OTRO');


-- =====================================================
-- INSERTAR PRODUCTOS
-- =====================================================
-- Cada producto pertenece a una categoría.

INSERT INTO product (id,name,price,category_id)
SELECT uuid_generate_v4(),'Cafe',3000,id FROM category WHERE name='Cafe';

INSERT INTO product (id,name,price,category_id)
SELECT uuid_generate_v4(),'Capuccino',4000,id FROM category WHERE name='Cafe';

INSERT INTO product (id,name,price,category_id)
SELECT uuid_generate_v4(),'Latte',4500,id FROM category WHERE name='Cafe';

INSERT INTO product (id,name,price,category_id)
SELECT uuid_generate_v4(),'Brownie',5000,id FROM category WHERE name='Postres';

INSERT INTO product (id,name,price,category_id)
SELECT uuid_generate_v4(),'Cheesecake',7000,id FROM category WHERE name='Postres';

INSERT INTO product (id,name,price,category_id)
SELECT uuid_generate_v4(),'Torta de Chocolate',6000,id FROM category WHERE name='Tortas';

INSERT INTO product (id,name,price,category_id)
SELECT uuid_generate_v4(),'Torta de Fresa',6500,id FROM category WHERE name='Tortas';

INSERT INTO product (id,name,price,category_id)
SELECT uuid_generate_v4(),'Galleta de Avena',2000,id FROM category WHERE name='Galletas';

INSERT INTO product (id,name,price,category_id)
SELECT uuid_generate_v4(),'Galleta de Chocolate',2500,id FROM category WHERE name='Galletas';

INSERT INTO product (id,name,price,category_id)
SELECT uuid_generate_v4(),'Sandwich de Pollo',8000,id FROM category WHERE name='Sandwich';


-- =====================================================
-- INVENTARIO
-- =====================================================
-- Registra la cantidad disponible de cada producto.

INSERT INTO inventory (product_id,quantity)
SELECT id,10 FROM product WHERE name='Cafe';

INSERT INTO inventory (product_id,quantity)
SELECT id,20 FROM product WHERE name='Capuccino';

INSERT INTO inventory (product_id,quantity)
SELECT id,30 FROM product WHERE name='Latte';

INSERT INTO inventory (product_id,quantity)
SELECT id,15 FROM product WHERE name='Brownie';

INSERT INTO inventory (product_id,quantity)
SELECT id,25 FROM product WHERE name='Cheesecake';

INSERT INTO inventory (product_id,quantity)
SELECT id,12 FROM product WHERE name='Torta de Chocolate';

INSERT INTO inventory (product_id,quantity)
SELECT id,18 FROM product WHERE name='Torta de Fresa';

INSERT INTO inventory (product_id,quantity)
SELECT id,50 FROM product WHERE name='Galleta de Avena';

INSERT INTO inventory (product_id,quantity)
SELECT id,40 FROM product WHERE name='Galleta de Chocolate';

INSERT INTO inventory (product_id,quantity)
SELECT id,10 FROM product WHERE name='Sandwich de Pollo';


-- =====================================================
-- USUARIOS DEL SISTEMA
-- =====================================================
-- Se crean cuentas de usuario asociadas a personas registradas.

INSERT INTO "user"(username,password,person_id)
SELECT 'user1','123',id FROM person WHERE identity='1001';

INSERT INTO "user"(username,password,person_id)
SELECT 'user2','123',id FROM person WHERE identity='1002';

INSERT INTO "user"(username,password,person_id)
SELECT 'user3','123',id FROM person WHERE identity='1003';

INSERT INTO "user"(username,password,person_id)
SELECT 'user4','123',id FROM person WHERE identity='1004';

INSERT INTO "user"(username,password,person_id)
SELECT 'user5','123',id FROM person WHERE identity='1005';

INSERT INTO "user"(username,password,person_id)
SELECT 'user6','123',id FROM person WHERE identity='1006';

INSERT INTO "user"(username,password,person_id)
SELECT 'user7','123',id FROM person WHERE identity='1007';

INSERT INTO "user"(username,password,person_id)
SELECT 'user8','123',id FROM person WHERE identity='1008';

INSERT INTO "user"(username,password,person_id)
SELECT 'user9','123',id FROM person WHERE identity='1009';

INSERT INTO "user"(username,password,person_id)
SELECT 'user10','123',id FROM person WHERE identity='1010';


-- =====================================================
-- RELACIONES DE SEGURIDAD
-- =====================================================

-- Asignar rol a un usuario
INSERT INTO user_role (user_id,role_id)
SELECT
(SELECT id FROM "user" LIMIT 1),
(SELECT id FROM role WHERE name='ADMIN');

-- Asignar módulo a rol
INSERT INTO role_module (role_id,module_id)
SELECT
(SELECT id FROM role WHERE name='ADMIN'),
(SELECT id FROM module WHERE name='Seguridad');

-- Asignar vista a módulo
INSERT INTO module_view (module_id,view_id)
SELECT
(SELECT id FROM module WHERE name='Seguridad'),
(SELECT id FROM view WHERE name='dashboard');


-- =====================================================
-- PEDIDOS
-- =====================================================
-- Crear un pedido realizado por un cliente

INSERT INTO "order" (customer_id,total)
SELECT id,10000 FROM customer WHERE name='Cliente1';


-- =====================================================
-- DETALLE DEL PEDIDO
-- =====================================================
-- Se agregan productos al pedido

INSERT INTO order_item (order_id,product_id,quantity,price)
SELECT
(SELECT id FROM "order" LIMIT 1),
(SELECT id FROM product WHERE name='Cafe'),
1,
3000;


-- =====================================================
-- FACTURACIÓN
-- =====================================================
-- Crear una factura basada en el pedido realizado

INSERT INTO invoice (order_id,total)
SELECT id,total FROM "order" LIMIT 1;


-- Detalle de productos en la factura
INSERT INTO invoice_item (invoice_id,product_id,quantity,price)
SELECT
(SELECT id FROM invoice LIMIT 1),
(SELECT id FROM product WHERE name='Cafe'),
1,
3000;


-- =====================================================
-- REGISTRO DE PAGO
-- =====================================================
-- Se registra el pago realizado para la factura

INSERT INTO payment (invoice_id,method_payment_id,amount)
SELECT
(SELECT id FROM invoice LIMIT 1),
(SELECT id FROM method_payment WHERE name='EFECTIVO'),
10000;