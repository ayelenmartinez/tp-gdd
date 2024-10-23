-- CREACION DEL SCHEMA --

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'LOS_ANTI_PALA')
    EXEC('CREATE SCHEMA LOS_ANTI_PALA');

-- ELIMINACION PREVENTIVA DE TABLAS --

IF OBJECT_ID('LOS_ANTI_PALA.Usuario', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Usuario
IF OBJECT_ID('LOS_ANTI_PALA.Cliente', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Cliente
IF OBJECT_ID('LOS_ANTI_PALA.Vendedor', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Vendedor
IF OBJECT_ID('LOS_ANTI_PALA.Envio', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Envio
IF OBJECT_ID('LOS_ANTI_PALA.Domicilio', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Domicilio
IF OBJECT_ID('LOS_ANTI_PALA.Domicilio_por_usuario', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Domicilio_por_usuario
IF OBJECT_ID('LOS_ANTI_PALA.Publicacion', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Publicaion
IF OBJECT_ID('LOS_ANTI_PALA.Provincia', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Provincia
IF OBJECT_ID('LOS_ANTI_PALA.Localidad', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Localidad
IF OBJECT_ID('LOS_ANTI_PALA.Almacen', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Almacen
IF OBJECT_ID('LOS_ANTI_PALA.Almacen_por_provincia', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Almacen_por_provincia
IF OBJECT_ID('LOS_ANTI_PALA.Marca', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Marca
IF OBJECT_ID('LOS_ANTI_PALA.Modelo', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Modelo
IF OBJECT_ID('LOS_ANTI_PALA.Rubro', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Rubro
IF OBJECT_ID('LOS_ANTI_PALA.Subrubro', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Subrubro
IF OBJECT_ID('LOS_ANTI_PALA.Producto', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Producto
IF OBJECT_ID('LOS_ANTI_PALA.Producto_por_subrubro', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Producto_por_subrubro
IF OBJECT_ID('LOS_ANTI_PALA.Venta', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALAV.Venta
IF OBJECT_ID('LOS_ANTI_PALA.Detalle_de_venta', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Detalle_de_venta
IF OBJECT_ID('LOS_ANTI_PALA.Detalle_del_pago', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Detalle_del_pago
IF OBJECT_ID('LOS_ANTI_PALA.Medio_de_pago', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Medio_de_pago
IF OBJECT_ID('LOS_ANTI_PALA.Pago', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Pago
IF OBJECT_ID('LOS_ANTI_PALA.Factura', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Factura
IF OBJECT_ID('LOS_ANTI_PALA.Concepto_factura', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Concepto_factura
IF OBJECT_ID('LOS_ANTI_PALA.Detalle_factura', 'U') IS NOT NULL DROP TABLE LOS_ANTI_PALA.Detalle_factura





-- CREACION DE TABLAS --

CREATE TABLE LOS_ANTI_PALA.Usuario (
	usuario_codigo BIGINT PRIMARY KEY,
	usuario_nombre BIGINT UNIQUE NOT NULL,
	usuario_password VARCHAR(50) NOT NULL,
	usuario_fecha_creacion DATE,
)

CREATE TABLE LOS_ANTI_PALA.Cliente (
	usuario_codigo BIGINT REFERENCES LOS_ANTI_PALA.Usuario PRIMARY KEY,
	cliente_nombre NVARCHAR(50) NOT NULL,
	cliente_apellido NVARCHAR(50) NOT NULL,
	cliente_dni DECIMAL(18,0) CONSTRAINT unique_cliente_dni UNIQUE NOT NULL,
	cliente_mail NVARCHAR(50) CONSTRAINT unique_cliente_email UNIQUE NOT NULL,
	cliente_fecha_nac DATE NOT NULL,
)

CREATE TABLE LOS_ANTI_PALA.Vendedor (
	usuario_codigo BIGINT REFERENCES LOS_ANTI_PALA.Usuario PRIMARY KEY,
	vendedor_cuit NVARCHAR(50) CONSTRAINT unique_vendedor_cuit UNIQUE NOT NULL,
	vendedor_mail NVARCHAR(50) NOT NULL,
)

CREATE TABLE LOS_ANTI_PALA.Envio (
	envio_codigo BIGINT PRIMARY KEY,
	envio_fecha_programada DATETIME NOT NULL,
	envio_tipo NVARCHAR(50) NOT NULL,
	envio_fecha_entrega DATETIME NOT NULL,
	envio_costo DECIMAL(18,2) NOT NULL DEFAULT 0,
	envio_hora_inicio DECIMAL(18,0) NOT NULL DEFAULT 0,
	envio_hora_fin DECIMAL(18,0) NOT NULL DEFAULT 0,
)

CREATE TABLE LOS_ANTI_PALA.Domicilio (
	domicilio_codigo BIGINT PRIMARY KEY,
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
	provincia_codigo BIGINT PRIMARY KEY,
	provincia_nombre NVARCHAR(50) NOT NULL,
)

CREATE TABLE LOS_ANTI_PALA.Localidad (
	localidad_codigo BIGINT PRIMARY KEY,
	localidad_nombre NVARCHAR(50) NOT NULL,
)

CREATE TABLE LOS_ANTI_PALA.Almacen (
	almacen_codigo DECIMAL(18,0) PRIMARY KEY,
	almacen_calle NVARCHAR(50) NOT NULL,
	almacen_numero_calle DECIMAL(18,0) NOT NULL DEFAULT 0,
	almacen_costo_dia DECIMAL (18,2),
	localidad_codigo BIGINT REFERENCES LOS_ANTI_PALA.Localidad NOT NULL,
)

CREATE TABLE LOS_ANTI_PALA.Almacen_por_provincia (
	PRIMARY KEY (provincia_codigo, almacen_codigo),
    provincia_codigo BIGINT NOT NULL REFERENCES LOS_ANTI_PALA.Provincia,
    almacen_codigo DECIMAL(18,0) NOT NULL REFERENCES LOS_ANTI_PALA.Almacen,
)

CREATE TABLE LOS_ANTI_PALA.Marca (
	marca_codigo BIGINT PRIMARY KEY,
	marca_descripcion NVARCHAR(50) NOT NULL,
)

CREATE TABLE LOS_ANTI_PALA.Modelo (
	modelo_codigo DECIMAL(18,0) PRIMARY KEY,
	modelo_descripcion NVARCHAR(50) NOT NULL,
)

CREATE TABLE LOS_ANTI_PALA.Rubro (
	rubro_codigo DECIMAL(18,0) PRIMARY KEY,
	rubro_descripcion NVARCHAR(50) NOT NULL,
)

CREATE TABLE LOS_ANTI_PALA.Subrubro (
	subrubro_codigo DECIMAL(18,0) PRIMARY KEY,
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
	medio_pago_codigo BIGINT PRIMARY KEY,
	medio_pago_descripcion NVARCHAR(50) NOT NULL,
	medio_pago_tipo NVARCHAR(50) NOT NULL,
)

CREATE TABLE LOS_ANTI_PALA.Pago (
	pago_codigo BIGINT PRIMARY KEY,
	pago_importe DECIMAL (18,2) NOT NULL DEFAULT 0,
	pago_fecha DATE NOT NULL,
	medio_pago_codigo BIGINT REFERENCES LOS_ANTI_PALA.Medio_de_pago NOT NULL,
)

CREATE TABLE LOS_ANTI_PALA.Detalle_de_pago (
    pago_codigo BIGINT NOT NULL REFERENCES LOS_ANTI_PALA.Pago PRIMARY KEY,
	detalle_pago_nro_tarjeta NVARCHAR(50) NOT NULL,
	detalle_pago_venc_tarjeta DATE NOT NULL,
	detalle_pago_cuotas DECIMAL(18,0) NOT NULL DEFAULT 0,
)

CREATE TABLE LOS_ANTI_PALA.Detalle_de_venta (
	detalle_venta_codigo BIGINT PRIMARY KEY,
    publicacion_codigo DECIMAL(18,0) NOT NULL REFERENCES LOS_ANTI_PALA.Publicacion,
	detalle_venta_cantidad DECIMAL (18,0) NOT NULL DEFAULT 0,
	detalle_venta_precio DECIMAL(18,2) NOT NULL DEFAULT 0,
	detalle_venta_subtotal DECIMAL(18,2) NOT NULL DEFAULT 0,
)

CREATE TABLE LOS_ANTI_PALA.Venta (
	venta_codigo DECIMAL (18,0) PRIMARY KEY,
	venta_fecha DATE NOT NULL,
	venta_total DECIMAL (18,2) NOT NULL DEFAULT 0,
	usuario_codigo BIGINT NOT NULL REFERENCES LOS_ANTI_PALA.Usuario,
	detalle_venta_codigo BIGINT NOT NULL REFERENCES LOS_ANTI_PALA.Detalle_de_venta,
)

CREATE TABLE LOS_ANTI_PALA.Concepto_factura (
	concepto_factura_codigo BIGINT PRIMARY KEY,
	concepto_factura_tipo NVARCHAR(50) NOT NULL,
	concepto_precio DECIMAL(18,2) NOT NULL DEFAULT 0,
)

--falta el campo factura_det_subtotal que no entiendo que es

CREATE TABLE LOS_ANTI_PALA.Detalle_factura (
	detalle_factura_cantidad DECIMAL (18,0) NOT NULL,
	concepto_factura_codigo BIGINT REFERENCES LOS_ANTI_PALA.Concepto_factura NOT NULL,
)

CREATE TABLE LOS_ANTI_PALA.Factura (
	factura_numero DECIMAL(18,0) PRIMARY KEY,
	factura_fecha DATE NOT NULL,
	factura_total DECIMAL(8,0) NOT NULL DEFAULT 0,
	usuario_codigo BIGINT REFERENCES LOS_ANTI_PALA.Usuario NOT NULL,
)



