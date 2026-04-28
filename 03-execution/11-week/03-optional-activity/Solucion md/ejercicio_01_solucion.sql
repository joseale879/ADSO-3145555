-- ============================================================
-- EJERCICIO 01 - Flujo de check-in y trazabilidad comercial
-- ============================================================

-- ============================================================
-- REQUERIMIENTO 1: Consulta INNER JOIN (mínimo 5 tablas)
-- Trazabilidad de pasajeros por vuelo: reserva, tiquete,
-- segmento, vuelo y persona.
-- ============================================================

SELECT
    r.reservation_code                          AS codigo_reserva,
    f.flight_number                             AS numero_vuelo,
    f.service_date                              AS fecha_servicio,
    t.ticket_number                             AS numero_tiquete,
    rp.passenger_sequence_no                    AS secuencia_pasajero,
    p.first_name || ' ' || p.last_name          AS nombre_pasajero,
    fs.segment_number                           AS segmento_vuelo,
    fs.scheduled_departure_at                   AS hora_salida_programada
FROM reservation r
    INNER JOIN reservation_passenger rp  ON rp.reservation_id       = r.reservation_id
    INNER JOIN person p                  ON p.person_id              = rp.person_id
    INNER JOIN sale s                    ON s.reservation_id         = r.reservation_id
    INNER JOIN ticket t                  ON t.sale_id                = s.sale_id
                                        AND t.reservation_passenger_id = rp.reservation_passenger_id
    INNER JOIN ticket_segment ts         ON ts.ticket_id             = t.ticket_id
    INNER JOIN flight_segment fs         ON fs.flight_segment_id     = ts.flight_segment_id
    INNER JOIN flight f                  ON f.flight_id              = fs.flight_id
ORDER BY f.service_date, f.flight_number, rp.passenger_sequence_no;


-- ============================================================
-- REQUERIMIENTO 2: Trigger AFTER INSERT sobre check_in
-- Al registrar un check-in, se genera automáticamente
-- el boarding_pass asociado.
-- ============================================================

-- Función que ejecuta el trigger
CREATE OR REPLACE FUNCTION fn_generar_boarding_pass()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO boarding_pass (
        check_in_id,
        boarding_pass_code,
        barcode_value,
        issued_at
    )
    VALUES (
        NEW.check_in_id,
        'BP-' || upper(substring(NEW.check_in_id::text, 1, 8)),
        'BC-' || upper(NEW.check_in_id::text),
        now()
    );

    RETURN NEW;
END;
$$;

-- Trigger AFTER INSERT sobre check_in
CREATE OR REPLACE TRIGGER trg_after_check_in_genera_boarding_pass
AFTER INSERT ON check_in
FOR EACH ROW
EXECUTE FUNCTION fn_generar_boarding_pass();


-- ============================================================
-- REQUERIMIENTO 3: Procedimiento almacenado
-- Registra un check-in para un ticket_segment existente.
-- ============================================================

CREATE OR REPLACE PROCEDURE sp_registrar_check_in(
    p_ticket_segment_id      uuid,
    p_check_in_status_code   varchar,
    p_boarding_group_code    varchar,
    p_user_account_id        uuid
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_check_in_status_id  uuid;
    v_boarding_group_id   uuid;
BEGIN
    -- Obtener el ID del estado de check-in
    SELECT check_in_status_id
    INTO v_check_in_status_id
    FROM check_in_status
    WHERE status_code = p_check_in_status_code;

    IF v_check_in_status_id IS NULL THEN
        RAISE EXCEPTION 'Estado de check-in no encontrado: %', p_check_in_status_code;
    END IF;

    -- Obtener el grupo de abordaje si se indicó
    IF p_boarding_group_code IS NOT NULL THEN
        SELECT boarding_group_id
        INTO v_boarding_group_id
        FROM boarding_group
        WHERE group_code = p_boarding_group_code;
    END IF;

    -- Registrar el check-in (dispara el trigger que crea el boarding_pass)
    INSERT INTO check_in (
        ticket_segment_id,
        check_in_status_id,
        boarding_group_id,
        checked_in_by_user_id,
        checked_in_at
    )
    VALUES (
        p_ticket_segment_id,
        v_check_in_status_id,
        v_boarding_group_id,
        p_user_account_id,
        now()
    );

    RAISE NOTICE 'Check-in registrado correctamente para ticket_segment_id: %', p_ticket_segment_id;
END;
$$;


-- ============================================================
-- SCRIPT DE PRUEBA Y VALIDACIÓN
-- ============================================================

-- 1. Preparar datos base necesarios para la prueba
DO $$
DECLARE
    v_continent_id         uuid;
    v_country_id           uuid;
    v_state_id             uuid;
    v_city_id              uuid;
    v_district_id          uuid;
    v_address_id           uuid;
    v_tz_id                uuid;
    v_airline_id           uuid;
    v_aircraft_mfr_id      uuid;
    v_aircraft_model_id    uuid;
    v_aircraft_id          uuid;
    v_airport_orig_id      uuid;
    v_airport_dest_id      uuid;
    v_flight_status_id     uuid;
    v_flight_id            uuid;
    v_flight_segment_id    uuid;
    v_person_type_id       uuid;
    v_person_id            uuid;
    v_customer_cat_id      uuid;
    v_customer_id          uuid;
    v_res_status_id        uuid;
    v_sale_channel_id      uuid;
    v_reservation_id       uuid;
    v_res_passenger_id     uuid;
    v_cabin_class_id       uuid;
    v_fare_class_id        uuid;
    v_currency_id          uuid;
    v_fare_id              uuid;
    v_ticket_status_id     uuid;
    v_sale_id              uuid;
    v_ticket_id            uuid;
    v_ticket_segment_id    uuid;
    v_check_in_status_id   uuid;
    v_user_status_id       uuid;
    v_user_account_id      uuid;
    v_boarding_group_id    uuid;
    v_cabin_id             uuid;
    v_seat_id              uuid;
BEGIN
    -- Geografía
    INSERT INTO continent(continent_code, continent_name) VALUES ('AM','América') RETURNING continent_id INTO v_continent_id;
    INSERT INTO country(continent_id, iso_alpha2, iso_alpha3, country_name) VALUES (v_continent_id,'CO','COL','Colombia') RETURNING country_id INTO v_country_id;
    INSERT INTO time_zone(time_zone_name, utc_offset_minutes) VALUES ('America/Bogota',-300) RETURNING time_zone_id INTO v_tz_id;
    INSERT INTO state_province(country_id, state_code, state_name) VALUES (v_country_id,'CUN','Cundinamarca') RETURNING state_province_id INTO v_state_id;
    INSERT INTO city(state_province_id, time_zone_id, city_name) VALUES (v_state_id, v_tz_id,'Bogotá') RETURNING city_id INTO v_city_id;
    INSERT INTO district(city_id, district_name) VALUES (v_city_id,'El Dorado') RETURNING district_id INTO v_district_id;
    INSERT INTO address(district_id, address_line_1) VALUES (v_district_id,'Aeropuerto El Dorado') RETURNING address_id INTO v_address_id;

    -- Aerolínea
    INSERT INTO airline(home_country_id, airline_code, airline_name, iata_code, icao_code)
    VALUES (v_country_id,'AV','Avianca','AV','AVA') RETURNING airline_id INTO v_airline_id;

    -- Aeronave
    INSERT INTO aircraft_manufacturer(manufacturer_name) VALUES ('Boeing') RETURNING aircraft_manufacturer_id INTO v_aircraft_mfr_id;
    INSERT INTO aircraft_model(aircraft_manufacturer_id, model_code, model_name) VALUES (v_aircraft_mfr_id,'B738','Boeing 737-800') RETURNING aircraft_model_id INTO v_aircraft_model_id;
    INSERT INTO aircraft(airline_id, aircraft_model_id, registration_number, serial_number)
    VALUES (v_airline_id, v_aircraft_model_id,'HK-5272','34567') RETURNING aircraft_id INTO v_aircraft_id;

    -- Cabina y asiento
    INSERT INTO cabin_class(class_code, class_name) VALUES ('Y','Economy') RETURNING cabin_class_id INTO v_cabin_class_id;
    INSERT INTO aircraft_cabin(aircraft_id, cabin_class_id, cabin_code) VALUES (v_aircraft_id, v_cabin_class_id,'Y1') RETURNING aircraft_cabin_id INTO v_cabin_id;
    INSERT INTO aircraft_seat(aircraft_cabin_id, seat_row_number, seat_column_code) VALUES (v_cabin_id, 12,'A') RETURNING aircraft_seat_id INTO v_seat_id;

    -- Aeropuertos
    INSERT INTO airport(address_id, airport_name, iata_code, icao_code)
    VALUES (v_address_id,'El Dorado International','BOG','SKBO') RETURNING airport_id INTO v_airport_orig_id;
    INSERT INTO address(district_id, address_line_1) VALUES (v_district_id,'Aeropuerto MDE') RETURNING address_id INTO v_address_id;
    INSERT INTO airport(address_id, airport_name, iata_code, icao_code)
    VALUES (v_address_id,'José María Córdova','MDE','SKRG') RETURNING airport_id INTO v_airport_dest_id;

    -- Vuelo
    INSERT INTO flight_status(status_code, status_name) VALUES ('SCH','Scheduled') RETURNING flight_status_id INTO v_flight_status_id;
    INSERT INTO flight(airline_id, aircraft_id, flight_status_id, flight_number, service_date)
    VALUES (v_airline_id, v_aircraft_id, v_flight_status_id,'AV9001','2026-05-01') RETURNING flight_id INTO v_flight_id;
    INSERT INTO flight_segment(flight_id, origin_airport_id, destination_airport_id, segment_number, scheduled_departure_at, scheduled_arrival_at)
    VALUES (v_flight_id, v_airport_orig_id, v_airport_dest_id, 1,'2026-05-01 08:00:00-05','2026-05-01 09:00:00-05') RETURNING flight_segment_id INTO v_flight_segment_id;

    -- Persona y cliente
    INSERT INTO person_type(type_code, type_name) VALUES ('PAX','Pasajero') RETURNING person_type_id INTO v_person_type_id;
    INSERT INTO person(person_type_id, first_name, last_name, gender_code)
    VALUES (v_person_type_id,'Carlos','Ramírez','M') RETURNING person_id INTO v_person_id;
    INSERT INTO customer_category(category_code, category_name) VALUES ('STD','Estándar') RETURNING customer_category_id INTO v_customer_cat_id;
    INSERT INTO customer(airline_id, person_id, customer_category_id)
    VALUES (v_airline_id, v_person_id, v_customer_cat_id) RETURNING customer_id INTO v_customer_id;

    -- Reserva
    INSERT INTO reservation_status(status_code, status_name) VALUES ('CON','Confirmed') RETURNING reservation_status_id INTO v_res_status_id;
    INSERT INTO sale_channel(channel_code, channel_name) VALUES ('WEB','Web') RETURNING sale_channel_id INTO v_sale_channel_id;
    INSERT INTO reservation(booked_by_customer_id, reservation_status_id, sale_channel_id, reservation_code, booked_at)
    VALUES (v_customer_id, v_res_status_id, v_sale_channel_id,'TESTAVRES01', now()) RETURNING reservation_id INTO v_reservation_id;
    INSERT INTO reservation_passenger(reservation_id, person_id, passenger_sequence_no, passenger_type)
    VALUES (v_reservation_id, v_person_id, 1,'ADULT') RETURNING reservation_passenger_id INTO v_res_passenger_id;

    -- Tarifa y tiquete
    INSERT INTO currency(iso_currency_code, currency_name, currency_symbol) VALUES ('COP','Peso Colombiano','$') RETURNING currency_id INTO v_currency_id;
    INSERT INTO fare_class(cabin_class_id, fare_class_code, fare_class_name) VALUES (v_cabin_class_id,'Y','Economy Full') RETURNING fare_class_id INTO v_fare_class_id;
    INSERT INTO fare(airline_id, origin_airport_id, destination_airport_id, fare_class_id, currency_id, fare_code, base_amount, valid_from)
    VALUES (v_airline_id, v_airport_orig_id, v_airport_dest_id, v_fare_class_id, v_currency_id,'BOGMDE01', 350000,'2026-01-01') RETURNING fare_id INTO v_fare_id;
    INSERT INTO ticket_status(status_code, status_name) VALUES ('TKT','Ticketed') RETURNING ticket_status_id INTO v_ticket_status_id;
    INSERT INTO sale(reservation_id, currency_id, sale_code, sold_at) VALUES (v_reservation_id, v_currency_id,'SALETST01', now()) RETURNING sale_id INTO v_sale_id;
    INSERT INTO ticket(sale_id, reservation_passenger_id, fare_id, ticket_status_id, ticket_number, issued_at)
    VALUES (v_sale_id, v_res_passenger_id, v_fare_id, v_ticket_status_id,'0792000001', now()) RETURNING ticket_id INTO v_ticket_id;
    INSERT INTO ticket_segment(ticket_id, flight_segment_id, segment_sequence_no)
    VALUES (v_ticket_id, v_flight_segment_id, 1) RETURNING ticket_segment_id INTO v_ticket_segment_id;

    -- Usuario y estados de check-in
    INSERT INTO user_status(status_code, status_name) VALUES ('ACT','Activo') RETURNING user_status_id INTO v_user_status_id;
    INSERT INTO user_account(person_id, user_status_id, username, password_hash)
    VALUES (v_person_id, v_user_status_id,'agent01','hash_test') RETURNING user_account_id INTO v_user_account_id;
    INSERT INTO check_in_status(status_code, status_name) VALUES ('CKD','Checked-In') RETURNING check_in_status_id INTO v_check_in_status_id;
    INSERT INTO boarding_group(group_code, group_name, sequence_no) VALUES ('A','Grupo A',1) RETURNING boarding_group_id INTO v_boarding_group_id;

    RAISE NOTICE 'Datos de prueba creados. ticket_segment_id=%', v_ticket_segment_id;
    RAISE NOTICE 'Ejecutar: CALL sp_registrar_check_in(''%'', ''CKD'', ''A'', ''%'');', v_ticket_segment_id, v_user_account_id;
END;
$$;


-- 2. Invocar el procedimiento (ajustar los UUIDs según salida del bloque anterior)
--    Ejemplo de invocación (los UUIDs son generados dinámicamente arriba):
--
--    CALL sp_registrar_check_in(
--        '<ticket_segment_id>',
--        'CKD',
--        'A',
--        '<user_account_id>'
--    );


-- 3. Consultas de validación
-- Verificar que el check-in fue creado
SELECT
    ci.check_in_id,
    ci.checked_in_at,
    cs.status_name           AS estado_checkin,
    bg.group_name            AS grupo_abordaje
FROM check_in ci
    INNER JOIN check_in_status cs ON cs.check_in_status_id = ci.check_in_status_id
    LEFT  JOIN boarding_group  bg ON bg.boarding_group_id  = ci.boarding_group_id
ORDER BY ci.checked_in_at DESC
LIMIT 5;

-- Verificar que el trigger generó el boarding_pass
SELECT
    bp.boarding_pass_id,
    bp.boarding_pass_code,
    bp.barcode_value,
    bp.issued_at,
    ci.checked_in_at
FROM boarding_pass bp
    INNER JOIN check_in ci ON ci.check_in_id = bp.check_in_id
ORDER BY bp.issued_at DESC
LIMIT 5;
