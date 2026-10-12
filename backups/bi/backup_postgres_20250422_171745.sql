--
-- neondbQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: almacenes; Type: SCHEMA; Schema: -; Owner: neondb
--

CREATE SCHEMA almacenes;



--
-- Name: compras; Type: SCHEMA; Schema: -; Owner: neondb
--

CREATE SCHEMA compras;



--
-- Name: finanzas; Type: SCHEMA; Schema: -; Owner: neondb
--

CREATE SCHEMA finanzas;



--
-- Name: objetivos; Type: SCHEMA; Schema: -; Owner: neondb
--

CREATE SCHEMA objetivos;



--
-- Name: productos; Type: SCHEMA; Schema: -; Owner: neondb
--

CREATE SCHEMA productos;



--
-- Name: ventas; Type: SCHEMA; Schema: -; Owner: neondb
--

CREATE SCHEMA ventas;



SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: depositos; Type: TABLE; Schema: almacenes; Owner: neondb
--

CREATE TABLE almacenes.depositos (
    id_depositos smallint NOT NULL,
    deposito character varying
);



--
-- Name: movimiento_statu; Type: TABLE; Schema: almacenes; Owner: neondb
--

CREATE TABLE almacenes.movimiento_statu (
    id_salidas bigint NOT NULL,
    id_status smallint NOT NULL,
    id_fechas smallint,
    id_horas smallint
);



--
-- Name: movimientos; Type: TABLE; Schema: almacenes; Owner: neondb
--

CREATE TABLE almacenes.movimientos (
    id_movimientos bigint NOT NULL,
    id_productos integer NOT NULL,
    cantidad numeric NOT NULL,
    id_depositos smallint,
    id_tipo_movimientos smallint NOT NULL,
    fecha timestamp without time zone,
    entrada smallint
);



--
-- Name: reservas; Type: TABLE; Schema: almacenes; Owner: neondb
--

CREATE TABLE almacenes.reservas (
    id_reservas bigint NOT NULL,
    id_productos smallint,
    id_depositos smallint,
    cantidad numeric,
    fecha date
);



--
-- Name: status; Type: TABLE; Schema: almacenes; Owner: neondb
--

CREATE TABLE almacenes.status (
    id_status smallint NOT NULL,
    statu character varying
);



--
-- Name: tipo_movimientos; Type: TABLE; Schema: almacenes; Owner: neondb
--

CREATE TABLE almacenes.tipo_movimientos (
    id_tipo_movimientos smallint NOT NULL,
    tipo character varying NOT NULL
);



--
-- Name: compras; Type: TABLE; Schema: compras; Owner: neondb
--

CREATE TABLE compras.compras (
    id_compras integer NOT NULL,
    id_proveedores smallint NOT NULL,
    num_factura character varying,
    id_tipo_facturas smallint,
    id_fechas smallint,
    id_horas smallint,
    num_control character varying,
    fecha date,
    anulado smallint DEFAULT 0,
    id_ordenes_compras integer,
    descuento numeric,
    tasa numeric
);



--
-- Name: det_compra; Type: TABLE; Schema: compras; Owner: neondb
--

CREATE TABLE compras.det_compra (
    id_det_compra bigint NOT NULL,
    id_productos smallint,
    costo numeric NOT NULL,
    cantidad numeric NOT NULL,
    descuento numeric,
    id_compras integer NOT NULL,
    id_depositos smallint NOT NULL,
    id_presentaciones integer,
    anulado smallint DEFAULT 0
);



--
-- Name: det_compra_statu; Type: TABLE; Schema: compras; Owner: neondb
--

CREATE TABLE compras.det_compra_statu (
    id_det_compra bigint NOT NULL,
    id_status smallint NOT NULL,
    id_fechas smallint,
    id_horas smallint
);



--
-- Name: det_orden_compra; Type: TABLE; Schema: compras; Owner: neondb
--

CREATE TABLE compras.det_orden_compra (
    id_det_orden_compra bigint NOT NULL,
    id_depositos smallint,
    id_productos smallint,
    descuento numeric,
    costo numeric,
    id_ordenes_compras integer,
    cantidad numeric
);



--
-- Name: ordenes_compras; Type: TABLE; Schema: compras; Owner: neondb
--

CREATE TABLE compras.ordenes_compras (
    id_ordenes_compras integer NOT NULL,
    id_proveedores smallint,
    fecha date,
    descuento numeric,
    tasa numeric
);



--
-- Name: proveedores; Type: TABLE; Schema: compras; Owner: neondb
--

CREATE TABLE compras.proveedores (
    id_proveedores smallint NOT NULL,
    proveedor character varying,
    id_tipo_proveedores smallint NOT NULL
);



--
-- Name: status; Type: TABLE; Schema: compras; Owner: neondb
--

CREATE TABLE compras.status (
    id_status smallint NOT NULL,
    statu character varying NOT NULL
);



--
-- Name: tipo_proveedores; Type: TABLE; Schema: compras; Owner: neondb
--

CREATE TABLE compras.tipo_proveedores (
    id_tipo_proveedores smallint NOT NULL,
    tipo character varying NOT NULL
);



--
-- Name: vw_compras; Type: VIEW; Schema: compras; Owner: neondb
--

CREATE VIEW compras.vw_compras AS
 SELECT dc.id_det_compra,
    dc.id_productos,
    dc.costo,
    dc.cantidad,
    dc.descuento,
    dc.id_compras,
    dc.id_depositos,
    dc.id_presentaciones,
    dc.anulado,
    c.fecha
   FROM (compras.compras c
     JOIN compras.det_compra dc ON ((dc.id_compras = c.id_compras)));



--
-- Name: bancos; Type: TABLE; Schema: finanzas; Owner: neondb
--

CREATE TABLE finanzas.bancos (
    id_bancos smallint NOT NULL,
    cuenta character varying NOT NULL,
    id_tipo_bancos smallint NOT NULL
);



--
-- Name: cajas; Type: TABLE; Schema: finanzas; Owner: neondb
--

CREATE TABLE finanzas.cajas (
    id_cajas smallint NOT NULL,
    caja character varying NOT NULL
);



--
-- Name: egreso_banco; Type: TABLE; Schema: finanzas; Owner: neondb
--

CREATE TABLE finanzas.egreso_banco (
    id_egresos bigint,
    id_tipo_bancos smallint,
    id_bancos smallint,
    id_egreso_banco bigint NOT NULL
);



--
-- Name: egreso_banco_id_egreso_banco_seq; Type: SEQUENCE; Schema: finanzas; Owner: neondb
--

CREATE SEQUENCE finanzas.egreso_banco_id_egreso_banco_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: egreso_banco_id_egreso_banco_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: neondb
--

ALTER SEQUENCE finanzas.egreso_banco_id_egreso_banco_seq OWNED BY finanzas.egreso_banco.id_egreso_banco;


--
-- Name: egreso_caja; Type: TABLE; Schema: finanzas; Owner: neondb
--

CREATE TABLE finanzas.egreso_caja (
    id_egresos bigint,
    id_cajas smallint,
    id_egreso_caja bigint NOT NULL
);



--
-- Name: egreso_caja_id_egreso_caja_seq; Type: SEQUENCE; Schema: finanzas; Owner: neondb
--

CREATE SEQUENCE finanzas.egreso_caja_id_egreso_caja_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: egreso_caja_id_egreso_caja_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: neondb
--

ALTER SEQUENCE finanzas.egreso_caja_id_egreso_caja_seq OWNED BY finanzas.egreso_caja.id_egreso_caja;


--
-- Name: egresos; Type: TABLE; Schema: finanzas; Owner: neondb
--

CREATE TABLE finanzas.egresos (
    id_mov_egresos bigint NOT NULL,
    monto numeric,
    fecha date,
    id_tipo_movimientos smallint,
    id_monedas smallint,
    id_metodo_pagos smallint,
    id_medios smallint NOT NULL,
    monto_dolar numeric,
    id_egresos bigint NOT NULL
);



--
-- Name: egresos_id_egresos_seq; Type: SEQUENCE; Schema: finanzas; Owner: neondb
--

CREATE SEQUENCE finanzas.egresos_id_egresos_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: egresos_id_egresos_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: neondb
--

ALTER SEQUENCE finanzas.egresos_id_egresos_seq OWNED BY finanzas.egresos.id_egresos;


--
-- Name: ingreso_banco; Type: TABLE; Schema: finanzas; Owner: neondb
--

CREATE TABLE finanzas.ingreso_banco (
    id_ingresos bigint,
    id_tipo_bancos smallint,
    id_bancos smallint,
    id_ingreso_banco bigint NOT NULL
);



--
-- Name: ingreso_banco_id_ingreso_banco_seq; Type: SEQUENCE; Schema: finanzas; Owner: neondb
--

CREATE SEQUENCE finanzas.ingreso_banco_id_ingreso_banco_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: ingreso_banco_id_ingreso_banco_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: neondb
--

ALTER SEQUENCE finanzas.ingreso_banco_id_ingreso_banco_seq OWNED BY finanzas.ingreso_banco.id_ingreso_banco;


--
-- Name: ingreso_caja; Type: TABLE; Schema: finanzas; Owner: neondb
--

CREATE TABLE finanzas.ingreso_caja (
    id_ingresos bigint,
    id_cajas smallint,
    id_ingreso_caja bigint NOT NULL
);



--
-- Name: ingreso_caja_id_ingreso_caja_seq; Type: SEQUENCE; Schema: finanzas; Owner: neondb
--

CREATE SEQUENCE finanzas.ingreso_caja_id_ingreso_caja_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: ingreso_caja_id_ingreso_caja_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: neondb
--

ALTER SEQUENCE finanzas.ingreso_caja_id_ingreso_caja_seq OWNED BY finanzas.ingreso_caja.id_ingreso_caja;


--
-- Name: ingresos; Type: TABLE; Schema: finanzas; Owner: neondb
--

CREATE TABLE finanzas.ingresos (
    id_mov_ingresos bigint NOT NULL,
    monto numeric,
    fecha date,
    id_tipo_movimientos smallint,
    id_monedas smallint,
    id_metodo_pagos smallint,
    monto_dolar numeric,
    id_medios smallint NOT NULL,
    id_ingresos bigint NOT NULL
);



--
-- Name: ingresos_id_ingresos_seq; Type: SEQUENCE; Schema: finanzas; Owner: neondb
--

CREATE SEQUENCE finanzas.ingresos_id_ingresos_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: ingresos_id_ingresos_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: neondb
--

ALTER SEQUENCE finanzas.ingresos_id_ingresos_seq OWNED BY finanzas.ingresos.id_ingresos;


--
-- Name: medios; Type: TABLE; Schema: finanzas; Owner: neondb
--

CREATE TABLE finanzas.medios (
    id_medios smallint NOT NULL,
    medio character varying
);



--
-- Name: metodo_pagos; Type: TABLE; Schema: finanzas; Owner: neondb
--

CREATE TABLE finanzas.metodo_pagos (
    id_metodo_pagos smallint NOT NULL,
    metodo character varying NOT NULL
);



--
-- Name: monedas; Type: TABLE; Schema: finanzas; Owner: neondb
--

CREATE TABLE finanzas.monedas (
    id_monedas smallint NOT NULL,
    simbolo character varying NOT NULL,
    moneda character varying NOT NULL,
    descripcion character varying
);



--
-- Name: tipo_bancos; Type: TABLE; Schema: finanzas; Owner: neondb
--

CREATE TABLE finanzas.tipo_bancos (
    id_tipo_bancos smallint NOT NULL,
    tipo character varying
);



--
-- Name: tipo_movimientos; Type: TABLE; Schema: finanzas; Owner: neondb
--

CREATE TABLE finanzas.tipo_movimientos (
    id_tipo_movimientos smallint NOT NULL,
    tipo character varying NOT NULL
);



--
-- Name: etiqueta_indicador; Type: TABLE; Schema: objetivos; Owner: neondb
--

CREATE TABLE objetivos.etiqueta_indicador (
    id_etiquetas smallint NOT NULL,
    id_indicadores smallint NOT NULL
);



--
-- Name: etiquetas; Type: TABLE; Schema: objetivos; Owner: neondb
--

CREATE TABLE objetivos.etiquetas (
    id_etiquetas smallint NOT NULL,
    etiqueta character varying NOT NULL,
    visible boolean DEFAULT true
);



--
-- Name: etiquetas_id_etiquetas_seq; Type: SEQUENCE; Schema: objetivos; Owner: neondb
--

CREATE SEQUENCE objetivos.etiquetas_id_etiquetas_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: etiquetas_id_etiquetas_seq; Type: SEQUENCE OWNED BY; Schema: objetivos; Owner: neondb
--

ALTER SEQUENCE objetivos.etiquetas_id_etiquetas_seq OWNED BY objetivos.etiquetas.id_etiquetas;


--
-- Name: formulas; Type: TABLE; Schema: objetivos; Owner: neondb
--

CREATE TABLE objetivos.formulas (
    id_formulas integer NOT NULL,
    formula text,
    titulo character varying,
    visible boolean DEFAULT true,
    id_etiquetas smallint
);



--
-- Name: formulas_id_formulas_seq; Type: SEQUENCE; Schema: objetivos; Owner: neondb
--

CREATE SEQUENCE objetivos.formulas_id_formulas_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: formulas_id_formulas_seq; Type: SEQUENCE OWNED BY; Schema: objetivos; Owner: neondb
--

ALTER SEQUENCE objetivos.formulas_id_formulas_seq OWNED BY objetivos.formulas.id_formulas;


--
-- Name: iconos; Type: TABLE; Schema: objetivos; Owner: neondb
--

CREATE TABLE objetivos.iconos (
    id_iconos smallint NOT NULL,
    icono character varying NOT NULL,
    visible boolean DEFAULT true
);



--
-- Name: iconos_id_iconos_seq; Type: SEQUENCE; Schema: objetivos; Owner: neondb
--

CREATE SEQUENCE objetivos.iconos_id_iconos_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: iconos_id_iconos_seq; Type: SEQUENCE OWNED BY; Schema: objetivos; Owner: neondb
--

ALTER SEQUENCE objetivos.iconos_id_iconos_seq OWNED BY objetivos.iconos.id_iconos;


--
-- Name: indicadores; Type: TABLE; Schema: objetivos; Owner: neondb
--

CREATE TABLE objetivos.indicadores (
    id_indicadores smallint NOT NULL,
    indicador character varying NOT NULL,
    consulta text,
    visible boolean DEFAULT true,
    descripcion character varying,
    filtro smallint DEFAULT 1
);



--
-- Name: objetivos; Type: TABLE; Schema: objetivos; Owner: neondb
--

CREATE TABLE objetivos.objetivos (
    id_objetivos bigint NOT NULL,
    titulo character varying(255) NOT NULL,
    optimo numeric NOT NULL,
    tolerable numeric,
    deficiente numeric,
    fecha_inicio timestamp without time zone,
    fecha_final timestamp without time zone,
    id_formulas integer
);



--
-- Name: objetivos_id_objetivos_seq; Type: SEQUENCE; Schema: objetivos; Owner: neondb
--

CREATE SEQUENCE objetivos.objetivos_id_objetivos_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: objetivos_id_objetivos_seq; Type: SEQUENCE OWNED BY; Schema: objetivos; Owner: neondb
--

ALTER SEQUENCE objetivos.objetivos_id_objetivos_seq OWNED BY objetivos.objetivos.id_objetivos;


--
-- Name: perspectiva_etiqueta; Type: TABLE; Schema: objetivos; Owner: neondb
--

CREATE TABLE objetivos.perspectiva_etiqueta (
    id_perspectivas smallint NOT NULL,
    id_etiquetas smallint NOT NULL
);



--
-- Name: perspectivas; Type: TABLE; Schema: objetivos; Owner: neondb
--

CREATE TABLE objetivos.perspectivas (
    perspectiva character varying NOT NULL,
    id_iconos smallint,
    visible boolean DEFAULT true,
    id_perspectivas smallint NOT NULL
);



--
-- Name: perspectivas_id_perspectivas_seq; Type: SEQUENCE; Schema: objetivos; Owner: neondb
--

CREATE SEQUENCE objetivos.perspectivas_id_perspectivas_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



--
-- Name: perspectivas_id_perspectivas_seq; Type: SEQUENCE OWNED BY; Schema: objetivos; Owner: neondb
--

ALTER SEQUENCE objetivos.perspectivas_id_perspectivas_seq OWNED BY objetivos.perspectivas.id_perspectivas;


--
-- Name: categorias; Type: TABLE; Schema: productos; Owner: neondb
--

CREATE TABLE productos.categorias (
    id_categorias smallint NOT NULL,
    categoria character varying NOT NULL
);



--
-- Name: detalle_productos; Type: TABLE; Schema: productos; Owner: neondb
--

CREATE TABLE productos.detalle_productos (
    id_detalle_productos integer NOT NULL,
    id_productos smallint NOT NULL,
    id_ingredientes smallint NOT NULL,
    cantidad numeric NOT NULL,
    id_unidades smallint
);



--
-- Name: marcas; Type: TABLE; Schema: productos; Owner: neondb
--

CREATE TABLE productos.marcas (
    id_marcas smallint NOT NULL,
    marca character varying NOT NULL
);



--
-- Name: presentaciones; Type: TABLE; Schema: productos; Owner: neondb
--

CREATE TABLE productos.presentaciones (
    id_presentaciones integer NOT NULL,
    presentacion character varying NOT NULL,
    id_productos integer NOT NULL,
    modificador numeric
);



--
-- Name: productos; Type: TABLE; Schema: productos; Owner: neondb
--

CREATE TABLE productos.productos (
    id_productos integer NOT NULL,
    titulo character varying,
    codigo character varying,
    id_marcas smallint,
    id_categorias smallint,
    id_subcategorias smallint,
    id_unidades smallint,
    id_tipo_productos smallint
);



--
-- Name: subcategorias; Type: TABLE; Schema: productos; Owner: neondb
--

CREATE TABLE productos.subcategorias (
    id_subcategorias smallint NOT NULL,
    subcategoria character varying NOT NULL
);



--
-- Name: tipo_productos; Type: TABLE; Schema: productos; Owner: neondb
--

CREATE TABLE productos.tipo_productos (
    id_tipo_productos smallint NOT NULL,
    tipo character varying NOT NULL
);



--
-- Name: unidades; Type: TABLE; Schema: productos; Owner: neondb
--

CREATE TABLE productos.unidades (
    id_unidades smallint NOT NULL,
    unidad character varying NOT NULL
);



--
-- Name: vw_gastos; Type: VIEW; Schema: productos; Owner: neondb
--

CREATE VIEW productos.vw_gastos AS
 SELECT p.id_productos,
    p.titulo,
    p.codigo,
    p.id_marcas,
    p.id_categorias,
    p.id_subcategorias,
    p.id_unidades,
    p.id_tipo_productos,
    c.categoria
   FROM (productos.productos p
     JOIN productos.categorias c ON ((c.id_categorias = p.id_categorias)))
  WHERE (p.id_tipo_productos = 4);



--
-- Name: ciudades; Type: TABLE; Schema: public; Owner: neondb
--

CREATE TABLE public.ciudades (
    id_ciudades smallint NOT NULL,
    ciudad character varying,
    id_estados smallint
);



--
-- Name: estados; Type: TABLE; Schema: public; Owner: neondb
--

CREATE TABLE public.estados (
    id_estados smallint NOT NULL,
    estado character varying
);



--
-- Name: fechas; Type: TABLE; Schema: public; Owner: neondb
--

CREATE TABLE public.fechas (
    id_fechas smallint NOT NULL,
    dia smallint NOT NULL,
    mes smallint NOT NULL,
    trimestre smallint NOT NULL,
    cuatrimestre smallint NOT NULL,
    semestre smallint NOT NULL,
    "año" smallint NOT NULL,
    semana smallint NOT NULL
);



--
-- Name: horas; Type: TABLE; Schema: public; Owner: neondb
--

CREATE TABLE public.horas (
    id_horas smallint NOT NULL,
    hora smallint NOT NULL,
    minutos smallint NOT NULL
);



--
-- Name: permisos; Type: TABLE; Schema: public; Owner: neondb
--

CREATE TABLE public.permisos (
    id_permisos smallint NOT NULL,
    activo boolean,
    controlador character varying,
    accion character varying,
    recurso character varying,
    modulo character varying
);



--
-- Name: personas; Type: TABLE; Schema: public; Owner: neondb
--

CREATE TABLE public.personas (
    id_personas integer NOT NULL,
    nombre character varying,
    cedula character varying,
    correo character varying,
    telefono character varying,
    id_ciudades smallint,
    nombre_comercial character varying,
    fecha_nacimiento date,
    direccion character varying
);



--
-- Name: role_permiso; Type: TABLE; Schema: public; Owner: neondb
--

CREATE TABLE public.role_permiso (
    id_roles smallint,
    id_permisos smallint
);



--
-- Name: roles; Type: TABLE; Schema: public; Owner: neondb
--

CREATE TABLE public.roles (
    rol character varying,
    acceso boolean,
    id_roles smallint NOT NULL
);



--
-- Name: tipo_factura; Type: TABLE; Schema: public; Owner: neondb
--

CREATE TABLE public.tipo_factura (
    id_tipo_facturas bigint,
    inicial text,
    tipo text
);



--
-- Name: tipo_facturas; Type: TABLE; Schema: public; Owner: neondb
--

CREATE TABLE public.tipo_facturas (
    id_tipo_facturas smallint NOT NULL,
    tipo character varying NOT NULL,
    inicial character varying
);



--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: neondb
--

CREATE TABLE public.usuarios (
    id_usuarios smallint NOT NULL,
    nombre_usuario character varying,
    "contraseña" character varying,
    correo character varying,
    nombre character varying,
    apellido character varying,
    acceso boolean,
    id_roles smallint
);



--
-- Name: det_venta; Type: TABLE; Schema: ventas; Owner: neondb
--

CREATE TABLE ventas.det_venta (
    id_det_venta bigint NOT NULL,
    id_productos integer NOT NULL,
    id_depositos smallint NOT NULL,
    precio numeric NOT NULL,
    cantidad numeric NOT NULL,
    id_ventas integer NOT NULL,
    descuento numeric,
    id_presentaciones integer,
    id_empleados smallint,
    anulado smallint DEFAULT 0,
    devuelto numeric
);



--
-- Name: det_venta_statu; Type: TABLE; Schema: ventas; Owner: neondb
--

CREATE TABLE ventas.det_venta_statu (
    id_det_venta bigint NOT NULL,
    id_status smallint,
    id_fechas smallint,
    id_horas smallint
);



--
-- Name: status; Type: TABLE; Schema: ventas; Owner: neondb
--

CREATE TABLE ventas.status (
    id_status smallint NOT NULL,
    statu character varying
);



--
-- Name: tipo_clientes; Type: TABLE; Schema: ventas; Owner: neondb
--

CREATE TABLE ventas.tipo_clientes (
    id_tipo_clientes smallint NOT NULL,
    tipo character varying
);



--
-- Name: vendedores; Type: TABLE; Schema: ventas; Owner: neondb
--

CREATE TABLE ventas.vendedores (
    id_vendedores integer NOT NULL,
    nombre character varying,
    porcentaje numeric
);



--
-- Name: venta_statu; Type: TABLE; Schema: ventas; Owner: neondb
--

CREATE TABLE ventas.venta_statu (
    id_ventas integer NOT NULL,
    id_status smallint NOT NULL,
    id_fechas smallint,
    id_horas smallint
);



--
-- Name: ventas; Type: TABLE; Schema: ventas; Owner: neondb
--

CREATE TABLE ventas.ventas (
    id_ventas integer NOT NULL,
    id_personas smallint,
    id_cajas smallint NOT NULL,
    id_vendedores smallint,
    descuento numeric,
    id_tipo_facturas smallint,
    num_factura character varying,
    num_control character varying,
    id_ciudades smallint,
    tasa numeric,
    id_tipo_clientes smallint,
    id_estados smallint,
    anulado smallint DEFAULT 0,
    fecha timestamp without time zone
);



--
-- Name: vw_ventas; Type: VIEW; Schema: ventas; Owner: neondb
--

CREATE VIEW ventas.vw_ventas AS
 SELECT dv.id_det_venta,
    dv.id_productos,
    dv.id_depositos,
    dv.precio,
    dv.cantidad,
    dv.id_ventas,
    dv.descuento,
    dv.id_presentaciones,
    dv.id_empleados,
    dv.anulado,
    dv.devuelto,
    v.fecha,
    v.id_personas,
    v.id_cajas,
    v.num_factura,
    v.num_control,
    v.id_ciudades,
    v.id_estados,
    v.id_tipo_clientes
   FROM (ventas.ventas v
     JOIN ventas.det_venta dv ON ((v.id_ventas = dv.id_ventas)));



--
-- Name: egreso_banco id_egreso_banco; Type: DEFAULT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.egreso_banco ALTER COLUMN id_egreso_banco SET DEFAULT nextval('finanzas.egreso_banco_id_egreso_banco_seq'::regclass);


--
-- Name: egreso_caja id_egreso_caja; Type: DEFAULT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.egreso_caja ALTER COLUMN id_egreso_caja SET DEFAULT nextval('finanzas.egreso_caja_id_egreso_caja_seq'::regclass);


--
-- Name: egresos id_egresos; Type: DEFAULT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.egresos ALTER COLUMN id_egresos SET DEFAULT nextval('finanzas.egresos_id_egresos_seq'::regclass);


--
-- Name: ingreso_banco id_ingreso_banco; Type: DEFAULT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.ingreso_banco ALTER COLUMN id_ingreso_banco SET DEFAULT nextval('finanzas.ingreso_banco_id_ingreso_banco_seq'::regclass);


--
-- Name: ingreso_caja id_ingreso_caja; Type: DEFAULT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.ingreso_caja ALTER COLUMN id_ingreso_caja SET DEFAULT nextval('finanzas.ingreso_caja_id_ingreso_caja_seq'::regclass);


--
-- Name: ingresos id_ingresos; Type: DEFAULT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.ingresos ALTER COLUMN id_ingresos SET DEFAULT nextval('finanzas.ingresos_id_ingresos_seq'::regclass);


--
-- Name: etiquetas id_etiquetas; Type: DEFAULT; Schema: objetivos; Owner: neondb
--

ALTER TABLE ONLY objetivos.etiquetas ALTER COLUMN id_etiquetas SET DEFAULT nextval('objetivos.etiquetas_id_etiquetas_seq'::regclass);


--
-- Name: formulas id_formulas; Type: DEFAULT; Schema: objetivos; Owner: neondb
--

ALTER TABLE ONLY objetivos.formulas ALTER COLUMN id_formulas SET DEFAULT nextval('objetivos.formulas_id_formulas_seq'::regclass);


--
-- Name: iconos id_iconos; Type: DEFAULT; Schema: objetivos; Owner: neondb
--

ALTER TABLE ONLY objetivos.iconos ALTER COLUMN id_iconos SET DEFAULT nextval('objetivos.iconos_id_iconos_seq'::regclass);


--
-- Name: objetivos id_objetivos; Type: DEFAULT; Schema: objetivos; Owner: neondb
--

ALTER TABLE ONLY objetivos.objetivos ALTER COLUMN id_objetivos SET DEFAULT nextval('objetivos.objetivos_id_objetivos_seq'::regclass);


--
-- Name: perspectivas id_perspectivas; Type: DEFAULT; Schema: objetivos; Owner: neondb
--

ALTER TABLE ONLY objetivos.perspectivas ALTER COLUMN id_perspectivas SET DEFAULT nextval('objetivos.perspectivas_id_perspectivas_seq'::regclass);


--
-- Data for Name: depositos; Type: TABLE DATA; Schema: almacenes; Owner: neondb
--

COPY almacenes.depositos (id_depositos, deposito) FROM stdin;
1	DEPOSITO DISTRIBUIDOR
3	DEPOSITO 02
4	DEPOSITO 03
5	DEPOSITO 04
6	DEPOSITO KOHLER
7	FANTASMA
\.


--
-- Data for Name: movimiento_statu; Type: TABLE DATA; Schema: almacenes; Owner: neondb
--

COPY almacenes.movimiento_statu (id_salidas, id_status, id_fechas, id_horas) FROM stdin;
\.


--
-- Data for Name: movimientos; Type: TABLE DATA; Schema: almacenes; Owner: neondb
--

COPY almacenes.movimientos (id_movimientos, id_productos, cantidad, id_depositos, id_tipo_movimientos, fecha, entrada) FROM stdin;
\.


--
-- Data for Name: reservas; Type: TABLE DATA; Schema: almacenes; Owner: neondb
--

COPY almacenes.reservas (id_reservas, id_productos, id_depositos, cantidad, fecha) FROM stdin;
\.


--
-- Data for Name: status; Type: TABLE DATA; Schema: almacenes; Owner: neondb
--

COPY almacenes.status (id_status, statu) FROM stdin;
1	En proceso
2	Completado
3	Anulado
\.


--
-- Data for Name: tipo_movimientos; Type: TABLE DATA; Schema: almacenes; Owner: neondb
--

COPY almacenes.tipo_movimientos (id_tipo_movimientos, tipo) FROM stdin;
1	FAC
2	AUTOCONSUMO
3	ENS
4	TRA
5	AJU
6	RETIRO
7	OTRO
10	REC
11	COM
12	CAR
8	NC
13	COMPROMETIDO
\.


--
-- Data for Name: compras; Type: TABLE DATA; Schema: compras; Owner: neondb
--

COPY compras.compras (id_compras, id_proveedores, num_factura, id_tipo_facturas, id_fechas, id_horas, num_control, fecha, anulado, id_ordenes_compras, descuento, tasa) FROM stdin;
1	1	12312313	1	\N	\N	12312323	2024-05-28	0	\N	0.0	35.0
2	2	12312311	1	\N	\N	12312323	2024-05-28	0	\N	0.0	37.0
3	3	020366	1	\N	\N	131316	2024-06-02	0	\N	0.0	36.8
4	2	12312	1	\N	\N	123123	2024-06-04	0	1	0.0	36.52
5	1	1231232	1	\N	\N	12312312	2024-06-05	0	\N	0.0	36.54
6	3	113123	1	\N	\N	1231233	2024-06-05	0	\N	0.0	36.54
7	1	123123	1	\N	\N	131312	2024-06-25	0	\N	0.0	36.37
8	2	C000019807	1	\N	\N	988777	2024-06-26	0	\N	0.0	36.35
9	3	22512	1	\N	\N	222561	2024-07-01	0	\N	0.0	36.46
10	4	12342134	1	\N	\N	23423423	2024-07-02	0	\N	0.0	4000.0
11	3	12342134	1	\N	\N	00-00515	2024-07-17	0	\N	0.0	36.53
12	4	151411	1	\N	\N	65151	2024-07-17	0	\N	0.0	36.53
13	5	4242452	1	\N	\N	4455235	2024-07-22	0	\N	0.0	36.61
14	5	234343	1	\N	\N	324234	2024-07-22	0	\N	0.0	36.61
15	5	212151	1	\N	\N	00-0551	2024-07-25	0	\N	0.0	42.0
16	1	1234	1	\N	\N	1234	2024-08-07	0	\N	0.0	36.6
17	3	1212	1	\N	\N	12122	2024-09-03	0	\N	0.0	36.63
18	1	65155	1	\N	\N	46416	2024-10-02	0	\N	0.0	36.95
19	4	2	1	\N	\N	1414324	2024-10-02	0	\N	0.0	0.0
20	2	3	1	\N	\N	1414324	2024-10-02	0	\N	0.0	36.92
21	1	C000018529	1	\N	\N	00181540	2024-10-04	0	\N	0.0	36.31
22	1	123456	3	\N	\N	123456	2024-10-04	0	\N	0.0	0.0
23	1	12444	4	\N	\N	123478	2024-10-04	0	\N	0.0	0.0
24	1	4234	1	\N	\N	3370	2024-10-04	0	\N	0.0	37.04
25	5	sdfsdfsd	1	\N	\N	sdfsdfsd	2024-10-23	0	\N	0.0	39.32
26	1	qweqwe	1	\N	\N	qweqw	2024-10-23	0	\N	0.0	39.32
27	8	212212	1	\N	\N	2121	2024-10-24	0	\N	0.0	50.0
28	1	24234234	1	\N	\N	01-000010	2024-10-24	0	\N	0.0	40.0
29	1	86728	1	\N	\N	1804802	2024-11-01	0	\N	0.0	42.56
30	1	323	1	\N	\N	123131	2024-11-04	0	\N	0.0	42.86
31	2	0909	1	\N	\N	0909	2024-11-04	0	\N	0.0	42.85
32	2	09098	1	\N	\N	8989	2024-11-04	0	\N	0.0	43.0
33	1	2121	1	\N	\N	123	2024-11-06	0	\N	0.0	42.86
34	1	xxxxx	1	\N	\N	xxxxxxxx	2024-12-03	0	\N	0.0	47.61
35	1	zzzzzzz	1	\N	\N	zzzzzzzzzzzz	2024-12-03	0	\N	0.0	47.61
36	1	123456789	1	\N	\N	000012	2024-12-03	0	\N	0.0	47.61
\.


--
-- Data for Name: det_compra; Type: TABLE DATA; Schema: compras; Owner: neondb
--

COPY compras.det_compra (id_det_compra, id_productos, costo, cantidad, descuento, id_compras, id_depositos, id_presentaciones, anulado) FROM stdin;
1	3	0.6	30.0	0.0	1	1	\N	0
2	3	0.6	10.0	0.0	2	1	\N	0
3	4	20.0	12.0	0.0	3	1	\N	0
4	3	0.6	300.0	0.0	4	1	\N	0
5	18	19.0	10.0	0.0	5	1	\N	0
6	18	21.16	10.0	0.0	6	3	\N	0
7	20	5.0	10.0	0.0	7	3	\N	0
8	1	0.2	1.0	0.0	8	3	\N	0
9	26	1.0	300.0	0.0	9	3	\N	0
10	18	10.0	200.0	0.0	10	3	\N	0
11	30	20.0	1000.0	0.0	11	3	2	0
12	31	25.0	500.0	0.0	12	3	3	0
13	37	20.0	1.0	0.0	13	3	\N	0
14	37	20.0	1.0	0.0	14	3	\N	0
15	38	19.0	60.0	0.0	15	3	4	0
16	3	0.6	1.0	0.0	16	3	\N	0
17	12	1.0	2.0	0.0	17	3	\N	0
18	17	5.0	10.0	0.0	17	3	\N	0
19	3	1.0	10.0	0.0	18	1	\N	0
20	10	2.0	10.0	0.0	18	1	\N	0
21	3	1.1	30.0	0.0	21	3	\N	0
22	4	20.0	50.0	0.0	21	3	\N	0
23	99	27.0	1.0	0.0	24	3	\N	0
24	94	10.0	5.0	0.0	25	3	\N	0
25	100	120.0	10.0	0.0	26	3	\N	0
26	12	1.2	100.0	0.0	27	3	\N	0
27	102	0.8	410.0	0.0	28	3	5	0
28	7	1.0	100.0	0.0	29	3	\N	0
29	106	1.0	1000.0	0.0	30	3	\N	0
30	3	1.1	1.0	0.0	31	3	\N	0
31	11	0.01	1.0	0.0	32	3	\N	0
32	4	20.0	12.0	0.0	33	1	\N	0
33	122	15.0	3.0	0.0	34	3	\N	0
34	122	15.0	3.0	0.0	35	3	\N	0
35	123	300.0	1.0	0.0	36	3	\N	0
\.


--
-- Data for Name: det_compra_statu; Type: TABLE DATA; Schema: compras; Owner: neondb
--

COPY compras.det_compra_statu (id_det_compra, id_status, id_fechas, id_horas) FROM stdin;
\.


--
-- Data for Name: det_orden_compra; Type: TABLE DATA; Schema: compras; Owner: neondb
--

COPY compras.det_orden_compra (id_det_orden_compra, id_depositos, id_productos, descuento, costo, id_ordenes_compras, cantidad) FROM stdin;
1	1	3	0.0	0.6	1	300.0
2	3	14	0.0	5.0	2	10.0
3	3	11	0.0	0.01	2	5.0
5	4	11	0.0	0.01	3	5.0
6	3	1	0.0	0.05	4	10.0
\.


--
-- Data for Name: ordenes_compras; Type: TABLE DATA; Schema: compras; Owner: neondb
--

COPY compras.ordenes_compras (id_ordenes_compras, id_proveedores, fecha, descuento, tasa) FROM stdin;
1	2	2024-05-28	0.0	36.52
2	1	2024-05-28	0.0	36.51
3	3	2024-09-04	0.0	37.0
4	1	2024-12-03	0.0	47.6
\.


--
-- Data for Name: proveedores; Type: TABLE DATA; Schema: compras; Owner: neondb
--

COPY compras.proveedores (id_proveedores, proveedor, id_tipo_proveedores) FROM stdin;
1	SOMOS SISTEMAS C.A.	1
2	MANTENTE POTENTE, C.A	1
3	SALCAR DE VENEZUELA 	1
4	CLEAN SPACE	1
5	ADUANA UNO	1
6	FENOX IMPORT	1
7	MODAVENCA	1
8	EL PINOSO FABRIL C.A	3
9	AREHANNY DEL VALLE PE�A MALPICA	4
\.


--
-- Data for Name: status; Type: TABLE DATA; Schema: compras; Owner: neondb
--

COPY compras.status (id_status, statu) FROM stdin;
1	Orden de compra
2	Compra
\.


--
-- Data for Name: tipo_proveedores; Type: TABLE DATA; Schema: compras; Owner: neondb
--

COPY compras.tipo_proveedores (id_tipo_proveedores, tipo) FROM stdin;
1	PROVEEDOR DE CAJAS
2	PROVEEDOR DE BOLSA
3	PROVEEDOR NACIONAL
4	ACEITES
\.


--
-- Data for Name: bancos; Type: TABLE DATA; Schema: finanzas; Owner: neondb
--

COPY finanzas.bancos (id_bancos, cuenta, id_tipo_bancos) FROM stdin;
\.


--
-- Data for Name: cajas; Type: TABLE DATA; Schema: finanzas; Owner: neondb
--

COPY finanzas.cajas (id_cajas, caja) FROM stdin;
1	SAN CRISTOBAL
2	SAN ANTONIO 
3	LA GRITA
5	CAJA 3
6	CAJA 4
7	CAJA 5
8	CAJA 6
9	CAJA 7
10	CAJA 8
4	BARLOVENTO Z
\.


--
-- Data for Name: egreso_banco; Type: TABLE DATA; Schema: finanzas; Owner: neondb
--

COPY finanzas.egreso_banco (id_egresos, id_tipo_bancos, id_bancos, id_egreso_banco) FROM stdin;
\.


--
-- Data for Name: egreso_caja; Type: TABLE DATA; Schema: finanzas; Owner: neondb
--

COPY finanzas.egreso_caja (id_egresos, id_cajas, id_egreso_caja) FROM stdin;
\.


--
-- Data for Name: egresos; Type: TABLE DATA; Schema: finanzas; Owner: neondb
--

COPY finanzas.egresos (id_mov_egresos, monto, fecha, id_tipo_movimientos, id_monedas, id_metodo_pagos, id_medios, monto_dolar, id_egresos) FROM stdin;
\.


--
-- Data for Name: ingreso_banco; Type: TABLE DATA; Schema: finanzas; Owner: neondb
--

COPY finanzas.ingreso_banco (id_ingresos, id_tipo_bancos, id_bancos, id_ingreso_banco) FROM stdin;
\.


--
-- Data for Name: ingreso_caja; Type: TABLE DATA; Schema: finanzas; Owner: neondb
--

COPY finanzas.ingreso_caja (id_ingresos, id_cajas, id_ingreso_caja) FROM stdin;
\.


--
-- Data for Name: ingresos; Type: TABLE DATA; Schema: finanzas; Owner: neondb
--

COPY finanzas.ingresos (id_mov_ingresos, monto, fecha, id_tipo_movimientos, id_monedas, id_metodo_pagos, monto_dolar, id_medios, id_ingresos) FROM stdin;
\.


--
-- Data for Name: medios; Type: TABLE DATA; Schema: finanzas; Owner: neondb
--

COPY finanzas.medios (id_medios, medio) FROM stdin;
1	Banco
2	Caja
\.


--
-- Data for Name: metodo_pagos; Type: TABLE DATA; Schema: finanzas; Owner: neondb
--

COPY finanzas.metodo_pagos (id_metodo_pagos, metodo) FROM stdin;
1	EFECTIVO
2	DIVISA
3	TARJETA DE DEBITO
4	TARJETA DE CREDITO
5	DEPOSITO
6	TRANSFERENCIA
7	NOTA DE DEBITO
8	COMISION BANCARIA
9	RET-IVA
10	VUELTO
11	WALLET
12	CREDITO
13	PROPINA
14	PAGO MOVIL
\.


--
-- Data for Name: monedas; Type: TABLE DATA; Schema: finanzas; Owner: neondb
--

COPY finanzas.monedas (id_monedas, simbolo, moneda, descripcion) FROM stdin;
1	Bs	Bs	Nacional
2	$	USD	Extranjera
3	Pts	Coins	Fidelidad
\.


--
-- Data for Name: tipo_bancos; Type: TABLE DATA; Schema: finanzas; Owner: neondb
--

COPY finanzas.tipo_bancos (id_tipo_bancos, tipo) FROM stdin;
\.


--
-- Data for Name: tipo_movimientos; Type: TABLE DATA; Schema: finanzas; Owner: neondb
--

COPY finanzas.tipo_movimientos (id_tipo_movimientos, tipo) FROM stdin;
1	ABONO
2	COMPRA
3	FACTURA
4	PEDIDO
5	INGRESO
6	RETIRO
7	BANCO
\.


--
-- Data for Name: etiqueta_indicador; Type: TABLE DATA; Schema: objetivos; Owner: neondb
--

COPY objetivos.etiqueta_indicador (id_etiquetas, id_indicadores) FROM stdin;
4	1
5	16
5	2
6	2
6	1
\.


--
-- Data for Name: etiquetas; Type: TABLE DATA; Schema: objetivos; Owner: neondb
--

COPY objetivos.etiquetas (id_etiquetas, etiqueta, visible) FROM stdin;
4	Clientes	t
5	Mermas	t
6	Cotizaciones	t
\.


--
-- Data for Name: formulas; Type: TABLE DATA; Schema: objetivos; Owner: neondb
--

COPY objetivos.formulas (id_formulas, formula, titulo, visible, id_etiquetas) FROM stdin;
24	COUNT\\left(Clientesrecurrentes\\right)	Clientes recurrentes	t	4
25	AVG\\left(Clientespromediocompra\\right)	Valor promedio de compra del cliente	t	4
26	COUNT\\left(Clientesfinales\\right)-\\frac{COUNT\\left(nuevosClientes\\right)}{COUNT\\left(Clientesfinales\\right)}ClientesfinalesClientesfinales	comretecion	t	4
1	string	string	t	4
2	\\frac{1}{2}SUM\\left(Compras\\right)	prueba 1/2 compras	t	4
4	\\frac{SUM\\left(Ventas\\right)}{SUM\\left(Compras\\right)}	compras y ventas	t	4
3	2*SUM\\left(Compras\\right)	2*compras	t	4
6	SUM\\left(Gastos\\right)	Gastos	t	4
7	SUM\\left(Ingresos\\right)	Ingresos	t	4
8	SUM\\left(Devueltos\\right)	Productos devueltos	t	4
5	\\frac{SUM\\left(Devueltos\\right)}{SUM\\left(Vendidos\\right)}	Tasa de devolucion	t	4
9	\\frac{SUM\\left(Devueltos\\right)}{SUM\\left(Vendidos\\right)}	tasa devolucin 2	t	4
10	\\frac{SUM\\left(Devueltos\\right)}{SUM\\left(Vendidos\\right)}	devueltosss	t	4
11	\\frac{SUM\\left(Devueltos\\right)}{SUM\\left(Vendidos\\right)}	devueltosss	t	4
22	\\frac{COUNT\\left(Clientesfinales\\right)-COUNT\\left(nuevosclientes\\right)}{COUNT\\left(Clientescomienzo\\right)}\\cdot100	Retencion de clientes	t	4
23	\\frac{COUNT\\left(Clientesfinales\\right)-COUNT\\left(nuevosclientes\\right)}{COUNT\\left(Clientescomienzo\\right)}\\cdot100	Retencion de clientes pop	t	4
12	SUM\\left(Ventas\\right)	Total de ventas	t	4
13	SUM\\left(Compras\\right)	Total de compras	t	4
14	COUNT\\left(Compras\\right)	Cantidad de compras	t	4
15	COUNT\\left(Ventas\\right)	Cantidad de ventas	t	4
16	AVG\\left(Ventas\\right)	Promedio de ventas	t	4
17	AVG\\left(Compras\\right)	Promedio de compras	t	4
18	COUNT\\left(Clientesfinales\\right)	Clientes finales	t	4
19	AVG\\left(Clientesvidautil\\right)	Vida util de clientes	t	4
20	COUNT\\left(nuevosclientes\\right)	Clientes nuevos	t	4
21	COUNT\\left(Clientescomienzo\\right)	Clientes iniciales	t	4
\.


--
-- Data for Name: iconos; Type: TABLE DATA; Schema: objetivos; Owner: neondb
--

COPY objetivos.iconos (id_iconos, icono, visible) FROM stdin;
1	Activity	t
2	Airplay	t
3	AlarmClock	t
4	AlertCircle	t
5	AlertOctagon	t
6	AlertTriangle	t
7	AlignCenter	t
8	AlignJustify	t
9	AlignLeft	t
10	AlignRight	t
11	Anchor	t
12	Aperture	t
13	Archive	t
14	ArrowDown	t
15	ArrowDownCircle	t
16	ArrowDownLeft	t
17	ArrowDownRight	t
18	ArrowLeft	t
19	ArrowLeftCircle	t
20	ArrowRight	t
21	ArrowRightCircle	t
22	ArrowUp	t
23	ArrowUpCircle	t
24	ArrowUpLeft	t
25	ArrowUpRight	t
26	AtSign	t
27	Award	t
28	Axe	t
29	BarChart	t
30	BarChart2	t
31	Battery	t
32	BatteryCharging	t
33	Bell	t
34	BellOff	t
35	Bluetooth	t
36	Bold	t
37	Book	t
38	Bookmark	t
39	Box	t
40	Briefcase	t
41	Calendar	t
42	Camera	t
43	CameraOff	t
44	Cast	t
45	Check	t
46	CheckCircle	t
47	CheckSquare	t
48	ChevronDown	t
49	ChevronLeft	t
50	ChevronRight	t
51	ChevronUp	t
52	Circle	t
53	Clipboard	t
54	Clock	t
55	Cloud	t
56	CloudDrizzle	t
57	CloudLightning	t
58	CloudOff	t
59	CloudRain	t
60	CloudSnow	t
61	Code	t
62	Codepen	t
63	Codesandbox	t
64	Coffee	t
65	Columns	t
66	Command	t
67	Compass	t
68	Copy	t
69	CornerDownLeft	t
70	CornerDownRight	t
71	CornerLeftDown	t
72	CornerLeftUp	t
73	CornerRightDown	t
74	CornerRightUp	t
75	CornerUpLeft	t
76	CornerUpRight	t
77	Cpu	t
78	CreditCard	t
79	Crop	t
80	Crosshair	t
81	Database	t
82	Delete	t
83	Disc	t
84	Divide	t
85	DivideCircle	t
86	DivideSquare	t
87	DollarSign	t
88	Download	t
89	DownloadCloud	t
90	Dribbble	t
91	Droplet	t
92	Edit	t
93	Edit2	t
94	Edit3	t
95	ExternalLink	t
96	Eye	t
97	EyeOff	t
98	Facebook	t
99	FastForward	t
100	Feather	t
101	Figma	t
102	File	t
103	FileMinus	t
104	FilePlus	t
105	FileText	t
106	Film	t
107	Filter	t
108	Flag	t
109	Folder	t
110	FolderMinus	t
111	FolderPlus	t
112	Framer	t
113	Frown	t
114	Gift	t
115	GitBranch	t
116	GitCommit	t
117	GitMerge	t
118	GitPullRequest	t
119	Github	t
120	Gitlab	t
121	Globe	t
122	Grid	t
123	HardDrive	t
124	Hash	t
125	Headphones	t
126	Heart	t
127	HelpCircle	t
128	Hexagon	t
129	Home	t
130	Image	t
131	Inbox	t
132	Info	t
133	Instagram	t
134	Italic	t
135	Key	t
136	Layers	t
137	Layout	t
138	LifeBuoy	t
139	Link	t
140	Link2	t
141	Linkedin	t
142	List	t
143	Loader	t
144	Lock	t
145	LogIn	t
146	LogOut	t
147	Mail	t
148	Map	t
149	MapPin	t
150	Maximize	t
151	Maximize2	t
152	Meh	t
153	Menu	t
154	MessageCircle	t
155	MessageSquare	t
156	Mic	t
157	MicOff	t
158	Minimize	t
159	Minimize2	t
160	Minus	t
161	MinusCircle	t
162	MinusSquare	t
163	Monitor	t
164	Moon	t
165	MoreHorizontal	t
166	MoreVertical	t
167	MousePointer	t
168	Move	t
169	Music	t
170	Navigation	t
171	Navigation2	t
172	Octagon	t
173	Package	t
174	Paperclip	t
175	Pause	t
176	PauseCircle	t
177	PenTool	t
178	Percent	t
179	Phone	t
180	PhoneCall	t
181	PhoneForwarded	t
182	PhoneIncoming	t
183	PhoneMissed	t
184	PhoneOff	t
185	PhoneOutgoing	t
186	PieChart	t
187	Play	t
188	PlayCircle	t
189	Plus	t
190	PlusCircle	t
191	PlusSquare	t
192	Pocket	t
193	Power	t
194	Printer	t
195	Radio	t
196	RefreshCcw	t
197	RefreshCw	t
198	Repeat	t
199	Rewind	t
200	RotateCcw	t
201	RotateCw	t
202	Rss	t
203	Save	t
204	Scissors	t
205	Search	t
206	Send	t
207	Server	t
208	Settings	t
209	Share	t
210	Share2	t
211	Shield	t
212	ShieldOff	t
213	ShoppingBag	t
214	ShoppingCart	t
215	Shuffle	t
216	Sidebar	t
217	SkipBack	t
218	SkipForward	t
219	Slack	t
220	Slash	t
221	Sliders	t
222	Smartphone	t
223	Smile	t
224	Speaker	t
225	Square	t
226	Star	t
227	StopCircle	t
228	Sun	t
229	Sunrise	t
230	Sunset	t
231	Tablet	t
232	Tag	t
233	Target	t
234	Terminal	t
235	Thermometer	t
236	ThumbsDown	t
237	ThumbsUp	t
238	ToggleLeft	t
239	ToggleRight	t
240	Tool	t
241	Trash	t
242	Trash2	t
243	Trello	t
244	TrendingDown	t
245	TrendingUp	t
246	Triangle	t
247	Truck	t
248	Tv	t
249	Twitch	t
250	Twitter	t
251	Type	t
252	Umbrella	t
253	Underline	t
254	Unlock	t
255	Upload	t
256	UploadCloud	t
257	User	t
258	UserCheck	t
259	UserMinus	t
260	UserPlus	t
261	UserX	t
262	Users	t
263	Video	t
264	VideoOff	t
265	Voicemail	t
266	Volume	t
267	Volume1	t
268	Volume2	t
269	VolumeX	t
270	Watch	t
271	Wifi	t
272	WifiOff	t
273	Wind	t
274	X	t
275	XCircle	t
276	XOctagon	t
277	XSquare	t
278	Youtube	t
279	Zap	t
280	ZapOff	t
281	ZoomIn	t
282	ZoomOut	t
283	Store	t
284	PackageSearch	t
285	CircleDollarSign	t
\.


--
-- Data for Name: indicadores; Type: TABLE DATA; Schema: objetivos; Owner: neondb
--

COPY objetivos.indicadores (id_indicadores, indicador, consulta, visible, descripcion, filtro) FROM stdin;
5	Ingresos	select i.monto as value, i.fecha from finanzas.ingresos i	f	\N	1
8	Gastos	select (vc.cantidad * vc.costo) as value, vc.fecha from productos.vw_gastos vg\r\ninner join compras.vw_compras vc on vg.id_productos = vg.id_productos	f	\N	1
9	Ventas por cliente	SELECT\r\n SUM(vv.cantidad * vv.precio) AS value,\r\n MIN(vv.fecha) as fecha\r\n  FROM\r\n  ventas.vw_ventas vv \r\n    \r\n    GROUP BY\r\n        vv.id_personas	f	\N	1
6	Devueltos	select vv.devuelto as value, vv.fecha from ventas.vw_ventas vv	f	\N	1
7	Vendidos	select vv.cantidad as value, vv.fecha from ventas.vw_ventas vv	f	\N	1
10	nuevosclientes	SELECT \r\n    v.id_personas as value, \r\n    v.fecha,\r\n\tv.id_personas as id\r\nFROM \r\n    (SELECT \r\n         id_personas, \r\n         fecha,\r\n         ROW_NUMBER() OVER (PARTITION BY id_personas ORDER BY fecha ASC) AS rn\r\n     FROM ventas.ventas) v\r\nWHERE \r\n    v.rn = 1\r\nORDER BY \r\n    v.fecha ASC	f	\N	1
13	Clientescomienzo	SELECT id_personas as value, id_personas as id, MIN(fecha) AS fecha\r\n    FROM ventas.ventas \r\n    GROUP BY id_personas	f	\N	2
12	Clientesrecurrentes	SELECt\r\n\t\t        v.id_personas as value,\r\n\t\t        v.id_personas as id,\r\n\t\t       fecha\r\n\t\t    FROM\r\n\t\t        ventas.ventas v\r\n\t\t     where V.id_personas in (\r\n\t\t     \tselect id_personas from ventas.ventas v2 \r\n\t\t     \tgroup by id_personas \r\n\t\t     \thaving count(*) >1\r\n\t\t     )	f	\N	1
16	comprapromediocliente	SELECt\r\n\t\t         v.cantidad * v.precio as value,\r\n\t\t         v.id_personas as id,\r\n\t\t         v.fecha \r\n\t\t         \r\n\t\t    FROM\r\n\t\t        ventas.vw_ventas v	t	\N	1
14	Clientesvidautil	SELECT \r\n    EXTRACT(EPOCH FROM vida_util) / 86400 AS value,\r\n\tid_personas as id,\r\n    fecha\r\nFROM (\r\n    SELECT \r\n        v.id_personas, \r\n        AGE(MAX(v.fecha), MIN(v.fecha)) AS vida_util,\r\n        MIN(v.fecha) as fecha\r\n    FROM \r\n        ventas.ventas v \r\n    GROUP BY \r\n        v.id_personas\r\n    HAVING \r\n        COUNT(*) > 1\r\n) AS TOTAL	f	\N	3
15	Clientespromediocompra	SELECt\r\n\t\t         v.cantidad * v.precio as value,\r\n\t\t         v.id_personas as id,\r\n\t\t         v.fecha \r\n\t\t         \r\n\t\t    FROM\r\n\t\t        ventas.vw_ventas v\r\n\t\t     	f	\N	1
4	Egresos	select e.monto as value, e.fecha from finanzas.egresos e	f	\N	1
11	Clientesfinales	SELECt\r\n\t\t        v.id_personas as value,\r\n\t\t        v.id_personas as id,\r\n\t\t       fecha\r\n\t\t    FROM\r\n\t\t        ventas.ventas v	f	\N	1
2	Ventas	SELECT V.CANTIDAD * V.PRECIO AS VALUE, V.FECHA, V.ID_DET_VENTA AS ID FROM VENTAS.VW_VENTAS V	t	\N	1
1	Compras	SELECT C.CANTIDAD * C.COSTO AS VALUE, C.FECHA AS FECHA_INICIO, C.FECHA, C.ID_DET_COMPRA  AS ID FROM COMPRAS.VW_COMPRAS C	t	\N	1
\.


--
-- Data for Name: objetivos; Type: TABLE DATA; Schema: objetivos; Owner: neondb
--

COPY objetivos.objetivos (id_objetivos, titulo, optimo, tolerable, deficiente, fecha_inicio, fecha_final, id_formulas) FROM stdin;
6	Compras	22220	200	51	2023-02-17 00:00:00	2025-02-17 00:00:00	2
29	Retencion de clientes popbb	200	100	21	2021-03-10 00:00:00	2025-03-20 00:00:00	2
12	string	2500	0	0	2024-12-01 00:00:00	2025-03-02 00:00:00	20
31	erhher	223325	22367	331	2025-03-17 00:00:00	2025-03-27 00:00:00	2
9	con otro objetivo	2222	22	11	2023-02-17 00:00:00	2025-02-28 00:00:00	2
18	Compras	25220	200	10	2023-02-17 00:00:00	2025-02-17 00:00:00	2
22	Nuevos clientes	5	3	2	2024-12-01 00:00:00	2025-03-29 00:00:00	20
23	Clientes iniciales	5	3	2	2024-12-01 00:00:00	2025-03-29 00:00:00	21
24	Retencion de clientes diciembre	120	50	20	2024-12-01 00:00:00	2025-04-04 00:00:00	22
25	Retencion de clientes diciembre	120	50	20	2025-03-05 00:00:00	2025-04-04 00:00:00	23
21	vida util	50	20	10	2024-12-01 00:00:00	2025-03-14 00:00:00	19
37	prueba 12/04	2227	111	101	2025-04-12 00:00:00	2025-04-26 00:00:00	3
26	clientes recurrentes diciembre	20	8	5	2023-02-17 00:00:00	2025-02-28 00:00:00	24
27	Cliente-Promedio diciembre	250	150	100	2024-12-01 00:00:00	2025-03-21 00:00:00	24
19	Clientes totales de diciembre-febrero	10	3	2	2024-12-01 00:00:00	2025-03-21 04:00:00	18
20	Clientes totales en general	25	5	2	2023-03-04 00:00:00	2025-03-22 04:00:00	18
35	vida util nn	2222	222	111	2023-01-01 00:00:00	2023-12-31 00:00:00	20
32	afaeeaf	222	22	1	2025-03-21 00:00:00	2025-03-27 04:00:00	23
\.


--
-- Data for Name: perspectiva_etiqueta; Type: TABLE DATA; Schema: objetivos; Owner: neondb
--

COPY objetivos.perspectiva_etiqueta (id_perspectivas, id_etiquetas) FROM stdin;
1	4
7	4
2	4
3	4
8	4
4	4
8	5
2	6
3	6
8	6
11	4
11	5
\.


--
-- Data for Name: perspectivas; Type: TABLE DATA; Schema: objetivos; Owner: neondb
--

COPY objetivos.perspectivas (perspectiva, id_iconos, visible, id_perspectivas) FROM stdin;
Aprendizaje y crecimientp	1	f	4
Procesos internos	\N	f	3
Clientes	\N	f	2
Compras	283	t	11
Finanzas	10	f	1
Ventas	285	t	7
Almacenes	284	t	8
\.


--
-- Data for Name: categorias; Type: TABLE DATA; Schema: productos; Owner: neondb
--

COPY productos.categorias (id_categorias, categoria) FROM stdin;
1	FILTROS
2	MATERIA PRIMA
3	ACCESORIO
4	VIVERES
5	SIN GLUTEN
6	ACCESORIOS
7	COMBOS
8	PASTELES
9	BEBIDAS
10	TRANSFORMADORES
11	CORREAS
12	LICORES
13	CABALLERO
14	PELUQUERIA
15	ACEITES
16	LIMPIEZA
17	CARNICERIA
18	HIGIENE Y BELLEZA
19	FERRETERIA
20	REPUESTOS 
21	PAPELERIA
22	LIBRERIA
23	SERVICIOS
25	Activos
26	Ventas
27	Marketing
28	INNOVACION
\.


--
-- Data for Name: detalle_productos; Type: TABLE DATA; Schema: productos; Owner: neondb
--

COPY productos.detalle_productos (id_detalle_productos, id_productos, id_ingredientes, cantidad, id_unidades) FROM stdin;
1	5	3	1.0	1
2	5	4	2.0	1
3	6	3	1.0	1
4	6	4	1.0	1
5	12	7	0.5	3
6	12	8	1.0	3
7	12	10	1.0	3
8	12	11	3.0	4
10	14	13	5.0	5
13	32	30	0.4	1
14	32	31	0.003	1
16	33	32	15.0	1
21	108	3	4.0	1
22	108	4	8.0	1
23	117	114	4.0	1
24	117	115	8.0	1
27	118	114	4.0	1
28	118	115	8.0	1
29	120	4	1.0	1
30	120	3	1.0	1
31	121	4	1.0	1
32	121	3	1.0	1
34	125	3	1.0	1
\.


--
-- Data for Name: marcas; Type: TABLE DATA; Schema: productos; Owner: neondb
--

COPY productos.marcas (id_marcas, marca) FROM stdin;
1	oster
2	IBERICO
3	WENCA
4	YONDIR
5	ADIDAS
6	ULTRALUB
7	MOTORCRAFT
8	XIBERIA
9	ALIVE
10	GENERICO
11	PAN
\.


--
-- Data for Name: presentaciones; Type: TABLE DATA; Schema: productos; Owner: neondb
--

COPY productos.presentaciones (id_presentaciones, presentacion, id_productos, modificador) FROM stdin;
1	default	5	1.0
2	SACO X 25 KG	30	25.0
3	BOBINA X 50	31	50.0
4	CAJA X 6	38	6.0
5	CAJA X 20 UNID	102	20.0
6	CAJA X 12	1	12.0
\.


--
-- Data for Name: productos; Type: TABLE DATA; Schema: productos; Owner: neondb
--

COPY productos.productos (id_productos, titulo, codigo, id_marcas, id_categorias, id_subcategorias, id_unidades, id_tipo_productos) FROM stdin;
1	ATAMEL	000001	\N	\N	\N	1	2
2	SERV	SERV	\N	\N	\N	1	1
3	MICRO FILTRO UNIVERSAL	MF0001	\N	1	\N	1	2
4	SELLOS	23423434	\N	\N	\N	1	2
5	KIT DE LIMPIEZA DE INYECTOS	123123	\N	\N	\N	1	3
6	KIT DE LIMPIEZA DE INYECTORES	234234	\N	\N	\N	1	5
7	LECHE 1 KG	12312312	\N	2	\N	3	2
8	AZUCAR 1 KG	1231232222	\N	\N	\N	3	2
9	VAINILLA	2343534	\N	2	\N	4	2
10	HARINA DE TRIGO	56786544	\N	2	\N	3	2
11	AGUA LITRO	575645	\N	2	\N	4	2
12	CHICHA 	ENS01	\N	\N	\N	4	5
13	MATERIA PRIMA PLATA 	31232312	\N	\N	\N	5	2
14	PULSERA ESPECIAL DE BODA	01	\N	3	\N	1	3
15	LICUADORA	244343243	\N	\N	\N	1	2
16	PRODUCTO SIN GLUTEN	6540446	\N	5	3	1	2
17	AVENAS SIN GLUTEN	2342343	\N	5	2	1	2
18	TAPA VALVULA DE COROLLA	234234234234	\N	6	4	1	2
19	SERVICIO DE FLETE	23524	\N	\N	\N	1	1
20	MACHETE HERRAMIENTA	242343	\N	3	\N	1	2
21	PRUEBA COMBO	0003	\N	7	\N	1	6
22	VIVIERES PRUEBA	004	\N	4	1	1	2
23	PASTEL DE POLLO 10 CM	00001	\N	8	5	1	2
24	JUGO DE PARCHITA	00002	\N	9	6	1	2
25	COMBO 1	COMBO1	\N	7	\N	1	6
26	PASTEL ANDINO	00004	\N	8	5	1	2
27	JUGO GUANABANA	00005	\N	9	6	1	2
28	CHULETA AHUMADA	00009	1	\N	\N	3	2
29	JAMON AREPERO IBERICO	025211212	2	\N	\N	1	2
30	LECHE EN POLVO X KG MP 	LECHEMP	\N	2	\N	1	2
31	BOBINA PARA BOLSA DE LECHE MP	MPBOBINABOLSA	\N	2	\N	1	2
32	LECHE MAMA CONCHITA X 400GR	LECHE400	\N	\N	\N	1	5
33	BULTO DE 15 LECHES DE 400 GRS	BULTOX15	\N	\N	\N	6	5
34	CORREA DE VENTILADOR YONDIR J150	6030A00848	4	11	8	1	2
35	POLAR PILSEN RET 222MLX36UN PL (E)\t	CP0001	\N	9	\N	1	2
36	FLETE	010110	\N	\N	\N	1	1
37	MANTENIMIENTO DE AIRE	453454	\N	\N	\N	1	2
38	BUCHANNAS 12 A�OS 	5155515151	\N	12	9	1	2
39	ADIDAS SUPERSTAR	0010	5	13	10	1	2
40	adidas campus	0001	5	13	10	7	2
46	adidas campus	Campus	5	13	10	7	2
48	adidas campus	Aaaa	5	13	10	7	2
51	adidas campus	002233	5	13	10	7	2
53	adidas campus	00223393939399299	5	13	10	7	2
94	SECADOR DE PELO	234324234	\N	14	\N	1	2
95	15W40 SEMI SINTETICO ULTRALUB	15W40SM	6	15	11	4	2
96	CLASICO 20W 50 MINERAL	232	\N	15	12	1	2
97	BOLETO AEREO CCS - PMV 	BOL	\N	\N	\N	1	2
99	GASTOS	GASTOS	\N	\N	\N	1	1
100	CELULAR XIAOMI MI 12 LITE	484515555454	\N	\N	\N	1	2
101	NEVERA EHXIBIDORA 4 PUERTAS 	RR4	8	\N	\N	1	2
102	LECHE 1 L 	LECH1L	\N	\N	\N	1	2
103	CARNE DE PEPITO	CARNI00001	\N	17	\N	3	2
104	SHAMPOO ACONDICIONADOR 2 EN 1 ALIVE 350ML	7597257003166	\N	18	\N	9	2
105	DESODORANTE ALIVE AUDAZ FOR MEN ROLL ON 80ML	7597597003246	5	18	\N	9	2
106	CACAO SECO X KG 	CACAOSEC	\N	\N	\N	1	2
107	ATAMEL FORTE	000001515	\N	\N	\N	1	2
108	KIT UNIVERSAL	KIT001P	\N	3	\N	9	3
109	6 ASIENTO BAQUELITA INYECTOR FORD EXPLORER MOTORES 4.0 DOHC F77Z-9G512-A	KIT130	4	3	\N	1	5
110	ARROZ PRIMOR 1KG	1231223123	\N	4	\N	1	2
111	MARTILLO CON MANGO	352354545	\N	19	\N	1	2
112	PAPAS FRITAS DE 200 GR	0004	\N	\N	\N	1	2
113	ARTICULO DE PRUEBA SS 01	0005	\N	\N	\N	1	2
114	MICROFILTRO UNIVERSAL PRUEBA 	MF001PRUEBA	10	20	\N	1	2
115	SELLO UNIVERSAL PRUEBA 	S002PRUEBA	10	20	15	1	2
116	KIT UNIVERSAL PRUEBA 	KIT001PRUEBA	10	20	15	1	5
117	KIT UNIVERSAL 	KIT001PRUEBA1	10	20	15	1	5
118	KIT 002	KIT002	10	20	15	1	3
119	POLEA TIEMPO 	402012345	10	20	15	9	2
120	KIT DE INYECTORES	234323423	\N	\N	\N	1	5
121	KIT INYECTORES 02 COMPUESTO	23434234	\N	\N	\N	1	3
122	A	123457689	\N	\N	\N	1	2
123	INTERNET	G000000012	\N	\N	\N	1	1
124	HARINA PAN 2KG	H138	11	4	\N	9	2
125	NATILLA23	1023	\N	\N	\N	1	5
126	RESMA DE PAPEL CARTA 500 HOJAS	131223123	\N	21	\N	1	2
127	COPIAS BLANCO Y NEGRO CARTA	S01	\N	\N	\N	1	1
128	RECARGA DE TELEFONIA	S02	\N	\N	\N	1	1
129	COPIAR TAMA{P CARTA	COP01	\N	22	17	9	1
130	COPIAS NEGRO T/C	CPIAS01	\N	\N	\N	1	1
131	CAJA DE ZULIA	0101	\N	9	\N	1	2
132	DESTAPAR CA�ERIAS	S001	\N	23	\N	1	1
133	MANTENIMIENTO DE EDIFICACIONES	S002	\N	\N	\N	1	2
134	TEFLON 1 M	3123123123	\N	\N	\N	1	2
\.


--
-- Data for Name: subcategorias; Type: TABLE DATA; Schema: productos; Owner: neondb
--

COPY productos.subcategorias (id_subcategorias, subcategoria) FROM stdin;
1	AVENA
2	CON AZUCAR
3	SIN AZUCAR
4	TAPA VALVULA
5	10 CM
6	JUGOS
7	37.5 KVA
8	VENTILADOR
9	WHISKYS
10	DEPORTIVO
11	ACEITE DE MOTOR
12	ACEITE DE CAJA
13	SHAMPOO
14	DESODORANTES
15	KIT DE INYECTORES
16	HARINAS
17	COPIAS
20	Maquinaria
21	Instagram
23	TECNOLOGIA
24	INFRAESTRUCTURA
25	ALIANZAS
\.


--
-- Data for Name: tipo_productos; Type: TABLE DATA; Schema: productos; Owner: neondb
--

COPY productos.tipo_productos (id_tipo_productos, tipo) FROM stdin;
1	Servicio
2	Articulo
3	Compuesto
4	GASTOS
5	Ensamblado
6	Combo
\.


--
-- Data for Name: unidades; Type: TABLE DATA; Schema: productos; Owner: neondb
--

COPY productos.unidades (id_unidades, unidad) FROM stdin;
1	CAJA
2	SERVICIO
3	KG
4	LT
5	GRAMOS
6	BULTO
7	PARES
8	BOLSA
9	UNIDAD
\.


--
-- Data for Name: ciudades; Type: TABLE DATA; Schema: public; Owner: neondb
--

COPY public.ciudades (id_ciudades, ciudad, id_estados) FROM stdin;
1	Maroa	1
2	Puerto Ayacucho	1
3	San Fernando de Atabapo	1
4	Anaco	2
5	Aragua de Barcelona	2
6	Barcelona	2
7	Boca de Uchire	2
8	Cantaura	2
9	Clarines	2
10	El Chaparro	2
11	El Pao Anzo�tegui	2
12	El Tigre	2
13	El Tigrito	2
14	Guanape	2
15	Guanta	2
16	Lecher�a	2
17	Onoto	2
18	Pariagu�n	2
19	P�ritu	2
20	Puerto La Cruz	2
21	Puerto P�ritu	2
22	Sabana de Uchire	2
23	San Mateo Anzo�tegui	2
24	San Pablo Anzo�tegui	2
25	San Tom�	2
26	Santa Ana de Anzo�tegui	2
27	Santa Fe Anzo�tegui	2
28	Santa Rosa	2
29	Soledad	2
30	Urica	2
31	Valle de Guanape	2
43	Achaguas	3
44	Biruaca	3
45	Bruzual	3
46	El Amparo	3
47	El Nula	3
48	Elorza	3
49	Guasdualito	3
50	Mantecal	3
51	Puerto P�ez	3
52	San Fernando de Apure	3
53	San Juan de Payara	3
54	Barbacoas	4
55	Cagua	4
56	Camatagua	4
58	Choron�	4
59	Colonia Tovar	4
60	El Consejo	4
61	La Victoria	4
62	Las Tejer�as	4
63	Magdaleno	4
64	Maracay	4
65	Ocumare de La Costa	4
66	Palo Negro	4
67	San Casimiro	4
68	San Mateo	4
69	San Sebasti�n	4
70	Santa Cruz de Aragua	4
71	Tocor�n	4
72	Turmero	4
73	Villa de Cura	4
74	Zuata	4
75	Barinas	5
76	Barinitas	5
77	Barrancas	5
78	Calderas	5
79	Capitanejo	5
80	Ciudad Bolivia	5
81	El Cant�n	5
82	Las Veguitas	5
83	Libertad de Barinas	5
84	Sabaneta	5
85	Santa B�rbara de Barinas	5
86	Socop�	5
87	Caicara del Orinoco	6
88	Canaima	6
89	Ciudad Bol�var	6
90	Ciudad Piar	6
91	El Callao	6
92	El Dorado	6
93	El Manteco	6
94	El Palmar	6
95	El Pao	6
96	Guasipati	6
97	Guri	6
98	La Paragua	6
99	Matanzas	6
100	Puerto Ordaz	6
101	San F�lix	6
102	Santa Elena de Uair�n	6
103	Tumeremo	6
104	Unare	6
105	Upata	6
106	Bejuma	7
107	Bel�n	7
108	Campo de Carabobo	7
109	Canoabo	7
110	Central Tacarigua	7
111	Chirgua	7
112	Ciudad Alianza	7
113	El Palito	7
114	Guacara	7
115	Guigue	7
116	Las Trincheras	7
117	Los Guayos	7
118	Mariara	7
119	Miranda	7
120	Montalb�n	7
121	Mor�n	7
122	Naguanagua	7
123	Puerto Cabello	7
124	San Joaqu�n	7
125	Tocuyito	7
126	Urama	7
127	Valencia	7
128	Vigirimita	7
129	Aguirre	8
130	Apartaderos Cojedes	8
131	Arismendi	8
132	Camuriquito	8
133	El Ba�l	8
134	El Lim�n	8
135	El Pao Cojedes	8
136	El Socorro	8
137	La Aguadita	8
138	Las Vegas	8
139	Libertad de Cojedes	8
140	Mapuey	8
141	Pi�edo	8
142	Samancito	8
143	San Carlos	8
144	Sucre	8
145	Tinaco	8
146	Tinaquillo	8
147	Vallecito	8
148	Tucupita	9
149	Caracas	24
150	El Junquito	24
151	Ad�cora	10
152	Boca de Aroa	10
153	Cabure	10
154	Capadare	10
155	Capat�rida	10
156	Chichiriviche	10
157	Churuguara	10
158	Coro	10
159	Cumarebo	10
160	Dabajuro	10
161	Judibana	10
162	La Cruz de Taratara	10
163	La Vela de Coro	10
164	Los Taques	10
165	Maparari	10
166	Mene de Mauroa	10
167	Mirimire	10
168	Pedregal	10
169	P�ritu Falc�n	10
170	Pueblo Nuevo Falc�n	10
171	Puerto Cumarebo	10
172	Punta Card�n	10
173	Punto Fijo	10
174	San Juan de Los Cayos	10
175	San Luis	10
176	Santa Ana Falc�n	10
177	Santa Cruz De Bucaral	10
178	Tocopero	10
179	Tocuyo de La Costa	10
180	Tucacas	10
181	Yaracal	10
182	Altagracia de Orituco	11
183	Cabruta	11
184	Calabozo	11
185	Camagu�n	11
196	Chaguaramas Gu�rico	11
197	El Socorro	11
198	El Sombrero	11
199	Las Mercedes de Los Llanos	11
200	Lezama	11
201	Onoto	11
202	Ort�z	11
203	San Jos� de Guaribe	11
204	San Juan de Los Morros	11
205	San Rafael de Laya	11
206	Santa Mar�a de Ipire	11
207	Tucupido	11
208	Valle de La Pascua	11
209	Zaraza	11
210	Aguada Grande	12
211	Atarigua	12
212	Barquisimeto	12
213	Bobare	12
214	Cabudare	12
215	Carora	12
216	Cubiro	12
217	Cuj�	12
218	Duaca	12
219	El Manzano	12
220	El Tocuyo	12
221	Guar�co	12
222	Humocaro Alto	12
223	Humocaro Bajo	12
224	La Miel	12
225	Moroturo	12
226	Qu�bor	12
227	R�o Claro	12
228	Sanare	12
229	Santa In�s	12
230	Sarare	12
231	Siquisique	12
232	Tintorero	12
233	Apartaderos M�rida	13
234	Arapuey	13
235	Bailadores	13
236	Caja Seca	13
237	Canagu�	13
238	Chachopo	13
239	Chiguara	13
240	Ejido	13
241	El Vig�a	13
242	La Azulita	13
243	La Playa	13
244	Lagunillas M�rida	13
245	M�rida	13
246	Mesa de Bol�var	13
247	Mucuch�es	13
248	Mucujepe	13
249	Mucuruba	13
250	Nueva Bolivia	13
251	Palmarito	13
252	Pueblo Llano	13
253	Santa Cruz de Mora	13
254	Santa Elena de Arenales	13
255	Santo Domingo	13
256	Tab�y	13
257	Timotes	13
258	Torondoy	13
259	Tovar	13
260	Tucani	13
261	Zea	13
262	Araguita	14
263	Carrizal	14
264	Caucagua	14
265	Chaguaramas Miranda	14
266	Charallave	14
267	Chirimena	14
268	Chuspa	14
269	C�a	14
270	Cupira	14
271	Curiepe	14
272	El Guapo	14
273	El Jarillo	14
274	Filas de Mariche	14
275	Guarenas	14
276	Guatire	14
277	Higuerote	14
278	Los Anaucos	14
279	Los Teques	14
280	Ocumare del Tuy	14
281	Panaquire	14
282	Paracotos	14
283	R�o Chico	14
284	San Antonio de Los Altos	14
285	San Diego de Los Altos	14
286	San Fernando del Guapo	14
287	San Francisco de Yare	14
288	San Jos� de Los Altos	14
289	San Jos� de R�o Chico	14
290	San Pedro de Los Altos	14
291	Santa Luc�a	14
292	Santa Teresa	14
293	Tacarigua de La Laguna	14
294	Tacarigua de Mamporal	14
295	T�cata	14
296	Turumo	14
297	Aguasay	15
298	Aragua de Matur�n	15
299	Barrancas del Orinoco	15
300	Caicara de Matur�n	15
301	Caripe	15
302	Caripito	15
303	Chaguaramal	15
305	Chaguaramas Monagas	15
307	El Furrial	15
308	El Tejero	15
309	Jusep�n	15
310	La Toscana	15
311	Matur�n	15
312	Miraflores	15
313	Punta de Mata	15
314	Quiriquire	15
315	San Antonio de Matur�n	15
316	San Vicente Monagas	15
317	Santa B�rbara	15
318	Temblador	15
319	Teresen	15
320	Uracoa	15
321	Altagracia	16
322	Boca de Pozo	16
323	Boca de R�o	16
324	El Espinal	16
325	El Valle del Esp�ritu Santo	16
326	El Yaque	16
327	Juangriego	16
328	La Asunci�n	16
329	La Guardia	16
330	Pampatar	16
331	Porlamar	16
332	Puerto Ferm�n	16
333	Punta de Piedras	16
334	San Francisco de Macanao	16
335	San Juan Bautista	16
336	San Pedro de Coche	16
337	Santa Ana de Nueva Esparta	16
338	Villa Rosa	16
339	Acarigua	17
340	Agua Blanca	17
341	Araure	17
342	Biscucuy	17
343	Boconoito	17
344	Campo El�as	17
345	Chabasqu�n	17
346	Guanare	17
347	Guanarito	17
348	La Aparici�n	17
349	La Misi�n	17
350	Mesa de Cavacas	17
351	Ospino	17
352	Papel�n	17
353	Payara	17
354	Pimpinela	17
355	P�ritu de Portuguesa	17
356	San Rafael de Onoto	17
357	Santa Rosal�a	17
358	Tur�n	17
359	Altos de Sucre	18
360	Araya	18
361	Cariaco	18
362	Car�pano	18
363	Casanay	18
364	Cuman�	18
365	Cumanacoa	18
366	El Morro Puerto Santo	18
367	El Pilar	18
368	El Poblado	18
369	Guaca	18
370	Guiria	18
371	Irapa	18
372	Manicuare	18
373	Mariguitar	18
374	R�o Caribe	18
375	San Antonio del Golfo	18
376	San Jos� de Aerocuar	18
377	San Vicente de Sucre	18
378	Santa Fe de Sucre	18
379	Tunapuy	18
380	Yaguaraparo	18
381	Yoco	18
382	Abejales	19
383	Borota	19
384	Bramon	19
385	Capacho	19
386	Col�n	19
387	Coloncito	19
388	Cordero	19
389	El Cobre	19
390	El Pinal	19
391	Independencia	19
392	La Fr�a	19
393	La Grita	19
394	La Pedrera	19
395	La Tendida	19
396	Las Delicias	19
397	Las Hern�ndez	19
398	Lobatera	19
399	Michelena	19
400	Palmira	19
401	Pregonero	19
402	Queniquea	19
403	Rubio	19
404	San Antonio del Tachira	19
405	San Cristobal	19
406	San Jos� de Bol�var	19
407	San Josecito	19
408	San Pedro del R�o	19
409	Santa Ana T�chira	19
410	Seboruco	19
411	T�riba	19
412	Umuquena	19
413	Ure�a	19
414	Batatal	20
415	Betijoque	20
416	Bocon�	20
417	Carache	20
418	Chejende	20
419	Cuicas	20
420	El Dividive	20
421	El Jaguito	20
422	Escuque	20
423	Isnot�	20
424	Jaj�	20
425	La Ceiba	20
426	La Concepci�n de Trujllo	20
427	La Mesa de Esnujaque	20
428	La Puerta	20
429	La Quebrada	20
430	Mendoza Fr�a	20
431	Meseta de Chimpire	20
432	Monay	20
433	Motat�n	20
434	Pamp�n	20
435	Pampanito	20
436	Sabana de Mendoza	20
437	San L�zaro	20
438	Santa Ana de Trujillo	20
439	Tost�s	20
440	Trujillo	20
441	Valera	20
442	Carayaca	21
443	Litoral	21
444	Archipi�lago Los Roques	25
445	Aroa	22
446	Boraure	22
447	Campo El�as de Yaracuy	22
448	Chivacoa	22
449	Cocorote	22
450	Farriar	22
451	Guama	22
452	Mar�n	22
453	Nirgua	22
454	Sabana de Parra	22
455	Salom	22
456	San Felipe	22
457	San Pablo de Yaracuy	22
458	Urachiche	22
459	Yaritagua	22
460	Yumare	22
461	Bachaquero	23
462	Bobures	23
463	Cabimas	23
464	Campo Concepci�n	23
465	Campo Mara	23
466	Campo Rojo	23
467	Carrasquero	23
468	Casigua	23
469	Chiquinquir�	23
470	Ciudad Ojeda	23
471	El Batey	23
472	El Carmelo	23
473	El Chivo	23
474	El Guayabo	23
475	El Mene	23
476	El Venado	23
477	Encontrados	23
478	Gibraltar	23
479	Isla de Toas	23
480	La Concepci�n del Zulia	23
481	La Paz	23
482	La Sierrita	23
483	Lagunillas del Zulia	23
484	Las Piedras de Perij�	23
485	Los Cortijos	23
486	Machiques	23
487	Maracaibo	23
488	Mene Grande	23
489	Palmarejo	23
490	Paraguaipoa	23
491	Potrerito	23
492	Pueblo Nuevo del Zulia	23
493	Puertos de Altagracia	23
494	Punta Gorda	23
495	Sabaneta de Palma	23
496	San Francisco	23
497	San Jos� de Perij�	23
498	San Rafael del Moj�n	23
499	San Timoteo	23
500	Santa B�rbara Del Zulia	23
501	Santa Cruz de Mara	23
502	Santa Cruz del Zulia	23
503	Santa Rita	23
504	Sinamaica	23
505	Tamare	23
506	T�a Juana	23
507	Villa del Rosario	23
508	La Guaira	21
509	Catia La Mar	21
510	Macuto	21
511	Naiguat�	21
512	Archipi�lago Los Monjes	25
513	Isla La Tortuga y Cayos adyacentes	25
514	Isla La Sola	25
515	Islas Los Testigos	25
516	Islas Los Frailes	25
517	Isla La Orchila	25
518	Archipi�lago Las Aves	25
519	Isla de Aves	25
520	Isla La Blanquilla	25
521	Isla de Patos	25
522	Islas Los Hermanos	25
\.


--
-- Data for Name: estados; Type: TABLE DATA; Schema: public; Owner: neondb
--

COPY public.estados (id_estados, estado) FROM stdin;
1	Amazonas
2	Anzo�tegui
3	Apure
4	Aragua
5	Barinas
6	Bol�var
7	Carabobo
8	Cojedes
9	Delta Amacuro
10	Falc�n
11	Gu�rico
12	Lara
13	M�rida
14	Miranda
15	Monagas
16	Nueva Esparta
17	Portuguesa
18	Sucre
19	T�chira
20	Trujillo
21	Vargas
22	Yaracuy
23	Zulia
24	Distrito Capital
25	Dependencias Federales
\.


--
-- Data for Name: fechas; Type: TABLE DATA; Schema: public; Owner: neondb
--

COPY public.fechas (id_fechas, dia, mes, trimestre, cuatrimestre, semestre, "año", semana) FROM stdin;
1	1	1	1	1	1	2020	1
2	2	1	1	1	1	2020	1
3	3	1	1	1	1	2020	1
4	4	1	1	1	1	2020	1
5	5	1	1	1	1	2020	1
6	6	1	1	1	1	2020	2
7	7	1	1	1	1	2020	2
8	8	1	1	1	1	2020	2
9	9	1	1	1	1	2020	2
10	10	1	1	1	1	2020	2
11	11	1	1	1	1	2020	2
12	12	1	1	1	1	2020	2
13	13	1	1	1	1	2020	3
14	14	1	1	1	1	2020	3
15	15	1	1	1	1	2020	3
16	16	1	1	1	1	2020	3
17	17	1	1	1	1	2020	3
18	18	1	1	1	1	2020	3
19	19	1	1	1	1	2020	3
20	20	1	1	1	1	2020	4
21	21	1	1	1	1	2020	4
22	22	1	1	1	1	2020	4
23	23	1	1	1	1	2020	4
24	24	1	1	1	1	2020	4
25	25	1	1	1	1	2020	4
26	26	1	1	1	1	2020	4
27	27	1	1	1	1	2020	5
28	28	1	1	1	1	2020	5
29	29	1	1	1	1	2020	5
30	30	1	1	1	1	2020	5
31	31	1	1	1	1	2020	5
32	1	2	1	1	1	2020	5
33	2	2	1	1	1	2020	5
34	3	2	1	1	1	2020	6
35	4	2	1	1	1	2020	6
36	5	2	1	1	1	2020	6
37	6	2	1	1	1	2020	6
38	7	2	1	1	1	2020	6
39	8	2	1	1	1	2020	6
40	9	2	1	1	1	2020	6
41	10	2	1	1	1	2020	7
42	11	2	1	1	1	2020	7
43	12	2	1	1	1	2020	7
44	13	2	1	1	1	2020	7
45	14	2	1	1	1	2020	7
46	15	2	1	1	1	2020	7
47	16	2	1	1	1	2020	7
48	17	2	1	1	1	2020	8
49	18	2	1	1	1	2020	8
50	19	2	1	1	1	2020	8
51	20	2	1	1	1	2020	8
52	21	2	1	1	1	2020	8
53	22	2	1	1	1	2020	8
54	23	2	1	1	1	2020	8
55	24	2	1	1	1	2020	9
56	25	2	1	1	1	2020	9
57	26	2	1	1	1	2020	9
58	27	2	1	1	1	2020	9
59	28	2	1	1	1	2020	9
60	29	2	1	1	1	2020	9
61	1	3	1	1	1	2020	9
62	2	3	1	1	1	2020	10
63	3	3	1	1	1	2020	10
64	4	3	1	1	1	2020	10
65	5	3	1	1	1	2020	10
66	6	3	1	1	1	2020	10
67	7	3	1	1	1	2020	10
68	8	3	1	1	1	2020	10
69	9	3	1	1	1	2020	11
70	10	3	1	1	1	2020	11
71	11	3	1	1	1	2020	11
72	12	3	1	1	1	2020	11
73	13	3	1	1	1	2020	11
74	14	3	1	1	1	2020	11
75	15	3	1	1	1	2020	11
76	16	3	1	1	1	2020	12
77	17	3	1	1	1	2020	12
78	18	3	1	1	1	2020	12
79	19	3	1	1	1	2020	12
80	20	3	1	1	1	2020	12
81	21	3	1	1	1	2020	12
82	22	3	1	1	1	2020	12
83	23	3	1	1	1	2020	13
84	24	3	1	1	1	2020	13
85	25	3	1	1	1	2020	13
86	26	3	1	1	1	2020	13
87	27	3	1	1	1	2020	13
88	28	3	1	1	1	2020	13
89	29	3	1	1	1	2020	13
90	30	3	1	1	1	2020	14
91	31	3	1	1	1	2020	14
92	1	4	2	1	1	2020	14
93	2	4	2	1	1	2020	14
94	3	4	2	1	1	2020	14
95	4	4	2	1	1	2020	14
96	5	4	2	1	1	2020	14
97	6	4	2	1	1	2020	15
98	7	4	2	1	1	2020	15
99	8	4	2	1	1	2020	15
100	9	4	2	1	1	2020	15
101	10	4	2	1	1	2020	15
102	11	4	2	1	1	2020	15
103	12	4	2	1	1	2020	15
104	13	4	2	1	1	2020	16
105	14	4	2	1	1	2020	16
106	15	4	2	1	1	2020	16
107	16	4	2	1	1	2020	16
108	17	4	2	1	1	2020	16
109	18	4	2	1	1	2020	16
110	19	4	2	1	1	2020	16
111	20	4	2	1	1	2020	17
112	21	4	2	1	1	2020	17
113	22	4	2	1	1	2020	17
114	23	4	2	1	1	2020	17
115	24	4	2	1	1	2020	17
116	25	4	2	1	1	2020	17
117	26	4	2	1	1	2020	17
118	27	4	2	1	1	2020	18
119	28	4	2	1	1	2020	18
120	29	4	2	1	1	2020	18
121	30	4	2	1	1	2020	18
122	1	5	2	2	1	2020	18
123	2	5	2	2	1	2020	18
124	3	5	2	2	1	2020	18
125	4	5	2	2	1	2020	19
126	5	5	2	2	1	2020	19
127	6	5	2	2	1	2020	19
128	7	5	2	2	1	2020	19
129	8	5	2	2	1	2020	19
130	9	5	2	2	1	2020	19
131	10	5	2	2	1	2020	19
132	11	5	2	2	1	2020	20
133	12	5	2	2	1	2020	20
134	13	5	2	2	1	2020	20
135	14	5	2	2	1	2020	20
136	15	5	2	2	1	2020	20
137	16	5	2	2	1	2020	20
138	17	5	2	2	1	2020	20
139	18	5	2	2	1	2020	21
140	19	5	2	2	1	2020	21
141	20	5	2	2	1	2020	21
142	21	5	2	2	1	2020	21
143	22	5	2	2	1	2020	21
144	23	5	2	2	1	2020	21
145	24	5	2	2	1	2020	21
146	25	5	2	2	1	2020	22
147	26	5	2	2	1	2020	22
148	27	5	2	2	1	2020	22
149	28	5	2	2	1	2020	22
150	29	5	2	2	1	2020	22
151	30	5	2	2	1	2020	22
152	31	5	2	2	1	2020	22
153	1	6	2	2	1	2020	23
154	2	6	2	2	1	2020	23
155	3	6	2	2	1	2020	23
156	4	6	2	2	1	2020	23
157	5	6	2	2	1	2020	23
158	6	6	2	2	1	2020	23
159	7	6	2	2	1	2020	23
160	8	6	2	2	1	2020	24
161	9	6	2	2	1	2020	24
162	10	6	2	2	1	2020	24
163	11	6	2	2	1	2020	24
164	12	6	2	2	1	2020	24
165	13	6	2	2	1	2020	24
166	14	6	2	2	1	2020	24
167	15	6	2	2	1	2020	25
168	16	6	2	2	1	2020	25
169	17	6	2	2	1	2020	25
170	18	6	2	2	1	2020	25
171	19	6	2	2	1	2020	25
172	20	6	2	2	1	2020	25
173	21	6	2	2	1	2020	25
174	22	6	2	2	1	2020	26
175	23	6	2	2	1	2020	26
176	24	6	2	2	1	2020	26
177	25	6	2	2	1	2020	26
178	26	6	2	2	1	2020	26
179	27	6	2	2	1	2020	26
180	28	6	2	2	1	2020	26
181	29	6	2	2	1	2020	27
182	30	6	2	2	1	2020	27
183	1	7	3	2	2	2020	27
184	2	7	3	2	2	2020	27
185	3	7	3	2	2	2020	27
186	4	7	3	2	2	2020	27
187	5	7	3	2	2	2020	27
188	6	7	3	2	2	2020	28
189	7	7	3	2	2	2020	28
190	8	7	3	2	2	2020	28
191	9	7	3	2	2	2020	28
192	10	7	3	2	2	2020	28
193	11	7	3	2	2	2020	28
194	12	7	3	2	2	2020	28
195	13	7	3	2	2	2020	29
196	14	7	3	2	2	2020	29
197	15	7	3	2	2	2020	29
198	16	7	3	2	2	2020	29
199	17	7	3	2	2	2020	29
200	18	7	3	2	2	2020	29
201	19	7	3	2	2	2020	29
202	20	7	3	2	2	2020	30
203	21	7	3	2	2	2020	30
204	22	7	3	2	2	2020	30
205	23	7	3	2	2	2020	30
206	24	7	3	2	2	2020	30
207	25	7	3	2	2	2020	30
208	26	7	3	2	2	2020	30
209	27	7	3	2	2	2020	31
210	28	7	3	2	2	2020	31
211	29	7	3	2	2	2020	31
212	30	7	3	2	2	2020	31
213	31	7	3	2	2	2020	31
214	1	8	3	2	2	2020	31
215	2	8	3	2	2	2020	31
216	3	8	3	2	2	2020	32
217	4	8	3	2	2	2020	32
218	5	8	3	2	2	2020	32
219	6	8	3	2	2	2020	32
220	7	8	3	2	2	2020	32
221	8	8	3	2	2	2020	32
222	9	8	3	2	2	2020	32
223	10	8	3	2	2	2020	33
224	11	8	3	2	2	2020	33
225	12	8	3	2	2	2020	33
226	13	8	3	2	2	2020	33
227	14	8	3	2	2	2020	33
228	15	8	3	2	2	2020	33
229	16	8	3	2	2	2020	33
230	17	8	3	2	2	2020	34
231	18	8	3	2	2	2020	34
232	19	8	3	2	2	2020	34
233	20	8	3	2	2	2020	34
234	21	8	3	2	2	2020	34
235	22	8	3	2	2	2020	34
236	23	8	3	2	2	2020	34
237	24	8	3	2	2	2020	35
238	25	8	3	2	2	2020	35
239	26	8	3	2	2	2020	35
240	27	8	3	2	2	2020	35
241	28	8	3	2	2	2020	35
242	29	8	3	2	2	2020	35
243	30	8	3	2	2	2020	35
244	31	8	3	2	2	2020	36
245	1	9	3	3	2	2020	36
246	2	9	3	3	2	2020	36
247	3	9	3	3	2	2020	36
248	4	9	3	3	2	2020	36
249	5	9	3	3	2	2020	36
250	6	9	3	3	2	2020	36
251	7	9	3	3	2	2020	37
252	8	9	3	3	2	2020	37
253	9	9	3	3	2	2020	37
254	10	9	3	3	2	2020	37
255	11	9	3	3	2	2020	37
256	12	9	3	3	2	2020	37
257	13	9	3	3	2	2020	37
258	14	9	3	3	2	2020	38
259	15	9	3	3	2	2020	38
260	16	9	3	3	2	2020	38
261	17	9	3	3	2	2020	38
262	18	9	3	3	2	2020	38
263	19	9	3	3	2	2020	38
264	20	9	3	3	2	2020	38
265	21	9	3	3	2	2020	39
266	22	9	3	3	2	2020	39
267	23	9	3	3	2	2020	39
268	24	9	3	3	2	2020	39
269	25	9	3	3	2	2020	39
270	26	9	3	3	2	2020	39
271	27	9	3	3	2	2020	39
272	28	9	3	3	2	2020	40
273	29	9	3	3	2	2020	40
274	30	9	3	3	2	2020	40
275	1	10	4	3	2	2020	40
276	2	10	4	3	2	2020	40
277	3	10	4	3	2	2020	40
278	4	10	4	3	2	2020	40
279	5	10	4	3	2	2020	41
280	6	10	4	3	2	2020	41
281	7	10	4	3	2	2020	41
282	8	10	4	3	2	2020	41
283	9	10	4	3	2	2020	41
284	10	10	4	3	2	2020	41
285	11	10	4	3	2	2020	41
286	12	10	4	3	2	2020	42
287	13	10	4	3	2	2020	42
288	14	10	4	3	2	2020	42
289	15	10	4	3	2	2020	42
290	16	10	4	3	2	2020	42
291	17	10	4	3	2	2020	42
292	18	10	4	3	2	2020	42
293	19	10	4	3	2	2020	43
294	20	10	4	3	2	2020	43
295	21	10	4	3	2	2020	43
296	22	10	4	3	2	2020	43
297	23	10	4	3	2	2020	43
298	24	10	4	3	2	2020	43
299	25	10	4	3	2	2020	43
300	26	10	4	3	2	2020	44
301	27	10	4	3	2	2020	44
302	28	10	4	3	2	2020	44
303	29	10	4	3	2	2020	44
304	30	10	4	3	2	2020	44
305	31	10	4	3	2	2020	44
306	1	11	4	3	2	2020	44
307	2	11	4	3	2	2020	45
308	3	11	4	3	2	2020	45
309	4	11	4	3	2	2020	45
310	5	11	4	3	2	2020	45
311	6	11	4	3	2	2020	45
312	7	11	4	3	2	2020	45
313	8	11	4	3	2	2020	45
314	9	11	4	3	2	2020	46
315	10	11	4	3	2	2020	46
316	11	11	4	3	2	2020	46
317	12	11	4	3	2	2020	46
318	13	11	4	3	2	2020	46
319	14	11	4	3	2	2020	46
320	15	11	4	3	2	2020	46
321	16	11	4	3	2	2020	47
322	17	11	4	3	2	2020	47
323	18	11	4	3	2	2020	47
324	19	11	4	3	2	2020	47
325	20	11	4	3	2	2020	47
326	21	11	4	3	2	2020	47
327	22	11	4	3	2	2020	47
328	23	11	4	3	2	2020	48
329	24	11	4	3	2	2020	48
330	25	11	4	3	2	2020	48
331	26	11	4	3	2	2020	48
332	27	11	4	3	2	2020	48
333	28	11	4	3	2	2020	48
334	29	11	4	3	2	2020	48
335	30	11	4	3	2	2020	49
336	1	12	4	3	2	2020	49
337	2	12	4	3	2	2020	49
338	3	12	4	3	2	2020	49
339	4	12	4	3	2	2020	49
340	5	12	4	3	2	2020	49
341	6	12	4	3	2	2020	49
342	7	12	4	3	2	2020	50
343	8	12	4	3	2	2020	50
344	9	12	4	3	2	2020	50
345	10	12	4	3	2	2020	50
346	11	12	4	3	2	2020	50
347	12	12	4	3	2	2020	50
348	13	12	4	3	2	2020	50
349	14	12	4	3	2	2020	51
350	15	12	4	3	2	2020	51
351	16	12	4	3	2	2020	51
352	17	12	4	3	2	2020	51
353	18	12	4	3	2	2020	51
354	19	12	4	3	2	2020	51
355	20	12	4	3	2	2020	51
356	21	12	4	3	2	2020	52
357	22	12	4	3	2	2020	52
358	23	12	4	3	2	2020	52
359	24	12	4	3	2	2020	52
360	25	12	4	3	2	2020	52
361	26	12	4	3	2	2020	52
362	27	12	4	3	2	2020	52
363	28	12	4	3	2	2020	53
364	29	12	4	3	2	2020	53
365	30	12	4	3	2	2020	53
366	31	12	4	3	2	2020	53
367	1	1	1	1	1	2021	53
368	2	1	1	1	1	2021	53
369	3	1	1	1	1	2021	53
370	4	1	1	1	1	2021	1
371	5	1	1	1	1	2021	1
372	6	1	1	1	1	2021	1
373	7	1	1	1	1	2021	1
374	8	1	1	1	1	2021	1
375	9	1	1	1	1	2021	1
376	10	1	1	1	1	2021	1
377	11	1	1	1	1	2021	2
378	12	1	1	1	1	2021	2
379	13	1	1	1	1	2021	2
380	14	1	1	1	1	2021	2
381	15	1	1	1	1	2021	2
382	16	1	1	1	1	2021	2
383	17	1	1	1	1	2021	2
384	18	1	1	1	1	2021	3
385	19	1	1	1	1	2021	3
386	20	1	1	1	1	2021	3
387	21	1	1	1	1	2021	3
388	22	1	1	1	1	2021	3
389	23	1	1	1	1	2021	3
390	24	1	1	1	1	2021	3
391	25	1	1	1	1	2021	4
392	26	1	1	1	1	2021	4
393	27	1	1	1	1	2021	4
394	28	1	1	1	1	2021	4
395	29	1	1	1	1	2021	4
396	30	1	1	1	1	2021	4
397	31	1	1	1	1	2021	4
398	1	2	1	1	1	2021	5
399	2	2	1	1	1	2021	5
400	3	2	1	1	1	2021	5
401	4	2	1	1	1	2021	5
402	5	2	1	1	1	2021	5
403	6	2	1	1	1	2021	5
404	7	2	1	1	1	2021	5
405	8	2	1	1	1	2021	6
406	9	2	1	1	1	2021	6
407	10	2	1	1	1	2021	6
408	11	2	1	1	1	2021	6
409	12	2	1	1	1	2021	6
410	13	2	1	1	1	2021	6
411	14	2	1	1	1	2021	6
412	15	2	1	1	1	2021	7
413	16	2	1	1	1	2021	7
414	17	2	1	1	1	2021	7
415	18	2	1	1	1	2021	7
416	19	2	1	1	1	2021	7
417	20	2	1	1	1	2021	7
418	21	2	1	1	1	2021	7
419	22	2	1	1	1	2021	8
420	23	2	1	1	1	2021	8
421	24	2	1	1	1	2021	8
422	25	2	1	1	1	2021	8
423	26	2	1	1	1	2021	8
424	27	2	1	1	1	2021	8
425	28	2	1	1	1	2021	8
426	1	3	1	1	1	2021	9
427	2	3	1	1	1	2021	9
428	3	3	1	1	1	2021	9
429	4	3	1	1	1	2021	9
430	5	3	1	1	1	2021	9
431	6	3	1	1	1	2021	9
432	7	3	1	1	1	2021	9
433	8	3	1	1	1	2021	10
434	9	3	1	1	1	2021	10
435	10	3	1	1	1	2021	10
436	11	3	1	1	1	2021	10
437	12	3	1	1	1	2021	10
438	13	3	1	1	1	2021	10
439	14	3	1	1	1	2021	10
440	15	3	1	1	1	2021	11
441	16	3	1	1	1	2021	11
442	17	3	1	1	1	2021	11
443	18	3	1	1	1	2021	11
444	19	3	1	1	1	2021	11
445	20	3	1	1	1	2021	11
446	21	3	1	1	1	2021	11
447	22	3	1	1	1	2021	12
448	23	3	1	1	1	2021	12
449	24	3	1	1	1	2021	12
450	25	3	1	1	1	2021	12
451	26	3	1	1	1	2021	12
452	27	3	1	1	1	2021	12
453	28	3	1	1	1	2021	12
454	29	3	1	1	1	2021	13
455	30	3	1	1	1	2021	13
456	31	3	1	1	1	2021	13
457	1	4	2	1	1	2021	13
458	2	4	2	1	1	2021	13
459	3	4	2	1	1	2021	13
460	4	4	2	1	1	2021	13
461	5	4	2	1	1	2021	14
462	6	4	2	1	1	2021	14
463	7	4	2	1	1	2021	14
464	8	4	2	1	1	2021	14
465	9	4	2	1	1	2021	14
466	10	4	2	1	1	2021	14
467	11	4	2	1	1	2021	14
468	12	4	2	1	1	2021	15
469	13	4	2	1	1	2021	15
470	14	4	2	1	1	2021	15
471	15	4	2	1	1	2021	15
472	16	4	2	1	1	2021	15
473	17	4	2	1	1	2021	15
474	18	4	2	1	1	2021	15
475	19	4	2	1	1	2021	16
476	20	4	2	1	1	2021	16
477	21	4	2	1	1	2021	16
478	22	4	2	1	1	2021	16
479	23	4	2	1	1	2021	16
480	24	4	2	1	1	2021	16
481	25	4	2	1	1	2021	16
482	26	4	2	1	1	2021	17
483	27	4	2	1	1	2021	17
484	28	4	2	1	1	2021	17
485	29	4	2	1	1	2021	17
486	30	4	2	1	1	2021	17
487	1	5	2	2	1	2021	17
488	2	5	2	2	1	2021	17
489	3	5	2	2	1	2021	18
490	4	5	2	2	1	2021	18
491	5	5	2	2	1	2021	18
492	6	5	2	2	1	2021	18
493	7	5	2	2	1	2021	18
494	8	5	2	2	1	2021	18
495	9	5	2	2	1	2021	18
496	10	5	2	2	1	2021	19
497	11	5	2	2	1	2021	19
498	12	5	2	2	1	2021	19
499	13	5	2	2	1	2021	19
500	14	5	2	2	1	2021	19
501	15	5	2	2	1	2021	19
502	16	5	2	2	1	2021	19
503	17	5	2	2	1	2021	20
504	18	5	2	2	1	2021	20
505	19	5	2	2	1	2021	20
506	20	5	2	2	1	2021	20
507	21	5	2	2	1	2021	20
508	22	5	2	2	1	2021	20
509	23	5	2	2	1	2021	20
510	24	5	2	2	1	2021	21
511	25	5	2	2	1	2021	21
512	26	5	2	2	1	2021	21
513	27	5	2	2	1	2021	21
514	28	5	2	2	1	2021	21
515	29	5	2	2	1	2021	21
516	30	5	2	2	1	2021	21
517	31	5	2	2	1	2021	22
518	1	6	2	2	1	2021	22
519	2	6	2	2	1	2021	22
520	3	6	2	2	1	2021	22
521	4	6	2	2	1	2021	22
522	5	6	2	2	1	2021	22
523	6	6	2	2	1	2021	22
524	7	6	2	2	1	2021	23
525	8	6	2	2	1	2021	23
526	9	6	2	2	1	2021	23
527	10	6	2	2	1	2021	23
528	11	6	2	2	1	2021	23
529	12	6	2	2	1	2021	23
530	13	6	2	2	1	2021	23
531	14	6	2	2	1	2021	24
532	15	6	2	2	1	2021	24
533	16	6	2	2	1	2021	24
534	17	6	2	2	1	2021	24
535	18	6	2	2	1	2021	24
536	19	6	2	2	1	2021	24
537	20	6	2	2	1	2021	24
538	21	6	2	2	1	2021	25
539	22	6	2	2	1	2021	25
540	23	6	2	2	1	2021	25
541	24	6	2	2	1	2021	25
542	25	6	2	2	1	2021	25
543	26	6	2	2	1	2021	25
544	27	6	2	2	1	2021	25
545	28	6	2	2	1	2021	26
546	29	6	2	2	1	2021	26
547	30	6	2	2	1	2021	26
548	1	7	3	2	2	2021	26
549	2	7	3	2	2	2021	26
550	3	7	3	2	2	2021	26
551	4	7	3	2	2	2021	26
552	5	7	3	2	2	2021	27
553	6	7	3	2	2	2021	27
554	7	7	3	2	2	2021	27
555	8	7	3	2	2	2021	27
556	9	7	3	2	2	2021	27
557	10	7	3	2	2	2021	27
558	11	7	3	2	2	2021	27
559	12	7	3	2	2	2021	28
560	13	7	3	2	2	2021	28
561	14	7	3	2	2	2021	28
562	15	7	3	2	2	2021	28
563	16	7	3	2	2	2021	28
564	17	7	3	2	2	2021	28
565	18	7	3	2	2	2021	28
566	19	7	3	2	2	2021	29
567	20	7	3	2	2	2021	29
568	21	7	3	2	2	2021	29
569	22	7	3	2	2	2021	29
570	23	7	3	2	2	2021	29
571	24	7	3	2	2	2021	29
572	25	7	3	2	2	2021	29
573	26	7	3	2	2	2021	30
574	27	7	3	2	2	2021	30
575	28	7	3	2	2	2021	30
576	29	7	3	2	2	2021	30
577	30	7	3	2	2	2021	30
578	31	7	3	2	2	2021	30
579	1	8	3	2	2	2021	30
580	2	8	3	2	2	2021	31
581	3	8	3	2	2	2021	31
582	4	8	3	2	2	2021	31
583	5	8	3	2	2	2021	31
584	6	8	3	2	2	2021	31
585	7	8	3	2	2	2021	31
586	8	8	3	2	2	2021	31
587	9	8	3	2	2	2021	32
588	10	8	3	2	2	2021	32
589	11	8	3	2	2	2021	32
590	12	8	3	2	2	2021	32
591	13	8	3	2	2	2021	32
592	14	8	3	2	2	2021	32
593	15	8	3	2	2	2021	32
594	16	8	3	2	2	2021	33
595	17	8	3	2	2	2021	33
596	18	8	3	2	2	2021	33
597	19	8	3	2	2	2021	33
598	20	8	3	2	2	2021	33
599	21	8	3	2	2	2021	33
600	22	8	3	2	2	2021	33
601	23	8	3	2	2	2021	34
602	24	8	3	2	2	2021	34
603	25	8	3	2	2	2021	34
604	26	8	3	2	2	2021	34
605	27	8	3	2	2	2021	34
606	28	8	3	2	2	2021	34
607	29	8	3	2	2	2021	34
608	30	8	3	2	2	2021	35
609	31	8	3	2	2	2021	35
610	1	9	3	3	2	2021	35
611	2	9	3	3	2	2021	35
612	3	9	3	3	2	2021	35
613	4	9	3	3	2	2021	35
614	5	9	3	3	2	2021	35
615	6	9	3	3	2	2021	36
616	7	9	3	3	2	2021	36
617	8	9	3	3	2	2021	36
618	9	9	3	3	2	2021	36
619	10	9	3	3	2	2021	36
620	11	9	3	3	2	2021	36
621	12	9	3	3	2	2021	36
622	13	9	3	3	2	2021	37
623	14	9	3	3	2	2021	37
624	15	9	3	3	2	2021	37
625	16	9	3	3	2	2021	37
626	17	9	3	3	2	2021	37
627	18	9	3	3	2	2021	37
628	19	9	3	3	2	2021	37
629	20	9	3	3	2	2021	38
630	21	9	3	3	2	2021	38
631	22	9	3	3	2	2021	38
632	23	9	3	3	2	2021	38
633	24	9	3	3	2	2021	38
634	25	9	3	3	2	2021	38
635	26	9	3	3	2	2021	38
636	27	9	3	3	2	2021	39
637	28	9	3	3	2	2021	39
638	29	9	3	3	2	2021	39
639	30	9	3	3	2	2021	39
640	1	10	4	3	2	2021	39
641	2	10	4	3	2	2021	39
642	3	10	4	3	2	2021	39
643	4	10	4	3	2	2021	40
644	5	10	4	3	2	2021	40
645	6	10	4	3	2	2021	40
646	7	10	4	3	2	2021	40
647	8	10	4	3	2	2021	40
648	9	10	4	3	2	2021	40
649	10	10	4	3	2	2021	40
650	11	10	4	3	2	2021	41
651	12	10	4	3	2	2021	41
652	13	10	4	3	2	2021	41
653	14	10	4	3	2	2021	41
654	15	10	4	3	2	2021	41
655	16	10	4	3	2	2021	41
656	17	10	4	3	2	2021	41
657	18	10	4	3	2	2021	42
658	19	10	4	3	2	2021	42
659	20	10	4	3	2	2021	42
660	21	10	4	3	2	2021	42
661	22	10	4	3	2	2021	42
662	23	10	4	3	2	2021	42
663	24	10	4	3	2	2021	42
664	25	10	4	3	2	2021	43
665	26	10	4	3	2	2021	43
666	27	10	4	3	2	2021	43
667	28	10	4	3	2	2021	43
668	29	10	4	3	2	2021	43
669	30	10	4	3	2	2021	43
670	31	10	4	3	2	2021	43
671	1	11	4	3	2	2021	44
672	2	11	4	3	2	2021	44
673	3	11	4	3	2	2021	44
674	4	11	4	3	2	2021	44
675	5	11	4	3	2	2021	44
676	6	11	4	3	2	2021	44
677	7	11	4	3	2	2021	44
678	8	11	4	3	2	2021	45
679	9	11	4	3	2	2021	45
680	10	11	4	3	2	2021	45
681	11	11	4	3	2	2021	45
682	12	11	4	3	2	2021	45
683	13	11	4	3	2	2021	45
684	14	11	4	3	2	2021	45
685	15	11	4	3	2	2021	46
686	16	11	4	3	2	2021	46
687	17	11	4	3	2	2021	46
688	18	11	4	3	2	2021	46
689	19	11	4	3	2	2021	46
690	20	11	4	3	2	2021	46
691	21	11	4	3	2	2021	46
692	22	11	4	3	2	2021	47
693	23	11	4	3	2	2021	47
694	24	11	4	3	2	2021	47
695	25	11	4	3	2	2021	47
696	26	11	4	3	2	2021	47
697	27	11	4	3	2	2021	47
698	28	11	4	3	2	2021	47
699	29	11	4	3	2	2021	48
700	30	11	4	3	2	2021	48
701	1	12	4	3	2	2021	48
702	2	12	4	3	2	2021	48
703	3	12	4	3	2	2021	48
704	4	12	4	3	2	2021	48
705	5	12	4	3	2	2021	48
706	6	12	4	3	2	2021	49
707	7	12	4	3	2	2021	49
708	8	12	4	3	2	2021	49
709	9	12	4	3	2	2021	49
710	10	12	4	3	2	2021	49
711	11	12	4	3	2	2021	49
712	12	12	4	3	2	2021	49
713	13	12	4	3	2	2021	50
714	14	12	4	3	2	2021	50
715	15	12	4	3	2	2021	50
716	16	12	4	3	2	2021	50
717	17	12	4	3	2	2021	50
718	18	12	4	3	2	2021	50
719	19	12	4	3	2	2021	50
720	20	12	4	3	2	2021	51
721	21	12	4	3	2	2021	51
722	22	12	4	3	2	2021	51
723	23	12	4	3	2	2021	51
724	24	12	4	3	2	2021	51
725	25	12	4	3	2	2021	51
726	26	12	4	3	2	2021	51
727	27	12	4	3	2	2021	52
728	28	12	4	3	2	2021	52
729	29	12	4	3	2	2021	52
730	30	12	4	3	2	2021	52
731	31	12	4	3	2	2021	52
732	1	1	1	1	1	2022	52
733	2	1	1	1	1	2022	52
734	3	1	1	1	1	2022	1
735	4	1	1	1	1	2022	1
736	5	1	1	1	1	2022	1
737	6	1	1	1	1	2022	1
738	7	1	1	1	1	2022	1
739	8	1	1	1	1	2022	1
740	9	1	1	1	1	2022	1
741	10	1	1	1	1	2022	2
742	11	1	1	1	1	2022	2
743	12	1	1	1	1	2022	2
744	13	1	1	1	1	2022	2
745	14	1	1	1	1	2022	2
746	15	1	1	1	1	2022	2
747	16	1	1	1	1	2022	2
748	17	1	1	1	1	2022	3
749	18	1	1	1	1	2022	3
750	19	1	1	1	1	2022	3
751	20	1	1	1	1	2022	3
752	21	1	1	1	1	2022	3
753	22	1	1	1	1	2022	3
754	23	1	1	1	1	2022	3
755	24	1	1	1	1	2022	4
756	25	1	1	1	1	2022	4
757	26	1	1	1	1	2022	4
758	27	1	1	1	1	2022	4
759	28	1	1	1	1	2022	4
760	29	1	1	1	1	2022	4
761	30	1	1	1	1	2022	4
762	31	1	1	1	1	2022	5
763	1	2	1	1	1	2022	5
764	2	2	1	1	1	2022	5
765	3	2	1	1	1	2022	5
766	4	2	1	1	1	2022	5
767	5	2	1	1	1	2022	5
768	6	2	1	1	1	2022	5
769	7	2	1	1	1	2022	6
770	8	2	1	1	1	2022	6
771	9	2	1	1	1	2022	6
772	10	2	1	1	1	2022	6
773	11	2	1	1	1	2022	6
774	12	2	1	1	1	2022	6
775	13	2	1	1	1	2022	6
776	14	2	1	1	1	2022	7
777	15	2	1	1	1	2022	7
778	16	2	1	1	1	2022	7
779	17	2	1	1	1	2022	7
780	18	2	1	1	1	2022	7
781	19	2	1	1	1	2022	7
782	20	2	1	1	1	2022	7
783	21	2	1	1	1	2022	8
784	22	2	1	1	1	2022	8
785	23	2	1	1	1	2022	8
786	24	2	1	1	1	2022	8
787	25	2	1	1	1	2022	8
788	26	2	1	1	1	2022	8
789	27	2	1	1	1	2022	8
790	28	2	1	1	1	2022	9
791	1	3	1	1	1	2022	9
792	2	3	1	1	1	2022	9
793	3	3	1	1	1	2022	9
794	4	3	1	1	1	2022	9
795	5	3	1	1	1	2022	9
796	6	3	1	1	1	2022	9
797	7	3	1	1	1	2022	10
798	8	3	1	1	1	2022	10
799	9	3	1	1	1	2022	10
800	10	3	1	1	1	2022	10
801	11	3	1	1	1	2022	10
802	12	3	1	1	1	2022	10
803	13	3	1	1	1	2022	10
804	14	3	1	1	1	2022	11
805	15	3	1	1	1	2022	11
806	16	3	1	1	1	2022	11
807	17	3	1	1	1	2022	11
808	18	3	1	1	1	2022	11
809	19	3	1	1	1	2022	11
810	20	3	1	1	1	2022	11
811	21	3	1	1	1	2022	12
812	22	3	1	1	1	2022	12
813	23	3	1	1	1	2022	12
814	24	3	1	1	1	2022	12
815	25	3	1	1	1	2022	12
816	26	3	1	1	1	2022	12
817	27	3	1	1	1	2022	12
818	28	3	1	1	1	2022	13
819	29	3	1	1	1	2022	13
820	30	3	1	1	1	2022	13
821	31	3	1	1	1	2022	13
822	1	4	2	1	1	2022	13
823	2	4	2	1	1	2022	13
824	3	4	2	1	1	2022	13
825	4	4	2	1	1	2022	14
826	5	4	2	1	1	2022	14
827	6	4	2	1	1	2022	14
828	7	4	2	1	1	2022	14
829	8	4	2	1	1	2022	14
830	9	4	2	1	1	2022	14
831	10	4	2	1	1	2022	14
832	11	4	2	1	1	2022	15
833	12	4	2	1	1	2022	15
834	13	4	2	1	1	2022	15
835	14	4	2	1	1	2022	15
836	15	4	2	1	1	2022	15
837	16	4	2	1	1	2022	15
838	17	4	2	1	1	2022	15
839	18	4	2	1	1	2022	16
840	19	4	2	1	1	2022	16
841	20	4	2	1	1	2022	16
842	21	4	2	1	1	2022	16
843	22	4	2	1	1	2022	16
844	23	4	2	1	1	2022	16
845	24	4	2	1	1	2022	16
846	25	4	2	1	1	2022	17
847	26	4	2	1	1	2022	17
848	27	4	2	1	1	2022	17
849	28	4	2	1	1	2022	17
850	29	4	2	1	1	2022	17
851	30	4	2	1	1	2022	17
852	1	5	2	2	1	2022	17
853	2	5	2	2	1	2022	18
854	3	5	2	2	1	2022	18
855	4	5	2	2	1	2022	18
856	5	5	2	2	1	2022	18
857	6	5	2	2	1	2022	18
858	7	5	2	2	1	2022	18
859	8	5	2	2	1	2022	18
860	9	5	2	2	1	2022	19
861	10	5	2	2	1	2022	19
862	11	5	2	2	1	2022	19
863	12	5	2	2	1	2022	19
864	13	5	2	2	1	2022	19
865	14	5	2	2	1	2022	19
866	15	5	2	2	1	2022	19
867	16	5	2	2	1	2022	20
868	17	5	2	2	1	2022	20
869	18	5	2	2	1	2022	20
870	19	5	2	2	1	2022	20
871	20	5	2	2	1	2022	20
872	21	5	2	2	1	2022	20
873	22	5	2	2	1	2022	20
874	23	5	2	2	1	2022	21
875	24	5	2	2	1	2022	21
876	25	5	2	2	1	2022	21
877	26	5	2	2	1	2022	21
878	27	5	2	2	1	2022	21
879	28	5	2	2	1	2022	21
880	29	5	2	2	1	2022	21
881	30	5	2	2	1	2022	22
882	31	5	2	2	1	2022	22
883	1	6	2	2	1	2022	22
884	2	6	2	2	1	2022	22
885	3	6	2	2	1	2022	22
886	4	6	2	2	1	2022	22
887	5	6	2	2	1	2022	22
888	6	6	2	2	1	2022	23
889	7	6	2	2	1	2022	23
890	8	6	2	2	1	2022	23
891	9	6	2	2	1	2022	23
892	10	6	2	2	1	2022	23
893	11	6	2	2	1	2022	23
894	12	6	2	2	1	2022	23
895	13	6	2	2	1	2022	24
896	14	6	2	2	1	2022	24
897	15	6	2	2	1	2022	24
898	16	6	2	2	1	2022	24
899	17	6	2	2	1	2022	24
900	18	6	2	2	1	2022	24
901	19	6	2	2	1	2022	24
902	20	6	2	2	1	2022	25
903	21	6	2	2	1	2022	25
904	22	6	2	2	1	2022	25
905	23	6	2	2	1	2022	25
906	24	6	2	2	1	2022	25
907	25	6	2	2	1	2022	25
908	26	6	2	2	1	2022	25
909	27	6	2	2	1	2022	26
910	28	6	2	2	1	2022	26
911	29	6	2	2	1	2022	26
912	30	6	2	2	1	2022	26
913	1	7	3	2	2	2022	26
914	2	7	3	2	2	2022	26
915	3	7	3	2	2	2022	26
916	4	7	3	2	2	2022	27
917	5	7	3	2	2	2022	27
918	6	7	3	2	2	2022	27
919	7	7	3	2	2	2022	27
920	8	7	3	2	2	2022	27
921	9	7	3	2	2	2022	27
922	10	7	3	2	2	2022	27
923	11	7	3	2	2	2022	28
924	12	7	3	2	2	2022	28
925	13	7	3	2	2	2022	28
926	14	7	3	2	2	2022	28
927	15	7	3	2	2	2022	28
928	16	7	3	2	2	2022	28
929	17	7	3	2	2	2022	28
930	18	7	3	2	2	2022	29
931	19	7	3	2	2	2022	29
932	20	7	3	2	2	2022	29
933	21	7	3	2	2	2022	29
934	22	7	3	2	2	2022	29
935	23	7	3	2	2	2022	29
936	24	7	3	2	2	2022	29
937	25	7	3	2	2	2022	30
938	26	7	3	2	2	2022	30
939	27	7	3	2	2	2022	30
940	28	7	3	2	2	2022	30
941	29	7	3	2	2	2022	30
942	30	7	3	2	2	2022	30
943	31	7	3	2	2	2022	30
944	1	8	3	2	2	2022	31
945	2	8	3	2	2	2022	31
946	3	8	3	2	2	2022	31
947	4	8	3	2	2	2022	31
948	5	8	3	2	2	2022	31
949	6	8	3	2	2	2022	31
950	7	8	3	2	2	2022	31
951	8	8	3	2	2	2022	32
952	9	8	3	2	2	2022	32
953	10	8	3	2	2	2022	32
954	11	8	3	2	2	2022	32
955	12	8	3	2	2	2022	32
956	13	8	3	2	2	2022	32
957	14	8	3	2	2	2022	32
958	15	8	3	2	2	2022	33
959	16	8	3	2	2	2022	33
960	17	8	3	2	2	2022	33
961	18	8	3	2	2	2022	33
962	19	8	3	2	2	2022	33
963	20	8	3	2	2	2022	33
964	21	8	3	2	2	2022	33
965	22	8	3	2	2	2022	34
966	23	8	3	2	2	2022	34
967	24	8	3	2	2	2022	34
968	25	8	3	2	2	2022	34
969	26	8	3	2	2	2022	34
970	27	8	3	2	2	2022	34
971	28	8	3	2	2	2022	34
972	29	8	3	2	2	2022	35
973	30	8	3	2	2	2022	35
974	31	8	3	2	2	2022	35
975	1	9	3	3	2	2022	35
976	2	9	3	3	2	2022	35
977	3	9	3	3	2	2022	35
978	4	9	3	3	2	2022	35
979	5	9	3	3	2	2022	36
980	6	9	3	3	2	2022	36
981	7	9	3	3	2	2022	36
982	8	9	3	3	2	2022	36
983	9	9	3	3	2	2022	36
984	10	9	3	3	2	2022	36
985	11	9	3	3	2	2022	36
986	12	9	3	3	2	2022	37
987	13	9	3	3	2	2022	37
988	14	9	3	3	2	2022	37
989	15	9	3	3	2	2022	37
990	16	9	3	3	2	2022	37
991	17	9	3	3	2	2022	37
992	18	9	3	3	2	2022	37
993	19	9	3	3	2	2022	38
994	20	9	3	3	2	2022	38
995	21	9	3	3	2	2022	38
996	22	9	3	3	2	2022	38
997	23	9	3	3	2	2022	38
998	24	9	3	3	2	2022	38
999	25	9	3	3	2	2022	38
1000	26	9	3	3	2	2022	39
1001	27	9	3	3	2	2022	39
1002	28	9	3	3	2	2022	39
1003	29	9	3	3	2	2022	39
1004	30	9	3	3	2	2022	39
1005	1	10	4	3	2	2022	39
1006	2	10	4	3	2	2022	39
1007	3	10	4	3	2	2022	40
1008	4	10	4	3	2	2022	40
1009	5	10	4	3	2	2022	40
1010	6	10	4	3	2	2022	40
1011	7	10	4	3	2	2022	40
1012	8	10	4	3	2	2022	40
1013	9	10	4	3	2	2022	40
1014	10	10	4	3	2	2022	41
1015	11	10	4	3	2	2022	41
1016	12	10	4	3	2	2022	41
1017	13	10	4	3	2	2022	41
1018	14	10	4	3	2	2022	41
1019	15	10	4	3	2	2022	41
1020	16	10	4	3	2	2022	41
1021	17	10	4	3	2	2022	42
1022	18	10	4	3	2	2022	42
1023	19	10	4	3	2	2022	42
1024	20	10	4	3	2	2022	42
1025	21	10	4	3	2	2022	42
1026	22	10	4	3	2	2022	42
1027	23	10	4	3	2	2022	42
1028	24	10	4	3	2	2022	43
1029	25	10	4	3	2	2022	43
1030	26	10	4	3	2	2022	43
1031	27	10	4	3	2	2022	43
1032	28	10	4	3	2	2022	43
1033	29	10	4	3	2	2022	43
1034	30	10	4	3	2	2022	43
1035	31	10	4	3	2	2022	44
1036	1	11	4	3	2	2022	44
1037	2	11	4	3	2	2022	44
1038	3	11	4	3	2	2022	44
1039	4	11	4	3	2	2022	44
1040	5	11	4	3	2	2022	44
1041	6	11	4	3	2	2022	44
1042	7	11	4	3	2	2022	45
1043	8	11	4	3	2	2022	45
1044	9	11	4	3	2	2022	45
1045	10	11	4	3	2	2022	45
1046	11	11	4	3	2	2022	45
1047	12	11	4	3	2	2022	45
1048	13	11	4	3	2	2022	45
1049	14	11	4	3	2	2022	46
1050	15	11	4	3	2	2022	46
1051	16	11	4	3	2	2022	46
1052	17	11	4	3	2	2022	46
1053	18	11	4	3	2	2022	46
1054	19	11	4	3	2	2022	46
1055	20	11	4	3	2	2022	46
1056	21	11	4	3	2	2022	47
1057	22	11	4	3	2	2022	47
1058	23	11	4	3	2	2022	47
1059	24	11	4	3	2	2022	47
1060	25	11	4	3	2	2022	47
1061	26	11	4	3	2	2022	47
1062	27	11	4	3	2	2022	47
1063	28	11	4	3	2	2022	48
1064	29	11	4	3	2	2022	48
1065	30	11	4	3	2	2022	48
1066	1	12	4	3	2	2022	48
1067	2	12	4	3	2	2022	48
1068	3	12	4	3	2	2022	48
1069	4	12	4	3	2	2022	48
1070	5	12	4	3	2	2022	49
1071	6	12	4	3	2	2022	49
1072	7	12	4	3	2	2022	49
1073	8	12	4	3	2	2022	49
1074	9	12	4	3	2	2022	49
1075	10	12	4	3	2	2022	49
1076	11	12	4	3	2	2022	49
1077	12	12	4	3	2	2022	50
1078	13	12	4	3	2	2022	50
1079	14	12	4	3	2	2022	50
1080	15	12	4	3	2	2022	50
1081	16	12	4	3	2	2022	50
1082	17	12	4	3	2	2022	50
1083	18	12	4	3	2	2022	50
1084	19	12	4	3	2	2022	51
1085	20	12	4	3	2	2022	51
1086	21	12	4	3	2	2022	51
1087	22	12	4	3	2	2022	51
1088	23	12	4	3	2	2022	51
1089	24	12	4	3	2	2022	51
1090	25	12	4	3	2	2022	51
1091	26	12	4	3	2	2022	52
1092	27	12	4	3	2	2022	52
1093	28	12	4	3	2	2022	52
1094	29	12	4	3	2	2022	52
1095	30	12	4	3	2	2022	52
1096	31	12	4	3	2	2022	52
1097	1	1	1	1	1	2023	52
1098	2	1	1	1	1	2023	1
1099	3	1	1	1	1	2023	1
1100	4	1	1	1	1	2023	1
1101	5	1	1	1	1	2023	1
1102	6	1	1	1	1	2023	1
1103	7	1	1	1	1	2023	1
1104	8	1	1	1	1	2023	1
1105	9	1	1	1	1	2023	2
1106	10	1	1	1	1	2023	2
1107	11	1	1	1	1	2023	2
1108	12	1	1	1	1	2023	2
1109	13	1	1	1	1	2023	2
1110	14	1	1	1	1	2023	2
1111	15	1	1	1	1	2023	2
1112	16	1	1	1	1	2023	3
1113	17	1	1	1	1	2023	3
1114	18	1	1	1	1	2023	3
1115	19	1	1	1	1	2023	3
1116	20	1	1	1	1	2023	3
1117	21	1	1	1	1	2023	3
1118	22	1	1	1	1	2023	3
1119	23	1	1	1	1	2023	4
1120	24	1	1	1	1	2023	4
1121	25	1	1	1	1	2023	4
1122	26	1	1	1	1	2023	4
1123	27	1	1	1	1	2023	4
1124	28	1	1	1	1	2023	4
1125	29	1	1	1	1	2023	4
1126	30	1	1	1	1	2023	5
1127	31	1	1	1	1	2023	5
1128	1	2	1	1	1	2023	5
1129	2	2	1	1	1	2023	5
1130	3	2	1	1	1	2023	5
1131	4	2	1	1	1	2023	5
1132	5	2	1	1	1	2023	5
1133	6	2	1	1	1	2023	6
1134	7	2	1	1	1	2023	6
1135	8	2	1	1	1	2023	6
1136	9	2	1	1	1	2023	6
1137	10	2	1	1	1	2023	6
1138	11	2	1	1	1	2023	6
1139	12	2	1	1	1	2023	6
1140	13	2	1	1	1	2023	7
1141	14	2	1	1	1	2023	7
1142	15	2	1	1	1	2023	7
1143	16	2	1	1	1	2023	7
1144	17	2	1	1	1	2023	7
1145	18	2	1	1	1	2023	7
1146	19	2	1	1	1	2023	7
1147	20	2	1	1	1	2023	8
1148	21	2	1	1	1	2023	8
1149	22	2	1	1	1	2023	8
1150	23	2	1	1	1	2023	8
1151	24	2	1	1	1	2023	8
1152	25	2	1	1	1	2023	8
1153	26	2	1	1	1	2023	8
1154	27	2	1	1	1	2023	9
1155	28	2	1	1	1	2023	9
1156	1	3	1	1	1	2023	9
1157	2	3	1	1	1	2023	9
1158	3	3	1	1	1	2023	9
1159	4	3	1	1	1	2023	9
1160	5	3	1	1	1	2023	9
1161	6	3	1	1	1	2023	10
1162	7	3	1	1	1	2023	10
1163	8	3	1	1	1	2023	10
1164	9	3	1	1	1	2023	10
1165	10	3	1	1	1	2023	10
1166	11	3	1	1	1	2023	10
1167	12	3	1	1	1	2023	10
1168	13	3	1	1	1	2023	11
1169	14	3	1	1	1	2023	11
1170	15	3	1	1	1	2023	11
1171	16	3	1	1	1	2023	11
1172	17	3	1	1	1	2023	11
1173	18	3	1	1	1	2023	11
1174	19	3	1	1	1	2023	11
1175	20	3	1	1	1	2023	12
1176	21	3	1	1	1	2023	12
1177	22	3	1	1	1	2023	12
1178	23	3	1	1	1	2023	12
1179	24	3	1	1	1	2023	12
1180	25	3	1	1	1	2023	12
1181	26	3	1	1	1	2023	12
1182	27	3	1	1	1	2023	13
1183	28	3	1	1	1	2023	13
1184	29	3	1	1	1	2023	13
1185	30	3	1	1	1	2023	13
1186	31	3	1	1	1	2023	13
1187	1	4	2	1	1	2023	13
1188	2	4	2	1	1	2023	13
1189	3	4	2	1	1	2023	14
1190	4	4	2	1	1	2023	14
1191	5	4	2	1	1	2023	14
1192	6	4	2	1	1	2023	14
1193	7	4	2	1	1	2023	14
1194	8	4	2	1	1	2023	14
1195	9	4	2	1	1	2023	14
1196	10	4	2	1	1	2023	15
1197	11	4	2	1	1	2023	15
1198	12	4	2	1	1	2023	15
1199	13	4	2	1	1	2023	15
1200	14	4	2	1	1	2023	15
1201	15	4	2	1	1	2023	15
1202	16	4	2	1	1	2023	15
1203	17	4	2	1	1	2023	16
1204	18	4	2	1	1	2023	16
1205	19	4	2	1	1	2023	16
1206	20	4	2	1	1	2023	16
1207	21	4	2	1	1	2023	16
1208	22	4	2	1	1	2023	16
1209	23	4	2	1	1	2023	16
1210	24	4	2	1	1	2023	17
1211	25	4	2	1	1	2023	17
1212	26	4	2	1	1	2023	17
1213	27	4	2	1	1	2023	17
1214	28	4	2	1	1	2023	17
1215	29	4	2	1	1	2023	17
1216	30	4	2	1	1	2023	17
1217	1	5	2	2	1	2023	18
1218	2	5	2	2	1	2023	18
1219	3	5	2	2	1	2023	18
1220	4	5	2	2	1	2023	18
1221	5	5	2	2	1	2023	18
1222	6	5	2	2	1	2023	18
1223	7	5	2	2	1	2023	18
1224	8	5	2	2	1	2023	19
1225	9	5	2	2	1	2023	19
1226	10	5	2	2	1	2023	19
1227	11	5	2	2	1	2023	19
1228	12	5	2	2	1	2023	19
1229	13	5	2	2	1	2023	19
1230	14	5	2	2	1	2023	19
1231	15	5	2	2	1	2023	20
1232	16	5	2	2	1	2023	20
1233	17	5	2	2	1	2023	20
1234	18	5	2	2	1	2023	20
1235	19	5	2	2	1	2023	20
1236	20	5	2	2	1	2023	20
1237	21	5	2	2	1	2023	20
1238	22	5	2	2	1	2023	21
1239	23	5	2	2	1	2023	21
1240	24	5	2	2	1	2023	21
1241	25	5	2	2	1	2023	21
1242	26	5	2	2	1	2023	21
1243	27	5	2	2	1	2023	21
1244	28	5	2	2	1	2023	21
1245	29	5	2	2	1	2023	22
1246	30	5	2	2	1	2023	22
1247	31	5	2	2	1	2023	22
1248	1	6	2	2	1	2023	22
1249	2	6	2	2	1	2023	22
1250	3	6	2	2	1	2023	22
1251	4	6	2	2	1	2023	22
1252	5	6	2	2	1	2023	23
1253	6	6	2	2	1	2023	23
1254	7	6	2	2	1	2023	23
1255	8	6	2	2	1	2023	23
1256	9	6	2	2	1	2023	23
1257	10	6	2	2	1	2023	23
1258	11	6	2	2	1	2023	23
1259	12	6	2	2	1	2023	24
1260	13	6	2	2	1	2023	24
1261	14	6	2	2	1	2023	24
1262	15	6	2	2	1	2023	24
1263	16	6	2	2	1	2023	24
1264	17	6	2	2	1	2023	24
1265	18	6	2	2	1	2023	24
1266	19	6	2	2	1	2023	25
1267	20	6	2	2	1	2023	25
1268	21	6	2	2	1	2023	25
1269	22	6	2	2	1	2023	25
1270	23	6	2	2	1	2023	25
1271	24	6	2	2	1	2023	25
1272	25	6	2	2	1	2023	25
1273	26	6	2	2	1	2023	26
1274	27	6	2	2	1	2023	26
1275	28	6	2	2	1	2023	26
1276	29	6	2	2	1	2023	26
1277	30	6	2	2	1	2023	26
1278	1	7	3	2	2	2023	26
1279	2	7	3	2	2	2023	26
1280	3	7	3	2	2	2023	27
1281	4	7	3	2	2	2023	27
1282	5	7	3	2	2	2023	27
1283	6	7	3	2	2	2023	27
1284	7	7	3	2	2	2023	27
1285	8	7	3	2	2	2023	27
1286	9	7	3	2	2	2023	27
1287	10	7	3	2	2	2023	28
1288	11	7	3	2	2	2023	28
1289	12	7	3	2	2	2023	28
1290	13	7	3	2	2	2023	28
1291	14	7	3	2	2	2023	28
1292	15	7	3	2	2	2023	28
1293	16	7	3	2	2	2023	28
1294	17	7	3	2	2	2023	29
1295	18	7	3	2	2	2023	29
1296	19	7	3	2	2	2023	29
1297	20	7	3	2	2	2023	29
1298	21	7	3	2	2	2023	29
1299	22	7	3	2	2	2023	29
1300	23	7	3	2	2	2023	29
1301	24	7	3	2	2	2023	30
1302	25	7	3	2	2	2023	30
1303	26	7	3	2	2	2023	30
1304	27	7	3	2	2	2023	30
1305	28	7	3	2	2	2023	30
1306	29	7	3	2	2	2023	30
1307	30	7	3	2	2	2023	30
1308	31	7	3	2	2	2023	31
1309	1	8	3	2	2	2023	31
1310	2	8	3	2	2	2023	31
1311	3	8	3	2	2	2023	31
1312	4	8	3	2	2	2023	31
1313	5	8	3	2	2	2023	31
1314	6	8	3	2	2	2023	31
1315	7	8	3	2	2	2023	32
1316	8	8	3	2	2	2023	32
1317	9	8	3	2	2	2023	32
1318	10	8	3	2	2	2023	32
1319	11	8	3	2	2	2023	32
1320	12	8	3	2	2	2023	32
1321	13	8	3	2	2	2023	32
1322	14	8	3	2	2	2023	33
1323	15	8	3	2	2	2023	33
1324	16	8	3	2	2	2023	33
1325	17	8	3	2	2	2023	33
1326	18	8	3	2	2	2023	33
1327	19	8	3	2	2	2023	33
1328	20	8	3	2	2	2023	33
1329	21	8	3	2	2	2023	34
1330	22	8	3	2	2	2023	34
1331	23	8	3	2	2	2023	34
1332	24	8	3	2	2	2023	34
1333	25	8	3	2	2	2023	34
1334	26	8	3	2	2	2023	34
1335	27	8	3	2	2	2023	34
1336	28	8	3	2	2	2023	35
1337	29	8	3	2	2	2023	35
1338	30	8	3	2	2	2023	35
1339	31	8	3	2	2	2023	35
1340	1	9	3	3	2	2023	35
1341	2	9	3	3	2	2023	35
1342	3	9	3	3	2	2023	35
1343	4	9	3	3	2	2023	36
1344	5	9	3	3	2	2023	36
1345	6	9	3	3	2	2023	36
1346	7	9	3	3	2	2023	36
1347	8	9	3	3	2	2023	36
1348	9	9	3	3	2	2023	36
1349	10	9	3	3	2	2023	36
1350	11	9	3	3	2	2023	37
1351	12	9	3	3	2	2023	37
1352	13	9	3	3	2	2023	37
1353	14	9	3	3	2	2023	37
1354	15	9	3	3	2	2023	37
1355	16	9	3	3	2	2023	37
1356	17	9	3	3	2	2023	37
1357	18	9	3	3	2	2023	38
1358	19	9	3	3	2	2023	38
1359	20	9	3	3	2	2023	38
1360	21	9	3	3	2	2023	38
1361	22	9	3	3	2	2023	38
1362	23	9	3	3	2	2023	38
1363	24	9	3	3	2	2023	38
1364	25	9	3	3	2	2023	39
1365	26	9	3	3	2	2023	39
1366	27	9	3	3	2	2023	39
1367	28	9	3	3	2	2023	39
1368	29	9	3	3	2	2023	39
1369	30	9	3	3	2	2023	39
1370	1	10	4	3	2	2023	39
1371	2	10	4	3	2	2023	40
1372	3	10	4	3	2	2023	40
1373	4	10	4	3	2	2023	40
1374	5	10	4	3	2	2023	40
1375	6	10	4	3	2	2023	40
1376	7	10	4	3	2	2023	40
1377	8	10	4	3	2	2023	40
1378	9	10	4	3	2	2023	41
1379	10	10	4	3	2	2023	41
1380	11	10	4	3	2	2023	41
1381	12	10	4	3	2	2023	41
1382	13	10	4	3	2	2023	41
1383	14	10	4	3	2	2023	41
1384	15	10	4	3	2	2023	41
1385	16	10	4	3	2	2023	42
1386	17	10	4	3	2	2023	42
1387	18	10	4	3	2	2023	42
1388	19	10	4	3	2	2023	42
1389	20	10	4	3	2	2023	42
1390	21	10	4	3	2	2023	42
1391	22	10	4	3	2	2023	42
1392	23	10	4	3	2	2023	43
1393	24	10	4	3	2	2023	43
1394	25	10	4	3	2	2023	43
1395	26	10	4	3	2	2023	43
1396	27	10	4	3	2	2023	43
1397	28	10	4	3	2	2023	43
1398	29	10	4	3	2	2023	43
1399	30	10	4	3	2	2023	44
1400	31	10	4	3	2	2023	44
1401	1	11	4	3	2	2023	44
1402	2	11	4	3	2	2023	44
1403	3	11	4	3	2	2023	44
1404	4	11	4	3	2	2023	44
1405	5	11	4	3	2	2023	44
1406	6	11	4	3	2	2023	45
1407	7	11	4	3	2	2023	45
1408	8	11	4	3	2	2023	45
1409	9	11	4	3	2	2023	45
1410	10	11	4	3	2	2023	45
1411	11	11	4	3	2	2023	45
1412	12	11	4	3	2	2023	45
1413	13	11	4	3	2	2023	46
1414	14	11	4	3	2	2023	46
1415	15	11	4	3	2	2023	46
1416	16	11	4	3	2	2023	46
1417	17	11	4	3	2	2023	46
1418	18	11	4	3	2	2023	46
1419	19	11	4	3	2	2023	46
1420	20	11	4	3	2	2023	47
1421	21	11	4	3	2	2023	47
1422	22	11	4	3	2	2023	47
1423	23	11	4	3	2	2023	47
1424	24	11	4	3	2	2023	47
1425	25	11	4	3	2	2023	47
1426	26	11	4	3	2	2023	47
1427	27	11	4	3	2	2023	48
1428	28	11	4	3	2	2023	48
1429	29	11	4	3	2	2023	48
1430	30	11	4	3	2	2023	48
1431	1	12	4	3	2	2023	48
1432	2	12	4	3	2	2023	48
1433	3	12	4	3	2	2023	48
1434	4	12	4	3	2	2023	49
1435	5	12	4	3	2	2023	49
1436	6	12	4	3	2	2023	49
1437	7	12	4	3	2	2023	49
1438	8	12	4	3	2	2023	49
1439	9	12	4	3	2	2023	49
1440	10	12	4	3	2	2023	49
1441	11	12	4	3	2	2023	50
1442	12	12	4	3	2	2023	50
1443	13	12	4	3	2	2023	50
1444	14	12	4	3	2	2023	50
1445	15	12	4	3	2	2023	50
1446	16	12	4	3	2	2023	50
1447	17	12	4	3	2	2023	50
1448	18	12	4	3	2	2023	51
1449	19	12	4	3	2	2023	51
1450	20	12	4	3	2	2023	51
1451	21	12	4	3	2	2023	51
1452	22	12	4	3	2	2023	51
1453	23	12	4	3	2	2023	51
1454	24	12	4	3	2	2023	51
1455	25	12	4	3	2	2023	52
1456	26	12	4	3	2	2023	52
1457	27	12	4	3	2	2023	52
1458	28	12	4	3	2	2023	52
1459	29	12	4	3	2	2023	52
1460	30	12	4	3	2	2023	52
1461	31	12	4	3	2	2023	52
1462	1	1	1	1	1	2024	1
1463	2	1	1	1	1	2024	1
1464	3	1	1	1	1	2024	1
1465	4	1	1	1	1	2024	1
1466	5	1	1	1	1	2024	1
1467	6	1	1	1	1	2024	1
1468	7	1	1	1	1	2024	1
1469	8	1	1	1	1	2024	2
1470	9	1	1	1	1	2024	2
1471	10	1	1	1	1	2024	2
1472	11	1	1	1	1	2024	2
1473	12	1	1	1	1	2024	2
1474	13	1	1	1	1	2024	2
1475	14	1	1	1	1	2024	2
1476	15	1	1	1	1	2024	3
1477	16	1	1	1	1	2024	3
1478	17	1	1	1	1	2024	3
1479	18	1	1	1	1	2024	3
1480	19	1	1	1	1	2024	3
1481	20	1	1	1	1	2024	3
1482	21	1	1	1	1	2024	3
1483	22	1	1	1	1	2024	4
1484	23	1	1	1	1	2024	4
1485	24	1	1	1	1	2024	4
1486	25	1	1	1	1	2024	4
1487	26	1	1	1	1	2024	4
1488	27	1	1	1	1	2024	4
1489	28	1	1	1	1	2024	4
1490	29	1	1	1	1	2024	5
1491	30	1	1	1	1	2024	5
1492	31	1	1	1	1	2024	5
1493	1	2	1	1	1	2024	5
1494	2	2	1	1	1	2024	5
1495	3	2	1	1	1	2024	5
1496	4	2	1	1	1	2024	5
1497	5	2	1	1	1	2024	6
1498	6	2	1	1	1	2024	6
1499	7	2	1	1	1	2024	6
1500	8	2	1	1	1	2024	6
1501	9	2	1	1	1	2024	6
1502	10	2	1	1	1	2024	6
1503	11	2	1	1	1	2024	6
1504	12	2	1	1	1	2024	7
1505	13	2	1	1	1	2024	7
1506	14	2	1	1	1	2024	7
1507	15	2	1	1	1	2024	7
1508	16	2	1	1	1	2024	7
1509	17	2	1	1	1	2024	7
1510	18	2	1	1	1	2024	7
1511	19	2	1	1	1	2024	8
1512	20	2	1	1	1	2024	8
1513	21	2	1	1	1	2024	8
1514	22	2	1	1	1	2024	8
1515	23	2	1	1	1	2024	8
1516	24	2	1	1	1	2024	8
1517	25	2	1	1	1	2024	8
1518	26	2	1	1	1	2024	9
1519	27	2	1	1	1	2024	9
1520	28	2	1	1	1	2024	9
1521	29	2	1	1	1	2024	9
1522	1	3	1	1	1	2024	9
1523	2	3	1	1	1	2024	9
1524	3	3	1	1	1	2024	9
1525	4	3	1	1	1	2024	10
1526	5	3	1	1	1	2024	10
1527	6	3	1	1	1	2024	10
1528	7	3	1	1	1	2024	10
1529	8	3	1	1	1	2024	10
1530	9	3	1	1	1	2024	10
1531	10	3	1	1	1	2024	10
1532	11	3	1	1	1	2024	11
1533	12	3	1	1	1	2024	11
1534	13	3	1	1	1	2024	11
1535	14	3	1	1	1	2024	11
1536	15	3	1	1	1	2024	11
1537	16	3	1	1	1	2024	11
1538	17	3	1	1	1	2024	11
1539	18	3	1	1	1	2024	12
1540	19	3	1	1	1	2024	12
1541	20	3	1	1	1	2024	12
1542	21	3	1	1	1	2024	12
1543	22	3	1	1	1	2024	12
1544	23	3	1	1	1	2024	12
1545	24	3	1	1	1	2024	12
1546	25	3	1	1	1	2024	13
1547	26	3	1	1	1	2024	13
1548	27	3	1	1	1	2024	13
1549	28	3	1	1	1	2024	13
1550	29	3	1	1	1	2024	13
1551	30	3	1	1	1	2024	13
1552	31	3	1	1	1	2024	13
1553	1	4	2	1	1	2024	14
1554	2	4	2	1	1	2024	14
1555	3	4	2	1	1	2024	14
1556	4	4	2	1	1	2024	14
1557	5	4	2	1	1	2024	14
1558	6	4	2	1	1	2024	14
1559	7	4	2	1	1	2024	14
1560	8	4	2	1	1	2024	15
1561	9	4	2	1	1	2024	15
1562	10	4	2	1	1	2024	15
1563	11	4	2	1	1	2024	15
1564	12	4	2	1	1	2024	15
1565	13	4	2	1	1	2024	15
1566	14	4	2	1	1	2024	15
1567	15	4	2	1	1	2024	16
1568	16	4	2	1	1	2024	16
1569	17	4	2	1	1	2024	16
1570	18	4	2	1	1	2024	16
1571	19	4	2	1	1	2024	16
1572	20	4	2	1	1	2024	16
1573	21	4	2	1	1	2024	16
1574	22	4	2	1	1	2024	17
1575	23	4	2	1	1	2024	17
1576	24	4	2	1	1	2024	17
1577	25	4	2	1	1	2024	17
1578	26	4	2	1	1	2024	17
1579	27	4	2	1	1	2024	17
1580	28	4	2	1	1	2024	17
1581	29	4	2	1	1	2024	18
1582	30	4	2	1	1	2024	18
1583	1	5	2	2	1	2024	18
1584	2	5	2	2	1	2024	18
1585	3	5	2	2	1	2024	18
1586	4	5	2	2	1	2024	18
1587	5	5	2	2	1	2024	18
1588	6	5	2	2	1	2024	19
1589	7	5	2	2	1	2024	19
1590	8	5	2	2	1	2024	19
1591	9	5	2	2	1	2024	19
1592	10	5	2	2	1	2024	19
1593	11	5	2	2	1	2024	19
1594	12	5	2	2	1	2024	19
1595	13	5	2	2	1	2024	20
1596	14	5	2	2	1	2024	20
1597	15	5	2	2	1	2024	20
1598	16	5	2	2	1	2024	20
1599	17	5	2	2	1	2024	20
1600	18	5	2	2	1	2024	20
1601	19	5	2	2	1	2024	20
1602	20	5	2	2	1	2024	21
1603	21	5	2	2	1	2024	21
1604	22	5	2	2	1	2024	21
1605	23	5	2	2	1	2024	21
1606	24	5	2	2	1	2024	21
1607	25	5	2	2	1	2024	21
1608	26	5	2	2	1	2024	21
1609	27	5	2	2	1	2024	22
1610	28	5	2	2	1	2024	22
1611	29	5	2	2	1	2024	22
1612	30	5	2	2	1	2024	22
1613	31	5	2	2	1	2024	22
1614	1	6	2	2	1	2024	22
1615	2	6	2	2	1	2024	22
1616	3	6	2	2	1	2024	23
1617	4	6	2	2	1	2024	23
1618	5	6	2	2	1	2024	23
1619	6	6	2	2	1	2024	23
1620	7	6	2	2	1	2024	23
1621	8	6	2	2	1	2024	23
1622	9	6	2	2	1	2024	23
1623	10	6	2	2	1	2024	24
1624	11	6	2	2	1	2024	24
1625	12	6	2	2	1	2024	24
1626	13	6	2	2	1	2024	24
1627	14	6	2	2	1	2024	24
1628	15	6	2	2	1	2024	24
1629	16	6	2	2	1	2024	24
1630	17	6	2	2	1	2024	25
1631	18	6	2	2	1	2024	25
1632	19	6	2	2	1	2024	25
1633	20	6	2	2	1	2024	25
1634	21	6	2	2	1	2024	25
1635	22	6	2	2	1	2024	25
1636	23	6	2	2	1	2024	25
1637	24	6	2	2	1	2024	26
1638	25	6	2	2	1	2024	26
1639	26	6	2	2	1	2024	26
1640	27	6	2	2	1	2024	26
1641	28	6	2	2	1	2024	26
1642	29	6	2	2	1	2024	26
1643	30	6	2	2	1	2024	26
1644	1	7	3	2	2	2024	27
1645	2	7	3	2	2	2024	27
1646	3	7	3	2	2	2024	27
1647	4	7	3	2	2	2024	27
1648	5	7	3	2	2	2024	27
1649	6	7	3	2	2	2024	27
1650	7	7	3	2	2	2024	27
1651	8	7	3	2	2	2024	28
1652	9	7	3	2	2	2024	28
1653	10	7	3	2	2	2024	28
1654	11	7	3	2	2	2024	28
1655	12	7	3	2	2	2024	28
1656	13	7	3	2	2	2024	28
1657	14	7	3	2	2	2024	28
1658	15	7	3	2	2	2024	29
1659	16	7	3	2	2	2024	29
1660	17	7	3	2	2	2024	29
1661	18	7	3	2	2	2024	29
1662	19	7	3	2	2	2024	29
1663	20	7	3	2	2	2024	29
1664	21	7	3	2	2	2024	29
1665	22	7	3	2	2	2024	30
1666	23	7	3	2	2	2024	30
1667	24	7	3	2	2	2024	30
1668	25	7	3	2	2	2024	30
1669	26	7	3	2	2	2024	30
1670	27	7	3	2	2	2024	30
1671	28	7	3	2	2	2024	30
1672	29	7	3	2	2	2024	31
1673	30	7	3	2	2	2024	31
1674	31	7	3	2	2	2024	31
1675	1	8	3	2	2	2024	31
1676	2	8	3	2	2	2024	31
1677	3	8	3	2	2	2024	31
1678	4	8	3	2	2	2024	31
1679	5	8	3	2	2	2024	32
1680	6	8	3	2	2	2024	32
1681	7	8	3	2	2	2024	32
1682	8	8	3	2	2	2024	32
1683	9	8	3	2	2	2024	32
1684	10	8	3	2	2	2024	32
1685	11	8	3	2	2	2024	32
1686	12	8	3	2	2	2024	33
1687	13	8	3	2	2	2024	33
1688	14	8	3	2	2	2024	33
1689	15	8	3	2	2	2024	33
1690	16	8	3	2	2	2024	33
1691	17	8	3	2	2	2024	33
1692	18	8	3	2	2	2024	33
1693	19	8	3	2	2	2024	34
1694	20	8	3	2	2	2024	34
1695	21	8	3	2	2	2024	34
1696	22	8	3	2	2	2024	34
1697	23	8	3	2	2	2024	34
1698	24	8	3	2	2	2024	34
1699	25	8	3	2	2	2024	34
1700	26	8	3	2	2	2024	35
1701	27	8	3	2	2	2024	35
1702	28	8	3	2	2	2024	35
1703	29	8	3	2	2	2024	35
1704	30	8	3	2	2	2024	35
1705	31	8	3	2	2	2024	35
1706	1	9	3	3	2	2024	35
1707	2	9	3	3	2	2024	36
1708	3	9	3	3	2	2024	36
1709	4	9	3	3	2	2024	36
1710	5	9	3	3	2	2024	36
1711	6	9	3	3	2	2024	36
1712	7	9	3	3	2	2024	36
1713	8	9	3	3	2	2024	36
1714	9	9	3	3	2	2024	37
1715	10	9	3	3	2	2024	37
1716	11	9	3	3	2	2024	37
1717	12	9	3	3	2	2024	37
1718	13	9	3	3	2	2024	37
1719	14	9	3	3	2	2024	37
1720	15	9	3	3	2	2024	37
1721	16	9	3	3	2	2024	38
1722	17	9	3	3	2	2024	38
1723	18	9	3	3	2	2024	38
1724	19	9	3	3	2	2024	38
1725	20	9	3	3	2	2024	38
1726	21	9	3	3	2	2024	38
1727	22	9	3	3	2	2024	38
1728	23	9	3	3	2	2024	39
1729	24	9	3	3	2	2024	39
1730	25	9	3	3	2	2024	39
1731	26	9	3	3	2	2024	39
1732	27	9	3	3	2	2024	39
1733	28	9	3	3	2	2024	39
1734	29	9	3	3	2	2024	39
1735	30	9	3	3	2	2024	40
1736	1	10	4	3	2	2024	40
1737	2	10	4	3	2	2024	40
1738	3	10	4	3	2	2024	40
1739	4	10	4	3	2	2024	40
1740	5	10	4	3	2	2024	40
1741	6	10	4	3	2	2024	40
1742	7	10	4	3	2	2024	41
1743	8	10	4	3	2	2024	41
1744	9	10	4	3	2	2024	41
1745	10	10	4	3	2	2024	41
1746	11	10	4	3	2	2024	41
1747	12	10	4	3	2	2024	41
1748	13	10	4	3	2	2024	41
1749	14	10	4	3	2	2024	42
1750	15	10	4	3	2	2024	42
1751	16	10	4	3	2	2024	42
1752	17	10	4	3	2	2024	42
1753	18	10	4	3	2	2024	42
1754	19	10	4	3	2	2024	42
1755	20	10	4	3	2	2024	42
1756	21	10	4	3	2	2024	43
1757	22	10	4	3	2	2024	43
1758	23	10	4	3	2	2024	43
1759	24	10	4	3	2	2024	43
1760	25	10	4	3	2	2024	43
1761	26	10	4	3	2	2024	43
1762	27	10	4	3	2	2024	43
1763	28	10	4	3	2	2024	44
1764	29	10	4	3	2	2024	44
1765	30	10	4	3	2	2024	44
1766	31	10	4	3	2	2024	44
1767	1	11	4	3	2	2024	44
1768	2	11	4	3	2	2024	44
1769	3	11	4	3	2	2024	44
1770	4	11	4	3	2	2024	45
1771	5	11	4	3	2	2024	45
1772	6	11	4	3	2	2024	45
1773	7	11	4	3	2	2024	45
1774	8	11	4	3	2	2024	45
1775	9	11	4	3	2	2024	45
1776	10	11	4	3	2	2024	45
1777	11	11	4	3	2	2024	46
1778	12	11	4	3	2	2024	46
1779	13	11	4	3	2	2024	46
1780	14	11	4	3	2	2024	46
1781	15	11	4	3	2	2024	46
1782	16	11	4	3	2	2024	46
1783	17	11	4	3	2	2024	46
1784	18	11	4	3	2	2024	47
1785	19	11	4	3	2	2024	47
1786	20	11	4	3	2	2024	47
1787	21	11	4	3	2	2024	47
1788	22	11	4	3	2	2024	47
1789	23	11	4	3	2	2024	47
1790	24	11	4	3	2	2024	47
1791	25	11	4	3	2	2024	48
1792	26	11	4	3	2	2024	48
1793	27	11	4	3	2	2024	48
1794	28	11	4	3	2	2024	48
1795	29	11	4	3	2	2024	48
1796	30	11	4	3	2	2024	48
1797	1	12	4	3	2	2024	48
1798	2	12	4	3	2	2024	49
1799	3	12	4	3	2	2024	49
1800	4	12	4	3	2	2024	49
1801	5	12	4	3	2	2024	49
1802	6	12	4	3	2	2024	49
1803	7	12	4	3	2	2024	49
1804	8	12	4	3	2	2024	49
1805	9	12	4	3	2	2024	50
1806	10	12	4	3	2	2024	50
1807	11	12	4	3	2	2024	50
1808	12	12	4	3	2	2024	50
1809	13	12	4	3	2	2024	50
1810	14	12	4	3	2	2024	50
1811	15	12	4	3	2	2024	50
1812	16	12	4	3	2	2024	51
1813	17	12	4	3	2	2024	51
1814	18	12	4	3	2	2024	51
1815	19	12	4	3	2	2024	51
1816	20	12	4	3	2	2024	51
1817	21	12	4	3	2	2024	51
1818	22	12	4	3	2	2024	51
1819	23	12	4	3	2	2024	52
1820	24	12	4	3	2	2024	52
1821	25	12	4	3	2	2024	52
1822	26	12	4	3	2	2024	52
1823	27	12	4	3	2	2024	52
1824	28	12	4	3	2	2024	52
1825	29	12	4	3	2	2024	52
1826	30	12	4	3	2	2024	1
1827	31	12	4	3	2	2024	1
1828	1	1	1	1	1	2025	1
1829	2	1	1	1	1	2025	1
1830	3	1	1	1	1	2025	1
1831	4	1	1	1	1	2025	1
1832	5	1	1	1	1	2025	1
1833	6	1	1	1	1	2025	2
1834	7	1	1	1	1	2025	2
1835	8	1	1	1	1	2025	2
1836	9	1	1	1	1	2025	2
1837	10	1	1	1	1	2025	2
1838	11	1	1	1	1	2025	2
1839	12	1	1	1	1	2025	2
1840	13	1	1	1	1	2025	3
1841	14	1	1	1	1	2025	3
1842	15	1	1	1	1	2025	3
1843	16	1	1	1	1	2025	3
1844	17	1	1	1	1	2025	3
1845	18	1	1	1	1	2025	3
1846	19	1	1	1	1	2025	3
1847	20	1	1	1	1	2025	4
1848	21	1	1	1	1	2025	4
1849	22	1	1	1	1	2025	4
1850	23	1	1	1	1	2025	4
1851	24	1	1	1	1	2025	4
1852	25	1	1	1	1	2025	4
1853	26	1	1	1	1	2025	4
1854	27	1	1	1	1	2025	5
1855	28	1	1	1	1	2025	5
1856	29	1	1	1	1	2025	5
1857	30	1	1	1	1	2025	5
1858	31	1	1	1	1	2025	5
1859	1	2	1	1	1	2025	5
1860	2	2	1	1	1	2025	5
1861	3	2	1	1	1	2025	6
1862	4	2	1	1	1	2025	6
1863	5	2	1	1	1	2025	6
1864	6	2	1	1	1	2025	6
1865	7	2	1	1	1	2025	6
1866	8	2	1	1	1	2025	6
1867	9	2	1	1	1	2025	6
1868	10	2	1	1	1	2025	7
1869	11	2	1	1	1	2025	7
1870	12	2	1	1	1	2025	7
1871	13	2	1	1	1	2025	7
1872	14	2	1	1	1	2025	7
1873	15	2	1	1	1	2025	7
1874	16	2	1	1	1	2025	7
1875	17	2	1	1	1	2025	8
1876	18	2	1	1	1	2025	8
1877	19	2	1	1	1	2025	8
1878	20	2	1	1	1	2025	8
1879	21	2	1	1	1	2025	8
1880	22	2	1	1	1	2025	8
1881	23	2	1	1	1	2025	8
1882	24	2	1	1	1	2025	9
1883	25	2	1	1	1	2025	9
1884	26	2	1	1	1	2025	9
1885	27	2	1	1	1	2025	9
1886	28	2	1	1	1	2025	9
1887	1	3	1	1	1	2025	9
1888	2	3	1	1	1	2025	9
1889	3	3	1	1	1	2025	10
1890	4	3	1	1	1	2025	10
1891	5	3	1	1	1	2025	10
1892	6	3	1	1	1	2025	10
1893	7	3	1	1	1	2025	10
1894	8	3	1	1	1	2025	10
1895	9	3	1	1	1	2025	10
1896	10	3	1	1	1	2025	11
1897	11	3	1	1	1	2025	11
1898	12	3	1	1	1	2025	11
1899	13	3	1	1	1	2025	11
1900	14	3	1	1	1	2025	11
1901	15	3	1	1	1	2025	11
1902	16	3	1	1	1	2025	11
1903	17	3	1	1	1	2025	12
1904	18	3	1	1	1	2025	12
1905	19	3	1	1	1	2025	12
1906	20	3	1	1	1	2025	12
1907	21	3	1	1	1	2025	12
1908	22	3	1	1	1	2025	12
1909	23	3	1	1	1	2025	12
1910	24	3	1	1	1	2025	13
1911	25	3	1	1	1	2025	13
1912	26	3	1	1	1	2025	13
1913	27	3	1	1	1	2025	13
1914	28	3	1	1	1	2025	13
1915	29	3	1	1	1	2025	13
1916	30	3	1	1	1	2025	13
1917	31	3	1	1	1	2025	14
1918	1	4	2	1	1	2025	14
1919	2	4	2	1	1	2025	14
1920	3	4	2	1	1	2025	14
1921	4	4	2	1	1	2025	14
1922	5	4	2	1	1	2025	14
1923	6	4	2	1	1	2025	14
1924	7	4	2	1	1	2025	15
1925	8	4	2	1	1	2025	15
1926	9	4	2	1	1	2025	15
1927	10	4	2	1	1	2025	15
1928	11	4	2	1	1	2025	15
1929	12	4	2	1	1	2025	15
1930	13	4	2	1	1	2025	15
1931	14	4	2	1	1	2025	16
1932	15	4	2	1	1	2025	16
1933	16	4	2	1	1	2025	16
1934	17	4	2	1	1	2025	16
1935	18	4	2	1	1	2025	16
1936	19	4	2	1	1	2025	16
1937	20	4	2	1	1	2025	16
1938	21	4	2	1	1	2025	17
1939	22	4	2	1	1	2025	17
1940	23	4	2	1	1	2025	17
1941	24	4	2	1	1	2025	17
1942	25	4	2	1	1	2025	17
1943	26	4	2	1	1	2025	17
1944	27	4	2	1	1	2025	17
1945	28	4	2	1	1	2025	18
1946	29	4	2	1	1	2025	18
1947	30	4	2	1	1	2025	18
1948	1	5	2	2	1	2025	18
1949	2	5	2	2	1	2025	18
1950	3	5	2	2	1	2025	18
1951	4	5	2	2	1	2025	18
1952	5	5	2	2	1	2025	19
1953	6	5	2	2	1	2025	19
1954	7	5	2	2	1	2025	19
1955	8	5	2	2	1	2025	19
1956	9	5	2	2	1	2025	19
1957	10	5	2	2	1	2025	19
1958	11	5	2	2	1	2025	19
1959	12	5	2	2	1	2025	20
1960	13	5	2	2	1	2025	20
1961	14	5	2	2	1	2025	20
1962	15	5	2	2	1	2025	20
1963	16	5	2	2	1	2025	20
1964	17	5	2	2	1	2025	20
1965	18	5	2	2	1	2025	20
1966	19	5	2	2	1	2025	21
1967	20	5	2	2	1	2025	21
1968	21	5	2	2	1	2025	21
1969	22	5	2	2	1	2025	21
1970	23	5	2	2	1	2025	21
1971	24	5	2	2	1	2025	21
1972	25	5	2	2	1	2025	21
1973	26	5	2	2	1	2025	22
1974	27	5	2	2	1	2025	22
1975	28	5	2	2	1	2025	22
1976	29	5	2	2	1	2025	22
1977	30	5	2	2	1	2025	22
1978	31	5	2	2	1	2025	22
1979	1	6	2	2	1	2025	22
1980	2	6	2	2	1	2025	23
1981	3	6	2	2	1	2025	23
1982	4	6	2	2	1	2025	23
1983	5	6	2	2	1	2025	23
1984	6	6	2	2	1	2025	23
1985	7	6	2	2	1	2025	23
1986	8	6	2	2	1	2025	23
1987	9	6	2	2	1	2025	24
1988	10	6	2	2	1	2025	24
1989	11	6	2	2	1	2025	24
1990	12	6	2	2	1	2025	24
1991	13	6	2	2	1	2025	24
1992	14	6	2	2	1	2025	24
1993	15	6	2	2	1	2025	24
1994	16	6	2	2	1	2025	25
1995	17	6	2	2	1	2025	25
1996	18	6	2	2	1	2025	25
1997	19	6	2	2	1	2025	25
1998	20	6	2	2	1	2025	25
1999	21	6	2	2	1	2025	25
2000	22	6	2	2	1	2025	25
2001	23	6	2	2	1	2025	26
2002	24	6	2	2	1	2025	26
2003	25	6	2	2	1	2025	26
2004	26	6	2	2	1	2025	26
2005	27	6	2	2	1	2025	26
2006	28	6	2	2	1	2025	26
2007	29	6	2	2	1	2025	26
2008	30	6	2	2	1	2025	27
2009	1	7	3	2	2	2025	27
2010	2	7	3	2	2	2025	27
2011	3	7	3	2	2	2025	27
2012	4	7	3	2	2	2025	27
2013	5	7	3	2	2	2025	27
2014	6	7	3	2	2	2025	27
2015	7	7	3	2	2	2025	28
2016	8	7	3	2	2	2025	28
2017	9	7	3	2	2	2025	28
2018	10	7	3	2	2	2025	28
2019	11	7	3	2	2	2025	28
2020	12	7	3	2	2	2025	28
2021	13	7	3	2	2	2025	28
2022	14	7	3	2	2	2025	29
2023	15	7	3	2	2	2025	29
2024	16	7	3	2	2	2025	29
2025	17	7	3	2	2	2025	29
2026	18	7	3	2	2	2025	29
2027	19	7	3	2	2	2025	29
2028	20	7	3	2	2	2025	29
2029	21	7	3	2	2	2025	30
2030	22	7	3	2	2	2025	30
2031	23	7	3	2	2	2025	30
2032	24	7	3	2	2	2025	30
2033	25	7	3	2	2	2025	30
2034	26	7	3	2	2	2025	30
2035	27	7	3	2	2	2025	30
2036	28	7	3	2	2	2025	31
2037	29	7	3	2	2	2025	31
2038	30	7	3	2	2	2025	31
2039	31	7	3	2	2	2025	31
2040	1	8	3	2	2	2025	31
2041	2	8	3	2	2	2025	31
2042	3	8	3	2	2	2025	31
2043	4	8	3	2	2	2025	32
2044	5	8	3	2	2	2025	32
2045	6	8	3	2	2	2025	32
2046	7	8	3	2	2	2025	32
2047	8	8	3	2	2	2025	32
2048	9	8	3	2	2	2025	32
2049	10	8	3	2	2	2025	32
2050	11	8	3	2	2	2025	33
2051	12	8	3	2	2	2025	33
2052	13	8	3	2	2	2025	33
2053	14	8	3	2	2	2025	33
2054	15	8	3	2	2	2025	33
2055	16	8	3	2	2	2025	33
2056	17	8	3	2	2	2025	33
2057	18	8	3	2	2	2025	34
2058	19	8	3	2	2	2025	34
2059	20	8	3	2	2	2025	34
2060	21	8	3	2	2	2025	34
2061	22	8	3	2	2	2025	34
2062	23	8	3	2	2	2025	34
2063	24	8	3	2	2	2025	34
2064	25	8	3	2	2	2025	35
2065	26	8	3	2	2	2025	35
2066	27	8	3	2	2	2025	35
2067	28	8	3	2	2	2025	35
2068	29	8	3	2	2	2025	35
2069	30	8	3	2	2	2025	35
2070	31	8	3	2	2	2025	35
2071	1	9	3	3	2	2025	36
2072	2	9	3	3	2	2025	36
2073	3	9	3	3	2	2025	36
2074	4	9	3	3	2	2025	36
2075	5	9	3	3	2	2025	36
2076	6	9	3	3	2	2025	36
2077	7	9	3	3	2	2025	36
2078	8	9	3	3	2	2025	37
2079	9	9	3	3	2	2025	37
2080	10	9	3	3	2	2025	37
2081	11	9	3	3	2	2025	37
2082	12	9	3	3	2	2025	37
2083	13	9	3	3	2	2025	37
2084	14	9	3	3	2	2025	37
2085	15	9	3	3	2	2025	38
2086	16	9	3	3	2	2025	38
2087	17	9	3	3	2	2025	38
2088	18	9	3	3	2	2025	38
2089	19	9	3	3	2	2025	38
2090	20	9	3	3	2	2025	38
2091	21	9	3	3	2	2025	38
2092	22	9	3	3	2	2025	39
2093	23	9	3	3	2	2025	39
2094	24	9	3	3	2	2025	39
2095	25	9	3	3	2	2025	39
2096	26	9	3	3	2	2025	39
2097	27	9	3	3	2	2025	39
2098	28	9	3	3	2	2025	39
2099	29	9	3	3	2	2025	40
2100	30	9	3	3	2	2025	40
2101	1	10	4	3	2	2025	40
2102	2	10	4	3	2	2025	40
2103	3	10	4	3	2	2025	40
2104	4	10	4	3	2	2025	40
2105	5	10	4	3	2	2025	40
2106	6	10	4	3	2	2025	41
2107	7	10	4	3	2	2025	41
2108	8	10	4	3	2	2025	41
2109	9	10	4	3	2	2025	41
2110	10	10	4	3	2	2025	41
2111	11	10	4	3	2	2025	41
2112	12	10	4	3	2	2025	41
2113	13	10	4	3	2	2025	42
2114	14	10	4	3	2	2025	42
2115	15	10	4	3	2	2025	42
2116	16	10	4	3	2	2025	42
2117	17	10	4	3	2	2025	42
2118	18	10	4	3	2	2025	42
2119	19	10	4	3	2	2025	42
2120	20	10	4	3	2	2025	43
2121	21	10	4	3	2	2025	43
2122	22	10	4	3	2	2025	43
2123	23	10	4	3	2	2025	43
2124	24	10	4	3	2	2025	43
2125	25	10	4	3	2	2025	43
2126	26	10	4	3	2	2025	43
2127	27	10	4	3	2	2025	44
2128	28	10	4	3	2	2025	44
2129	29	10	4	3	2	2025	44
2130	30	10	4	3	2	2025	44
2131	31	10	4	3	2	2025	44
2132	1	11	4	3	2	2025	44
2133	2	11	4	3	2	2025	44
2134	3	11	4	3	2	2025	45
2135	4	11	4	3	2	2025	45
2136	5	11	4	3	2	2025	45
2137	6	11	4	3	2	2025	45
2138	7	11	4	3	2	2025	45
2139	8	11	4	3	2	2025	45
2140	9	11	4	3	2	2025	45
2141	10	11	4	3	2	2025	46
2142	11	11	4	3	2	2025	46
2143	12	11	4	3	2	2025	46
2144	13	11	4	3	2	2025	46
2145	14	11	4	3	2	2025	46
2146	15	11	4	3	2	2025	46
2147	16	11	4	3	2	2025	46
2148	17	11	4	3	2	2025	47
2149	18	11	4	3	2	2025	47
2150	19	11	4	3	2	2025	47
2151	20	11	4	3	2	2025	47
2152	21	11	4	3	2	2025	47
2153	22	11	4	3	2	2025	47
2154	23	11	4	3	2	2025	47
2155	24	11	4	3	2	2025	48
2156	25	11	4	3	2	2025	48
2157	26	11	4	3	2	2025	48
2158	27	11	4	3	2	2025	48
2159	28	11	4	3	2	2025	48
2160	29	11	4	3	2	2025	48
2161	30	11	4	3	2	2025	48
2162	1	12	4	3	2	2025	49
2163	2	12	4	3	2	2025	49
2164	3	12	4	3	2	2025	49
2165	4	12	4	3	2	2025	49
2166	5	12	4	3	2	2025	49
2167	6	12	4	3	2	2025	49
2168	7	12	4	3	2	2025	49
2169	8	12	4	3	2	2025	50
2170	9	12	4	3	2	2025	50
2171	10	12	4	3	2	2025	50
2172	11	12	4	3	2	2025	50
2173	12	12	4	3	2	2025	50
2174	13	12	4	3	2	2025	50
2175	14	12	4	3	2	2025	50
2176	15	12	4	3	2	2025	51
2177	16	12	4	3	2	2025	51
2178	17	12	4	3	2	2025	51
2179	18	12	4	3	2	2025	51
2180	19	12	4	3	2	2025	51
2181	20	12	4	3	2	2025	51
2182	21	12	4	3	2	2025	51
2183	22	12	4	3	2	2025	52
2184	23	12	4	3	2	2025	52
2185	24	12	4	3	2	2025	52
2186	25	12	4	3	2	2025	52
2187	26	12	4	3	2	2025	52
2188	27	12	4	3	2	2025	52
2189	28	12	4	3	2	2025	52
2190	29	12	4	3	2	2025	1
2191	30	12	4	3	2	2025	1
2192	31	12	4	3	2	2025	1
\.


--
-- Data for Name: horas; Type: TABLE DATA; Schema: public; Owner: neondb
--

COPY public.horas (id_horas, hora, minutos) FROM stdin;
1	0	0
2	0	1
3	0	2
4	0	3
5	0	4
6	0	5
7	0	6
8	0	7
9	0	8
10	0	9
11	0	10
12	0	11
13	0	12
14	0	13
15	0	14
16	0	15
17	0	16
18	0	17
19	0	18
20	0	19
21	0	20
22	0	21
23	0	22
24	0	23
25	0	24
26	0	25
27	0	26
28	0	27
29	0	28
30	0	29
31	0	30
32	0	31
33	0	32
34	0	33
35	0	34
36	0	35
37	0	36
38	0	37
39	0	38
40	0	39
41	0	40
42	0	41
43	0	42
44	0	43
45	0	44
46	0	45
47	0	46
48	0	47
49	0	48
50	0	49
51	0	50
52	0	51
53	0	52
54	0	53
55	0	54
56	0	55
57	0	56
58	0	57
59	0	58
60	0	59
61	1	0
62	1	1
63	1	2
64	1	3
65	1	4
66	1	5
67	1	6
68	1	7
69	1	8
70	1	9
71	1	10
72	1	11
73	1	12
74	1	13
75	1	14
76	1	15
77	1	16
78	1	17
79	1	18
80	1	19
81	1	20
82	1	21
83	1	22
84	1	23
85	1	24
86	1	25
87	1	26
88	1	27
89	1	28
90	1	29
91	1	30
92	1	31
93	1	32
94	1	33
95	1	34
96	1	35
97	1	36
98	1	37
99	1	38
100	1	39
101	1	40
102	1	41
103	1	42
104	1	43
105	1	44
106	1	45
107	1	46
108	1	47
109	1	48
110	1	49
111	1	50
112	1	51
113	1	52
114	1	53
115	1	54
116	1	55
117	1	56
118	1	57
119	1	58
120	1	59
121	2	0
122	2	1
123	2	2
124	2	3
125	2	4
126	2	5
127	2	6
128	2	7
129	2	8
130	2	9
131	2	10
132	2	11
133	2	12
134	2	13
135	2	14
136	2	15
137	2	16
138	2	17
139	2	18
140	2	19
141	2	20
142	2	21
143	2	22
144	2	23
145	2	24
146	2	25
147	2	26
148	2	27
149	2	28
150	2	29
151	2	30
152	2	31
153	2	32
154	2	33
155	2	34
156	2	35
157	2	36
158	2	37
159	2	38
160	2	39
161	2	40
162	2	41
163	2	42
164	2	43
165	2	44
166	2	45
167	2	46
168	2	47
169	2	48
170	2	49
171	2	50
172	2	51
173	2	52
174	2	53
175	2	54
176	2	55
177	2	56
178	2	57
179	2	58
180	2	59
181	3	0
182	3	1
183	3	2
184	3	3
185	3	4
186	3	5
187	3	6
188	3	7
189	3	8
190	3	9
191	3	10
192	3	11
193	3	12
194	3	13
195	3	14
196	3	15
197	3	16
198	3	17
199	3	18
200	3	19
201	3	20
202	3	21
203	3	22
204	3	23
205	3	24
206	3	25
207	3	26
208	3	27
209	3	28
210	3	29
211	3	30
212	3	31
213	3	32
214	3	33
215	3	34
216	3	35
217	3	36
218	3	37
219	3	38
220	3	39
221	3	40
222	3	41
223	3	42
224	3	43
225	3	44
226	3	45
227	3	46
228	3	47
229	3	48
230	3	49
231	3	50
232	3	51
233	3	52
234	3	53
235	3	54
236	3	55
237	3	56
238	3	57
239	3	58
240	3	59
241	4	0
242	4	1
243	4	2
244	4	3
245	4	4
246	4	5
247	4	6
248	4	7
249	4	8
250	4	9
251	4	10
252	4	11
253	4	12
254	4	13
255	4	14
256	4	15
257	4	16
258	4	17
259	4	18
260	4	19
261	4	20
262	4	21
263	4	22
264	4	23
265	4	24
266	4	25
267	4	26
268	4	27
269	4	28
270	4	29
271	4	30
272	4	31
273	4	32
274	4	33
275	4	34
276	4	35
277	4	36
278	4	37
279	4	38
280	4	39
281	4	40
282	4	41
283	4	42
284	4	43
285	4	44
286	4	45
287	4	46
288	4	47
289	4	48
290	4	49
291	4	50
292	4	51
293	4	52
294	4	53
295	4	54
296	4	55
297	4	56
298	4	57
299	4	58
300	4	59
301	5	0
302	5	1
303	5	2
304	5	3
305	5	4
306	5	5
307	5	6
308	5	7
309	5	8
310	5	9
311	5	10
312	5	11
313	5	12
314	5	13
315	5	14
316	5	15
317	5	16
318	5	17
319	5	18
320	5	19
321	5	20
322	5	21
323	5	22
324	5	23
325	5	24
326	5	25
327	5	26
328	5	27
329	5	28
330	5	29
331	5	30
332	5	31
333	5	32
334	5	33
335	5	34
336	5	35
337	5	36
338	5	37
339	5	38
340	5	39
341	5	40
342	5	41
343	5	42
344	5	43
345	5	44
346	5	45
347	5	46
348	5	47
349	5	48
350	5	49
351	5	50
352	5	51
353	5	52
354	5	53
355	5	54
356	5	55
357	5	56
358	5	57
359	5	58
360	5	59
361	6	0
362	6	1
363	6	2
364	6	3
365	6	4
366	6	5
367	6	6
368	6	7
369	6	8
370	6	9
371	6	10
372	6	11
373	6	12
374	6	13
375	6	14
376	6	15
377	6	16
378	6	17
379	6	18
380	6	19
381	6	20
382	6	21
383	6	22
384	6	23
385	6	24
386	6	25
387	6	26
388	6	27
389	6	28
390	6	29
391	6	30
392	6	31
393	6	32
394	6	33
395	6	34
396	6	35
397	6	36
398	6	37
399	6	38
400	6	39
401	6	40
402	6	41
403	6	42
404	6	43
405	6	44
406	6	45
407	6	46
408	6	47
409	6	48
410	6	49
411	6	50
412	6	51
413	6	52
414	6	53
415	6	54
416	6	55
417	6	56
418	6	57
419	6	58
420	6	59
421	7	0
422	7	1
423	7	2
424	7	3
425	7	4
426	7	5
427	7	6
428	7	7
429	7	8
430	7	9
431	7	10
432	7	11
433	7	12
434	7	13
435	7	14
436	7	15
437	7	16
438	7	17
439	7	18
440	7	19
441	7	20
442	7	21
443	7	22
444	7	23
445	7	24
446	7	25
447	7	26
448	7	27
449	7	28
450	7	29
451	7	30
452	7	31
453	7	32
454	7	33
455	7	34
456	7	35
457	7	36
458	7	37
459	7	38
460	7	39
461	7	40
462	7	41
463	7	42
464	7	43
465	7	44
466	7	45
467	7	46
468	7	47
469	7	48
470	7	49
471	7	50
472	7	51
473	7	52
474	7	53
475	7	54
476	7	55
477	7	56
478	7	57
479	7	58
480	7	59
481	8	0
482	8	1
483	8	2
484	8	3
485	8	4
486	8	5
487	8	6
488	8	7
489	8	8
490	8	9
491	8	10
492	8	11
493	8	12
494	8	13
495	8	14
496	8	15
497	8	16
498	8	17
499	8	18
500	8	19
501	8	20
502	8	21
503	8	22
504	8	23
505	8	24
506	8	25
507	8	26
508	8	27
509	8	28
510	8	29
511	8	30
512	8	31
513	8	32
514	8	33
515	8	34
516	8	35
517	8	36
518	8	37
519	8	38
520	8	39
521	8	40
522	8	41
523	8	42
524	8	43
525	8	44
526	8	45
527	8	46
528	8	47
529	8	48
530	8	49
531	8	50
532	8	51
533	8	52
534	8	53
535	8	54
536	8	55
537	8	56
538	8	57
539	8	58
540	8	59
541	9	0
542	9	1
543	9	2
544	9	3
545	9	4
546	9	5
547	9	6
548	9	7
549	9	8
550	9	9
551	9	10
552	9	11
553	9	12
554	9	13
555	9	14
556	9	15
557	9	16
558	9	17
559	9	18
560	9	19
561	9	20
562	9	21
563	9	22
564	9	23
565	9	24
566	9	25
567	9	26
568	9	27
569	9	28
570	9	29
571	9	30
572	9	31
573	9	32
574	9	33
575	9	34
576	9	35
577	9	36
578	9	37
579	9	38
580	9	39
581	9	40
582	9	41
583	9	42
584	9	43
585	9	44
586	9	45
587	9	46
588	9	47
589	9	48
590	9	49
591	9	50
592	9	51
593	9	52
594	9	53
595	9	54
596	9	55
597	9	56
598	9	57
599	9	58
600	9	59
601	10	0
602	10	1
603	10	2
604	10	3
605	10	4
606	10	5
607	10	6
608	10	7
609	10	8
610	10	9
611	10	10
612	10	11
613	10	12
614	10	13
615	10	14
616	10	15
617	10	16
618	10	17
619	10	18
620	10	19
621	10	20
622	10	21
623	10	22
624	10	23
625	10	24
626	10	25
627	10	26
628	10	27
629	10	28
630	10	29
631	10	30
632	10	31
633	10	32
634	10	33
635	10	34
636	10	35
637	10	36
638	10	37
639	10	38
640	10	39
641	10	40
642	10	41
643	10	42
644	10	43
645	10	44
646	10	45
647	10	46
648	10	47
649	10	48
650	10	49
651	10	50
652	10	51
653	10	52
654	10	53
655	10	54
656	10	55
657	10	56
658	10	57
659	10	58
660	10	59
661	11	0
662	11	1
663	11	2
664	11	3
665	11	4
666	11	5
667	11	6
668	11	7
669	11	8
670	11	9
671	11	10
672	11	11
673	11	12
674	11	13
675	11	14
676	11	15
677	11	16
678	11	17
679	11	18
680	11	19
681	11	20
682	11	21
683	11	22
684	11	23
685	11	24
686	11	25
687	11	26
688	11	27
689	11	28
690	11	29
691	11	30
692	11	31
693	11	32
694	11	33
695	11	34
696	11	35
697	11	36
698	11	37
699	11	38
700	11	39
701	11	40
702	11	41
703	11	42
704	11	43
705	11	44
706	11	45
707	11	46
708	11	47
709	11	48
710	11	49
711	11	50
712	11	51
713	11	52
714	11	53
715	11	54
716	11	55
717	11	56
718	11	57
719	11	58
720	11	59
721	12	0
722	12	1
723	12	2
724	12	3
725	12	4
726	12	5
727	12	6
728	12	7
729	12	8
730	12	9
731	12	10
732	12	11
733	12	12
734	12	13
735	12	14
736	12	15
737	12	16
738	12	17
739	12	18
740	12	19
741	12	20
742	12	21
743	12	22
744	12	23
745	12	24
746	12	25
747	12	26
748	12	27
749	12	28
750	12	29
751	12	30
752	12	31
753	12	32
754	12	33
755	12	34
756	12	35
757	12	36
758	12	37
759	12	38
760	12	39
761	12	40
762	12	41
763	12	42
764	12	43
765	12	44
766	12	45
767	12	46
768	12	47
769	12	48
770	12	49
771	12	50
772	12	51
773	12	52
774	12	53
775	12	54
776	12	55
777	12	56
778	12	57
779	12	58
780	12	59
781	13	0
782	13	1
783	13	2
784	13	3
785	13	4
786	13	5
787	13	6
788	13	7
789	13	8
790	13	9
791	13	10
792	13	11
793	13	12
794	13	13
795	13	14
796	13	15
797	13	16
798	13	17
799	13	18
800	13	19
801	13	20
802	13	21
803	13	22
804	13	23
805	13	24
806	13	25
807	13	26
808	13	27
809	13	28
810	13	29
811	13	30
812	13	31
813	13	32
814	13	33
815	13	34
816	13	35
817	13	36
818	13	37
819	13	38
820	13	39
821	13	40
822	13	41
823	13	42
824	13	43
825	13	44
826	13	45
827	13	46
828	13	47
829	13	48
830	13	49
831	13	50
832	13	51
833	13	52
834	13	53
835	13	54
836	13	55
837	13	56
838	13	57
839	13	58
840	13	59
841	14	0
842	14	1
843	14	2
844	14	3
845	14	4
846	14	5
847	14	6
848	14	7
849	14	8
850	14	9
851	14	10
852	14	11
853	14	12
854	14	13
855	14	14
856	14	15
857	14	16
858	14	17
859	14	18
860	14	19
861	14	20
862	14	21
863	14	22
864	14	23
865	14	24
866	14	25
867	14	26
868	14	27
869	14	28
870	14	29
871	14	30
872	14	31
873	14	32
874	14	33
875	14	34
876	14	35
877	14	36
878	14	37
879	14	38
880	14	39
881	14	40
882	14	41
883	14	42
884	14	43
885	14	44
886	14	45
887	14	46
888	14	47
889	14	48
890	14	49
891	14	50
892	14	51
893	14	52
894	14	53
895	14	54
896	14	55
897	14	56
898	14	57
899	14	58
900	14	59
901	15	0
902	15	1
903	15	2
904	15	3
905	15	4
906	15	5
907	15	6
908	15	7
909	15	8
910	15	9
911	15	10
912	15	11
913	15	12
914	15	13
915	15	14
916	15	15
917	15	16
918	15	17
919	15	18
920	15	19
921	15	20
922	15	21
923	15	22
924	15	23
925	15	24
926	15	25
927	15	26
928	15	27
929	15	28
930	15	29
931	15	30
932	15	31
933	15	32
934	15	33
935	15	34
936	15	35
937	15	36
938	15	37
939	15	38
940	15	39
941	15	40
942	15	41
943	15	42
944	15	43
945	15	44
946	15	45
947	15	46
948	15	47
949	15	48
950	15	49
951	15	50
952	15	51
953	15	52
954	15	53
955	15	54
956	15	55
957	15	56
958	15	57
959	15	58
960	15	59
961	16	0
962	16	1
963	16	2
964	16	3
965	16	4
966	16	5
967	16	6
968	16	7
969	16	8
970	16	9
971	16	10
972	16	11
973	16	12
974	16	13
975	16	14
976	16	15
977	16	16
978	16	17
979	16	18
980	16	19
981	16	20
982	16	21
983	16	22
984	16	23
985	16	24
986	16	25
987	16	26
988	16	27
989	16	28
990	16	29
991	16	30
992	16	31
993	16	32
994	16	33
995	16	34
996	16	35
997	16	36
998	16	37
999	16	38
1000	16	39
1001	16	40
1002	16	41
1003	16	42
1004	16	43
1005	16	44
1006	16	45
1007	16	46
1008	16	47
1009	16	48
1010	16	49
1011	16	50
1012	16	51
1013	16	52
1014	16	53
1015	16	54
1016	16	55
1017	16	56
1018	16	57
1019	16	58
1020	16	59
1021	17	0
1022	17	1
1023	17	2
1024	17	3
1025	17	4
1026	17	5
1027	17	6
1028	17	7
1029	17	8
1030	17	9
1031	17	10
1032	17	11
1033	17	12
1034	17	13
1035	17	14
1036	17	15
1037	17	16
1038	17	17
1039	17	18
1040	17	19
1041	17	20
1042	17	21
1043	17	22
1044	17	23
1045	17	24
1046	17	25
1047	17	26
1048	17	27
1049	17	28
1050	17	29
1051	17	30
1052	17	31
1053	17	32
1054	17	33
1055	17	34
1056	17	35
1057	17	36
1058	17	37
1059	17	38
1060	17	39
1061	17	40
1062	17	41
1063	17	42
1064	17	43
1065	17	44
1066	17	45
1067	17	46
1068	17	47
1069	17	48
1070	17	49
1071	17	50
1072	17	51
1073	17	52
1074	17	53
1075	17	54
1076	17	55
1077	17	56
1078	17	57
1079	17	58
1080	17	59
1081	18	0
1082	18	1
1083	18	2
1084	18	3
1085	18	4
1086	18	5
1087	18	6
1088	18	7
1089	18	8
1090	18	9
1091	18	10
1092	18	11
1093	18	12
1094	18	13
1095	18	14
1096	18	15
1097	18	16
1098	18	17
1099	18	18
1100	18	19
1101	18	20
1102	18	21
1103	18	22
1104	18	23
1105	18	24
1106	18	25
1107	18	26
1108	18	27
1109	18	28
1110	18	29
1111	18	30
1112	18	31
1113	18	32
1114	18	33
1115	18	34
1116	18	35
1117	18	36
1118	18	37
1119	18	38
1120	18	39
1121	18	40
1122	18	41
1123	18	42
1124	18	43
1125	18	44
1126	18	45
1127	18	46
1128	18	47
1129	18	48
1130	18	49
1131	18	50
1132	18	51
1133	18	52
1134	18	53
1135	18	54
1136	18	55
1137	18	56
1138	18	57
1139	18	58
1140	18	59
1141	19	0
1142	19	1
1143	19	2
1144	19	3
1145	19	4
1146	19	5
1147	19	6
1148	19	7
1149	19	8
1150	19	9
1151	19	10
1152	19	11
1153	19	12
1154	19	13
1155	19	14
1156	19	15
1157	19	16
1158	19	17
1159	19	18
1160	19	19
1161	19	20
1162	19	21
1163	19	22
1164	19	23
1165	19	24
1166	19	25
1167	19	26
1168	19	27
1169	19	28
1170	19	29
1171	19	30
1172	19	31
1173	19	32
1174	19	33
1175	19	34
1176	19	35
1177	19	36
1178	19	37
1179	19	38
1180	19	39
1181	19	40
1182	19	41
1183	19	42
1184	19	43
1185	19	44
1186	19	45
1187	19	46
1188	19	47
1189	19	48
1190	19	49
1191	19	50
1192	19	51
1193	19	52
1194	19	53
1195	19	54
1196	19	55
1197	19	56
1198	19	57
1199	19	58
1200	19	59
1201	20	0
1202	20	1
1203	20	2
1204	20	3
1205	20	4
1206	20	5
1207	20	6
1208	20	7
1209	20	8
1210	20	9
1211	20	10
1212	20	11
1213	20	12
1214	20	13
1215	20	14
1216	20	15
1217	20	16
1218	20	17
1219	20	18
1220	20	19
1221	20	20
1222	20	21
1223	20	22
1224	20	23
1225	20	24
1226	20	25
1227	20	26
1228	20	27
1229	20	28
1230	20	29
1231	20	30
1232	20	31
1233	20	32
1234	20	33
1235	20	34
1236	20	35
1237	20	36
1238	20	37
1239	20	38
1240	20	39
1241	20	40
1242	20	41
1243	20	42
1244	20	43
1245	20	44
1246	20	45
1247	20	46
1248	20	47
1249	20	48
1250	20	49
1251	20	50
1252	20	51
1253	20	52
1254	20	53
1255	20	54
1256	20	55
1257	20	56
1258	20	57
1259	20	58
1260	20	59
1261	21	0
1262	21	1
1263	21	2
1264	21	3
1265	21	4
1266	21	5
1267	21	6
1268	21	7
1269	21	8
1270	21	9
1271	21	10
1272	21	11
1273	21	12
1274	21	13
1275	21	14
1276	21	15
1277	21	16
1278	21	17
1279	21	18
1280	21	19
1281	21	20
1282	21	21
1283	21	22
1284	21	23
1285	21	24
1286	21	25
1287	21	26
1288	21	27
1289	21	28
1290	21	29
1291	21	30
1292	21	31
1293	21	32
1294	21	33
1295	21	34
1296	21	35
1297	21	36
1298	21	37
1299	21	38
1300	21	39
1301	21	40
1302	21	41
1303	21	42
1304	21	43
1305	21	44
1306	21	45
1307	21	46
1308	21	47
1309	21	48
1310	21	49
1311	21	50
1312	21	51
1313	21	52
1314	21	53
1315	21	54
1316	21	55
1317	21	56
1318	21	57
1319	21	58
1320	21	59
1321	22	0
1322	22	1
1323	22	2
1324	22	3
1325	22	4
1326	22	5
1327	22	6
1328	22	7
1329	22	8
1330	22	9
1331	22	10
1332	22	11
1333	22	12
1334	22	13
1335	22	14
1336	22	15
1337	22	16
1338	22	17
1339	22	18
1340	22	19
1341	22	20
1342	22	21
1343	22	22
1344	22	23
1345	22	24
1346	22	25
1347	22	26
1348	22	27
1349	22	28
1350	22	29
1351	22	30
1352	22	31
1353	22	32
1354	22	33
1355	22	34
1356	22	35
1357	22	36
1358	22	37
1359	22	38
1360	22	39
1361	22	40
1362	22	41
1363	22	42
1364	22	43
1365	22	44
1366	22	45
1367	22	46
1368	22	47
1369	22	48
1370	22	49
1371	22	50
1372	22	51
1373	22	52
1374	22	53
1375	22	54
1376	22	55
1377	22	56
1378	22	57
1379	22	58
1380	22	59
1381	23	0
1382	23	1
1383	23	2
1384	23	3
1385	23	4
1386	23	5
1387	23	6
1388	23	7
1389	23	8
1390	23	9
1391	23	10
1392	23	11
1393	23	12
1394	23	13
1395	23	14
1396	23	15
1397	23	16
1398	23	17
1399	23	18
1400	23	19
1401	23	20
1402	23	21
1403	23	22
1404	23	23
1405	23	24
1406	23	25
1407	23	26
1408	23	27
1409	23	28
1410	23	29
1411	23	30
1412	23	31
1413	23	32
1414	23	33
1415	23	34
1416	23	35
1417	23	36
1418	23	37
1419	23	38
1420	23	39
1421	23	40
1422	23	41
1423	23	42
1424	23	43
1425	23	44
1426	23	45
1427	23	46
1428	23	47
1429	23	48
1430	23	49
1431	23	50
1432	23	51
1433	23	52
1434	23	53
1435	23	54
1436	23	55
1437	23	56
1438	23	57
1439	23	58
1440	23	59
\.


--
-- Data for Name: permisos; Type: TABLE DATA; Schema: public; Owner: neondb
--

COPY public.permisos (id_permisos, activo, controlador, accion, recurso, modulo) FROM stdin;
1	\N	NULL	NULL	*	*
\.


--
-- Data for Name: personas; Type: TABLE DATA; Schema: public; Owner: neondb
--

COPY public.personas (id_personas, nombre, cedula, correo, telefono, id_ciudades, nombre_comercial, fecha_nacimiento, direccion) FROM stdin;
1	CONTADO	V-00000000	contado@contado.com	(0000) 000-    	331	CONTADO	2024-10-09	UNICA
2	PEDRO MARCANO	V-18532145	\N	(0412) 350-2145	322	PEDRO MARCANO	2024-09-24	UNICA, 13, 16
3	ODELIS GOMEZ	V-11200444	\N	(0412) 352-1458	72	ODELIS GOMEZ	2024-09-24	TURMERO, 308, 4
4	HECTOR OLMO	V-203222222	\N	(0421) 235-2115	1	HECTOR OLMO	2024-05-30	UNICA, 1, 1
5	WILLIAM ZAMBRANO 	V-15074826	\N	(0424) 170-8810	1	WILLIAM ZAMBRANO 	2024-05-30	MONTALBAN , 1, 1
6	GEORGE KAMBAZ	V-11111111		(0   )    -    	1	GEORGE KAMBAZ	\N	UNICA, 1, 1
7	EDUARDO 	V-20326761	\N	(0412) 022-2   	1	EDUARDO 	2025-01-21	D, 1, 1
8	CESAR JAIMES	V-26147374 	\N	(0416) 796-5416	339	\N	\N	ACARIGUA
9	RAMON FERNANDEZ	V-203267541	\N	(0   )    -    	322	\N	2024-11-02	UNICA
10	JUAN CASTRO	V-12146123	\N	(0000) 000-0000	331	\N	2024-07-25	MARACAY
11	OSCAR CERRATO	V-21136312	oscarantoniocerrato@gmail.com	04123459460	138	\N	2024-07-14	LAS VEGAS
12	Aa cosneric 	J-412245090		(1223) 456-    	1	Aa cosneric 	\N	Ah ghgf, 1, 1
13	BRYANT ESTEVEZ	-235978187	estevez.enahp@gmail.com	(0424) 244-7340	510	\N	2011-06-07	LA GUAIRA
14	JOSE VALDERRAMA	V-27100157		(0412) 563-2211	325	JOSE VALDERRAMA	\N	LAASUNCIONW, 325, 16
15	med85	V-16650578	romioaa@gmail.com	(0424) 920-9246	89	med85	\N	Paseo Heres Edf Mardey, 89, 6
16	Martha Campos	V-123456789		(0424) 817-5214	1	Martha Campos	\N	venezuela, 1, 1
17	ANDREW	V-24442277	\N	(0412) 845-6890	127	\N	2024-10-09	VALENCIA
18	NADER ABU	V-20773762 	\N	(0414) 111-1111	89	\N	\N	CBL
19	DEVION	J-410406330	\N	(0285) 111-1111	89	\N	\N	DEVION
20	LEONARDO ROSALES	-10776906 	\N	(0414) 465-4646	212	\N	\N	BARQUISIMETO
21	Yomar Guerra	V-12194309	yomar.guerra@hotmail.com	(0414) 863-7054	89	Yomar Guerra	\N	Calle Principal, 89, 6
22	VICTOR ESCAMILLA	V-189632145	\N	0	473	\N	2024-11-18	ZULIA
23	AREHANNY 	V-22010888 	\N	(0424) 422-5459	106	\N	\N	LOS GUAYOS
24	CASHEA	V-2032541  	\N	(0   )    -    	325	\N	\N	LA ASUNCION 
25	Nicol�s 	-11772993 	\N	(0414) 678-8976	325	\N	\N	Punto fijo 
26	alirio seekatz	V-17418217 	alirioseekatz@gmail.com	(0412) 794-3699	321	\N	\N	porlamar
\.


--
-- Data for Name: role_permiso; Type: TABLE DATA; Schema: public; Owner: neondb
--

COPY public.role_permiso (id_roles, id_permisos) FROM stdin;
1	1
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: neondb
--

COPY public.roles (rol, acceso, id_roles) FROM stdin;
Super Usuario	t	1
Usuario Estandar	t	2
gerencia	t	3
Tecnico	t	4
Mesonero	f	5
Supervisor	t	6
Cocinero	t	7
cajera	t	8
consulta	t	9
verificador	t	15
pedidos	t	16
vendedorposreac	t	17
cliente	t	18
\.


--
-- Data for Name: tipo_factura; Type: TABLE DATA; Schema: public; Owner: neondb
--

COPY public.tipo_factura (id_tipo_facturas, inicial, tipo) FROM stdin;
1	F	Factura IF
2	D	Devolucion
3	NC	Nota de Credito
4	ND	Nota de Debito
5	FL	Forma Libre
6	NE	Nota de Entrega
7	T	Ticket
8	M	Factura Manual
9	FT	Factura Temporal
1	F	Factura IF
2	D	Devolucion
3	NC	Nota de Credito
4	ND	Nota de Debito
5	FL	Forma Libre
6	NE	Nota de Entrega
7	T	Ticket
8	M	Factura Manual
9	FT	Factura Temporal
1	F	Factura IF
2	D	Devolucion
3	NC	Nota de Credito
4	ND	Nota de Debito
5	FL	Forma Libre
6	NE	Nota de Entrega
7	T	Ticket
8	M	Factura Manual
9	FT	Factura Temporal
1	F	Factura IF
2	D	Devolucion
3	NC	Nota de Credito
4	ND	Nota de Debito
5	FL	Forma Libre
6	NE	Nota de Entrega
7	T	Ticket
8	M	Factura Manual
9	FT	Factura Temporal
1	F	Factura IF
2	D	Devolucion
3	NC	Nota de Credito
4	ND	Nota de Debito
5	FL	Forma Libre
6	NE	Nota de Entrega
7	T	Ticket
8	M	Factura Manual
9	FT	Factura Temporal
\.


--
-- Data for Name: tipo_facturas; Type: TABLE DATA; Schema: public; Owner: neondb
--

COPY public.tipo_facturas (id_tipo_facturas, tipo, inicial) FROM stdin;
1	Factura IF	F
2	Devolucion	D
3	Nota de Credito	NC
4	Nota de Debito	ND
5	Forma Libre	FL
6	Nota de Entrega	NE
7	Ticket	T
8	Factura Manual	M
9	Factura Temporal	FT
\.


--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: neondb
--

COPY public.usuarios (id_usuarios, nombre_usuario, "contraseña", correo, nombre, apellido, acceso, id_roles) FROM stdin;
3	admin	7c4a8d09ca3762af61e59520943dc26494f8941b	admin@admin.com	Super	Admin	t	1
4	soporte	2081ab297d5be74ab716bae982eb39294f5a6098	admin@admin.com	soporte	Admin	t	1
6	vendedor1	$2y$10$ptOFv5vQkr.JzM5fKymQVOCNuCsWjTHUz6D.knhU8Ddd.B8/oIzIS	WZAMBRANO@GMAIL.COM	WILLIAM	ZAMBRANO	t	17
7	YRON	$2y$10$ld4iBUmjYa2LKP0Bv2wUJOaDuxr1BDG8mP4YX/g66vLBwMhLQ5HbK	yohelyron@gmail.com	Yohely	Ron	t	6
8	user	$2y$10$JYARVdNkycWt9sXFlGENF.8vdKWdbqKdtguX4ChfWILFIrW7Vzvra	usaer@gmail.com	user	user	t	18
9	pedidos	$2y$10$CL86KXGpI5nNrM62VOg6susweimy/ew7GR/EVhMuVxH9RI2eieuDy	soporte@gmail.com	fv	sdsdvd	t	16
10	cobrar1	$2y$10$SvC1lm6fWfQ5cGlLJfmb4O/Ejdu/4wiiRW1tJlW21OkT6OzgTyLuO	admin@gai.com	user	user	t	18
\.


--
-- Data for Name: det_venta; Type: TABLE DATA; Schema: ventas; Owner: neondb
--

COPY ventas.det_venta (id_det_venta, id_productos, id_depositos, precio, cantidad, id_ventas, descuento, id_presentaciones, id_empleados, anulado, devuelto) FROM stdin;
1	3	1	0.78	10.0	1	0.0	\N	1	0	0.0
2	1	1	0.2	1.0	1	0.0	\N	1	0	0.0
3	3	1	0.78	5.0	2	0.0	\N	1	0	0.0
4	3	1	0.78	1.0	3	0.0	\N	1	0	0.0
5	3	1	0.78	12.0	4	0.0	\N	1	0	0.0
6	1	3	0.2	1.0	6	0.0	\N	2	0	0.0
7	1	3	0.2	1.0	7	0.0	\N	2	0	0.0
8	1	3	0.2	1.0	8	0.0	\N	2	0	0.0
10	16	1	4.31	1.0	10	0.0	\N	1	0	0.0
11	16	1	4.31	2.0	11	0.0	\N	1	0	0.0
12	18	3	28.8	2.0	12	0.0	\N	1	0	0.0
13	3	1	0.78	1.0	13	0.0	\N	1	0	0.0
14	8	1	1.5	1.0	13	0.0	\N	1	0	0.0
15	3	1	0.78	3.0	14	0.0	\N	1	0	0.0
16	4	1	20.0	5.0	14	0.0	\N	1	0	0.0
17	3	1	0.78	2.0	15	0.0	\N	2	0	0.0
18	4	1	20.0	3.0	15	0.0	\N	2	0	0.0
19	1	3	0.2	1.0	16	0.0	\N	1	0	0.0
20	9	1	3.0	1.0	17	0.0	\N	1	0	0.0
21	3	1	0.78	1.0	18	0.0	\N	2	0	0.0
22	3	1	0.78	2.0	19	0.0	\N	1	0	0.0
23	4	1	20.0	1.0	19	0.0	\N	1	0	0.0
24	1	1	10.0	1.0	20	0.0	\N	1	0	0.0
25	1	1	10.0	1.0	21	0.0	\N	1	0	0.0
26	3	1	10.0	1.0	22	0.0	\N	1	0	0.0
27	8	1	10.0	1.0	23	0.0	\N	1	0	0.0
28	21	1	600.0	1.0	25	0.0	\N	1	0	0.0
29	25	1	5.17	2.0	26	0.0	\N	1	0	0.0
32	25	1	5.17	1.0	29	0.0	\N	1	0	0.0
33	25	1	5.17	1.0	30	0.0	\N	1	0	0.0
34	25	1	5.17	1.0	31	0.0	\N	1	0	0.0
35	25	1	5.17	1.0	32	0.0	\N	1	0	0.0
36	16	1	4.31	1.0	33	0.0	\N	1	0	0.0
37	24	1	1.47	1.0	34	0.0	\N	1	0	0.0
38	25	1	5.17	1.0	34	0.0	\N	1	0	0.0
39	27	1	1.7	3.0	35	0.0	\N	1	0	0.0
40	24	1	1.47	1.0	36	0.0	\N	1	0	0.0
41	23	1	1.47	13.0	37	0.0	\N	1	0	0.0
42	27	1	1.7	9.0	37	0.0	\N	1	0	0.0
46	25	1	5.17	1.0	39	0.0	\N	1	0	0.0
47	17	1	6.5	1.0	40	0.0	\N	1	0	0.0
48	17	1	6.5	1.0	40	0.0	\N	1	0	0.0
49	17	1	6.5	1.0	41	0.0	\N	1	0	0.0
50	17	1	6.5	1.0	42	0.0	\N	2	0	0.0
51	7	1	10.0	1.0	43	0.0	\N	2	0	0.0
55	3	1	0.78	1.0	46	0.0	\N	1	0	0.0
56	5	1	5.0	1.0	46	0.0	\N	1	0	0.0
57	17	1	6.5	1.0	47	0.0	\N	2	0	0.0
58	3	1	0.78	1.0	48	0.0	\N	1	0	0.0
59	5	1	5.0	1.0	48	0.0	\N	1	0	0.0
60	3	1	0.78	1.0	49	0.0	\N	1	0	0.0
61	33	1	156.0	1.0	50	0.0	\N	1	0	0.0
62	32	1	10.4	10.0	50	0.0	\N	1	0	0.0
63	3	1	0.78	1.0	51	0.0	\N	1	0	0.0
64	7	1	10.0	1.0	52	0.0	\N	2	0	0.0
65	7	1	10.0	1.0	53	0.0	\N	1	0	0.0
66	36	1	30.0	1.0	54	0.0	\N	2	0	0.0
67	38	3	22.0	12.0	55	0.0	\N	1	0	0.0
68	8	1	1.5	1.0	56	0.0	\N	1	0	0.0
71	8	1	1.5	1.0	58	0.0	\N	1	0	0.0
72	4	1	20.0	1.0	58	0.0	\N	1	0	0.0
73	3	4	0.78	1.0	59	0.0	\N	1	0	0.0
74	9	1	3.0	1.0	60	0.0	\N	1	0	0.0
75	24	1	1.47	1.0	61	0.0	\N	2	0	0.0
76	35	1	12.0	1.0	61	0.0	\N	2	0	0.0
77	1	1	0.2	1.0	62	0.0	\N	2	0	0.0
78	3	1	0.78	1.0	62	0.0	\N	3	0	0.0
79	18	1	13.61	1.0	63	0.0	\N	1	0	0.0
80	19	1	25.86207	1.0	63	0.0	\N	1	0	0.0
81	95	1	8.62	1.0	64	0.0	\N	1	0	0.0
82	3	1	0.78	1.0	65	0.0	\N	1	0	0.0
83	4	1	20.0	1.0	66	0.0	\N	1	0	0.0
84	8	1	1.5	1.0	67	0.0	\N	2	0	0.0
85	1	1	0.13543	1.0	69	0.0	\N	1	0	0.0
86	2	1	0.2	1.0	71	0.0	\N	1	0	1.0
87	4	1	30.0	1.0	71	0.0	\N	1	0	1.0
88	2	1	0.2	1.0	72	0.0	\N	1	0	1.0
89	4	1	30.0	1.0	72	0.0	\N	1	0	1.0
90	3	1	5.0	1.0	73	0.0	\N	1	0	0.0
91	8	1	1.5	1.0	74	0.0	\N	1	0	0.0
92	7	1	10.0	1.0	74	0.0	\N	1	0	0.0
93	4	1	30.0	1.0	75	0.0	\N	3	0	0.0
94	7	1	10.0	1.0	75	0.0	\N	3	0	0.0
95	12	1	1.0	1.0	75	0.0	\N	3	0	0.0
96	19	1	25.86	1.0	75	0.0	\N	3	0	0.0
97	23	1	1.47	1.0	76	0.0	\N	1	0	0.0
98	4	1	30.0	1.0	77	0.0	\N	1	0	0.0
99	3	1	5.0	1.0	78	0.0	\N	1	0	0.0
100	3	1	5.0	1.0	79	0.0	\N	1	0	0.0
101	4	1	30.0	1.0	80	0.0	\N	1	0	0.0
102	4	1	30.0	1.0	81	0.0	\N	1	0	0.0
103	4	1	30.0	1.0	82	0.0	\N	1	0	0.0
104	3	1	5.0	1.0	83	0.0	\N	1	0	0.0
105	12	1	1.0	1.0	84	0.0	\N	1	0	0.0
106	4	1	30.0	1.0	85	0.0	\N	1	0	0.0
107	5	1	5.0	1.0	86	0.0	\N	1	0	0.0
108	2	1	20.0	1.0	87	0.0	\N	1	0	0.0
109	3	1	5.0	1.0	88	0.0	\N	1	0	0.0
110	4	1	30.0	1.0	89	0.0	\N	1	0	0.0
111	3	1	5.0	1.0	90	0.0	\N	1	0	0.0
112	3	1	5.0	1.0	91	0.0	\N	1	0	0.0
113	101	1	1250.0	1.0	92	0.0	\N	1	0	0.0
114	102	3	1.1	1.0	93	0.0	\N	1	0	0.0
115	102	3	1.1	10.0	93	0.0	\N	1	0	0.0
116	102	1	1.1	30.0	94	0.0	5	1	0	0.0
117	102	1	1.1	30.0	95	0.0	5	2	0	0.0
118	30	1	30.0	7.0	96	0.0	\N	2	0	0.0
119	9	1	3.0	1.0	97	0.0	\N	1	0	0.0
120	12	1	1.2	1.0	97	0.0	\N	1	0	0.0
121	4	1	0.1	1.0	98	0.0	\N	1	0	0.0
122	2	1	0.1	1.0	99	0.0	\N	1	0	0.0
123	1	1	0.1	1.0	100	0.0	\N	1	0	1.0
124	1	1	0.1	1.0	101	0.0	\N	1	0	1.0
126	1	1	0.1	1.0	103	0.0	\N	1	0	1.0
127	1	1	0.1	1.0	104	0.0	\N	1	0	1.0
128	3	1	5.0	1.0	105	0.0	\N	1	0	0.0
129	3	1	5.0	10.0	106	0.0	\N	1	0	0.0
130	3	1	5.0	5.0	107	0.0	\N	1	0	0.0
131	111	1	3.44828	1.0	108	0.0	\N	1	0	0.0
132	117	1	3.0	2.0	109	0.0	\N	1	0	0.0
134	117	1	3.0	1.0	111	0.0	\N	1	0	0.0
136	3	1	5.0	1.0	113	0.0	\N	1	0	0.0
137	3	1	5.0	1.0	114	0.0	\N	1	0	0.0
138	3	1	5.0	1.0	115	0.0	\N	1	0	0.0
139	3	1	5.0	1.0	116	0.0	\N	1	0	0.0
140	3	1	5.0	1.0	117	0.0	\N	1	0	0.0
141	3	1	5.0	1.0	118	0.0	\N	1	0	0.0
142	4	1	30.0	1.0	119	0.0	\N	1	0	0.0
143	9	1	3.0	1.0	120	0.0	\N	2	0	0.0
144	9	1	3.0	1.0	121	0.0	\N	2	0	0.0
145	4	1	30.0	1.0	122	0.0	\N	1	0	0.0
146	3	1	5.0	1.0	123	0.0	\N	1	0	0.0
147	7	1	1.2	1.0	123	0.0	\N	1	0	0.0
148	3	1	5.0	1.0	124	0.0	\N	1	0	0.0
149	4	1	30.0	1.0	124	0.0	\N	1	0	0.0
150	3	1	5.0	1.0	125	0.0	\N	1	0	0.0
151	10	1	2.0	1.0	125	0.0	\N	1	0	0.0
152	33	1	156.0	1.0	125	0.0	\N	1	0	0.0
153	114	1	3.0	1.0	125	0.0	\N	1	0	0.0
154	3	1	5.0	1.0	126	0.0	\N	1	0	0.0
155	35	1	12.0	1.0	127	0.0	\N	1	0	0.0
156	18	1	13.61	1.0	127	0.0	\N	1	0	0.0
157	35	1	12.0	1.0	127	0.0	\N	1	0	0.0
158	9	1	3.0	12.0	128	0.0	\N	1	0	0.0
159	19	1	25.86207	1.0	130	0.0	\N	1	0	0.0
160	3	1	5.0	1.0	131	0.0	\N	1	0	0.0
161	2	1	25.9605	1.0	132	0.0	\N	1	0	0.0
163	127	1	0.43103	3.0	134	0.0	\N	1	0	0.0
164	128	1	1.72414	1.0	134	0.0	\N	1	0	0.0
165	126	1	4.31034	1.0	134	0.0	\N	1	0	0.0
166	126	1	4.31034	1.0	135	0.0	\N	1	0	0.0
167	126	1	4.31034	1.0	136	0.0	\N	4	0	0.0
168	127	1	0.43	2.0	137	0.0	\N	2	0	0.0
169	126	1	4.31	1.0	137	0.0	\N	2	0	0.0
170	18	1	13.61	1.0	138	0.0	\N	4	0	0.0
171	35	1	12.0	1.0	138	0.0	\N	4	0	0.0
172	3	1	5.0	1.0	139	0.0	\N	4	0	0.0
173	6	1	3.0	1.0	139	0.0	\N	4	0	0.0
174	16	1	4.31	1.0	139	0.0	\N	4	0	0.0
175	127	1	0.43103	1.0	140	0.0	\N	4	0	0.0
176	132	1	30.17	2.0	141	0.0	\N	1	0	0.0
177	134	1	1.0	1.0	141	0.0	\N	1	0	0.0
178	133	1	100.0	1.0	141	0.0	\N	1	0	0.0
179	133	1	100.0	1.0	142	0.0	\N	1	0	0.0
\.


--
-- Data for Name: det_venta_statu; Type: TABLE DATA; Schema: ventas; Owner: neondb
--

COPY ventas.det_venta_statu (id_det_venta, id_status, id_fechas, id_horas) FROM stdin;
\.


--
-- Data for Name: status; Type: TABLE DATA; Schema: ventas; Owner: neondb
--

COPY ventas.status (id_status, statu) FROM stdin;
\.


--
-- Data for Name: tipo_clientes; Type: TABLE DATA; Schema: ventas; Owner: neondb
--

COPY ventas.tipo_clientes (id_tipo_clientes, tipo) FROM stdin;
1	RESTAURANTES
2	BODEGON
3	TIENDAS DE ROPA
4	MUEBLERIAS
5	TIENDAS DE PERSIANAS
6	OFICINAS ADMINISTRATIVAS
7	CONSTRUCTORAS
8	AGENCIAS DE VIAJES
9	PERFUMERIAS
10	PANADERIAS
11	VENTAS DE RESPUESTOS PARA VEHICULOS Y ACCESORIOS
12	LAVANDERIAS
13	TIENDAS NATURISTAS
14	HOTELES
15	AUTOLAVADOS
16	FERRETERIAS
17	GIMNASIO
18	PELUQUERIAS
19	LABORATORIOS
20	CLINICAS
21	LIBRERIAS
22	AGENCIAS DE LOTERIAS Y APUESTAS
23	COLEGIOS
24	MATERIALES DE CONSTRUCCION
25	FARMACIAS
26	EMISORAS DE RADIO
27	TIENDAS DE COMPUTACION Y ACCESORIOS
28	CARNICERIAS
29	ESTETICA
30	ADUANERA
31	ALCALDIAS
32	FRUTERIA
33	MARMOLESRIA PARA COCINAS Y ACSESORIOS
34	HELADERIA
35	TIENDAS DE ARTICULOS PARA FIESTAS
36	REPUESTOS PARA VEHICULOS
37	PERSONAL
38	INMOBILIARIA
39	MATERNAL
40	SUPERMERCADOS
41	CONDOMINIO
42	JOYERIA
43	DISTRIBUIDORA
44	carroceria
45	ACTIVIDADES DE HOSPITALES
46	pizeria
47	publicidad
48	venta de lubricantes
49	GUARDIA NACIONAL
50	EMPRESAS DE SERVICIOS
51	charcuteria
52	TASCA
53	MINIMARKET
54	CAFE
55	TIENDA DE FRUTOS SECOS Y ALGO MAS
56	MANICERIA
57	GALERIA DE ARTE
58	carapita
59	MERCADOLIBRE
\.


--
-- Data for Name: vendedores; Type: TABLE DATA; Schema: ventas; Owner: neondb
--

COPY ventas.vendedores (id_vendedores, nombre, porcentaje) FROM stdin;
1	Marcos 	5.0
2	WILLIAM ZAMBRANO	3.0
3	luia	0.0
4	JULIO	2.0
\.


--
-- Data for Name: venta_statu; Type: TABLE DATA; Schema: ventas; Owner: neondb
--

COPY ventas.venta_statu (id_ventas, id_status, id_fechas, id_horas) FROM stdin;
\.


--
-- Data for Name: ventas; Type: TABLE DATA; Schema: ventas; Owner: neondb
--

COPY ventas.ventas (id_ventas, id_personas, id_cajas, id_vendedores, descuento, id_tipo_facturas, num_factura, num_control, id_ciudades, tasa, id_tipo_clientes, id_estados, anulado, fecha) FROM stdin;
1	2	3	1	0.0	6	1212123	00000001	322	0.0	1	16	0	2024-05-28 10:00:42
2	3	3	1	0.0	5	12323	00000001	72	37.0	1	4	0	2024-05-28 10:07:17
3	3	1	1	0.0	6	00000002	00000002	72	37.0	1	4	0	2024-05-28 10:22:39
4	3	3	1	0.0	6	23423434	00000003	72	37.0	1	4	0	2024-05-28 10:29:54
6	2	1	2	0.0	7	00000001	00000001	322	36.5114	1	16	0	2024-05-30 16:15:49
7	5	1	2	0.0	7	00000002	00000002	1	36.5114	1	1	0	2024-05-30 16:18:19
8	2	1	2	0.0	7	00000003	00000003	322	36.5114	1	16	0	2024-05-30 16:24:56
10	1	1	1	0.0	7	00000004	00000004	331	36.5344	1	16	0	2024-06-03 11:26:52
11	6	1	1	0.0	7	00000005	00000005	1	36.5344	1	1	0	2024-06-03 11:31:21
12	4	1	2	0.0	7	00000006	00000006	1	36.5408	1	1	0	2024-06-05 14:48:04
13	2	3	1	0.0	5	2121	00000002	322	36.4787	1	16	0	2024-06-10 16:31:36
14	4	3	1	0.0	5	122	00000003	1	36.47	1	1	0	2024-06-10 21:11:35
15	3	1	2	0.0	5	7788	00000004	72	36.47	1	4	0	2024-06-10 21:31:19
16	8	1	1	0.0	7	00000007	00000007	339	36.45	1	17	0	2024-06-20 10:21:53
17	7	1	1	0.0	7	00000008	00000008	1	36.45	1	1	0	2024-06-20 10:44:36
18	3	3	2	0.0	6	00000004	00000004	72	36.3725	1	4	0	2024-06-25 09:40:05
19	6	1	1	0.0	7	00000009	00000009	1	36.3725	1	1	0	2024-06-25 09:48:26
20	7	1	1	0.0	5	00000005	00000005	1	36.3823	1	1	0	2024-06-27 15:07:10
21	7	1	1	0.0	5	00000006	00000006	1	36.3823	1	1	0	2024-06-27 15:24:22
22	7	1	1	0.0	5	00000007	00000007	1	36.3823	1	1	0	2024-06-27 15:26:45
23	7	1	1	0.0	5	00000008	00000008	1	36.3823	1	1	0	2024-06-27 15:30:09
24	1	3	1	0.0	7	0	00000001	331	36408500000000.0	1	16	0	2024-07-01 15:20:34
25	1	3	1	0.0	7	00000001	00000001	331	36408500000000.0	1	16	0	2024-07-01 15:23:03
26	1	3	1	0.0	7	00000002	00000002	331	40.0	1	16	0	2024-07-01 15:46:46
29	1	3	1	0.0	7	00000003	00000003	331	40.0	1	16	0	2024-07-01 16:02:29
30	1	3	1	0.0	7	00000004	00000004	331	40.0	1	16	0	2024-07-01 16:05:48
31	1	3	1	0.0	7	00000005	00000005	331	40.0	1	16	0	2024-07-01 16:11:16
32	1	3	1	0.0	7	00000006	00000006	331	40.0	1	16	0	2024-07-01 16:13:11
33	1	3	1	0.0	7	00000007	00000007	331	40.0	1	16	0	2024-07-01 16:18:30
34	1	3	1	0.0	7	00000008	00000008	331	40.0	1	16	0	2024-07-01 17:45:22
35	10	3	1	0.0	7	00000009	00000009	331	40.0	1	16	0	2024-07-01 17:58:10
36	10	3	1	0.0	7	00000010	00000010	331	40.0	1	16	0	2024-07-01 17:59:48
37	10	3	1	0.0	7	00000011	00000011	331	40.0	1	16	0	2024-07-01 18:15:51
39	1	3	1	0.0	7	00000012	00000012	331	36.4551	1	16	0	2024-07-01 21:03:20
40	7	1	1	0.0	6	00000005	00000005	1	36.46	1	1	0	2024-07-02 17:41:39
41	10	1	1	0.0	6	00000006	00000006	331	36.46	1	16	0	2024-07-02 17:50:27
42	4	3	2	0.0	5	1212	00000001	1	36.46	1	1	0	2024-07-04 15:52:23
43	4	3	2	0.0	5	1213	00000009	1	36.46	1	1	0	2024-07-04 15:53:11
46	4	3	2	0.0	7	00000013	00000013	1	36.46	1	1	0	2024-07-04 16:03:37
47	7	3	2	0.0	7	00000014	00000014	1	36.46	1	1	0	2024-07-04 16:04:22
48	4	1	2	0.0	7	00000010	00000010	1	36.4787	1	1	0	2024-07-04 16:04:25
49	1	3	1	0.0	7	00000015	00000015	331	36.53	1	16	0	2024-07-17 11:05:57
50	4	1	2	0.0	5	5115	00000010	1	36.53	1	1	0	2024-07-17 15:34:32
51	2	1	1	0.0	6	00000007	00000007	322	36.53	1	16	0	2024-07-19 11:56:46
52	4	1	2	0.0	5	00000012	00000011	1	36.5724	1	1	0	2024-07-19 11:59:10
53	1	1	1	0.0	6	00000008	00000008	331	36.5724	1	16	0	2024-07-19 12:23:51
54	3	1	2	0.0	5	000158	00000012	72	36.6066	1	4	0	2024-07-22 14:37:44
55	11	3	1	0.0	6	00000009	00000009	138	36.6066	51	8	0	2024-07-25 15:40:01
56	2	1	1	0.0	7	00000011	00000011	322	36.6305	1	16	0	2024-08-21 09:22:24
58	2	1	1	0.0	7	00000012	00000012	322	36.6305	1	16	0	2024-08-21 09:24:21
59	1	3	1	0.0	7	00000016	00000016	331	36.9187	1	16	0	2024-08-21 09:30:18
60	2	1	1	0.0	5	00000013	00000013	322	36.6305	1	16	0	2024-09-02 10:35:39
61	5	1	2	0.0	6	00000010	00000010	1	36.6305	1	1	0	2024-09-03 19:13:46
62	8	1	1	0.0	7	00000013	00000013	339	36.6391	1	17	0	2024-09-17 10:05:44
63	2	1	1	0.0	7	00000014	00000014	322	36.7789	1	16	0	2024-09-19 17:09:06
64	13	1	1	0.0	5	00000014	00000014	510	36.813	36	21	0	2024-09-24 09:47:40
65	3	1	2	0.0	6	00000011	00000011	72	36.813	1	4	0	2024-09-24 17:34:07
66	4	1	2	0.0	7	00000015	00000015	1	36.813	1	1	0	2024-10-02 12:05:04
67	2	1	2	0.0	6	00000012	00000012	322	53.02	1	16	0	2024-10-02 12:05:45
68	1	3	1	\N	4	00000001	00000001	331	36.9187	1	16	0	2024-10-02 15:40:28
69	14	1	1	0.0	7	00000016	00000016	325	36.9187	1	16	0	2024-10-02 15:52:24
70	2	1	2	\N	4	00000001	00000001	322	37.0358	1	16	0	2024-10-04 16:57:41
71	1	1	1	0.0	7	00000017	00000017	331	37.0	1	16	0	2024-10-06 12:27:26
72	1	1	1	0.0	3	00000017	00000001	331	37.0	1	16	0	2024-10-06 12:29:18
73	1	1	1	0.0	7	00000018	00000018	331	37.0	1	16	0	2024-10-06 12:30:25
74	1	1	1	0.0	7	00000019	00000019	331	37.0	1	16	0	2024-10-06 12:31:19
75	15	1	3	0.0	7	00000020	00000020	89	37.0	1	6	0	2024-10-06 12:46:36
76	17	1	1	0.0	6	00000013	00000013	127	1000.0	1	7	0	2024-10-09 11:08:08
77	1	1	1	0.0	7	00000021	00000021	331	38.8857	1	16	0	2024-10-14 15:20:37
78	1	1	1	0.0	7	00000022	00000022	331	38.9179	1	16	0	2024-10-16 16:47:37
79	1	1	1	0.0	7	00000023	00000023	331	38.9179	1	16	0	2024-10-16 16:48:08
80	1	1	1	0.0	7	00000024	00000024	331	38.9179	1	16	0	2024-10-16 16:58:21
81	1	1	1	0.0	7	00000025	00000025	331	38.9179	1	16	0	2024-10-16 17:00:49
82	1	1	1	0.0	7	00000026	00000026	331	38.9179	1	16	0	2024-10-16 17:00:50
83	1	1	1	0.0	7	00000027	00000027	331	38.9179	1	16	0	2024-10-16 17:01:44
84	1	1	1	0.0	7	00000028	00000028	331	38.9179	1	16	0	2024-10-16 17:03:27
85	1	1	1	0.0	7	00000029	00000029	331	38.9179	1	16	0	2024-10-16 17:03:27
86	1	1	1	0.0	7	00000030	00000030	331	38.9179	1	16	0	2024-10-16 17:03:27
87	1	1	1	0.0	7	00000031	00000031	331	38.9179	1	16	0	2024-10-16 17:03:28
88	1	1	1	0.0	7	00000032	00000032	331	38.9179	1	16	0	2024-10-16 17:03:28
89	1	1	1	0.0	7	00000033	00000033	331	38.9179	1	16	0	2024-10-16 17:03:28
90	1	1	1	0.0	7	00000034	00000034	331	38.9179	1	16	0	2024-10-16 17:03:28
91	1	1	1	0.0	7	00000035	00000035	331	38.9179	1	16	0	2024-10-16 17:03:41
92	17	1	1	0.0	6	00000014	00000014	127	39.323	1	7	0	2024-10-23 16:09:19
93	8	1	1	0.0	5	00000015	00000015	339	39.323	1	17	0	2024-10-24 10:21:28
94	4	1	2	0.0	7	00000036	00000036	1	39.323	1	1	0	2024-10-24 10:30:04
95	5	1	2	0.0	7	00000037	00000037	1	39.323	1	1	0	2024-10-24 10:37:41
96	4	1	2	0.0	7	00000038	00000038	1	39.323	1	1	0	2024-10-24 10:42:05
97	20	1	1	0.0	5	00000016	00000016	212	41.0429	1	12	0	2024-10-27 20:53:19
98	1	3	1	0.0	1	6827	00000001	331	42.8569	1	16	0	2024-11-07 14:55:10
99	1	3	1	0.0	1	6828	00000002	331	42.8569	1	16	0	2024-11-07 15:02:58
100	1	3	1	0.0	1	6829	00000003	331	42.8569	1	16	0	2024-11-07 15:47:53
101	1	3	1	0.0	3	35	35	331	42.8569	1	16	0	2024-11-07 15:48:23
103	1	3	1	0.0	1	6830	00000004	331	42.8569	1	16	0	2024-11-07 15:50:42
104	1	3	1	0.0	3	37	37	331	42.8569	1	16	0	2024-11-07 15:51:12
105	1	1	1	0.0	7	00000039	00000039	331	45.053	1	16	0	2024-11-15 11:13:04
106	2	1	1	0.0	7	00000040	00000040	322	45.053	1	16	0	2024-11-15 11:22:16
107	4	1	2	0.0	7	00000041	00000041	1	45.053	1	1	0	2024-11-15 11:23:30
108	7	1	1	0.0	7	00000042	00000042	1	45.7894	1	1	0	2024-11-18 14:37:50
109	1	1	1	0.0	6	00000015	00000015	331	45.841	1	16	0	2024-11-22 12:12:27
111	1	1	1	0.0	6	00000016	00000016	331	45.841	1	16	0	2024-11-22 12:48:57
113	2	1	1	0.0	7	00000043	00000043	322	46.7537	1	16	0	2024-11-27 10:39:51
114	1	3	1	0.0	7	00000017	00000017	331	46.7537	1	16	0	2024-11-27 11:36:58
115	1	1	1	0.0	7	00000044	00000044	331	46.7537	1	16	0	2024-11-27 14:09:04
116	1	1	1	0.0	7	00000045	00000045	331	46.7537	1	16	0	2024-11-27 14:10:00
117	24	1	1	0.0	7	00000046	00000046	325	46.7537	1	16	0	2024-11-27 14:14:47
118	24	1	1	0.0	7	00000047	00000047	325	46.7537	1	16	0	2024-11-27 14:16:21
119	1	1	1	0.0	7	00000048	00000048	331	45.841	1	16	0	2024-11-29 12:36:06
120	4	1	2	0.0	5	000	00000017	1	47.61	1	1	0	2024-11-30 13:09:31
121	5	1	2	0.0	5	0000000018	00000018	1	47.6074	1	1	0	2024-11-30 23:19:18
122	1	1	1	0.0	7	00000049	00000049	331	45.841	1	16	0	2024-12-06 11:50:28
123	1	1	1	0.0	7	00000050	00000050	331	49.1111	1	16	0	2024-12-11 10:29:19
124	1	1	1	0.0	7	00000051	00000051	331	49.1111	1	16	0	2024-12-11 10:39:03
125	1	4	1	0.0	6	00000017	00000017	331	49.1111	1	16	0	2024-12-11 17:57:33
126	1	5	1	0.0	5	1	00000019	331	53.012	1	16	0	2025-01-04 00:08:10
127	25	1	1	0.0	5	1	00000020	325	53.012	1	16	0	2025-01-04 19:25:33
128	7	1	1	0.0	6	00000018	00000018	1	53.02	1	1	0	2025-01-06 16:42:45
129	2	1	2	\N	4	00000002	00000002	322	53.02	1	16	0	2025-01-06 16:53:32
130	6	1	1	0.0	7	00000052	00000052	1	53.2827	1	1	0	2025-01-09 11:35:05
131	8	1	1	0.0	7	00000053	00000053	339	53.2827	1	17	0	2025-01-09 11:38:07
132	1	3	1	0.0	7	00000018	00000018	331	36.5621	1	16	0	2025-01-13 11:05:13
134	1	1	1	0.0	7	00000054	00000054	331	56.0	1	16	0	2025-01-20 14:46:09
135	1	1	1	0.0	7	00000055	00000055	331	56.0	1	16	0	2025-01-20 14:47:17
136	1	1	4	0.0	7	00000056	00000056	331	56.0	1	16	0	2025-01-20 14:56:26
137	4	1	2	0.0	5	1313	00000021	1	56.0	1	1	0	2025-01-20 15:05:06
138	2	4	4	0.0	5	01	00000002	322	61.0	1	16	0	2025-01-20 15:21:42
139	1	1	4	0.0	7	00000057	00000057	331	56.0	1	16	0	2025-01-20 15:24:30
140	1	1	4	0.0	7	00000058	00000058	331	56.0	1	16	0	2025-01-20 16:16:05
141	8	4	1	0.0	5	4242	00000022	339	55.7611	1	17	0	2025-01-22 16:08:22
142	2	1	1	0.0	5	424	00000023	322	55.7611	1	16	0	2025-01-22 16:16:17
\.


--
-- Name: egreso_banco_id_egreso_banco_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: neondb
--

SELECT pg_catalog.setval('finanzas.egreso_banco_id_egreso_banco_seq', 138, true);


--
-- Name: egreso_caja_id_egreso_caja_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: neondb
--

SELECT pg_catalog.setval('finanzas.egreso_caja_id_egreso_caja_seq', 456, true);


--
-- Name: egresos_id_egresos_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: neondb
--

SELECT pg_catalog.setval('finanzas.egresos_id_egresos_seq', 146, true);


--
-- Name: ingreso_banco_id_ingreso_banco_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: neondb
--

SELECT pg_catalog.setval('finanzas.ingreso_banco_id_ingreso_banco_seq', 9, true);


--
-- Name: ingreso_caja_id_ingreso_caja_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: neondb
--

SELECT pg_catalog.setval('finanzas.ingreso_caja_id_ingreso_caja_seq', 33, true);


--
-- Name: ingresos_id_ingresos_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: neondb
--

SELECT pg_catalog.setval('finanzas.ingresos_id_ingresos_seq', 18, true);


--
-- Name: etiquetas_id_etiquetas_seq; Type: SEQUENCE SET; Schema: objetivos; Owner: neondb
--

SELECT pg_catalog.setval('objetivos.etiquetas_id_etiquetas_seq', 6, true);


--
-- Name: formulas_id_formulas_seq; Type: SEQUENCE SET; Schema: objetivos; Owner: neondb
--

SELECT pg_catalog.setval('objetivos.formulas_id_formulas_seq', 29, true);


--
-- Name: iconos_id_iconos_seq; Type: SEQUENCE SET; Schema: objetivos; Owner: neondb
--

SELECT pg_catalog.setval('objetivos.iconos_id_iconos_seq', 285, true);


--
-- Name: objetivos_id_objetivos_seq; Type: SEQUENCE SET; Schema: objetivos; Owner: neondb
--

SELECT pg_catalog.setval('objetivos.objetivos_id_objetivos_seq', 37, true);


--
-- Name: perspectivas_id_perspectivas_seq; Type: SEQUENCE SET; Schema: objetivos; Owner: neondb
--

SELECT pg_catalog.setval('objetivos.perspectivas_id_perspectivas_seq', 11, true);


--
-- Name: depositos depositos_pk; Type: CONSTRAINT; Schema: almacenes; Owner: neondb
--

ALTER TABLE ONLY almacenes.depositos
    ADD CONSTRAINT depositos_pk PRIMARY KEY (id_depositos);


--
-- Name: movimientos movimientos_pk; Type: CONSTRAINT; Schema: almacenes; Owner: neondb
--

ALTER TABLE ONLY almacenes.movimientos
    ADD CONSTRAINT movimientos_pk PRIMARY KEY (id_movimientos, id_tipo_movimientos);


--
-- Name: reservas reservas_pk; Type: CONSTRAINT; Schema: almacenes; Owner: neondb
--

ALTER TABLE ONLY almacenes.reservas
    ADD CONSTRAINT reservas_pk PRIMARY KEY (id_reservas);


--
-- Name: movimiento_statu salida_statu_unique; Type: CONSTRAINT; Schema: almacenes; Owner: neondb
--

ALTER TABLE ONLY almacenes.movimiento_statu
    ADD CONSTRAINT salida_statu_unique UNIQUE (id_salidas, id_status);


--
-- Name: status status_pk; Type: CONSTRAINT; Schema: almacenes; Owner: neondb
--

ALTER TABLE ONLY almacenes.status
    ADD CONSTRAINT status_pk PRIMARY KEY (id_status);


--
-- Name: tipo_movimientos tipo_salidas_pk; Type: CONSTRAINT; Schema: almacenes; Owner: neondb
--

ALTER TABLE ONLY almacenes.tipo_movimientos
    ADD CONSTRAINT tipo_salidas_pk PRIMARY KEY (id_tipo_movimientos);


--
-- Name: compras compras_pk; Type: CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT compras_pk PRIMARY KEY (id_compras);


--
-- Name: det_compra det_compras_pk; Type: CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.det_compra
    ADD CONSTRAINT det_compras_pk PRIMARY KEY (id_det_compra);


--
-- Name: det_orden_compra det_orden_compra_pk; Type: CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.det_orden_compra
    ADD CONSTRAINT det_orden_compra_pk PRIMARY KEY (id_det_orden_compra);


--
-- Name: ordenes_compras ordenes_compras_pk; Type: CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.ordenes_compras
    ADD CONSTRAINT ordenes_compras_pk PRIMARY KEY (id_ordenes_compras);


--
-- Name: proveedores proveedores_pk; Type: CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.proveedores
    ADD CONSTRAINT proveedores_pk PRIMARY KEY (id_proveedores);


--
-- Name: status statu_pk; Type: CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.status
    ADD CONSTRAINT statu_pk PRIMARY KEY (id_status);


--
-- Name: tipo_proveedores tipo_proveedores_pk; Type: CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.tipo_proveedores
    ADD CONSTRAINT tipo_proveedores_pk PRIMARY KEY (id_tipo_proveedores);


--
-- Name: tipo_proveedores tipo_proveedores_unique; Type: CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.tipo_proveedores
    ADD CONSTRAINT tipo_proveedores_unique UNIQUE (tipo);


--
-- Name: bancos bancos_pk; Type: CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.bancos
    ADD CONSTRAINT bancos_pk PRIMARY KEY (id_bancos);


--
-- Name: cajas cajas_pk; Type: CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.cajas
    ADD CONSTRAINT cajas_pk PRIMARY KEY (id_cajas);


--
-- Name: egreso_banco egreso_banco_pk; Type: CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.egreso_banco
    ADD CONSTRAINT egreso_banco_pk PRIMARY KEY (id_egreso_banco);


--
-- Name: egreso_caja egreso_caja_pk; Type: CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.egreso_caja
    ADD CONSTRAINT egreso_caja_pk PRIMARY KEY (id_egreso_caja);


--
-- Name: egresos egresos_pk; Type: CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.egresos
    ADD CONSTRAINT egresos_pk PRIMARY KEY (id_mov_egresos, id_medios);


--
-- Name: egresos egresos_unique; Type: CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.egresos
    ADD CONSTRAINT egresos_unique UNIQUE (id_egresos);


--
-- Name: ingreso_banco ingreso_banco_pk; Type: CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.ingreso_banco
    ADD CONSTRAINT ingreso_banco_pk PRIMARY KEY (id_ingreso_banco);


--
-- Name: ingreso_caja ingreso_caja_pk; Type: CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.ingreso_caja
    ADD CONSTRAINT ingreso_caja_pk PRIMARY KEY (id_ingreso_caja);


--
-- Name: ingresos ingresos_pk; Type: CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.ingresos
    ADD CONSTRAINT ingresos_pk PRIMARY KEY (id_mov_ingresos, id_medios);


--
-- Name: ingresos ingresos_unique; Type: CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.ingresos
    ADD CONSTRAINT ingresos_unique UNIQUE (id_ingresos);


--
-- Name: medios medios_pk; Type: CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.medios
    ADD CONSTRAINT medios_pk PRIMARY KEY (id_medios);


--
-- Name: metodo_pagos metodo_pagos_pk; Type: CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.metodo_pagos
    ADD CONSTRAINT metodo_pagos_pk PRIMARY KEY (id_metodo_pagos);


--
-- Name: monedas monedas_pk; Type: CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.monedas
    ADD CONSTRAINT monedas_pk PRIMARY KEY (id_monedas);


--
-- Name: tipo_bancos tipo_bancos_pk; Type: CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.tipo_bancos
    ADD CONSTRAINT tipo_bancos_pk PRIMARY KEY (id_tipo_bancos);


--
-- Name: tipo_movimientos tipo_entradas_cajas_pk; Type: CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.tipo_movimientos
    ADD CONSTRAINT tipo_entradas_cajas_pk PRIMARY KEY (id_tipo_movimientos);


--
-- Name: etiqueta_indicador etiqueta_indicador_unique; Type: CONSTRAINT; Schema: objetivos; Owner: neondb
--

ALTER TABLE ONLY objetivos.etiqueta_indicador
    ADD CONSTRAINT etiqueta_indicador_unique UNIQUE (id_etiquetas, id_indicadores);


--
-- Name: etiquetas etiquetas_pk; Type: CONSTRAINT; Schema: objetivos; Owner: neondb
--

ALTER TABLE ONLY objetivos.etiquetas
    ADD CONSTRAINT etiquetas_pk PRIMARY KEY (id_etiquetas);


--
-- Name: etiquetas etiquetas_unique; Type: CONSTRAINT; Schema: objetivos; Owner: neondb
--

ALTER TABLE ONLY objetivos.etiquetas
    ADD CONSTRAINT etiquetas_unique UNIQUE (etiqueta);


--
-- Name: formulas formulas_pk; Type: CONSTRAINT; Schema: objetivos; Owner: neondb
--

ALTER TABLE ONLY objetivos.formulas
    ADD CONSTRAINT formulas_pk PRIMARY KEY (id_formulas);


--
-- Name: iconos iconos_pk; Type: CONSTRAINT; Schema: objetivos; Owner: neondb
--

ALTER TABLE ONLY objetivos.iconos
    ADD CONSTRAINT iconos_pk PRIMARY KEY (id_iconos);


--
-- Name: iconos iconos_unique; Type: CONSTRAINT; Schema: objetivos; Owner: neondb
--

ALTER TABLE ONLY objetivos.iconos
    ADD CONSTRAINT iconos_unique UNIQUE (icono);


--
-- Name: indicadores indicadores_pk; Type: CONSTRAINT; Schema: objetivos; Owner: neondb
--

ALTER TABLE ONLY objetivos.indicadores
    ADD CONSTRAINT indicadores_pk PRIMARY KEY (id_indicadores);


--
-- Name: objetivos objetivos_pkey; Type: CONSTRAINT; Schema: objetivos; Owner: neondb
--

ALTER TABLE ONLY objetivos.objetivos
    ADD CONSTRAINT objetivos_pkey PRIMARY KEY (id_objetivos);


--
-- Name: perspectiva_etiqueta perspectiva_etiqueta_unique; Type: CONSTRAINT; Schema: objetivos; Owner: neondb
--

ALTER TABLE ONLY objetivos.perspectiva_etiqueta
    ADD CONSTRAINT perspectiva_etiqueta_unique UNIQUE (id_etiquetas, id_perspectivas);


--
-- Name: perspectivas perspectivas_pk; Type: CONSTRAINT; Schema: objetivos; Owner: neondb
--

ALTER TABLE ONLY objetivos.perspectivas
    ADD CONSTRAINT perspectivas_pk PRIMARY KEY (id_perspectivas);


--
-- Name: perspectivas perspectivas_unique; Type: CONSTRAINT; Schema: objetivos; Owner: neondb
--

ALTER TABLE ONLY objetivos.perspectivas
    ADD CONSTRAINT perspectivas_unique UNIQUE (id_iconos);


--
-- Name: categorias categorias_pk; Type: CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.categorias
    ADD CONSTRAINT categorias_pk PRIMARY KEY (id_categorias);


--
-- Name: categorias categorias_unique; Type: CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.categorias
    ADD CONSTRAINT categorias_unique UNIQUE (categoria);


--
-- Name: detalle_productos detalle_productos_pk; Type: CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.detalle_productos
    ADD CONSTRAINT detalle_productos_pk PRIMARY KEY (id_detalle_productos);


--
-- Name: marcas marcas_pk; Type: CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.marcas
    ADD CONSTRAINT marcas_pk PRIMARY KEY (id_marcas);


--
-- Name: marcas marcas_unique; Type: CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.marcas
    ADD CONSTRAINT marcas_unique UNIQUE (marca);


--
-- Name: presentaciones presentaciones_pk; Type: CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.presentaciones
    ADD CONSTRAINT presentaciones_pk PRIMARY KEY (id_presentaciones);


--
-- Name: productos productos_pk; Type: CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.productos
    ADD CONSTRAINT productos_pk PRIMARY KEY (id_productos);


--
-- Name: productos productos_unique; Type: CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.productos
    ADD CONSTRAINT productos_unique UNIQUE (codigo);


--
-- Name: subcategorias subcategorias_pk; Type: CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.subcategorias
    ADD CONSTRAINT subcategorias_pk PRIMARY KEY (id_subcategorias);


--
-- Name: subcategorias subcategorias_unique; Type: CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.subcategorias
    ADD CONSTRAINT subcategorias_unique UNIQUE (subcategoria);


--
-- Name: tipo_productos tipo_productos_pk; Type: CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.tipo_productos
    ADD CONSTRAINT tipo_productos_pk PRIMARY KEY (id_tipo_productos);


--
-- Name: tipo_productos tipo_productos_unique; Type: CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.tipo_productos
    ADD CONSTRAINT tipo_productos_unique UNIQUE (tipo);


--
-- Name: unidades unidades_pk; Type: CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.unidades
    ADD CONSTRAINT unidades_pk PRIMARY KEY (id_unidades);


--
-- Name: unidades unidades_unique; Type: CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.unidades
    ADD CONSTRAINT unidades_unique UNIQUE (unidad);


--
-- Name: ciudades ciudades_pk; Type: CONSTRAINT; Schema: public; Owner: neondb
--

ALTER TABLE ONLY public.ciudades
    ADD CONSTRAINT ciudades_pk PRIMARY KEY (id_ciudades);


--
-- Name: ciudades ciudades_unique; Type: CONSTRAINT; Schema: public; Owner: neondb
--

ALTER TABLE ONLY public.ciudades
    ADD CONSTRAINT ciudades_unique UNIQUE (ciudad, id_estados);


--
-- Name: estados estados_pk; Type: CONSTRAINT; Schema: public; Owner: neondb
--

ALTER TABLE ONLY public.estados
    ADD CONSTRAINT estados_pk PRIMARY KEY (id_estados);


--
-- Name: estados estados_unique; Type: CONSTRAINT; Schema: public; Owner: neondb
--

ALTER TABLE ONLY public.estados
    ADD CONSTRAINT estados_unique UNIQUE (estado);


--
-- Name: fechas fechas_pk; Type: CONSTRAINT; Schema: public; Owner: neondb
--

ALTER TABLE ONLY public.fechas
    ADD CONSTRAINT fechas_pk PRIMARY KEY (id_fechas);


--
-- Name: horas horas_pk; Type: CONSTRAINT; Schema: public; Owner: neondb
--

ALTER TABLE ONLY public.horas
    ADD CONSTRAINT horas_pk PRIMARY KEY (id_horas);


--
-- Name: permisos permisos_pk; Type: CONSTRAINT; Schema: public; Owner: neondb
--

ALTER TABLE ONLY public.permisos
    ADD CONSTRAINT permisos_pk PRIMARY KEY (id_permisos);


--
-- Name: personas personas_pk; Type: CONSTRAINT; Schema: public; Owner: neondb
--

ALTER TABLE ONLY public.personas
    ADD CONSTRAINT personas_pk PRIMARY KEY (id_personas);


--
-- Name: role_permiso role_permiso_unique; Type: CONSTRAINT; Schema: public; Owner: neondb
--

ALTER TABLE ONLY public.role_permiso
    ADD CONSTRAINT role_permiso_unique UNIQUE (id_roles, id_permisos);


--
-- Name: roles roles_pk; Type: CONSTRAINT; Schema: public; Owner: neondb
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pk PRIMARY KEY (id_roles);


--
-- Name: tipo_facturas tipo_facturas_pk; Type: CONSTRAINT; Schema: public; Owner: neondb
--

ALTER TABLE ONLY public.tipo_facturas
    ADD CONSTRAINT tipo_facturas_pk PRIMARY KEY (id_tipo_facturas);


--
-- Name: tipo_facturas tipo_facturas_unique; Type: CONSTRAINT; Schema: public; Owner: neondb
--

ALTER TABLE ONLY public.tipo_facturas
    ADD CONSTRAINT tipo_facturas_unique UNIQUE (tipo);


--
-- Name: usuarios usuarios_pk; Type: CONSTRAINT; Schema: public; Owner: neondb
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pk PRIMARY KEY (id_usuarios);


--
-- Name: det_venta det_venta_pk; Type: CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.det_venta
    ADD CONSTRAINT det_venta_pk PRIMARY KEY (id_det_venta);


--
-- Name: det_venta_statu det_venta_statu_unique; Type: CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.det_venta_statu
    ADD CONSTRAINT det_venta_statu_unique UNIQUE (id_det_venta, id_status);


--
-- Name: status status_pk; Type: CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.status
    ADD CONSTRAINT status_pk PRIMARY KEY (id_status);


--
-- Name: tipo_clientes tipo_clientes_pk; Type: CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.tipo_clientes
    ADD CONSTRAINT tipo_clientes_pk PRIMARY KEY (id_tipo_clientes);


--
-- Name: tipo_clientes tipo_clientes_unique; Type: CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.tipo_clientes
    ADD CONSTRAINT tipo_clientes_unique UNIQUE (tipo);


--
-- Name: vendedores vendedores_pk; Type: CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.vendedores
    ADD CONSTRAINT vendedores_pk PRIMARY KEY (id_vendedores);


--
-- Name: venta_statu venta_statu_unique; Type: CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.venta_statu
    ADD CONSTRAINT venta_statu_unique UNIQUE (id_ventas, id_status);


--
-- Name: ventas ventas_pk; Type: CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT ventas_pk PRIMARY KEY (id_ventas);


--
-- Name: movimientos entradas_depositos_fk; Type: FK CONSTRAINT; Schema: almacenes; Owner: neondb
--

ALTER TABLE ONLY almacenes.movimientos
    ADD CONSTRAINT entradas_depositos_fk FOREIGN KEY (id_depositos) REFERENCES almacenes.depositos(id_depositos);


--
-- Name: movimientos entradas_productos_fk; Type: FK CONSTRAINT; Schema: almacenes; Owner: neondb
--

ALTER TABLE ONLY almacenes.movimientos
    ADD CONSTRAINT entradas_productos_fk FOREIGN KEY (id_productos) REFERENCES productos.productos(id_productos);


--
-- Name: movimientos entradas_tipo_movimientos_fk; Type: FK CONSTRAINT; Schema: almacenes; Owner: neondb
--

ALTER TABLE ONLY almacenes.movimientos
    ADD CONSTRAINT entradas_tipo_movimientos_fk FOREIGN KEY (id_tipo_movimientos) REFERENCES almacenes.tipo_movimientos(id_tipo_movimientos);


--
-- Name: reservas reservas_depositos_fk; Type: FK CONSTRAINT; Schema: almacenes; Owner: neondb
--

ALTER TABLE ONLY almacenes.reservas
    ADD CONSTRAINT reservas_depositos_fk FOREIGN KEY (id_depositos) REFERENCES almacenes.depositos(id_depositos);


--
-- Name: reservas reservas_productos_fk; Type: FK CONSTRAINT; Schema: almacenes; Owner: neondb
--

ALTER TABLE ONLY almacenes.reservas
    ADD CONSTRAINT reservas_productos_fk FOREIGN KEY (id_productos) REFERENCES productos.productos(id_productos);


--
-- Name: movimiento_statu salida_statu_fechas_fk; Type: FK CONSTRAINT; Schema: almacenes; Owner: neondb
--

ALTER TABLE ONLY almacenes.movimiento_statu
    ADD CONSTRAINT salida_statu_fechas_fk FOREIGN KEY (id_fechas) REFERENCES public.fechas(id_fechas);


--
-- Name: movimiento_statu salida_statu_horas_fk; Type: FK CONSTRAINT; Schema: almacenes; Owner: neondb
--

ALTER TABLE ONLY almacenes.movimiento_statu
    ADD CONSTRAINT salida_statu_horas_fk FOREIGN KEY (id_horas) REFERENCES public.horas(id_horas);


--
-- Name: movimiento_statu salida_statu_status_fk; Type: FK CONSTRAINT; Schema: almacenes; Owner: neondb
--

ALTER TABLE ONLY almacenes.movimiento_statu
    ADD CONSTRAINT salida_statu_status_fk FOREIGN KEY (id_status) REFERENCES almacenes.status(id_status);


--
-- Name: compras compras_fechas_fk; Type: FK CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT compras_fechas_fk FOREIGN KEY (id_fechas) REFERENCES public.fechas(id_fechas);


--
-- Name: compras compras_horas_fk; Type: FK CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT compras_horas_fk FOREIGN KEY (id_horas) REFERENCES public.horas(id_horas);


--
-- Name: compras compras_ordenes_compras_fk; Type: FK CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT compras_ordenes_compras_fk FOREIGN KEY (id_ordenes_compras) REFERENCES compras.ordenes_compras(id_ordenes_compras);


--
-- Name: compras compras_proveedores_fk; Type: FK CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT compras_proveedores_fk FOREIGN KEY (id_proveedores) REFERENCES compras.proveedores(id_proveedores);


--
-- Name: compras compras_tipo_facturas_fk; Type: FK CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT compras_tipo_facturas_fk FOREIGN KEY (id_tipo_facturas) REFERENCES public.tipo_facturas(id_tipo_facturas);


--
-- Name: det_compra det_compra_compras_fk; Type: FK CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.det_compra
    ADD CONSTRAINT det_compra_compras_fk FOREIGN KEY (id_compras) REFERENCES compras.compras(id_compras);


--
-- Name: det_compra det_compra_depositos_fk; Type: FK CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.det_compra
    ADD CONSTRAINT det_compra_depositos_fk FOREIGN KEY (id_depositos) REFERENCES almacenes.depositos(id_depositos);


--
-- Name: det_compra det_compra_presentaciones_fk; Type: FK CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.det_compra
    ADD CONSTRAINT det_compra_presentaciones_fk FOREIGN KEY (id_presentaciones) REFERENCES productos.presentaciones(id_presentaciones);


--
-- Name: det_compra det_compra_productos_fk; Type: FK CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.det_compra
    ADD CONSTRAINT det_compra_productos_fk FOREIGN KEY (id_productos) REFERENCES productos.productos(id_productos);


--
-- Name: det_compra_statu det_compra_statu_det_compra_fk; Type: FK CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.det_compra_statu
    ADD CONSTRAINT det_compra_statu_det_compra_fk FOREIGN KEY (id_det_compra) REFERENCES compras.det_compra(id_det_compra);


--
-- Name: det_compra_statu det_compra_statu_status_fk; Type: FK CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.det_compra_statu
    ADD CONSTRAINT det_compra_statu_status_fk FOREIGN KEY (id_status) REFERENCES compras.status(id_status);


--
-- Name: det_orden_compra det_orden_compra_depositos_fk; Type: FK CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.det_orden_compra
    ADD CONSTRAINT det_orden_compra_depositos_fk FOREIGN KEY (id_depositos) REFERENCES almacenes.depositos(id_depositos);


--
-- Name: det_orden_compra det_orden_compra_ordenes_compras_fk; Type: FK CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.det_orden_compra
    ADD CONSTRAINT det_orden_compra_ordenes_compras_fk FOREIGN KEY (id_ordenes_compras) REFERENCES compras.ordenes_compras(id_ordenes_compras);


--
-- Name: det_orden_compra det_orden_compra_productos_fk; Type: FK CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.det_orden_compra
    ADD CONSTRAINT det_orden_compra_productos_fk FOREIGN KEY (id_productos) REFERENCES productos.productos(id_productos);


--
-- Name: ordenes_compras ordenes_compras_proveedores_fk; Type: FK CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.ordenes_compras
    ADD CONSTRAINT ordenes_compras_proveedores_fk FOREIGN KEY (id_proveedores) REFERENCES compras.proveedores(id_proveedores);


--
-- Name: proveedores proveedores_tipo_proveedores_fk; Type: FK CONSTRAINT; Schema: compras; Owner: neondb
--

ALTER TABLE ONLY compras.proveedores
    ADD CONSTRAINT proveedores_tipo_proveedores_fk FOREIGN KEY (id_tipo_proveedores) REFERENCES compras.tipo_proveedores(id_tipo_proveedores);


--
-- Name: bancos bancos_tipo_bancos_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.bancos
    ADD CONSTRAINT bancos_tipo_bancos_fk FOREIGN KEY (id_tipo_bancos) REFERENCES finanzas.tipo_bancos(id_tipo_bancos);


--
-- Name: egreso_banco egreso_banco_bancos_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.egreso_banco
    ADD CONSTRAINT egreso_banco_bancos_fk FOREIGN KEY (id_bancos) REFERENCES finanzas.bancos(id_bancos);


--
-- Name: egreso_banco egreso_banco_tipo_bancos_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.egreso_banco
    ADD CONSTRAINT egreso_banco_tipo_bancos_fk FOREIGN KEY (id_tipo_bancos) REFERENCES finanzas.tipo_bancos(id_tipo_bancos);


--
-- Name: egreso_caja egreso_caja_cajas_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.egreso_caja
    ADD CONSTRAINT egreso_caja_cajas_fk FOREIGN KEY (id_cajas) REFERENCES finanzas.cajas(id_cajas);


--
-- Name: egresos egresos_medios_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.egresos
    ADD CONSTRAINT egresos_medios_fk FOREIGN KEY (id_medios) REFERENCES finanzas.medios(id_medios);


--
-- Name: egresos egresos_metodo_pagos_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.egresos
    ADD CONSTRAINT egresos_metodo_pagos_fk FOREIGN KEY (id_metodo_pagos) REFERENCES finanzas.metodo_pagos(id_metodo_pagos);


--
-- Name: egresos egresos_monedas_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.egresos
    ADD CONSTRAINT egresos_monedas_fk FOREIGN KEY (id_monedas) REFERENCES finanzas.monedas(id_monedas);


--
-- Name: egresos egresos_tipo_movimientos_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.egresos
    ADD CONSTRAINT egresos_tipo_movimientos_fk FOREIGN KEY (id_tipo_movimientos) REFERENCES finanzas.tipo_movimientos(id_tipo_movimientos);


--
-- Name: ingreso_banco ingreso_banco_bancos_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.ingreso_banco
    ADD CONSTRAINT ingreso_banco_bancos_fk FOREIGN KEY (id_bancos) REFERENCES finanzas.bancos(id_bancos);


--
-- Name: ingreso_banco ingreso_banco_tipo_bancos_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.ingreso_banco
    ADD CONSTRAINT ingreso_banco_tipo_bancos_fk FOREIGN KEY (id_tipo_bancos) REFERENCES finanzas.tipo_bancos(id_tipo_bancos);


--
-- Name: ingreso_caja ingreso_caja_cajas_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.ingreso_caja
    ADD CONSTRAINT ingreso_caja_cajas_fk FOREIGN KEY (id_cajas) REFERENCES finanzas.cajas(id_cajas);


--
-- Name: ingresos ingresos_medios_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.ingresos
    ADD CONSTRAINT ingresos_medios_fk FOREIGN KEY (id_medios) REFERENCES finanzas.medios(id_medios);


--
-- Name: ingresos ingresos_metodo_pagos_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.ingresos
    ADD CONSTRAINT ingresos_metodo_pagos_fk FOREIGN KEY (id_metodo_pagos) REFERENCES finanzas.metodo_pagos(id_metodo_pagos);


--
-- Name: ingresos ingresos_monedas_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.ingresos
    ADD CONSTRAINT ingresos_monedas_fk FOREIGN KEY (id_monedas) REFERENCES finanzas.monedas(id_monedas);


--
-- Name: ingresos ingresos_tipo_movimientos_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: neondb
--

ALTER TABLE ONLY finanzas.ingresos
    ADD CONSTRAINT ingresos_tipo_movimientos_fk FOREIGN KEY (id_tipo_movimientos) REFERENCES finanzas.tipo_movimientos(id_tipo_movimientos);


--
-- Name: etiqueta_indicador etiqueta_indicador_etiquetas_fk; Type: FK CONSTRAINT; Schema: objetivos; Owner: neondb
--

ALTER TABLE ONLY objetivos.etiqueta_indicador
    ADD CONSTRAINT etiqueta_indicador_etiquetas_fk FOREIGN KEY (id_etiquetas) REFERENCES objetivos.etiquetas(id_etiquetas);


--
-- Name: etiqueta_indicador etiqueta_indicador_indicadores_fk; Type: FK CONSTRAINT; Schema: objetivos; Owner: neondb
--

ALTER TABLE ONLY objetivos.etiqueta_indicador
    ADD CONSTRAINT etiqueta_indicador_indicadores_fk FOREIGN KEY (id_indicadores) REFERENCES objetivos.indicadores(id_indicadores);


--
-- Name: formulas formulas_etiquetas_fk; Type: FK CONSTRAINT; Schema: objetivos; Owner: neondb
--

ALTER TABLE ONLY objetivos.formulas
    ADD CONSTRAINT formulas_etiquetas_fk FOREIGN KEY (id_etiquetas) REFERENCES objetivos.etiquetas(id_etiquetas);


--
-- Name: objetivos objetivos_formulas_fk; Type: FK CONSTRAINT; Schema: objetivos; Owner: neondb
--

ALTER TABLE ONLY objetivos.objetivos
    ADD CONSTRAINT objetivos_formulas_fk FOREIGN KEY (id_formulas) REFERENCES objetivos.formulas(id_formulas);


--
-- Name: perspectiva_etiqueta perspectiva_etiqueta_etiquetas_fk; Type: FK CONSTRAINT; Schema: objetivos; Owner: neondb
--

ALTER TABLE ONLY objetivos.perspectiva_etiqueta
    ADD CONSTRAINT perspectiva_etiqueta_etiquetas_fk FOREIGN KEY (id_etiquetas) REFERENCES objetivos.etiquetas(id_etiquetas);


--
-- Name: perspectivas perspectivas_iconos_fk; Type: FK CONSTRAINT; Schema: objetivos; Owner: neondb
--

ALTER TABLE ONLY objetivos.perspectivas
    ADD CONSTRAINT perspectivas_iconos_fk FOREIGN KEY (id_iconos) REFERENCES objetivos.iconos(id_iconos);


--
-- Name: detalle_productos detalle_productos_ingredientes_fk; Type: FK CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.detalle_productos
    ADD CONSTRAINT detalle_productos_ingredientes_fk FOREIGN KEY (id_ingredientes) REFERENCES productos.productos(id_productos);


--
-- Name: detalle_productos detalle_productos_productos_fk; Type: FK CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.detalle_productos
    ADD CONSTRAINT detalle_productos_productos_fk FOREIGN KEY (id_productos) REFERENCES productos.productos(id_productos);


--
-- Name: detalle_productos detalle_productos_unidades_fk; Type: FK CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.detalle_productos
    ADD CONSTRAINT detalle_productos_unidades_fk FOREIGN KEY (id_unidades) REFERENCES productos.unidades(id_unidades);


--
-- Name: presentaciones presentaciones_productos_fk; Type: FK CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.presentaciones
    ADD CONSTRAINT presentaciones_productos_fk FOREIGN KEY (id_productos) REFERENCES productos.productos(id_productos);


--
-- Name: productos productos_categorias_fk; Type: FK CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.productos
    ADD CONSTRAINT productos_categorias_fk FOREIGN KEY (id_categorias) REFERENCES productos.categorias(id_categorias);


--
-- Name: productos productos_marcas_fk; Type: FK CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.productos
    ADD CONSTRAINT productos_marcas_fk FOREIGN KEY (id_marcas) REFERENCES productos.marcas(id_marcas);


--
-- Name: productos productos_subcategorias_fk; Type: FK CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.productos
    ADD CONSTRAINT productos_subcategorias_fk FOREIGN KEY (id_subcategorias) REFERENCES productos.subcategorias(id_subcategorias);


--
-- Name: productos productos_tipo_productos_fk; Type: FK CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.productos
    ADD CONSTRAINT productos_tipo_productos_fk FOREIGN KEY (id_tipo_productos) REFERENCES productos.tipo_productos(id_tipo_productos);


--
-- Name: productos productos_unidades_fk; Type: FK CONSTRAINT; Schema: productos; Owner: neondb
--

ALTER TABLE ONLY productos.productos
    ADD CONSTRAINT productos_unidades_fk FOREIGN KEY (id_unidades) REFERENCES productos.unidades(id_unidades);


--
-- Name: ciudades ciudades_estados_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb
--

ALTER TABLE ONLY public.ciudades
    ADD CONSTRAINT ciudades_estados_fk FOREIGN KEY (id_estados) REFERENCES public.estados(id_estados);


--
-- Name: personas personas_ciudades_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb
--

ALTER TABLE ONLY public.personas
    ADD CONSTRAINT personas_ciudades_fk FOREIGN KEY (id_ciudades) REFERENCES public.ciudades(id_ciudades);


--
-- Name: role_permiso role_permiso_permisos_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb
--

ALTER TABLE ONLY public.role_permiso
    ADD CONSTRAINT role_permiso_permisos_fk FOREIGN KEY (id_permisos) REFERENCES public.permisos(id_permisos);


--
-- Name: role_permiso role_permiso_roles_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb
--

ALTER TABLE ONLY public.role_permiso
    ADD CONSTRAINT role_permiso_roles_fk FOREIGN KEY (id_roles) REFERENCES public.roles(id_roles);


--
-- Name: usuarios usuarios_roles_fk; Type: FK CONSTRAINT; Schema: public; Owner: neondb
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_roles_fk FOREIGN KEY (id_roles) REFERENCES public.roles(id_roles);


--
-- Name: det_venta det_venta_depositos_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.det_venta
    ADD CONSTRAINT det_venta_depositos_fk FOREIGN KEY (id_depositos) REFERENCES almacenes.depositos(id_depositos);


--
-- Name: det_venta det_venta_presentaciones_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.det_venta
    ADD CONSTRAINT det_venta_presentaciones_fk FOREIGN KEY (id_presentaciones) REFERENCES productos.presentaciones(id_presentaciones);


--
-- Name: det_venta det_venta_productos_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.det_venta
    ADD CONSTRAINT det_venta_productos_fk FOREIGN KEY (id_productos) REFERENCES productos.productos(id_productos);


--
-- Name: det_venta_statu det_venta_statu_det_venta_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.det_venta_statu
    ADD CONSTRAINT det_venta_statu_det_venta_fk FOREIGN KEY (id_det_venta) REFERENCES ventas.det_venta(id_det_venta);


--
-- Name: det_venta_statu det_venta_statu_fechas_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.det_venta_statu
    ADD CONSTRAINT det_venta_statu_fechas_fk FOREIGN KEY (id_fechas) REFERENCES public.fechas(id_fechas);


--
-- Name: det_venta_statu det_venta_statu_horas_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.det_venta_statu
    ADD CONSTRAINT det_venta_statu_horas_fk FOREIGN KEY (id_horas) REFERENCES public.horas(id_horas);


--
-- Name: det_venta_statu det_venta_statu_status_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.det_venta_statu
    ADD CONSTRAINT det_venta_statu_status_fk FOREIGN KEY (id_status) REFERENCES ventas.status(id_status);


--
-- Name: det_venta det_venta_ventas_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.det_venta
    ADD CONSTRAINT det_venta_ventas_fk FOREIGN KEY (id_ventas) REFERENCES ventas.ventas(id_ventas);


--
-- Name: venta_statu venta_statu_fechas_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.venta_statu
    ADD CONSTRAINT venta_statu_fechas_fk FOREIGN KEY (id_fechas) REFERENCES public.fechas(id_fechas);


--
-- Name: venta_statu venta_statu_horas_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.venta_statu
    ADD CONSTRAINT venta_statu_horas_fk FOREIGN KEY (id_horas) REFERENCES public.horas(id_horas);


--
-- Name: venta_statu venta_statu_status_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.venta_statu
    ADD CONSTRAINT venta_statu_status_fk FOREIGN KEY (id_status) REFERENCES ventas.status(id_status);


--
-- Name: venta_statu venta_statu_ventas_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.venta_statu
    ADD CONSTRAINT venta_statu_ventas_fk FOREIGN KEY (id_ventas) REFERENCES ventas.ventas(id_ventas);


--
-- Name: ventas ventas_cajas_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT ventas_cajas_fk FOREIGN KEY (id_cajas) REFERENCES finanzas.cajas(id_cajas);


--
-- Name: ventas ventas_ciudades_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT ventas_ciudades_fk FOREIGN KEY (id_ciudades) REFERENCES public.ciudades(id_ciudades);


--
-- Name: ventas ventas_estados_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT ventas_estados_fk FOREIGN KEY (id_estados) REFERENCES public.estados(id_estados);


--
-- Name: ventas ventas_personas_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT ventas_personas_fk FOREIGN KEY (id_personas) REFERENCES public.personas(id_personas);


--
-- Name: ventas ventas_tipo_clientes_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT ventas_tipo_clientes_fk FOREIGN KEY (id_tipo_clientes) REFERENCES ventas.tipo_clientes(id_tipo_clientes);


--
-- Name: ventas ventas_tipo_facturas_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: neondb
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT ventas_tipo_facturas_fk FOREIGN KEY (id_tipo_facturas) REFERENCES public.tipo_facturas(id_tipo_facturas);


--
-- neondbQL database dump complete
--

