-- ============================================================
-- EJERCICIO 09 - Publicación de tarifas y reservas
-- ============================================================

-- ============================================================
-- REQUERIMIENTO 1: Consulta INNER JOIN (mínimo 5 tablas)
-- Aerolínea, tarifa, clase, aeropuertos, moneda,
-- reserva, venta y tiquete.
-- ============================================================

SELECT
    al.airline_name                     AS aerolinea,
    fa.fare_code                        AS codigo_tarifa,
    fc.fare_class_name                  AS clase_tarifaria,
    ao.airport_name                     AS aeropuerto_origen,
    ao.iata_code                        AS iata_origen,
    ad.airport_name                     AS aeropuerto_destino,
    ad.iata_code                        AS iata_destino,
    c.iso_currency_code                 AS moneda,
    fa.base_amount                      AS monto_base,
    fa.valid_from                       AS vigencia_desde,
    fa.valid_to                         AS vigencia_hasta,
    r.reservation_code                  AS reserva,
    s.sale_code                         AS venta,
    t.ticket_number                     AS tiquete
FROM fare fa
    INNER JOIN airline        al ON al.airline_id             = fa.airline_id
    INNER JOIN fare_class     fc ON fc.fare_class_id          = fa.fare_class_id
    INNER JOIN airport        ao ON ao.airport_id             = fa.origin_airport_id
    INNER JOIN airport        ad ON ad.airport_id             = fa.destination_airport_id
    INNER JOIN currency       c  ON c.currency_id             = fa.currency_id
    INNER JOIN ticket         t  ON t.fare_id                 = fa.fare_id
    INNER JOIN sale           s  ON s.sale_id                 = t.sale_id
    INNER JOIN reservation    r  ON r.reservation_id          = s.reservation_id
ORDER BY al.airline_name, fa.fare_code;


-- ============================================================
-- REQUERIMIENTO 2: Trigger AFTER INSERT sobre fare
-- Al publicar una nueva tarifa, se registra en un log de
-- auditoría tarifaria para trazabilidad comercial.
-- ============================================================

CREATE TABLE IF NOT EXISTS fare_publication_log (
    log_id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    fare_id         uuid NOT NULL,
    fare_code       varchar(30) NOT NULL,
    airline_id      uuid NOT NULL,
    base_amount     numeric(12,2) NOT NULL,
    origin_iata     varchar(3),
    destination_iata varchar(3),
    logged_at       timestamptz NOT NULL DEFAULT now(),
    log_message     text
);

CREATE OR REPLACE FUNCTION fn_log_publicacion_tarifa()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_origin_iata       varchar(3);
    v_destination_iata  varchar(3);
    v_airline_name      varchar(150);
BEGIN
    SELECT iata_code INTO v_origin_iata FROM airport WHERE airport_id = NEW.origin_airport_id;
    SELECT iata_code INTO v_destination_iata FROM airport WHERE airport_id = NEW.destination_airport_id;
    SELECT airline_name INTO v_airline_name FROM airline WHERE airline_id = NEW.airline_id;

    INSERT INTO fare_publication_log (
        fare_id,
        fare_code,
        airline_id,
        base_amount,
        origin_iata,
        destination_iata,
        log_message
    )
    VALUES (
        NEW.fare_id,
        NEW.fare_code,
        NEW.airline_id,
        NEW.base_amount,
        v_origin_iata,
        v_destination_iata,
        'Nueva tarifa publicada: ' || NEW.fare_code ||
        ' para ruta ' || COALESCE(v_origin_iata,'?') || '-' || COALESCE(v_destination_iata,'?') ||
        ' por ' || COALESCE(v_airline_name,'N/A') ||
        '. Monto base: ' || NEW.base_amount
    );

    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_after_fare_publicacion
AFTER INSERT ON fare
FOR EACH ROW
EXECUTE FUNCTION fn_log_publicacion_tarifa();


-- ============================================================
-- REQUERIMIENTO 3: Procedimiento almacenado
-- Registra y publica una tarifa para una ruta y clase específica.
-- ============================================================

CREATE OR REPLACE PROCEDURE sp_publicar_tarifa(
    p_airline_code          varchar,
    p_origin_iata           varchar,
    p_destination_iata      varchar,
    p_fare_class_code       varchar,
    p_currency_code         varchar,
    p_fare_code             varchar,
    p_base_amount           numeric,
    p_valid_from            date,
    p_valid_to              date     DEFAULT NULL,
    p_baggage_allowance_qty integer  DEFAULT 0
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_airline_id        uuid;
    v_origin_id         uuid;
    v_destination_id    uuid;
    v_fare_class_id     uuid;
    v_currency_id       uuid;
BEGIN
    -- Buscar aerolínea
    SELECT airline_id INTO v_airline_id FROM airline WHERE airline_code = p_airline_code;
    IF v_airline_id IS NULL THEN RAISE EXCEPTION 'Aerolínea no encontrada: %', p_airline_code; END IF;

    -- Buscar aeropuerto origen
    SELECT airport_id INTO v_origin_id FROM airport WHERE iata_code = p_origin_iata;
    IF v_origin_id IS NULL THEN RAISE EXCEPTION 'Aeropuerto origen no encontrado: %', p_origin_iata; END IF;

    -- Buscar aeropuerto destino
    SELECT airport_id INTO v_destination_id FROM airport WHERE iata_code = p_destination_iata;
    IF v_destination_id IS NULL THEN RAISE EXCEPTION 'Aeropuerto destino no encontrado: %', p_destination_iata; END IF;

    IF v_origin_id = v_destination_id THEN
        RAISE EXCEPTION 'El aeropuerto origen y destino no pueden ser iguales.';
    END IF;

    -- Buscar clase tarifaria
    SELECT fare_class_id INTO v_fare_class_id FROM fare_class WHERE fare_class_code = p_fare_class_code;
    IF v_fare_class_id IS NULL THEN RAISE EXCEPTION 'Clase tarifaria no encontrada: %', p_fare_class_code; END IF;

    -- Buscar moneda
    SELECT currency_id INTO v_currency_id FROM currency WHERE iso_currency_code = p_currency_code;
    IF v_currency_id IS NULL THEN RAISE EXCEPTION 'Moneda no encontrada: %', p_currency_code; END IF;

    -- Publicar la tarifa (dispara el trigger)
    INSERT INTO fare (
        airline_id,
        origin_airport_id,
        destination_airport_id,
        fare_class_id,
        currency_id,
        fare_code,
        base_amount,
        valid_from,
        valid_to,
        baggage_allowance_qty
    )
    VALUES (
        v_airline_id,
        v_origin_id,
        v_destination_id,
        v_fare_class_id,
        v_currency_id,
        p_fare_code,
        p_base_amount,
        p_valid_from,
        p_valid_to,
        p_baggage_allowance_qty
    );

    RAISE NOTICE 'Tarifa % publicada para ruta %-% con monto %', p_fare_code, p_origin_iata, p_destination_iata, p_base_amount;
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
    v_addr1_id        uuid;
    v_addr2_id        uuid;
    v_airline_id      uuid;
    v_mfr_id          uuid;
    v_model_id        uuid;
    v_cabin_class_id  uuid;
    v_fare_class_id   uuid;
    v_currency_id     uuid;
BEGIN
    INSERT INTO continent(continent_code, continent_name) VALUES ('AT','Atlántico') RETURNING continent_id INTO v_continent_id;
    INSERT INTO country(continent_id, iso_alpha2, iso_alpha3, country_name) VALUES (v_continent_id,'BR','BRA','Brasil') RETURNING country_id INTO v_country_id;
    INSERT INTO time_zone(time_zone_name, utc_offset_minutes) VALUES ('America/Sao_Paulo',-180) RETURNING time_zone_id INTO v_tz_id;
    INSERT INTO state_province(country_id, state_code, state_name) VALUES (v_country_id,'SP','São Paulo') RETURNING state_province_id INTO v_state_id;
    INSERT INTO city(state_province_id, time_zone_id, city_name) VALUES (v_state_id, v_tz_id,'São Paulo') RETURNING city_id INTO v_city_id;
    INSERT INTO district(city_id, district_name) VALUES (v_city_id,'Guarulhos') RETURNING district_id INTO v_district_id;
    INSERT INTO address(district_id, address_line_1) VALUES (v_district_id,'Aeroporto GRU') RETURNING address_id INTO v_addr1_id;
    INSERT INTO address(district_id, address_line_1) VALUES (v_district_id,'Aeroporto RIO') RETURNING address_id INTO v_addr2_id;
    INSERT INTO airline(home_country_id, airline_code, airline_name, iata_code, icao_code)
    VALUES (v_country_id,'G3','Gol Linhas Aéreas','G3','GLO') RETURNING airline_id INTO v_airline_id;
    INSERT INTO airport(address_id, airport_name, iata_code, icao_code) VALUES (v_addr1_id,'Guarulhos','GRU','SBGR') RETURNING airport_id;
    INSERT INTO airport(address_id, airport_name, iata_code, icao_code) VALUES (v_addr2_id,'Galeão','GIG','SBGL') RETURNING airport_id;
    INSERT INTO cabin_class(class_code, class_name) VALUES ('YB','Economy BR') RETURNING cabin_class_id INTO v_cabin_class_id;
    INSERT INTO fare_class(cabin_class_id, fare_class_code, fare_class_name) VALUES (v_cabin_class_id,'YB1','Economy BR Flex') RETURNING fare_class_id INTO v_fare_class_id;
    INSERT INTO currency(iso_currency_code, currency_name, currency_symbol) VALUES ('BRL','Real Brasileiro','R$') RETURNING currency_id INTO v_currency_id;

    RAISE NOTICE 'Datos listos para publicar tarifa.';
    RAISE NOTICE 'Ejecutar: CALL sp_publicar_tarifa(''G3'',''GRU'',''GIG'',''YB1'',''BRL'',''G3GRUGIG01'', 299.90, ''2026-01-01'', ''2026-12-31'', 1);';
END;
$$;


-- Invocar el procedimiento:
-- CALL sp_publicar_tarifa(
--     'G3',
--     'GRU',
--     'GIG',
--     'YB1',
--     'BRL',
--     'G3GRUGIG01',
--     299.90,
--     '2026-01-01',
--     '2026-12-31',
--     1
-- );


-- Consultas de validación
SELECT f.fare_code, f.base_amount, f.valid_from, f.valid_to FROM fare f ORDER BY f.created_at DESC LIMIT 5;

-- Ver log de publicación generado por el trigger
SELECT fpl.fare_code, fpl.base_amount, fpl.origin_iata, fpl.destination_iata, fpl.logged_at, fpl.log_message
FROM fare_publication_log fpl ORDER BY fpl.logged_at DESC LIMIT 5;
