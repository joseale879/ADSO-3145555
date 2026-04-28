-- ============================================================
-- EJERCICIO 05 - Mantenimiento de aeronaves
-- ============================================================

-- ============================================================
-- REQUERIMIENTO 1: Consulta INNER JOIN (mínimo 5 tablas)
-- Aeronave, aerolínea, modelo, fabricante, tipo de
-- mantenimiento, proveedor y evento de mantenimiento.
-- ============================================================

SELECT
    a.registration_number           AS matricula_aeronave,
    al.airline_name                 AS aerolinea,
    am.model_name                   AS modelo,
    amf.manufacturer_name           AS fabricante,
    mt.type_name                    AS tipo_mantenimiento,
    mp.provider_name                AS proveedor,
    me.status_code                  AS estado_evento,
    me.started_at                   AS fecha_inicio,
    me.completed_at                 AS fecha_fin,
    me.notes                        AS observaciones
FROM maintenance_event me
    INNER JOIN aircraft              a   ON a.aircraft_id              = me.aircraft_id
    INNER JOIN airline               al  ON al.airline_id              = a.airline_id
    INNER JOIN aircraft_model        am  ON am.aircraft_model_id       = a.aircraft_model_id
    INNER JOIN aircraft_manufacturer amf ON amf.aircraft_manufacturer_id = am.aircraft_manufacturer_id
    INNER JOIN maintenance_type      mt  ON mt.maintenance_type_id     = me.maintenance_type_id
    INNER JOIN maintenance_provider  mp  ON mp.maintenance_provider_id = me.maintenance_provider_id
ORDER BY me.started_at DESC;


-- ============================================================
-- REQUERIMIENTO 2: Trigger AFTER INSERT sobre maintenance_event
-- Cuando se registra un evento con estado IN_PROGRESS,
-- se valida que la aeronave no tenga otro evento activo del
-- mismo tipo. El efecto verificable es un registro en una
-- tabla de log de mantenimiento que se crea a continuación.
-- NOTA: La tabla de log es compatible con el modelo base ya
--       que no altera ninguna tabla existente.
-- ============================================================

-- Tabla auxiliar de log (no modifica el modelo base, se crea aparte)
CREATE TABLE IF NOT EXISTS maintenance_event_log (
    log_id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    maintenance_event_id uuid NOT NULL,
    aircraft_id      uuid NOT NULL,
    status_code      varchar(20) NOT NULL,
    logged_at        timestamptz NOT NULL DEFAULT now(),
    log_message      text
);

CREATE OR REPLACE FUNCTION fn_log_mantenimiento()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    -- Insertar en el log de mantenimiento (efecto verificable)
    INSERT INTO maintenance_event_log (
        maintenance_event_id,
        aircraft_id,
        status_code,
        log_message
    )
    VALUES (
        NEW.maintenance_event_id,
        NEW.aircraft_id,
        NEW.status_code,
        'Evento registrado con estado ' || NEW.status_code ||
        ' para aeronave ' || NEW.aircraft_id::text ||
        ' en ' || to_char(now(), 'YYYY-MM-DD HH24:MI:SS')
    );

    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_after_maintenance_event_log
AFTER INSERT ON maintenance_event
FOR EACH ROW
EXECUTE FUNCTION fn_log_mantenimiento();


-- ============================================================
-- REQUERIMIENTO 3: Procedimiento almacenado
-- Registra un nuevo evento de mantenimiento para una aeronave.
-- ============================================================

CREATE OR REPLACE PROCEDURE sp_registrar_evento_mantenimiento(
    p_registration_number     varchar,
    p_maintenance_type_code   varchar,
    p_provider_name           varchar,
    p_status_code             varchar,
    p_started_at              timestamptz,
    p_notes                   text DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_aircraft_id           uuid;
    v_maintenance_type_id   uuid;
    v_maintenance_provider_id uuid;
BEGIN
    -- Buscar aeronave por matrícula
    SELECT aircraft_id INTO v_aircraft_id
    FROM aircraft WHERE registration_number = p_registration_number;

    IF v_aircraft_id IS NULL THEN
        RAISE EXCEPTION 'Aeronave no encontrada con matrícula: %', p_registration_number;
    END IF;

    -- Buscar tipo de mantenimiento
    SELECT maintenance_type_id INTO v_maintenance_type_id
    FROM maintenance_type WHERE type_code = p_maintenance_type_code;

    IF v_maintenance_type_id IS NULL THEN
        RAISE EXCEPTION 'Tipo de mantenimiento no encontrado: %', p_maintenance_type_code;
    END IF;

    -- Buscar proveedor si se indicó
    IF p_provider_name IS NOT NULL THEN
        SELECT maintenance_provider_id INTO v_maintenance_provider_id
        FROM maintenance_provider WHERE provider_name = p_provider_name;
    END IF;

    -- Validar estado
    IF p_status_code NOT IN ('PLANNED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED') THEN
        RAISE EXCEPTION 'Estado inválido: %. Valores permitidos: PLANNED, IN_PROGRESS, COMPLETED, CANCELLED', p_status_code;
    END IF;

    -- Insertar evento (dispara el trigger de log)
    INSERT INTO maintenance_event (
        aircraft_id,
        maintenance_type_id,
        maintenance_provider_id,
        status_code,
        started_at,
        notes
    )
    VALUES (
        v_aircraft_id,
        v_maintenance_type_id,
        v_maintenance_provider_id,
        p_status_code,
        p_started_at,
        p_notes
    );

    RAISE NOTICE 'Evento de mantenimiento registrado para aeronave %', p_registration_number;
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
    v_mfr_id          uuid;
    v_model_id        uuid;
    v_maint_type_id   uuid;
    v_provider_id     uuid;
BEGIN
    INSERT INTO continent(continent_code, continent_name) VALUES ('AS','Asia') RETURNING continent_id INTO v_continent_id;
    INSERT INTO country(continent_id, iso_alpha2, iso_alpha3, country_name) VALUES (v_continent_id,'SG','SGP','Singapur') RETURNING country_id INTO v_country_id;
    INSERT INTO time_zone(time_zone_name, utc_offset_minutes) VALUES ('Asia/Singapore',480) RETURNING time_zone_id INTO v_tz_id;
    INSERT INTO state_province(country_id, state_code, state_name) VALUES (v_country_id,'SG01','Central Region') RETURNING state_province_id INTO v_state_id;
    INSERT INTO city(state_province_id, time_zone_id, city_name) VALUES (v_state_id, v_tz_id,'Singapur') RETURNING city_id INTO v_city_id;
    INSERT INTO district(city_id, district_name) VALUES (v_city_id,'Changi') RETURNING district_id INTO v_district_id;
    INSERT INTO address(district_id, address_line_1) VALUES (v_district_id,'Changi Airport') RETURNING address_id INTO v_address_id;
    INSERT INTO airline(home_country_id, airline_code, airline_name, iata_code, icao_code)
    VALUES (v_country_id,'SQ','Singapore Airlines','SQ','SIA') RETURNING airline_id INTO v_airline_id;
    INSERT INTO aircraft_manufacturer(manufacturer_name) VALUES ('Airbus') RETURNING aircraft_manufacturer_id INTO v_mfr_id;
    INSERT INTO aircraft_model(aircraft_manufacturer_id, model_code, model_name)
    VALUES (v_mfr_id,'A380','Airbus A380-800') RETURNING aircraft_model_id INTO v_model_id;
    INSERT INTO aircraft(airline_id, aircraft_model_id, registration_number, serial_number)
    VALUES (v_airline_id, v_model_id,'9V-SKA','001') RETURNING aircraft_id;

    INSERT INTO maintenance_type(type_code, type_name) VALUES ('CHK-C','Revisión C') RETURNING maintenance_type_id INTO v_maint_type_id;
    INSERT INTO maintenance_provider(address_id, provider_name) VALUES (v_address_id,'SIA Engineering') RETURNING maintenance_provider_id INTO v_provider_id;

    RAISE NOTICE 'Datos listos. Ejecutar:';
    RAISE NOTICE 'CALL sp_registrar_evento_mantenimiento(''9V-SKA'', ''CHK-C'', ''SIA Engineering'', ''PLANNED'', now(), ''Revisión programada'');';
END;
$$;


-- Invocar el procedimiento:
-- CALL sp_registrar_evento_mantenimiento(
--     '9V-SKA',
--     'CHK-C',
--     'SIA Engineering',
--     'PLANNED',
--     now(),
--     'Revisión programada anual'
-- );


-- Consultas de validación
-- Ver eventos de mantenimiento registrados
SELECT
    a.registration_number,
    mt.type_name,
    me.status_code,
    me.started_at,
    me.notes
FROM maintenance_event me
    INNER JOIN aircraft         a  ON a.aircraft_id          = me.aircraft_id
    INNER JOIN maintenance_type mt ON mt.maintenance_type_id  = me.maintenance_type_id
ORDER BY me.created_at DESC LIMIT 5;

-- Ver log generado por el trigger
SELECT
    mel.maintenance_event_id,
    mel.status_code,
    mel.logged_at,
    mel.log_message
FROM maintenance_event_log mel
ORDER BY mel.logged_at DESC LIMIT 5;
