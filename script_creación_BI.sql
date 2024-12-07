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
	hecho_venta_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
	venta_monto_total DECIMAL(18,0) NOT NULL DEFAULT 0,
	venta_monto_total_cuotas DECIMAL(18,0) NOT NULL,
	cantidad_ventas BIGINT NOT NULL DEFAULT 0,
	tiempo_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Tiempo NOT NULL,
	ubicacion_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Ubicacion NOT NULL,
	rubro_subrubro_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Rubro_subrubro NOT NULL,
	rango_etario_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Rango_etario NOT NULL,
	tipo_medio_pago_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Tipo_medio_pago NOT NULL,
);

CREATE TABLE LOS_ANTI_PALA.BI_Hecho_Publicacion (
	hecho_publicacion_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
	codigo_tiempo BIGINT REFERENCES LOS_ANTI_PALA.BI_Tiempo NOT NULL,
	rubro_subrubro_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Rubro_Subrubro NOT NULL,
	marca_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Marca NOT NULL,
	publicacion_vigencia DECIMAL(18,0) NOT NULL DEFAULT 0,
	publicacion_stock_inicial_promedio DECIMAL(18,0) NOT NULL DEFAULT 0,
);

CREATE TABLE LOS_ANTI_PALA.BI_Hecho_Envio (
	hecho_envio_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
	tiempo_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Tiempo NOT NULL,
	ubicacion_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Ubicacion NOT NULL,
	tipo_envio_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Tipo_envio NOT NULL,
	envio_cumplido BIT NOT NULL,
	envio_costo DECIMAL (18,2)
);

CREATE TABLE LOS_ANTI_PALA.BI_Hecho_Facturacion (	
	hecho_envio_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
    tiempo_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Tiempo NOT NULL,
	ubicacion_codigo BIGINT REFERENCES LOS_ANTI_PALA.BI_Ubicacion NOT NULL,
    facturacion_concepto NVARCHAR(50),
	factura_total DECIMAL(18,2)
);
------------------------------------------------------------ FIN CREACION DE TABLAS ------------------------------------------------------------

---------- Funciones auxiliares ----------

IF OBJECT_ID('LOS_ANTI_PALA.obtenerCuatrimestre', 'FN') IS NOT NULL
DROP FUNCTION LOS_ANTI_PALA.obtenerCuatrimestre;
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



IF OBJECT_ID('LOS_ANTI_PALA.calcularRangoEtario', 'FN') IS NOT NULL
DROP FUNCTION LOS_ANTI_PALA.calcularRangoEtario;
GO
CREATE FUNCTION LOS_ANTI_PALA.calcularRangoEtario (@fecha DATE)
RETURNS NVARCHAR(11)
AS
BEGIN
DECLARE @edad INT
DECLARE @rango NVARCHAR(11)
SET @edad = CAST(DATEDIFF(DAY, @fecha, GETDATE()) / 365.25 AS INT)

SET @rango =
	CASE
		WHEN @edad < 25 THEN '< 25'
		WHEN @edad >= 25 AND @edad < 35 THEN '25 - 35'
		WHEN @edad >= 35 AND @edad < 50 THEN '35 - 50'
		WHEN @edad >= 50 THEN '> 50'
	END

RETURN @rango
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
		UNION
	SELECT DISTINCT
		v.vendedor_domicilio_provincia,
		v.vendedor_domicilio_localidad
	FROM LOS_ANTI_PALA.Vendedor v
		UNION
	SELECT DISTINCT
		l.localidad_nombre,
		p.provincia_nombre
	FROM LOS_ANTI_PALA.Localidad l JOIN LOS_ANTI_PALA.Provincia p ON l.provincia_codigo = p.provincia_codigo

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
	FROM LOS_ANTI_PALA.Pago p

	UNION 

	SELECT DISTINCT 
		YEAR(u.usuario_fecha_creacion),
		LOS_ANTI_PALA.obtenerCuatrimestre(u.usuario_fecha_creacion),
		MONTH(u.usuario_fecha_creacion)
	FROM LOS_ANTI_PALA.Usuario u

	UNION

	SELECT DISTINCT
		YEAR(c.cliente_fecha_nac),
		LOS_ANTI_PALA.obtenerCuatrimestre(c.cliente_fecha_nac),
		MONTH(c.cliente_fecha_nac)
	FROM LOS_ANTI_PALA.Cliente c
	


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


IF OBJECT_ID('migrar_tabla_bi_hecho_envio', 'P') IS NOT NULL
	DROP PROCEDURE migrar_tabla_bi_hecho_envio;
GO
CREATE PROCEDURE migrar_tabla_bi_hecho_envio
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.BI_Hecho_Envio(tiempo_codigo,	ubicacion_codigo,tipo_envio_codigo, envio_cumplido,envio_costo)
	SELECT DISTINCT
		t.tiempo_codigo,
		u.ubicacion_codigo,
		e.tipo_envio_codigo,
	CASE 
		WHEN DATEDIFF(d,env.envio_fecha_entrega,env.envio_fecha_programada) >= 0 THEN 1
		ELSE 0
	END,
	env.envio_costo

	FROM LOS_ANTI_PALA.Envio env
	JOIN LOS_ANTI_PALA.BI_Tiempo t 
		ON YEAR(env.envio_fecha_entrega) = t.tiempo_anio AND MONTH(env.envio_fecha_entrega) = t.tiempo_mes 
	JOIN LOS_ANTI_PALA.Tipo_Envio te 
		ON env.envio_tipo_envio = te.tipo_envio_codigo 
	JOIN LOS_ANTI_PALA.BI_Tipo_Envio e 
		ON e.tipo_envio_codigo = te.tipo_envio_codigo
	JOIN LOS_ANTI_PALA.Domicilio d ON d.domicilio_codigo = env.domicilio_codigo
	JOIN LOS_ANTI_PALA.BI_Ubicacion u
		ON u.ubicacion_provincia = d.domicilio_provincia AND u.ubicacion_localidad = d.domicilio_localidad

	PRINT ('Tabla "Hecho Envio" del BI migrada')
END
GO

IF OBJECT_ID('migrar_tabla_bi_hecho_facturacion', 'P') IS NOT NULL  
    DROP PROCEDURE migrar_tabla_bi_hecho_facturacion;
GO
CREATE PROCEDURE migrar_tabla_bi_hecho_facturacion
AS
BEGIN

    INSERT INTO LOS_ANTI_PALA.BI_Hecho_Facturacion (
        tiempo_codigo,
        facturacion_concepto,
        factura_total,
		ubicacion_codigo
    )
    SELECT 
        t.tiempo_codigo,
		cf.concepto_factura_codigo,
		SUM(f.factura_total) as Total_facturado,
		ub.ubicacion_codigo

    FROM LOS_ANTI_PALA.BI_Tiempo t
    JOIN LOS_ANTI_PALA.Factura f
		ON t.tiempo_anio = YEAR(f.factura_fecha) AND t.tiempo_mes = MONTH(f.factura_fecha)
	JOIN LOS_ANTI_PALA.Detalle_factura d
		ON f.factura_numero = d.factura_numero
	JOIN LOS_ANTI_PALA.Concepto_factura cf
		ON d.concepto_factura_codigo = cf.concepto_factura_codigo
	JOIN LOS_ANTI_PALA.Vendedor v
		ON f.usuario_codigo = v.usuario_codigo
	JOIN LOS_ANTI_PALA.BI_Ubicacion ub
		ON ub.ubicacion_localidad = v.vendedor_domicilio_localidad 
		AND ub.ubicacion_provincia = v.vendedor_domicilio_provincia
	GROUP BY t.tiempo_codigo, cf.concepto_factura_codigo, ubicacion_codigo
    PRINT ('Tabla "BI_Hecho_Facturacion" migrada correctamente');
    
END;
GO

IF OBJECT_ID('migrar_tabla_bi_hecho_venta', 'P') IS NOT NULL  
    DROP PROCEDURE migrar_tabla_bi_hecho_venta;
GO
CREATE PROCEDURE migrar_tabla_bi_hecho_venta
AS
BEGIN
INSERT INTO LOS_ANTI_PALA.BI_Hecho_Venta(
		cantidad_ventas, venta_monto_total, venta_monto_total_cuotas,
		rango_etario_codigo, tiempo_codigo, 
		tipo_medio_pago_codigo, ubicacion_codigo, rubro_subrubro_codigo)
SELECT
	COUNT (DISTINCT v.venta_codigo),
	SUM(v.venta_total),
	ISNULL(SUM(p.pago_importe),0),
	re.rango_etario_codigo,
	t.tiempo_codigo,
	mp.medio_pago_codigo,
	u.ubicacion_codigo,
	rs.rubro

FROM LOS_ANTI_PALA.Venta v 
JOIN LOS_ANTI_PALA.Pago p 
	ON v.venta_codigo = p.venta_codigo
JOIN LOS_ANTI_PALA.Cliente c
	ON v.usuario_codigo = c.usuario_codigo
JOIN LOS_ANTI_PALA.BI_Rango_Etario re 
	ON re.rango_etario = LOS_ANTI_PALA.calcularRangoEtario(c.cliente_fecha_nac)
JOIN LOS_ANTI_PALA.BI_Tiempo t
	ON t.tiempo_anio = YEAR(v.venta_fecha) AND t.tiempo_mes = MONTH(v.venta_fecha) AND t.tiempo_cuatrimestre = LOS_ANTI_PALA.obtenerCuatrimestre(v.venta_fecha)
JOIN LOS_ANTI_PALA.Medio_de_pago mp 
	ON mp.medio_pago_codigo = p.medio_pago_codigo
JOIN LOS_ANTI_PALA.Domicilio_por_cliente dc
	ON c.usuario_codigo = dc.usuario_codigo
JOIN LOS_ANTI_PALA.Domicilio d
	ON d.domicilio_codigo = dc.domicilio_codigo
JOIN LOS_ANTI_PALA.BI_Ubicacion u
	ON u.ubicacion_localidad = d.domicilio_localidad AND u.ubicacion_provincia = d.domicilio_provincia
JOIN LOS_ANTI_PALA.Detalle_de_venta dv
	ON dv.venta_codigo = v.venta_codigo
JOIN LOS_ANTI_PALA.Publicacion pub 
	ON pub.publicacion_codigo = dv.publicacion_codigo
JOIN LOS_ANTI_PALA.Rubro rub
	ON rub.rubro_codigo = pub.rubro_codigo
JOIN LOS_ANTI_PALA.BI_Rubro_Subrubro rs 
	ON rs.rubro = rub.rubro_codigo
	
GROUP BY re.rango_etario_codigo, t.tiempo_codigo, mp.medio_pago_codigo, u.ubicacion_codigo, rs.rubro
PRINT ('Tabla "BI_Hecho_Venta" migrada correctamente');
END

---------- Fin migracion Hechos ----------


------------------------------------------------------------ FIN MIGRACION DE TABLAS ------------------------------------------------------------
GO
BEGIN TRANSACTION
BEGIN TRY
EXEC migrar_tabla_bi_rubro_subrubro;
EXEC migrar_tabla_bi_marca;
EXEC migrar_tabla_bi_rango_etario;
EXEC migrar_tabla_bi_tipo_envio;
EXEC migrar_tabla_bi_ubicacion;
EXEC migrar_tabla_bi_tipo_pago;
EXEC migrar_tabla_bi_tiempo;
EXEC migrar_tabla_bi_hecho_publicacion;
EXEC migrar_tabla_bi_hecho_envio;
EXEC migrar_tabla_bi_hecho_facturacion;
EXEC migrar_tabla_bi_hecho_venta;
	PRINT '--- Todas las tablas del BI fueron migradas correctamente --';
COMMIT TRANSACTION
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION;
		THROW 50001, 'No se migraron correctamente las tablas del BI', 1;
END CATCH


------------------------------------------------------------ VISTAS ------------------------------------------------------------

---------- Drop preventivo de views ----------
---------- Fin drop preventivo de views ----------



-- 1) Promedio de tiempo de publicaciones.
GO
CREATE OR ALTER VIEW LOS_ANTI_PALA.BI_promedio_tiempo_publicaciones AS
SELECT
    t.tiempo_anio, 
    t.tiempo_cuatrimestre,
    r.subrubro,
    p.publicacion_vigencia AS 'Promedio de tiempo de publicaciones'

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
CREATE OR ALTER VIEW LOS_ANTI_PALA.BI_promedio_stock_inicial AS
SELECT
	p.publicacion_stock_inicial_promedio,
	m.marca_descripcion,
	t.tiempo_anio
	
FROM LOS_ANTI_PALA.BI_Hecho_Publicacion p 
JOIN LOS_ANTI_PALA.BI_Tiempo t ON p.codigo_tiempo = t.tiempo_codigo
JOIN LOS_ANTI_PALA.BI_Marca m ON p.marca_codigo = m.marca_codigo
GROUP BY p.publicacion_stock_inicial_promedio, m.marca_descripcion, t.tiempo_anio
GO


-- 3) Venta promedio mensual.
CREATE OR ALTER VIEW LOS_ANTI_PALA.BI_venta_promedio_mensual AS
SELECT
	t.tiempo_anio,
	t.tiempo_mes,
	u.ubicacion_provincia,
	((SUM(v.venta_monto_total))/
		(SUM(v.cantidad_ventas))) as venta_promedio
FROM LOS_ANTI_PALA.BI_Hecho_Venta v
	 JOIN LOS_ANTI_PALA.BI_Ubicacion u on v.ubicacion_codigo = u.ubicacion_codigo
	 JOIN LOS_ANTI_PALA.BI_Tiempo t on v.tiempo_codigo = t.tiempo_codigo
GROUP BY 
	t.tiempo_anio,
	t.tiempo_mes,
	u.ubicacion_provincia
GO


-- 4) Rendimiento de rubros. 
CREATE OR ALTER VIEW LOS_ANTI_PALA.BI_mayor_rendimiento_rubros AS
SELECT TOP 5
    t.tiempo_anio,
    t.tiempo_cuatrimestre,
    u.ubicacion_localidad,
    re.rango_etario,
    r.rubro,
    SUM(v.venta_monto_total) AS venta_total
FROM 
    LOS_ANTI_PALA.BI_Hecho_Venta v
    JOIN LOS_ANTI_PALA.BI_Tiempo t ON v.tiempo_codigo = t.tiempo_codigo
    JOIN LOS_ANTI_PALA.BI_Ubicacion u ON v.ubicacion_codigo = u.ubicacion_codigo
    JOIN LOS_ANTI_PALA.BI_Rango_Etario re ON v.rango_etario_codigo = re.rango_etario_codigo
    JOIN LOS_ANTI_PALA.BI_Rubro_Subrubro r ON v.rubro_subrubro_codigo = r.rubro_subrubro_codigo
GROUP BY 
    t.tiempo_anio,
    t.tiempo_cuatrimestre,
    u.ubicacion_localidad,
    re.rango_etario,
    r.rubro
ORDER BY SUM(v.venta_monto_total) DESC
GO


-- 6) Pago en cuotas. 
CREATE OR ALTER VIEW LOS_ANTI_PALA.BI_mayor_importe_cuotas AS
SELECT 
	TOP 3
    u.ubicacion_localidad,
    t.tiempo_anio,
    t.tiempo_mes,
    mp.tipo_medio_pago,
	MAX(v.venta_monto_total_cuotas) AS monto_total_cuotas
FROM LOS_ANTI_PALA.BI_Hecho_Venta v
	 JOIN LOS_ANTI_PALA.BI_Ubicacion u 
		ON v.ubicacion_codigo = u.ubicacion_codigo
	 JOIN LOS_ANTI_PALA.BI_Tiempo t 
		ON v.tiempo_codigo = t.tiempo_codigo
	 JOIN LOS_ANTI_PALA.BI_Tipo_Medio_Pago mp 
		ON v.tipo_medio_pago_codigo = mp.tipo_medio_pago_codigo
GROUP BY 
    u.ubicacion_localidad, 
    t.tiempo_anio, 
    t.tiempo_mes, 
    mp.tipo_medio_pago
ORDER BY monto_total_cuotas DESC;
GO


-- 7) Porcentaje de cumplimiento de envíos en tiempos programados.
CREATE OR ALTER VIEW LOS_ANTI_PALA.BI_porcentaje_cumplimiento_envios AS
SELECT
	t.tiempo_anio,
	t.tiempo_mes,
	u.ubicacion_provincia,
	COUNT(CASE WHEN e.envio_cumplido = 1 THEN 1 END) * 100.0 / COUNT(*) AS porcentaje_cumplimiento

FROM LOS_ANTI_PALA.BI_Hecho_Envio e 
JOIN LOS_ANTI_PALA.BI_Tiempo t ON e.tiempo_codigo = t.tiempo_codigo
JOIN LOS_ANTI_PALA.BI_Ubicacion u ON e.ubicacion_codigo = u.ubicacion_codigo
GROUP BY
	t.tiempo_anio,
	t.tiempo_mes,
	u.ubicacion_provincia
GO


-- 8) Localidades que pagan mayor costo de envío.Las 5 localidades (tomando la localidad del cliente) con mayor costo de envío.
CREATE OR ALTER VIEW LOS_ANTI_PALA.BI_localidad_paga_mayor_costo_envio AS
SELECT 
	TOP 5 
	u.ubicacion_localidad,
	MAX(e.envio_costo) AS Costo_envio
	
	FROM LOS_ANTI_PALA.BI_Hecho_Envio e
	JOIN LOS_ANTI_PALA.BI_Ubicacion u 
		ON u.ubicacion_codigo = e.ubicacion_codigo
	GROUP BY u.ubicacion_localidad
	ORDER BY MAX(e.envio_costo) desc
GO


-- 9) Porcentaje de facturación por concepto 
CREATE OR ALTER VIEW LOS_ANTI_PALA.BI_porcentaje_facturacion_concepto AS
SELECT
    t.tiempo_anio,
    t.tiempo_mes,
    (SUM(f.factura_total) * 100.0) / 
					(SELECT SUM(factura_total) FROM LOS_ANTI_PALA.BI_Hecho_Facturacion) AS porcentaje_facturacion,
	f.facturacion_concepto
FROM LOS_ANTI_PALA.BI_Hecho_Facturacion f
JOIN LOS_ANTI_PALA.BI_Tiempo t ON f.tiempo_codigo = t.tiempo_codigo
GROUP BY 
    t.tiempo_anio,
    t.tiempo_mes,
	f.facturacion_concepto
GO


-- 10) Facturación por provincia. 
CREATE OR ALTER VIEW LOS_ANTI_PALA.BI_facturacion_por_provincia AS
SELECT
    t.tiempo_anio,
    t.tiempo_cuatrimestre,
    u.ubicacion_provincia,
    SUM(f.factura_total) AS monto_facturado
FROM LOS_ANTI_PALA.BI_Hecho_Facturacion f
	 JOIN LOS_ANTI_PALA.BI_Tiempo t ON f.tiempo_codigo = t.tiempo_codigo
	 JOIN LOS_ANTI_PALA.BI_Ubicacion u ON f.ubicacion_codigo = u.ubicacion_codigo
GROUP BY 
    t.tiempo_anio,
    t.tiempo_cuatrimestre,
    u.ubicacion_provincia
GO
