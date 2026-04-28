-- ============================================================
-- EJERCICIO 04 - Acumulación de millas e historial de nivel
-- ============================================================

-- ============================================================
-- REQUERIMIENTO 1: Consulta INNER JOIN (mínimo 5 tablas)
-- Cliente, persona, cuenta fidelización, programa, nivel y venta.
-- ============================================================

SELECT
    c.customer_id                           AS cliente_id,
    p.first_name || ' ' || p.last_name      AS persona,
    la.account_number                       AS cuenta_fidelizacion,
    lp.program_name                         AS programa,
    lt.tier_name                            AS nivel,
    lat.assigned_at                         AS fecha_asignacion_nivel,
    s.sale_code                             AS venta_relacionada
FROM customer c
    INNER JOIN person                p   ON p.person_id              = c.person_id
    INNER JOIN loyalty_account       la  ON la.customer_id           = c.customer_id
    INNER JOIN loyalty_program       lp  ON lp.loyalty_program_id    = la.loyalty_program_id
    INNER JOIN loyalty_account_tier  lat ON lat.loyalty_account_id   = la.loyalty_account_id
    INNER JOIN loyalty_tier          lt  ON lt.loyalty_tier_id       = lat.loyalty_tier_id
    INNER JOIN reservation           r   ON r.booked_by_customer_id  = c.customer_id
    INNER JOIN sale                  s   ON s.reservation_id         = r.reservation_id
ORDER BY c.customer_id, lat.assigned_at DESC;


-- ============================================================
-- REQUERIMIENTO 2: Trigger AFTER INSERT sobre miles_transaction
-- Al acumular millas (EARN), evalúa si el total acumulado
-- supera el umbral del siguiente nivel y actualiza
-- loyalty_account_tier con el nuevo nivel correspondiente.
-- ============================================================

CREATE OR REPLACE FUNCTION fn_evaluar_nivel_fidelizacion()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_miles    integer;
    v_program_id     uuid;
    v_nuevo_tier_id  uuid;
    v_tier_actual_id uuid;
BEGIN
    -- Solo actuar en transacciones de acumulación
    IF NEW.transaction_type <> 'EARN' THEN
        RETURN NEW;
    END IF;

    -- Calcular total de millas acumuladas
    SELECT COALESCE(SUM(miles_delta), 0)
    INTO v_total_miles
    FROM miles_transaction
    WHERE loyalty_account_id = NEW.loyalty_account_id
      AND transaction_type = 'EARN';

    -- Obtener el programa al que pertenece la cuenta
    SELECT loyalty_program_id
    INTO v_program_id
    FROM loyalty_account
    WHERE loyalty_account_id = NEW.loyalty_account_id;

    -- Determinar el nivel más alto que el cliente puede alcanzar
    SELECT loyalty_tier_id
    INTO v_nuevo_tier_id
    FROM loyalty_tier
    WHERE loyalty_program_id = v_program_id
      AND required_miles <= v_total_miles
    ORDER BY required_miles DESC
    LIMIT 1;

    IF v_nuevo_tier_id IS NULL THEN
        RETURN NEW;
    END IF;

    -- Obtener el nivel actualmente asignado
    SELECT loyalty_tier_id
    INTO v_tier_actual_id
    FROM loyalty_account_tier
    WHERE loyalty_account_id = NEW.loyalty_account_id
    ORDER BY assigned_at DESC
    LIMIT 1;

    -- Si el nivel cambió, registrar el nuevo
    IF v_tier_actual_id IS DISTINCT FROM v_nuevo_tier_id THEN
        INSERT INTO loyalty_account_tier (
            loyalty_account_id,
            loyalty_tier_id,
            assigned_at
        )
        VALUES (
            NEW.loyalty_account_id,
            v_nuevo_tier_id,
            now()
        );

        RAISE NOTICE 'Nivel actualizado para cuenta %. Total millas: %', NEW.loyalty_account_id, v_total_miles;
    END IF;

    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_after_miles_transaction_evalua_nivel
AFTER INSERT ON miles_transaction
FOR EACH ROW
EXECUTE FUNCTION fn_evaluar_nivel_fidelizacion();


-- ============================================================
-- REQUERIMIENTO 3: Procedimiento almacenado
-- Registra una transacción de millas para una cuenta existente.
-- ============================================================

CREATE OR REPLACE PROCEDURE sp_registrar_millas(
    p_loyalty_account_id  uuid,
    p_transaction_type    varchar,
    p_miles_delta         integer,
    p_reference_code      varchar DEFAULT NULL,
    p_notes               text    DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validar tipo de transacción
    IF p_transaction_type NOT IN ('EARN', 'REDEEM', 'ADJUST') THEN
        RAISE EXCEPTION 'Tipo de transacción inválido: %', p_transaction_type;
    END IF;

    -- Validar que la cuenta exista
    IF NOT EXISTS (SELECT 1 FROM loyalty_account WHERE loyalty_account_id = p_loyalty_account_id) THEN
        RAISE EXCEPTION 'Cuenta de fidelización no encontrada: %', p_loyalty_account_id;
    END IF;

    -- Validar que miles_delta no sea cero
    IF p_miles_delta = 0 THEN
        RAISE EXCEPTION 'El delta de millas no puede ser cero.';
    END IF;

    -- Insertar la transacción (dispara el trigger de nivel)
    INSERT INTO miles_transaction (
        loyalty_account_id,
        transaction_type,
        miles_delta,
        occurred_at,
        reference_code,
        notes
    )
    VALUES (
        p_loyalty_account_id,
        p_transaction_type,
        p_miles_delta,
        now(),
        p_reference_code,
        p_notes
    );

    RAISE NOTICE 'Transacción de millas registrada: tipo=%, delta=%', p_transaction_type, p_miles_delta;
END;
$$;


-- ============================================================
-- SCRIPT DE PRUEBA Y VALIDACIÓN
-- ============================================================

DO $$
DECLARE
    v_continent_id      uuid;
    v_country_id        uuid;
    v_tz_id             uuid;
    v_state_id          uuid;
    v_city_id           uuid;
    v_district_id       uuid;
    v_address_id        uuid;
    v_airline_id        uuid;
    v_currency_id       uuid;
    v_person_type_id    uuid;
    v_person_id         uuid;
    v_customer_cat_id   uuid;
    v_customer_id       uuid;
    v_loyalty_prog_id   uuid;
    v_tier_base_id      uuid;
    v_tier_gold_id      uuid;
    v_loyalty_acc_id    uuid;
BEGIN
    INSERT INTO continent(continent_code, continent_name) VALUES ('OC','Oceanía') RETURNING continent_id INTO v_continent_id;
    INSERT INTO country(continent_id, iso_alpha2, iso_alpha3, country_name) VALUES (v_continent_id,'AU','AUS','Australia') RETURNING country_id INTO v_country_id;
    INSERT INTO time_zone(time_zone_name, utc_offset_minutes) VALUES ('Australia/Sydney',600) RETURNING time_zone_id INTO v_tz_id;
    INSERT INTO state_province(country_id, state_code, state_name) VALUES (v_country_id,'NSW','New South Wales') RETURNING state_province_id INTO v_state_id;
    INSERT INTO city(state_province_id, time_zone_id, city_name) VALUES (v_state_id, v_tz_id,'Sydney') RETURNING city_id INTO v_city_id;
    INSERT INTO district(city_id, district_name) VALUES (v_city_id,'Mascot') RETURNING district_id INTO v_district_id;
    INSERT INTO address(district_id, address_line_1) VALUES (v_district_id,'Airport Dr') RETURNING address_id INTO v_address_id;
    INSERT INTO airline(home_country_id, airline_code, airline_name, iata_code, icao_code)
    VALUES (v_country_id,'QF','Qantas','QF','QFA') RETURNING airline_id INTO v_airline_id;
    INSERT INTO currency(iso_currency_code, currency_name, currency_symbol) VALUES ('AUD','Australian Dollar','A$') RETURNING currency_id INTO v_currency_id;
    INSERT INTO person_type(type_code, type_name) VALUES ('FRQ','Viajero Frecuente') RETURNING person_type_id INTO v_person_type_id;
    INSERT INTO person(person_type_id, first_name, last_name) VALUES (v_person_type_id,'John','Smith') RETURNING person_id INTO v_person_id;
    INSERT INTO customer_category(category_code, category_name) VALUES ('PLAT','Platinum') RETURNING customer_category_id INTO v_customer_cat_id;
    INSERT INTO customer(airline_id, person_id, customer_category_id) VALUES (v_airline_id, v_person_id, v_customer_cat_id) RETURNING customer_id INTO v_customer_id;

    -- Programa de fidelización con dos niveles
    INSERT INTO loyalty_program(airline_id, default_currency_id, program_code, program_name)
    VALUES (v_airline_id, v_currency_id,'QFFPTS','Qantas Frequent Flyer') RETURNING loyalty_program_id INTO v_loyalty_prog_id;

    INSERT INTO loyalty_tier(loyalty_program_id, tier_code, tier_name, priority_level, required_miles)
    VALUES (v_loyalty_prog_id,'BRZ','Bronze', 1, 0) RETURNING loyalty_tier_id INTO v_tier_base_id;

    INSERT INTO loyalty_tier(loyalty_program_id, tier_code, tier_name, priority_level, required_miles)
    VALUES (v_loyalty_prog_id,'GLD','Gold', 2, 5000) RETURNING loyalty_tier_id INTO v_tier_gold_id;

    -- Cuenta con nivel inicial Bronze
    INSERT INTO loyalty_account(customer_id, loyalty_program_id, account_number)
    VALUES (v_customer_id, v_loyalty_prog_id,'QFF-100200300') RETURNING loyalty_account_id INTO v_loyalty_acc_id;

    INSERT INTO loyalty_account_tier(loyalty_account_id, loyalty_tier_id, assigned_at)
    VALUES (v_loyalty_acc_id, v_tier_base_id, now());

    RAISE NOTICE 'loyalty_account_id=%', v_loyalty_acc_id;
    RAISE NOTICE 'Ejecutar: CALL sp_registrar_millas(''%'', ''EARN'', 6000, ''VLO-AV9001'', ''Vuelo SYD-MEL'');', v_loyalty_acc_id;
END;
$$;


-- Invocar el procedimiento (debe subir de nivel a Gold):
-- CALL sp_registrar_millas(
--     '<loyalty_account_id>',
--     'EARN',
--     6000,
--     'VLO-AV9001',
--     'Vuelo Sydney - Melbourne'
-- );


-- Consultas de validación
-- Ver transacciones registradas
SELECT mt.transaction_type, mt.miles_delta, mt.occurred_at, mt.reference_code
FROM miles_transaction mt
ORDER BY mt.occurred_at DESC LIMIT 5;

-- Ver historial de niveles (el trigger debe haber agregado Gold)
SELECT
    la.account_number,
    lt.tier_name,
    lat.assigned_at
FROM loyalty_account_tier lat
    INNER JOIN loyalty_account la ON la.loyalty_account_id = lat.loyalty_account_id
    INNER JOIN loyalty_tier    lt ON lt.loyalty_tier_id    = lat.loyalty_tier_id
ORDER BY lat.assigned_at DESC
LIMIT 10;
