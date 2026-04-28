-- ============================================================
-- EJERCICIO 08 - Auditoría de acceso y asignación de roles
-- ============================================================

-- ============================================================
-- REQUERIMIENTO 1: Consulta INNER JOIN (mínimo 5 tablas)
-- Persona, cuenta de usuario, estado, roles y permisos.
-- ============================================================

SELECT
    p.first_name || ' ' || p.last_name      AS persona,
    ua.username                             AS usuario,
    us.status_name                          AS estado_usuario,
    sr.role_name                            AS rol_asignado,
    ur.assigned_at                          AS fecha_asignacion,
    sp.permission_name                      AS permiso_asociado,
    sp.permission_code                      AS codigo_permiso
FROM person p
    INNER JOIN user_account       ua ON ua.person_id              = p.person_id
    INNER JOIN user_status        us ON us.user_status_id         = ua.user_status_id
    INNER JOIN user_role          ur ON ur.user_account_id        = ua.user_account_id
    INNER JOIN security_role      sr ON sr.security_role_id       = ur.security_role_id
    INNER JOIN role_permission    rp ON rp.security_role_id       = sr.security_role_id
    INNER JOIN security_permission sp ON sp.security_permission_id = rp.security_permission_id
ORDER BY ua.username, sr.role_name, sp.permission_name;


-- ============================================================
-- REQUERIMIENTO 2: Trigger AFTER INSERT sobre user_role
-- Al asignar un rol, se registra un log de auditoría de
-- seguridad como evidencia verificable del cambio.
-- ============================================================

CREATE TABLE IF NOT EXISTS user_role_audit_log (
    audit_log_id        uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_role_id        uuid NOT NULL,
    user_account_id     uuid NOT NULL,
    security_role_id    uuid NOT NULL,
    assigned_at         timestamptz NOT NULL,
    assigned_by         uuid,
    logged_at           timestamptz NOT NULL DEFAULT now(),
    audit_message       text
);

CREATE OR REPLACE FUNCTION fn_auditar_asignacion_rol()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_username      varchar(80);
    v_role_name     varchar(100);
    v_assigned_by   varchar(80);
BEGIN
    -- Obtener nombre de usuario
    SELECT username INTO v_username
    FROM user_account WHERE user_account_id = NEW.user_account_id;

    -- Obtener nombre del rol
    SELECT role_name INTO v_role_name
    FROM security_role WHERE security_role_id = NEW.security_role_id;

    -- Obtener quien asignó si existe
    IF NEW.assigned_by_user_id IS NOT NULL THEN
        SELECT username INTO v_assigned_by
        FROM user_account WHERE user_account_id = NEW.assigned_by_user_id;
    END IF;

    -- Registrar auditoría
    INSERT INTO user_role_audit_log (
        user_role_id,
        user_account_id,
        security_role_id,
        assigned_at,
        assigned_by,
        audit_message
    )
    VALUES (
        NEW.user_role_id,
        NEW.user_account_id,
        NEW.security_role_id,
        NEW.assigned_at,
        NEW.assigned_by_user_id,
        'Rol "' || COALESCE(v_role_name,'N/A') || '" asignado al usuario "' ||
        COALESCE(v_username,'N/A') || '"' ||
        CASE WHEN v_assigned_by IS NOT NULL THEN ' por "' || v_assigned_by || '"' ELSE '' END
    );

    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_after_user_role_auditoria
AFTER INSERT ON user_role
FOR EACH ROW
EXECUTE FUNCTION fn_auditar_asignacion_rol();


-- ============================================================
-- REQUERIMIENTO 3: Procedimiento almacenado
-- Asigna un rol a un usuario existente dentro del sistema.
-- ============================================================

CREATE OR REPLACE PROCEDURE sp_asignar_rol_usuario(
    p_username           varchar,
    p_role_code          varchar,
    p_assigned_by_username varchar DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_user_account_id       uuid;
    v_security_role_id      uuid;
    v_assigned_by_user_id   uuid;
BEGIN
    -- Buscar cuenta de usuario
    SELECT user_account_id INTO v_user_account_id
    FROM user_account WHERE username = p_username;

    IF v_user_account_id IS NULL THEN
        RAISE EXCEPTION 'Usuario no encontrado: %', p_username;
    END IF;

    -- Buscar rol
    SELECT security_role_id INTO v_security_role_id
    FROM security_role WHERE role_code = p_role_code;

    IF v_security_role_id IS NULL THEN
        RAISE EXCEPTION 'Rol no encontrado: %', p_role_code;
    END IF;

    -- Buscar usuario asignador si se indicó
    IF p_assigned_by_username IS NOT NULL THEN
        SELECT user_account_id INTO v_assigned_by_user_id
        FROM user_account WHERE username = p_assigned_by_username;
    END IF;

    -- Verificar si ya tiene el rol asignado
    IF EXISTS (
        SELECT 1 FROM user_role
        WHERE user_account_id = v_user_account_id
          AND security_role_id = v_security_role_id
    ) THEN
        RAISE NOTICE 'El usuario % ya tiene el rol % asignado.', p_username, p_role_code;
        RETURN;
    END IF;

    -- Asignar el rol (dispara el trigger de auditoría)
    INSERT INTO user_role (
        user_account_id,
        security_role_id,
        assigned_at,
        assigned_by_user_id
    )
    VALUES (
        v_user_account_id,
        v_security_role_id,
        now(),
        v_assigned_by_user_id
    );

    RAISE NOTICE 'Rol % asignado al usuario % correctamente.', p_role_code, p_username;
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
    v_person_type_id  uuid;
    v_person1_id      uuid;
    v_person2_id      uuid;
    v_user_status_id  uuid;
    v_ua1_id          uuid;
    v_ua2_id          uuid;
    v_role_id         uuid;
    v_perm_id         uuid;
BEGIN
    INSERT INTO continent(continent_code, continent_name) VALUES ('AN','Antártida') RETURNING continent_id INTO v_continent_id;
    INSERT INTO country(continent_id, iso_alpha2, iso_alpha3, country_name) VALUES (v_continent_id,'AQ','ATA','Territorio Antártico') RETURNING country_id INTO v_country_id;
    INSERT INTO time_zone(time_zone_name, utc_offset_minutes) VALUES ('UTC',0) RETURNING time_zone_id INTO v_tz_id;
    INSERT INTO state_province(country_id, state_code, state_name) VALUES (v_country_id,'ANT','Región Antártica') RETURNING state_province_id INTO v_state_id;
    INSERT INTO city(state_province_id, time_zone_id, city_name) VALUES (v_state_id, v_tz_id,'Base Principal') RETURNING city_id INTO v_city_id;
    INSERT INTO district(city_id, district_name) VALUES (v_city_id,'Distrito Central') RETURNING district_id INTO v_district_id;
    INSERT INTO address(district_id, address_line_1) VALUES (v_district_id,'Calle Principal 1') RETURNING address_id INTO v_address_id;

    INSERT INTO person_type(type_code, type_name) VALUES ('ADM','Administrador') RETURNING person_type_id INTO v_person_type_id;
    INSERT INTO person(person_type_id, first_name, last_name) VALUES (v_person_type_id,'Super','Admin') RETURNING person_id INTO v_person1_id;
    INSERT INTO person(person_type_id, first_name, last_name) VALUES (v_person_type_id,'Nuevo','Operador') RETURNING person_id INTO v_person2_id;
    INSERT INTO user_status(status_code, status_name) VALUES ('ENA','Habilitado') RETURNING user_status_id INTO v_user_status_id;
    INSERT INTO user_account(person_id, user_status_id, username, password_hash)
    VALUES (v_person1_id, v_user_status_id,'superadmin','$hash_admin$') RETURNING user_account_id INTO v_ua1_id;
    INSERT INTO user_account(person_id, user_status_id, username, password_hash)
    VALUES (v_person2_id, v_user_status_id,'newoperator','$hash_oper$') RETURNING user_account_id INTO v_ua2_id;

    INSERT INTO security_role(role_code, role_name, role_description)
    VALUES ('OPS_AGENT','Agente de Operaciones','Acceso a módulos de operaciones') RETURNING security_role_id INTO v_role_id;
    INSERT INTO security_permission(permission_code, permission_name)
    VALUES ('FLIGHT_READ','Lectura de Vuelos') RETURNING security_permission_id INTO v_perm_id;
    INSERT INTO role_permission(security_role_id, security_permission_id) VALUES (v_role_id, v_perm_id);

    RAISE NOTICE 'Datos listos.';
    RAISE NOTICE 'Ejecutar: CALL sp_asignar_rol_usuario(''newoperator'', ''OPS_AGENT'', ''superadmin'');';
END;
$$;


-- Invocar el procedimiento:
-- CALL sp_asignar_rol_usuario('newoperator', 'OPS_AGENT', 'superadmin');


-- Consultas de validación
SELECT
    ur.assigned_at,
    ua.username,
    sr.role_name
FROM user_role ur
    INNER JOIN user_account  ua ON ua.user_account_id   = ur.user_account_id
    INNER JOIN security_role sr ON sr.security_role_id  = ur.security_role_id
ORDER BY ur.assigned_at DESC LIMIT 5;

-- Ver log de auditoría generado por el trigger
SELECT
    ural.audit_message,
    ural.assigned_at,
    ural.logged_at
FROM user_role_audit_log ural
ORDER BY ural.logged_at DESC LIMIT 5;
