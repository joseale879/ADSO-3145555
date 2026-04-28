-- ============================================================
-- EJERCICIO 07 - Asignación de asientos y equipaje
-- ============================================================

-- ============================================================
-- REQUERIMIENTO 1: Consulta INNER JOIN (mínimo 5 tablas)
-- Tiquete, segmento ticketed, asiento, cabina y equipaje.
-- ============================================================

SELECT
    t.ticket_number                         AS numero_tiquete,
    ts.segment_sequence_no                  AS secuencia_segmento,
    f.flight_number                         AS numero_vuelo,
    cc.class_name                           AS cabina,
    ase.seat_row_number                     AS fila_asiento,
    ase.seat_column_code                    AS columna_asiento,
    sa.assignment_source                    AS fuente_asignacion,
    b.baggage_tag                           AS etiqueta_equipaje,
    b.baggage_type                          AS tipo_equipaje,
    b.baggage_status                        AS estado_equipaje,
    b.weight_kg                             AS peso_kg
FROM ticket t
    INNER JOIN ticket_segment  ts  ON ts.ticket_id            = t.ticket_id
    INNER JOIN flight_segment  fseg ON fseg.flight_segment_id = ts.flight_segment_id
    INNER JOIN flight          f   ON f.flight_id             = fseg.flight_id
    INNER JOIN seat_assignment sa  ON sa.ticket_segment_id    = ts.ticket_segment_id
    INNER JOIN aircraft_seat   ase ON ase.aircraft_seat_id    = sa.aircraft_seat_id
    INNER JOIN aircraft_cabin  ac  ON ac.aircraft_cabin_id    = ase.aircraft_cabin_id
    INNER JOIN cabin_class     cc  ON cc.cabin_class_id       = ac.cabin_class_id
    INNER JOIN baggage         b   ON b.ticket_segment_id     = ts.ticket_segment_id
ORDER BY t.ticket_number, ts.segment_sequence_no;


-- ============================================================
-- REQUERIMIENTO 2: Trigger AFTER INSERT sobre baggage
-- Al registrar un equipaje, se crea un log de trazabilidad
-- aeroportuaria con la información del segmento afectado.
-- ============================================================

CREATE TABLE IF NOT EXISTS baggage_tracking_log (
    log_id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    baggage_id          uuid NOT NULL,
    ticket_segment_id   uuid NOT NULL,
    baggage_tag         varchar(30) NOT NULL,
    baggage_type        varchar(20) NOT NULL,
    weight_kg           numeric(6,2) NOT NULL,
    logged_at           timestamptz NOT NULL DEFAULT now(),
    log_message         text
);

CREATE OR REPLACE FUNCTION fn_log_equipaje()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_flight_number varchar(12);
    v_segment_no    integer;
BEGIN
    -- Obtener información del vuelo para el log
    SELECT f.flight_number, fseg.segment_number
    INTO v_flight_number, v_segment_no
    FROM ticket_segment ts
        INNER JOIN flight_segment fseg ON fseg.flight_segment_id = ts.flight_segment_id
        INNER JOIN flight          f   ON f.flight_id            = fseg.flight_id
    WHERE ts.ticket_segment_id = NEW.ticket_segment_id;

    INSERT INTO baggage_tracking_log (
        baggage_id,
        ticket_segment_id,
        baggage_tag,
        baggage_type,
        weight_kg,
        log_message
    )
    VALUES (
        NEW.baggage_id,
        NEW.ticket_segment_id,
        NEW.baggage_tag,
        NEW.baggage_type,
        NEW.weight_kg,
        'Equipaje ' || NEW.baggage_tag || ' (' || NEW.baggage_type || ') registrado para vuelo ' ||
        COALESCE(v_flight_number, 'N/A') || ' segmento ' || COALESCE(v_segment_no::text, 'N/A') ||
        '. Peso: ' || NEW.weight_kg || ' kg'
    );

    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_after_baggage_log
AFTER INSERT ON baggage
FOR EACH ROW
EXECUTE FUNCTION fn_log_equipaje();


-- ============================================================
-- REQUERIMIENTO 3: Procedimiento almacenado
-- Registra el equipaje para un ticket_segment existente.
-- ============================================================

CREATE OR REPLACE PROCEDURE sp_registrar_equipaje(
    p_ticket_segment_id  uuid,
    p_baggage_tag        varchar,
    p_baggage_type       varchar,
    p_weight_kg          numeric
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validar que el ticket_segment exista
    IF NOT EXISTS (SELECT 1 FROM ticket_segment WHERE ticket_segment_id = p_ticket_segment_id) THEN
        RAISE EXCEPTION 'ticket_segment no encontrado: %', p_ticket_segment_id;
    END IF;

    -- Validar tipo de equipaje
    IF p_baggage_type NOT IN ('CHECKED', 'CARRY_ON', 'SPECIAL') THEN
        RAISE EXCEPTION 'Tipo de equipaje inválido: %. Valores: CHECKED, CARRY_ON, SPECIAL', p_baggage_type;
    END IF;

    -- Validar peso
    IF p_weight_kg <= 0 THEN
        RAISE EXCEPTION 'El peso debe ser mayor a cero.';
    END IF;

    -- Insertar equipaje (dispara el trigger)
    INSERT INTO baggage (
        ticket_segment_id,
        baggage_tag,
        baggage_type,
        baggage_status,
        weight_kg,
        checked_at
    )
    VALUES (
        p_ticket_segment_id,
        p_baggage_tag,
        p_baggage_type,
        'REGISTERED',
        p_weight_kg,
        now()
    );

    RAISE NOTICE 'Equipaje % registrado para ticket_segment %', p_baggage_tag, p_ticket_segment_id;
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
    v_aircraft_id     uuid;
    v_cabin_class_id  uuid;
    v_cabin_id        uuid;
    v_seat_id         uuid;
    v_apt_orig_id     uuid;
    v_apt_dest_id     uuid;
    v_flt_status_id   uuid;
    v_flight_id       uuid;
    v_segment_id      uuid;
    v_person_type_id  uuid;
    v_person_id       uuid;
    v_customer_cat_id uuid;
    v_customer_id     uuid;
    v_res_status_id   uuid;
    v_sale_channel_id uuid;
    v_reservation_id  uuid;
    v_res_pass_id     uuid;
    v_currency_id     uuid;
    v_fare_class_id   uuid;
    v_fare_id         uuid;
    v_ticket_status_id uuid;
    v_sale_id         uuid;
    v_ticket_id       uuid;
    v_ticket_seg_id   uuid;
BEGIN
    INSERT INTO continent(continent_code, continent_name) VALUES ('AF','África') RETURNING continent_id INTO v_continent_id;
    INSERT INTO country(continent_id, iso_alpha2, iso_alpha3, country_name) VALUES (v_continent_id,'ZA','ZAF','Sudáfrica') RETURNING country_id INTO v_country_id;
    INSERT INTO time_zone(time_zone_name, utc_offset_minutes) VALUES ('Africa/Johannesburg',120) RETURNING time_zone_id INTO v_tz_id;
    INSERT INTO state_province(country_id, state_code, state_name) VALUES (v_country_id,'GP','Gauteng') RETURNING state_province_id INTO v_state_id;
    INSERT INTO city(state_province_id, time_zone_id, city_name) VALUES (v_state_id, v_tz_id,'Johannesburgo') RETURNING city_id INTO v_city_id;
    INSERT INTO district(city_id, district_name) VALUES (v_city_id,'OR Tambo') RETURNING district_id INTO v_district_id;
    INSERT INTO address(district_id, address_line_1) VALUES (v_district_id,'OR Tambo Airport') RETURNING address_id INTO v_addr1_id;
    INSERT INTO address(district_id, address_line_1) VALUES (v_district_id,'Cape Town Airport') RETURNING address_id INTO v_addr2_id;
    INSERT INTO airline(home_country_id, airline_code, airline_name, iata_code, icao_code)
    VALUES (v_country_id,'SA','South African Airways','SA','SAA') RETURNING airline_id INTO v_airline_id;
    INSERT INTO aircraft_manufacturer(manufacturer_name) VALUES ('Bombardier') RETURNING aircraft_manufacturer_id INTO v_mfr_id;
    INSERT INTO aircraft_model(aircraft_manufacturer_id, model_code, model_name) VALUES (v_mfr_id,'Q400','Dash 8 Q400') RETURNING aircraft_model_id INTO v_model_id;
    INSERT INTO aircraft(airline_id, aircraft_model_id, registration_number, serial_number)
    VALUES (v_airline_id, v_model_id,'ZS-YAN','Q400-001') RETURNING aircraft_id INTO v_aircraft_id;
    INSERT INTO cabin_class(class_code, class_name) VALUES ('EC','Economy ZA') RETURNING cabin_class_id INTO v_cabin_class_id;
    INSERT INTO aircraft_cabin(aircraft_id, cabin_class_id, cabin_code) VALUES (v_aircraft_id, v_cabin_class_id,'ECZ') RETURNING aircraft_cabin_id INTO v_cabin_id;
    INSERT INTO aircraft_seat(aircraft_cabin_id, seat_row_number, seat_column_code) VALUES (v_cabin_id, 5,'B') RETURNING aircraft_seat_id INTO v_seat_id;
    INSERT INTO airport(address_id, airport_name, iata_code, icao_code) VALUES (v_addr1_id,'O.R. Tambo','JNB','FAOR') RETURNING airport_id INTO v_apt_orig_id;
    INSERT INTO airport(address_id, airport_name, iata_code, icao_code) VALUES (v_addr2_id,'Cape Town International','CPT','FACT') RETURNING airport_id INTO v_apt_dest_id;
    INSERT INTO flight_status(status_code, status_name) VALUES ('OPR','Operational') RETURNING flight_status_id INTO v_flt_status_id;
    INSERT INTO flight(airline_id, aircraft_id, flight_status_id, flight_number, service_date)
    VALUES (v_airline_id, v_aircraft_id, v_flt_status_id,'SA0300','2026-07-01') RETURNING flight_id INTO v_flight_id;
    INSERT INTO flight_segment(flight_id, origin_airport_id, destination_airport_id, segment_number, scheduled_departure_at, scheduled_arrival_at)
    VALUES (v_flight_id, v_apt_orig_id, v_apt_dest_id, 1,'2026-07-01 07:00:00+02','2026-07-01 09:00:00+02') RETURNING flight_segment_id INTO v_segment_id;
    INSERT INTO person_type(type_code, type_name) VALUES ('TUR','Turista') RETURNING person_type_id INTO v_person_type_id;
    INSERT INTO person(person_type_id, first_name, last_name) VALUES (v_person_type_id,'Marie','Dupont') RETURNING person_id INTO v_person_id;
    INSERT INTO customer_category(category_code, category_name) VALUES ('BAS','Basic') RETURNING customer_category_id INTO v_customer_cat_id;
    INSERT INTO customer(airline_id, person_id, customer_category_id) VALUES (v_airline_id, v_person_id, v_customer_cat_id) RETURNING customer_id INTO v_customer_id;
    INSERT INTO reservation_status(status_code, status_name) VALUES ('ACT','Active') RETURNING reservation_status_id INTO v_res_status_id;
    INSERT INTO sale_channel(channel_code, channel_name) VALUES ('TKT','Taquilla') RETURNING sale_channel_id INTO v_sale_channel_id;
    INSERT INTO reservation(booked_by_customer_id, reservation_status_id, sale_channel_id, reservation_code, booked_at)
    VALUES (v_customer_id, v_res_status_id, v_sale_channel_id,'BGGTEST01', now()) RETURNING reservation_id INTO v_reservation_id;
    INSERT INTO reservation_passenger(reservation_id, person_id, passenger_sequence_no, passenger_type)
    VALUES (v_reservation_id, v_person_id, 1,'ADULT') RETURNING reservation_passenger_id INTO v_res_pass_id;
    INSERT INTO currency(iso_currency_code, currency_name, currency_symbol) VALUES ('ZAR','South African Rand','R') RETURNING currency_id INTO v_currency_id;
    INSERT INTO fare_class(cabin_class_id, fare_class_code, fare_class_name) VALUES (v_cabin_class_id,'EZ','Economy ZA Full') RETURNING fare_class_id INTO v_fare_class_id;
    INSERT INTO fare(airline_id, origin_airport_id, destination_airport_id, fare_class_id, currency_id, fare_code, base_amount, valid_from)
    VALUES (v_airline_id, v_apt_orig_id, v_apt_dest_id, v_fare_class_id, v_currency_id,'JNBCPT01', 1500,'2026-01-01') RETURNING fare_id INTO v_fare_id;
    INSERT INTO ticket_status(status_code, status_name) VALUES ('ISS','Issued') RETURNING ticket_status_id INTO v_ticket_status_id;
    INSERT INTO sale(reservation_id, currency_id, sale_code, sold_at) VALUES (v_reservation_id, v_currency_id,'SLE07TST', now()) RETURNING sale_id INTO v_sale_id;
    INSERT INTO ticket(sale_id, reservation_passenger_id, fare_id, ticket_status_id, ticket_number, issued_at)
    VALUES (v_sale_id, v_res_pass_id, v_fare_id, v_ticket_status_id,'0790070001', now()) RETURNING ticket_id INTO v_ticket_id;
    INSERT INTO ticket_segment(ticket_id, flight_segment_id, segment_sequence_no)
    VALUES (v_ticket_id, v_segment_id, 1) RETURNING ticket_segment_id INTO v_ticket_seg_id;

    -- Asignar asiento
    INSERT INTO seat_assignment(ticket_segment_id, flight_segment_id, aircraft_seat_id, assigned_at, assignment_source)
    VALUES (v_ticket_seg_id, v_segment_id, v_seat_id, now(), 'CUSTOMER');

    RAISE NOTICE 'ticket_segment_id=%', v_ticket_seg_id;
    RAISE NOTICE 'Ejecutar: CALL sp_registrar_equipaje(''%'', ''BAG-ZA-00001'', ''CHECKED'', 23.5);', v_ticket_seg_id;
END;
$$;


-- Invocar el procedimiento:
-- CALL sp_registrar_equipaje(
--     '<ticket_segment_id>',
--     'BAG-ZA-00001',
--     'CHECKED',
--     23.5
-- );


-- Consultas de validación
SELECT b.baggage_tag, b.baggage_type, b.baggage_status, b.weight_kg, b.checked_at
FROM baggage b ORDER BY b.created_at DESC LIMIT 5;

SELECT btl.baggage_tag, btl.baggage_type, btl.weight_kg, btl.logged_at, btl.log_message
FROM baggage_tracking_log btl ORDER BY btl.logged_at DESC LIMIT 5;
