
-- CREACION DEL SCHEMA --

CREATE SCHEMA LOS_ANTI_PALA
GO


-- CREACION DE TABLAS --

CREATE TABLE LOS_ANTI_PALA.Usuario (
	usuario_codigo BIGINT PRIMARY KEY,
	usuario_nombre BIGINT UNIQUE NOT NULL,
	usuario_password VARCHAR(50) NOT NULL,
	usuario_fecha_creacion DATE,
)

CREATE TABLE LOS_ANTI_PALA.Cliente (
	cliente_codigo BIGINT PRIMARY KEY,
	cliente_nombre NVARCHAR(50) NOT NULL,
	cliente_apellido NVARCHAR(50) NOT NULL,
	cliente_dni DECIMAL(18,0) CONSTRAINT unique_cliente_dni UNIQUE NOT NULL,
	cliente_mail NVARCHAR(50) CONSTRAINT unique_cliente_email UNIQUE NOT NULL,
	cliente_fecha_nac DATE NOT NULL,
	usuario_codigo BIGINT REFERENCES LOS_ANTI_PALA.Usuario NOT NULL UNIQUE,
)

CREATE TABLE LOS_ANTI_PALA.Vendedor (
	vendedor_codigo BIGINT PRIMARY KEY,
	vendedor_cuit NVARCHAR(50) CONSTRAINT unique_vendedor_cuit UNIQUE NOT NULL,
	vendedor_mail NVARCHAR(50) NOT NULL,
	usuario_codigo BIGINT REFERENCES LOS_ANTI_PALA.Usuario NOT NULL UNIQUE,
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
	PRIMARY KEY (cliente_codigo, domicilio_codigo),
    cliente_codigo BIGINT NOT NULL REFERENCES LOS_ANTI_PALA.Cliente,
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
	vendedor_codigo BIGINT REFERENCES LOS_ANTI_PALA.Vendedor NOT NULL,
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


CREATE TABLE LOS_ANTI_PALA.Pago (
	pago_codigo BIGINT PRIMARY KEY,
	pago_importe DECIMAL (18,2) NOT NULL DEFAULT 0,
	pago_fecha DATE NOT NULL,
	--falta terminar
)




