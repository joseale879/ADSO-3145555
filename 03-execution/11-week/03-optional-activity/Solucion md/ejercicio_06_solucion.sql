-- ============================================================
-- EJERCICIO 06 - Retrasos operativos por segmento de vuelo
-- ============================================================

-- ============================================================
-- REQUERIMIENTO 1: Consulta INNER JOIN (mínimo 5 tablas)
-- Aerolínea, vuelo, estado, segmento, aeropuertos y demora.
-- ============================================================

SELECT
    al.airline_name                 AS aerolinea,
    f.flight_number                 AS numero_vuelo,
    f.service_date                  AS fecha_servicio,
    fs2.status_name                 AS estado_vuelo,
    fs.segment_number               AS segmento,
    ao.airport_name                 AS aeropuerto_origen,
    ao.iata_code                    AS iata_origen,
    ad.airport_name                 AS aeropuerto_destino,
    ad.iata_code                    AS iata_destino,
    fd.delay_minutes                AS minutos_demora,
    drt.reason_name                 AS motivo_retraso,
    fd.reported_at                  AS fecha_reporte,
    fd.notes                        AS notas
FROM flight_delay fd
    INNER JOIN flight_segment      fs  ON fs.flight_segment_id       = fd.flight_segment_id
    INNER JOIN flight              f   ON f.flight_id                = fs.flight_id
    INNER JOIN flight_status       fs2 ON fs2.flight_status_id       = f.flight_status_id
    INNER JOIN airline             al  ON al.airline_id              = f.airline_id
    INNER JOIN airport             ao  ON ao.airport_id              = fs.origin_airport_id
    INNER JOIN airport             ad  ON ad.airport_id              = fs.destination_airport_id
    INNER JOIN delay_reason_type   drt ON drt.delay_reason_type_id   = fd.delay_reason_type_id
ORDER BY f.service_date DESC, fd.delay_minutes DESC;


-- ============================================================
-- REQUERIMIENTO 2: Trigger AFTER INSERT sobre flight_delay
-- Al registrarse una demora, actualiza el campo updated_at
-- del flight_segment afectado para reflejar la trazabilidad
-- operacional del impacto del retraso.
-- ============================================================

-- Tabla de log de impacto operativo (evidencia verificable)
CREATE TABLE IF NOT EXISTS flight_delay_impact_log (
    log_id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    flight_delay_id      uuid NOT NULL,
    flight_segment_id    uuid NOT NULL,
    flight_id            uuid NOT NULL,
    delay_minutes        integer NOT NULL,
    logged_at            timestamptz NOT NULL DEFAULT now(),
    impact_description   text
);

CREATE OR REPLACE FUNCTION fn_registrar_impacto_demora()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_flight_id     uuid;
    v_flight_number varchar(12);
BEGIN
    -- Obtener el vuelo relacionado al segmento
    SELECT flight_id INTO v_flight_id
    FROM flight_segment
    WHERE flight_segment_id = NEW.flight_segment_id;

    SELECT flight_number INTO v_flight_number
    FROM flight
    WHERE flight_id = v_flight_id;

    -- Registrar el impacto en el log (efecto verificable)
    INSERT INTO flight_delay_impact_log (
        flight_delay_id,
        flight_segment_id,
        flight_id,
        delay_minutes,
        impact_description
    )
    VALUES (
        NEW.flight_delay_id,
        NEW.flight_segment_id,
        v_flight_id,
        NEW.delay_minutes,
        'Demora de ' || NEW.delay_minutes || ' minutos registrada para vuelo ' ||
        v_flight_number || ' en segmento ' || NEW.flight_segment_id::text
    );

    -- Actualizar updated_at del segmento afectado
    UPDATE flight_segment
    SET updated_at = now()
    WHERE flight_segment_id = NEW.flight_segment_id;

    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_after_flight_delay_impacto
AFTER INSERT ON flight_delay
FOR EACH ROW
EXECUTE FUNCTION fn_registrar_impacto_demora();


-- ============================================================
-- REQUERIMIENTO 3: Procedimiento almacenado
-- Registra una demora para un flight_segment existente.
-- ============================================================

CREATE OR REPLACE PROCEDURE sp_registrar_demora_segmento(
    p_flight_segment_id     uuid,
    p_reason_code           varchar,
    p_delay_minutes         integer,
    p_notes                 text DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_delay_reason_type_id  uuid;
BEGIN
    -- Validar que el segmento exista
    IF NOT EXISTS (SELECT 1 FROM flight_segment WHERE flight_segment_id = p_flight_segment_id) THEN
        RAISE EXCEPTION 'Segmento de vuelo no encontrado: %', p_flight_segment_id;
    END IF;

    -- Obtener tipo de razón de demora
    SELECT delay_reason_type_id INTO v_delay_reason_type_id
    FROM delay_reason_type WHERE reason_code = p_reason_code;

    IF v_delay_reason_type_id IS NULL THEN
        RAISE EXCEPTION 'Código de motivo de demora no encontrado: %', p_reason_code;
    END IF;

    -- Validar minutos
    IF p_delay_minutes <= 0 THEN
        RAISE EXCEPTION 'Los minutos de demora deben ser mayores a cero.';
    END IF;

    -- Insertar la demora (dispara el trigger)
    INSERT INTO flight_delay (
        flight_segment_id,
        delay_reason_type_id,
        reported_at,
        delay_minutes,
        notes
    )
    VALUES (
        p_flight_segment_id,
        v_delay_reason_type_id,
        now(),
        p_delay_minutes,
        p_notes
    );

    RAISE NOTICE 'Demora de % minutos registrada para segmento %', p_delay_minutes, p_flight_segment_id;
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
    v_apt_orig_id     uuid;
    v_apt_dest_id     uuid;
    v_flt_status_id   uuid;
    v_flight_id       uuid;
    v_segment_id      uuid;
    v_delay_reason_id uuid;
BEGIN
    INSERT INTO continent(continent_code, continent_name) VALUES ('NA','Norteamérica') RETURNING continent_id INTO v_continent_id;
    INSERT INTO country(continent_id, iso_alpha2, iso_alpha3, country_name) VALUES (v_continent_id,'MX','MEX','México') RETURNING country_id INTO v_country_id;
    INSERT INTO time_zone(time_zone_name, utc_offset_minutes) VALUES ('America/Mexico_City',-360) RETURNING time_zone_id INTO v_tz_id;
    INSERT INTO state_province(country_id, state_code, state_name) VALUES (v_country_id,'CMX','Ciudad de México') RETURNING state_province_id INTO v_state_id;
    INSERT INTO city(state_province_id, time_zone_id, city_name) VALUES (v_state_id, v_tz_id,'CDMX') RETURNING city_id INTO v_city_id;
    INSERT INTO district(city_id, district_name) VALUES (v_city_id,'Venustiano Carranza') RETURNING district_id INTO v_district_id;
    INSERT INTO address(district_id, address_line_1) VALUES (v_district_id,'Aeropuerto Internacional') RETURNING address_id INTO v_addr1_id;
    INSERT INTO address(district_id, address_line_1) VALUES (v_district_id,'Aeropuerto Guadalajara') RETURNING address_id INTO v_addr2_id;
    INSERT INTO airline(home_country_id, airline_code, airline_name, iata_code, icao_code)
    VALUES (v_country_id,'AM','Aeroméxico','AM','AMX') RETURNING airline_id INTO v_airline_id;
    INSERT INTO aircraft_manufacturer(manufacturer_name) VALUES ('Embraer') RETURNING aircraft_manufacturer_id INTO v_mfr_id;
    INSERT INTO aircraft_model(aircraft_manufacturer_id, model_code, model_name) VALUES (v_mfr_id,'E190','Embraer 190') RETURNING aircraft_model_id INTO v_model_id;
    INSERT INTO aircraft(airline_id, aircraft_model_id, registration_number, serial_number)
    VALUES (v_airline_id, v_model_id,'XA-MX01','E190-001') RETURNING aircraft_id INTO v_aircraft_id;
    INSERT INTO airport(address_id, airport_name, iata_code, icao_code) VALUES (v_addr1_id,'Benito Juárez','MEX','MMMX') RETURNING airport_id INTO v_apt_orig_id;
    INSERT INTO airport(address_id, airport_name, iata_code, icao_code) VALUES (v_addr2_id,'Don Miguel Hidalgo','GDL','MMGL') RETURNING airport_id INTO v_apt_dest_id;
    INSERT INTO flight_status(status_code, status_name) VALUES ('DLY','Delayed') RETURNING flight_status_id INTO v_flt_status_id;
    INSERT INTO flight(airline_id, aircraft_id, flight_status_id, flight_number, service_date)
    VALUES (v_airline_id, v_aircraft_id, v_flt_status_id,'AM0501','2026-06-01') RETURNING flight_id INTO v_flight_id;
    INSERT INTO flight_segment(flight_id, origin_airport_id, destination_airport_id, segment_number, scheduled_departure_at, scheduled_arrival_at)
    VALUES (v_flight_id, v_apt_orig_id, v_apt_dest_id, 1,'2026-06-01 10:00:00-06','2026-06-01 11:30:00-06') RETURNING flight_segment_id INTO v_segment_id;
    INSERT INTO delay_reason_type(reason_code, reason_name) VALUES ('WTH','Condiciones Meteorológicas') RETURNING delay_reason_type_id INTO v_delay_reason_id;

    RAISE NOTICE 'flight_segment_id=%', v_segment_id;
    RAISE NOTICE 'Ejecutar: CALL sp_registrar_demora_segmento(''%'', ''WTH'', 45, ''Niebla en aeropuerto origen'');', v_segment_id;
END;
$$;


-- Invocar el procedimiento:
-- CALL sp_registrar_demora_segmento(
--     '<flight_segment_id>',
--     'WTH',
--     45,
--     'Niebla densa en aeropuerto de origen'
-- );


-- Consultas de validación
-- Ver demoras registradas
SELECT
    fd.delay_minutes,
    fd.reported_at,
    drt.reason_name,
    fd.notes
FROM flight_delay fd
    INNER JOIN delay_reason_type drt ON drt.delay_reason_type_id = fd.delay_reason_type_id
ORDER BY fd.reported_at DESC LIMIT 5;

-- Ver log de impacto generado por el trigger
SELECT
    dil.delay_minutes,
    dil.logged_at,
    dil.impact_description
FROM flight_delay_impact_log dil
ORDER BY dil.logged_at DESC LIMIT 5;
