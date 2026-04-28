-- ============================================================
-- EJERCICIO 10 - Identidad de pasajeros, documentos y contacto
-- ============================================================

-- ============================================================
-- REQUERIMIENTO 1: Consulta INNER JOIN (mínimo 5 tablas)
-- Persona, tipo, documento, tipo documento, contacto,
-- tipo contacto y reserva.
-- ============================================================

SELECT
    p.first_name || ' ' || p.last_name      AS persona,
    pt.type_name                            AS tipo_persona,
    dt.type_name                            AS tipo_documento,
    pd.document_number                      AS numero_documento,
    pd.issued_on                            AS fecha_emision,
    pd.expires_on                           AS fecha_vencimiento,
    ct.type_name                            AS tipo_contacto,
    pc.contact_value                        AS valor_contacto,
    pc.is_primary                           AS es_primario,
    r.reservation_code                      AS reserva_relacionada,
    rp.passenger_sequence_no                AS secuencia_pasajero
FROM person p
    INNER JOIN person_type         pt  ON pt.person_type_id       = p.person_type_id
    INNER JOIN person_document     pd  ON pd.person_id            = p.person_id
    INNER JOIN document_type       dt  ON dt.document_type_id     = pd.document_type_id
    INNER JOIN person_contact      pc  ON pc.person_id            = p.person_id
    INNER JOIN contact_type        ct  ON ct.contact_type_id      = pc.contact_type_id
    INNER JOIN reservation_passenger rp ON rp.person_id           = p.person_id
    INNER JOIN reservation         r   ON r.reservation_id        = rp.reservation_id
ORDER BY p.last_name, p.first_name, dt.type_name;


-- ============================================================
-- REQUERIMIENTO 2: Trigger AFTER INSERT sobre person_document
-- Al registrar un documento nuevo, se crea un log de
-- identidad como evidencia verificable de la actualización.
-- ============================================================

CREATE TABLE IF NOT EXISTS person_identity_log (
    log_id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    person_id           uuid NOT NULL,
    event_type          varchar(30) NOT NULL,  -- 'DOCUMENT_ADDED' | 'CONTACT_ADDED'
    reference_id        uuid NOT NULL,         -- person_document_id o person_contact_id
    logged_at           timestamptz NOT NULL DEFAULT now(),
    log_message         text
);

CREATE OR REPLACE FUNCTION fn_log_nuevo_documento()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_person_name   text;
    v_doc_type_name varchar(80);
BEGIN
    SELECT first_name || ' ' || last_name INTO v_person_name
    FROM person WHERE person_id = NEW.person_id;

    SELECT type_name INTO v_doc_type_name
    FROM document_type WHERE document_type_id = NEW.document_type_id;

    INSERT INTO person_identity_log (
        person_id,
        event_type,
        reference_id,
        log_message
    )
    VALUES (
        NEW.person_id,
        'DOCUMENT_ADDED',
        NEW.person_document_id,
        'Documento "' || COALESCE(v_doc_type_name,'N/A') || '" (N° ' || NEW.document_number ||
        ') registrado para la persona "' || COALESCE(v_person_name,'N/A') || '"'
    );

    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_after_person_document_log
AFTER INSERT ON person_document
FOR EACH ROW
EXECUTE FUNCTION fn_log_nuevo_documento();


-- ============================================================
-- REQUERIMIENTO 3: Procedimiento almacenado
-- Registra un nuevo documento para una persona existente.
-- ============================================================

CREATE OR REPLACE PROCEDURE sp_registrar_documento_persona(
    p_person_id          uuid,
    p_document_type_code varchar,
    p_document_number    varchar,
    p_issuing_country_iso varchar DEFAULT NULL,
    p_issued_on          date     DEFAULT NULL,
    p_expires_on         date     DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_document_type_id   uuid;
    v_issuing_country_id uuid;
BEGIN
    -- Validar que la persona exista
    IF NOT EXISTS (SELECT 1 FROM person WHERE person_id = p_person_id) THEN
        RAISE EXCEPTION 'Persona no encontrada: %', p_person_id;
    END IF;

    -- Buscar tipo de documento
    SELECT document_type_id INTO v_document_type_id
    FROM document_type WHERE type_code = p_document_type_code;

    IF v_document_type_id IS NULL THEN
        RAISE EXCEPTION 'Tipo de documento no encontrado: %', p_document_type_code;
    END IF;

    -- Buscar país emisor si se indicó
    IF p_issuing_country_iso IS NOT NULL THEN
        SELECT country_id INTO v_issuing_country_id
        FROM country WHERE iso_alpha2 = p_issuing_country_iso;

        IF v_issuing_country_id IS NULL THEN
            RAISE EXCEPTION 'País emisor no encontrado: %', p_issuing_country_iso;
        END IF;
    END IF;

    -- Validar fechas si se proporcionaron
    IF p_issued_on IS NOT NULL AND p_expires_on IS NOT NULL AND p_expires_on < p_issued_on THEN
        RAISE EXCEPTION 'La fecha de vencimiento no puede ser anterior a la de emisión.';
    END IF;

    -- Insertar el documento (dispara el trigger)
    INSERT INTO person_document (
        person_id,
        document_type_id,
        issuing_country_id,
        document_number,
        issued_on,
        expires_on
    )
    VALUES (
        p_person_id,
        v_document_type_id,
        v_issuing_country_id,
        p_document_number,
        p_issued_on,
        p_expires_on
    );

    RAISE NOTICE 'Documento % registrado para persona %', p_document_number, p_person_id;
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
    v_person_type_id  uuid;
    v_person_id       uuid;
    v_doc_type_id     uuid;
    v_contact_type_id uuid;
    v_customer_cat_id uuid;
    v_customer_id     uuid;
    v_res_status_id   uuid;
    v_sale_channel_id uuid;
    v_reservation_id  uuid;
BEGIN
    INSERT INTO continent(continent_code, continent_name) VALUES ('PA','Pacífico') RETURNING continent_id INTO v_continent_id;
    INSERT INTO country(continent_id, iso_alpha2, iso_alpha3, country_name) VALUES (v_continent_id,'CL','CHL','Chile') RETURNING country_id INTO v_country_id;
    INSERT INTO time_zone(time_zone_name, utc_offset_minutes) VALUES ('America/Santiago',-240) RETURNING time_zone_id INTO v_tz_id;
    INSERT INTO state_province(country_id, state_code, state_name) VALUES (v_country_id,'RM','Región Metropolitana') RETURNING state_province_id INTO v_state_id;
    INSERT INTO city(state_province_id, time_zone_id, city_name) VALUES (v_state_id, v_tz_id,'Santiago') RETURNING city_id INTO v_city_id;
    INSERT INTO district(city_id, district_name) VALUES (v_city_id,'Pudahuel') RETURNING district_id INTO v_district_id;
    INSERT INTO address(district_id, address_line_1) VALUES (v_district_id,'Aeropuerto SCL') RETURNING address_id INTO v_address_id;
    INSERT INTO airline(home_country_id, airline_code, airline_name, iata_code, icao_code)
    VALUES (v_country_id,'LA','LATAM Chile','LA','LAN') RETURNING airline_id INTO v_airline_id;

    INSERT INTO person_type(type_code, type_name) VALUES ('NAT','Natural') RETURNING person_type_id INTO v_person_type_id;
    INSERT INTO person(person_type_id, first_name, last_name, nationality_country_id)
    VALUES (v_person_type_id,'Valentina','Muñoz', v_country_id) RETURNING person_id INTO v_person_id;

    -- Tipo de documento y contacto
    INSERT INTO document_type(type_code, type_name) VALUES ('PASS','Pasaporte') RETURNING document_type_id INTO v_doc_type_id;
    INSERT INTO contact_type(type_code, type_name) VALUES ('EMAIL','Correo Electrónico') RETURNING contact_type_id INTO v_contact_type_id;
    INSERT INTO person_contact(person_id, contact_type_id, contact_value, is_primary)
    VALUES (v_person_id, v_contact_type_id,'valentina@ejemplo.cl', true);

    -- Reserva de prueba para la consulta
    INSERT INTO customer_category(category_code, category_name) VALUES ('PRE','Preferencial') RETURNING customer_category_id INTO v_customer_cat_id;
    INSERT INTO customer(airline_id, person_id, customer_category_id) VALUES (v_airline_id, v_person_id, v_customer_cat_id) RETURNING customer_id INTO v_customer_id;
    INSERT INTO reservation_status(status_code, status_name) VALUES ('OPN','Abierta') RETURNING reservation_status_id INTO v_res_status_id;
    INSERT INTO sale_channel(channel_code, channel_name) VALUES ('CAL','Call Center') RETURNING sale_channel_id INTO v_sale_channel_id;
    INSERT INTO reservation(booked_by_customer_id, reservation_status_id, sale_channel_id, reservation_code, booked_at)
    VALUES (v_customer_id, v_res_status_id, v_sale_channel_id,'IDTTEST01', now()) RETURNING reservation_id INTO v_reservation_id;
    INSERT INTO reservation_passenger(reservation_id, person_id, passenger_sequence_no, passenger_type)
    VALUES (v_reservation_id, v_person_id, 1,'ADULT');

    RAISE NOTICE 'person_id=%', v_person_id;
    RAISE NOTICE 'Ejecutar: CALL sp_registrar_documento_persona(''%'', ''PASS'', ''CL1234567'', ''CL'', ''2020-03-15'', ''2030-03-14'');', v_person_id;
END;
$$;


-- Invocar el procedimiento:
-- CALL sp_registrar_documento_persona(
--     '<person_id>',
--     'PASS',
--     'CL1234567',
--     'CL',
--     '2020-03-15',
--     '2030-03-14'
-- );


-- Consultas de validación
SELECT pd.document_number, dt.type_name, pd.issued_on, pd.expires_on, p.first_name || ' ' || p.last_name AS persona
FROM person_document pd
    INNER JOIN person        p  ON p.person_id        = pd.person_id
    INNER JOIN document_type dt ON dt.document_type_id = pd.document_type_id
ORDER BY pd.created_at DESC LIMIT 5;

-- Ver log generado por el trigger
SELECT pil.event_type, pil.log_message, pil.logged_at
FROM person_identity_log pil
ORDER BY pil.logged_at DESC LIMIT 5;
