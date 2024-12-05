USE GD2C2024
GO


------------------------------------------------------------ ELIMINACION PREVENTIVA DE TABLAS ------------------------------------------------------------
EXEC sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT ALL";

IF OBJECT_ID('LOS_ANTI_PALA.BI_Hecho_Publicacion', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.BI_Hecho_Publicacion;
IF OBJECT_ID('LOS_ANTI_PALA.BI_Hecho_Envio', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.BI_Hecho_Envio;
IF OBJECT_ID('LOS_ANTI_PALA.BI_Hecho_Venta', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.BI_Hecho_Venta;
IF OBJECT_ID('LOS_ANTI_PALA.BI_Hecho_Facturacion', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.BI_Hecho_Facturacion;

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
	rango_horario_codigo BIGINT IDENTITY(1,1) PRIMARY KEY NOT NULL,
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
	rubro DECIMAL(18,0),
	subrubro DECIMAL(18,0),
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
	publicacion_vigencia DECIMAL(18,0) NOT NULL DEFAULT 0,
	publicacion_stock_inicial_promedio DECIMAL(18,0) NOT NULL DEFAULT 0,
);

CREATE TABLE LOS_ANTI_PALA.BI_Hecho_Envio (
	tiempo_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Tiempo NOT NULL,
	ubicacion_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Ubicacion NOT NULL,
	tipo_envio_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Tipo_envio NOT NULL,

);

CREATE TABLE LOS_ANTI_PALA.BI_Hecho_Facturacion (
    tiempo_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Tiempo NOT NULL,
    ubicacion_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Ubicacion NOT NULL,
    
);

------------------------------------------------------------ FIN CREACION DE TABLAS ------------------------------------------------------------

---------- Funciones auxiliares ----------

IF OBJECT_ID('LOS_ANTI_PALA.obtenerCuatrimestre', 'FN') IS NOT NULL
BEGIN
    DROP FUNCTION LOS_ANTI_PALA.obtenerCuatrimestre;
END

GO


CREATE FUNCTION LOS_ANTI_PALA.obtenerCuatrimestre (@fecha DATE)
RETURNS SMALLINT
AS BEGIN
DECLARE @nro_cuatrimestre SMALLINT
SET @nro_cuatrimestre =
	CASE
		WHEN MONTH(@fecha) BETWEEN 1 AND 4 THEN 1
		WHEN MONTH(@fecha) BETWEEN 5 AND 8 THEN 2
		WHEN MONTH(@fecha) BETWEEN 9 AND 12 THEN 3
	END

RETURN @nro_cuatrimestre

END
GO

---------- Fin funciones auxiliares ----------

------------------------------------------------------------ MIGRACION DE TABLAS ------------------------------------------------------------


---------- Migracion dimensiones ----------

IF OBJECT_ID('migrar_tabla_bi_rango_etario', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_bi_rango_etario;
GO
CREATE PROCEDURE migrar_tabla_bi_rango_etario
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.BI_Rango_Etario (rango_etario)
	VALUES 
		('< 25'), 
		('25 - 35'), 
		('35 - 50'), 
		('> 50');
	PRINT ('Tabla "Rango etario" del BI migrada')
END

GO

IF OBJECT_ID('migrar_tabla_bi_rango_horario', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_bi_rango_horario;
GO
CREATE PROCEDURE migrar_tabla_bi_rango_horario
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.BI_Rango_Horario (rango)
	VALUES 
		('00:00 - 06:00'), 
		('06:00 - 12:00'), 
		('12:00 - 18:00'), 
		('18:00 - 24:00');
	PRINT ('Tabla "Rango horario" del BI migrada')
END
GO


IF OBJECT_ID('migrar_tabla_bi_tipo_pago', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_bi_tipo_pago;
GO
CREATE PROCEDURE migrar_tabla_bi_tipo_pago
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.BI_Tipo_Medio_Pago (tipo_medio_pago_codigo, tipo_medio_pago)
	SELECT DISTINCT
		p.medio_pago_codigo,
		p.medio_pago_descripcion
	FROM LOS_ANTI_PALA.Medio_de_pago p
	PRINT ('Tabla "Tipo_medio_pago" del BI migrada')
END
GO


IF OBJECT_ID('migrar_tabla_bi_rubro_subrubro', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_bi_rubro_subrubro;
GO
CREATE PROCEDURE migrar_tabla_bi_rubro_subrubro
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.BI_Rubro_Subrubro(rubro, subrubro)
	SELECT DISTINCT 
		r.rubro_codigo,
		s.subrubro_codigo
	FROM LOS_ANTI_PALA.Rubro r JOIN LOS_ANTI_PALA.Subrubro s 
	ON r.rubro_codigo = s.rubro_codigo
	PRINT ('Tabla "Rubro_Subrubro" del BI migrada')
END
GO


IF OBJECT_ID('migrar_tabla_bi_tipo_envio', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_bi_tipo_envio;
GO
CREATE PROCEDURE migrar_tabla_bi_tipo_envio
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.BI_Tipo_Envio(tipo_envio_codigo, tipo_envio_descripcion)
	SELECT DISTINCT 
		e.tipo_envio_codigo,
		e.tipo_envio_descripcion
	FROM LOS_ANTI_PALA.Tipo_Envio e 
	PRINT ('Tabla "Tipo_envio" del BI migrada')
END
GO

IF OBJECT_ID('migrar_tabla_bi_marca', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_bi_marca;
GO
CREATE PROCEDURE migrar_tabla_bi_marca
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.BI_Marca(marca_codigo, marca_descripcion)
	SELECT DISTINCT 
		m.marca_codigo,
		m.marca_descripcion
	FROM LOS_ANTI_PALA.Marca m
	PRINT ('Tabla "Marca" del BI migrada')
END
GO

IF OBJECT_ID('migrar_tabla_bi_ubicacion', 'P') IS NOT NULL
	DROP PROCEDURE migrar_tabla_bi_ubicacion;
GO
CREATE PROCEDURE migrar_tabla_bi_ubicacion
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.BI_Ubicacion(ubicacion_provincia, ubicacion_localidad)
	SELECT DISTINCT 
		d.domicilio_provincia,
		d.domicilio_localidad
		FROM LOS_ANTI_PALA.Domicilio d 

	PRINT ('Tabla "Ubicacion" del BI migrada')
END
GO


IF OBJECT_ID ('migrar_tabla_bi_tiempo', 'P') IS NOT NULL
	DROP PROCEDURE migrar_tabla_bi_tiempo;
GO
CREATE PROCEDURE migrar_tabla_bi_tiempo
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.BI_Tiempo(tiempo_anio,tiempo_cuatrimestre,tiempo_mes)
	SELECT DISTINCT
		YEAR(v.venta_fecha), 
		LOS_ANTI_PALA.obtenerCuatrimestre(v.venta_fecha), 
		MONTH(v.venta_fecha)
	FROM LOS_ANTI_PALA.Venta v

	UNION 

	SELECT DISTINCT 
		YEAR(f.factura_fecha),
		LOS_ANTI_PALA.obtenerCuatrimestre(f.factura_fecha), 
		MONTH(f.factura_fecha) 
	FROM LOS_ANTI_PALA.Factura f

	UNION

	SELECT DISTINCT
		YEAR(p.pago_fecha),
		LOS_ANTI_PALA.obtenerCuatrimestre(p.pago_fecha), 
		MONTH(p.pago_fecha) AS MES
	FROM LOS_ANTI_PALA.Pago P

	--FALTA TERMINAR


PRINT ('Tabla "Tiempo" del BI migrada')
END
GO
---------- Fin migracion dimensiones ----------


---------- Migracion Hechos ----------

IF OBJECT_ID('migrar_tabla_bi_hecho_publicacion', 'P') IS NOT NULL
	DROP PROCEDURE migrar_tabla_bi_hecho_publicacion;
GO
CREATE PROCEDURE migrar_tabla_bi_hecho_publicacion
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.BI_Hecho_Publicacion
				(publicacion_vigencia, publicacion_stock_inicial_promedio, codigo_tiempo, 
				marca_codigo, rubro_subrubro_codigo)
	SELECT
		AVG(DATEDIFF(DAY, p.publicacion_fecha_inicial, p.publicacion_fecha_final)),
		AVG(p.publicacion_stock),
		t.tiempo_codigo,
		m.marca_codigo,
		r.rubro_subrubro_codigo
	FROM LOS_ANTI_PALA.Publicacion p 
	JOIN LOS_ANTI_PALA.BI_Tiempo t
		ON YEAR(p.publicacion_fecha_inicial) = t.tiempo_anio AND MONTH(p.publicacion_fecha_final) = t.tiempo_mes
	JOIN LOS_ANTI_PALA.Producto prod 
		ON p.publicacion_codigo = prod.publicacion_codigo
	JOIN LOS_ANTI_PALA.BI_Rubro_Subrubro r
		ON prod.subrubro_codigo = r.subrubro
	JOIN LOS_ANTI_PALA.Marca m
		ON prod.marca_codigo = m.marca_codigo
	GROUP BY t.tiempo_codigo, m.marca_codigo, r.rubro_subrubro_codigo
	PRINT ('Tabla "Hecho Publicacion" del BI migrada')
END
GO


---------- Fin migracion Hechos ----------


------------------------------------------------------------ FIN MIGRACION DE TABLAS ------------------------------------------------------------

GO
BEGIN TRANSACTION
BEGIN TRY
EXEC migrar_tabla_bi_rubro_subrubro;
EXEC migrar_tabla_bi_marca;
EXEC migrar_tabla_bi_rango_etario;
EXEC migrar_tabla_bi_rango_horario;
EXEC migrar_tabla_bi_tipo_envio;
EXEC migrar_tabla_bi_ubicacion;
EXEC migrar_tabla_bi_tipo_pago;
EXEC migrar_tabla_bi_tiempo;
EXEC migrar_tabla_bi_hecho_publicacion;

	PRINT '--- Todas las tablas del BI fueron migradas correctamente --';
COMMIT TRANSACTION
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION;
		THROW 50001, 'No se migraron correctamente las tablas del BI', 1;
END CATCH


------------------------------------------------------------ VISTAS ------------------------------------------------------------
GO

-- 1) Promedio de tiempo de publicaciones.

CREATE VIEW LOS_ANTI_PALA.BI_promedio_tiempo_publicaciones AS
SELECT
    t.tiempo_anio AS anio,
    t.tiempo_cuatrimestre AS cuatrimestre,
    r.subrubro,
    p.publicacion_vigencia

FROM LOS_ANTI_PALA.BI_Hecho_Publicacion p
	 JOIN LOS_ANTI_PALA.BI_Tiempo t 
		ON p.codigo_tiempo = t.tiempo_codigo
	 JOIN LOS_ANTI_PALA.BI_Rubro_Subrubro r 
		ON p.rubro_subrubro_codigo = r.rubro_subrubro_codigo
GROUP BY 
    t.tiempo_anio,
    t.tiempo_cuatrimestre,
    r.subrubro,
	p.publicacion_vigencia

GO

-- 2) Promedio de Stock Inicial.

CREATE VIEW LOS_ANTI_PALA.promedio_stock_inicial AS
SELECT
	p.publicacion_stock_inicial_promedio,
	p.marca_codigo,
	t.tiempo_anio
	
FROM LOS_ANTI_PALA.BI_Hecho_Publicacion p 
JOIN LOS_ANTI_PALA.BI_Tiempo t ON p.codigo_tiempo = t.tiempo_codigo
GROUP BY p.publicacion_stock_inicial_promedio, p.marca_codigo, t.tiempo_anio
