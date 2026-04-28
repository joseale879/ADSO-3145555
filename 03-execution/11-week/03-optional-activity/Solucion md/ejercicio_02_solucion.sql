-- ============================================================
-- EJERCICIO 02 - Control de pagos y trazabilidad financiera
-- ============================================================

-- ============================================================
-- REQUERIMIENTO 1: Consulta INNER JOIN (mínimo 5 tablas)
-- Consolida venta, pago, estado, método, transacción y moneda.
-- ============================================================

SELECT
    s.sale_code                     AS codigo_venta,
    r.reservation_code              AS codigo_reserva,
    p.payment_reference             AS referencia_pago,
    ps.status_name                  AS estado_pago,
    pm.method_name                  AS metodo_pago,
    pt.transaction_reference        AS referencia_transaccion,
    pt.transaction_type             AS tipo_transaccion,
    pt.transaction_amount           AS monto_procesado,
    c.iso_currency_code             AS moneda
FROM sale s
    INNER JOIN reservation         r  ON r.reservation_id          = s.reservation_id
    INNER JOIN payment             p  ON p.sale_id                 = s.sale_id
    INNER JOIN payment_status      ps ON ps.payment_status_id      = p.payment_status_id
    INNER JOIN payment_method      pm ON pm.payment_method_id      = p.payment_method_id
    INNER JOIN payment_transaction pt ON pt.payment_id             = p.payment_id
    INNER JOIN currency            c  ON c.currency_id             = p.currency_id
ORDER BY s.sold_at DESC, pt.processed_at DESC;


-- ============================================================
-- REQUERIMIENTO 2: Trigger AFTER INSERT sobre payment_transaction
-- Cuando se registra una transacción de tipo REFUND, se crea
-- automáticamente un registro en la tabla refund.
-- ============================================================

CREATE OR REPLACE FUNCTION fn_crear_refund_desde_transaccion()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.transaction_type = 'REFUND' THEN
        INSERT INTO refund (
            payment_id,
            refund_reference,
            amount,
            requested_at,
            refund_reason
        )
        VALUES (
            NEW.payment_id,
            'REF-' || upper(substring(NEW.payment_transaction_id::text, 1, 12)),
            NEW.transaction_amount,
            now(),
            'Generado automáticamente desde transacción: ' || NEW.transaction_reference
        );
    END IF;

    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_after_payment_transaction_crea_refund
AFTER INSERT ON payment_transaction
FOR EACH ROW
EXECUTE FUNCTION fn_crear_refund_desde_transaccion();


-- ============================================================
-- REQUERIMIENTO 3: Procedimiento almacenado
-- Registra una transacción de pago sobre un pago existente.
-- ============================================================

CREATE OR REPLACE PROCEDURE sp_registrar_transaccion_pago(
    p_payment_id             uuid,
    p_transaction_reference  varchar,
    p_transaction_type       varchar,
    p_transaction_amount     numeric,
    p_provider_message       text DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validar que el tipo de transacción sea válido
    IF p_transaction_type NOT IN ('AUTH','CAPTURE','VOID','REFUND','REVERSAL') THEN
        RAISE EXCEPTION 'Tipo de transacción inválido: %. Valores permitidos: AUTH, CAPTURE, VOID, REFUND, REVERSAL', p_transaction_type;
    END IF;

    -- Validar que el pago exista
    IF NOT EXISTS (SELECT 1 FROM payment WHERE payment_id = p_payment_id) THEN
        RAISE EXCEPTION 'El pago no existe: %', p_payment_id;
    END IF;

    -- Registrar la transacción (puede disparar el trigger si es REFUND)
    INSERT INTO payment_transaction (
        payment_id,
        transaction_reference,
        transaction_type,
        transaction_amount,
        processed_at,
        provider_message
    )
    VALUES (
        p_payment_id,
        p_transaction_reference,
        p_transaction_type,
        p_transaction_amount,
        now(),
        p_provider_message
    );

    RAISE NOTICE 'Transacción % registrada para pago %', p_transaction_type, p_payment_id;
END;
$$;


-- ============================================================
-- SCRIPT DE PRUEBA Y VALIDACIÓN
-- ============================================================

-- 1. Insertar datos base de prueba
DO $$
DECLARE
    v_continent_id      uuid;
    v_country_id        uuid;
    v_state_id          uuid;
    v_city_id           uuid;
    v_district_id       uuid;
    v_address_id        uuid;
    v_tz_id             uuid;
    v_airline_id        uuid;
    v_currency_id       uuid;
    v_customer_cat_id   uuid;
    v_person_type_id    uuid;
    v_person_id         uuid;
    v_customer_id       uuid;
    v_res_status_id     uuid;
    v_sale_channel_id   uuid;
    v_reservation_id    uuid;
    v_sale_id           uuid;
    v_pay_status_id     uuid;
    v_pay_method_id     uuid;
    v_payment_id        uuid;
BEGIN
    INSERT INTO continent(continent_code, continent_name) VALUES ('SA','Sudamérica') RETURNING continent_id INTO v_continent_id;
    INSERT INTO country(continent_id, iso_alpha2, iso_alpha3, country_name) VALUES (v_continent_id,'PE','PER','Perú') RETURNING country_id INTO v_country_id;
    INSERT INTO time_zone(time_zone_name, utc_offset_minutes) VALUES ('America/Lima',-300) RETURNING time_zone_id INTO v_tz_id;
    INSERT INTO state_province(country_id, state_code, state_name) VALUES (v_country_id,'LIM','Lima') RETURNING state_province_id INTO v_state_id;
    INSERT INTO city(state_province_id, time_zone_id, city_name) VALUES (v_state_id, v_tz_id,'Lima') RETURNING city_id INTO v_city_id;
    INSERT INTO district(city_id, district_name) VALUES (v_city_id,'Miraflores') RETURNING district_id INTO v_district_id;
    INSERT INTO address(district_id, address_line_1) VALUES (v_district_id,'Av. Larco 123') RETURNING address_id INTO v_address_id;
    INSERT INTO airline(home_country_id, airline_code, airline_name, iata_code, icao_code)
    VALUES (v_country_id,'LP','LATAM Perú','LP','LPE') RETURNING airline_id INTO v_airline_id;
    INSERT INTO currency(iso_currency_code, currency_name, currency_symbol) VALUES ('USD','US Dollar','$') RETURNING currency_id INTO v_currency_id;
    INSERT INTO person_type(type_code, type_name) VALUES ('CLI','Cliente') RETURNING person_type_id INTO v_person_type_id;
    INSERT INTO person(person_type_id, first_name, last_name) VALUES (v_person_type_id,'Ana','Torres') RETURNING person_id INTO v_person_id;
    INSERT INTO customer_category(category_code, category_name) VALUES ('GOLD','Gold') RETURNING customer_category_id INTO v_customer_cat_id;
    INSERT INTO customer(airline_id, person_id, customer_category_id) VALUES (v_airline_id, v_person_id, v_customer_cat_id) RETURNING customer_id INTO v_customer_id;
    INSERT INTO reservation_status(status_code, status_name) VALUES ('PND','Pendiente') RETURNING reservation_status_id INTO v_res_status_id;
    INSERT INTO sale_channel(channel_code, channel_name) VALUES ('APP','App Móvil') RETURNING sale_channel_id INTO v_sale_channel_id;
    INSERT INTO reservation(booked_by_customer_id, reservation_status_id, sale_channel_id, reservation_code, booked_at)
    VALUES (v_customer_id, v_res_status_id, v_sale_channel_id,'PAYTEST01', now()) RETURNING reservation_id INTO v_reservation_id;
    INSERT INTO sale(reservation_id, currency_id, sale_code, sold_at)
    VALUES (v_reservation_id, v_currency_id,'SLE02TST', now()) RETURNING sale_id INTO v_sale_id;
    INSERT INTO payment_status(status_code, status_name) VALUES ('APR','Aprobado') RETURNING payment_status_id INTO v_pay_status_id;
    INSERT INTO payment_method(method_code, method_name) VALUES ('CARD','Tarjeta Crédito') RETURNING payment_method_id INTO v_pay_method_id;
    INSERT INTO payment(sale_id, payment_status_id, payment_method_id, currency_id, payment_reference, amount, authorized_at)
    VALUES (v_sale_id, v_pay_status_id, v_pay_method_id, v_currency_id,'PAY-EJ02-001', 450.00, now())
    RETURNING payment_id INTO v_payment_id;

    RAISE NOTICE 'Datos de prueba listos. payment_id=%', v_payment_id;
    RAISE NOTICE 'Ejecutar para disparar trigger:';
    RAISE NOTICE 'CALL sp_registrar_transaccion_pago(''%'', ''TXN-REFUND-001'', ''REFUND'', 450.00, ''Reembolso cliente'');', v_payment_id;
END;
$$;


-- 2. Invocar el procedimiento con tipo REFUND (disparará el trigger)
--    Ajustar el UUID de payment_id según la ejecución del bloque anterior:
--
--    CALL sp_registrar_transaccion_pago(
--        '<payment_id>',
--        'TXN-REFUND-001',
--        'REFUND',
--        450.00,
--        'Devolución solicitada por el cliente'
--    );


-- 3. Consultas de validación
-- Verificar transacción registrada
SELECT
    pt.transaction_reference,
    pt.transaction_type,
    pt.transaction_amount,
    pt.processed_at,
    p.payment_reference
FROM payment_transaction pt
    INNER JOIN payment p ON p.payment_id = pt.payment_id
ORDER BY pt.processed_at DESC
LIMIT 5;

-- Verificar que el trigger creó el refund
SELECT
    rf.refund_reference,
    rf.amount,
    rf.requested_at,
    rf.refund_reason,
    p.payment_reference
FROM refund rf
    INNER JOIN payment p ON p.payment_id = rf.payment_id
ORDER BY rf.requested_at DESC
LIMIT 5;
