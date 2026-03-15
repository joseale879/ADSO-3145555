\c cafetinprueba;
-- VISTA
CREATE VIEW view_product_category AS
SELECT 
    p.id AS product_id,
    p.name AS product_name,
    p.price,
    c.name AS category_name
FROM product p
JOIN category c
ON p.category_id = c.id;

SELECT * FROM view_product_category;


--FUNCION

CREATE OR REPLACE FUNCTION obtener_precio_producto(pnombre TEXT)
RETURNS INT
LANGUAGE SQL
AS $$
SELECT price
FROM product
WHERE name = pnombre;
$$;

SELECT obtener_precio_producto('Cafe');