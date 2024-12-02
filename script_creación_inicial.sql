-- CREACION DEL SCHEMA --

USE GD2C2024;

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'LOS_ANTI_PALA')
    EXEC('CREATE SCHEMA LOS_ANTI_PALA');


------------------------------------------------------------ ELIMINACION PREVENTIVA DE TABLAS ------------------------------------------------------------

EXEC sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT ALL";


-- Nuevos drop --
IF OBJECT_ID('LOS_ANTI_PALA.Detalle_factura', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Detalle_factura;
IF OBJECT_ID('LOS_ANTI_PALA.Concepto_factura', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Concepto_factura;
IF OBJECT_ID('LOS_ANTI_PALA.Factura', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Factura;


IF OBJECT_ID('LOS_ANTI_PALA.Envio', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Envio;
IF OBJECT_ID('LOS_ANTI_PALA.Detalle_de_venta', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Detalle_de_venta;
IF OBJECT_ID('LOS_ANTI_PALA.Venta', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Venta;

IF OBJECT_ID('LOS_ANTI_PALA.Pago', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Pago;
IF OBJECT_ID('LOS_ANTI_PALA.Detalle_de_pago', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Detalle_de_pago;
IF OBJECT_ID('LOS_ANTI_PALA.Medio_de_pago', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Medio_de_pago;

IF OBJECT_ID('LOS_ANTI_PALA.Publicacion', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Publicacion;
IF OBJECT_ID('LOS_ANTI_PALA.Producto_por_subrubro', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Producto_por_subrubro;
IF OBJECT_ID('LOS_ANTI_PALA.Producto', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Producto;
IF OBJECT_ID('LOS_ANTI_PALA.Subrubro', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Subrubro;
IF OBJECT_ID('LOS_ANTI_PALA.Rubro', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Rubro;

IF OBJECT_ID('LOS_ANTI_PALA.Modelo', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Modelo;
IF OBJECT_ID('LOS_ANTI_PALA.Marca', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Marca;

IF OBJECT_ID('LOS_ANTI_PALA.Almacen', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Almacen;
IF OBJECT_ID('LOS_ANTI_PALA.Localidad', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Localidad;
IF OBJECT_ID('LOS_ANTI_PALA.Provincia', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Provincia;

IF OBJECT_ID('LOS_ANTI_PALA.Domicilio_por_usuario', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Domicilio_por_usuario;
IF OBJECT_ID('LOS_ANTI_PALA.Domicilio', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Domicilio;

IF OBJECT_ID('LOS_ANTI_PALA.Tipo_Envio', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Tipo_Envio;
IF OBJECT_ID('LOS_ANTI_PALA.Vendedor', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Vendedor;

IF OBJECT_ID('LOS_ANTI_PALA.Cliente', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Cliente;
IF OBJECT_ID('LOS_ANTI_PALA.Usuario', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Usuario;


EXEC sp_MSforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL";

------------------------------------------------------------ CREACION DE TABLAS ------------------------------------------------------------

CREATE TABLE LOS_ANTI_PALA.Usuario (
	usuario_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
	usuario_nombre VARCHAR(50) NOT NULL,
	usuario_password VARCHAR(50) NOT NULL,
	usuario_fecha_creacion DATE,
	usuario_mail NVARCHAR(50),
)

CREATE TABLE LOS_ANTI_PALA.Cliente (
	usuario_codigo BIGINT REFERENCES LOS_ANTI_PALA.Usuario PRIMARY KEY,
	cliente_nombre NVARCHAR(50) NOT NULL,
	cliente_apellido NVARCHAR(50) NOT NULL,
	cliente_dni DECIMAL(18,0) CONSTRAINT unique_cliente_dni NOT NULL,
	cliente_fecha_nac DATE NOT NULL
)

CREATE TABLE LOS_ANTI_PALA.Vendedor (
	usuario_codigo BIGINT REFERENCES LOS_ANTI_PALA.Usuario PRIMARY KEY,
	vendedor_cuit NVARCHAR(50) CONSTRAINT unique_vendedor_cuit UNIQUE NOT NULL,
	vendedor_razon_social NVARCHAR(50) NOT NULL
)


CREATE TABLE LOS_ANTI_PALA.Tipo_Envio(
 tipo_envio_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
 tipo_envio_descripcion VARCHAR(50) NOT NULL
 )


CREATE TABLE LOS_ANTI_PALA.Domicilio (
	domicilio_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
	domicilio_calle NVARCHAR(50) NOT NULL,
	domicilio_nro_calle DECIMAL(18,0) NOT NULL DEFAULT 0,
	domicilio_codigo_postal NVARCHAR(50) NOT NULL,
	domicilio_localidad NVARCHAR(50) NOT NULL,
	domicilio_provincia NVARCHAR(50) NOT NULL,
	domicilio_piso DECIMAL(18,0),
	domicilio_depto NVARCHAR(50),
)

CREATE TABLE LOS_ANTI_PALA.Domicilio_por_usuario (
	PRIMARY KEY (usuario_codigo, domicilio_codigo),
    usuario_codigo BIGINT NOT NULL REFERENCES LOS_ANTI_PALA.Usuario,
    domicilio_codigo BIGINT NOT NULL REFERENCES LOS_ANTI_PALA.Domicilio,
)

CREATE TABLE LOS_ANTI_PALA.Publicacion (
	publicacion_codigo DECIMAL(18,0) PRIMARY KEY,
	publicacion_descripcion NVARCHAR(50) NOT NULL,
	publicacion_stock DECIMAL(18,0) NOT NULL,
	publicacion_precio DECIMAL(18,2) NOT NULL DEFAULT 0,
	publicacion_costo DECIMAL(18,2) NOT NULL DEFAULT 0,
	producto_porcejtane_venta DECIMAL(18,2) NOT NULL DEFAULT 0,
	publicacion_fecha DATE,
	usuario_codigo BIGINT REFERENCES LOS_ANTI_PALA.Vendedor NOT NULL,
)

CREATE TABLE LOS_ANTI_PALA.Provincia (
	provincia_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
	provincia_nombre NVARCHAR(50) NOT NULL,
)

CREATE TABLE LOS_ANTI_PALA.Localidad (
	localidad_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
	localidad_nombre NVARCHAR(50) NOT NULL,
)

CREATE TABLE LOS_ANTI_PALA.Almacen (
	almacen_codigo DECIMAL(18,0) PRIMARY KEY,
	almacen_calle NVARCHAR(50) NOT NULL,
	almacen_numero_calle DECIMAL(18,0) NOT NULL DEFAULT 0,
	almacen_costo_dia DECIMAL (18,2),
	localidad_codigo BIGINT REFERENCES LOS_ANTI_PALA.Localidad NOT NULL,
)

CREATE TABLE LOS_ANTI_PALA.Marca (
	marca_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
	marca_descripcion NVARCHAR(50) NOT NULL,
)

CREATE TABLE LOS_ANTI_PALA.Modelo (
	modelo_codigo DECIMAL(18,0) PRIMARY KEY,
	modelo_descripcion NVARCHAR(50) NOT NULL,
)

CREATE TABLE LOS_ANTI_PALA.Rubro (
	rubro_codigo DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	rubro_descripcion NVARCHAR(50) NOT NULL,
)

CREATE TABLE LOS_ANTI_PALA.Subrubro (
	subrubro_codigo DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	subrubro_descripcion NVARCHAR(50) NOT NULL,
	rubro_codigo DECIMAL(18,0) REFERENCES LOS_ANTI_PALA.Rubro,
)

CREATE TABLE LOS_ANTI_PALA.Producto (
	producto_codigo NVARCHAR(50) PRIMARY KEY,
	producto_descripcion NVARCHAR(50) NOT NULL,
	producto_precio DECIMAL(18,2) NOT NULL DEFAULT 0,
	marca_codigo BIGINT REFERENCES LOS_ANTI_PALA.Marca NOT NULL,
	modelo_codigo DECIMAL(18,0) REFERENCES LOS_ANTI_PALA.Modelo NOT NULL,
)

CREATE TABLE LOS_ANTI_PALA.Producto_por_subrubro (
	PRIMARY KEY (subrubro_codigo, producto_codigo),
    subrubro_codigo DECIMAL(18,0) NOT NULL REFERENCES LOS_ANTI_PALA.Subrubro,
    producto_codigo NVARCHAR(50) NOT NULL REFERENCES LOS_ANTI_PALA.Producto,
)

CREATE TABLE LOS_ANTI_PALA.Medio_de_pago (
	medio_pago_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
	medio_pago_descripcion NVARCHAR(50) NOT NULL,
	medio_pago_tipo NVARCHAR(50) NOT NULL,
)


CREATE TABLE LOS_ANTI_PALA.Detalle_de_pago (
    detalle_pago_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
	detalle_pago_nro_tarjeta NVARCHAR(50) NOT NULL,
	detalle_pago_venc_tarjeta DATE NOT NULL,
	detalle_pago_cuotas DECIMAL(18,0) NOT NULL DEFAULT 0,
)

CREATE TABLE LOS_ANTI_PALA.Pago (
	pago_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
	pago_importe DECIMAL (18,2) NOT NULL DEFAULT 0,
	pago_fecha DATE NOT NULL,
	medio_pago_codigo BIGINT REFERENCES LOS_ANTI_PALA.Medio_de_pago NOT NULL,
	detalle_pago_codigo BIGINT REFERENCES LOS_ANTI_PALA.Detalle_de_pago,
)


CREATE TABLE LOS_ANTI_PALA.Venta (
	venta_codigo DECIMAL (18,0) PRIMARY KEY,
	venta_fecha DATE NOT NULL,
	venta_total DECIMAL (18,2) NOT NULL DEFAULT 0,
	usuario_codigo BIGINT NOT NULL REFERENCES LOS_ANTI_PALA.Usuario,
)


CREATE TABLE LOS_ANTI_PALA.Detalle_de_venta (
	detalle_venta_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
    publicacion_codigo DECIMAL(18,0) NOT NULL REFERENCES LOS_ANTI_PALA.Publicacion,
	detalle_venta_cantidad DECIMAL (18,0) NOT NULL DEFAULT 0,
	detalle_venta_precio DECIMAL(18,2) NOT NULL DEFAULT 0,
	detalle_venta_subtotal DECIMAL(18,2) NOT NULL DEFAULT 0,
	venta_codigo DECIMAL (18,0) REFERENCES LOS_ANTI_PALA.Venta NOT NULL,
)

CREATE TABLE LOS_ANTI_PALA.Envio (
	envio_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
	envio_fecha_programada DATETIME NOT NULL,
	--envio_tipo NVARCHAR(50) NOT NULL,
	envio_fecha_entrega DATETIME NOT NULL,
	envio_costo DECIMAL(18,2) NOT NULL DEFAULT 0,
	envio_hora_inicio DECIMAL(18,0) NOT NULL DEFAULT 0,
	envio_hora_fin DECIMAL(18,0) NOT NULL DEFAULT 0,
	envio_tipo_envio BIGINT NOT NULL REFERENCES LOS_ANTI_PALA.tipo_envio,
	venta_codigo DECIMAL(18,0) REFERENCES LOS_ANTI_PALA.Venta
)

CREATE TABLE LOS_ANTI_PALA.Concepto_factura (
	concepto_factura_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
	concepto_factura_tipo NVARCHAR(50) NOT NULL
)

CREATE TABLE LOS_ANTI_PALA.Detalle_factura (
	detalle_factura_cantidad DECIMAL(18,0) NOT NULL,
	concepto_factura_codigo BIGINT REFERENCES LOS_ANTI_PALA.Concepto_factura NOT NULL,
	detalle_factura_precio DECIMAL(18,0) NOT NULL,
	detalle_factura_subtotal DECIMAL(18,0) NOT NULL
)

CREATE TABLE LOS_ANTI_PALA.Factura (
	factura_numero DECIMAL(18,0) IDENTITY(1,1) PRIMARY KEY,
	factura_fecha DATE NOT NULL,
	factura_total DECIMAL(8,0) NOT NULL DEFAULT 0,
	usuario_codigo BIGINT REFERENCES LOS_ANTI_PALA.Usuario NOT NULL,
)

------------------------------------------------------------ FIN CREACION DE TABLAS ------------------------------------------------------------




------------------------------------------------------------ MIGRACION DE LA TABLA MAESTRA ------------------------------------------------------------



------------------- Creacion de procedures -------------------

GO

---------- Migracion Domicilio ----------

IF OBJECT_ID('migrar_tabla_domicilio', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_domicilio;
GO
CREATE PROCEDURE migrar_tabla_domicilio
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.Domicilio (domicilio_calle, domicilio_nro_calle, domicilio_codigo_postal, 
										 domicilio_localidad, domicilio_provincia, domicilio_piso, domicilio_depto)
	SELECT 
		CLI_USUARIO_DOMICILIO_CALLE,
		CLI_USUARIO_DOMICILIO_NRO_CALLE,
		CLI_USUARIO_DOMICILIO_CP,
		CLI_USUARIO_DOMICILIO_LOCALIDAD,
		CLI_USUARIO_DOMICILIO_PROVINCIA,
		CLI_USUARIO_DOMICILIO_PISO,
		CLI_USUARIO_DOMICILIO_DEPTO
	FROM [GD2C2024].[gd_esquema].[Maestra] 
	WHERE CLI_USUARIO_DOMICILIO_CALLE IS NOT NULL 
	GROUP BY CLI_USUARIO_DOMICILIO_CALLE,
			 CLI_USUARIO_DOMICILIO_NRO_CALLE,
			 CLI_USUARIO_DOMICILIO_CP,
			 CLI_USUARIO_DOMICILIO_LOCALIDAD,
			 CLI_USUARIO_DOMICILIO_PROVINCIA,
			 CLI_USUARIO_DOMICILIO_PISO,
			 CLI_USUARIO_DOMICILIO_DEPTO
				
	UNION 
		SELECT 
			[VEN_USUARIO_DOMICILIO_CALLE],
			[VEN_USUARIO_DOMICILIO_NRO_CALLE],
			[VEN_USUARIO_DOMICILIO_CP],
			[VEN_USUARIO_DOMICILIO_LOCALIDAD],
			[VEN_USUARIO_DOMICILIO_PROVINCIA],
			[VEN_USUARIO_DOMICILIO_PISO],
			[VEN_USUARIO_DOMICILIO_DEPTO]
		FROM [GD2C2024].[gd_esquema].[Maestra] 
		WHERE VEN_USUARIO_DOMICILIO_CALLE IS NOT NULL
		GROUP BY 
			[VEN_USUARIO_DOMICILIO_CALLE],
			[VEN_USUARIO_DOMICILIO_NRO_CALLE],
			[VEN_USUARIO_DOMICILIO_CP],
			[VEN_USUARIO_DOMICILIO_LOCALIDAD],
			[VEN_USUARIO_DOMICILIO_PROVINCIA],
			[VEN_USUARIO_DOMICILIO_PISO],
			[VEN_USUARIO_DOMICILIO_DEPTO];
	PRINT('Tabla "Domicilio" migrada')
END
GO
---------- Fin Migracion Domiciio ----------

---------- Migracion Domicilio por usuario-----

IF OBJECT_ID('migrar_tabla_domicilio_por_usuario', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_domicilio_por_usuario;
GO
CREATE PROCEDURE migrar_tabla_domicilio_por_usuario
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.Domicilio_por_usuario (
            usuario_codigo, domicilio_codigo
        )
       SELECT DISTINCT 
    u.usuario_codigo, 
    d.domicilio_codigo
FROM [GD2C2024].[gd_esquema].[Maestra] AS m
INNER JOIN LOS_ANTI_PALA.Usuario AS u
    ON u.usuario_mail = m.CLIENTE_MAIL
INNER JOIN LOS_ANTI_PALA.Domicilio AS d
    ON d.domicilio_calle = m.CLI_USUARIO_DOMICILIO_CALLE
       AND d.domicilio_nro_calle = m.CLI_USUARIO_DOMICILIO_NRO_CALLE
       AND d.domicilio_codigo_postal = m.CLI_USUARIO_DOMICILIO_CP
       AND d.domicilio_localidad = m.CLI_USUARIO_DOMICILIO_LOCALIDAD
       AND d.domicilio_provincia = m.CLI_USUARIO_DOMICILIO_PROVINCIA
       AND d.domicilio_piso = m.CLI_USUARIO_DOMICILIO_PISO
       AND d.domicilio_depto = m.CLI_USUARIO_DOMICILIO_DEPTO;

	INSERT INTO LOS_ANTI_PALA.Domicilio_por_usuario (
    usuario_codigo, domicilio_codigo
)
SELECT DISTINCT 
    u.usuario_codigo, 
    d.domicilio_codigo
FROM [GD2C2024].[gd_esquema].[Maestra] AS m
INNER JOIN LOS_ANTI_PALA.Usuario AS u
    ON u.usuario_mail = m.VENDEDOR_MAIL
INNER JOIN LOS_ANTI_PALA.Domicilio AS d
    ON d.domicilio_calle = m.VEN_USUARIO_DOMICILIO_CALLE
       AND d.domicilio_nro_calle = m.CLI_USUARIO_DOMICILIO_NRO_CALLE
       AND d.domicilio_codigo_postal = m.VEN_USUARIO_DOMICILIO_CP
       AND d.domicilio_localidad = m.VEN_USUARIO_DOMICILIO_LOCALIDAD
       AND d.domicilio_provincia = m.VEN_USUARIO_DOMICILIO_PROVINCIA
       AND d.domicilio_piso = m.VEN_USUARIO_DOMICILIO_PISO
       AND d.domicilio_depto = m.VEN_USUARIO_DOMICILIO_DEPTO;

END
GO

---------- Fin Migracion Domicilio por usuario-----

---------- Migracion Medio de pago ----------

IF OBJECT_ID('migrar_tabla_medio_de_pago', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_medio_de_pago;
GO
CREATE PROCEDURE migrar_tabla_medio_de_pago
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.Medio_de_pago(medio_pago_descripcion,medio_pago_tipo)
	SELECT
		PAGO_MEDIO_PAGO,
		PAGO_TIPO_MEDIO_PAGO
	FROM [GD2C2024].[gd_esquema].[Maestra] 
	WHERE PAGO_MEDIO_PAGO IS NOT NULL 
	GROUP BY PAGO_MEDIO_PAGO, PAGO_TIPO_MEDIO_PAGO;
	PRINT('Tabla "Medio de pago" migrada')
END
GO

---------- Fin migracion Medio de pago ----------


---------- Migracion Pago ----------

IF OBJECT_ID('migrar_tabla_pago', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_pago;
GO
CREATE PROCEDURE migrar_tabla_pago
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.Pago(pago_importe,pago_fecha, medio_pago_codigo, detalle_pago_codigo)
	SELECT 
		[PAGO_IMPORTE],
		[PAGO_FECHA],
		(	SELECT medio_pago_codigo FROM LOS_ANTI_PALA.Medio_de_pago 
			WHERE	LOS_ANTI_PALA.Medio_de_pago.medio_pago_descripcion = [GD2C2024].[gd_esquema].[Maestra].[PAGO_MEDIO_PAGO] 
				AND LOS_ANTI_PALA.Medio_de_pago.medio_pago_tipo = [GD2C2024].[gd_esquema].[Maestra].[PAGO_TIPO_MEDIO_PAGO] 
			GROUP BY medio_pago_codigo 
		) AS medio_pago_codigo,
		(	SELECT detalle_pago_codigo FROM LOS_ANTI_PALA.Detalle_de_pago 
			WHERE	LOS_ANTI_PALA.Detalle_de_pago.detalle_pago_nro_tarjeta = [GD2C2024].[gd_esquema].[Maestra].[PAGO_NRO_TARJETA] 
				AND LOS_ANTI_PALA.Detalle_de_pago.detalle_pago_venc_tarjeta = [GD2C2024].[gd_esquema].[Maestra].[PAGO_FECHA_VENC_TARJETA] 
			GROUP BY detalle_pago_codigo 
		) AS Detalle_pago_codigo
	FROM [GD2C2024].[gd_esquema].[Maestra]
	WHERE	[PAGO_IMPORTE] IS NOT NULL 
		AND [PAGO_FECHA] IS NOT NULL
	PRINT ('Tabla "Pago" migrada')
END
GO

---------- Fin migracion Pago ----------


---------- Migracion Detalle de pago ----------

IF OBJECT_ID('migrar_tabla_detalle_de_pago', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_detalle_de_pago;
GO
CREATE PROCEDURE migrar_tabla_detalle_de_pago
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.Detalle_de_pago(detalle_pago_nro_tarjeta, detalle_pago_venc_tarjeta, detalle_pago_cuotas)
	SELECT
		[PAGO_NRO_TARJETA],
		[PAGO_FECHA_VENC_TARJETA],
		[PAGO_CANT_CUOTAS]
	FROM [GD2C2024].[gd_esquema].[Maestra] 
	WHERE [PAGO_NRO_TARJETA] IS NOT NULL 
							 AND [PAGO_FECHA_VENC_TARJETA] IS NOT NULL 
							 AND [PAGO_CANT_CUOTAS] IS NOT NULL
	PRINT('Tabla "Detalle de pago" migrada')
END
GO

---------- Fin migracion Detalle de pago ----------


---------- Migracion Localidad ----------

IF OBJECT_ID('migrar_tabla_localidad', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_localidad;
GO
CREATE PROCEDURE migrar_tabla_localidad
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.Localidad(localidad_nombre)
	SELECT 
		ALMACEN_Localidad
	FROM [GD2C2024].[gd_esquema].[Maestra] 
	GROUP BY ALMACEN_Localidad 
	HAVING ALMACEN_Localidad IS NOT NULL;
	PRINT ('Tabla "Localidad" migrada')
END
GO

---------- Fin migracion Localidad ----------

---------- Migracion Provincia ----------

IF OBJECT_ID('migrar_tabla_provincia', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_provincia;
GO
CREATE PROCEDURE migrar_tabla_provincia
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.Provincia(provincia_nombre)
	SELECT 
		[ALMACEN_PROVINCIA]
	FROM [GD2C2024].[gd_esquema].[Maestra] 
	GROUP BY [ALMACEN_PROVINCIA] 
	HAVING [ALMACEN_PROVINCIA] IS NOT NULL;
	PRINT ('Tabla "Provincia" migrada')
END
GO

---------- Fin migracion Provincia ----------


---------- Migracion Publicacion ----------
IF OBJECT_ID('migrar_tabla_publicacion', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_publicacion;
GO
CREATE PROCEDURE migrar_tabla_publicacion
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.Publicacion(publicacion_codigo, publicacion_descripcion,
	publicacion_stock, publicacion_precio,publicacion_costo,producto_porcejtane_venta,
	publicacion_fecha,usuario_codigo)
	SELECT DISTINCT 
		[PUBLICACION_CODIGO],
		[PUBLICACION_DESCRIPCION],
		[PUBLICACION_STOCK],
		[PUBLICACION_PRECIO],
		[PUBLICACION_COSTO],
		[PUBLICACION_PORC_VENTA],
		[PUBLICACION_FECHA],
		usuario_codigo 
	FROM [GD2C2024].[gd_esquema].[Maestra] m
		JOIN LOS_ANTI_PALA.Vendedor V 
		ON v.vendedor_cuit =  m.VENDEDOR_CUIT AND v.vendedor_razon_social = m.VENDEDOR_RAZON_SOCIAl			 
	PRINT ('Tabla "Publicacion" migrada')
END
GO
---------- Migracion Publicacion ----------

---------- Migracion Concepto Factura ----------

GO
IF OBJECT_ID('migrar_tabla_concepto_factura', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_concepto_factura;

GO
CREATE PROCEDURE migrar_tabla_concepto_factura
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.Concepto_factura(concepto_factura_tipo)
	SELECT 
		FACTURA_DET_TIPO
	FROM [GD2C2024].[gd_esquema].[Maestra] 
	GROUP BY FACTURA_DET_TIPO 
	HAVING FACTURA_DET_TIPO IS NOT NULL;
	PRINT('Tabla "Concepto facutra" migrada')
END
GO
---------- Fin migracion Concepto Factura ----------



---------- Migracion Rubro y Subrubro ----------

IF OBJECT_ID('migrar_tabla_rubro_y_subrubro', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_rubro_y_subrubro;
GO
CREATE PROCEDURE migrar_tabla_rubro_y_subrubro
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.Rubro(rubro_descripcion)
	SELECT 
		[PRODUCTO_RUBRO_DESCRIPCION]

	FROM [GD2C2024].[gd_esquema].[Maestra] 
	GROUP BY [PRODUCTO_RUBRO_DESCRIPCION] 
	HAVING [PRODUCTO_RUBRO_DESCRIPCION] IS NOT NULL;

	WITH CTE AS (
					SELECT 
						PRODUCTO_SUB_RUBRO,
						(	
							SELECT rubro_codigo 
							FROM LOS_ANTI_PALA.Rubro r 
							WHERE PRODUCTO_RUBRO_DESCRIPCION = r.rubro_descripcion
						) AS RUBRO_FK
					FROM [GD2C2024].[gd_esquema].[Maestra] 
					WHERE  PRODUCTO_SUB_RUBRO IS NOT NULL
				)

	INSERT INTO LOS_ANTI_PALA.Subrubro(subrubro_descripcion, rubro_codigo)
	SELECT 
		PRODUCTO_SUB_RUBRO,
		RUBRO_FK
	FROM CTE
	GROUP BY PRODUCTO_SUB_RUBRO, RUBRO_FK
	PRINT('Tablas "Rubro" y "Subrubro" migradas')
END
GO
---------- Fin migracion Rubro y Subrubro ----------



---------- Migracion Tipo Envio ----------

IF OBJECT_ID('migrar_tabla_tipo_envio', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_tipo_envio;
GO
CREATE PROCEDURE migrar_tabla_tipo_envio
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.Tipo_Envio(tipo_envio_descripcion)
	SELECT 
		[ENVIO_TIPO]
	FROM [GD2C2024].[gd_esquema].[Maestra] 
	GROUP BY [ENVIO_TIPO] 
	HAVING [ENVIO_TIPO] IS NOT NULL;
	PRINT('Tabla "Tipo Envio" migrada')
END
GO
---------- Fin Migracion Tipo Envio ----------

---------- Migracion Venta ----------

IF OBJECT_ID('migrar_tabla_venta', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_venta;
GO
CREATE PROCEDURE migrar_tabla_venta
AS
	BEGIN
		INSERT INTO LOS_ANTI_PALA.Venta (venta_codigo, venta_fecha, venta_total, usuario_codigo)
		SELECT DISTINCT 
			VENTA_CODIGO,
			VENTA_FECHA,
			VENTA_TOTAL,
			c.usuario_codigo
		FROM gd_esquema.Maestra m
		JOIN LOS_ANTI_PALA.Cliente c ON 
				c.cliente_dni = m.CLIENTE_DNI 
			AND c.cliente_nombre = m.CLIENTE_NOMBRE 
			AND c.cliente_apellido = m.CLIENTE_APELLIDO
		PRINT('Tabla "Venta" migrada')
	END
GO 

---------- Fin migracion Venta ----------

---------- Migracion Detalle venta ----------

IF OBJECT_ID('migrar_tabla_detalle_venta', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_detalle_venta;
GO
CREATE PROCEDURE migrar_tabla_detalle_venta
AS
	BEGIN
		INSERT INTO LOS_ANTI_PALA.Detalle_de_venta(detalle_venta_cantidad, 
		detalle_venta_precio, detalle_venta_subtotal, venta_codigo, publicacion_codigo)
		SELECT DISTINCT 
			VENTA_DET_CANT,
			VENTA_DET_PRECIO,
			VENTA_DET_SUB_TOTAL,
			VENTA_CODIGO,
			PUBLICACION_CODIGO
		FROM gd_esquema.Maestra 
		WHERE VENTA_CODIGO IS NOT NULL
		PRINT('Tabla "Detalle venta" migrada')
	END
GO 

---------- Fin migracion Detalle venta ----------



---------- Migracion Envio ----------

IF OBJECT_ID('migrar_tabla_envio', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_envio;
GO
CREATE PROCEDURE migrar_tabla_envio
AS
	BEGIN
		INSERT INTO LOS_ANTI_PALA.Envio(
			envio_fecha_programada,envio_fecha_entrega,envio_costo,envio_hora_inicio,
			envio_hora_fin, envio_tipo_envio, venta_codigo)
		SELECT 
			[ENVIO_FECHA_PROGAMADA],
			[ENVIO_FECHA_ENTREGA],
			[ENVIO_COSTO],
			[ENVIO_HORA_INICIO],
			[ENVIO_HORA_FIN_INICIO],
			tipo_envio_codigo,
			v.venta_codigo
			FROM [GD2C2024].[gd_esquema].[Maestra] 
				JOIN LOS_ANTI_PALA.Tipo_Envio
				ON LOS_ANTI_PALA.Tipo_Envio.tipo_envio_descripcion =  [GD2C2024].[gd_esquema].[Maestra].[ENVIO_TIPO]
				JOIN LOS_ANTI_PALA.Venta v ON v.venta_codigo = [GD2C2024].[gd_esquema].[Maestra].[VENTA_CODIGO]
			PRINT('Tabla "Envio" migrada')
	END
GO
---------- Fin migracion Envio ----------


---------- Migracion Usuario ----------

IF OBJECT_ID('migrar_tabla_usuario', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_usuario;
GO
CREATE PROCEDURE migrar_tabla_usuario
AS
	BEGIN
		INSERT INTO LOS_ANTI_PALA.Usuario (
			usuario_nombre, usuario_password, usuario_fecha_creacion,usuario_mail)
		SELECT DISTINCT
			[CLI_USUARIO_NOMBRE],
			[CLI_USUARIO_PASS],
			[CLI_USUARIO_FECHA_CREACION],
			[CLIENTE_MAIL]

		FROM [GD2C2024].[gd_esquema].[Maestra] 
		WHERE [CLI_USUARIO_NOMBRE] IS NOT NULL 
		UNION
		SELECT DISTINCT
			[VEN_USUARIO_NOMBRE],
			[VEN_USUARIO_PASS],
			[VEN_USUARIO_FECHA_CREACION],
			[VENDEDOR_MAIL]
		FROM [GD2C2024].[gd_esquema].[Maestra] 
		WHERE [VEN_USUARIO_NOMBRE] IS NOT NULL

		PRINT('Tabla "Usuario" migrada')
	END
GO
-------- Fin migracion Usuario ----------


-------- Migracion Vendedor ----------

IF OBJECT_ID('migrar_tabla_vendedor', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_vendedor;
GO
CREATE PROCEDURE migrar_tabla_vendedor
AS
	BEGIN
		INSERT INTO LOS_ANTI_PALA.Vendedor(usuario_codigo, vendedor_cuit, vendedor_razon_social)
		SELECT DISTINCT
			usuario_codigo,
			[VENDEDOR_CUIT],
			[VENDEDOR_RAZON_SOCIAL]
		FROM [GD2C2024].[gd_esquema].[Maestra] JOIN LOS_ANTI_PALA.Usuario 
						ON VENDEDOR_MAIL = usuario_mail AND
						VEN_USUARIO_NOMBRE = usuario_nombre AND
						VEN_USUARIO_FECHA_CREACION = usuario_fecha_creacion
		WHERE [VENDEDOR_CUIT] IS NOT NULL
		PRINT('Tabla "Vendedor" migrada')
	END
GO
-------- Fin migracion Vendedor ----------

-------- Migracion Cliente ----------

IF OBJECT_ID('migrar_tabla_cliente', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_cliente;
GO
CREATE PROCEDURE migrar_tabla_cliente
AS
	BEGIN
		INSERT INTO LOS_ANTI_PALA.Cliente
			(usuario_codigo, cliente_nombre, cliente_apellido, cliente_dni, cliente_fecha_nac)
		SELECT DISTINCT
			usuario_codigo,
			[CLIENTE_NOMBRE],
			[CLIENTE_APELLIDO],
			[CLIENTE_DNI],
			[CLIENTE_FECHA_NAC]
		FROM [GD2C2024].[gd_esquema].[Maestra] m JOIN LOS_ANTI_PALA.Usuario u
						ON m.CLIENTE_MAIL = u.usuario_mail AND
						m.CLI_USUARIO_NOMBRE = u.usuario_nombre AND
						m.CLI_USUARIO_FECHA_CREACION = u.usuario_fecha_creacion
		PRINT('Tabla "Cliente" migrada')
	END
GO
-------- Fin migracion Cliente ----------


-------- Migracion Modelo ----------

IF OBJECT_ID('migrar_tabla_modelo', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_modelo;
GO
CREATE PROCEDURE migrar_tabla_modelo
AS
	BEGIN
		INSERT INTO LOS_ANTI_PALA.Modelo(modelo_codigo, modelo_descripcion)
		SELECT 
			[PRODUCTO_MOD_CODIGO],
			[PRODUCTO_MOD_DESCRIPCION]

		FROM [GD2C2024].[gd_esquema].[Maestra] 
		WHERE [PRODUCTO_MOD_DESCRIPCION] IS NOT NULL
		GROUP BY [PRODUCTO_MOD_CODIGO],[PRODUCTO_MOD_DESCRIPCION] ;
		PRINT('Tabla "Modelo" migrada')
	END
GO
-------- Fin migracion Modelo ----------

---------- Migracion Marca ----------

IF OBJECT_ID('migrar_tabla_marca', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_marca;
GO
CREATE PROCEDURE migrar_tabla_marca
AS
    BEGIN
        INSERT INTO LOS_ANTI_PALA.Marca(marca_descripcion)
		SELECT 
			[PRODUCTO_MARCA]
		FROM [GD2C2024].[gd_esquema].[Maestra] 
		WHERE [PRODUCTO_MARCA] IS NOT NULL
		GROUP BY [PRODUCTO_MARCA];
        PRINT('Tabla "Marca" migrada')
    END
GO
-------- Fin migracion Marca ----------

---------- Migracion Almacen ----------

IF OBJECT_ID('migrar_tabla_almacen', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_almacen;
GO
CREATE PROCEDURE migrar_tabla_almacen
AS
    BEGIN
        INSERT INTO LOS_ANTI_PALA.Almacen(almacen_codigo,almacen_calle, almacen_numero_calle, almacen_costo_dia, localidad_codigo)
		SELECT DISTINCT
			[ALMACEN_CODIGO],
			[ALMACEN_CALLE],
			[ALMACEN_NRO_CALLE],
			[ALMACEN_COSTO_DIA_AL],
			l.localidad_codigo
		FROM [GD2C2024].[gd_esquema].[Maestra]  JOIN LOS_ANTI_PALA.Localidad l
			 ON [GD2C2024].[gd_esquema].[Maestra].ALMACEN_Localidad = l.localidad_nombre
        PRINT('Tabla "Almacen" migrada')
    END
GO

-------- Fin migracion Almacen ----------
-------- Migracion Producto ----------
IF OBJECT_ID('migrar_tabla_producto', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_producto;
GO

CREATE PROCEDURE migrar_tabla_producto
AS
BEGIN
    -- Primero, asegurarnos de que la tabla Marca esté migrada con los datos de PRODUCTO_MARCA
    INSERT INTO LOS_ANTI_PALA.Marca (marca_descripcion)
    SELECT DISTINCT PRODUCTO_MARCA
    FROM [GD2C2024].[gd_esquema].[Maestra]
    WHERE PRODUCTO_MARCA IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 
        FROM LOS_ANTI_PALA.Marca m 
        WHERE m.marca_descripcion = PRODUCTO_MARCA
    );

    -- Luego, migrar los productos
    INSERT INTO LOS_ANTI_PALA.Producto (
        producto_codigo,
        producto_descripcion,
        producto_precio,
        marca_codigo,
        modelo_codigo
    )
    SELECT DISTINCT
        M.PRODUCTO_CODIGO,
        M.PRODUCTO_DESCRIPCION,
        M.PRODUCTO_PRECIO,
        MA.marca_codigo,
        M.PRODUCTO_MOD_CODIGO
    FROM [GD2C2024].[gd_esquema].[Maestra] M
    INNER JOIN LOS_ANTI_PALA.Marca MA ON MA.marca_descripcion = M.PRODUCTO_MARCA
    WHERE M.PRODUCTO_CODIGO IS NOT NULL
    AND M.PRODUCTO_DESCRIPCION IS NOT NULL
    AND M.PRODUCTO_PRECIO IS NOT NULL
    AND M.PRODUCTO_MOD_CODIGO IS NOT NULL
    AND M.PRODUCTO_MARCA IS NOT NULL;

    PRINT('Tabla "Producto" migrada')
END
GO
-------- Fin migracion Producto ----------
-------- Migracion Factura ----------
	    IF OBJECT_ID('migrar_tabla_factura', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_factura;
GO

CREATE PROCEDURE migrar_tabla_factura
AS
BEGIN
    -- Primero insertamos los conceptos de factura
    INSERT INTO LOS_ANTI_PALA.Concepto_factura (concepto_factura_tipo)
    SELECT DISTINCT FACTURA_DET_TIPO
    FROM [GD2C2024].[gd_esquema].[Maestra]
    WHERE FACTURA_DET_TIPO IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 
        FROM LOS_ANTI_PALA.Concepto_factura cf 
        WHERE cf.concepto_factura_tipo = FACTURA_DET_TIPO
    );

    -- Luego insertamos las facturas
    INSERT INTO LOS_ANTI_PALA.Factura (
        factura_numero,
        factura_fecha,
        factura_total,
        usuario_codigo
    )
    SELECT DISTINCT
        M.FACTURA_NUMERO,
        M.FACTURA_FECHA,
        M.FACTURA_TOTAL,
        U.usuario_codigo
    FROM [GD2C2024].[gd_esquema].[Maestra] M
    INNER JOIN LOS_ANTI_PALA.Usuario U ON 
        (U.usuario_nombre = M.CLI_USUARIO_NOMBRE OR U.usuario_nombre = M.VEN_USUARIO_NOMBRE)
    WHERE M.FACTURA_NUMERO IS NOT NULL
    AND M.FACTURA_FECHA IS NOT NULL
    AND M.FACTURA_TOTAL IS NOT NULL;

    -- Finalmente insertamos los detalles de factura
    INSERT INTO LOS_ANTI_PALA.Detalle_factura (
        detalle_factura_cantidad,
        concepto_factura_codigo,
        detalle_factura_precio,
        detalle_factura_subtotal
    )
    SELECT 
        M.FACTURA_DET_CANTIDAD,
        CF.concepto_factura_codigo,
        M.FACTURA_DET_PRECIO,
        M.FACTURA_DET_SUBTOTAL
    FROM [GD2C2024].[gd_esquema].[Maestra] M
    INNER JOIN LOS_ANTI_PALA.Concepto_factura CF ON CF.concepto_factura_tipo = M.FACTURA_DET_TIPO
    WHERE M.FACTURA_DET_CANTIDAD IS NOT NULL
    AND M.FACTURA_DET_TIPO IS NOT NULL
    AND M.FACTURA_DET_PRECIO IS NOT NULL
    AND M.FACTURA_DET_SUBTOTAL IS NOT NULL;

    PRINT('Tablas "Factura", "Concepto_factura" y "Detalle_factura" migradas')
END
GO
-------- Fin migracion Factura ----------
-------- migracion Detalle Factura ----------
IF OBJECT_ID('migrar_tabla_detalle_factura', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_detalle_factura;
GO

CREATE PROCEDURE migrar_tabla_detalle_factura
AS
BEGIN
    -- Primero nos aseguramos que existan los conceptos de factura
    INSERT INTO LOS_ANTI_PALA.Concepto_factura (concepto_factura_tipo)
    SELECT DISTINCT FACTURA_DET_TIPO
    FROM [GD2C2024].[gd_esquema].[Maestra]
    WHERE FACTURA_DET_TIPO IS NOT NULL
    AND NOT EXISTS (
        SELECT 1 
        FROM LOS_ANTI_PALA.Concepto_factura cf 
        WHERE cf.concepto_factura_tipo = FACTURA_DET_TIPO
    );

    -- Luego insertamos los detalles de factura
    INSERT INTO LOS_ANTI_PALA.Detalle_factura (
        detalle_factura_cantidad,
        concepto_factura_codigo,
        detalle_factura_precio,
        detalle_factura_subtotal
    )
    SELECT DISTINCT
        M.FACTURA_DET_CANTIDAD,
        CF.concepto_factura_codigo,
        M.FACTURA_DET_PRECIO,
        M.FACTURA_DET_SUBTOTAL
    FROM [GD2C2024].[gd_esquema].[Maestra] M
    INNER JOIN LOS_ANTI_PALA.Concepto_factura CF 
        ON CF.concepto_factura_tipo = M.FACTURA_DET_TIPO
    WHERE M.FACTURA_DET_CANTIDAD IS NOT NULL
        AND M.FACTURA_DET_TIPO IS NOT NULL
        AND M.FACTURA_DET_PRECIO IS NOT NULL
        AND M.FACTURA_DET_SUBTOTAL IS NOT NULL
        AND M.FACTURA_NUMERO IS NOT NULL;

    PRINT('Tabla "Detalle_factura" migrada')
END
GO
-------- Fin migracion Detalle Factura ----------


------------------- Fin creacion de procedures -------------------
select*from [LOS_ANTI_PALA].Domicilio_por_usuario
------------------- Ejecucion de procedures -------------------
GO

BEGIN TRANSACTION
BEGIN TRY
EXEC migrar_tabla_domicilio;
EXEC migrar_tabla_domicilio_por_usuario;
EXEC migrar_tabla_medio_de_pago;
EXEC migrar_tabla_pago;
EXEC migrar_tabla_detalle_de_pago;
EXEC migrar_tabla_localidad;
EXEC migrar_tabla_provincia;
EXEC migrar_tabla_concepto_factura;
EXEC migrar_tabla_rubro_y_subrubro;
EXEC migrar_tabla_tipo_envio;
EXEC migrar_tabla_envio;
EXEC migrar_tabla_usuario;
EXEC migrar_tabla_vendedor;
EXEC migrar_tabla_publicacion;
EXEC migrar_tabla_cliente;
EXEC migrar_tabla_venta;
EXEC migrar_tabla_modelo;
EXEC migrar_tabla_marca;
EXEC migrar_tabla_almacen;
	PRINT '--- Todas las tablas fueron migradas correctamente --';
COMMIT TRANSACTION
END TRY

BEGIN CATCH
ROLLBACK TRANSACTION;
		THROW 50001, 'No se migraron correctamente las tablas', 1;
END CATCH

------------------- Fin ejecucion de procedures -------------------
