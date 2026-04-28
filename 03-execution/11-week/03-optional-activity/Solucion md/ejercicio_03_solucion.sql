-- ============================================================
-- EJERCICIO 03 - Facturación: venta, impuestos, detalle
-- ============================================================

-- ============================================================
-- REQUERIMIENTO 1: Consulta INNER JOIN (mínimo 5 tablas)
-- Relación entre venta, factura, estado, líneas e impuesto.
-- ============================================================

SELECT
    s.sale_code                 AS codigo_venta,
    i.invoice_number            AS numero_factura,
    ist.status_name             AS estado_factura,
    il.line_number              AS linea_facturable,
    il.line_description         AS descripcion_linea,
    il.quantity                 AS cantidad,
    il.unit_price               AS precio_unitario,
    t.tax_name                  AS impuesto_aplicado,
    t.rate_percentage           AS porcentaje_impuesto,
    c.iso_currency_code         AS moneda
FROM sale s
    INNER JOIN invoice        i   ON i.sale_id             = s.sale_id
    INNER JOIN invoice_status ist ON ist.invoice_status_id = i.invoice_status_id
    INNER JOIN invoice_line   il  ON il.invoice_id         = i.invoice_id
    INNER JOIN tax            t   ON t.tax_id              = il.tax_id
    INNER JOIN currency       c   ON c.currency_id         = i.currency_id
ORDER BY s.sold_at DESC, il.line_number;


-- ============================================================
-- REQUERIMIENTO 2: Trigger AFTER INSERT sobre invoice_line
-- Cada vez que se registra una línea, se verifica que la
-- factura esté en estado 'DRAFT'; de lo contrario se lanza
-- una excepción para mantener consistencia del flujo.
-- Como efecto verificable, se actualiza el campo updated_at
-- de la factura para reflejar que fue modificada.
-- ============================================================

CREATE OR REPLACE FUNCTION fn_actualizar_factura_tras_linea()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_status_code varchar(20);
BEGIN
    -- Obtener el estado actual de la factura
    SELECT ist.status_code
    INTO v_status_code
    FROM invoice i
        INNER JOIN invoice_status ist ON ist.invoice_status_id = i.invoice_status_id
    WHERE i.invoice_id = NEW.invoice_id;

    -- Solo permitir agregar líneas a facturas en estado DRAFT
    IF v_status_code <> 'DRAFT' THEN
        RAISE EXCEPTION 'No se pueden agregar líneas a una factura en estado %. Solo se permiten facturas en estado DRAFT.', v_status_code;
    END IF;

    -- Registrar que la factura fue actualizada (efecto verificable)
    UPDATE invoice
    SET updated_at = now()
    WHERE invoice_id = NEW.invoice_id;

    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_after_invoice_line_valida_factura
AFTER INSERT ON invoice_line
FOR EACH ROW
EXECUTE FUNCTION fn_actualizar_factura_tras_linea();


-- ============================================================
-- REQUERIMIENTO 3: Procedimiento almacenado
-- Registra una nueva línea facturable sobre una factura existente.
-- ============================================================

CREATE OR REPLACE PROCEDURE sp_registrar_linea_factura(
    p_invoice_id        uuid,
    p_tax_code          varchar,
    p_line_number       integer,
    p_line_description  varchar,
    p_quantity          numeric,
    p_unit_price        numeric
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_tax_id    uuid;
BEGIN
    -- Validar que la factura exista
    IF NOT EXISTS (SELECT 1 FROM invoice WHERE invoice_id = p_invoice_id) THEN
        RAISE EXCEPTION 'La factura no existe: %', p_invoice_id;
    END IF;

    -- Obtener impuesto si se indicó
    IF p_tax_code IS NOT NULL THEN
        SELECT tax_id INTO v_tax_id FROM tax WHERE tax_code = p_tax_code;
        IF v_tax_id IS NULL THEN
            RAISE EXCEPTION 'El código de impuesto no existe: %', p_tax_code;
        END IF;
    END IF;

    -- Insertar la línea (dispara el trigger)
    INSERT INTO invoice_line (
        invoice_id,
        tax_id,
        line_number,
        line_description,
        quantity,
        unit_price
    )
    VALUES (
        p_invoice_id,
        v_tax_id,
        p_line_number,
        p_line_description,
        p_quantity,
        p_unit_price
    );

    RAISE NOTICE 'Línea % registrada en factura %', p_line_number, p_invoice_id;
END;
$$;


-- ============================================================
-- SCRIPT DE PRUEBA Y VALIDACIÓN
-- ============================================================

DO $$
DECLARE
    v_continent_id    uuid;
    v_country_id      uuid;
    v_tz_id           uuid;
    v_state_id        uuid;
    v_city_id         uuid;
    v_district_id     uuid;
    v_address_id      uuid;
    v_airline_id      uuid;
    v_currency_id     uuid;
    v_person_type_id  uuid;
    v_person_id       uuid;
    v_customer_cat_id uuid;
    v_customer_id     uuid;
    v_res_status_id   uuid;
    v_sale_channel_id uuid;
    v_reservation_id  uuid;
    v_sale_id         uuid;
    v_inv_status_id   uuid;
    v_invoice_id      uuid;
    v_tax_id          uuid;
BEGIN
    INSERT INTO continent(continent_code, continent_name) VALUES ('EU','Europa') RETURNING continent_id INTO v_continent_id;
    INSERT INTO country(continent_id, iso_alpha2, iso_alpha3, country_name) VALUES (v_continent_id,'ES','ESP','España') RETURNING country_id INTO v_country_id;
    INSERT INTO time_zone(time_zone_name, utc_offset_minutes) VALUES ('Europe/Madrid',60) RETURNING time_zone_id INTO v_tz_id;
    INSERT INTO state_province(country_id, state_code, state_name) VALUES (v_country_id,'MAD','Madrid') RETURNING state_province_id INTO v_state_id;
    INSERT INTO city(state_province_id, time_zone_id, city_name) VALUES (v_state_id, v_tz_id,'Madrid') RETURNING city_id INTO v_city_id;
    INSERT INTO district(city_id, district_name) VALUES (v_city_id,'Barajas') RETURNING district_id INTO v_district_id;
    INSERT INTO address(district_id, address_line_1) VALUES (v_district_id,'Aeropuerto Barajas') RETURNING address_id INTO v_address_id;
    INSERT INTO airline(home_country_id, airline_code, airline_name, iata_code, icao_code)
    VALUES (v_country_id,'IB','Iberia','IB','IBE') RETURNING airline_id INTO v_airline_id;
    INSERT INTO currency(iso_currency_code, currency_name, currency_symbol) VALUES ('EUR','Euro','€') RETURNING currency_id INTO v_currency_id;
    INSERT INTO person_type(type_code, type_name) VALUES ('EMP','Empleado') RETURNING person_type_id INTO v_person_type_id;
    INSERT INTO person(person_type_id, first_name, last_name) VALUES (v_person_type_id,'Luis','García') RETURNING person_id INTO v_person_id;
    INSERT INTO customer_category(category_code, category_name) VALUES ('SIL','Silver') RETURNING customer_category_id INTO v_customer_cat_id;
    INSERT INTO customer(airline_id, person_id, customer_category_id) VALUES (v_airline_id, v_person_id, v_customer_cat_id) RETURNING customer_id INTO v_customer_id;
    INSERT INTO reservation_status(status_code, status_name) VALUES ('CAN','Cancelada') RETURNING reservation_status_id INTO v_res_status_id;
    INSERT INTO sale_channel(channel_code, channel_name) VALUES ('AGC','Agencia') RETURNING sale_channel_id INTO v_sale_channel_id;
    INSERT INTO reservation(booked_by_customer_id, reservation_status_id, sale_channel_id, reservation_code, booked_at)
    VALUES (v_customer_id, v_res_status_id, v_sale_channel_id,'INVTEST01', now()) RETURNING reservation_id INTO v_reservation_id;
    INSERT INTO sale(reservation_id, currency_id, sale_code, sold_at) VALUES (v_reservation_id, v_currency_id,'SLE03TST', now()) RETURNING sale_id INTO v_sale_id;

    -- Factura en estado DRAFT
    INSERT INTO invoice_status(status_code, status_name) VALUES ('DRAFT','Borrador') RETURNING invoice_status_id INTO v_inv_status_id;
    INSERT INTO invoice(sale_id, invoice_status_id, currency_id, invoice_number, issued_at)
    VALUES (v_sale_id, v_inv_status_id, v_currency_id,'INV-2026-0001', now()) RETURNING invoice_id INTO v_invoice_id;

    -- Impuesto
    INSERT INTO tax(tax_code, tax_name, rate_percentage, effective_from)
    VALUES ('IVA21','IVA 21%', 21.000,'2024-01-01') RETURNING tax_id INTO v_tax_id;

    RAISE NOTICE 'invoice_id=% tax_code=IVA21', v_invoice_id;
    RAISE NOTICE 'Ejecutar: CALL sp_registrar_linea_factura(''%'', ''IVA21'', 1, ''Tiquete BOG-MDE'', 1, 350000);', v_invoice_id;
END;
$$;


-- Invocar el procedimiento (ajustar UUID):
-- CALL sp_registrar_linea_factura(
--     '<invoice_id>',
--     'IVA21',
--     1,
--     'Tiquete Bogotá - Medellín',
--     1,
--     350000
-- );


-- Consultas de validación
SELECT
    i.invoice_number,
    i.updated_at         AS ultima_actualizacion_factura,
    il.line_number,
    il.line_description,
    il.quantity,
    il.unit_price,
    t.tax_name
FROM invoice_line il
    INNER JOIN invoice i ON i.invoice_id = il.invoice_id
    LEFT  JOIN tax     t ON t.tax_id     = il.tax_id
ORDER BY il.created_at DESC
LIMIT 5;
