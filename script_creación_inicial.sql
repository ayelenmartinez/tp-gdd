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
IF OBJECT_ID('LOS_ANTI_PALA.Pago', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Pago;
IF OBJECT_ID('LOS_ANTI_PALA.Venta', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Venta;

IF OBJECT_ID('LOS_ANTI_PALA.Detalle_de_pago', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Detalle_de_pago;
IF OBJECT_ID('LOS_ANTI_PALA.Medio_de_pago', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Medio_de_pago;
IF OBJECT_ID('LOS_ANTI_PALA.Producto', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Producto;

IF OBJECT_ID('LOS_ANTI_PALA.Publicacion', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Publicacion;
IF OBJECT_ID('LOS_ANTI_PALA.Subrubro', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Subrubro;
IF OBJECT_ID('LOS_ANTI_PALA.Rubro', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Rubro;

IF OBJECT_ID('LOS_ANTI_PALA.Modelo', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Modelo;
IF OBJECT_ID('LOS_ANTI_PALA.Marca', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Marca;

IF OBJECT_ID('LOS_ANTI_PALA.Almacen', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Almacen;
IF OBJECT_ID('LOS_ANTI_PALA.Localidad', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Localidad;
IF OBJECT_ID('LOS_ANTI_PALA.Provincia', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Provincia;

IF OBJECT_ID('LOS_ANTI_PALA.domicilio_por_cliente', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Domicilio_por_cliente;
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
	vendedor_razon_social NVARCHAR(50) NOT NULL,
	vendedor_domicilio_calle NVARCHAR(50) NOT NULL,
	vendedor_domicilio_nro_calle DECIMAL(18,0) NOT NULL DEFAULT 0,
	vendedor_domicilio_piso DECIMAL(18,0) NOT NULL DEFAULT 0,
	vendedor_domicilio_depto NVARCHAR(50) NOT NULL,
	vendedor_domicilio_cp NVARCHAR (50) NOT NULL,
	vendedor_domicilio_localidad NVARCHAR(50) NOT NULL,
	vendedor_domicilio_provincia NVARCHAR(50) NOT NULL,
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


CREATE TABLE LOS_ANTI_PALA.Domicilio_por_cliente (
	PRIMARY KEY (usuario_codigo, domicilio_codigo),
    usuario_codigo BIGINT NOT NULL REFERENCES LOS_ANTI_PALA.Usuario,
    domicilio_codigo BIGINT NOT NULL REFERENCES LOS_ANTI_PALA.Domicilio,
)


CREATE TABLE LOS_ANTI_PALA.Provincia (
	provincia_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
	provincia_nombre NVARCHAR(50) NOT NULL,
)


CREATE TABLE LOS_ANTI_PALA.Localidad (
	localidad_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
	localidad_nombre NVARCHAR(50) NOT NULL,
	provincia_codigo BIGINT REFERENCES LOS_ANTI_PALA.Provincia NOT NULL,
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


CREATE TABLE LOS_ANTI_PALA.Publicacion (
	publicacion_codigo DECIMAL(18,0) PRIMARY KEY,
	publicacion_descripcion NVARCHAR(50) NOT NULL,
	publicacion_stock DECIMAL(18,0) NOT NULL,
	publicacion_precio DECIMAL(18,2) NOT NULL DEFAULT 0,
	publicacion_costo DECIMAL(18,2) NOT NULL DEFAULT 0,
	publicacion_porcentaje_venta DECIMAL(18,2) NOT NULL DEFAULT 0,
	publicacion_fecha_inicial DATE,
	publicacion_fecha_final DATE,
	usuario_codigo BIGINT REFERENCES LOS_ANTI_PALA.Vendedor NOT NULL,
	almacen_codigo DECIMAL (18,0) REFERENCES LOS_ANTI_PALA.Almacen NOT NULL,
	rubro_codigo DECIMAL(18,0) REFERENCES LOS_ANTI_PALA.Rubro NOT NULL,
)


CREATE TABLE LOS_ANTI_PALA.Producto (
	producto_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
	producto_numero NVARCHAR(50),
	producto_descripcion NVARCHAR(50) NOT NULL,
	producto_precio DECIMAL(18,2) NOT NULL DEFAULT 0,
	marca_codigo BIGINT REFERENCES LOS_ANTI_PALA.Marca NOT NULL,
	modelo_codigo DECIMAL(18,0) REFERENCES LOS_ANTI_PALA.Modelo NOT NULL,
	subrubro_codigo DECIMAL (18,0) REFERENCES LOS_ANTI_PALA.Subrubro NOT NULL,
	publicacion_codigo DECIMAL(18,0) NOT NULL,
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



CREATE TABLE LOS_ANTI_PALA.Venta (
	venta_codigo DECIMAL (18,0) PRIMARY KEY,
	venta_fecha DATE NOT NULL,
	venta_total DECIMAL (18,2) NOT NULL DEFAULT 0,
	usuario_codigo BIGINT NOT NULL REFERENCES LOS_ANTI_PALA.Usuario,
)


CREATE TABLE LOS_ANTI_PALA.Pago (
	pago_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
	pago_importe DECIMAL (18,2) NOT NULL DEFAULT 0,
	pago_fecha DATE NOT NULL,
	medio_pago_codigo BIGINT REFERENCES LOS_ANTI_PALA.Medio_de_pago NOT NULL,
	detalle_pago_codigo BIGINT REFERENCES LOS_ANTI_PALA.Detalle_de_pago NOT NULL,
	venta_codigo DECIMAL(18,0) REFERENCES LOS_ANTI_PALA.Venta NOT NULL,
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
	venta_codigo DECIMAL(18,0) REFERENCES LOS_ANTI_PALA.Venta,
	domicilio_codigo BIGINT NOT NULL REFERENCES LOS_ANTI_PALA.domicilio
)

CREATE TABLE LOS_ANTI_PALA.Concepto_factura (
	concepto_factura_codigo BIGINT IDENTITY(1,1) PRIMARY KEY,
	concepto_factura_tipo NVARCHAR(50) NOT NULL
)

CREATE TABLE LOS_ANTI_PALA.Factura (
	factura_numero DECIMAL(18,0) PRIMARY KEY,
	factura_fecha DATE NOT NULL,
	factura_total DECIMAL(8,0) NOT NULL DEFAULT 0,
	usuario_codigo BIGINT REFERENCES LOS_ANTI_PALA.Usuario NOT NULL,
)

CREATE TABLE LOS_ANTI_PALA.Detalle_factura (
	detalle_factura_codigo BIGINT IDENTITY (1,1) PRIMARY KEY,
	detalle_factura_cantidad DECIMAL(18,0) NOT NULL,
	detalle_factura_precio DECIMAL(18,0) NOT NULL,
	detalle_factura_subtotal DECIMAL(18,0) NOT NULL,
	concepto_factura_codigo BIGINT REFERENCES LOS_ANTI_PALA.Concepto_factura NOT NULL,
	publicacion_codigo DECIMAL (18,0) REFERENCES LOS_ANTI_PALA.Publicacion NOT NULL,
	factura_numero DECIMAL (18,0) REFERENCES LOS_ANTI_PALA.Factura NOT NULL,
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
	PRINT('Tabla "Domicilio" migrada')
END
GO
---------- Fin Migracion Domiciio ----------

---------- Migracion Domicilio por usuario-----

IF OBJECT_ID('migrar_tabla_domicilio_por_cliente', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_domicilio_por_cliente;
GO
CREATE PROCEDURE migrar_tabla_domicilio_por_cliente
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.Domicilio_por_cliente (
            usuario_codigo, domicilio_codigo
        )
       SELECT DISTINCT 
			c.usuario_codigo, 
			d.domicilio_codigo
	   FROM [GD2C2024].[gd_esquema].[Maestra] AS m
	   JOIN LOS_ANTI_PALA.Cliente AS c
			ON c.cliente_dni = m.CLIENTE_DNI 
			   AND c.cliente_nombre = m.CLI_USUARIO_NOMBRE
			   AND c.cliente_apellido = m.CLIENTE_APELLIDO
			   AND c.cliente_fecha_nac = m.CLIENTE_FECHA_NAC
	   JOIN LOS_ANTI_PALA.Domicilio AS d
			ON d.domicilio_calle = m.CLI_USUARIO_DOMICILIO_CALLE
			   AND d.domicilio_nro_calle = m.CLI_USUARIO_DOMICILIO_NRO_CALLE
			   AND d.domicilio_codigo_postal = m.CLI_USUARIO_DOMICILIO_CP
			   AND d.domicilio_localidad = m.CLI_USUARIO_DOMICILIO_LOCALIDAD
			   AND d.domicilio_provincia = m.CLI_USUARIO_DOMICILIO_PROVINCIA
			   AND d.domicilio_piso = m.CLI_USUARIO_DOMICILIO_PISO
			   AND d.domicilio_depto = m.CLI_USUARIO_DOMICILIO_DEPTO;
	   PRINT('Tabla "Domicilio por usuario" migrada') 
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
	INSERT INTO LOS_ANTI_PALA.Pago(pago_importe,pago_fecha, medio_pago_codigo, detalle_pago_codigo, venta_codigo)
	SELECT DISTINCT
		m.[PAGO_IMPORTE],
		m.[PAGO_FECHA],
		mp.medio_pago_codigo,
		dp.detalle_pago_codigo,
		m.VENTA_CODIGO
	FROM [GD2C2024].[gd_esquema].[Maestra] m
	JOIN LOS_ANTI_PALA.Medio_de_pago mp
	ON mp.medio_pago_descripcion = m.[PAGO_MEDIO_PAGO] 
		AND mp.medio_pago_tipo = m.[PAGO_TIPO_MEDIO_PAGO] 
	JOIN LOS_ANTI_PALA.Detalle_de_pago dp
	ON dp.detalle_pago_nro_tarjeta = m.PAGO_NRO_TARJETA
		AND dp.detalle_pago_venc_tarjeta = m.PAGO_FECHA_VENC_TARJETA
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
	INSERT INTO LOS_ANTI_PALA.Localidad(localidad_nombre, provincia_codigo)
	SELECT DISTINCT
		m.ALMACEN_Localidad,
		p.provincia_codigo
	FROM [GD2C2024].[gd_esquema].[Maestra] m
	JOIN LOS_ANTI_PALA.Provincia p ON m.ALMACEN_PROVINCIA = p.provincia_nombre
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
	publicacion_stock, publicacion_precio,publicacion_costo,publicacion_porcentaje_venta,
	publicacion_fecha_inicial, publicacion_fecha_final,almacen_codigo,usuario_codigo, rubro_codigo)
	SELECT DISTINCT 
		m.[PUBLICACION_CODIGO],
		m.[PUBLICACION_DESCRIPCION],
		m.[PUBLICACION_STOCK],
		m.[PUBLICACION_PRECIO],
		m.[PUBLICACION_COSTO],
		m.[PUBLICACION_PORC_VENTA],
		m.[PUBLICACION_FECHA],
		m.[PUBLICACION_FECHA_V],
		m.[ALMACEN_CODIGO],
		v.usuario_codigo,
		r.rubro_codigo
	FROM [GD2C2024].[gd_esquema].[Maestra] m
		JOIN LOS_ANTI_PALA.Vendedor V 
		ON v.vendedor_cuit =  m.VENDEDOR_CUIT AND v.vendedor_razon_social = m.VENDEDOR_RAZON_SOCIAl	
		JOIN LOS_ANTI_PALA.Rubro r
		ON m.PRODUCTO_RUBRO_DESCRIPCION = r.rubro_descripcion
	PRINT ('Tabla "Publicacion" migrada')
END
GO
---------- Migracion Publicacion ----------

---------- Migracion Rubro ----------

IF OBJECT_ID('migrar_tabla_rubro', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_rubro;
GO
CREATE PROCEDURE migrar_tabla_rubro
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.Rubro(rubro_descripcion)
	SELECT DISTINCT
		[PRODUCTO_RUBRO_DESCRIPCION]
	FROM [GD2C2024].[gd_esquema].[Maestra] 
	WHERE [PRODUCTO_RUBRO_DESCRIPCION] IS NOT NULL;
	PRINT('Tabla "Rubro" migrada')
END
GO
---------- Fin migracion Rubro ----------


---------- Migracion Subrubro ----------

IF OBJECT_ID('migrar_tabla_subrubro', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_subrubro;
GO
CREATE PROCEDURE migrar_tabla_subrubro
AS
BEGIN
	INSERT INTO LOS_ANTI_PALA.Subrubro(subrubro_descripcion, rubro_codigo)
	SELECT DISTINCT
		m.[PRODUCTO_SUB_RUBRO],
		r.rubro_codigo
	FROM [GD2C2024].[gd_esquema].[Maestra] m 
		JOIN LOS_ANTI_PALA.Rubro r
		ON m.PRODUCTO_RUBRO_DESCRIPCION = r.rubro_descripcion
	WHERE [PRODUCTO_RUBRO_DESCRIPCION] IS NOT NULL
	PRINT('Tabla "Subrubro" migrada')
END
GO
---------- Fin migracion Subrubro ----------



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
			envio_hora_fin, envio_tipo_envio, venta_codigo, domicilio_codigo)
		SELECT 
			[ENVIO_FECHA_PROGAMADA],
			[ENVIO_FECHA_ENTREGA],
			[ENVIO_COSTO],
			[ENVIO_HORA_INICIO],
			[ENVIO_HORA_FIN_INICIO],
			tipo_envio_codigo,
			v.venta_codigo,
			d.domicilio_codigo
			FROM [GD2C2024].[gd_esquema].[Maestra] m
				JOIN LOS_ANTI_PALA.Tipo_Envio
				ON LOS_ANTI_PALA.Tipo_Envio.tipo_envio_descripcion =  m.ENVIO_TIPO
				JOIN LOS_ANTI_PALA.Venta v ON v.venta_codigo = m.VENTA_CODIGO
				JOIN LOS_ANTI_PALA.Domicilio d ON d.domicilio_calle = m.CLI_USUARIO_DOMICILIO_CALLE AND d.domicilio_nro_calle = m.CLI_USUARIO_DOMICILIO_NRO_CALLE AND
				d.domicilio_depto = m.CLI_USUARIO_DOMICILIO_DEPTO AND d.domicilio_piso = m.CLI_USUARIO_DOMICILIO_PISO AND d.domicilio_localidad = m.CLI_USUARIO_DOMICILIO_LOCALIDAD
				AND d.domicilio_provincia = m.CLI_USUARIO_DOMICILIO_PROVINCIA AND d.domicilio_codigo_postal = m.CLI_USUARIO_DOMICILIO_CP
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
		INSERT INTO LOS_ANTI_PALA.Vendedor(
			usuario_codigo, 
			vendedor_cuit, 
			vendedor_razon_social,
			vendedor_domicilio_calle,
			vendedor_domicilio_nro_calle,
			vendedor_domicilio_piso,
			vendedor_domicilio_depto,
			vendedor_domicilio_cp,
			vendedor_domicilio_localidad,
			vendedor_domicilio_provincia)
		SELECT DISTINCT
			usuario_codigo,
			[VENDEDOR_CUIT],
			[VENDEDOR_RAZON_SOCIAL],
			[VEN_USUARIO_DOMICILIO_CALLE],
			[VEN_USUARIO_DOMICILIO_NRO_CALLE],
			[VEN_USUARIO_DOMICILIO_PISO],
			[VEN_USUARIO_DOMICILIO_DEPTO],
			[VEN_USUARIO_DOMICILIO_CP],
			[VEN_USUARIO_DOMICILIO_LOCALIDAD],
			[VEN_USUARIO_DOMICILIO_PROVINCIA]
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
		SELECT DISTINCT
			[PRODUCTO_MOD_CODIGO],
			[PRODUCTO_MOD_DESCRIPCION]

		FROM [GD2C2024].[gd_esquema].[Maestra] 
		WHERE [PRODUCTO_MOD_DESCRIPCION] IS NOT NULL
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
		SELECT DISTINCT
			[PRODUCTO_MARCA]
		FROM [GD2C2024].[gd_esquema].[Maestra] 
		WHERE [PRODUCTO_MARCA] IS NOT NULL
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
    INSERT INTO LOS_ANTI_PALA.Producto (
        producto_numero,
        producto_descripcion,
        producto_precio,
        marca_codigo,
        modelo_codigo,
		subrubro_codigo,
		publicacion_codigo
    )
    SELECT DISTINCT
        m.PRODUCTO_CODIGO,
        m.PRODUCTO_DESCRIPCION,
        m.PRODUCTO_PRECIO,
        ma.marca_codigo,
        mo.modelo_codigo,
		s.subrubro_codigo,
		m.publicacion_codigo
    FROM [GD2C2024].[gd_esquema].[Maestra] m
     JOIN LOS_ANTI_PALA.Marca MA 
		ON ma.marca_descripcion = m.PRODUCTO_MARCA
	 JOIN LOS_ANTI_PALA.Modelo mo 
		ON mo.modelo_descripcion = m.PRODUCTO_MOD_DESCRIPCION 
	JOIN LOS_ANTI_PALA.Subrubro s
		ON s.subrubro_descripcion = m.PRODUCTO_SUB_RUBRO
    PRINT('Tabla "Producto" migrada')
END
GO
-------- Fin migracion Producto ----------

---------- Migracion Factura ----------

IF OBJECT_ID('migrar_tabla_factura', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_factura;
GO
CREATE PROCEDURE migrar_tabla_factura
AS
    BEGIN
        INSERT INTO LOS_ANTI_PALA.Factura(factura_numero, factura_fecha, factura_total, usuario_codigo)
		SELECT DISTINCT
			m.FACTURA_NUMERO,
			m.FACTURA_FECHA,
			m.FACTURA_TOTAL,
			(
				SELECT 
					top 1 p.usuario_codigo
				FROM LOS_ANTI_PALA.Publicacion p
				WHERE p.publicacion_codigo = m.PUBLICACION_CODIGO
			)
		FROM [GD2C2024].[gd_esquema].[Maestra] m
		WHERE m.FACTURA_NUMERO IS NOT NULL
        PRINT('Tabla "Factura" migrada')
    END 
GO
-------- Fin migracion Factura ----------


---------- Migracion Concepto Factura ----------
IF OBJECT_ID('migrar_tabla_concepto_factura', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_concepto_factura;
GO
CREATE PROCEDURE migrar_tabla_concepto_factura
AS
    BEGIN
        INSERT INTO LOS_ANTI_PALA.Concepto_factura(concepto_factura_tipo)
		SELECT DISTINCT
			FACTURA_DET_TIPO
		FROM [GD2C2024].[gd_esquema].[Maestra] 
		WHERE FACTURA_DET_TIPO IS NOT NULL
        PRINT('Tabla "Concepto factura" migrada')
    END
GO
-------- Fin migracion Concepto Factura ----------


---------- Migracion Detalle Factura ----------
IF OBJECT_ID('migrar_tabla_detalle_factura', 'P') IS NOT NULL
    DROP PROCEDURE migrar_tabla_detalle_factura;
GO
CREATE PROCEDURE migrar_tabla_detalle_factura
AS
    BEGIN
        INSERT INTO LOS_ANTI_PALA.Detalle_factura(detalle_factura_cantidad, detalle_factura_precio,
					detalle_factura_subtotal, factura_numero, publicacion_codigo, concepto_factura_codigo)
		SELECT DISTINCT
			m.FACTURA_DET_CANTIDAD,
			m.FACTURA_DET_PRECIO,
			m.FACTURA_DET_SUBTOTAL,
			m.FACTURA_NUMERO,
			m.PUBLICACION_CODIGO,
			c.concepto_factura_codigo
		FROM [GD2C2024].[gd_esquema].[Maestra] m JOIN LOS_ANTI_PALA.Concepto_factura c 
			ON m.FACTURA_DET_TIPO = c.concepto_factura_tipo
		WHERE FACTURA_DET_TIPO IS NOT NULL
        PRINT('Tabla "Detalle factura" migrada')
    END
GO
-------- Fin Detalle Factura ----------

------------------- Fin creacion de procedures -------------------

------------------- Ejecucion de procedures -------------------
GO
BEGIN TRANSACTION
BEGIN TRY
EXEC migrar_tabla_domicilio;
EXEC migrar_tabla_modelo;
EXEC migrar_tabla_marca;
EXEC migrar_tabla_provincia;
EXEC migrar_tabla_localidad;
EXEC migrar_tabla_rubro;
EXEC migrar_tabla_subrubro;
EXEC migrar_tabla_producto;
EXEC migrar_tabla_medio_de_pago;
EXEC migrar_tabla_detalle_de_pago;
EXEC migrar_tabla_tipo_envio;
EXEC migrar_tabla_usuario;
EXEC migrar_tabla_vendedor;
EXEC migrar_tabla_almacen;
EXEC migrar_tabla_publicacion;
EXEC migrar_tabla_cliente;
EXEC migrar_tabla_domicilio_por_cliente;
EXEC migrar_tabla_venta;
EXEC migrar_tabla_pago;
EXEC migrar_tabla_detalle_venta;
EXEC migrar_tabla_envio;
EXEC migrar_tabla_factura;
EXEC migrar_tabla_concepto_factura;
EXEC migrar_tabla_detalle_factura;
	PRINT '--- Todas las tablas fueron migradas correctamente --';
COMMIT TRANSACTION
END TRY
BEGIN CATCH
ROLLBACK TRANSACTION;
		THROW 50001, 'No se migraron correctamente las tablas', 1;
END CATCH
------------------- Fin ejecucion de procedures -------------------
