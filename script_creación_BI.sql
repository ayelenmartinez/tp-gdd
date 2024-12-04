USE GD2C2024
GO


------------------------------------------------------------ ELIMINACION PREVENTIVA DE TABLAS ------------------------------------------------------------
EXEC sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT ALL";

IF OBJECT_ID('LOS_ANTI_PALA.BI_Hecho_publicacion', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.BI_Hecho_publicacion;
IF OBJECT_ID('LOS_ANTI_PALA.BI_Hecho_Envio', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.BI_Hecho_Envio;
IF OBJECT_ID('LOS_ANTI_PALA.BI_Hecho_Venta', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.BI_Hecho_Venta;

IF OBJECT_ID('LOS_ANTI_PALA.BI_Marca', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.BI_Marca;
IF OBJECT_ID('LOS_ANTI_PALA.BI_Rubro_Subrubro', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.BI_Rubro_Subrubro;
IF OBJECT_ID('LOS_ANTI_PALA.BI_Tipo_medio_pago', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.BI_Tipo_medio_pago;
IF OBJECT_ID('LOS_ANTI_PALA.BI_Tipo_envio', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.BI_Tipo_envio;
IF OBJECT_ID('LOS_ANTI_PALA.BI_Rango_horario', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.BI_Rango_horario;
IF OBJECT_ID('LOS_ANTI_PALA.BI_Rango_etario', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.BI_Rango_etario;
IF OBJECT_ID('LOS_ANTI_PALA.BI_Ubicacion', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.BI_Ubicacion;
IF OBJECT_ID('LOS_ANTI_PALA.BI_Tiempo', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.BI_Tiempo;

EXEC sp_MSforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL";

------------------------------------------------------------ FIN DE ELIMINACION PREVENTIVA DE TABLAS ------------------------------------------------------------

------------------------------------------------------------ CREACION DE TABLAS ------------------------------------------------------------

---------- Dimensiones ----------

CREATE TABLE LOS_ANTI_PALA.BI_Tiempo (
	tiempo_codigo BIGINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	tiempo_anio DECIMAL(18,0),
	tiempo_cuatrimestre INT CHECK (tiempo_cuatrimestre BETWEEN 1 AND 3),
	tiempo_mes DECIMAL(18,0) CHECK (tiempo_mes BETWEEN 1 AND 12),
);

CREATE TABLE LOS_ANTI_PALA.BI_Ubicacion (
	ubicacion_codigo BIGINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	ubicacion_provincia NVARCHAR(100),
	ubicacion_localidad NVARCHAR(100),
);

CREATE TABLE LOS_ANTI_PALA.BI_Rango_Etario (
	rango_etario_codigo BIGINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	rango_etario NVARCHAR(255),
);

CREATE TABLE LOS_ANTI_PALA.BI_Rango_Horario (
	rango_horario_id BIGINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	rango NVARCHAR(50),
);

CREATE TABLE LOS_ANTI_PALA.BI_Tipo_Envio (
	tipo_envio_codigo BIGINT PRIMARY KEY NOT NULL,
	tipo_envio_descripcion NVARCHAR(100),
);

	CREATE TABLE LOS_ANTI_PALA.BI_Tipo_Medio_Pago (
	tipo_medio_pago_codigo BIGINT PRIMARY KEY NOT NULL,
	tipo_medio_pago NVARCHAR(50),
);

CREATE TABLE LOS_ANTI_PALA.BI_Rubro_Subrubro (
	rubro_subrubro_codigo BIGINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	rubro NVARCHAR(50),
	subrubro NVARCHAR(50),
);

CREATE TABLE LOS_ANTI_PALA.BI_Marca (
    marca_codigo BIGINT PRIMARY KEY NOT NULL,
    marca_descripcion NVARCHAR(50),
);

---------- Tablas de hecho ----------

CREATE TABLE LOS_ANTI_PALA.BI_Hecho_Venta (
	tiempo_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Tiempo NOT NULL,
	ubicacion_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Ubicacion NOT NULL,
	rubro_subrubro_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Rubro_subrubro NOT NULL,
	rango_etario_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Rango_etario NOT NULL,
	rango_horario_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Rango_horario NOT NULL,
	tipo_medio_pago_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Tipo_medio_pago NOT NULL,
);

CREATE TABLE LOS_ANTI_PALA.BI_Hecho_Publicacion (
	codigo_tiempo BIGINT REFERENCES LOS_ANTI_PALA.BI_Tiempo NOT NULL,
	rubro_subrubro_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Rubro_Subrubro NOT NULL,
	marca_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Marca NOT NULL,
);

CREATE TABLE LOS_ANTI_PALA.BI_Hecho_Envio (
	tiempo_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Tiempo NOT NULL,
	ubicacion_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Ubicacion NOT NULL,
	tipo_envio_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Tipo_envio NOT NULL,

)


------------------------------------------------------------ FIN CREACION DE TABLAS ------------------------------------------------------------





------------------------------------------------------------ MIGRACION DE TABLAS ------------------------------------------------------------

