USE GD2C2024
GO


------------------------------------------------------------ ELIMINACION PREVENTIVA DE TABLAS ------------------------------------------------------------

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
	tipo_medio_pago NVARCHAR(100),
);

CREATE TABLE LOS_ANTI_PALA.BI_Rubro_Subrubro (
	rubro_subrubro_codigo INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	rubro NVARCHAR(100),
	subrubro NVARCHAR(100),
);

CREATE TABLE LOS_ANTI_PALA.BI_Marca (
    marca_codigo BIGINT PRIMARY KEY NOT NULL,
    marca_descripcion NVARCHAR(50),
);


------------------------------------------------------------ FIN CREACION DE TABLAS ------------------------------------------------------------
