-- =====================================================
-- PROYECTO: HIDRO SMART - BASE DE DATOS SEGURA (PostgreSQL)
-- =====================================================

-- 1. Crear base de datos (ejecutar como superusuario o con permisos)
-- CREATE DATABASE "HidroSmart" OWNER postgres ENCODING 'UTF8' LC_COLLATE 'es_CO.utf8' LC_CTYPE 'es_CO.utf8' TEMPLATE template0;
-- \c HidroSmart

-- Nota: si ya estás conectado a la base deseada, omite lo anterior

-- =====================================================
-- Limpieza (drop en orden inverso para evitar errores de FK)
-- =====================================================

DROP TABLE IF EXISTS log_errores         CASCADE;
DROP TABLE IF EXISTS auditoria           CASCADE;
DROP TABLE IF EXISTS sesion_usuario      CASCADE;
DROP TABLE IF EXISTS tokens              CASCADE;
DROP TABLE IF EXISTS alertas             CASCADE;
DROP TABLE IF EXISTS consumo             CASCADE;
DROP TABLE IF EXISTS medidores           CASCADE;
DROP TABLE IF EXISTS configuraciones     CASCADE;
DROP TABLE IF EXISTS hogares             CASCADE;
DROP TABLE IF EXISTS usuario_rol         CASCADE;
DROP TABLE IF EXISTS rol_permiso         CASCADE;
DROP TABLE IF EXISTS usuarios            CASCADE;
DROP TABLE IF EXISTS permisos            CASCADE;
DROP TABLE IF EXISTS roles               CASCADE;
DROP TABLE IF EXISTS politicas_contrasenas CASCADE;

-- =====================================================
-- Tablas
-- =====================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE politicas_contrasenas (
    politica_id       SERIAL PRIMARY KEY,
    min_longitud      INTEGER DEFAULT 12,
    max_longitud      INTEGER DEFAULT 50,
    requiere_mayusculas BOOLEAN DEFAULT TRUE,
    requiere_numeros    BOOLEAN DEFAULT TRUE,
    requiere_simbolos   BOOLEAN DEFAULT TRUE,
    caducidad_dias      INTEGER DEFAULT 90,
    bloqueo_intentos    INTEGER DEFAULT 5,
    bloqueo_minutos     INTEGER DEFAULT 30
);

INSERT INTO politicas_contrasenas DEFAULT VALUES;

CREATE TABLE roles (
    rol_id      SERIAL PRIMARY KEY,
    nombre_rol  VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
);

INSERT INTO roles (nombre_rol, descripcion) VALUES
    ('Admin',           'Administrador total'),
    ('Soporte Técnico', 'Mantenimiento dispositivos'),
    ('Usuario doméstico','Usuario hogar');

CREATE TABLE permisos (
    permiso_id    SERIAL PRIMARY KEY,
    nombre_permiso VARCHAR(50) NOT NULL UNIQUE,
    descripcion    VARCHAR(255)
);

INSERT INTO permisos (nombre_permiso) VALUES
    ('ver_reportes'),
    ('gestionar_dispositivos'),
    ('admin_usuarios'),
    ('configurar_alertas');

CREATE TABLE rol_permiso (
    rol_id     INTEGER NOT NULL,
    permiso_id INTEGER NOT NULL,
    PRIMARY KEY (rol_id, permiso_id),
    FOREIGN KEY (rol_id)     REFERENCES roles(rol_id)     ON DELETE CASCADE,
    FOREIGN KEY (permiso_id) REFERENCES permisos(permiso_id) ON DELETE CASCADE
);

CREATE TABLE usuarios (
    usuario_id         SERIAL PRIMARY KEY,
    nombre_completo    VARCHAR(200) NOT NULL,
    tipo_documento     VARCHAR(20),
    numero_documento   VARCHAR(50) UNIQUE,
    telefono           VARCHAR(20),
    ciudad             VARCHAR(100),
    nombre_usuario     VARCHAR(100) NOT NULL UNIQUE,
    salt               VARCHAR(100) NOT NULL DEFAULT gen_random_uuid()::text,
    contrasena_hash    VARCHAR(255) NOT NULL,          -- pgcrypto → sha512 o argon2
    email              VARCHAR(150) UNIQUE,
    estado_usuario     VARCHAR(20) DEFAULT 'Activo'
        CHECK (estado_usuario IN ('Activo', 'Suspendido', 'Bloqueado')),
    intentos_fallidos  INTEGER DEFAULT 0,
    bloqueado_hasta    TIMESTAMPTZ,
    ultima_cambio_pass TIMESTAMPTZ,
    fecha_creacion     TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    ultimo_acceso      TIMESTAMPTZ
);

CREATE TABLE hogares (
    hogar_id     SERIAL PRIMARY KEY,
    nombre       VARCHAR(100) NOT NULL,
    direccion    VARCHAR(255),
    ciudad       VARCHAR(100),
    estrato      SMALLINT CHECK (estrato BETWEEN 1 AND 6),
    valor_base   DECIMAL(12,2),
    titular_id   INTEGER NOT NULL,
    estado       VARCHAR(20) DEFAULT 'Activo',
    FOREIGN KEY (titular_id) REFERENCES usuarios(usuario_id)
);

CREATE TABLE configuraciones (
    config_id     SERIAL PRIMARY KEY,
    hogar_id      INTEGER UNIQUE NOT NULL,
    consumo_tope  DECIMAL(10,2),
    alertas_config JSONB,                   -- muy recomendado en PostgreSQL
    idioma        VARCHAR(10) DEFAULT 'es',
    moneda        VARCHAR(3)  DEFAULT 'COP',
    FOREIGN KEY (hogar_id) REFERENCES hogares(hogar_id)
);

CREATE TABLE usuario_rol (
    usuario_id       INTEGER NOT NULL,
    rol_id           INTEGER NOT NULL,
    fecha_asignacion TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (usuario_id, rol_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id) ON DELETE CASCADE,
    FOREIGN KEY (rol_id)     REFERENCES roles(rol_id)     ON DELETE CASCADE
);

CREATE TABLE medidores (
    medidor_id        SERIAL PRIMARY KEY,
    hogar_id          INTEGER,
    usuario_id        INTEGER NOT NULL,
    codigo_medidor    VARCHAR(100) UNIQUE NOT NULL,
    tipo              VARCHAR(50),
    ubicacion         VARCHAR(255),
    fecha_instalacion TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    estado_medidor    VARCHAR(50) DEFAULT 'Activo',
    FOREIGN KEY (hogar_id)   REFERENCES hogares(hogar_id),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id)
);

CREATE TABLE consumo (
    consumo_id       SERIAL PRIMARY KEY,
    medidor_id       INTEGER NOT NULL,
    fecha_lectura    TIMESTAMPTZ(3) NOT NULL,   -- precisión de milisegundos
    cantidad_consumida DECIMAL(10,4) NOT NULL,
    actividad        VARCHAR(50) DEFAULT 'General'
        CHECK (actividad IN ('Ducha','Lavado','Cocina','Aseo','Otros')),
    costo_calculado  DECIMAL(10,2),
    flujo            DECIMAL(8,4),               -- litros/min
    FOREIGN KEY (medidor_id) REFERENCES medidores(medidor_id) ON DELETE CASCADE
);

CREATE TABLE alertas (
    alerta_id       SERIAL PRIMARY KEY,
    usuario_id      INTEGER NOT NULL,
    medidor_id      INTEGER,
    hogar_id        INTEGER,
    tipo_alerta     VARCHAR(100),
    mensaje         VARCHAR(500),
    fecha_generacion TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    estado_alerta   VARCHAR(50) DEFAULT 'Pendiente',
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id),
    FOREIGN KEY (medidor_id) REFERENCES medidores(medidor_id),
    FOREIGN KEY (hogar_id)   REFERENCES hogares(hogar_id)
);

CREATE TABLE tokens (
    token_id     SERIAL PRIMARY KEY,
    usuario_id   INTEGER NOT NULL,
    access_token VARCHAR(500) UNIQUE NOT NULL,
    refresh_token VARCHAR(500) UNIQUE,
    expira_en    TIMESTAMPTZ NOT NULL,
    estado       VARCHAR(20) DEFAULT 'Activo',
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id) ON DELETE CASCADE
);

CREATE TABLE auditoria (
    auditoria_id SERIAL PRIMARY KEY,
    usuario_id   INTEGER,
    accion       VARCHAR(255),
    fecha        TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    descripcion  VARCHAR(500),
    ip_origen    VARCHAR(50),
    user_agent   VARCHAR(500),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id)
);

CREATE TABLE sesion_usuario (
    sesion_id    SERIAL PRIMARY KEY,
    usuario_id   INTEGER NOT NULL,
    token_ref    VARCHAR(500),
    fecha_inicio TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    fecha_fin    TIMESTAMPTZ,
    estado_sesion VARCHAR(50)
        CHECK (estado_sesion IN ('Activo','Cerrado','Expirado')),
    ip_origen    VARCHAR(50),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id)
);

CREATE TABLE log_errores (
    error_id     SERIAL PRIMARY KEY,
    usuario_id   INTEGER,
    fecha        TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    tipo_error   VARCHAR(100),
    descripcion  VARCHAR(1000),
    stack_trace  TEXT,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id)
);

-- =====================================================
-- Índices recomendados
-- =====================================================

CREATE INDEX idx_consumo_medidor_fecha    ON consumo(medidor_id, fecha_lectura);
CREATE INDEX idx_consumo_hogar_actividad  ON consumo(medidor_id) INCLUDE (cantidad_consumida, actividad);
CREATE INDEX idx_alertas_hogar            ON alertas(hogar_id);
CREATE INDEX idx_medidores_hogar          ON medidores(hogar_id);
CREATE INDEX idx_auditoria_usuario_fecha  ON auditoria(usuario_id, fecha);
CREATE INDEX idx_tokens_usuario_expira    ON tokens(usuario_id, expira_en);

-- =====================================================
-- FUNCIONES y TRIGGERS (PostgreSQL style)
-- =====================================================

-- Función auxiliar para auditoría
CREATE OR REPLACE FUNCTION fn_auditar_usuarios() RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO auditoria (usuario_id, accion, descripcion, ip_origen)
        VALUES (OLD.usuario_id, 'DELETE', 'Usuario eliminado', inet_client_addr()::text);
        RETURN OLD;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO auditoria (usuario_id, accion, descripcion, ip_origen)
        VALUES (NEW.usuario_id, 'UPDATE', 'Usuario modificado', inet_client_addr()::text);
        RETURN NEW;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO auditoria (usuario_id, accion, descripcion, ip_origen)
        VALUES (NEW.usuario_id, 'INSERT', 'Usuario creado', inet_client_addr()::text);
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_auditoria_usuarios
AFTER INSERT OR UPDATE OR DELETE ON usuarios
FOR EACH ROW EXECUTE FUNCTION fn_auditar_usuarios();

-- =====================================================
-- Procedimiento de login (ejemplo básico)
-- =====================================================

CREATE OR REPLACE PROCEDURE sp_login_usuario(
    p_nombre_usuario  VARCHAR,
    p_contrasena      VARCHAR,
    p_politica_id     INTEGER DEFAULT 1
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_salt            VARCHAR(100);
    v_hash_esperado   VARCHAR(255);
    v_intentos        INTEGER;
    v_bloqueado_hasta TIMESTAMPTZ;
    v_input_hash      BYTEA;
    v_bloqueo_intentos INTEGER;
    v_bloqueo_minutos  INTEGER;
BEGIN
    SELECT 
        salt, contrasena_hash, intentos_fallidos, bloqueado_hasta
    INTO 
        v_salt, v_hash_esperado, v_intentos, v_bloqueado_hasta
    FROM usuarios
    WHERE nombre_usuario = p_nombre_usuario;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Usuario no encontrado';
    END IF;

    IF v_bloqueado_hasta IS NOT NULL AND v_bloqueado_hasta > CURRENT_TIMESTAMP THEN
        RAISE EXCEPTION 'Cuenta bloqueada hasta %', v_bloqueado_hasta;
    END IF;

    -- Ejemplo con SHA512 (recomendado: usar Argon2 en la aplicación)
    v_input_hash := digest(v_salt || p_contrasena, 'sha512');

    IF encode(v_input_hash, 'hex') = v_hash_esperado THEN
        UPDATE usuarios 
        SET intentos_fallidos = 0,
            ultimo_acceso = CURRENT_TIMESTAMP,
            estado_usuario = 'Activo'
        WHERE nombre_usuario = p_nombre_usuario;

        -- Aquí normalmente retornarías datos del usuario o generarías JWT en la app
        RAISE NOTICE 'Login OK';
    ELSE
        UPDATE usuarios 
        SET intentos_fallidos = intentos_fallidos + 1
        WHERE nombre_usuario = p_nombre_usuario;

        SELECT bloqueo_intentos, bloqueo_minutos
        INTO v_bloqueo_intentos, v_bloqueo_minutos
        FROM politicas_contrasenas WHERE politica_id = p_politica_id;

        IF (v_intentos + 1) >= v_bloqueo_intentos THEN
            UPDATE usuarios
            SET estado_usuario = 'Bloqueado',
                bloqueado_hasta = CURRENT_TIMESTAMP + (v_bloqueo_minutos || ' minutes')::interval
            WHERE nombre_usuario = p_nombre_usuario;
        END IF;

        RAISE EXCEPTION 'Credenciales inválidas. Intentos: %', v_intentos + 1;
    END IF;
END;
$$;

-- =====================================================
-- Datos de prueba
-- =====================================================

-- IMPORTANTE: NO uses contraseñas en texto plano en producción
-- Este es solo un ejemplo. Genera el hash real desde tu aplicación.

INSERT INTO usuarios (
    nombre_completo, nombre_usuario, salt, contrasena_hash, email
) VALUES (
    'Admin Hidro',
    'admin',
    'salt123',
    encode(digest('salt123' || 'admin2026!', 'sha512'), 'hex'),
    'admin@hidro.com'
);

-- Prueba (ejecuta en cliente o pgAdmin)
-- CALL sp_login_usuario('admin', 'admin2026!');