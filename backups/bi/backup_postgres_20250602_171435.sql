--
-- PostgreSQL database dump
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
-- Name: almacenes; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA almacenes;


ALTER SCHEMA almacenes OWNER TO postgres;

--
-- Name: compras; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA compras;


ALTER SCHEMA compras OWNER TO postgres;

--
-- Name: finanzas; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA finanzas;


ALTER SCHEMA finanzas OWNER TO postgres;

--
-- Name: objetivos; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA objetivos;


ALTER SCHEMA objetivos OWNER TO postgres;

--
-- Name: productos; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA productos;


ALTER SCHEMA productos OWNER TO postgres;

--
-- Name: ventas; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA ventas;


ALTER SCHEMA ventas OWNER TO postgres;

--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- Name: fn_refrescar_almacenes(); Type: FUNCTION; Schema: almacenes; Owner: postgres
--

CREATE FUNCTION almacenes.fn_refrescar_almacenes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' OR TG_OP = 'DELETE' THEN
        IF NOT pg_trigger_depth() > 1 THEN
            REFRESH MATERIALIZED VIEW CONCURRENTLY almacenes.vw_almacenes;
        END IF;
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION almacenes.fn_refrescar_almacenes() OWNER TO postgres;

--
-- Name: fn_refrescar_compras(); Type: FUNCTION; Schema: compras; Owner: postgres
--

CREATE FUNCTION compras.fn_refrescar_compras() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' OR TG_OP = 'DELETE' THEN
        IF NOT pg_trigger_depth() > 1 THEN
            REFRESH MATERIALIZED VIEW CONCURRENTLY compras.vw_compras;
        END IF;
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION compras.fn_refrescar_compras() OWNER TO postgres;

--
-- Name: fn_refrescar_ordenes(); Type: FUNCTION; Schema: compras; Owner: postgres
--

CREATE FUNCTION compras.fn_refrescar_ordenes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' OR TG_OP = 'DELETE' THEN
        IF NOT pg_trigger_depth() > 1 THEN
            REFRESH MATERIALIZED VIEW CONCURRENTLY compras.vw_ordenes;
        END IF;
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION compras.fn_refrescar_ordenes() OWNER TO postgres;

--
-- Name: fn_refrescar_productos(); Type: FUNCTION; Schema: productos; Owner: postgres
--

CREATE FUNCTION productos.fn_refrescar_productos() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' OR TG_OP = 'DELETE' THEN
        IF NOT pg_trigger_depth() > 1 THEN
            REFRESH MATERIALIZED VIEW CONCURRENTLY productos.vw_productos;
        END IF;
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION productos.fn_refrescar_productos() OWNER TO postgres;

--
-- Name: nombre_dia_espanol(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.nombre_dia_espanol(dia_num integer) RETURNS character varying
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
    RETURN CASE dia_num
        WHEN 1 THEN 'Lunes'
        WHEN 2 THEN 'Martes'
        WHEN 3 THEN 'Miércoles'
        WHEN 4 THEN 'Jueves'
        WHEN 5 THEN 'Viernes'
        WHEN 6 THEN 'Sábado'
        WHEN 7 THEN 'Domingo'
    END;
END;
$$;


ALTER FUNCTION public.nombre_dia_espanol(dia_num integer) OWNER TO postgres;

--
-- Name: nombre_mes_espanol(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.nombre_mes_espanol(mes_num integer) RETURNS character varying
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
    RETURN CASE mes_num
        WHEN 1 THEN 'Enero'
        WHEN 2 THEN 'Febrero'
        WHEN 3 THEN 'Marzo'
        WHEN 4 THEN 'Abril'
        WHEN 5 THEN 'Mayo'
        WHEN 6 THEN 'Junio'
        WHEN 7 THEN 'Julio'
        WHEN 8 THEN 'Agosto'
        WHEN 9 THEN 'Septiembre'
        WHEN 10 THEN 'Octubre'
        WHEN 11 THEN 'Noviembre'
        WHEN 12 THEN 'Diciembre'
    END;
END;
$$;


ALTER FUNCTION public.nombre_mes_espanol(mes_num integer) OWNER TO postgres;

--
-- Name: semana_del_mes(date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.semana_del_mes(fecha date) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    primer_dia_mes DATE;
    ajuste_semana INTEGER;
    dia_del_mes INTEGER;
BEGIN
    primer_dia_mes := DATE_TRUNC('month', fecha)::DATE;
    ajuste_semana := EXTRACT(DOW FROM primer_dia_mes) - 1;
    IF ajuste_semana < 0 THEN 
        ajuste_semana := 6; 
    END IF;
    
    dia_del_mes := EXTRACT(DAY FROM fecha)::INTEGER;
    
    RETURN ((dia_del_mes + ajuste_semana - 1) / 7 + 1);
END;
$$;


ALTER FUNCTION public.semana_del_mes(fecha date) OWNER TO postgres;

--
-- Name: fn_refrescar_cotizaciones(); Type: FUNCTION; Schema: ventas; Owner: postgres
--

CREATE FUNCTION ventas.fn_refrescar_cotizaciones() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' OR TG_OP = 'DELETE' THEN
        IF NOT pg_trigger_depth() > 1 THEN
            REFRESH MATERIALIZED VIEW CONCURRENTLY ventas.vw_cotizaciones;
        END IF;
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION ventas.fn_refrescar_cotizaciones() OWNER TO postgres;

--
-- Name: fn_refrescar_ventas(); Type: FUNCTION; Schema: ventas; Owner: postgres
--

CREATE FUNCTION ventas.fn_refrescar_ventas() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' OR TG_OP = 'DELETE' THEN
        IF NOT pg_trigger_depth() > 1 THEN
            REFRESH MATERIALIZED VIEW CONCURRENTLY ventas.vw_ventas;
        END IF;
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION ventas.fn_refrescar_ventas() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: depositos; Type: TABLE; Schema: almacenes; Owner: postgres
--

CREATE TABLE almacenes.depositos (
    id_depositos smallint NOT NULL,
    deposito character varying
);


ALTER TABLE almacenes.depositos OWNER TO postgres;

--
-- Name: movimientos; Type: TABLE; Schema: almacenes; Owner: postgres
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


ALTER TABLE almacenes.movimientos OWNER TO postgres;

--
-- Name: tipo_movimientos; Type: TABLE; Schema: almacenes; Owner: postgres
--

CREATE TABLE almacenes.tipo_movimientos (
    id_tipo_movimientos smallint NOT NULL,
    tipo character varying NOT NULL,
    movimiento character varying
);


ALTER TABLE almacenes.tipo_movimientos OWNER TO postgres;

--
-- Name: categorias; Type: TABLE; Schema: productos; Owner: postgres
--

CREATE TABLE productos.categorias (
    id_categorias smallint NOT NULL,
    categoria character varying NOT NULL
);


ALTER TABLE productos.categorias OWNER TO postgres;

--
-- Name: detalle_productos; Type: TABLE; Schema: productos; Owner: postgres
--

CREATE TABLE productos.detalle_productos (
    id_detalle_productos integer NOT NULL,
    id_productos smallint NOT NULL,
    id_ingredientes smallint NOT NULL,
    cantidad numeric NOT NULL,
    id_unidades smallint
);


ALTER TABLE productos.detalle_productos OWNER TO postgres;

--
-- Name: marcas; Type: TABLE; Schema: productos; Owner: postgres
--

CREATE TABLE productos.marcas (
    id_marcas smallint NOT NULL,
    marca character varying NOT NULL
);


ALTER TABLE productos.marcas OWNER TO postgres;

--
-- Name: presentaciones; Type: TABLE; Schema: productos; Owner: postgres
--

CREATE TABLE productos.presentaciones (
    id_presentaciones integer NOT NULL,
    presentacion character varying NOT NULL,
    id_productos integer NOT NULL,
    modificador numeric
);


ALTER TABLE productos.presentaciones OWNER TO postgres;

--
-- Name: productos; Type: TABLE; Schema: productos; Owner: postgres
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


ALTER TABLE productos.productos OWNER TO postgres;

--
-- Name: subcategorias; Type: TABLE; Schema: productos; Owner: postgres
--

CREATE TABLE productos.subcategorias (
    id_subcategorias smallint NOT NULL,
    subcategoria character varying NOT NULL
);


ALTER TABLE productos.subcategorias OWNER TO postgres;

--
-- Name: tipo_productos; Type: TABLE; Schema: productos; Owner: postgres
--

CREATE TABLE productos.tipo_productos (
    id_tipo_productos smallint NOT NULL,
    tipo character varying NOT NULL
);


ALTER TABLE productos.tipo_productos OWNER TO postgres;

--
-- Name: unidades; Type: TABLE; Schema: productos; Owner: postgres
--

CREATE TABLE productos.unidades (
    id_unidades smallint NOT NULL,
    unidad character varying NOT NULL
);


ALTER TABLE productos.unidades OWNER TO postgres;

--
-- Name: vw_productos; Type: MATERIALIZED VIEW; Schema: productos; Owner: postgres
--

CREATE MATERIALIZED VIEW productos.vw_productos AS
 SELECT p.id_productos,
    p.titulo AS producto,
    p.codigo,
    c.categoria,
    s.subcategoria,
    tp.tipo AS tipo_producto,
    u.unidad,
    m.marca,
    ( SELECT string_agg((((p2.titulo)::text || '-'::text) || dp.cantidad), ', '::text ORDER BY p2.titulo) AS string_agg
           FROM (productos.detalle_productos dp
             JOIN productos.productos p2 ON ((dp.id_ingredientes = p2.id_productos)))
          WHERE (dp.id_productos = p.id_productos)) AS detalles,
    ( SELECT string_agg((((p3.presentacion)::text || '-'::text) || p3.modificador), ', '::text ORDER BY p3.presentacion) AS string_agg
           FROM productos.presentaciones p3
          WHERE (p3.id_productos = p.id_productos)) AS presentaciones
   FROM (((((productos.productos p
     LEFT JOIN productos.categorias c ON ((c.id_categorias = p.id_categorias)))
     LEFT JOIN productos.subcategorias s ON ((s.id_subcategorias = p.id_subcategorias)))
     LEFT JOIN productos.tipo_productos tp ON ((tp.id_tipo_productos = p.id_tipo_productos)))
     LEFT JOIN productos.unidades u ON ((u.id_unidades = p.id_unidades)))
     LEFT JOIN productos.marcas m ON ((m.id_marcas = p.id_marcas)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW productos.vw_productos OWNER TO postgres;

--
-- Name: fechas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fechas (
    fecha date NOT NULL,
    dia integer NOT NULL,
    dia_semana integer NOT NULL,
    nombre_dia character varying(10) NOT NULL,
    semana_anio integer NOT NULL,
    semana_mes integer NOT NULL,
    quincena integer NOT NULL,
    mes integer NOT NULL,
    nombre_mes character varying(10) NOT NULL,
    trimestre integer NOT NULL,
    semestre integer NOT NULL,
    anio integer NOT NULL,
    es_fin_de_semana boolean NOT NULL
);


ALTER TABLE public.fechas OWNER TO postgres;

--
-- Name: vw_almacenes; Type: MATERIALIZED VIEW; Schema: almacenes; Owner: postgres
--

CREATE MATERIALIZED VIEW almacenes.vw_almacenes AS
 SELECT m.id_movimientos AS id,
    d.deposito,
    tm.movimiento AS tipo_movimiento,
    vp.id_productos,
    vp.producto,
    vp.codigo,
    vp.categoria,
    vp.subcategoria,
    vp.tipo_producto,
    vp.unidad,
    vp.marca,
    vp.detalles,
    vp.presentaciones,
    m.cantidad,
    f.fecha,
    f.dia,
    f.dia_semana,
    f.nombre_dia,
    f.semana_anio,
    f.semana_mes,
    f.quincena,
    f.mes,
    f.nombre_mes,
    f.trimestre,
    f.semestre,
    f.anio,
    f.es_fin_de_semana
   FROM ((((almacenes.movimientos m
     JOIN almacenes.depositos d ON ((d.id_depositos = m.id_depositos)))
     JOIN almacenes.tipo_movimientos tm ON ((tm.id_tipo_movimientos = m.id_tipo_movimientos)))
     JOIN productos.vw_productos vp ON ((vp.id_productos = m.id_productos)))
     JOIN public.fechas f ON ((f.fecha = m.fecha)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW almacenes.vw_almacenes OWNER TO postgres;

--
-- Name: compras; Type: TABLE; Schema: compras; Owner: postgres
--

CREATE TABLE compras.compras (
    id_compras integer NOT NULL,
    id_proveedores smallint NOT NULL,
    num_factura character varying,
    id_tipo_facturas smallint,
    num_control character varying,
    fecha date,
    id_ordenes_compras integer,
    tasa numeric
);


ALTER TABLE compras.compras OWNER TO postgres;

--
-- Name: det_compra; Type: TABLE; Schema: compras; Owner: postgres
--

CREATE TABLE compras.det_compra (
    id_det_compra bigint NOT NULL,
    id_productos smallint,
    costo numeric NOT NULL,
    cantidad numeric NOT NULL,
    descuento numeric,
    id_compras integer NOT NULL,
    id_depositos smallint NOT NULL,
    id_presentaciones integer
);


ALTER TABLE compras.det_compra OWNER TO postgres;

--
-- Name: det_orden_compra; Type: TABLE; Schema: compras; Owner: postgres
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


ALTER TABLE compras.det_orden_compra OWNER TO postgres;

--
-- Name: ordenes_compras; Type: TABLE; Schema: compras; Owner: postgres
--

CREATE TABLE compras.ordenes_compras (
    id_ordenes_compras integer NOT NULL,
    id_proveedores smallint,
    fecha date,
    tasa numeric
);


ALTER TABLE compras.ordenes_compras OWNER TO postgres;

--
-- Name: proveedores; Type: TABLE; Schema: compras; Owner: postgres
--

CREATE TABLE compras.proveedores (
    id_proveedores smallint NOT NULL,
    proveedor character varying,
    id_tipo_proveedores smallint NOT NULL
);


ALTER TABLE compras.proveedores OWNER TO postgres;

--
-- Name: tipo_proveedores; Type: TABLE; Schema: compras; Owner: postgres
--

CREATE TABLE compras.tipo_proveedores (
    id_tipo_proveedores smallint NOT NULL,
    tipo character varying NOT NULL
);


ALTER TABLE compras.tipo_proveedores OWNER TO postgres;

--
-- Name: tipo_facturas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tipo_facturas (
    id_tipo_facturas smallint NOT NULL,
    tipo character varying NOT NULL,
    inicial character varying
);


ALTER TABLE public.tipo_facturas OWNER TO postgres;

--
-- Name: vw_compras; Type: MATERIALIZED VIEW; Schema: compras; Owner: postgres
--

CREATE MATERIALIZED VIEW compras.vw_compras AS
 SELECT dc.id_det_compra AS id,
    dc.cantidad,
    dc.costo,
    round((dc.costo * c.tasa), 2) AS costo_bs,
    (dc.costo * dc.cantidad) AS subtotal,
    round(((dc.costo * c.tasa) * dc.cantidad), 2) AS subtotal_bs,
    dc.descuento AS descuento_porcentaje,
    round(((((dc.costo * dc.descuento) * c.tasa) * dc.cantidad) / (100)::numeric), 2) AS descuento,
    round(((((dc.costo * dc.descuento) * c.tasa) * dc.cantidad) / (100)::numeric), 2) AS descuento_bs,
    ((dc.costo * dc.cantidad) - round(((((dc.costo * dc.descuento) * c.tasa) * dc.cantidad) / (100)::numeric), 2)) AS total,
    (round(((dc.costo * c.tasa) * dc.cantidad), 2) - round(((((dc.costo * dc.descuento) * c.tasa) * dc.cantidad) / (100)::numeric), 2)) AS total_bs,
    d.deposito,
    p.proveedor,
    tp.tipo AS tipo_proveedor,
    c.num_control,
    c.num_factura,
    tf.tipo AS tipo_factura,
    c.tasa,
    f.fecha,
    f.dia,
    f.dia_semana,
    f.nombre_dia,
    f.semana_anio,
    f.semana_mes,
    f.quincena,
    f.mes,
    f.nombre_mes,
    f.trimestre,
    f.semestre,
    f.anio,
    f.es_fin_de_semana,
    vp.id_productos,
    vp.producto,
    vp.codigo,
    vp.categoria,
    vp.subcategoria,
    vp.tipo_producto,
    vp.unidad,
    vp.marca,
    vp.detalles,
    vp.presentaciones,
    pr.presentacion,
    pr.modificador
   FROM ((((((((compras.det_compra dc
     JOIN compras.compras c ON ((c.id_compras = dc.id_compras)))
     LEFT JOIN compras.proveedores p ON ((p.id_proveedores = c.id_proveedores)))
     LEFT JOIN compras.tipo_proveedores tp ON ((tp.id_tipo_proveedores = p.id_tipo_proveedores)))
     LEFT JOIN public.tipo_facturas tf ON ((tf.id_tipo_facturas = c.id_tipo_facturas)))
     LEFT JOIN almacenes.depositos d ON ((d.id_depositos = dc.id_depositos)))
     LEFT JOIN productos.vw_productos vp ON ((vp.id_productos = dc.id_productos)))
     LEFT JOIN public.fechas f ON ((f.fecha = c.fecha)))
     LEFT JOIN productos.presentaciones pr ON ((pr.id_presentaciones = dc.id_presentaciones)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW compras.vw_compras OWNER TO postgres;

--
-- Name: vw_ordenes; Type: MATERIALIZED VIEW; Schema: compras; Owner: postgres
--

CREATE MATERIALIZED VIEW compras.vw_ordenes AS
 SELECT dc.id_det_orden_compra AS id,
    dc.cantidad,
    dc.costo,
    round((dc.costo * c.tasa), 2) AS costo_bs,
    (dc.costo * dc.cantidad) AS subtotal,
    round(((dc.costo * c.tasa) * dc.cantidad), 2) AS subtotal_bs,
    dc.descuento AS descuento_porcentaje,
    round(((((dc.costo * dc.descuento) * c.tasa) * dc.cantidad) / (100)::numeric), 2) AS descuento,
    round(((((dc.costo * dc.descuento) * c.tasa) * dc.cantidad) / (100)::numeric), 2) AS descuento_bs,
    ((dc.costo * dc.cantidad) - round(((((dc.costo * dc.descuento) * c.tasa) * dc.cantidad) / (100)::numeric), 2)) AS total,
    (round(((dc.costo * c.tasa) * dc.cantidad), 2) - round(((((dc.costo * dc.descuento) * c.tasa) * dc.cantidad) / (100)::numeric), 2)) AS total_bs,
    d.deposito,
    p.proveedor,
    tp.tipo AS tipo_proveedor,
    c.tasa,
    f.fecha,
    f.dia,
    f.dia_semana,
    f.nombre_dia,
    f.semana_anio,
    f.semana_mes,
    f.quincena,
    f.mes,
    f.nombre_mes,
    f.trimestre,
    f.semestre,
    f.anio,
    f.es_fin_de_semana,
    vp.id_productos,
    vp.producto,
    vp.codigo,
    vp.categoria,
    vp.subcategoria,
    vp.tipo_producto,
    vp.unidad,
    vp.marca,
    vp.detalles,
    vp.presentaciones,
        CASE
            WHEN (( SELECT count(*) AS count
               FROM compras.compras c_1
              WHERE (c_1.id_ordenes_compras = dc.id_ordenes_compras)) >= 1) THEN true
            ELSE false
        END AS comprado
   FROM ((((((compras.det_orden_compra dc
     JOIN compras.ordenes_compras c ON ((c.id_ordenes_compras = dc.id_ordenes_compras)))
     LEFT JOIN compras.proveedores p ON ((p.id_proveedores = c.id_proveedores)))
     LEFT JOIN compras.tipo_proveedores tp ON ((tp.id_tipo_proveedores = p.id_tipo_proveedores)))
     LEFT JOIN almacenes.depositos d ON ((d.id_depositos = dc.id_depositos)))
     LEFT JOIN productos.vw_productos vp ON ((vp.id_productos = dc.id_productos)))
     LEFT JOIN public.fechas f ON ((f.fecha = c.fecha)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW compras.vw_ordenes OWNER TO postgres;

--
-- Name: bancos; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.bancos (
    id_bancos smallint NOT NULL,
    cuenta character varying NOT NULL,
    id_tipo_bancos smallint NOT NULL
);


ALTER TABLE finanzas.bancos OWNER TO postgres;

--
-- Name: cajas; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.cajas (
    id_cajas smallint NOT NULL,
    caja character varying NOT NULL
);


ALTER TABLE finanzas.cajas OWNER TO postgres;

--
-- Name: egreso_banco; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.egreso_banco (
    id_egresos bigint,
    id_tipo_bancos smallint,
    id_bancos smallint,
    id_egreso_banco bigint NOT NULL
);


ALTER TABLE finanzas.egreso_banco OWNER TO postgres;

--
-- Name: egreso_banco_id_egreso_banco_seq; Type: SEQUENCE; Schema: finanzas; Owner: postgres
--

CREATE SEQUENCE finanzas.egreso_banco_id_egreso_banco_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finanzas.egreso_banco_id_egreso_banco_seq OWNER TO postgres;

--
-- Name: egreso_banco_id_egreso_banco_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.egreso_banco_id_egreso_banco_seq OWNED BY finanzas.egreso_banco.id_egreso_banco;


--
-- Name: egreso_caja; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.egreso_caja (
    id_egresos bigint,
    id_cajas smallint,
    id_egreso_caja bigint NOT NULL
);


ALTER TABLE finanzas.egreso_caja OWNER TO postgres;

--
-- Name: egreso_caja_id_egreso_caja_seq; Type: SEQUENCE; Schema: finanzas; Owner: postgres
--

CREATE SEQUENCE finanzas.egreso_caja_id_egreso_caja_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finanzas.egreso_caja_id_egreso_caja_seq OWNER TO postgres;

--
-- Name: egreso_caja_id_egreso_caja_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.egreso_caja_id_egreso_caja_seq OWNED BY finanzas.egreso_caja.id_egreso_caja;


--
-- Name: egresos; Type: TABLE; Schema: finanzas; Owner: postgres
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


ALTER TABLE finanzas.egresos OWNER TO postgres;

--
-- Name: egresos_id_egresos_seq; Type: SEQUENCE; Schema: finanzas; Owner: postgres
--

CREATE SEQUENCE finanzas.egresos_id_egresos_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finanzas.egresos_id_egresos_seq OWNER TO postgres;

--
-- Name: egresos_id_egresos_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.egresos_id_egresos_seq OWNED BY finanzas.egresos.id_egresos;


--
-- Name: ingreso_banco; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.ingreso_banco (
    id_ingresos bigint,
    id_tipo_bancos smallint,
    id_bancos smallint,
    id_ingreso_banco bigint NOT NULL
);


ALTER TABLE finanzas.ingreso_banco OWNER TO postgres;

--
-- Name: ingreso_banco_id_ingreso_banco_seq; Type: SEQUENCE; Schema: finanzas; Owner: postgres
--

CREATE SEQUENCE finanzas.ingreso_banco_id_ingreso_banco_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finanzas.ingreso_banco_id_ingreso_banco_seq OWNER TO postgres;

--
-- Name: ingreso_banco_id_ingreso_banco_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.ingreso_banco_id_ingreso_banco_seq OWNED BY finanzas.ingreso_banco.id_ingreso_banco;


--
-- Name: ingreso_caja; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.ingreso_caja (
    id_ingresos bigint,
    id_cajas smallint,
    id_ingreso_caja bigint NOT NULL
);


ALTER TABLE finanzas.ingreso_caja OWNER TO postgres;

--
-- Name: ingreso_caja_id_ingreso_caja_seq; Type: SEQUENCE; Schema: finanzas; Owner: postgres
--

CREATE SEQUENCE finanzas.ingreso_caja_id_ingreso_caja_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finanzas.ingreso_caja_id_ingreso_caja_seq OWNER TO postgres;

--
-- Name: ingreso_caja_id_ingreso_caja_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.ingreso_caja_id_ingreso_caja_seq OWNED BY finanzas.ingreso_caja.id_ingreso_caja;


--
-- Name: ingresos; Type: TABLE; Schema: finanzas; Owner: postgres
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


ALTER TABLE finanzas.ingresos OWNER TO postgres;

--
-- Name: ingresos_id_ingresos_seq; Type: SEQUENCE; Schema: finanzas; Owner: postgres
--

CREATE SEQUENCE finanzas.ingresos_id_ingresos_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE finanzas.ingresos_id_ingresos_seq OWNER TO postgres;

--
-- Name: ingresos_id_ingresos_seq; Type: SEQUENCE OWNED BY; Schema: finanzas; Owner: postgres
--

ALTER SEQUENCE finanzas.ingresos_id_ingresos_seq OWNED BY finanzas.ingresos.id_ingresos;


--
-- Name: medios; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.medios (
    id_medios smallint NOT NULL,
    medio character varying
);


ALTER TABLE finanzas.medios OWNER TO postgres;

--
-- Name: metodo_pagos; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.metodo_pagos (
    id_metodo_pagos smallint NOT NULL,
    metodo character varying NOT NULL
);


ALTER TABLE finanzas.metodo_pagos OWNER TO postgres;

--
-- Name: monedas; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.monedas (
    id_monedas smallint NOT NULL,
    simbolo character varying NOT NULL,
    moneda character varying NOT NULL,
    descripcion character varying
);


ALTER TABLE finanzas.monedas OWNER TO postgres;

--
-- Name: tipo_bancos; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.tipo_bancos (
    id_tipo_bancos smallint NOT NULL,
    tipo character varying
);


ALTER TABLE finanzas.tipo_bancos OWNER TO postgres;

--
-- Name: tipo_movimientos; Type: TABLE; Schema: finanzas; Owner: postgres
--

CREATE TABLE finanzas.tipo_movimientos (
    id_tipo_movimientos smallint NOT NULL,
    tipo character varying NOT NULL
);


ALTER TABLE finanzas.tipo_movimientos OWNER TO postgres;

--
-- Name: etiqueta_indicador; Type: TABLE; Schema: objetivos; Owner: postgres
--

CREATE TABLE objetivos.etiqueta_indicador (
    id_etiquetas smallint NOT NULL,
    id_indicadores smallint NOT NULL
);


ALTER TABLE objetivos.etiqueta_indicador OWNER TO postgres;

--
-- Name: etiquetas; Type: TABLE; Schema: objetivos; Owner: postgres
--

CREATE TABLE objetivos.etiquetas (
    id_etiquetas smallint NOT NULL,
    etiqueta character varying NOT NULL,
    visible boolean DEFAULT true
);


ALTER TABLE objetivos.etiquetas OWNER TO postgres;

--
-- Name: etiquetas_id_etiquetas_seq; Type: SEQUENCE; Schema: objetivos; Owner: postgres
--

CREATE SEQUENCE objetivos.etiquetas_id_etiquetas_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE objetivos.etiquetas_id_etiquetas_seq OWNER TO postgres;

--
-- Name: etiquetas_id_etiquetas_seq; Type: SEQUENCE OWNED BY; Schema: objetivos; Owner: postgres
--

ALTER SEQUENCE objetivos.etiquetas_id_etiquetas_seq OWNED BY objetivos.etiquetas.id_etiquetas;


--
-- Name: formulas; Type: TABLE; Schema: objetivos; Owner: postgres
--

CREATE TABLE objetivos.formulas (
    id_formulas integer NOT NULL,
    formula text,
    titulo character varying,
    visible boolean DEFAULT true,
    id_etiquetas smallint
);


ALTER TABLE objetivos.formulas OWNER TO postgres;

--
-- Name: formulas_id_formulas_seq; Type: SEQUENCE; Schema: objetivos; Owner: postgres
--

CREATE SEQUENCE objetivos.formulas_id_formulas_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE objetivos.formulas_id_formulas_seq OWNER TO postgres;

--
-- Name: formulas_id_formulas_seq; Type: SEQUENCE OWNED BY; Schema: objetivos; Owner: postgres
--

ALTER SEQUENCE objetivos.formulas_id_formulas_seq OWNED BY objetivos.formulas.id_formulas;


--
-- Name: iconos; Type: TABLE; Schema: objetivos; Owner: postgres
--

CREATE TABLE objetivos.iconos (
    id_iconos smallint NOT NULL,
    icono character varying NOT NULL,
    visible boolean DEFAULT true
);


ALTER TABLE objetivos.iconos OWNER TO postgres;

--
-- Name: iconos_id_iconos_seq; Type: SEQUENCE; Schema: objetivos; Owner: postgres
--

CREATE SEQUENCE objetivos.iconos_id_iconos_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE objetivos.iconos_id_iconos_seq OWNER TO postgres;

--
-- Name: iconos_id_iconos_seq; Type: SEQUENCE OWNED BY; Schema: objetivos; Owner: postgres
--

ALTER SEQUENCE objetivos.iconos_id_iconos_seq OWNED BY objetivos.iconos.id_iconos;


--
-- Name: indicadores; Type: TABLE; Schema: objetivos; Owner: postgres
--

CREATE TABLE objetivos.indicadores (
    id_indicadores smallint NOT NULL,
    indicador character varying NOT NULL,
    consulta text,
    visible boolean DEFAULT true,
    descripcion character varying,
    filtro smallint DEFAULT 1
);


ALTER TABLE objetivos.indicadores OWNER TO postgres;

--
-- Name: objetivos; Type: TABLE; Schema: objetivos; Owner: postgres
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


ALTER TABLE objetivos.objetivos OWNER TO postgres;

--
-- Name: objetivos_id_objetivos_seq; Type: SEQUENCE; Schema: objetivos; Owner: postgres
--

CREATE SEQUENCE objetivos.objetivos_id_objetivos_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE objetivos.objetivos_id_objetivos_seq OWNER TO postgres;

--
-- Name: objetivos_id_objetivos_seq; Type: SEQUENCE OWNED BY; Schema: objetivos; Owner: postgres
--

ALTER SEQUENCE objetivos.objetivos_id_objetivos_seq OWNED BY objetivos.objetivos.id_objetivos;


--
-- Name: perspectiva_etiqueta; Type: TABLE; Schema: objetivos; Owner: postgres
--

CREATE TABLE objetivos.perspectiva_etiqueta (
    id_perspectivas smallint NOT NULL,
    id_etiquetas smallint NOT NULL
);


ALTER TABLE objetivos.perspectiva_etiqueta OWNER TO postgres;

--
-- Name: perspectivas; Type: TABLE; Schema: objetivos; Owner: postgres
--

CREATE TABLE objetivos.perspectivas (
    perspectiva character varying NOT NULL,
    id_iconos smallint,
    visible boolean DEFAULT true,
    id_perspectivas smallint NOT NULL
);


ALTER TABLE objetivos.perspectivas OWNER TO postgres;

--
-- Name: perspectivas_id_perspectivas_seq; Type: SEQUENCE; Schema: objetivos; Owner: postgres
--

CREATE SEQUENCE objetivos.perspectivas_id_perspectivas_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE objetivos.perspectivas_id_perspectivas_seq OWNER TO postgres;

--
-- Name: perspectivas_id_perspectivas_seq; Type: SEQUENCE OWNED BY; Schema: objetivos; Owner: postgres
--

ALTER SEQUENCE objetivos.perspectivas_id_perspectivas_seq OWNED BY objetivos.perspectivas.id_perspectivas;


--
-- Name: vw_gastos; Type: VIEW; Schema: productos; Owner: postgres
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


ALTER VIEW productos.vw_gastos OWNER TO postgres;

--
-- Name: ciudades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ciudades (
    id_ciudades smallint NOT NULL,
    ciudad character varying,
    id_estados smallint
);


ALTER TABLE public.ciudades OWNER TO postgres;

--
-- Name: estados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estados (
    id_estados smallint NOT NULL,
    estado character varying
);


ALTER TABLE public.estados OWNER TO postgres;

--
-- Name: horas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.horas (
    id_horas smallint NOT NULL,
    hora smallint NOT NULL,
    minutos smallint NOT NULL
);


ALTER TABLE public.horas OWNER TO postgres;

--
-- Name: permisos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permisos (
    id_permisos smallint NOT NULL,
    activo boolean,
    controlador character varying,
    accion character varying,
    recurso character varying,
    modulo character varying
);


ALTER TABLE public.permisos OWNER TO postgres;

--
-- Name: personas; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.personas OWNER TO postgres;

--
-- Name: role_permiso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permiso (
    id_roles smallint,
    id_permisos smallint
);


ALTER TABLE public.role_permiso OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    rol character varying,
    acceso boolean,
    id_roles smallint NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- Name: cotizaciones; Type: TABLE; Schema: ventas; Owner: postgres
--

CREATE TABLE ventas.cotizaciones (
    id_cotizaciones bigint NOT NULL,
    num_control character varying,
    tasa numeric,
    id_personas bigint,
    id_vendedores bigint,
    id_estados integer,
    id_ciudades integer,
    id_tipo_clientes integer,
    fecha timestamp without time zone
);


ALTER TABLE ventas.cotizaciones OWNER TO postgres;

--
-- Name: det_cotizacion; Type: TABLE; Schema: ventas; Owner: postgres
--

CREATE TABLE ventas.det_cotizacion (
    id_det_cotizacion bigint NOT NULL,
    id_cotizaciones bigint,
    id_productos bigint,
    id_depositos integer,
    id_vendedores integer,
    precio numeric,
    descuento numeric,
    cantidad numeric
);


ALTER TABLE ventas.det_cotizacion OWNER TO postgres;

--
-- Name: det_venta; Type: TABLE; Schema: ventas; Owner: postgres
--

CREATE TABLE ventas.det_venta (
    id_det_venta bigint NOT NULL,
    id_productos integer NOT NULL,
    id_depositos smallint NOT NULL,
    precio numeric NOT NULL,
    cantidad numeric NOT NULL,
    id_ventas bigint NOT NULL,
    descuento numeric,
    id_presentaciones integer,
    id_vendedores smallint,
    devuelto numeric
);


ALTER TABLE ventas.det_venta OWNER TO postgres;

--
-- Name: tipo_clientes; Type: TABLE; Schema: ventas; Owner: postgres
--

CREATE TABLE ventas.tipo_clientes (
    id_tipo_clientes smallint NOT NULL,
    tipo character varying
);


ALTER TABLE ventas.tipo_clientes OWNER TO postgres;

--
-- Name: vendedores; Type: TABLE; Schema: ventas; Owner: postgres
--

CREATE TABLE ventas.vendedores (
    id_vendedores integer NOT NULL,
    nombre character varying,
    porcentaje numeric
);


ALTER TABLE ventas.vendedores OWNER TO postgres;

--
-- Name: ventas; Type: TABLE; Schema: ventas; Owner: postgres
--

CREATE TABLE ventas.ventas (
    id_ventas bigint NOT NULL,
    id_personas smallint,
    id_cajas smallint NOT NULL,
    id_tipo_facturas smallint,
    num_factura character varying,
    num_control character varying,
    id_ciudades smallint,
    tasa numeric,
    id_tipo_clientes smallint,
    id_estados smallint,
    fecha timestamp without time zone,
    id_cotizaciones bigint
);


ALTER TABLE ventas.ventas OWNER TO postgres;

--
-- Name: vw_cotizaciones; Type: MATERIALIZED VIEW; Schema: ventas; Owner: postgres
--

CREATE MATERIALIZED VIEW ventas.vw_cotizaciones AS
 SELECT dv.id_det_cotizacion AS id,
    dv.cantidad,
    dv.precio,
    round((dv.precio * v.tasa), 2) AS precio_bs,
    (dv.precio * dv.cantidad) AS subtotal,
    round(((dv.precio * v.tasa) * dv.cantidad), 2) AS subtotal_bs,
    dv.descuento AS descuento_porcentaje,
    round(((((dv.precio * dv.descuento) * v.tasa) * dv.cantidad) / (100)::numeric), 2) AS descuento,
    round(((((dv.precio * dv.descuento) * v.tasa) * dv.cantidad) / (100)::numeric), 2) AS descuento_bs,
    ((dv.precio * dv.cantidad) - round(((((dv.precio * dv.descuento) * v.tasa) * dv.cantidad) / (100)::numeric), 2)) AS total,
    (round(((dv.precio * v.tasa) * dv.cantidad), 2) - round(((((dv.precio * dv.descuento) * v.tasa) * dv.cantidad) / (100)::numeric), 2)) AS total_bs,
    v.num_control,
    v.tasa,
    v2.nombre AS vendedor,
    v2.porcentaje AS porcentaje_vendedor,
    c.ciudad,
    e.estado,
    p.nombre AS cliente,
    p.direccion AS cliente_direccion,
    p.nombre_comercial AS cliente_comercial,
    d.deposito,
    f.fecha,
    f.dia,
    f.dia_semana,
    f.nombre_dia,
    f.semana_anio,
    f.semana_mes,
    f.quincena,
    f.mes,
    f.nombre_mes,
    f.trimestre,
    f.semestre,
    f.anio,
    f.es_fin_de_semana,
    tc.tipo AS tipo_cliente,
    vp.id_productos,
    vp.producto,
    vp.codigo,
    vp.categoria,
    vp.subcategoria,
    vp.tipo_producto,
    vp.unidad,
    vp.marca,
    vp.detalles,
    vp.presentaciones,
        CASE
            WHEN (( SELECT count(*) AS count
               FROM ventas.ventas v_1
              WHERE (v_1.id_cotizaciones = dv.id_cotizaciones)) >= 1) THEN true
            ELSE false
        END AS vendido
   FROM (((((((((ventas.det_cotizacion dv
     JOIN ventas.cotizaciones v ON ((v.id_cotizaciones = dv.id_cotizaciones)))
     LEFT JOIN ventas.vendedores v2 ON ((v2.id_vendedores = dv.id_vendedores)))
     LEFT JOIN public.ciudades c ON ((c.id_ciudades = v.id_ciudades)))
     LEFT JOIN public.estados e ON ((e.id_estados = v.id_estados)))
     LEFT JOIN public.personas p ON ((p.id_personas = v.id_personas)))
     LEFT JOIN productos.vw_productos vp ON ((vp.id_productos = dv.id_productos)))
     LEFT JOIN public.fechas f ON ((f.fecha = v.fecha)))
     LEFT JOIN ventas.tipo_clientes tc ON ((tc.id_tipo_clientes = v.id_tipo_clientes)))
     LEFT JOIN almacenes.depositos d ON ((d.id_depositos = dv.id_depositos)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW ventas.vw_cotizaciones OWNER TO postgres;

--
-- Name: vw_ventas; Type: MATERIALIZED VIEW; Schema: ventas; Owner: postgres
--

CREATE MATERIALIZED VIEW ventas.vw_ventas AS
 SELECT dv.id_det_venta AS id,
    dv.cantidad,
    dv.precio,
    round((dv.precio * v.tasa), 2) AS precio_bs,
    (dv.precio * dv.cantidad) AS subtotal,
    round(((dv.precio * v.tasa) * dv.cantidad), 2) AS subtotal_bs,
    dv.descuento AS descuento_porcentaje,
    round(((((dv.precio * dv.descuento) * v.tasa) * dv.cantidad) / (100)::numeric), 2) AS descuento,
    round(((((dv.precio * dv.descuento) * v.tasa) * dv.cantidad) / (100)::numeric), 2) AS descuento_bs,
    ((dv.precio * dv.cantidad) - round(((((dv.precio * dv.descuento) * v.tasa) * dv.cantidad) / (100)::numeric), 2)) AS total,
    (round(((dv.precio * v.tasa) * dv.cantidad), 2) - round(((((dv.precio * dv.descuento) * v.tasa) * dv.cantidad) / (100)::numeric), 2)) AS total_bs,
    dv.devuelto,
    v.num_control,
    v.num_factura,
    v.tasa,
    v2.nombre AS vendedor,
    v2.porcentaje AS porcentaje_vendedor,
    c.ciudad,
    e.estado,
    p.nombre AS cliente,
    p.direccion AS cliente_direccion,
    p.nombre_comercial AS cliente_comercial,
    d.deposito,
    c2.caja,
    tf.tipo AS tipo_factura,
    f.fecha,
    f.dia,
    f.dia_semana,
    f.nombre_dia,
    f.semana_anio,
    f.semana_mes,
    f.quincena,
    f.mes,
    f.nombre_mes,
    f.trimestre,
    f.semestre,
    f.anio,
    f.es_fin_de_semana,
    vp.id_productos,
    vp.producto,
    vp.codigo,
    vp.categoria,
    vp.subcategoria,
    vp.tipo_producto,
    vp.unidad,
    vp.marca,
    vp.detalles,
    vp.presentaciones,
    tc.tipo AS tipo_cliente,
    p2.presentacion,
    p2.modificador
   FROM ((((((((((((ventas.det_venta dv
     JOIN ventas.ventas v ON ((v.id_ventas = dv.id_ventas)))
     LEFT JOIN ventas.vendedores v2 ON ((v2.id_vendedores = dv.id_vendedores)))
     LEFT JOIN public.ciudades c ON ((c.id_ciudades = v.id_ciudades)))
     LEFT JOIN public.estados e ON ((e.id_estados = v.id_estados)))
     LEFT JOIN public.personas p ON ((p.id_personas = v.id_personas)))
     LEFT JOIN productos.presentaciones p2 ON ((p2.id_presentaciones = dv.id_presentaciones)))
     LEFT JOIN productos.vw_productos vp ON ((vp.id_productos = dv.id_productos)))
     LEFT JOIN public.fechas f ON ((f.fecha = date(v.fecha))))
     LEFT JOIN finanzas.cajas c2 ON ((c2.id_cajas = v.id_cajas)))
     LEFT JOIN public.tipo_facturas tf ON ((tf.id_tipo_facturas = v.id_tipo_facturas)))
     LEFT JOIN ventas.tipo_clientes tc ON ((tc.id_tipo_clientes = v.id_tipo_clientes)))
     LEFT JOIN almacenes.depositos d ON ((d.id_depositos = dv.id_depositos)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW ventas.vw_ventas OWNER TO postgres;

--
-- Name: egreso_banco id_egreso_banco; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egreso_banco ALTER COLUMN id_egreso_banco SET DEFAULT nextval('finanzas.egreso_banco_id_egreso_banco_seq'::regclass);


--
-- Name: egreso_caja id_egreso_caja; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egreso_caja ALTER COLUMN id_egreso_caja SET DEFAULT nextval('finanzas.egreso_caja_id_egreso_caja_seq'::regclass);


--
-- Name: egresos id_egresos; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egresos ALTER COLUMN id_egresos SET DEFAULT nextval('finanzas.egresos_id_egresos_seq'::regclass);


--
-- Name: ingreso_banco id_ingreso_banco; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.ingreso_banco ALTER COLUMN id_ingreso_banco SET DEFAULT nextval('finanzas.ingreso_banco_id_ingreso_banco_seq'::regclass);


--
-- Name: ingreso_caja id_ingreso_caja; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.ingreso_caja ALTER COLUMN id_ingreso_caja SET DEFAULT nextval('finanzas.ingreso_caja_id_ingreso_caja_seq'::regclass);


--
-- Name: ingresos id_ingresos; Type: DEFAULT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.ingresos ALTER COLUMN id_ingresos SET DEFAULT nextval('finanzas.ingresos_id_ingresos_seq'::regclass);


--
-- Name: etiquetas id_etiquetas; Type: DEFAULT; Schema: objetivos; Owner: postgres
--

ALTER TABLE ONLY objetivos.etiquetas ALTER COLUMN id_etiquetas SET DEFAULT nextval('objetivos.etiquetas_id_etiquetas_seq'::regclass);


--
-- Name: formulas id_formulas; Type: DEFAULT; Schema: objetivos; Owner: postgres
--

ALTER TABLE ONLY objetivos.formulas ALTER COLUMN id_formulas SET DEFAULT nextval('objetivos.formulas_id_formulas_seq'::regclass);


--
-- Name: iconos id_iconos; Type: DEFAULT; Schema: objetivos; Owner: postgres
--

ALTER TABLE ONLY objetivos.iconos ALTER COLUMN id_iconos SET DEFAULT nextval('objetivos.iconos_id_iconos_seq'::regclass);


--
-- Name: objetivos id_objetivos; Type: DEFAULT; Schema: objetivos; Owner: postgres
--

ALTER TABLE ONLY objetivos.objetivos ALTER COLUMN id_objetivos SET DEFAULT nextval('objetivos.objetivos_id_objetivos_seq'::regclass);


--
-- Name: perspectivas id_perspectivas; Type: DEFAULT; Schema: objetivos; Owner: postgres
--

ALTER TABLE ONLY objetivos.perspectivas ALTER COLUMN id_perspectivas SET DEFAULT nextval('objetivos.perspectivas_id_perspectivas_seq'::regclass);


--
-- Data for Name: depositos; Type: TABLE DATA; Schema: almacenes; Owner: postgres
--

COPY almacenes.depositos (id_depositos, deposito) FROM stdin;
1	DEPOSITO DISTRIBUIDOR
2	DEPOSITO 02
3	DEPOSITO 02
4	DEPOSITO 03
5	DEPOSITO 04
6	DEPOSITO KOHLER
7	FANTASMA
\.


--
-- Data for Name: movimientos; Type: TABLE DATA; Schema: almacenes; Owner: postgres
--

COPY almacenes.movimientos (id_movimientos, id_productos, cantidad, id_depositos, id_tipo_movimientos, fecha, entrada) FROM stdin;
1	3	30.0	1	11	2024-05-28 00:00:00	1
2	1	10.0	1	5	2024-05-28 00:00:00	1
3	3	10.0	1	11	2024-05-28 00:00:00	1
4	3	10.0	1	1	2024-05-28 00:00:00	0
5	1	1.0	1	1	2024-05-28 00:00:00	0
6	3	5.0	1	1	2024-05-28 00:00:00	0
7	3	1.0	1	1	2024-05-28 00:00:00	0
8	3	12.0	1	1	2024-05-28 00:00:00	0
9	4	5.0	1	12	2024-05-28 00:00:00	1
10	3	1.0	1	3	2024-05-28 00:00:00	0
11	3	1.0	2	3	2024-05-28 00:00:00	1
12	4	1.0	1	3	2024-05-28 00:00:00	0
13	4	1.0	2	3	2024-05-28 00:00:00	1
14	6	1.0	1	3	2024-05-28 00:00:00	1
15	3	1.0	2	3	2024-05-28 00:00:00	0
16	4	1.0	2	3	2024-05-28 00:00:00	0
17	3	5.0	1	4	2024-05-28 00:00:00	0
18	3	5.0	3	4	2024-05-28 00:00:00	1
19	4	1.0	1	4	2024-05-28 00:00:00	0
20	4	1.0	3	4	2024-05-28 00:00:00	1
21	7	10.0	1	12	2024-05-28 00:00:00	1
22	8	10.0	1	12	2024-05-28 00:00:00	1
23	9	10.0	1	12	2024-05-28 00:00:00	1
24	10	10.0	1	12	2024-05-28 00:00:00	1
25	11	10.0	1	12	2024-05-28 00:00:00	1
26	7	0.5	1	3	2024-05-28 00:00:00	0
27	7	0.5	2	3	2024-05-28 00:00:00	1
28	8	1.0	1	3	2024-05-28 00:00:00	0
29	8	1.0	2	3	2024-05-28 00:00:00	1
30	10	1.0	1	3	2024-05-28 00:00:00	0
31	10	1.0	2	3	2024-05-28 00:00:00	1
32	11	3.0	1	3	2024-05-28 00:00:00	0
33	11	3.0	2	3	2024-05-28 00:00:00	1
34	12	10.0	1	3	2024-05-28 00:00:00	1
35	7	0.5	2	3	2024-05-28 00:00:00	0
36	8	1.0	2	3	2024-05-28 00:00:00	0
37	10	1.0	2	3	2024-05-28 00:00:00	0
38	11	3.0	2	3	2024-05-28 00:00:00	0
39	13	10.0	1	12	2024-05-28 00:00:00	1
40	1	5.0	1	4	2024-05-30 00:00:00	0
41	1	5.0	3	4	2024-05-30 00:00:00	1
42	1	1.0	3	1	2024-05-30 00:00:00	0
43	1	1.0	3	1	2024-05-30 00:00:00	0
44	1	1.0	3	1	2024-05-30 00:00:00	0
45	6	1.0	1	4	2024-05-31 00:00:00	0
46	6	1.0	3	4	2024-05-31 00:00:00	1
47	4	12.0	1	11	2024-06-02 00:00:00	1
48	16	5.0	1	12	2024-06-03 00:00:00	1
49	16	1.0	1	1	2024-06-03 00:00:00	0
50	16	2.0	1	1	2024-06-03 00:00:00	0
51	17	10.0	1	12	2024-06-03 00:00:00	1
52	3	300.0	1	11	2024-06-04 00:00:00	1
53	18	10.0	1	11	2024-06-05 00:00:00	1
54	18	10.0	3	11	2024-06-05 00:00:00	1
55	18	2.0	3	1	2024-06-05 00:00:00	0
56	3	1.0	1	1	2024-06-10 00:00:00	0
57	8	1.0	1	1	2024-06-10 00:00:00	0
58	3	3.0	1	1	2024-06-10 00:00:00	0
59	4	5.0	1	1	2024-06-10 00:00:00	0
60	3	2.0	1	1	2024-06-10 00:00:00	0
61	4	3.0	1	1	2024-06-10 00:00:00	0
62	1	1.0	3	1	2024-06-20 00:00:00	0
63	9	1.0	1	1	2024-06-20 00:00:00	0
64	3	1.0	1	1	2024-06-25 00:00:00	0
65	3	2.0	1	1	2024-06-25 00:00:00	0
66	4	1.0	1	1	2024-06-25 00:00:00	0
67	20	10.0	3	11	2024-06-25 00:00:00	1
68	20	10.0	1	12	2024-06-25 00:00:00	1
69	1	1.0	3	11	2024-06-26 00:00:00	1
70	1	1.0	1	1	2024-06-27 00:00:00	0
71	1	1.0	1	1	2024-06-27 00:00:00	0
72	3	1.0	1	1	2024-06-27 00:00:00	0
73	8	1.0	1	1	2024-06-27 00:00:00	0
74	22	2.0	1	1	2024-07-01 00:00:00	0
75	17	2.0	1	1	2024-07-01 00:00:00	0
76	23	100.0	1	12	2024-07-01 00:00:00	1
77	24	100.0	1	12	2024-07-01 00:00:00	1
78	23	3.0	1	1	2024-07-01 00:00:00	0
79	24	3.0	1	1	2024-07-01 00:00:00	0
82	23	3.0	1	1	2024-07-01 00:00:00	0
83	24	3.0	1	1	2024-07-01 00:00:00	0
84	23	3.0	1	1	2024-07-01 00:00:00	0
85	24	3.0	1	1	2024-07-01 00:00:00	0
86	23	3.0	1	1	2024-07-01 00:00:00	0
87	24	3.0	1	1	2024-07-01 00:00:00	0
88	23	3.0	1	1	2024-07-01 00:00:00	0
89	24	3.0	1	1	2024-07-01 00:00:00	0
90	16	1.0	1	1	2024-07-01 00:00:00	0
91	27	100.0	3	5	2024-07-01 00:00:00	1
92	26	100.0	3	5	2024-07-01 00:00:00	1
93	24	1.0	1	1	2024-07-01 00:00:00	0
94	23	2.0	1	1	2024-07-01 00:00:00	0
95	26	1.0	1	1	2024-07-01 00:00:00	0
96	24	2.0	1	1	2024-07-01 00:00:00	0
97	27	1.0	1	1	2024-07-01 00:00:00	0
98	27	3.0	1	1	2024-07-01 00:00:00	0
99	24	1.0	1	1	2024-07-01 00:00:00	0
100	23	13.0	1	1	2024-07-01 00:00:00	0
101	27	9.0	1	1	2024-07-01 00:00:00	0
102	26	300.0	3	11	2024-07-01 00:00:00	1
103	23	2.0	1	1	2024-07-01 00:00:00	0
104	26	1.0	1	1	2024-07-01 00:00:00	0
105	24	1.0	1	1	2024-07-01 00:00:00	0
106	27	2.0	1	1	2024-07-01 00:00:00	0
107	18	200.0	3	11	2024-07-02 00:00:00	1
108	17	1.0	1	1	2024-07-02 00:00:00	0
109	17	1.0	1	1	2024-07-02 00:00:00	0
110	17	1.0	1	1	2024-07-02 00:00:00	0
111	17	1.0	1	1	2024-07-04 00:00:00	0
112	7	1.0	1	1	2024-07-04 00:00:00	0
113	3	1.0	1	1	2024-07-04 00:00:00	0
114	3	1.0	1	1	2024-07-04 00:00:00	0
115	4	2.0	1	1	2024-07-04 00:00:00	0
116	17	1.0	1	1	2024-07-04 00:00:00	0
117	3	1.0	1	1	2024-07-04 00:00:00	0
118	3	1.0	1	1	2024-07-04 00:00:00	0
119	4	2.0	1	1	2024-07-04 00:00:00	0
120	3	1.0	1	1	2024-07-17 00:00:00	0
121	30	1000.0	3	11	2024-07-17 00:00:00	1
122	31	500.0	3	11	2024-07-17 00:00:00	1
123	30	40.0	1	3	2024-07-17 00:00:00	0
124	30	40.0	2	3	2024-07-17 00:00:00	1
125	31	0.3	1	3	2024-07-17 00:00:00	0
126	31	0.3	2	3	2024-07-17 00:00:00	1
127	32	100.0	1	3	2024-07-17 00:00:00	1
128	30	40.0	2	3	2024-07-17 00:00:00	0
129	31	0.3	2	3	2024-07-17 00:00:00	0
130	32	40.0	1	4	2024-07-17 00:00:00	0
131	32	40.0	3	4	2024-07-17 00:00:00	1
132	32	30.0	1	3	2024-07-17 00:00:00	0
133	32	30.0	2	3	2024-07-17 00:00:00	1
134	33	2.0	1	3	2024-07-17 00:00:00	1
135	32	30.0	2	3	2024-07-17 00:00:00	0
136	33	1.0	1	1	2024-07-17 00:00:00	0
137	32	10.0	1	1	2024-07-17 00:00:00	0
138	3	1.0	1	1	2024-07-19 00:00:00	0
139	7	1.0	1	1	2024-07-19 00:00:00	0
140	34	10.0	3	5	2024-07-19 00:00:00	1
141	7	1.0	1	1	2024-07-19 00:00:00	0
142	35	100.0	1	12	2024-07-19 00:00:00	1
143	37	1.0	3	11	2024-07-22 00:00:00	1
144	37	1.0	3	11	2024-07-22 00:00:00	1
145	38	60.0	3	11	2024-07-25 00:00:00	1
146	38	12.0	3	1	2024-07-25 00:00:00	0
147	3	1.0	3	11	2024-08-07 00:00:00	1
148	1	1.0	3	2	2024-08-07 00:00:00	0
149	11	5.0	1	12	2024-08-07 00:00:00	1
150	8	1.0	1	1	2024-08-21 00:00:00	0
151	8	1.0	1	1	2024-08-21 00:00:00	0
152	4	1.0	1	1	2024-08-21 00:00:00	0
153	3	1.0	4	1	2024-08-21 00:00:00	0
154	9	1.0	1	1	2024-09-02 00:00:00	0
155	12	2.0	3	11	2024-09-03 00:00:00	1
156	17	10.0	3	11	2024-09-03 00:00:00	1
157	24	1.0	1	1	2024-09-03 00:00:00	0
158	35	1.0	1	1	2024-09-03 00:00:00	0
159	11	5.0	4	10	2024-09-04 00:00:00	1
160	11	5.0	4	10	2024-09-04 00:00:00	0
161	3	1.0	1	12	2024-09-17 00:00:00	1
162	4	10.0	1	12	2024-09-17 00:00:00	1
163	10	10.0	1	12	2024-09-17 00:00:00	1
164	1	1.0	1	1	2024-09-17 00:00:00	0
165	3	1.0	1	1	2024-09-17 00:00:00	0
166	94	10.0	3	5	2024-09-19 00:00:00	1
167	94	10.0	1	5	2024-09-19 00:00:00	1
168	18	1.0	1	1	2024-09-19 00:00:00	0
169	95	1.0	1	1	2024-09-24 00:00:00	0
170	96	10.0	1	5	2024-09-24 00:00:00	1
171	3	1.0	1	1	2024-09-24 00:00:00	0
172	4	1.0	1	1	2024-10-02 00:00:00	0
173	8	1.0	1	1	2024-10-02 00:00:00	0
174	3	10.0	1	11	2024-10-02 00:00:00	1
175	10	10.0	1	11	2024-10-02 00:00:00	1
176	1	1.0	1	1	2024-10-02 00:00:00	0
177	1	3.0	1	12	2024-10-04 00:00:00	1
178	4	4.0	1	12	2024-10-04 00:00:00	1
179	3	9.0	3	5	2024-10-04 00:00:00	0
180	3	8.0	3	5	2024-10-04 00:00:00	1
181	3	30.0	3	11	2024-10-04 00:00:00	1
182	4	50.0	3	11	2024-10-04 00:00:00	1
183	4	1.0	1	1	2024-10-06 00:00:00	0
184	4	1.0	1	8	2024-10-06 00:00:00	1
185	3	1.0	1	1	2024-10-06 00:00:00	0
186	8	1.0	1	1	2024-10-06 00:00:00	0
187	7	1.0	1	1	2024-10-06 00:00:00	0
188	4	1.0	1	1	2024-10-06 00:00:00	0
189	7	1.0	1	1	2024-10-06 00:00:00	0
190	12	1.0	1	1	2024-10-06 00:00:00	0
191	23	1.0	1	1	2024-10-09 00:00:00	0
192	1	199.0	3	5	2024-10-10 00:00:00	1
193	4	1.0	1	1	2024-10-14 00:00:00	0
194	3	1.0	1	1	2024-10-16 00:00:00	0
195	3	1.0	1	1	2024-10-16 00:00:00	0
196	4	1.0	1	1	2024-10-16 00:00:00	0
197	4	1.0	1	1	2024-10-16 00:00:00	0
198	4	1.0	1	1	2024-10-16 00:00:00	0
199	3	1.0	1	1	2024-10-16 00:00:00	0
200	12	1.0	1	1	2024-10-16 00:00:00	0
201	4	1.0	1	1	2024-10-16 00:00:00	0
202	3	1.0	1	1	2024-10-16 00:00:00	0
203	4	2.0	1	1	2024-10-16 00:00:00	0
204	3	1.0	1	1	2024-10-16 00:00:00	0
205	4	1.0	1	1	2024-10-16 00:00:00	0
206	3	1.0	1	1	2024-10-16 00:00:00	0
207	3	1.0	1	1	2024-10-16 00:00:00	0
208	94	5.0	3	11	2024-10-23 00:00:00	1
209	100	10.0	3	11	2024-10-23 00:00:00	1
210	100	2.0	3	2	2024-10-23 00:00:00	0
211	101	1.0	1	1	2024-10-23 00:00:00	0
212	100	3.0	3	4	2024-10-23 00:00:00	0
213	100	3.0	6	4	2024-10-23 00:00:00	1
214	12	100.0	3	11	2024-10-24 00:00:00	1
215	102	410.0	3	11	2024-10-24 00:00:00	1
216	102	1.0	3	1	2024-10-24 00:00:00	0
217	102	10.0	3	1	2024-10-24 00:00:00	0
218	102	30.0	1	1	2024-10-24 00:00:00	0
219	102	30.0	1	1	2024-10-24 00:00:00	0
220	30	7.0	1	1	2024-10-24 00:00:00	0
221	9	1.0	1	1	2024-10-27 00:00:00	0
222	12	1.0	1	1	2024-10-27 00:00:00	0
223	7	100.0	3	11	2024-11-01 00:00:00	1
224	106	1000.0	3	11	2024-11-04 00:00:00	1
225	3	1.0	3	11	2024-11-04 00:00:00	1
226	11	1.0	3	11	2024-11-04 00:00:00	1
227	4	12.0	1	11	2024-11-06 00:00:00	1
228	4	1.0	1	1	2024-11-07 00:00:00	0
229	1	1.0	1	1	2024-11-07 00:00:00	0
230	1	1.0	1	8	2024-11-07 00:00:00	1
231	1	1.0	1	1	2024-11-07 00:00:00	0
232	1	1.0	1	8	2024-11-07 00:00:00	1
233	3	1.0	1	1	2024-11-15 00:00:00	0
234	3	10.0	1	1	2024-11-15 00:00:00	0
235	3	5.0	1	1	2024-11-15 00:00:00	0
236	111	10.0	3	5	2024-11-18 00:00:00	1
237	111	20.0	1	5	2024-11-18 00:00:00	1
238	111	1.0	1	1	2024-11-18 00:00:00	0
239	114	1000.0	1	12	2024-11-22 00:00:00	1
240	115	1000.0	1	12	2024-11-22 00:00:00	1
241	117	2.0	1	1	2024-11-22 00:00:00	0
243	114	4.0	1	3	2024-11-22 00:00:00	0
244	114	4.0	3	3	2024-11-22 00:00:00	1
245	115	8.0	1	3	2024-11-22 00:00:00	0
246	115	8.0	3	3	2024-11-22 00:00:00	1
247	117	1.0	1	1	2024-11-22 00:00:00	0
248	114	40.0	1	3	2024-11-22 00:00:00	0
249	114	40.0	3	3	2024-11-22 00:00:00	1
250	115	80.0	1	3	2024-11-22 00:00:00	0
251	115	80.0	3	3	2024-11-22 00:00:00	1
253	119	2.0	3	5	2024-11-25 00:00:00	1
254	3	10.0	1	3	2024-11-27 00:00:00	0
255	3	10.0	3	3	2024-11-27 00:00:00	1
256	4	10.0	1	3	2024-11-27 00:00:00	0
257	4	10.0	3	3	2024-11-27 00:00:00	1
258	120	10.0	1	3	2024-11-27 00:00:00	1
259	3	10.0	3	3	2024-11-27 00:00:00	0
260	4	10.0	3	3	2024-11-27 00:00:00	0
261	3	1.0	1	1	2024-11-27 00:00:00	0
262	3	1.0	1	1	2024-11-27 00:00:00	1
263	3	1.0	1	1	2024-11-27 00:00:00	0
264	3	1.0	1	1	2024-11-27 00:00:00	1
265	3	1.0	1	1	2024-11-27 00:00:00	0
266	3	1.0	1	1	2024-11-27 00:00:00	0
267	3	1.0	1	1	2024-11-27 00:00:00	0
268	3	1.0	1	1	2024-11-27 00:00:00	0
269	4	1.0	1	1	2024-11-29 00:00:00	0
270	117	5.0	1	3	2024-11-30 00:00:00	1
271	114	4.0	3	3	2024-11-30 00:00:00	0
272	115	8.0	3	3	2024-11-30 00:00:00	0
273	9	1.0	1	1	2024-11-30 00:00:00	0
274	9	1.0	1	1	2024-11-30 00:00:00	0
275	122	3.0	3	11	2024-12-03 00:00:00	1
276	122	3.0	3	11	2024-12-03 00:00:00	1
277	4	1.0	1	1	2024-12-06 00:00:00	0
278	3	1.0	1	1	2024-12-11 00:00:00	0
279	7	1.0	1	1	2024-12-11 00:00:00	0
280	3	1.0	1	1	2024-12-11 00:00:00	0
281	4	1.0	1	1	2024-12-11 00:00:00	0
282	3	1.0	1	1	2024-12-11 00:00:00	0
283	10	1.0	1	1	2024-12-11 00:00:00	0
284	33	1.0	1	1	2024-12-11 00:00:00	0
285	114	1.0	1	1	2024-12-11 00:00:00	0
286	3	1.0	1	1	2025-01-04 00:00:00	0
287	35	1.0	1	1	2025-01-04 00:00:00	0
288	18	1.0	1	1	2025-01-04 00:00:00	0
289	35	1.0	1	1	2025-01-04 00:00:00	0
290	9	12.0	1	1	2025-01-06 00:00:00	0
291	3	1.0	1	1	2025-01-09 00:00:00	0
292	1	15.0	3	12	2025-01-16 00:00:00	1
293	126	20.0	1	12	2025-01-20 00:00:00	1
294	126	5.0	1	5	2025-01-20 00:00:00	0
295	126	1.0	1	1	2025-01-20 00:00:00	0
296	126	1.0	1	1	2025-01-20 00:00:00	0
297	126	1.0	1	1	2025-01-20 00:00:00	0
298	126	1.0	1	1	2025-01-20 00:00:00	0
299	18	1.0	1	1	2025-01-20 00:00:00	0
300	35	1.0	1	1	2025-01-20 00:00:00	0
301	3	1.0	1	1	2025-01-20 00:00:00	0
302	6	1.0	1	1	2025-01-20 00:00:00	0
303	16	1.0	1	1	2025-01-20 00:00:00	0
304	131	100.0	1	5	2025-01-21 00:00:00	1
305	7	99.0	3	5	2025-01-21 00:00:00	1
306	8	27.0	3	5	2025-01-21 00:00:00	1
307	10	20.0	3	5	2025-01-21 00:00:00	1
308	11	18.0	3	5	2025-01-21 00:00:00	1
309	114	4.0	1	3	2025-01-21 00:00:00	0
310	114	4.0	3	3	2025-01-21 00:00:00	1
311	115	8.0	1	3	2025-01-21 00:00:00	0
312	115	8.0	3	3	2025-01-21 00:00:00	1
313	134	1.0	1	1	2025-01-22 00:00:00	0
314	133	1.0	1	1	2025-01-22 00:00:00	0
315	133	1.0	1	1	2025-01-22 00:00:00	0
316	4	1.0	3	7	2025-01-25 00:00:00	0
317	4	1.0	3	6	2025-01-25 00:00:00	0
318	26	1.0	3	4	2025-01-25 00:00:00	0
319	26	1.0	4	4	2025-01-25 00:00:00	1
\.


--
-- Data for Name: tipo_movimientos; Type: TABLE DATA; Schema: almacenes; Owner: postgres
--

COPY almacenes.tipo_movimientos (id_tipo_movimientos, tipo, movimiento) FROM stdin;
1	FAC	VENTA
2	AUTOCONSUMO	AUTOCONSUMO
3	ENS	ENSAMBLADO
4	TRA	TRASLADO
5	AJU	AJUSTE DE INVENTARIO
6	RETIRO	RETIRO
7	OTRO	PERDIDA
10	REC	RECEPCIÓN
11	COM	COMPRA
12	CAR	CARGO
8	NC	NOTA DE CRÉDITO
13	COMPROMETIDO	COMPROMETIDO
\.


--
-- Data for Name: compras; Type: TABLE DATA; Schema: compras; Owner: postgres
--

COPY compras.compras (id_compras, id_proveedores, num_factura, id_tipo_facturas, num_control, fecha, id_ordenes_compras, tasa) FROM stdin;
1	1	12312313	1	12312323	2024-05-28	\N	35.0
2	2	12312311	1	12312323	2024-05-28	\N	37.0
3	3	020366	1	131316	2024-06-02	\N	36.8
4	2	12312	1	123123	2024-06-04	1	36.52
5	1	1231232	1	12312312	2024-06-05	\N	36.54
6	3	113123	1	1231233	2024-06-05	\N	36.54
7	1	123123	1	131312	2024-06-25	\N	36.37
8	2	C000019807	1	988777	2024-06-26	\N	36.35
9	3	22512	1	222561	2024-07-01	\N	36.46
10	4	12342134	1	23423423	2024-07-02	\N	4000.0
11	3	12342134	1	00-00515	2024-07-17	\N	36.53
12	4	151411	1	65151	2024-07-17	\N	36.53
13	5	4242452	1	4455235	2024-07-22	\N	36.61
14	5	234343	1	324234	2024-07-22	\N	36.61
15	5	212151	1	00-0551	2024-07-25	\N	42.0
16	1	1234	1	1234	2024-08-07	\N	36.6
17	3	1212	1	12122	2024-09-03	\N	36.63
18	1	65155	1	46416	2024-10-02	\N	36.95
19	4	2	1	1414324	2024-10-02	\N	0.0
20	2	3	1	1414324	2024-10-02	\N	36.92
21	1	C000018529	1	00181540	2024-10-04	\N	36.31
22	1	123456	3	123456	2024-10-04	\N	0.0
23	1	12444	4	123478	2024-10-04	\N	0.0
24	1	4234	1	3370	2024-10-04	\N	37.04
25	5	sdfsdfsd	1	sdfsdfsd	2024-10-23	\N	39.32
26	1	qweqwe	1	qweqw	2024-10-23	\N	39.32
27	8	212212	1	2121	2024-10-24	\N	50.0
28	1	24234234	1	01-000010	2024-10-24	\N	40.0
29	1	86728	1	1804802	2024-11-01	\N	42.56
30	1	323	1	123131	2024-11-04	\N	42.86
31	2	0909	1	0909	2024-11-04	\N	42.85
32	2	09098	1	8989	2024-11-04	\N	43.0
33	1	2121	1	123	2024-11-06	\N	42.86
34	1	xxxxx	1	xxxxxxxx	2024-12-03	\N	47.61
35	1	zzzzzzz	1	zzzzzzzzzzzz	2024-12-03	\N	47.61
36	1	123456789	1	000012	2024-12-03	\N	47.61
\.


--
-- Data for Name: det_compra; Type: TABLE DATA; Schema: compras; Owner: postgres
--

COPY compras.det_compra (id_det_compra, id_productos, costo, cantidad, descuento, id_compras, id_depositos, id_presentaciones) FROM stdin;
1	3	0.6	30.0	0.0	1	1	\N
2	3	0.6	10.0	0.0	2	1	\N
3	4	20.0	12.0	0.0	3	1	\N
4	3	0.6	300.0	0.0	4	1	\N
5	18	19.0	10.0	0.0	5	1	\N
6	18	21.16	10.0	0.0	6	3	\N
7	20	5.0	10.0	0.0	7	3	\N
8	1	0.2	1.0	0.0	8	3	\N
9	26	1.0	300.0	0.0	9	3	\N
10	18	10.0	200.0	0.0	10	3	\N
11	30	20.0	1000.0	0.0	11	3	2
12	31	25.0	500.0	0.0	12	3	3
13	37	20.0	1.0	0.0	13	3	\N
14	37	20.0	1.0	0.0	14	3	\N
15	38	19.0	60.0	0.0	15	3	4
16	3	0.6	1.0	0.0	16	3	\N
17	12	1.0	2.0	0.0	17	3	\N
18	17	5.0	10.0	0.0	17	3	\N
19	3	1.0	10.0	0.0	18	1	\N
20	10	2.0	10.0	0.0	18	1	\N
21	3	1.1	30.0	0.0	21	3	\N
22	4	20.0	50.0	0.0	21	3	\N
23	99	27.0	1.0	0.0	24	3	\N
24	94	10.0	5.0	0.0	25	3	\N
25	100	120.0	10.0	0.0	26	3	\N
26	12	1.2	100.0	0.0	27	3	\N
27	102	0.8	410.0	0.0	28	3	5
28	7	1.0	100.0	0.0	29	3	\N
29	106	1.0	1000.0	0.0	30	3	\N
30	3	1.1	1.0	0.0	31	3	\N
31	11	0.01	1.0	0.0	32	3	\N
32	4	20.0	12.0	0.0	33	1	\N
33	122	15.0	3.0	0.0	34	3	\N
34	122	15.0	3.0	0.0	35	3	\N
35	123	300.0	1.0	0.0	36	3	\N
\.


--
-- Data for Name: det_orden_compra; Type: TABLE DATA; Schema: compras; Owner: postgres
--

COPY compras.det_orden_compra (id_det_orden_compra, id_depositos, id_productos, descuento, costo, id_ordenes_compras, cantidad) FROM stdin;
1	1	3	0.0	0.6	1	300.0
2	3	14	0.0	5.0	2	10.0
3	3	11	0.0	0.01	2	5.0
5	4	11	0.0	0.01	3	5.0
6	3	1	0.0	0.05	4	10.0
\.


--
-- Data for Name: ordenes_compras; Type: TABLE DATA; Schema: compras; Owner: postgres
--

COPY compras.ordenes_compras (id_ordenes_compras, id_proveedores, fecha, tasa) FROM stdin;
1	2	2024-05-28	36.52
2	1	2024-05-28	36.51
3	3	2024-09-04	37.0
4	1	2024-12-03	47.6
\.


--
-- Data for Name: proveedores; Type: TABLE DATA; Schema: compras; Owner: postgres
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
-- Data for Name: tipo_proveedores; Type: TABLE DATA; Schema: compras; Owner: postgres
--

COPY compras.tipo_proveedores (id_tipo_proveedores, tipo) FROM stdin;
1	PROVEEDOR DE CAJAS
2	PROVEEDOR DE BOLSA
3	PROVEEDOR NACIONAL
4	ACEITES
\.


--
-- Data for Name: bancos; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.bancos (id_bancos, cuenta, id_tipo_bancos) FROM stdin;
\.


--
-- Data for Name: cajas; Type: TABLE DATA; Schema: finanzas; Owner: postgres
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
-- Data for Name: egreso_banco; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.egreso_banco (id_egresos, id_tipo_bancos, id_bancos, id_egreso_banco) FROM stdin;
\.


--
-- Data for Name: egreso_caja; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.egreso_caja (id_egresos, id_cajas, id_egreso_caja) FROM stdin;
\.


--
-- Data for Name: egresos; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.egresos (id_mov_egresos, monto, fecha, id_tipo_movimientos, id_monedas, id_metodo_pagos, id_medios, monto_dolar, id_egresos) FROM stdin;
\.


--
-- Data for Name: ingreso_banco; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.ingreso_banco (id_ingresos, id_tipo_bancos, id_bancos, id_ingreso_banco) FROM stdin;
\.


--
-- Data for Name: ingreso_caja; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.ingreso_caja (id_ingresos, id_cajas, id_ingreso_caja) FROM stdin;
\.


--
-- Data for Name: ingresos; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.ingresos (id_mov_ingresos, monto, fecha, id_tipo_movimientos, id_monedas, id_metodo_pagos, monto_dolar, id_medios, id_ingresos) FROM stdin;
\.


--
-- Data for Name: medios; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.medios (id_medios, medio) FROM stdin;
1	Banco
2	Caja
\.


--
-- Data for Name: metodo_pagos; Type: TABLE DATA; Schema: finanzas; Owner: postgres
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
-- Data for Name: monedas; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.monedas (id_monedas, simbolo, moneda, descripcion) FROM stdin;
1	Bs	Bs	Nacional
2	$	USD	Extranjera
3	Pts	Coins	Fidelidad
\.


--
-- Data for Name: tipo_bancos; Type: TABLE DATA; Schema: finanzas; Owner: postgres
--

COPY finanzas.tipo_bancos (id_tipo_bancos, tipo) FROM stdin;
\.


--
-- Data for Name: tipo_movimientos; Type: TABLE DATA; Schema: finanzas; Owner: postgres
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
-- Data for Name: etiqueta_indicador; Type: TABLE DATA; Schema: objetivos; Owner: postgres
--

COPY objetivos.etiqueta_indicador (id_etiquetas, id_indicadores) FROM stdin;
4	1
5	2
6	2
6	1
8	15
8	19
9	35
9	31
9	32
9	21
9	23
9	19
9	49
9	45
9	18
9	20
9	6
9	26
9	51
9	53
9	17
9	24
9	47
9	22
9	44
9	48
9	25
9	7
10	13
10	11
10	10
10	12
10	5
10	15
10	14
10	1
10	40
10	35
10	30
10	37
10	38
10	31
10	32
10	29
10	36
10	21
10	23
10	19
10	49
10	45
10	18
10	20
10	6
10	26
10	51
10	53
10	17
10	24
10	47
10	22
10	44
10	48
10	25
10	7
10	52
10	28
10	27
10	46
10	3
10	33
10	41
10	34
10	42
10	2
10	39
10	43
10	54
11	1
11	40
11	29
11	36
11	52
11	28
11	27
11	46
11	3
11	33
11	41
12	13
12	11
12	10
12	12
12	5
12	15
12	14
12	30
12	37
12	38
12	2
12	39
12	43
12	54
\.


--
-- Data for Name: etiquetas; Type: TABLE DATA; Schema: objetivos; Owner: postgres
--

COPY objetivos.etiquetas (id_etiquetas, etiqueta, visible) FROM stdin;
5	Mermas	t
6	Cotizaciones	t
4	Clientes	t
7	trasladospp	f
8	Seleccionnn	f
9	Almacenes	t
11	Compras	t
12	Ventas	t
10	Integral	t
\.


--
-- Data for Name: formulas; Type: TABLE DATA; Schema: objetivos; Owner: postgres
--

COPY objetivos.formulas (id_formulas, formula, titulo, visible, id_etiquetas) FROM stdin;
25	AVG\\left(ClientesVentas\\right)	Valor promedio de compra del cliente	t	4
31	\\frac{COUNT\\left(Clientesfinales\\right)+2\\cdot2}{2}\\cdot100	POp 22aa	t	8
32	10^{^2}	22r13eqf	t	6
22	\\frac{COUNT\\left(ClientesFinales\\right)-COUNT\\left(ClientesNuevos\\right)}{COUNT\\left(ClientesComienzo\\right)}\\cdot100	Retencion de clientes	t	4
2	\\frac{1}{2}SUM\\left(Compras\\right)	prueba 1/2 compras	t	4
4	\\frac{SUM\\left(Ventas\\right)}{SUM\\left(Compras\\right)}	compras y ventas	t	4
3	2*SUM\\left(Compras\\right)	2*compras	t	4
23	\\frac{COUNT\\left(ClientesFinales\\right)-COUNT\\left(ClientesNuevos\\right)}{COUNT\\left(ClientesComienzo\\right)}\\cdot100	Retencion de clientes pop	t	4
6	SUM\\left(Gastos\\right)	Gastos	f	4
7	SUM\\left(Ingresos\\right)	Ingresos	f	4
20	COUNT\\left(ClientesNuevos\\right)	Clientes nuevos	t	4
24	COUNT\\left(ClientesRecurrentes\\right)	Clientes recurrentes	t	4
30	COUNT\\left(ClientesFinales\\right)	sgsgrsgdf	f	6
12	SUM\\left(Ventas\\right)	Total de ventas	t	4
13	SUM\\left(Compras\\right)	Total de compras	t	4
14	COUNT\\left(Compras\\right)	Cantidad de compras	t	4
15	COUNT\\left(Ventas\\right)	Cantidad de ventas	t	4
16	AVG\\left(Ventas\\right)	Promedio de ventas	t	4
17	AVG\\left(Compras\\right)	Promedio de compras	t	4
18	COUNT\\left(ClientesFinales\\right)	Clientes finales	t	4
19	AVG\\left(ClientesVidaUtil\\right)	Vida util de clientes	t	4
21	COUNT\\left(ClientesComienzo\\right)	Clientes iniciales	t	4
8	SUM\\left(ProductosDevueltos\\right)	Productos devueltos	t	4
5	\\frac{SUM\\left(ProductosDevueltos\\right)}{SUM\\left(ProductosVendidos\\right)}	Tasa de devolucion	t	4
9	\\frac{SUM\\left(ProductosDevueltos\\right)}{SUM\\left(ProductosVendidos\\right)}	tasa devolucin 2	t	4
10	\\frac{SUM\\left(ProductosDevueltos\\right)}{SUM\\left(ProductosVendidos\\right)}	devueltosss	t	4
11	\\frac{SUM\\left(ProductosDevueltos\\right)}{SUM\\left(ProductosVendidos\\right)}	devueltosss	t	4
\.


--
-- Data for Name: iconos; Type: TABLE DATA; Schema: objetivos; Owner: postgres
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
-- Data for Name: indicadores; Type: TABLE DATA; Schema: objetivos; Owner: postgres
--

COPY objetivos.indicadores (id_indicadores, indicador, consulta, visible, descripcion, filtro) FROM stdin;
14	ClientesVidaUtil	SELECT \r\n    EXTRACT(EPOCH FROM vida_util) / 86400 AS value,\r\n\tid_personas as id,\r\n    fecha\r\nFROM (\r\n    SELECT \r\n        v.id_personas, \r\n        AGE(MAX(v.fecha), MIN(v.fecha)) AS vida_util,\r\n        MIN(v.fecha) as fecha\r\n    FROM \r\n        ventas.ventas v \r\n    GROUP BY \r\n        v.id_personas\r\n    HAVING \r\n        COUNT(*) > 1\r\n) AS TOTAL	t	Tiempo de vida de los clientes	3
15	ClientesVentas	SELECt\r\n\t\t         v.cantidad * v.precio as value,\r\n\t\t         v.id_personas as id,\r\n\t\t         v.fecha \r\n\t\t         \r\n\t\t    FROM\r\n\t\t        ventas.vw_ventas v\r\n\t\t     	t	Ventas por cliente	1
11	ClientesFinales	SELECt\r\n\t\t        v.id_personas as value,\r\n\t\t        v.id_personas as id,\r\n\t\t       fecha\r\n\t\t    FROM\r\n\t\t        ventas.ventas v	t	Clientes que aparecieron al final de un periodo	1
19	ProductosCargos	select vv.cantidad as value, vv.fecha, vv.id from almacenes.vw_almacenes vv where tipo_movimiento = 'CARGO'	t	Productos cargos (cantidad)	1
20	ProductosDescargos	select vv.cantidad as value, vv.fecha, vv.id from almacenes.vw_almacenes vv where tipo_movimiento = 'DESCARGO'	t	Productos descargos (cantidad)	1
21	ProductosAjustesInventario	select vv.cantidad as value, vv.fecha, vv.id from almacenes.vw_almacenes vv where tipo_movimiento = 'AJUSTE DE INVENTARIO'	t	Productos ajustes de inventario (cantidad)	1
22	ProductosRetiros	select vv.cantidad as value, vv.fecha, vv.id from almacenes.vw_almacenes vv where tipo_movimiento = 'RETIRO'	t	Productos retirados (cantidad)	1
29	OrdenesCompras	SELECT C.TOTAL AS VALUE, C.FECHA AS FECHA_INICIO, C.FECHA, C.ID  AS ID FROM COMPRAS.VW_ORDENES C	t	Ordenes de compras	1
23	ProductosAutoconsumos	select vv.cantidad as value, vv.fecha, vv.id from almacenes.vw_almacenes vv where tipo_movimiento = 'AUTOCONSUMO'	t	Productos de uso de autoconsumo (cantidad)	1
26	ProductosEnsamblados	select vv.cantidad as value, vv.fecha, vv.id from almacenes.vw_almacenes vv where tipo_movimiento = 'ENSAMBLADO'	t	Productos ensamblados (cantidad)	1
30	Cotizaciones	SELECT C.TOTAL AS VALUE, C.FECHA AS FECHA_INICIO, C.FECHA, C.ID  AS ID FROM VENTAS.VW_COTIZACIONES C	t	Cotizaciones	1
6	ProductosDevueltos	select vv.devuelto as value, vv.fecha, vv.id from ventas.vw_ventas vv	t	Productos devueltos por venta	1
7	ProductosVendidos	select vv.cantidad as value, vv.fecha, vv.id from ventas.vw_ventas vv	t	Productos vendidos (cantidad) por venta	1
2	Ventas	SELECT V.TOTAL AS VALUE, V.FECHA, V.ID AS ID FROM VENTAS.VW_VENTAS V	t	Ventas	1
1	Compras	SELECT C.TOTAL AS VALUE, C.FECHA AS FECHA_INICIO, C.FECHA, C.ID  AS ID FROM COMPRAS.VW_COMPRAS C	t	Compras	1
16	ProductosCompras	select vv.cantidad as value, vv.fecha, vv.id from compras.vw_compras vv	f	Productos comprados (cantidad) por venta	1
10	ClientesNuevos	SELECT \r\n    v.id_personas as value, \r\n    v.fecha,\r\n\tv.id_personas as id\r\nFROM \r\n    (SELECT \r\n         id_personas, \r\n         fecha,\r\n         ROW_NUMBER() OVER (PARTITION BY id_personas ORDER BY fecha ASC) AS rn\r\n     FROM ventas.ventas) v\r\nWHERE \r\n    v.rn = 1\r\nORDER BY \r\n    v.fecha ASC	t	Nuevos Clientes en un periodo	1
12	ClientesRecurrentes	SELECt\r\n\t\t        v.id_personas as value,\r\n\t\t        v.id_personas as id,\r\n\t\t       fecha\r\n\t\t    FROM\r\n\t\t        ventas.ventas v\r\n\t\t     where V.id_personas in (\r\n\t\t     \tselect id_personas from ventas.ventas v2 \r\n\t\t     \tgroup by id_personas \r\n\t\t     \thaving count(*) >1\r\n\t\t     )	t	Clientes que compraron mas de una vez en un periodo	1
28	ProveedoresFinales	SELECt\r\n\t\t        v.id_proveedores as value,\r\n\t\t        v.id_proveedores as id,\r\n\t\t       fecha\r\n\t\t    FROM\r\n\t\t        compras.compras v	t	Clientes que aparecieron al final de un periodo	1
24	ProductosRecepciones	select vv.cantidad as value, vv.fecha, vv.id from almacenes.vw_almacenes vv where tipo_movimiento = 'RECEPCION'	t	Productos recepcionados (cantidad)	1
25	ProductosTraslados	select vv.cantidad as value, vv.fecha, vv.id from almacenes.vw_almacenes vv where tipo_movimiento = 'TRASLADO'	t	Productos trasladados (cantidad)	1
17	ProductosOrdenesCompras	select vv.cantidad as value, vv.fecha, vv.id from compras.vw_ordenes vv	t	Productos ordenados para comprar (cantidad) por venta	1
18	ProductosCotizaciones	select vv.cantidad as value, vv.fecha, vv.id from ventas.vw_cotizaciones vv	t	Productos cotizados (cantidad)	1
32	InventarioFinales	WITH ultimas_compras AS (\r\n  SELECT \r\n    vc.id_productos,\r\n    vc.costo,\r\n    vc.fecha,\r\n    ROW_NUMBER() OVER (PARTITION BY vc.id_productos ORDER BY vc.fecha DESC) AS fila\r\n  FROM compras.vw_compras vc\r\n),\r\n\r\ncosto_promedio_reciente AS (\r\n  SELECT \r\n    id_productos,\r\n    AVG(costo) AS costo_promedio\r\n  FROM ultimas_compras\r\n  WHERE fila <= 3\r\n  GROUP BY id_productos\r\n)\r\n\r\nSELECT \r\n  m.id_movimientos AS id,\r\n  m.fecha,\r\n  CASE\r\n    WHEN m.entrada = 1 THEN round(m.cantidad * cp.costo_promedio,2)\r\n    ELSE round(-1 * m.cantidad * cp.costo_promedio, 2)\r\n  END AS value\r\nFROM almacenes.movimientos m\r\nJOIN costo_promedio_reciente cp ON cp.id_productos = m.id_productos\r\nORDER BY m.fecha	t	Valor monetario del inventario final	3
39	VentasClientes	select \r\nvv.cliente as id,\r\nsum(vv.total) as value,\r\nmin(vv.fecha) as fecha\r\nfrom ventas.vw_ventas vv \r\ngroup by vv.cliente\r\n	t	Ventas agrupadas por clientes	1
13	ClientesComienzo	SELECT id_personas as value, id_personas as id, MIN(fecha) AS fecha\r\n    FROM ventas.ventas \r\n    GROUP BY id_personas	t	Clientes iniciales para una fecha	2
5	ClientesTotales	SELECt\r\n\t\t        v.id_personas as value,\r\n\t\t        v.id_personas as id,\r\n\t\t       fecha\r\n\t\t    FROM\r\n\t\t        ventas.ventas v	t	Clientes totales de la fecha final de un periodo	3
31	InventarioComienzo	WITH ultimas_compras AS (\r\n  SELECT \r\n    vc.id_productos,\r\n    vc.costo,\r\n    vc.fecha,\r\n    ROW_NUMBER() OVER (PARTITION BY vc.id_productos ORDER BY vc.fecha DESC) AS fila\r\n  FROM compras.vw_compras vc\r\n),\r\n\r\ncosto_promedio_reciente AS (\r\n  SELECT \r\n    id_productos,\r\n    AVG(costo) AS costo_promedio\r\n  FROM ultimas_compras\r\n  WHERE fila <= 3\r\n  GROUP BY id_productos\r\n)\r\n\r\nSELECT \r\n  m.id_movimientos AS id,\r\n  m.fecha,\r\n  CASE\r\n    WHEN m.entrada = 1 THEN round(m.cantidad * cp.costo_promedio,2)\r\n    ELSE round(-1 * m.cantidad * cp.costo_promedio, 2)\r\n  END AS value\r\nFROM almacenes.movimientos m\r\nJOIN costo_promedio_reciente cp ON cp.id_productos = m.id_productos\r\nORDER BY m.fecha	t	Valor monetario del inventario inicial	2
3	ProveedoresTotales	SELECt\r\n\t\t        v.id_proveedores as value,\r\n\t\t        v.id_proveedores as id,\r\n\t\t       fecha\r\n\t\t    FROM\r\n\t\t        compras.compras v	t	Proveedores totales de la fecha final de un periodo	3
33	TiempoCicloCompras	select \r\nc.id_compras as id,\r\nc.fecha,\r\nextract(epoch from age(c.fecha, oc.fecha))/86400 as value\r\nfrom compras.compras c \r\ninner join compras.ordenes_compras oc on oc.id_ordenes_compras = c.id_ordenes_compras 	t	Tiempo en dias desde la orden de compra hasta la compra	1
34	TiempoCicloVentas	select \r\nv.id_ventas  as id,\r\nv.fecha,\r\nextract(epoch from age(v.fecha, c.fecha))/86400 as value\r\nfrom ventas.ventas v \r\ninner join ventas.cotizaciones c on c.id_cotizaciones = v.id_cotizaciones 	t	Tiempo en dias desde la cotizacion hasta la venta	1
40	ComprasProveedores	select \r\nvc.proveedor as id,\r\nsum(vc.total) as value,\r\nmin(vc.fecha) as fecha\r\nfrom compras.vw_compras vc \r\ngroup by vc.proveedor\r\n	t	Compras agrupadas por proveedores	1
35	CostosAlmacenamiento	select vc.id, vc.costo, vc.fecha from compras.vw_compras vc \r\nwhere vc.categoria = 'ALMACENAMIENTO' or vc.subcategoria = 'ALMACENAMIENTO'	t	Costos de almacenamiento	1
37	CotizacionesExitosas	select \r\nv.id_ventas  as id,\r\nv.fecha,\r\ndv.precio as value\r\nfrom ventas.det_venta dv \r\ninner join ventas.ventas v on dv.id_ventas = v.id_ventas \r\ninner join ventas.cotizaciones c on c.id_cotizaciones = v.id_cotizaciones 	t	Cotizaciones completadas en ventas	1
41	TiempoCicloComprasProveedores	select \r\np.id_proveedores as id,\r\nmin(c.fecha) as fecha,\r\nsum(extract(epoch from age(c.fecha, oc.fecha))/86400) as value\r\nfrom compras.compras c \r\ninner join compras.ordenes_compras oc on oc.id_ordenes_compras = c.id_ordenes_compras \r\ninner join compras.proveedores p on p.id_proveedores = c.id_proveedores\r\ngroup by p.id_proveedores\r\n	t	Tiempo de ciclo de compras por proveedores	1
38	Devoluciones	select \r\n\tvv.id,\r\n\tvv.fecha,\r\n\tvv.devuelto * vv.precio as value\r\nfrom ventas.vw_ventas vv \r\n	t	Valor monetario de las devoluciones	1
36	OrdenesComprasExitosas	select \r\nc.id_compras  as id,\r\nc.fecha,\r\ndc.costo as value\r\nfrom compras.det_compra dc \r\ninner join compras.compras c on dc.id_compras = c.id_compras \r\ninner join compras.ordenes_compras oc on c.id_ordenes_compras = oc.id_ordenes_compras 	t	Ordenes completadas en compras	1
27	ProveedoresNuevos	SELECT \r\n    v.id_personas as value, \r\n    v.fecha,\r\n\tv.id_personas as id\r\nFROM \r\n    (SELECT \r\n         id_proveedores as id_personas, \r\n         fecha,\r\n         ROW_NUMBER() OVER (PARTITION BY id_personas ORDER BY fecha ASC) AS rn\r\n     FROM compras.compras) v\r\nWHERE \r\n    v.rn = 1\r\nORDER BY \r\n    v.fecha ASC	t	Nuevos proveedores en un periodo	1
42	TiempoFrecuenciaClientes	WITH compras_ordenadas AS (\r\n  SELECT \r\n    vv.id_personas as id,\r\n    vv.fecha,\r\n    LAG(vv.fecha) OVER (PARTITION BY vv.id_personas ORDER BY vv.fecha) AS fecha_anterior\r\n  FROM ventas.ventas vv \r\n),\r\nintervalos AS (\r\n  SELECT \r\n    id,\r\n    fecha,\r\n    fecha_anterior,\r\n    EXTRACT(DAY FROM fecha - fecha_anterior) AS dias_entre_compras\r\n  FROM compras_ordenadas\r\n  WHERE fecha_anterior IS NOT NULL\r\n)\r\nSELECT \r\n  id,\r\n  ROUND(AVG(dias_entre_compras), 2) AS value,\r\n  MIN(fecha) as fecha\r\nFROM intervalos\r\nGROUP BY id\r\n	t	Tiempo de frecuencia de compra de clientes	1
43	VentasCostoDiario	WITH ultimas_compras AS (\r\n  SELECT \r\n    vc.id_productos,\r\n    vc.costo,\r\n    vc.fecha,\r\n    ROW_NUMBER() OVER (PARTITION BY vc.id_productos ORDER BY vc.fecha DESC) AS fila\r\n  FROM compras.vw_compras vc\r\n),\r\n\r\ncosto_promedio_reciente AS (\r\n  SELECT \r\n    id_productos,\r\n    AVG(costo) AS costo_promedio\r\n  FROM ultimas_compras\r\n  WHERE fila <= 3\r\n  GROUP BY id_productos\r\n)\r\n  \r\nSELECT \r\nround(sum(cp.costo_promedio*cantidad),2) AS VALUE, \r\nV.FECHA, \r\nV.fecha AS ID \r\nFROM VENTAS.VW_VENTAS V \r\ninner join costo_promedio_reciente cp on cp.id_productos = v.id_productos\r\ngroup by v.fecha\r\n	t	Costo diario de las ventas	1
45	ProductosConStock	select id_productos as id, fecha, stock as value from (SELECT \r\n    p.id_productos,\r\n    COALESCE(SUM(CASE \r\n      WHEN m.entrada = 1 THEN m.cantidad \r\n      ELSE -m.cantidad \r\n    END), 0) AS stock,\r\n    min(m.fecha) as fecha\r\n  FROM productos.productos p\r\n  LEFT JOIN almacenes.movimientos m ON m.id_productos = p.id_productos\r\n  GROUP BY p.id_productos) as tabla\r\n  where stock > 0\r\n	t	Productos con stock	3
44	ProductosSinStock	SELECT \r\n  id_productos AS id,\r\n  fecha,\r\n  stock AS value\r\nFROM (\r\n  SELECT \r\n    p.id_productos,\r\n    COALESCE(SUM(CASE \r\n      WHEN m.entrada = 1 THEN m.cantidad \r\n      ELSE -m.cantidad \r\n    END), 0) AS stock,\r\n    COALESCE(MIN(m.fecha), DATE '2000-01-01') AS fecha\r\n  FROM productos.productos p\r\n  LEFT JOIN almacenes.movimientos m \r\n    ON m.id_productos = p.id_productos\r\n  GROUP BY p.id_productos\r\n) AS tabla\r\nWHERE stock <= 0\r\n	t	Productos sin stock 	3
46	ProveedoresRecurrentes	SELECt\r\n\t\t        v.id_proveedores as value,\r\n\t\t        v.id_proveedores as id,\r\n\t\t       fecha\r\n\t\t    FROM\r\n\t\t        compras.compras v\r\n\t\t     where V.id_proveedores in (\r\n\t\t     \tselect id_proveedores from compras.compras v2 \r\n\t\t     \tgroup by id_proveedores \r\n\t\t     \thaving count(*) >1\r\n\t\t     )\r\n	t	\N	1
47	ProductosRecurrentes	SELECt\r\n\t\t        v.id_productos as value,\r\n\t\t        v.id_productos as id,\r\n\t\t       fecha\r\n\t\t    FROM\r\n\t\t        almacenes.movimientos v\r\n\t\t     where V.id_productos in (\r\n\t\t     \tselect id_productos from almacenes.movimientos v2 \r\n\t\t     \tgroup by id_productos\r\n\t\t     \thaving count(*) >1\r\n\t\t     )\r\n	t	\N	1
48	ProductosTotales	SELECt\r\n\t\t        v.id_productos as value,\r\n\t\t        v.id_productos as id,\r\n\t\t       fecha\r\n\t\t    FROM\r\n\t\t        almacenes.movimientos v\r\n	t	\N	1
49	ProductosComienzo	 SELECT m.id_productos as value, m.id_productos as id, MIN(m.fecha) AS fecha\r\n    FROM almacenes.movimientos m \r\n    group by m.id_productos \r\n	t	\N	1
51	ProductosFinales	SELECt\r\n\t\t        v.id_productos as value,\r\n\t\t        v.id_productos as id,\r\n\t\t       fecha\r\n\t\t    FROM\r\n\t\t        almacenes.movimientos v\r\n	t	\N	1
52	ProveedoresComienzo	SELECT c.id_proveedores as value, c.id_proveedores as id, MIN(fecha) AS fecha\r\n    FROM compras.compras c \r\n    GROUP BY c.id_proveedores \r\n	t	\N	1
53	ProductosNuevos	 SELECT \r\n    v.id_personas as value, \r\n    v.fecha,\r\n\tv.id_personas as id\r\nFROM \r\n    (SELECT \r\n         id_productos as id_personas, \r\n         fecha,\r\n         ROW_NUMBER() OVER (PARTITION BY id_productos ORDER BY fecha ASC) AS rn\r\n     FROM almacenes.movimientos) v\r\nWHERE \r\n    v.rn = 1\r\nORDER BY \r\n    v.fecha asc\r\n	t	\N	1
54	VentasDiario	    SELECT \r\nround(sum(v.total),2) AS VALUE, \r\nV.FECHA, \r\nV.fecha AS ID \r\nFROM VENTAS.VW_VENTAS V\r\ngroup by v.fecha\r\n	t	\N	1
\.


--
-- Data for Name: objetivos; Type: TABLE DATA; Schema: objetivos; Owner: postgres
--

COPY objetivos.objetivos (id_objetivos, titulo, optimo, tolerable, deficiente, fecha_inicio, fecha_final, id_formulas) FROM stdin;
6	Compras	22220	200	51	2023-02-17 00:00:00	2025-02-17 00:00:00	2
29	Retencion de clientes popbb	200	100	21	2021-03-10 00:00:00	2025-03-20 00:00:00	2
12	string	2500	0	0	2024-12-01 00:00:00	2025-03-02 00:00:00	20
35	vida util nn	2222	222	111	2023-01-01 00:00:00	2023-12-31 00:00:00	20
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
32	afaeeaf	222	22	1	2025-03-21 00:00:00	2025-03-27 04:00:00	23
38	mhhmf	200	100	50	2025-04-30 00:00:00	2025-05-24 00:00:00	24
\.


--
-- Data for Name: perspectiva_etiqueta; Type: TABLE DATA; Schema: objetivos; Owner: postgres
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
12	6
7	7
8	7
11	8
8	9
11	11
7	12
17	10
\.


--
-- Data for Name: perspectivas; Type: TABLE DATA; Schema: objetivos; Owner: postgres
--

COPY objetivos.perspectivas (perspectiva, id_iconos, visible, id_perspectivas) FROM stdin;
Compras	283	t	11
Ventas	285	t	7
Almacenes	284	t	8
Integral	2	f	17
Aprendizaje y crecimientp	1	f	4
Procesos internos	\N	f	3
Clientes	\N	f	2
Finanzas	10	f	1
Compraspp	3	f	12
\.


--
-- Data for Name: categorias; Type: TABLE DATA; Schema: productos; Owner: postgres
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
-- Data for Name: detalle_productos; Type: TABLE DATA; Schema: productos; Owner: postgres
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
-- Data for Name: marcas; Type: TABLE DATA; Schema: productos; Owner: postgres
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
-- Data for Name: presentaciones; Type: TABLE DATA; Schema: productos; Owner: postgres
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
-- Data for Name: productos; Type: TABLE DATA; Schema: productos; Owner: postgres
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
-- Data for Name: subcategorias; Type: TABLE DATA; Schema: productos; Owner: postgres
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
-- Data for Name: tipo_productos; Type: TABLE DATA; Schema: productos; Owner: postgres
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
-- Data for Name: unidades; Type: TABLE DATA; Schema: productos; Owner: postgres
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
-- Data for Name: ciudades; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- Data for Name: estados; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- Data for Name: fechas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fechas (fecha, dia, dia_semana, nombre_dia, semana_anio, semana_mes, quincena, mes, nombre_mes, trimestre, semestre, anio, es_fin_de_semana) FROM stdin;
2015-01-01	1	4	Jueves	1	1	1	1	Enero	1	1	2015	f
2015-01-02	2	5	Viernes	1	1	1	1	Enero	1	1	2015	f
2015-01-03	3	6	Sábado	1	1	1	1	Enero	1	1	2015	t
2015-01-04	4	7	Domingo	1	1	1	1	Enero	1	1	2015	t
2015-01-05	5	1	Lunes	2	2	1	1	Enero	1	1	2015	f
2015-01-06	6	2	Martes	2	2	1	1	Enero	1	1	2015	f
2015-01-07	7	3	Miércoles	2	2	1	1	Enero	1	1	2015	f
2015-01-08	8	4	Jueves	2	2	1	1	Enero	1	1	2015	f
2015-01-09	9	5	Viernes	2	2	1	1	Enero	1	1	2015	f
2015-01-10	10	6	Sábado	2	2	1	1	Enero	1	1	2015	t
2015-01-11	11	7	Domingo	2	2	1	1	Enero	1	1	2015	t
2015-01-12	12	1	Lunes	3	3	1	1	Enero	1	1	2015	f
2015-01-13	13	2	Martes	3	3	1	1	Enero	1	1	2015	f
2015-01-14	14	3	Miércoles	3	3	1	1	Enero	1	1	2015	f
2015-01-15	15	4	Jueves	3	3	1	1	Enero	1	1	2015	f
2015-01-16	16	5	Viernes	3	3	2	1	Enero	1	1	2015	f
2015-01-17	17	6	Sábado	3	3	2	1	Enero	1	1	2015	t
2015-01-18	18	7	Domingo	3	3	2	1	Enero	1	1	2015	t
2015-01-19	19	1	Lunes	4	4	2	1	Enero	1	1	2015	f
2015-01-20	20	2	Martes	4	4	2	1	Enero	1	1	2015	f
2015-01-21	21	3	Miércoles	4	4	2	1	Enero	1	1	2015	f
2015-01-22	22	4	Jueves	4	4	2	1	Enero	1	1	2015	f
2015-01-23	23	5	Viernes	4	4	2	1	Enero	1	1	2015	f
2015-01-24	24	6	Sábado	4	4	2	1	Enero	1	1	2015	t
2015-01-25	25	7	Domingo	4	4	2	1	Enero	1	1	2015	t
2015-01-26	26	1	Lunes	5	5	2	1	Enero	1	1	2015	f
2015-01-27	27	2	Martes	5	5	2	1	Enero	1	1	2015	f
2015-01-28	28	3	Miércoles	5	5	2	1	Enero	1	1	2015	f
2015-01-29	29	4	Jueves	5	5	2	1	Enero	1	1	2015	f
2015-01-30	30	5	Viernes	5	5	2	1	Enero	1	1	2015	f
2015-01-31	31	6	Sábado	5	5	2	1	Enero	1	1	2015	t
2015-02-01	1	7	Domingo	5	1	1	2	Febrero	1	1	2015	t
2015-02-02	2	1	Lunes	6	2	1	2	Febrero	1	1	2015	f
2015-02-03	3	2	Martes	6	2	1	2	Febrero	1	1	2015	f
2015-02-04	4	3	Miércoles	6	2	1	2	Febrero	1	1	2015	f
2015-02-05	5	4	Jueves	6	2	1	2	Febrero	1	1	2015	f
2015-02-06	6	5	Viernes	6	2	1	2	Febrero	1	1	2015	f
2015-02-07	7	6	Sábado	6	2	1	2	Febrero	1	1	2015	t
2015-02-08	8	7	Domingo	6	2	1	2	Febrero	1	1	2015	t
2015-02-09	9	1	Lunes	7	3	1	2	Febrero	1	1	2015	f
2015-02-10	10	2	Martes	7	3	1	2	Febrero	1	1	2015	f
2015-02-11	11	3	Miércoles	7	3	1	2	Febrero	1	1	2015	f
2015-02-12	12	4	Jueves	7	3	1	2	Febrero	1	1	2015	f
2015-02-13	13	5	Viernes	7	3	1	2	Febrero	1	1	2015	f
2015-02-14	14	6	Sábado	7	3	1	2	Febrero	1	1	2015	t
2015-02-15	15	7	Domingo	7	3	1	2	Febrero	1	1	2015	t
2015-02-16	16	1	Lunes	8	4	2	2	Febrero	1	1	2015	f
2015-02-17	17	2	Martes	8	4	2	2	Febrero	1	1	2015	f
2015-02-18	18	3	Miércoles	8	4	2	2	Febrero	1	1	2015	f
2015-02-19	19	4	Jueves	8	4	2	2	Febrero	1	1	2015	f
2015-02-20	20	5	Viernes	8	4	2	2	Febrero	1	1	2015	f
2015-02-21	21	6	Sábado	8	4	2	2	Febrero	1	1	2015	t
2015-02-22	22	7	Domingo	8	4	2	2	Febrero	1	1	2015	t
2015-02-23	23	1	Lunes	9	5	2	2	Febrero	1	1	2015	f
2015-02-24	24	2	Martes	9	5	2	2	Febrero	1	1	2015	f
2015-02-25	25	3	Miércoles	9	5	2	2	Febrero	1	1	2015	f
2015-02-26	26	4	Jueves	9	5	2	2	Febrero	1	1	2015	f
2015-02-27	27	5	Viernes	9	5	2	2	Febrero	1	1	2015	f
2015-02-28	28	6	Sábado	9	5	2	2	Febrero	1	1	2015	t
2015-03-01	1	7	Domingo	9	1	1	3	Marzo	1	1	2015	t
2015-03-02	2	1	Lunes	10	2	1	3	Marzo	1	1	2015	f
2015-03-03	3	2	Martes	10	2	1	3	Marzo	1	1	2015	f
2015-03-04	4	3	Miércoles	10	2	1	3	Marzo	1	1	2015	f
2015-03-05	5	4	Jueves	10	2	1	3	Marzo	1	1	2015	f
2015-03-06	6	5	Viernes	10	2	1	3	Marzo	1	1	2015	f
2015-03-07	7	6	Sábado	10	2	1	3	Marzo	1	1	2015	t
2015-03-08	8	7	Domingo	10	2	1	3	Marzo	1	1	2015	t
2015-03-09	9	1	Lunes	11	3	1	3	Marzo	1	1	2015	f
2015-03-10	10	2	Martes	11	3	1	3	Marzo	1	1	2015	f
2015-03-11	11	3	Miércoles	11	3	1	3	Marzo	1	1	2015	f
2015-03-12	12	4	Jueves	11	3	1	3	Marzo	1	1	2015	f
2015-03-13	13	5	Viernes	11	3	1	3	Marzo	1	1	2015	f
2015-03-14	14	6	Sábado	11	3	1	3	Marzo	1	1	2015	t
2015-03-15	15	7	Domingo	11	3	1	3	Marzo	1	1	2015	t
2015-03-16	16	1	Lunes	12	4	2	3	Marzo	1	1	2015	f
2015-03-17	17	2	Martes	12	4	2	3	Marzo	1	1	2015	f
2015-03-18	18	3	Miércoles	12	4	2	3	Marzo	1	1	2015	f
2015-03-19	19	4	Jueves	12	4	2	3	Marzo	1	1	2015	f
2015-03-20	20	5	Viernes	12	4	2	3	Marzo	1	1	2015	f
2015-03-21	21	6	Sábado	12	4	2	3	Marzo	1	1	2015	t
2015-03-22	22	7	Domingo	12	4	2	3	Marzo	1	1	2015	t
2015-03-23	23	1	Lunes	13	5	2	3	Marzo	1	1	2015	f
2015-03-24	24	2	Martes	13	5	2	3	Marzo	1	1	2015	f
2015-03-25	25	3	Miércoles	13	5	2	3	Marzo	1	1	2015	f
2015-03-26	26	4	Jueves	13	5	2	3	Marzo	1	1	2015	f
2015-03-27	27	5	Viernes	13	5	2	3	Marzo	1	1	2015	f
2015-03-28	28	6	Sábado	13	5	2	3	Marzo	1	1	2015	t
2015-03-29	29	7	Domingo	13	5	2	3	Marzo	1	1	2015	t
2015-03-30	30	1	Lunes	14	6	2	3	Marzo	1	1	2015	f
2015-03-31	31	2	Martes	14	6	2	3	Marzo	1	1	2015	f
2015-04-01	1	3	Miércoles	14	1	1	4	Abril	2	1	2015	f
2015-04-02	2	4	Jueves	14	1	1	4	Abril	2	1	2015	f
2015-04-03	3	5	Viernes	14	1	1	4	Abril	2	1	2015	f
2015-04-04	4	6	Sábado	14	1	1	4	Abril	2	1	2015	t
2015-04-05	5	7	Domingo	14	1	1	4	Abril	2	1	2015	t
2015-04-06	6	1	Lunes	15	2	1	4	Abril	2	1	2015	f
2015-04-07	7	2	Martes	15	2	1	4	Abril	2	1	2015	f
2015-04-08	8	3	Miércoles	15	2	1	4	Abril	2	1	2015	f
2015-04-09	9	4	Jueves	15	2	1	4	Abril	2	1	2015	f
2015-04-10	10	5	Viernes	15	2	1	4	Abril	2	1	2015	f
2015-04-11	11	6	Sábado	15	2	1	4	Abril	2	1	2015	t
2015-04-12	12	7	Domingo	15	2	1	4	Abril	2	1	2015	t
2015-04-13	13	1	Lunes	16	3	1	4	Abril	2	1	2015	f
2015-04-14	14	2	Martes	16	3	1	4	Abril	2	1	2015	f
2015-04-15	15	3	Miércoles	16	3	1	4	Abril	2	1	2015	f
2015-04-16	16	4	Jueves	16	3	2	4	Abril	2	1	2015	f
2015-04-17	17	5	Viernes	16	3	2	4	Abril	2	1	2015	f
2015-04-18	18	6	Sábado	16	3	2	4	Abril	2	1	2015	t
2015-04-19	19	7	Domingo	16	3	2	4	Abril	2	1	2015	t
2015-04-20	20	1	Lunes	17	4	2	4	Abril	2	1	2015	f
2015-04-21	21	2	Martes	17	4	2	4	Abril	2	1	2015	f
2015-04-22	22	3	Miércoles	17	4	2	4	Abril	2	1	2015	f
2015-04-23	23	4	Jueves	17	4	2	4	Abril	2	1	2015	f
2015-04-24	24	5	Viernes	17	4	2	4	Abril	2	1	2015	f
2015-04-25	25	6	Sábado	17	4	2	4	Abril	2	1	2015	t
2015-04-26	26	7	Domingo	17	4	2	4	Abril	2	1	2015	t
2015-04-27	27	1	Lunes	18	5	2	4	Abril	2	1	2015	f
2015-04-28	28	2	Martes	18	5	2	4	Abril	2	1	2015	f
2015-04-29	29	3	Miércoles	18	5	2	4	Abril	2	1	2015	f
2015-04-30	30	4	Jueves	18	5	2	4	Abril	2	1	2015	f
2015-05-01	1	5	Viernes	18	1	1	5	Mayo	2	1	2015	f
2015-05-02	2	6	Sábado	18	1	1	5	Mayo	2	1	2015	t
2015-05-03	3	7	Domingo	18	1	1	5	Mayo	2	1	2015	t
2015-05-04	4	1	Lunes	19	2	1	5	Mayo	2	1	2015	f
2015-05-05	5	2	Martes	19	2	1	5	Mayo	2	1	2015	f
2015-05-06	6	3	Miércoles	19	2	1	5	Mayo	2	1	2015	f
2015-05-07	7	4	Jueves	19	2	1	5	Mayo	2	1	2015	f
2015-05-08	8	5	Viernes	19	2	1	5	Mayo	2	1	2015	f
2015-05-09	9	6	Sábado	19	2	1	5	Mayo	2	1	2015	t
2015-05-10	10	7	Domingo	19	2	1	5	Mayo	2	1	2015	t
2015-05-11	11	1	Lunes	20	3	1	5	Mayo	2	1	2015	f
2015-05-12	12	2	Martes	20	3	1	5	Mayo	2	1	2015	f
2015-05-13	13	3	Miércoles	20	3	1	5	Mayo	2	1	2015	f
2015-05-14	14	4	Jueves	20	3	1	5	Mayo	2	1	2015	f
2015-05-15	15	5	Viernes	20	3	1	5	Mayo	2	1	2015	f
2015-05-16	16	6	Sábado	20	3	2	5	Mayo	2	1	2015	t
2015-05-17	17	7	Domingo	20	3	2	5	Mayo	2	1	2015	t
2015-05-18	18	1	Lunes	21	4	2	5	Mayo	2	1	2015	f
2015-05-19	19	2	Martes	21	4	2	5	Mayo	2	1	2015	f
2015-05-20	20	3	Miércoles	21	4	2	5	Mayo	2	1	2015	f
2015-05-21	21	4	Jueves	21	4	2	5	Mayo	2	1	2015	f
2015-05-22	22	5	Viernes	21	4	2	5	Mayo	2	1	2015	f
2015-05-23	23	6	Sábado	21	4	2	5	Mayo	2	1	2015	t
2015-05-24	24	7	Domingo	21	4	2	5	Mayo	2	1	2015	t
2015-05-25	25	1	Lunes	22	5	2	5	Mayo	2	1	2015	f
2015-05-26	26	2	Martes	22	5	2	5	Mayo	2	1	2015	f
2015-05-27	27	3	Miércoles	22	5	2	5	Mayo	2	1	2015	f
2015-05-28	28	4	Jueves	22	5	2	5	Mayo	2	1	2015	f
2015-05-29	29	5	Viernes	22	5	2	5	Mayo	2	1	2015	f
2015-05-30	30	6	Sábado	22	5	2	5	Mayo	2	1	2015	t
2015-05-31	31	7	Domingo	22	5	2	5	Mayo	2	1	2015	t
2015-06-01	1	1	Lunes	23	1	1	6	Junio	2	1	2015	f
2015-06-02	2	2	Martes	23	1	1	6	Junio	2	1	2015	f
2015-06-03	3	3	Miércoles	23	1	1	6	Junio	2	1	2015	f
2015-06-04	4	4	Jueves	23	1	1	6	Junio	2	1	2015	f
2015-06-05	5	5	Viernes	23	1	1	6	Junio	2	1	2015	f
2015-06-06	6	6	Sábado	23	1	1	6	Junio	2	1	2015	t
2015-06-07	7	7	Domingo	23	1	1	6	Junio	2	1	2015	t
2015-06-08	8	1	Lunes	24	2	1	6	Junio	2	1	2015	f
2015-06-09	9	2	Martes	24	2	1	6	Junio	2	1	2015	f
2015-06-10	10	3	Miércoles	24	2	1	6	Junio	2	1	2015	f
2015-06-11	11	4	Jueves	24	2	1	6	Junio	2	1	2015	f
2015-06-12	12	5	Viernes	24	2	1	6	Junio	2	1	2015	f
2015-06-13	13	6	Sábado	24	2	1	6	Junio	2	1	2015	t
2015-06-14	14	7	Domingo	24	2	1	6	Junio	2	1	2015	t
2015-06-15	15	1	Lunes	25	3	1	6	Junio	2	1	2015	f
2015-06-16	16	2	Martes	25	3	2	6	Junio	2	1	2015	f
2015-06-17	17	3	Miércoles	25	3	2	6	Junio	2	1	2015	f
2015-06-18	18	4	Jueves	25	3	2	6	Junio	2	1	2015	f
2015-06-19	19	5	Viernes	25	3	2	6	Junio	2	1	2015	f
2015-06-20	20	6	Sábado	25	3	2	6	Junio	2	1	2015	t
2015-06-21	21	7	Domingo	25	3	2	6	Junio	2	1	2015	t
2015-06-22	22	1	Lunes	26	4	2	6	Junio	2	1	2015	f
2015-06-23	23	2	Martes	26	4	2	6	Junio	2	1	2015	f
2015-06-24	24	3	Miércoles	26	4	2	6	Junio	2	1	2015	f
2015-06-25	25	4	Jueves	26	4	2	6	Junio	2	1	2015	f
2015-06-26	26	5	Viernes	26	4	2	6	Junio	2	1	2015	f
2015-06-27	27	6	Sábado	26	4	2	6	Junio	2	1	2015	t
2015-06-28	28	7	Domingo	26	4	2	6	Junio	2	1	2015	t
2015-06-29	29	1	Lunes	27	5	2	6	Junio	2	1	2015	f
2015-06-30	30	2	Martes	27	5	2	6	Junio	2	1	2015	f
2015-07-01	1	3	Miércoles	27	1	1	7	Julio	3	2	2015	f
2015-07-02	2	4	Jueves	27	1	1	7	Julio	3	2	2015	f
2015-07-03	3	5	Viernes	27	1	1	7	Julio	3	2	2015	f
2015-07-04	4	6	Sábado	27	1	1	7	Julio	3	2	2015	t
2015-07-05	5	7	Domingo	27	1	1	7	Julio	3	2	2015	t
2015-07-06	6	1	Lunes	28	2	1	7	Julio	3	2	2015	f
2015-07-07	7	2	Martes	28	2	1	7	Julio	3	2	2015	f
2015-07-08	8	3	Miércoles	28	2	1	7	Julio	3	2	2015	f
2015-07-09	9	4	Jueves	28	2	1	7	Julio	3	2	2015	f
2015-07-10	10	5	Viernes	28	2	1	7	Julio	3	2	2015	f
2015-07-11	11	6	Sábado	28	2	1	7	Julio	3	2	2015	t
2015-07-12	12	7	Domingo	28	2	1	7	Julio	3	2	2015	t
2015-07-13	13	1	Lunes	29	3	1	7	Julio	3	2	2015	f
2015-07-14	14	2	Martes	29	3	1	7	Julio	3	2	2015	f
2015-07-15	15	3	Miércoles	29	3	1	7	Julio	3	2	2015	f
2015-07-16	16	4	Jueves	29	3	2	7	Julio	3	2	2015	f
2015-07-17	17	5	Viernes	29	3	2	7	Julio	3	2	2015	f
2015-07-18	18	6	Sábado	29	3	2	7	Julio	3	2	2015	t
2015-07-19	19	7	Domingo	29	3	2	7	Julio	3	2	2015	t
2015-07-20	20	1	Lunes	30	4	2	7	Julio	3	2	2015	f
2015-07-21	21	2	Martes	30	4	2	7	Julio	3	2	2015	f
2015-07-22	22	3	Miércoles	30	4	2	7	Julio	3	2	2015	f
2015-07-23	23	4	Jueves	30	4	2	7	Julio	3	2	2015	f
2015-07-24	24	5	Viernes	30	4	2	7	Julio	3	2	2015	f
2015-07-25	25	6	Sábado	30	4	2	7	Julio	3	2	2015	t
2015-07-26	26	7	Domingo	30	4	2	7	Julio	3	2	2015	t
2015-07-27	27	1	Lunes	31	5	2	7	Julio	3	2	2015	f
2015-07-28	28	2	Martes	31	5	2	7	Julio	3	2	2015	f
2015-07-29	29	3	Miércoles	31	5	2	7	Julio	3	2	2015	f
2015-07-30	30	4	Jueves	31	5	2	7	Julio	3	2	2015	f
2015-07-31	31	5	Viernes	31	5	2	7	Julio	3	2	2015	f
2015-08-01	1	6	Sábado	31	1	1	8	Agosto	3	2	2015	t
2015-08-02	2	7	Domingo	31	1	1	8	Agosto	3	2	2015	t
2015-08-03	3	1	Lunes	32	2	1	8	Agosto	3	2	2015	f
2015-08-04	4	2	Martes	32	2	1	8	Agosto	3	2	2015	f
2015-08-05	5	3	Miércoles	32	2	1	8	Agosto	3	2	2015	f
2015-08-06	6	4	Jueves	32	2	1	8	Agosto	3	2	2015	f
2015-08-07	7	5	Viernes	32	2	1	8	Agosto	3	2	2015	f
2015-08-08	8	6	Sábado	32	2	1	8	Agosto	3	2	2015	t
2015-08-09	9	7	Domingo	32	2	1	8	Agosto	3	2	2015	t
2015-08-10	10	1	Lunes	33	3	1	8	Agosto	3	2	2015	f
2015-08-11	11	2	Martes	33	3	1	8	Agosto	3	2	2015	f
2015-08-12	12	3	Miércoles	33	3	1	8	Agosto	3	2	2015	f
2015-08-13	13	4	Jueves	33	3	1	8	Agosto	3	2	2015	f
2015-08-14	14	5	Viernes	33	3	1	8	Agosto	3	2	2015	f
2015-08-15	15	6	Sábado	33	3	1	8	Agosto	3	2	2015	t
2015-08-16	16	7	Domingo	33	3	2	8	Agosto	3	2	2015	t
2015-08-17	17	1	Lunes	34	4	2	8	Agosto	3	2	2015	f
2015-08-18	18	2	Martes	34	4	2	8	Agosto	3	2	2015	f
2015-08-19	19	3	Miércoles	34	4	2	8	Agosto	3	2	2015	f
2015-08-20	20	4	Jueves	34	4	2	8	Agosto	3	2	2015	f
2015-08-21	21	5	Viernes	34	4	2	8	Agosto	3	2	2015	f
2015-08-22	22	6	Sábado	34	4	2	8	Agosto	3	2	2015	t
2015-08-23	23	7	Domingo	34	4	2	8	Agosto	3	2	2015	t
2015-08-24	24	1	Lunes	35	5	2	8	Agosto	3	2	2015	f
2015-08-25	25	2	Martes	35	5	2	8	Agosto	3	2	2015	f
2015-08-26	26	3	Miércoles	35	5	2	8	Agosto	3	2	2015	f
2015-08-27	27	4	Jueves	35	5	2	8	Agosto	3	2	2015	f
2015-08-28	28	5	Viernes	35	5	2	8	Agosto	3	2	2015	f
2015-08-29	29	6	Sábado	35	5	2	8	Agosto	3	2	2015	t
2015-08-30	30	7	Domingo	35	5	2	8	Agosto	3	2	2015	t
2015-08-31	31	1	Lunes	36	6	2	8	Agosto	3	2	2015	f
2015-09-01	1	2	Martes	36	1	1	9	Septiembre	3	2	2015	f
2015-09-02	2	3	Miércoles	36	1	1	9	Septiembre	3	2	2015	f
2015-09-03	3	4	Jueves	36	1	1	9	Septiembre	3	2	2015	f
2015-09-04	4	5	Viernes	36	1	1	9	Septiembre	3	2	2015	f
2015-09-05	5	6	Sábado	36	1	1	9	Septiembre	3	2	2015	t
2015-09-06	6	7	Domingo	36	1	1	9	Septiembre	3	2	2015	t
2015-09-07	7	1	Lunes	37	2	1	9	Septiembre	3	2	2015	f
2015-09-08	8	2	Martes	37	2	1	9	Septiembre	3	2	2015	f
2015-09-09	9	3	Miércoles	37	2	1	9	Septiembre	3	2	2015	f
2015-09-10	10	4	Jueves	37	2	1	9	Septiembre	3	2	2015	f
2015-09-11	11	5	Viernes	37	2	1	9	Septiembre	3	2	2015	f
2015-09-12	12	6	Sábado	37	2	1	9	Septiembre	3	2	2015	t
2015-09-13	13	7	Domingo	37	2	1	9	Septiembre	3	2	2015	t
2015-09-14	14	1	Lunes	38	3	1	9	Septiembre	3	2	2015	f
2015-09-15	15	2	Martes	38	3	1	9	Septiembre	3	2	2015	f
2015-09-16	16	3	Miércoles	38	3	2	9	Septiembre	3	2	2015	f
2015-09-17	17	4	Jueves	38	3	2	9	Septiembre	3	2	2015	f
2015-09-18	18	5	Viernes	38	3	2	9	Septiembre	3	2	2015	f
2015-09-19	19	6	Sábado	38	3	2	9	Septiembre	3	2	2015	t
2015-09-20	20	7	Domingo	38	3	2	9	Septiembre	3	2	2015	t
2015-09-21	21	1	Lunes	39	4	2	9	Septiembre	3	2	2015	f
2015-09-22	22	2	Martes	39	4	2	9	Septiembre	3	2	2015	f
2015-09-23	23	3	Miércoles	39	4	2	9	Septiembre	3	2	2015	f
2015-09-24	24	4	Jueves	39	4	2	9	Septiembre	3	2	2015	f
2015-09-25	25	5	Viernes	39	4	2	9	Septiembre	3	2	2015	f
2015-09-26	26	6	Sábado	39	4	2	9	Septiembre	3	2	2015	t
2015-09-27	27	7	Domingo	39	4	2	9	Septiembre	3	2	2015	t
2015-09-28	28	1	Lunes	40	5	2	9	Septiembre	3	2	2015	f
2015-09-29	29	2	Martes	40	5	2	9	Septiembre	3	2	2015	f
2015-09-30	30	3	Miércoles	40	5	2	9	Septiembre	3	2	2015	f
2015-10-01	1	4	Jueves	40	1	1	10	Octubre	4	2	2015	f
2015-10-02	2	5	Viernes	40	1	1	10	Octubre	4	2	2015	f
2015-10-03	3	6	Sábado	40	1	1	10	Octubre	4	2	2015	t
2015-10-04	4	7	Domingo	40	1	1	10	Octubre	4	2	2015	t
2015-10-05	5	1	Lunes	41	2	1	10	Octubre	4	2	2015	f
2015-10-06	6	2	Martes	41	2	1	10	Octubre	4	2	2015	f
2015-10-07	7	3	Miércoles	41	2	1	10	Octubre	4	2	2015	f
2015-10-08	8	4	Jueves	41	2	1	10	Octubre	4	2	2015	f
2015-10-09	9	5	Viernes	41	2	1	10	Octubre	4	2	2015	f
2015-10-10	10	6	Sábado	41	2	1	10	Octubre	4	2	2015	t
2015-10-11	11	7	Domingo	41	2	1	10	Octubre	4	2	2015	t
2015-10-12	12	1	Lunes	42	3	1	10	Octubre	4	2	2015	f
2015-10-13	13	2	Martes	42	3	1	10	Octubre	4	2	2015	f
2015-10-14	14	3	Miércoles	42	3	1	10	Octubre	4	2	2015	f
2015-10-15	15	4	Jueves	42	3	1	10	Octubre	4	2	2015	f
2015-10-16	16	5	Viernes	42	3	2	10	Octubre	4	2	2015	f
2015-10-17	17	6	Sábado	42	3	2	10	Octubre	4	2	2015	t
2015-10-18	18	7	Domingo	42	3	2	10	Octubre	4	2	2015	t
2015-10-19	19	1	Lunes	43	4	2	10	Octubre	4	2	2015	f
2015-10-20	20	2	Martes	43	4	2	10	Octubre	4	2	2015	f
2015-10-21	21	3	Miércoles	43	4	2	10	Octubre	4	2	2015	f
2015-10-22	22	4	Jueves	43	4	2	10	Octubre	4	2	2015	f
2015-10-23	23	5	Viernes	43	4	2	10	Octubre	4	2	2015	f
2015-10-24	24	6	Sábado	43	4	2	10	Octubre	4	2	2015	t
2015-10-25	25	7	Domingo	43	4	2	10	Octubre	4	2	2015	t
2015-10-26	26	1	Lunes	44	5	2	10	Octubre	4	2	2015	f
2015-10-27	27	2	Martes	44	5	2	10	Octubre	4	2	2015	f
2015-10-28	28	3	Miércoles	44	5	2	10	Octubre	4	2	2015	f
2015-10-29	29	4	Jueves	44	5	2	10	Octubre	4	2	2015	f
2015-10-30	30	5	Viernes	44	5	2	10	Octubre	4	2	2015	f
2015-10-31	31	6	Sábado	44	5	2	10	Octubre	4	2	2015	t
2015-11-01	1	7	Domingo	44	1	1	11	Noviembre	4	2	2015	t
2015-11-02	2	1	Lunes	45	2	1	11	Noviembre	4	2	2015	f
2015-11-03	3	2	Martes	45	2	1	11	Noviembre	4	2	2015	f
2015-11-04	4	3	Miércoles	45	2	1	11	Noviembre	4	2	2015	f
2015-11-05	5	4	Jueves	45	2	1	11	Noviembre	4	2	2015	f
2015-11-06	6	5	Viernes	45	2	1	11	Noviembre	4	2	2015	f
2015-11-07	7	6	Sábado	45	2	1	11	Noviembre	4	2	2015	t
2015-11-08	8	7	Domingo	45	2	1	11	Noviembre	4	2	2015	t
2015-11-09	9	1	Lunes	46	3	1	11	Noviembre	4	2	2015	f
2015-11-10	10	2	Martes	46	3	1	11	Noviembre	4	2	2015	f
2015-11-11	11	3	Miércoles	46	3	1	11	Noviembre	4	2	2015	f
2015-11-12	12	4	Jueves	46	3	1	11	Noviembre	4	2	2015	f
2015-11-13	13	5	Viernes	46	3	1	11	Noviembre	4	2	2015	f
2015-11-14	14	6	Sábado	46	3	1	11	Noviembre	4	2	2015	t
2015-11-15	15	7	Domingo	46	3	1	11	Noviembre	4	2	2015	t
2015-11-16	16	1	Lunes	47	4	2	11	Noviembre	4	2	2015	f
2015-11-17	17	2	Martes	47	4	2	11	Noviembre	4	2	2015	f
2015-11-18	18	3	Miércoles	47	4	2	11	Noviembre	4	2	2015	f
2015-11-19	19	4	Jueves	47	4	2	11	Noviembre	4	2	2015	f
2015-11-20	20	5	Viernes	47	4	2	11	Noviembre	4	2	2015	f
2015-11-21	21	6	Sábado	47	4	2	11	Noviembre	4	2	2015	t
2015-11-22	22	7	Domingo	47	4	2	11	Noviembre	4	2	2015	t
2015-11-23	23	1	Lunes	48	5	2	11	Noviembre	4	2	2015	f
2015-11-24	24	2	Martes	48	5	2	11	Noviembre	4	2	2015	f
2015-11-25	25	3	Miércoles	48	5	2	11	Noviembre	4	2	2015	f
2015-11-26	26	4	Jueves	48	5	2	11	Noviembre	4	2	2015	f
2015-11-27	27	5	Viernes	48	5	2	11	Noviembre	4	2	2015	f
2015-11-28	28	6	Sábado	48	5	2	11	Noviembre	4	2	2015	t
2015-11-29	29	7	Domingo	48	5	2	11	Noviembre	4	2	2015	t
2015-11-30	30	1	Lunes	49	6	2	11	Noviembre	4	2	2015	f
2015-12-01	1	2	Martes	49	1	1	12	Diciembre	4	2	2015	f
2015-12-02	2	3	Miércoles	49	1	1	12	Diciembre	4	2	2015	f
2015-12-03	3	4	Jueves	49	1	1	12	Diciembre	4	2	2015	f
2015-12-04	4	5	Viernes	49	1	1	12	Diciembre	4	2	2015	f
2015-12-05	5	6	Sábado	49	1	1	12	Diciembre	4	2	2015	t
2015-12-06	6	7	Domingo	49	1	1	12	Diciembre	4	2	2015	t
2015-12-07	7	1	Lunes	50	2	1	12	Diciembre	4	2	2015	f
2015-12-08	8	2	Martes	50	2	1	12	Diciembre	4	2	2015	f
2015-12-09	9	3	Miércoles	50	2	1	12	Diciembre	4	2	2015	f
2015-12-10	10	4	Jueves	50	2	1	12	Diciembre	4	2	2015	f
2015-12-11	11	5	Viernes	50	2	1	12	Diciembre	4	2	2015	f
2015-12-12	12	6	Sábado	50	2	1	12	Diciembre	4	2	2015	t
2015-12-13	13	7	Domingo	50	2	1	12	Diciembre	4	2	2015	t
2015-12-14	14	1	Lunes	51	3	1	12	Diciembre	4	2	2015	f
2015-12-15	15	2	Martes	51	3	1	12	Diciembre	4	2	2015	f
2015-12-16	16	3	Miércoles	51	3	2	12	Diciembre	4	2	2015	f
2015-12-17	17	4	Jueves	51	3	2	12	Diciembre	4	2	2015	f
2015-12-18	18	5	Viernes	51	3	2	12	Diciembre	4	2	2015	f
2015-12-19	19	6	Sábado	51	3	2	12	Diciembre	4	2	2015	t
2015-12-20	20	7	Domingo	51	3	2	12	Diciembre	4	2	2015	t
2015-12-21	21	1	Lunes	52	4	2	12	Diciembre	4	2	2015	f
2015-12-22	22	2	Martes	52	4	2	12	Diciembre	4	2	2015	f
2015-12-23	23	3	Miércoles	52	4	2	12	Diciembre	4	2	2015	f
2015-12-24	24	4	Jueves	52	4	2	12	Diciembre	4	2	2015	f
2015-12-25	25	5	Viernes	52	4	2	12	Diciembre	4	2	2015	f
2015-12-26	26	6	Sábado	52	4	2	12	Diciembre	4	2	2015	t
2015-12-27	27	7	Domingo	52	4	2	12	Diciembre	4	2	2015	t
2015-12-28	28	1	Lunes	53	5	2	12	Diciembre	4	2	2015	f
2015-12-29	29	2	Martes	53	5	2	12	Diciembre	4	2	2015	f
2015-12-30	30	3	Miércoles	53	5	2	12	Diciembre	4	2	2015	f
2015-12-31	31	4	Jueves	53	5	2	12	Diciembre	4	2	2015	f
2016-01-01	1	5	Viernes	53	1	1	1	Enero	1	1	2016	f
2016-01-02	2	6	Sábado	53	1	1	1	Enero	1	1	2016	t
2016-01-03	3	7	Domingo	53	1	1	1	Enero	1	1	2016	t
2016-01-04	4	1	Lunes	1	2	1	1	Enero	1	1	2016	f
2016-01-05	5	2	Martes	1	2	1	1	Enero	1	1	2016	f
2016-01-06	6	3	Miércoles	1	2	1	1	Enero	1	1	2016	f
2016-01-07	7	4	Jueves	1	2	1	1	Enero	1	1	2016	f
2016-01-08	8	5	Viernes	1	2	1	1	Enero	1	1	2016	f
2016-01-09	9	6	Sábado	1	2	1	1	Enero	1	1	2016	t
2016-01-10	10	7	Domingo	1	2	1	1	Enero	1	1	2016	t
2016-01-11	11	1	Lunes	2	3	1	1	Enero	1	1	2016	f
2016-01-12	12	2	Martes	2	3	1	1	Enero	1	1	2016	f
2016-01-13	13	3	Miércoles	2	3	1	1	Enero	1	1	2016	f
2016-01-14	14	4	Jueves	2	3	1	1	Enero	1	1	2016	f
2016-01-15	15	5	Viernes	2	3	1	1	Enero	1	1	2016	f
2016-01-16	16	6	Sábado	2	3	2	1	Enero	1	1	2016	t
2016-01-17	17	7	Domingo	2	3	2	1	Enero	1	1	2016	t
2016-01-18	18	1	Lunes	3	4	2	1	Enero	1	1	2016	f
2016-01-19	19	2	Martes	3	4	2	1	Enero	1	1	2016	f
2016-01-20	20	3	Miércoles	3	4	2	1	Enero	1	1	2016	f
2016-01-21	21	4	Jueves	3	4	2	1	Enero	1	1	2016	f
2016-01-22	22	5	Viernes	3	4	2	1	Enero	1	1	2016	f
2016-01-23	23	6	Sábado	3	4	2	1	Enero	1	1	2016	t
2016-01-24	24	7	Domingo	3	4	2	1	Enero	1	1	2016	t
2016-01-25	25	1	Lunes	4	5	2	1	Enero	1	1	2016	f
2016-01-26	26	2	Martes	4	5	2	1	Enero	1	1	2016	f
2016-01-27	27	3	Miércoles	4	5	2	1	Enero	1	1	2016	f
2016-01-28	28	4	Jueves	4	5	2	1	Enero	1	1	2016	f
2016-01-29	29	5	Viernes	4	5	2	1	Enero	1	1	2016	f
2016-01-30	30	6	Sábado	4	5	2	1	Enero	1	1	2016	t
2016-01-31	31	7	Domingo	4	5	2	1	Enero	1	1	2016	t
2016-02-01	1	1	Lunes	5	1	1	2	Febrero	1	1	2016	f
2016-02-02	2	2	Martes	5	1	1	2	Febrero	1	1	2016	f
2016-02-03	3	3	Miércoles	5	1	1	2	Febrero	1	1	2016	f
2016-02-04	4	4	Jueves	5	1	1	2	Febrero	1	1	2016	f
2016-02-05	5	5	Viernes	5	1	1	2	Febrero	1	1	2016	f
2016-02-06	6	6	Sábado	5	1	1	2	Febrero	1	1	2016	t
2016-02-07	7	7	Domingo	5	1	1	2	Febrero	1	1	2016	t
2016-02-08	8	1	Lunes	6	2	1	2	Febrero	1	1	2016	f
2016-02-09	9	2	Martes	6	2	1	2	Febrero	1	1	2016	f
2016-02-10	10	3	Miércoles	6	2	1	2	Febrero	1	1	2016	f
2016-02-11	11	4	Jueves	6	2	1	2	Febrero	1	1	2016	f
2016-02-12	12	5	Viernes	6	2	1	2	Febrero	1	1	2016	f
2016-02-13	13	6	Sábado	6	2	1	2	Febrero	1	1	2016	t
2016-02-14	14	7	Domingo	6	2	1	2	Febrero	1	1	2016	t
2016-02-15	15	1	Lunes	7	3	1	2	Febrero	1	1	2016	f
2016-02-16	16	2	Martes	7	3	2	2	Febrero	1	1	2016	f
2016-02-17	17	3	Miércoles	7	3	2	2	Febrero	1	1	2016	f
2016-02-18	18	4	Jueves	7	3	2	2	Febrero	1	1	2016	f
2016-02-19	19	5	Viernes	7	3	2	2	Febrero	1	1	2016	f
2016-02-20	20	6	Sábado	7	3	2	2	Febrero	1	1	2016	t
2016-02-21	21	7	Domingo	7	3	2	2	Febrero	1	1	2016	t
2016-02-22	22	1	Lunes	8	4	2	2	Febrero	1	1	2016	f
2016-02-23	23	2	Martes	8	4	2	2	Febrero	1	1	2016	f
2016-02-24	24	3	Miércoles	8	4	2	2	Febrero	1	1	2016	f
2016-02-25	25	4	Jueves	8	4	2	2	Febrero	1	1	2016	f
2016-02-26	26	5	Viernes	8	4	2	2	Febrero	1	1	2016	f
2016-02-27	27	6	Sábado	8	4	2	2	Febrero	1	1	2016	t
2016-02-28	28	7	Domingo	8	4	2	2	Febrero	1	1	2016	t
2016-02-29	29	1	Lunes	9	5	2	2	Febrero	1	1	2016	f
2016-03-01	1	2	Martes	9	1	1	3	Marzo	1	1	2016	f
2016-03-02	2	3	Miércoles	9	1	1	3	Marzo	1	1	2016	f
2016-03-03	3	4	Jueves	9	1	1	3	Marzo	1	1	2016	f
2016-03-04	4	5	Viernes	9	1	1	3	Marzo	1	1	2016	f
2016-03-05	5	6	Sábado	9	1	1	3	Marzo	1	1	2016	t
2016-03-06	6	7	Domingo	9	1	1	3	Marzo	1	1	2016	t
2016-03-07	7	1	Lunes	10	2	1	3	Marzo	1	1	2016	f
2016-03-08	8	2	Martes	10	2	1	3	Marzo	1	1	2016	f
2016-03-09	9	3	Miércoles	10	2	1	3	Marzo	1	1	2016	f
2016-03-10	10	4	Jueves	10	2	1	3	Marzo	1	1	2016	f
2016-03-11	11	5	Viernes	10	2	1	3	Marzo	1	1	2016	f
2016-03-12	12	6	Sábado	10	2	1	3	Marzo	1	1	2016	t
2016-03-13	13	7	Domingo	10	2	1	3	Marzo	1	1	2016	t
2016-03-14	14	1	Lunes	11	3	1	3	Marzo	1	1	2016	f
2016-03-15	15	2	Martes	11	3	1	3	Marzo	1	1	2016	f
2016-03-16	16	3	Miércoles	11	3	2	3	Marzo	1	1	2016	f
2016-03-17	17	4	Jueves	11	3	2	3	Marzo	1	1	2016	f
2016-03-18	18	5	Viernes	11	3	2	3	Marzo	1	1	2016	f
2016-03-19	19	6	Sábado	11	3	2	3	Marzo	1	1	2016	t
2016-03-20	20	7	Domingo	11	3	2	3	Marzo	1	1	2016	t
2016-03-21	21	1	Lunes	12	4	2	3	Marzo	1	1	2016	f
2016-03-22	22	2	Martes	12	4	2	3	Marzo	1	1	2016	f
2016-03-23	23	3	Miércoles	12	4	2	3	Marzo	1	1	2016	f
2016-03-24	24	4	Jueves	12	4	2	3	Marzo	1	1	2016	f
2016-03-25	25	5	Viernes	12	4	2	3	Marzo	1	1	2016	f
2016-03-26	26	6	Sábado	12	4	2	3	Marzo	1	1	2016	t
2016-03-27	27	7	Domingo	12	4	2	3	Marzo	1	1	2016	t
2016-03-28	28	1	Lunes	13	5	2	3	Marzo	1	1	2016	f
2016-03-29	29	2	Martes	13	5	2	3	Marzo	1	1	2016	f
2016-03-30	30	3	Miércoles	13	5	2	3	Marzo	1	1	2016	f
2016-03-31	31	4	Jueves	13	5	2	3	Marzo	1	1	2016	f
2016-04-01	1	5	Viernes	13	1	1	4	Abril	2	1	2016	f
2016-04-02	2	6	Sábado	13	1	1	4	Abril	2	1	2016	t
2016-04-03	3	7	Domingo	13	1	1	4	Abril	2	1	2016	t
2016-04-04	4	1	Lunes	14	2	1	4	Abril	2	1	2016	f
2016-04-05	5	2	Martes	14	2	1	4	Abril	2	1	2016	f
2016-04-06	6	3	Miércoles	14	2	1	4	Abril	2	1	2016	f
2016-04-07	7	4	Jueves	14	2	1	4	Abril	2	1	2016	f
2016-04-08	8	5	Viernes	14	2	1	4	Abril	2	1	2016	f
2016-04-09	9	6	Sábado	14	2	1	4	Abril	2	1	2016	t
2016-04-10	10	7	Domingo	14	2	1	4	Abril	2	1	2016	t
2016-04-11	11	1	Lunes	15	3	1	4	Abril	2	1	2016	f
2016-04-12	12	2	Martes	15	3	1	4	Abril	2	1	2016	f
2016-04-13	13	3	Miércoles	15	3	1	4	Abril	2	1	2016	f
2016-04-14	14	4	Jueves	15	3	1	4	Abril	2	1	2016	f
2016-04-15	15	5	Viernes	15	3	1	4	Abril	2	1	2016	f
2016-04-16	16	6	Sábado	15	3	2	4	Abril	2	1	2016	t
2016-04-17	17	7	Domingo	15	3	2	4	Abril	2	1	2016	t
2016-04-18	18	1	Lunes	16	4	2	4	Abril	2	1	2016	f
2016-04-19	19	2	Martes	16	4	2	4	Abril	2	1	2016	f
2016-04-20	20	3	Miércoles	16	4	2	4	Abril	2	1	2016	f
2016-04-21	21	4	Jueves	16	4	2	4	Abril	2	1	2016	f
2016-04-22	22	5	Viernes	16	4	2	4	Abril	2	1	2016	f
2016-04-23	23	6	Sábado	16	4	2	4	Abril	2	1	2016	t
2016-04-24	24	7	Domingo	16	4	2	4	Abril	2	1	2016	t
2016-04-25	25	1	Lunes	17	5	2	4	Abril	2	1	2016	f
2016-04-26	26	2	Martes	17	5	2	4	Abril	2	1	2016	f
2016-04-27	27	3	Miércoles	17	5	2	4	Abril	2	1	2016	f
2016-04-28	28	4	Jueves	17	5	2	4	Abril	2	1	2016	f
2016-04-29	29	5	Viernes	17	5	2	4	Abril	2	1	2016	f
2016-04-30	30	6	Sábado	17	5	2	4	Abril	2	1	2016	t
2016-05-01	1	7	Domingo	17	1	1	5	Mayo	2	1	2016	t
2016-05-02	2	1	Lunes	18	2	1	5	Mayo	2	1	2016	f
2016-05-03	3	2	Martes	18	2	1	5	Mayo	2	1	2016	f
2016-05-04	4	3	Miércoles	18	2	1	5	Mayo	2	1	2016	f
2016-05-05	5	4	Jueves	18	2	1	5	Mayo	2	1	2016	f
2016-05-06	6	5	Viernes	18	2	1	5	Mayo	2	1	2016	f
2016-05-07	7	6	Sábado	18	2	1	5	Mayo	2	1	2016	t
2016-05-08	8	7	Domingo	18	2	1	5	Mayo	2	1	2016	t
2016-05-09	9	1	Lunes	19	3	1	5	Mayo	2	1	2016	f
2016-05-10	10	2	Martes	19	3	1	5	Mayo	2	1	2016	f
2016-05-11	11	3	Miércoles	19	3	1	5	Mayo	2	1	2016	f
2016-05-12	12	4	Jueves	19	3	1	5	Mayo	2	1	2016	f
2016-05-13	13	5	Viernes	19	3	1	5	Mayo	2	1	2016	f
2016-05-14	14	6	Sábado	19	3	1	5	Mayo	2	1	2016	t
2016-05-15	15	7	Domingo	19	3	1	5	Mayo	2	1	2016	t
2016-05-16	16	1	Lunes	20	4	2	5	Mayo	2	1	2016	f
2016-05-17	17	2	Martes	20	4	2	5	Mayo	2	1	2016	f
2016-05-18	18	3	Miércoles	20	4	2	5	Mayo	2	1	2016	f
2016-05-19	19	4	Jueves	20	4	2	5	Mayo	2	1	2016	f
2016-05-20	20	5	Viernes	20	4	2	5	Mayo	2	1	2016	f
2016-05-21	21	6	Sábado	20	4	2	5	Mayo	2	1	2016	t
2016-05-22	22	7	Domingo	20	4	2	5	Mayo	2	1	2016	t
2016-05-23	23	1	Lunes	21	5	2	5	Mayo	2	1	2016	f
2016-05-24	24	2	Martes	21	5	2	5	Mayo	2	1	2016	f
2016-05-25	25	3	Miércoles	21	5	2	5	Mayo	2	1	2016	f
2016-05-26	26	4	Jueves	21	5	2	5	Mayo	2	1	2016	f
2016-05-27	27	5	Viernes	21	5	2	5	Mayo	2	1	2016	f
2016-05-28	28	6	Sábado	21	5	2	5	Mayo	2	1	2016	t
2016-05-29	29	7	Domingo	21	5	2	5	Mayo	2	1	2016	t
2016-05-30	30	1	Lunes	22	6	2	5	Mayo	2	1	2016	f
2016-05-31	31	2	Martes	22	6	2	5	Mayo	2	1	2016	f
2016-06-01	1	3	Miércoles	22	1	1	6	Junio	2	1	2016	f
2016-06-02	2	4	Jueves	22	1	1	6	Junio	2	1	2016	f
2016-06-03	3	5	Viernes	22	1	1	6	Junio	2	1	2016	f
2016-06-04	4	6	Sábado	22	1	1	6	Junio	2	1	2016	t
2016-06-05	5	7	Domingo	22	1	1	6	Junio	2	1	2016	t
2016-06-06	6	1	Lunes	23	2	1	6	Junio	2	1	2016	f
2016-06-07	7	2	Martes	23	2	1	6	Junio	2	1	2016	f
2016-06-08	8	3	Miércoles	23	2	1	6	Junio	2	1	2016	f
2016-06-09	9	4	Jueves	23	2	1	6	Junio	2	1	2016	f
2016-06-10	10	5	Viernes	23	2	1	6	Junio	2	1	2016	f
2016-06-11	11	6	Sábado	23	2	1	6	Junio	2	1	2016	t
2016-06-12	12	7	Domingo	23	2	1	6	Junio	2	1	2016	t
2016-06-13	13	1	Lunes	24	3	1	6	Junio	2	1	2016	f
2016-06-14	14	2	Martes	24	3	1	6	Junio	2	1	2016	f
2016-06-15	15	3	Miércoles	24	3	1	6	Junio	2	1	2016	f
2016-06-16	16	4	Jueves	24	3	2	6	Junio	2	1	2016	f
2016-06-17	17	5	Viernes	24	3	2	6	Junio	2	1	2016	f
2016-06-18	18	6	Sábado	24	3	2	6	Junio	2	1	2016	t
2016-06-19	19	7	Domingo	24	3	2	6	Junio	2	1	2016	t
2016-06-20	20	1	Lunes	25	4	2	6	Junio	2	1	2016	f
2016-06-21	21	2	Martes	25	4	2	6	Junio	2	1	2016	f
2016-06-22	22	3	Miércoles	25	4	2	6	Junio	2	1	2016	f
2016-06-23	23	4	Jueves	25	4	2	6	Junio	2	1	2016	f
2016-06-24	24	5	Viernes	25	4	2	6	Junio	2	1	2016	f
2016-06-25	25	6	Sábado	25	4	2	6	Junio	2	1	2016	t
2016-06-26	26	7	Domingo	25	4	2	6	Junio	2	1	2016	t
2016-06-27	27	1	Lunes	26	5	2	6	Junio	2	1	2016	f
2016-06-28	28	2	Martes	26	5	2	6	Junio	2	1	2016	f
2016-06-29	29	3	Miércoles	26	5	2	6	Junio	2	1	2016	f
2016-06-30	30	4	Jueves	26	5	2	6	Junio	2	1	2016	f
2016-07-01	1	5	Viernes	26	1	1	7	Julio	3	2	2016	f
2016-07-02	2	6	Sábado	26	1	1	7	Julio	3	2	2016	t
2016-07-03	3	7	Domingo	26	1	1	7	Julio	3	2	2016	t
2016-07-04	4	1	Lunes	27	2	1	7	Julio	3	2	2016	f
2016-07-05	5	2	Martes	27	2	1	7	Julio	3	2	2016	f
2016-07-06	6	3	Miércoles	27	2	1	7	Julio	3	2	2016	f
2016-07-07	7	4	Jueves	27	2	1	7	Julio	3	2	2016	f
2016-07-08	8	5	Viernes	27	2	1	7	Julio	3	2	2016	f
2016-07-09	9	6	Sábado	27	2	1	7	Julio	3	2	2016	t
2016-07-10	10	7	Domingo	27	2	1	7	Julio	3	2	2016	t
2016-07-11	11	1	Lunes	28	3	1	7	Julio	3	2	2016	f
2016-07-12	12	2	Martes	28	3	1	7	Julio	3	2	2016	f
2016-07-13	13	3	Miércoles	28	3	1	7	Julio	3	2	2016	f
2016-07-14	14	4	Jueves	28	3	1	7	Julio	3	2	2016	f
2016-07-15	15	5	Viernes	28	3	1	7	Julio	3	2	2016	f
2016-07-16	16	6	Sábado	28	3	2	7	Julio	3	2	2016	t
2016-07-17	17	7	Domingo	28	3	2	7	Julio	3	2	2016	t
2016-07-18	18	1	Lunes	29	4	2	7	Julio	3	2	2016	f
2016-07-19	19	2	Martes	29	4	2	7	Julio	3	2	2016	f
2016-07-20	20	3	Miércoles	29	4	2	7	Julio	3	2	2016	f
2016-07-21	21	4	Jueves	29	4	2	7	Julio	3	2	2016	f
2016-07-22	22	5	Viernes	29	4	2	7	Julio	3	2	2016	f
2016-07-23	23	6	Sábado	29	4	2	7	Julio	3	2	2016	t
2016-07-24	24	7	Domingo	29	4	2	7	Julio	3	2	2016	t
2016-07-25	25	1	Lunes	30	5	2	7	Julio	3	2	2016	f
2016-07-26	26	2	Martes	30	5	2	7	Julio	3	2	2016	f
2016-07-27	27	3	Miércoles	30	5	2	7	Julio	3	2	2016	f
2016-07-28	28	4	Jueves	30	5	2	7	Julio	3	2	2016	f
2016-07-29	29	5	Viernes	30	5	2	7	Julio	3	2	2016	f
2016-07-30	30	6	Sábado	30	5	2	7	Julio	3	2	2016	t
2016-07-31	31	7	Domingo	30	5	2	7	Julio	3	2	2016	t
2016-08-01	1	1	Lunes	31	1	1	8	Agosto	3	2	2016	f
2016-08-02	2	2	Martes	31	1	1	8	Agosto	3	2	2016	f
2016-08-03	3	3	Miércoles	31	1	1	8	Agosto	3	2	2016	f
2016-08-04	4	4	Jueves	31	1	1	8	Agosto	3	2	2016	f
2016-08-05	5	5	Viernes	31	1	1	8	Agosto	3	2	2016	f
2016-08-06	6	6	Sábado	31	1	1	8	Agosto	3	2	2016	t
2016-08-07	7	7	Domingo	31	1	1	8	Agosto	3	2	2016	t
2016-08-08	8	1	Lunes	32	2	1	8	Agosto	3	2	2016	f
2016-08-09	9	2	Martes	32	2	1	8	Agosto	3	2	2016	f
2016-08-10	10	3	Miércoles	32	2	1	8	Agosto	3	2	2016	f
2016-08-11	11	4	Jueves	32	2	1	8	Agosto	3	2	2016	f
2016-08-12	12	5	Viernes	32	2	1	8	Agosto	3	2	2016	f
2016-08-13	13	6	Sábado	32	2	1	8	Agosto	3	2	2016	t
2016-08-14	14	7	Domingo	32	2	1	8	Agosto	3	2	2016	t
2016-08-15	15	1	Lunes	33	3	1	8	Agosto	3	2	2016	f
2016-08-16	16	2	Martes	33	3	2	8	Agosto	3	2	2016	f
2016-08-17	17	3	Miércoles	33	3	2	8	Agosto	3	2	2016	f
2016-08-18	18	4	Jueves	33	3	2	8	Agosto	3	2	2016	f
2016-08-19	19	5	Viernes	33	3	2	8	Agosto	3	2	2016	f
2016-08-20	20	6	Sábado	33	3	2	8	Agosto	3	2	2016	t
2016-08-21	21	7	Domingo	33	3	2	8	Agosto	3	2	2016	t
2016-08-22	22	1	Lunes	34	4	2	8	Agosto	3	2	2016	f
2016-08-23	23	2	Martes	34	4	2	8	Agosto	3	2	2016	f
2016-08-24	24	3	Miércoles	34	4	2	8	Agosto	3	2	2016	f
2016-08-25	25	4	Jueves	34	4	2	8	Agosto	3	2	2016	f
2016-08-26	26	5	Viernes	34	4	2	8	Agosto	3	2	2016	f
2016-08-27	27	6	Sábado	34	4	2	8	Agosto	3	2	2016	t
2016-08-28	28	7	Domingo	34	4	2	8	Agosto	3	2	2016	t
2016-08-29	29	1	Lunes	35	5	2	8	Agosto	3	2	2016	f
2016-08-30	30	2	Martes	35	5	2	8	Agosto	3	2	2016	f
2016-08-31	31	3	Miércoles	35	5	2	8	Agosto	3	2	2016	f
2016-09-01	1	4	Jueves	35	1	1	9	Septiembre	3	2	2016	f
2016-09-02	2	5	Viernes	35	1	1	9	Septiembre	3	2	2016	f
2016-09-03	3	6	Sábado	35	1	1	9	Septiembre	3	2	2016	t
2016-09-04	4	7	Domingo	35	1	1	9	Septiembre	3	2	2016	t
2016-09-05	5	1	Lunes	36	2	1	9	Septiembre	3	2	2016	f
2016-09-06	6	2	Martes	36	2	1	9	Septiembre	3	2	2016	f
2016-09-07	7	3	Miércoles	36	2	1	9	Septiembre	3	2	2016	f
2016-09-08	8	4	Jueves	36	2	1	9	Septiembre	3	2	2016	f
2016-09-09	9	5	Viernes	36	2	1	9	Septiembre	3	2	2016	f
2016-09-10	10	6	Sábado	36	2	1	9	Septiembre	3	2	2016	t
2016-09-11	11	7	Domingo	36	2	1	9	Septiembre	3	2	2016	t
2016-09-12	12	1	Lunes	37	3	1	9	Septiembre	3	2	2016	f
2016-09-13	13	2	Martes	37	3	1	9	Septiembre	3	2	2016	f
2016-09-14	14	3	Miércoles	37	3	1	9	Septiembre	3	2	2016	f
2016-09-15	15	4	Jueves	37	3	1	9	Septiembre	3	2	2016	f
2016-09-16	16	5	Viernes	37	3	2	9	Septiembre	3	2	2016	f
2016-09-17	17	6	Sábado	37	3	2	9	Septiembre	3	2	2016	t
2016-09-18	18	7	Domingo	37	3	2	9	Septiembre	3	2	2016	t
2016-09-19	19	1	Lunes	38	4	2	9	Septiembre	3	2	2016	f
2016-09-20	20	2	Martes	38	4	2	9	Septiembre	3	2	2016	f
2016-09-21	21	3	Miércoles	38	4	2	9	Septiembre	3	2	2016	f
2016-09-22	22	4	Jueves	38	4	2	9	Septiembre	3	2	2016	f
2016-09-23	23	5	Viernes	38	4	2	9	Septiembre	3	2	2016	f
2016-09-24	24	6	Sábado	38	4	2	9	Septiembre	3	2	2016	t
2016-09-25	25	7	Domingo	38	4	2	9	Septiembre	3	2	2016	t
2016-09-26	26	1	Lunes	39	5	2	9	Septiembre	3	2	2016	f
2016-09-27	27	2	Martes	39	5	2	9	Septiembre	3	2	2016	f
2016-09-28	28	3	Miércoles	39	5	2	9	Septiembre	3	2	2016	f
2016-09-29	29	4	Jueves	39	5	2	9	Septiembre	3	2	2016	f
2016-09-30	30	5	Viernes	39	5	2	9	Septiembre	3	2	2016	f
2016-10-01	1	6	Sábado	39	1	1	10	Octubre	4	2	2016	t
2016-10-02	2	7	Domingo	39	1	1	10	Octubre	4	2	2016	t
2016-10-03	3	1	Lunes	40	2	1	10	Octubre	4	2	2016	f
2016-10-04	4	2	Martes	40	2	1	10	Octubre	4	2	2016	f
2016-10-05	5	3	Miércoles	40	2	1	10	Octubre	4	2	2016	f
2016-10-06	6	4	Jueves	40	2	1	10	Octubre	4	2	2016	f
2016-10-07	7	5	Viernes	40	2	1	10	Octubre	4	2	2016	f
2016-10-08	8	6	Sábado	40	2	1	10	Octubre	4	2	2016	t
2016-10-09	9	7	Domingo	40	2	1	10	Octubre	4	2	2016	t
2016-10-10	10	1	Lunes	41	3	1	10	Octubre	4	2	2016	f
2016-10-11	11	2	Martes	41	3	1	10	Octubre	4	2	2016	f
2016-10-12	12	3	Miércoles	41	3	1	10	Octubre	4	2	2016	f
2016-10-13	13	4	Jueves	41	3	1	10	Octubre	4	2	2016	f
2016-10-14	14	5	Viernes	41	3	1	10	Octubre	4	2	2016	f
2016-10-15	15	6	Sábado	41	3	1	10	Octubre	4	2	2016	t
2016-10-16	16	7	Domingo	41	3	2	10	Octubre	4	2	2016	t
2016-10-17	17	1	Lunes	42	4	2	10	Octubre	4	2	2016	f
2016-10-18	18	2	Martes	42	4	2	10	Octubre	4	2	2016	f
2016-10-19	19	3	Miércoles	42	4	2	10	Octubre	4	2	2016	f
2016-10-20	20	4	Jueves	42	4	2	10	Octubre	4	2	2016	f
2016-10-21	21	5	Viernes	42	4	2	10	Octubre	4	2	2016	f
2016-10-22	22	6	Sábado	42	4	2	10	Octubre	4	2	2016	t
2016-10-23	23	7	Domingo	42	4	2	10	Octubre	4	2	2016	t
2016-10-24	24	1	Lunes	43	5	2	10	Octubre	4	2	2016	f
2016-10-25	25	2	Martes	43	5	2	10	Octubre	4	2	2016	f
2016-10-26	26	3	Miércoles	43	5	2	10	Octubre	4	2	2016	f
2016-10-27	27	4	Jueves	43	5	2	10	Octubre	4	2	2016	f
2016-10-28	28	5	Viernes	43	5	2	10	Octubre	4	2	2016	f
2016-10-29	29	6	Sábado	43	5	2	10	Octubre	4	2	2016	t
2016-10-30	30	7	Domingo	43	5	2	10	Octubre	4	2	2016	t
2016-10-31	31	1	Lunes	44	6	2	10	Octubre	4	2	2016	f
2016-11-01	1	2	Martes	44	1	1	11	Noviembre	4	2	2016	f
2016-11-02	2	3	Miércoles	44	1	1	11	Noviembre	4	2	2016	f
2016-11-03	3	4	Jueves	44	1	1	11	Noviembre	4	2	2016	f
2016-11-04	4	5	Viernes	44	1	1	11	Noviembre	4	2	2016	f
2016-11-05	5	6	Sábado	44	1	1	11	Noviembre	4	2	2016	t
2016-11-06	6	7	Domingo	44	1	1	11	Noviembre	4	2	2016	t
2016-11-07	7	1	Lunes	45	2	1	11	Noviembre	4	2	2016	f
2016-11-08	8	2	Martes	45	2	1	11	Noviembre	4	2	2016	f
2016-11-09	9	3	Miércoles	45	2	1	11	Noviembre	4	2	2016	f
2016-11-10	10	4	Jueves	45	2	1	11	Noviembre	4	2	2016	f
2016-11-11	11	5	Viernes	45	2	1	11	Noviembre	4	2	2016	f
2016-11-12	12	6	Sábado	45	2	1	11	Noviembre	4	2	2016	t
2016-11-13	13	7	Domingo	45	2	1	11	Noviembre	4	2	2016	t
2016-11-14	14	1	Lunes	46	3	1	11	Noviembre	4	2	2016	f
2016-11-15	15	2	Martes	46	3	1	11	Noviembre	4	2	2016	f
2016-11-16	16	3	Miércoles	46	3	2	11	Noviembre	4	2	2016	f
2016-11-17	17	4	Jueves	46	3	2	11	Noviembre	4	2	2016	f
2016-11-18	18	5	Viernes	46	3	2	11	Noviembre	4	2	2016	f
2016-11-19	19	6	Sábado	46	3	2	11	Noviembre	4	2	2016	t
2016-11-20	20	7	Domingo	46	3	2	11	Noviembre	4	2	2016	t
2016-11-21	21	1	Lunes	47	4	2	11	Noviembre	4	2	2016	f
2016-11-22	22	2	Martes	47	4	2	11	Noviembre	4	2	2016	f
2016-11-23	23	3	Miércoles	47	4	2	11	Noviembre	4	2	2016	f
2016-11-24	24	4	Jueves	47	4	2	11	Noviembre	4	2	2016	f
2016-11-25	25	5	Viernes	47	4	2	11	Noviembre	4	2	2016	f
2016-11-26	26	6	Sábado	47	4	2	11	Noviembre	4	2	2016	t
2016-11-27	27	7	Domingo	47	4	2	11	Noviembre	4	2	2016	t
2016-11-28	28	1	Lunes	48	5	2	11	Noviembre	4	2	2016	f
2016-11-29	29	2	Martes	48	5	2	11	Noviembre	4	2	2016	f
2016-11-30	30	3	Miércoles	48	5	2	11	Noviembre	4	2	2016	f
2016-12-01	1	4	Jueves	48	1	1	12	Diciembre	4	2	2016	f
2016-12-02	2	5	Viernes	48	1	1	12	Diciembre	4	2	2016	f
2016-12-03	3	6	Sábado	48	1	1	12	Diciembre	4	2	2016	t
2016-12-04	4	7	Domingo	48	1	1	12	Diciembre	4	2	2016	t
2016-12-05	5	1	Lunes	49	2	1	12	Diciembre	4	2	2016	f
2016-12-06	6	2	Martes	49	2	1	12	Diciembre	4	2	2016	f
2016-12-07	7	3	Miércoles	49	2	1	12	Diciembre	4	2	2016	f
2016-12-08	8	4	Jueves	49	2	1	12	Diciembre	4	2	2016	f
2016-12-09	9	5	Viernes	49	2	1	12	Diciembre	4	2	2016	f
2016-12-10	10	6	Sábado	49	2	1	12	Diciembre	4	2	2016	t
2016-12-11	11	7	Domingo	49	2	1	12	Diciembre	4	2	2016	t
2016-12-12	12	1	Lunes	50	3	1	12	Diciembre	4	2	2016	f
2016-12-13	13	2	Martes	50	3	1	12	Diciembre	4	2	2016	f
2016-12-14	14	3	Miércoles	50	3	1	12	Diciembre	4	2	2016	f
2016-12-15	15	4	Jueves	50	3	1	12	Diciembre	4	2	2016	f
2016-12-16	16	5	Viernes	50	3	2	12	Diciembre	4	2	2016	f
2016-12-17	17	6	Sábado	50	3	2	12	Diciembre	4	2	2016	t
2016-12-18	18	7	Domingo	50	3	2	12	Diciembre	4	2	2016	t
2016-12-19	19	1	Lunes	51	4	2	12	Diciembre	4	2	2016	f
2016-12-20	20	2	Martes	51	4	2	12	Diciembre	4	2	2016	f
2016-12-21	21	3	Miércoles	51	4	2	12	Diciembre	4	2	2016	f
2016-12-22	22	4	Jueves	51	4	2	12	Diciembre	4	2	2016	f
2016-12-23	23	5	Viernes	51	4	2	12	Diciembre	4	2	2016	f
2016-12-24	24	6	Sábado	51	4	2	12	Diciembre	4	2	2016	t
2016-12-25	25	7	Domingo	51	4	2	12	Diciembre	4	2	2016	t
2016-12-26	26	1	Lunes	52	5	2	12	Diciembre	4	2	2016	f
2016-12-27	27	2	Martes	52	5	2	12	Diciembre	4	2	2016	f
2016-12-28	28	3	Miércoles	52	5	2	12	Diciembre	4	2	2016	f
2016-12-29	29	4	Jueves	52	5	2	12	Diciembre	4	2	2016	f
2016-12-30	30	5	Viernes	52	5	2	12	Diciembre	4	2	2016	f
2016-12-31	31	6	Sábado	52	5	2	12	Diciembre	4	2	2016	t
2017-01-01	1	7	Domingo	52	1	1	1	Enero	1	1	2017	t
2017-01-02	2	1	Lunes	1	2	1	1	Enero	1	1	2017	f
2017-01-03	3	2	Martes	1	2	1	1	Enero	1	1	2017	f
2017-01-04	4	3	Miércoles	1	2	1	1	Enero	1	1	2017	f
2017-01-05	5	4	Jueves	1	2	1	1	Enero	1	1	2017	f
2017-01-06	6	5	Viernes	1	2	1	1	Enero	1	1	2017	f
2017-01-07	7	6	Sábado	1	2	1	1	Enero	1	1	2017	t
2017-01-08	8	7	Domingo	1	2	1	1	Enero	1	1	2017	t
2017-01-09	9	1	Lunes	2	3	1	1	Enero	1	1	2017	f
2017-01-10	10	2	Martes	2	3	1	1	Enero	1	1	2017	f
2017-01-11	11	3	Miércoles	2	3	1	1	Enero	1	1	2017	f
2017-01-12	12	4	Jueves	2	3	1	1	Enero	1	1	2017	f
2017-01-13	13	5	Viernes	2	3	1	1	Enero	1	1	2017	f
2017-01-14	14	6	Sábado	2	3	1	1	Enero	1	1	2017	t
2017-01-15	15	7	Domingo	2	3	1	1	Enero	1	1	2017	t
2017-01-16	16	1	Lunes	3	4	2	1	Enero	1	1	2017	f
2017-01-17	17	2	Martes	3	4	2	1	Enero	1	1	2017	f
2017-01-18	18	3	Miércoles	3	4	2	1	Enero	1	1	2017	f
2017-01-19	19	4	Jueves	3	4	2	1	Enero	1	1	2017	f
2017-01-20	20	5	Viernes	3	4	2	1	Enero	1	1	2017	f
2017-01-21	21	6	Sábado	3	4	2	1	Enero	1	1	2017	t
2017-01-22	22	7	Domingo	3	4	2	1	Enero	1	1	2017	t
2017-01-23	23	1	Lunes	4	5	2	1	Enero	1	1	2017	f
2017-01-24	24	2	Martes	4	5	2	1	Enero	1	1	2017	f
2017-01-25	25	3	Miércoles	4	5	2	1	Enero	1	1	2017	f
2017-01-26	26	4	Jueves	4	5	2	1	Enero	1	1	2017	f
2017-01-27	27	5	Viernes	4	5	2	1	Enero	1	1	2017	f
2017-01-28	28	6	Sábado	4	5	2	1	Enero	1	1	2017	t
2017-01-29	29	7	Domingo	4	5	2	1	Enero	1	1	2017	t
2017-01-30	30	1	Lunes	5	6	2	1	Enero	1	1	2017	f
2017-01-31	31	2	Martes	5	6	2	1	Enero	1	1	2017	f
2017-02-01	1	3	Miércoles	5	1	1	2	Febrero	1	1	2017	f
2017-02-02	2	4	Jueves	5	1	1	2	Febrero	1	1	2017	f
2017-02-03	3	5	Viernes	5	1	1	2	Febrero	1	1	2017	f
2017-02-04	4	6	Sábado	5	1	1	2	Febrero	1	1	2017	t
2017-02-05	5	7	Domingo	5	1	1	2	Febrero	1	1	2017	t
2017-02-06	6	1	Lunes	6	2	1	2	Febrero	1	1	2017	f
2017-02-07	7	2	Martes	6	2	1	2	Febrero	1	1	2017	f
2017-02-08	8	3	Miércoles	6	2	1	2	Febrero	1	1	2017	f
2017-02-09	9	4	Jueves	6	2	1	2	Febrero	1	1	2017	f
2017-02-10	10	5	Viernes	6	2	1	2	Febrero	1	1	2017	f
2017-02-11	11	6	Sábado	6	2	1	2	Febrero	1	1	2017	t
2017-02-12	12	7	Domingo	6	2	1	2	Febrero	1	1	2017	t
2017-02-13	13	1	Lunes	7	3	1	2	Febrero	1	1	2017	f
2017-02-14	14	2	Martes	7	3	1	2	Febrero	1	1	2017	f
2017-02-15	15	3	Miércoles	7	3	1	2	Febrero	1	1	2017	f
2017-02-16	16	4	Jueves	7	3	2	2	Febrero	1	1	2017	f
2017-02-17	17	5	Viernes	7	3	2	2	Febrero	1	1	2017	f
2017-02-18	18	6	Sábado	7	3	2	2	Febrero	1	1	2017	t
2017-02-19	19	7	Domingo	7	3	2	2	Febrero	1	1	2017	t
2017-02-20	20	1	Lunes	8	4	2	2	Febrero	1	1	2017	f
2017-02-21	21	2	Martes	8	4	2	2	Febrero	1	1	2017	f
2017-02-22	22	3	Miércoles	8	4	2	2	Febrero	1	1	2017	f
2017-02-23	23	4	Jueves	8	4	2	2	Febrero	1	1	2017	f
2017-02-24	24	5	Viernes	8	4	2	2	Febrero	1	1	2017	f
2017-02-25	25	6	Sábado	8	4	2	2	Febrero	1	1	2017	t
2017-02-26	26	7	Domingo	8	4	2	2	Febrero	1	1	2017	t
2017-02-27	27	1	Lunes	9	5	2	2	Febrero	1	1	2017	f
2017-02-28	28	2	Martes	9	5	2	2	Febrero	1	1	2017	f
2017-03-01	1	3	Miércoles	9	1	1	3	Marzo	1	1	2017	f
2017-03-02	2	4	Jueves	9	1	1	3	Marzo	1	1	2017	f
2017-03-03	3	5	Viernes	9	1	1	3	Marzo	1	1	2017	f
2017-03-04	4	6	Sábado	9	1	1	3	Marzo	1	1	2017	t
2017-03-05	5	7	Domingo	9	1	1	3	Marzo	1	1	2017	t
2017-03-06	6	1	Lunes	10	2	1	3	Marzo	1	1	2017	f
2017-03-07	7	2	Martes	10	2	1	3	Marzo	1	1	2017	f
2017-03-08	8	3	Miércoles	10	2	1	3	Marzo	1	1	2017	f
2017-03-09	9	4	Jueves	10	2	1	3	Marzo	1	1	2017	f
2017-03-10	10	5	Viernes	10	2	1	3	Marzo	1	1	2017	f
2017-03-11	11	6	Sábado	10	2	1	3	Marzo	1	1	2017	t
2017-03-12	12	7	Domingo	10	2	1	3	Marzo	1	1	2017	t
2017-03-13	13	1	Lunes	11	3	1	3	Marzo	1	1	2017	f
2017-03-14	14	2	Martes	11	3	1	3	Marzo	1	1	2017	f
2017-03-15	15	3	Miércoles	11	3	1	3	Marzo	1	1	2017	f
2017-03-16	16	4	Jueves	11	3	2	3	Marzo	1	1	2017	f
2017-03-17	17	5	Viernes	11	3	2	3	Marzo	1	1	2017	f
2017-03-18	18	6	Sábado	11	3	2	3	Marzo	1	1	2017	t
2017-03-19	19	7	Domingo	11	3	2	3	Marzo	1	1	2017	t
2017-03-20	20	1	Lunes	12	4	2	3	Marzo	1	1	2017	f
2017-03-21	21	2	Martes	12	4	2	3	Marzo	1	1	2017	f
2017-03-22	22	3	Miércoles	12	4	2	3	Marzo	1	1	2017	f
2017-03-23	23	4	Jueves	12	4	2	3	Marzo	1	1	2017	f
2017-03-24	24	5	Viernes	12	4	2	3	Marzo	1	1	2017	f
2017-03-25	25	6	Sábado	12	4	2	3	Marzo	1	1	2017	t
2017-03-26	26	7	Domingo	12	4	2	3	Marzo	1	1	2017	t
2017-03-27	27	1	Lunes	13	5	2	3	Marzo	1	1	2017	f
2017-03-28	28	2	Martes	13	5	2	3	Marzo	1	1	2017	f
2017-03-29	29	3	Miércoles	13	5	2	3	Marzo	1	1	2017	f
2017-03-30	30	4	Jueves	13	5	2	3	Marzo	1	1	2017	f
2017-03-31	31	5	Viernes	13	5	2	3	Marzo	1	1	2017	f
2017-04-01	1	6	Sábado	13	1	1	4	Abril	2	1	2017	t
2017-04-02	2	7	Domingo	13	1	1	4	Abril	2	1	2017	t
2017-04-03	3	1	Lunes	14	2	1	4	Abril	2	1	2017	f
2017-04-04	4	2	Martes	14	2	1	4	Abril	2	1	2017	f
2017-04-05	5	3	Miércoles	14	2	1	4	Abril	2	1	2017	f
2017-04-06	6	4	Jueves	14	2	1	4	Abril	2	1	2017	f
2017-04-07	7	5	Viernes	14	2	1	4	Abril	2	1	2017	f
2017-04-08	8	6	Sábado	14	2	1	4	Abril	2	1	2017	t
2017-04-09	9	7	Domingo	14	2	1	4	Abril	2	1	2017	t
2017-04-10	10	1	Lunes	15	3	1	4	Abril	2	1	2017	f
2017-04-11	11	2	Martes	15	3	1	4	Abril	2	1	2017	f
2017-04-12	12	3	Miércoles	15	3	1	4	Abril	2	1	2017	f
2017-04-13	13	4	Jueves	15	3	1	4	Abril	2	1	2017	f
2017-04-14	14	5	Viernes	15	3	1	4	Abril	2	1	2017	f
2017-04-15	15	6	Sábado	15	3	1	4	Abril	2	1	2017	t
2017-04-16	16	7	Domingo	15	3	2	4	Abril	2	1	2017	t
2017-04-17	17	1	Lunes	16	4	2	4	Abril	2	1	2017	f
2017-04-18	18	2	Martes	16	4	2	4	Abril	2	1	2017	f
2017-04-19	19	3	Miércoles	16	4	2	4	Abril	2	1	2017	f
2017-04-20	20	4	Jueves	16	4	2	4	Abril	2	1	2017	f
2017-04-21	21	5	Viernes	16	4	2	4	Abril	2	1	2017	f
2017-04-22	22	6	Sábado	16	4	2	4	Abril	2	1	2017	t
2017-04-23	23	7	Domingo	16	4	2	4	Abril	2	1	2017	t
2017-04-24	24	1	Lunes	17	5	2	4	Abril	2	1	2017	f
2017-04-25	25	2	Martes	17	5	2	4	Abril	2	1	2017	f
2017-04-26	26	3	Miércoles	17	5	2	4	Abril	2	1	2017	f
2017-04-27	27	4	Jueves	17	5	2	4	Abril	2	1	2017	f
2017-04-28	28	5	Viernes	17	5	2	4	Abril	2	1	2017	f
2017-04-29	29	6	Sábado	17	5	2	4	Abril	2	1	2017	t
2017-04-30	30	7	Domingo	17	5	2	4	Abril	2	1	2017	t
2017-05-01	1	1	Lunes	18	1	1	5	Mayo	2	1	2017	f
2017-05-02	2	2	Martes	18	1	1	5	Mayo	2	1	2017	f
2017-05-03	3	3	Miércoles	18	1	1	5	Mayo	2	1	2017	f
2017-05-04	4	4	Jueves	18	1	1	5	Mayo	2	1	2017	f
2017-05-05	5	5	Viernes	18	1	1	5	Mayo	2	1	2017	f
2017-05-06	6	6	Sábado	18	1	1	5	Mayo	2	1	2017	t
2017-05-07	7	7	Domingo	18	1	1	5	Mayo	2	1	2017	t
2017-05-08	8	1	Lunes	19	2	1	5	Mayo	2	1	2017	f
2017-05-09	9	2	Martes	19	2	1	5	Mayo	2	1	2017	f
2017-05-10	10	3	Miércoles	19	2	1	5	Mayo	2	1	2017	f
2017-05-11	11	4	Jueves	19	2	1	5	Mayo	2	1	2017	f
2017-05-12	12	5	Viernes	19	2	1	5	Mayo	2	1	2017	f
2017-05-13	13	6	Sábado	19	2	1	5	Mayo	2	1	2017	t
2017-05-14	14	7	Domingo	19	2	1	5	Mayo	2	1	2017	t
2017-05-15	15	1	Lunes	20	3	1	5	Mayo	2	1	2017	f
2017-05-16	16	2	Martes	20	3	2	5	Mayo	2	1	2017	f
2017-05-17	17	3	Miércoles	20	3	2	5	Mayo	2	1	2017	f
2017-05-18	18	4	Jueves	20	3	2	5	Mayo	2	1	2017	f
2017-05-19	19	5	Viernes	20	3	2	5	Mayo	2	1	2017	f
2017-05-20	20	6	Sábado	20	3	2	5	Mayo	2	1	2017	t
2017-05-21	21	7	Domingo	20	3	2	5	Mayo	2	1	2017	t
2017-05-22	22	1	Lunes	21	4	2	5	Mayo	2	1	2017	f
2017-05-23	23	2	Martes	21	4	2	5	Mayo	2	1	2017	f
2017-05-24	24	3	Miércoles	21	4	2	5	Mayo	2	1	2017	f
2017-05-25	25	4	Jueves	21	4	2	5	Mayo	2	1	2017	f
2017-05-26	26	5	Viernes	21	4	2	5	Mayo	2	1	2017	f
2017-05-27	27	6	Sábado	21	4	2	5	Mayo	2	1	2017	t
2017-05-28	28	7	Domingo	21	4	2	5	Mayo	2	1	2017	t
2017-05-29	29	1	Lunes	22	5	2	5	Mayo	2	1	2017	f
2017-05-30	30	2	Martes	22	5	2	5	Mayo	2	1	2017	f
2017-05-31	31	3	Miércoles	22	5	2	5	Mayo	2	1	2017	f
2017-06-01	1	4	Jueves	22	1	1	6	Junio	2	1	2017	f
2017-06-02	2	5	Viernes	22	1	1	6	Junio	2	1	2017	f
2017-06-03	3	6	Sábado	22	1	1	6	Junio	2	1	2017	t
2017-06-04	4	7	Domingo	22	1	1	6	Junio	2	1	2017	t
2017-06-05	5	1	Lunes	23	2	1	6	Junio	2	1	2017	f
2017-06-06	6	2	Martes	23	2	1	6	Junio	2	1	2017	f
2017-06-07	7	3	Miércoles	23	2	1	6	Junio	2	1	2017	f
2017-06-08	8	4	Jueves	23	2	1	6	Junio	2	1	2017	f
2017-06-09	9	5	Viernes	23	2	1	6	Junio	2	1	2017	f
2017-06-10	10	6	Sábado	23	2	1	6	Junio	2	1	2017	t
2017-06-11	11	7	Domingo	23	2	1	6	Junio	2	1	2017	t
2017-06-12	12	1	Lunes	24	3	1	6	Junio	2	1	2017	f
2017-06-13	13	2	Martes	24	3	1	6	Junio	2	1	2017	f
2017-06-14	14	3	Miércoles	24	3	1	6	Junio	2	1	2017	f
2017-06-15	15	4	Jueves	24	3	1	6	Junio	2	1	2017	f
2017-06-16	16	5	Viernes	24	3	2	6	Junio	2	1	2017	f
2017-06-17	17	6	Sábado	24	3	2	6	Junio	2	1	2017	t
2017-06-18	18	7	Domingo	24	3	2	6	Junio	2	1	2017	t
2017-06-19	19	1	Lunes	25	4	2	6	Junio	2	1	2017	f
2017-06-20	20	2	Martes	25	4	2	6	Junio	2	1	2017	f
2017-06-21	21	3	Miércoles	25	4	2	6	Junio	2	1	2017	f
2017-06-22	22	4	Jueves	25	4	2	6	Junio	2	1	2017	f
2017-06-23	23	5	Viernes	25	4	2	6	Junio	2	1	2017	f
2017-06-24	24	6	Sábado	25	4	2	6	Junio	2	1	2017	t
2017-06-25	25	7	Domingo	25	4	2	6	Junio	2	1	2017	t
2017-06-26	26	1	Lunes	26	5	2	6	Junio	2	1	2017	f
2017-06-27	27	2	Martes	26	5	2	6	Junio	2	1	2017	f
2017-06-28	28	3	Miércoles	26	5	2	6	Junio	2	1	2017	f
2017-06-29	29	4	Jueves	26	5	2	6	Junio	2	1	2017	f
2017-06-30	30	5	Viernes	26	5	2	6	Junio	2	1	2017	f
2017-07-01	1	6	Sábado	26	1	1	7	Julio	3	2	2017	t
2017-07-02	2	7	Domingo	26	1	1	7	Julio	3	2	2017	t
2017-07-03	3	1	Lunes	27	2	1	7	Julio	3	2	2017	f
2017-07-04	4	2	Martes	27	2	1	7	Julio	3	2	2017	f
2017-07-05	5	3	Miércoles	27	2	1	7	Julio	3	2	2017	f
2017-07-06	6	4	Jueves	27	2	1	7	Julio	3	2	2017	f
2017-07-07	7	5	Viernes	27	2	1	7	Julio	3	2	2017	f
2017-07-08	8	6	Sábado	27	2	1	7	Julio	3	2	2017	t
2017-07-09	9	7	Domingo	27	2	1	7	Julio	3	2	2017	t
2017-07-10	10	1	Lunes	28	3	1	7	Julio	3	2	2017	f
2017-07-11	11	2	Martes	28	3	1	7	Julio	3	2	2017	f
2017-07-12	12	3	Miércoles	28	3	1	7	Julio	3	2	2017	f
2017-07-13	13	4	Jueves	28	3	1	7	Julio	3	2	2017	f
2017-07-14	14	5	Viernes	28	3	1	7	Julio	3	2	2017	f
2017-07-15	15	6	Sábado	28	3	1	7	Julio	3	2	2017	t
2017-07-16	16	7	Domingo	28	3	2	7	Julio	3	2	2017	t
2017-07-17	17	1	Lunes	29	4	2	7	Julio	3	2	2017	f
2017-07-18	18	2	Martes	29	4	2	7	Julio	3	2	2017	f
2017-07-19	19	3	Miércoles	29	4	2	7	Julio	3	2	2017	f
2017-07-20	20	4	Jueves	29	4	2	7	Julio	3	2	2017	f
2017-07-21	21	5	Viernes	29	4	2	7	Julio	3	2	2017	f
2017-07-22	22	6	Sábado	29	4	2	7	Julio	3	2	2017	t
2017-07-23	23	7	Domingo	29	4	2	7	Julio	3	2	2017	t
2017-07-24	24	1	Lunes	30	5	2	7	Julio	3	2	2017	f
2017-07-25	25	2	Martes	30	5	2	7	Julio	3	2	2017	f
2017-07-26	26	3	Miércoles	30	5	2	7	Julio	3	2	2017	f
2017-07-27	27	4	Jueves	30	5	2	7	Julio	3	2	2017	f
2017-07-28	28	5	Viernes	30	5	2	7	Julio	3	2	2017	f
2017-07-29	29	6	Sábado	30	5	2	7	Julio	3	2	2017	t
2017-07-30	30	7	Domingo	30	5	2	7	Julio	3	2	2017	t
2017-07-31	31	1	Lunes	31	6	2	7	Julio	3	2	2017	f
2017-08-01	1	2	Martes	31	1	1	8	Agosto	3	2	2017	f
2017-08-02	2	3	Miércoles	31	1	1	8	Agosto	3	2	2017	f
2017-08-03	3	4	Jueves	31	1	1	8	Agosto	3	2	2017	f
2017-08-04	4	5	Viernes	31	1	1	8	Agosto	3	2	2017	f
2017-08-05	5	6	Sábado	31	1	1	8	Agosto	3	2	2017	t
2017-08-06	6	7	Domingo	31	1	1	8	Agosto	3	2	2017	t
2017-08-07	7	1	Lunes	32	2	1	8	Agosto	3	2	2017	f
2017-08-08	8	2	Martes	32	2	1	8	Agosto	3	2	2017	f
2017-08-09	9	3	Miércoles	32	2	1	8	Agosto	3	2	2017	f
2017-08-10	10	4	Jueves	32	2	1	8	Agosto	3	2	2017	f
2017-08-11	11	5	Viernes	32	2	1	8	Agosto	3	2	2017	f
2017-08-12	12	6	Sábado	32	2	1	8	Agosto	3	2	2017	t
2017-08-13	13	7	Domingo	32	2	1	8	Agosto	3	2	2017	t
2017-08-14	14	1	Lunes	33	3	1	8	Agosto	3	2	2017	f
2017-08-15	15	2	Martes	33	3	1	8	Agosto	3	2	2017	f
2017-08-16	16	3	Miércoles	33	3	2	8	Agosto	3	2	2017	f
2017-08-17	17	4	Jueves	33	3	2	8	Agosto	3	2	2017	f
2017-08-18	18	5	Viernes	33	3	2	8	Agosto	3	2	2017	f
2017-08-19	19	6	Sábado	33	3	2	8	Agosto	3	2	2017	t
2017-08-20	20	7	Domingo	33	3	2	8	Agosto	3	2	2017	t
2017-08-21	21	1	Lunes	34	4	2	8	Agosto	3	2	2017	f
2017-08-22	22	2	Martes	34	4	2	8	Agosto	3	2	2017	f
2017-08-23	23	3	Miércoles	34	4	2	8	Agosto	3	2	2017	f
2017-08-24	24	4	Jueves	34	4	2	8	Agosto	3	2	2017	f
2017-08-25	25	5	Viernes	34	4	2	8	Agosto	3	2	2017	f
2017-08-26	26	6	Sábado	34	4	2	8	Agosto	3	2	2017	t
2017-08-27	27	7	Domingo	34	4	2	8	Agosto	3	2	2017	t
2017-08-28	28	1	Lunes	35	5	2	8	Agosto	3	2	2017	f
2017-08-29	29	2	Martes	35	5	2	8	Agosto	3	2	2017	f
2017-08-30	30	3	Miércoles	35	5	2	8	Agosto	3	2	2017	f
2017-08-31	31	4	Jueves	35	5	2	8	Agosto	3	2	2017	f
2017-09-01	1	5	Viernes	35	1	1	9	Septiembre	3	2	2017	f
2017-09-02	2	6	Sábado	35	1	1	9	Septiembre	3	2	2017	t
2017-09-03	3	7	Domingo	35	1	1	9	Septiembre	3	2	2017	t
2017-09-04	4	1	Lunes	36	2	1	9	Septiembre	3	2	2017	f
2017-09-05	5	2	Martes	36	2	1	9	Septiembre	3	2	2017	f
2017-09-06	6	3	Miércoles	36	2	1	9	Septiembre	3	2	2017	f
2017-09-07	7	4	Jueves	36	2	1	9	Septiembre	3	2	2017	f
2017-09-08	8	5	Viernes	36	2	1	9	Septiembre	3	2	2017	f
2017-09-09	9	6	Sábado	36	2	1	9	Septiembre	3	2	2017	t
2017-09-10	10	7	Domingo	36	2	1	9	Septiembre	3	2	2017	t
2017-09-11	11	1	Lunes	37	3	1	9	Septiembre	3	2	2017	f
2017-09-12	12	2	Martes	37	3	1	9	Septiembre	3	2	2017	f
2017-09-13	13	3	Miércoles	37	3	1	9	Septiembre	3	2	2017	f
2017-09-14	14	4	Jueves	37	3	1	9	Septiembre	3	2	2017	f
2017-09-15	15	5	Viernes	37	3	1	9	Septiembre	3	2	2017	f
2017-09-16	16	6	Sábado	37	3	2	9	Septiembre	3	2	2017	t
2017-09-17	17	7	Domingo	37	3	2	9	Septiembre	3	2	2017	t
2017-09-18	18	1	Lunes	38	4	2	9	Septiembre	3	2	2017	f
2017-09-19	19	2	Martes	38	4	2	9	Septiembre	3	2	2017	f
2017-09-20	20	3	Miércoles	38	4	2	9	Septiembre	3	2	2017	f
2017-09-21	21	4	Jueves	38	4	2	9	Septiembre	3	2	2017	f
2017-09-22	22	5	Viernes	38	4	2	9	Septiembre	3	2	2017	f
2017-09-23	23	6	Sábado	38	4	2	9	Septiembre	3	2	2017	t
2017-09-24	24	7	Domingo	38	4	2	9	Septiembre	3	2	2017	t
2017-09-25	25	1	Lunes	39	5	2	9	Septiembre	3	2	2017	f
2017-09-26	26	2	Martes	39	5	2	9	Septiembre	3	2	2017	f
2017-09-27	27	3	Miércoles	39	5	2	9	Septiembre	3	2	2017	f
2017-09-28	28	4	Jueves	39	5	2	9	Septiembre	3	2	2017	f
2017-09-29	29	5	Viernes	39	5	2	9	Septiembre	3	2	2017	f
2017-09-30	30	6	Sábado	39	5	2	9	Septiembre	3	2	2017	t
2017-10-01	1	7	Domingo	39	1	1	10	Octubre	4	2	2017	t
2017-10-02	2	1	Lunes	40	2	1	10	Octubre	4	2	2017	f
2017-10-03	3	2	Martes	40	2	1	10	Octubre	4	2	2017	f
2017-10-04	4	3	Miércoles	40	2	1	10	Octubre	4	2	2017	f
2017-10-05	5	4	Jueves	40	2	1	10	Octubre	4	2	2017	f
2017-10-06	6	5	Viernes	40	2	1	10	Octubre	4	2	2017	f
2017-10-07	7	6	Sábado	40	2	1	10	Octubre	4	2	2017	t
2017-10-08	8	7	Domingo	40	2	1	10	Octubre	4	2	2017	t
2017-10-09	9	1	Lunes	41	3	1	10	Octubre	4	2	2017	f
2017-10-10	10	2	Martes	41	3	1	10	Octubre	4	2	2017	f
2017-10-11	11	3	Miércoles	41	3	1	10	Octubre	4	2	2017	f
2017-10-12	12	4	Jueves	41	3	1	10	Octubre	4	2	2017	f
2017-10-13	13	5	Viernes	41	3	1	10	Octubre	4	2	2017	f
2017-10-14	14	6	Sábado	41	3	1	10	Octubre	4	2	2017	t
2017-10-15	15	7	Domingo	41	3	1	10	Octubre	4	2	2017	t
2017-10-16	16	1	Lunes	42	4	2	10	Octubre	4	2	2017	f
2017-10-17	17	2	Martes	42	4	2	10	Octubre	4	2	2017	f
2017-10-18	18	3	Miércoles	42	4	2	10	Octubre	4	2	2017	f
2017-10-19	19	4	Jueves	42	4	2	10	Octubre	4	2	2017	f
2017-10-20	20	5	Viernes	42	4	2	10	Octubre	4	2	2017	f
2017-10-21	21	6	Sábado	42	4	2	10	Octubre	4	2	2017	t
2017-10-22	22	7	Domingo	42	4	2	10	Octubre	4	2	2017	t
2017-10-23	23	1	Lunes	43	5	2	10	Octubre	4	2	2017	f
2017-10-24	24	2	Martes	43	5	2	10	Octubre	4	2	2017	f
2017-10-25	25	3	Miércoles	43	5	2	10	Octubre	4	2	2017	f
2017-10-26	26	4	Jueves	43	5	2	10	Octubre	4	2	2017	f
2017-10-27	27	5	Viernes	43	5	2	10	Octubre	4	2	2017	f
2017-10-28	28	6	Sábado	43	5	2	10	Octubre	4	2	2017	t
2017-10-29	29	7	Domingo	43	5	2	10	Octubre	4	2	2017	t
2017-10-30	30	1	Lunes	44	6	2	10	Octubre	4	2	2017	f
2017-10-31	31	2	Martes	44	6	2	10	Octubre	4	2	2017	f
2017-11-01	1	3	Miércoles	44	1	1	11	Noviembre	4	2	2017	f
2017-11-02	2	4	Jueves	44	1	1	11	Noviembre	4	2	2017	f
2017-11-03	3	5	Viernes	44	1	1	11	Noviembre	4	2	2017	f
2017-11-04	4	6	Sábado	44	1	1	11	Noviembre	4	2	2017	t
2017-11-05	5	7	Domingo	44	1	1	11	Noviembre	4	2	2017	t
2017-11-06	6	1	Lunes	45	2	1	11	Noviembre	4	2	2017	f
2017-11-07	7	2	Martes	45	2	1	11	Noviembre	4	2	2017	f
2017-11-08	8	3	Miércoles	45	2	1	11	Noviembre	4	2	2017	f
2017-11-09	9	4	Jueves	45	2	1	11	Noviembre	4	2	2017	f
2017-11-10	10	5	Viernes	45	2	1	11	Noviembre	4	2	2017	f
2017-11-11	11	6	Sábado	45	2	1	11	Noviembre	4	2	2017	t
2017-11-12	12	7	Domingo	45	2	1	11	Noviembre	4	2	2017	t
2017-11-13	13	1	Lunes	46	3	1	11	Noviembre	4	2	2017	f
2017-11-14	14	2	Martes	46	3	1	11	Noviembre	4	2	2017	f
2017-11-15	15	3	Miércoles	46	3	1	11	Noviembre	4	2	2017	f
2017-11-16	16	4	Jueves	46	3	2	11	Noviembre	4	2	2017	f
2017-11-17	17	5	Viernes	46	3	2	11	Noviembre	4	2	2017	f
2017-11-18	18	6	Sábado	46	3	2	11	Noviembre	4	2	2017	t
2017-11-19	19	7	Domingo	46	3	2	11	Noviembre	4	2	2017	t
2017-11-20	20	1	Lunes	47	4	2	11	Noviembre	4	2	2017	f
2017-11-21	21	2	Martes	47	4	2	11	Noviembre	4	2	2017	f
2017-11-22	22	3	Miércoles	47	4	2	11	Noviembre	4	2	2017	f
2017-11-23	23	4	Jueves	47	4	2	11	Noviembre	4	2	2017	f
2017-11-24	24	5	Viernes	47	4	2	11	Noviembre	4	2	2017	f
2017-11-25	25	6	Sábado	47	4	2	11	Noviembre	4	2	2017	t
2017-11-26	26	7	Domingo	47	4	2	11	Noviembre	4	2	2017	t
2017-11-27	27	1	Lunes	48	5	2	11	Noviembre	4	2	2017	f
2017-11-28	28	2	Martes	48	5	2	11	Noviembre	4	2	2017	f
2017-11-29	29	3	Miércoles	48	5	2	11	Noviembre	4	2	2017	f
2017-11-30	30	4	Jueves	48	5	2	11	Noviembre	4	2	2017	f
2017-12-01	1	5	Viernes	48	1	1	12	Diciembre	4	2	2017	f
2017-12-02	2	6	Sábado	48	1	1	12	Diciembre	4	2	2017	t
2017-12-03	3	7	Domingo	48	1	1	12	Diciembre	4	2	2017	t
2017-12-04	4	1	Lunes	49	2	1	12	Diciembre	4	2	2017	f
2017-12-05	5	2	Martes	49	2	1	12	Diciembre	4	2	2017	f
2017-12-06	6	3	Miércoles	49	2	1	12	Diciembre	4	2	2017	f
2017-12-07	7	4	Jueves	49	2	1	12	Diciembre	4	2	2017	f
2017-12-08	8	5	Viernes	49	2	1	12	Diciembre	4	2	2017	f
2017-12-09	9	6	Sábado	49	2	1	12	Diciembre	4	2	2017	t
2017-12-10	10	7	Domingo	49	2	1	12	Diciembre	4	2	2017	t
2017-12-11	11	1	Lunes	50	3	1	12	Diciembre	4	2	2017	f
2017-12-12	12	2	Martes	50	3	1	12	Diciembre	4	2	2017	f
2017-12-13	13	3	Miércoles	50	3	1	12	Diciembre	4	2	2017	f
2017-12-14	14	4	Jueves	50	3	1	12	Diciembre	4	2	2017	f
2017-12-15	15	5	Viernes	50	3	1	12	Diciembre	4	2	2017	f
2017-12-16	16	6	Sábado	50	3	2	12	Diciembre	4	2	2017	t
2017-12-17	17	7	Domingo	50	3	2	12	Diciembre	4	2	2017	t
2017-12-18	18	1	Lunes	51	4	2	12	Diciembre	4	2	2017	f
2017-12-19	19	2	Martes	51	4	2	12	Diciembre	4	2	2017	f
2017-12-20	20	3	Miércoles	51	4	2	12	Diciembre	4	2	2017	f
2017-12-21	21	4	Jueves	51	4	2	12	Diciembre	4	2	2017	f
2017-12-22	22	5	Viernes	51	4	2	12	Diciembre	4	2	2017	f
2017-12-23	23	6	Sábado	51	4	2	12	Diciembre	4	2	2017	t
2017-12-24	24	7	Domingo	51	4	2	12	Diciembre	4	2	2017	t
2017-12-25	25	1	Lunes	52	5	2	12	Diciembre	4	2	2017	f
2017-12-26	26	2	Martes	52	5	2	12	Diciembre	4	2	2017	f
2017-12-27	27	3	Miércoles	52	5	2	12	Diciembre	4	2	2017	f
2017-12-28	28	4	Jueves	52	5	2	12	Diciembre	4	2	2017	f
2017-12-29	29	5	Viernes	52	5	2	12	Diciembre	4	2	2017	f
2017-12-30	30	6	Sábado	52	5	2	12	Diciembre	4	2	2017	t
2017-12-31	31	7	Domingo	52	5	2	12	Diciembre	4	2	2017	t
2018-01-01	1	1	Lunes	1	1	1	1	Enero	1	1	2018	f
2018-01-02	2	2	Martes	1	1	1	1	Enero	1	1	2018	f
2018-01-03	3	3	Miércoles	1	1	1	1	Enero	1	1	2018	f
2018-01-04	4	4	Jueves	1	1	1	1	Enero	1	1	2018	f
2018-01-05	5	5	Viernes	1	1	1	1	Enero	1	1	2018	f
2018-01-06	6	6	Sábado	1	1	1	1	Enero	1	1	2018	t
2018-01-07	7	7	Domingo	1	1	1	1	Enero	1	1	2018	t
2018-01-08	8	1	Lunes	2	2	1	1	Enero	1	1	2018	f
2018-01-09	9	2	Martes	2	2	1	1	Enero	1	1	2018	f
2018-01-10	10	3	Miércoles	2	2	1	1	Enero	1	1	2018	f
2018-01-11	11	4	Jueves	2	2	1	1	Enero	1	1	2018	f
2018-01-12	12	5	Viernes	2	2	1	1	Enero	1	1	2018	f
2018-01-13	13	6	Sábado	2	2	1	1	Enero	1	1	2018	t
2018-01-14	14	7	Domingo	2	2	1	1	Enero	1	1	2018	t
2018-01-15	15	1	Lunes	3	3	1	1	Enero	1	1	2018	f
2018-01-16	16	2	Martes	3	3	2	1	Enero	1	1	2018	f
2018-01-17	17	3	Miércoles	3	3	2	1	Enero	1	1	2018	f
2018-01-18	18	4	Jueves	3	3	2	1	Enero	1	1	2018	f
2018-01-19	19	5	Viernes	3	3	2	1	Enero	1	1	2018	f
2018-01-20	20	6	Sábado	3	3	2	1	Enero	1	1	2018	t
2018-01-21	21	7	Domingo	3	3	2	1	Enero	1	1	2018	t
2018-01-22	22	1	Lunes	4	4	2	1	Enero	1	1	2018	f
2018-01-23	23	2	Martes	4	4	2	1	Enero	1	1	2018	f
2018-01-24	24	3	Miércoles	4	4	2	1	Enero	1	1	2018	f
2018-01-25	25	4	Jueves	4	4	2	1	Enero	1	1	2018	f
2018-01-26	26	5	Viernes	4	4	2	1	Enero	1	1	2018	f
2018-01-27	27	6	Sábado	4	4	2	1	Enero	1	1	2018	t
2018-01-28	28	7	Domingo	4	4	2	1	Enero	1	1	2018	t
2018-01-29	29	1	Lunes	5	5	2	1	Enero	1	1	2018	f
2018-01-30	30	2	Martes	5	5	2	1	Enero	1	1	2018	f
2018-01-31	31	3	Miércoles	5	5	2	1	Enero	1	1	2018	f
2018-02-01	1	4	Jueves	5	1	1	2	Febrero	1	1	2018	f
2018-02-02	2	5	Viernes	5	1	1	2	Febrero	1	1	2018	f
2018-02-03	3	6	Sábado	5	1	1	2	Febrero	1	1	2018	t
2018-02-04	4	7	Domingo	5	1	1	2	Febrero	1	1	2018	t
2018-02-05	5	1	Lunes	6	2	1	2	Febrero	1	1	2018	f
2018-02-06	6	2	Martes	6	2	1	2	Febrero	1	1	2018	f
2018-02-07	7	3	Miércoles	6	2	1	2	Febrero	1	1	2018	f
2018-02-08	8	4	Jueves	6	2	1	2	Febrero	1	1	2018	f
2018-02-09	9	5	Viernes	6	2	1	2	Febrero	1	1	2018	f
2018-02-10	10	6	Sábado	6	2	1	2	Febrero	1	1	2018	t
2018-02-11	11	7	Domingo	6	2	1	2	Febrero	1	1	2018	t
2018-02-12	12	1	Lunes	7	3	1	2	Febrero	1	1	2018	f
2018-02-13	13	2	Martes	7	3	1	2	Febrero	1	1	2018	f
2018-02-14	14	3	Miércoles	7	3	1	2	Febrero	1	1	2018	f
2018-02-15	15	4	Jueves	7	3	1	2	Febrero	1	1	2018	f
2018-02-16	16	5	Viernes	7	3	2	2	Febrero	1	1	2018	f
2018-02-17	17	6	Sábado	7	3	2	2	Febrero	1	1	2018	t
2018-02-18	18	7	Domingo	7	3	2	2	Febrero	1	1	2018	t
2018-02-19	19	1	Lunes	8	4	2	2	Febrero	1	1	2018	f
2018-02-20	20	2	Martes	8	4	2	2	Febrero	1	1	2018	f
2018-02-21	21	3	Miércoles	8	4	2	2	Febrero	1	1	2018	f
2018-02-22	22	4	Jueves	8	4	2	2	Febrero	1	1	2018	f
2018-02-23	23	5	Viernes	8	4	2	2	Febrero	1	1	2018	f
2018-02-24	24	6	Sábado	8	4	2	2	Febrero	1	1	2018	t
2018-02-25	25	7	Domingo	8	4	2	2	Febrero	1	1	2018	t
2018-02-26	26	1	Lunes	9	5	2	2	Febrero	1	1	2018	f
2018-02-27	27	2	Martes	9	5	2	2	Febrero	1	1	2018	f
2018-02-28	28	3	Miércoles	9	5	2	2	Febrero	1	1	2018	f
2018-03-01	1	4	Jueves	9	1	1	3	Marzo	1	1	2018	f
2018-03-02	2	5	Viernes	9	1	1	3	Marzo	1	1	2018	f
2018-03-03	3	6	Sábado	9	1	1	3	Marzo	1	1	2018	t
2018-03-04	4	7	Domingo	9	1	1	3	Marzo	1	1	2018	t
2018-03-05	5	1	Lunes	10	2	1	3	Marzo	1	1	2018	f
2018-03-06	6	2	Martes	10	2	1	3	Marzo	1	1	2018	f
2018-03-07	7	3	Miércoles	10	2	1	3	Marzo	1	1	2018	f
2018-03-08	8	4	Jueves	10	2	1	3	Marzo	1	1	2018	f
2018-03-09	9	5	Viernes	10	2	1	3	Marzo	1	1	2018	f
2018-03-10	10	6	Sábado	10	2	1	3	Marzo	1	1	2018	t
2018-03-11	11	7	Domingo	10	2	1	3	Marzo	1	1	2018	t
2018-03-12	12	1	Lunes	11	3	1	3	Marzo	1	1	2018	f
2018-03-13	13	2	Martes	11	3	1	3	Marzo	1	1	2018	f
2018-03-14	14	3	Miércoles	11	3	1	3	Marzo	1	1	2018	f
2018-03-15	15	4	Jueves	11	3	1	3	Marzo	1	1	2018	f
2018-03-16	16	5	Viernes	11	3	2	3	Marzo	1	1	2018	f
2018-03-17	17	6	Sábado	11	3	2	3	Marzo	1	1	2018	t
2018-03-18	18	7	Domingo	11	3	2	3	Marzo	1	1	2018	t
2018-03-19	19	1	Lunes	12	4	2	3	Marzo	1	1	2018	f
2018-03-20	20	2	Martes	12	4	2	3	Marzo	1	1	2018	f
2018-03-21	21	3	Miércoles	12	4	2	3	Marzo	1	1	2018	f
2018-03-22	22	4	Jueves	12	4	2	3	Marzo	1	1	2018	f
2018-03-23	23	5	Viernes	12	4	2	3	Marzo	1	1	2018	f
2018-03-24	24	6	Sábado	12	4	2	3	Marzo	1	1	2018	t
2018-03-25	25	7	Domingo	12	4	2	3	Marzo	1	1	2018	t
2018-03-26	26	1	Lunes	13	5	2	3	Marzo	1	1	2018	f
2018-03-27	27	2	Martes	13	5	2	3	Marzo	1	1	2018	f
2018-03-28	28	3	Miércoles	13	5	2	3	Marzo	1	1	2018	f
2018-03-29	29	4	Jueves	13	5	2	3	Marzo	1	1	2018	f
2018-03-30	30	5	Viernes	13	5	2	3	Marzo	1	1	2018	f
2018-03-31	31	6	Sábado	13	5	2	3	Marzo	1	1	2018	t
2018-04-01	1	7	Domingo	13	1	1	4	Abril	2	1	2018	t
2018-04-02	2	1	Lunes	14	2	1	4	Abril	2	1	2018	f
2018-04-03	3	2	Martes	14	2	1	4	Abril	2	1	2018	f
2018-04-04	4	3	Miércoles	14	2	1	4	Abril	2	1	2018	f
2018-04-05	5	4	Jueves	14	2	1	4	Abril	2	1	2018	f
2018-04-06	6	5	Viernes	14	2	1	4	Abril	2	1	2018	f
2018-04-07	7	6	Sábado	14	2	1	4	Abril	2	1	2018	t
2018-04-08	8	7	Domingo	14	2	1	4	Abril	2	1	2018	t
2018-04-09	9	1	Lunes	15	3	1	4	Abril	2	1	2018	f
2018-04-10	10	2	Martes	15	3	1	4	Abril	2	1	2018	f
2018-04-11	11	3	Miércoles	15	3	1	4	Abril	2	1	2018	f
2018-04-12	12	4	Jueves	15	3	1	4	Abril	2	1	2018	f
2018-04-13	13	5	Viernes	15	3	1	4	Abril	2	1	2018	f
2018-04-14	14	6	Sábado	15	3	1	4	Abril	2	1	2018	t
2018-04-15	15	7	Domingo	15	3	1	4	Abril	2	1	2018	t
2018-04-16	16	1	Lunes	16	4	2	4	Abril	2	1	2018	f
2018-04-17	17	2	Martes	16	4	2	4	Abril	2	1	2018	f
2018-04-18	18	3	Miércoles	16	4	2	4	Abril	2	1	2018	f
2018-04-19	19	4	Jueves	16	4	2	4	Abril	2	1	2018	f
2018-04-20	20	5	Viernes	16	4	2	4	Abril	2	1	2018	f
2018-04-21	21	6	Sábado	16	4	2	4	Abril	2	1	2018	t
2018-04-22	22	7	Domingo	16	4	2	4	Abril	2	1	2018	t
2018-04-23	23	1	Lunes	17	5	2	4	Abril	2	1	2018	f
2018-04-24	24	2	Martes	17	5	2	4	Abril	2	1	2018	f
2018-04-25	25	3	Miércoles	17	5	2	4	Abril	2	1	2018	f
2018-04-26	26	4	Jueves	17	5	2	4	Abril	2	1	2018	f
2018-04-27	27	5	Viernes	17	5	2	4	Abril	2	1	2018	f
2018-04-28	28	6	Sábado	17	5	2	4	Abril	2	1	2018	t
2018-04-29	29	7	Domingo	17	5	2	4	Abril	2	1	2018	t
2018-04-30	30	1	Lunes	18	6	2	4	Abril	2	1	2018	f
2018-05-01	1	2	Martes	18	1	1	5	Mayo	2	1	2018	f
2018-05-02	2	3	Miércoles	18	1	1	5	Mayo	2	1	2018	f
2018-05-03	3	4	Jueves	18	1	1	5	Mayo	2	1	2018	f
2018-05-04	4	5	Viernes	18	1	1	5	Mayo	2	1	2018	f
2018-05-05	5	6	Sábado	18	1	1	5	Mayo	2	1	2018	t
2018-05-06	6	7	Domingo	18	1	1	5	Mayo	2	1	2018	t
2018-05-07	7	1	Lunes	19	2	1	5	Mayo	2	1	2018	f
2018-05-08	8	2	Martes	19	2	1	5	Mayo	2	1	2018	f
2018-05-09	9	3	Miércoles	19	2	1	5	Mayo	2	1	2018	f
2018-05-10	10	4	Jueves	19	2	1	5	Mayo	2	1	2018	f
2018-05-11	11	5	Viernes	19	2	1	5	Mayo	2	1	2018	f
2018-05-12	12	6	Sábado	19	2	1	5	Mayo	2	1	2018	t
2018-05-13	13	7	Domingo	19	2	1	5	Mayo	2	1	2018	t
2018-05-14	14	1	Lunes	20	3	1	5	Mayo	2	1	2018	f
2018-05-15	15	2	Martes	20	3	1	5	Mayo	2	1	2018	f
2018-05-16	16	3	Miércoles	20	3	2	5	Mayo	2	1	2018	f
2018-05-17	17	4	Jueves	20	3	2	5	Mayo	2	1	2018	f
2018-05-18	18	5	Viernes	20	3	2	5	Mayo	2	1	2018	f
2018-05-19	19	6	Sábado	20	3	2	5	Mayo	2	1	2018	t
2018-05-20	20	7	Domingo	20	3	2	5	Mayo	2	1	2018	t
2018-05-21	21	1	Lunes	21	4	2	5	Mayo	2	1	2018	f
2018-05-22	22	2	Martes	21	4	2	5	Mayo	2	1	2018	f
2018-05-23	23	3	Miércoles	21	4	2	5	Mayo	2	1	2018	f
2018-05-24	24	4	Jueves	21	4	2	5	Mayo	2	1	2018	f
2018-05-25	25	5	Viernes	21	4	2	5	Mayo	2	1	2018	f
2018-05-26	26	6	Sábado	21	4	2	5	Mayo	2	1	2018	t
2018-05-27	27	7	Domingo	21	4	2	5	Mayo	2	1	2018	t
2018-05-28	28	1	Lunes	22	5	2	5	Mayo	2	1	2018	f
2018-05-29	29	2	Martes	22	5	2	5	Mayo	2	1	2018	f
2018-05-30	30	3	Miércoles	22	5	2	5	Mayo	2	1	2018	f
2018-05-31	31	4	Jueves	22	5	2	5	Mayo	2	1	2018	f
2018-06-01	1	5	Viernes	22	1	1	6	Junio	2	1	2018	f
2018-06-02	2	6	Sábado	22	1	1	6	Junio	2	1	2018	t
2018-06-03	3	7	Domingo	22	1	1	6	Junio	2	1	2018	t
2018-06-04	4	1	Lunes	23	2	1	6	Junio	2	1	2018	f
2018-06-05	5	2	Martes	23	2	1	6	Junio	2	1	2018	f
2018-06-06	6	3	Miércoles	23	2	1	6	Junio	2	1	2018	f
2018-06-07	7	4	Jueves	23	2	1	6	Junio	2	1	2018	f
2018-06-08	8	5	Viernes	23	2	1	6	Junio	2	1	2018	f
2018-06-09	9	6	Sábado	23	2	1	6	Junio	2	1	2018	t
2018-06-10	10	7	Domingo	23	2	1	6	Junio	2	1	2018	t
2018-06-11	11	1	Lunes	24	3	1	6	Junio	2	1	2018	f
2018-06-12	12	2	Martes	24	3	1	6	Junio	2	1	2018	f
2018-06-13	13	3	Miércoles	24	3	1	6	Junio	2	1	2018	f
2018-06-14	14	4	Jueves	24	3	1	6	Junio	2	1	2018	f
2018-06-15	15	5	Viernes	24	3	1	6	Junio	2	1	2018	f
2018-06-16	16	6	Sábado	24	3	2	6	Junio	2	1	2018	t
2018-06-17	17	7	Domingo	24	3	2	6	Junio	2	1	2018	t
2018-06-18	18	1	Lunes	25	4	2	6	Junio	2	1	2018	f
2018-06-19	19	2	Martes	25	4	2	6	Junio	2	1	2018	f
2018-06-20	20	3	Miércoles	25	4	2	6	Junio	2	1	2018	f
2018-06-21	21	4	Jueves	25	4	2	6	Junio	2	1	2018	f
2018-06-22	22	5	Viernes	25	4	2	6	Junio	2	1	2018	f
2018-06-23	23	6	Sábado	25	4	2	6	Junio	2	1	2018	t
2018-06-24	24	7	Domingo	25	4	2	6	Junio	2	1	2018	t
2018-06-25	25	1	Lunes	26	5	2	6	Junio	2	1	2018	f
2018-06-26	26	2	Martes	26	5	2	6	Junio	2	1	2018	f
2018-06-27	27	3	Miércoles	26	5	2	6	Junio	2	1	2018	f
2018-06-28	28	4	Jueves	26	5	2	6	Junio	2	1	2018	f
2018-06-29	29	5	Viernes	26	5	2	6	Junio	2	1	2018	f
2018-06-30	30	6	Sábado	26	5	2	6	Junio	2	1	2018	t
2018-07-01	1	7	Domingo	26	1	1	7	Julio	3	2	2018	t
2018-07-02	2	1	Lunes	27	2	1	7	Julio	3	2	2018	f
2018-07-03	3	2	Martes	27	2	1	7	Julio	3	2	2018	f
2018-07-04	4	3	Miércoles	27	2	1	7	Julio	3	2	2018	f
2018-07-05	5	4	Jueves	27	2	1	7	Julio	3	2	2018	f
2018-07-06	6	5	Viernes	27	2	1	7	Julio	3	2	2018	f
2018-07-07	7	6	Sábado	27	2	1	7	Julio	3	2	2018	t
2018-07-08	8	7	Domingo	27	2	1	7	Julio	3	2	2018	t
2018-07-09	9	1	Lunes	28	3	1	7	Julio	3	2	2018	f
2018-07-10	10	2	Martes	28	3	1	7	Julio	3	2	2018	f
2018-07-11	11	3	Miércoles	28	3	1	7	Julio	3	2	2018	f
2018-07-12	12	4	Jueves	28	3	1	7	Julio	3	2	2018	f
2018-07-13	13	5	Viernes	28	3	1	7	Julio	3	2	2018	f
2018-07-14	14	6	Sábado	28	3	1	7	Julio	3	2	2018	t
2018-07-15	15	7	Domingo	28	3	1	7	Julio	3	2	2018	t
2018-07-16	16	1	Lunes	29	4	2	7	Julio	3	2	2018	f
2018-07-17	17	2	Martes	29	4	2	7	Julio	3	2	2018	f
2018-07-18	18	3	Miércoles	29	4	2	7	Julio	3	2	2018	f
2018-07-19	19	4	Jueves	29	4	2	7	Julio	3	2	2018	f
2018-07-20	20	5	Viernes	29	4	2	7	Julio	3	2	2018	f
2018-07-21	21	6	Sábado	29	4	2	7	Julio	3	2	2018	t
2018-07-22	22	7	Domingo	29	4	2	7	Julio	3	2	2018	t
2018-07-23	23	1	Lunes	30	5	2	7	Julio	3	2	2018	f
2018-07-24	24	2	Martes	30	5	2	7	Julio	3	2	2018	f
2018-07-25	25	3	Miércoles	30	5	2	7	Julio	3	2	2018	f
2018-07-26	26	4	Jueves	30	5	2	7	Julio	3	2	2018	f
2018-07-27	27	5	Viernes	30	5	2	7	Julio	3	2	2018	f
2018-07-28	28	6	Sábado	30	5	2	7	Julio	3	2	2018	t
2018-07-29	29	7	Domingo	30	5	2	7	Julio	3	2	2018	t
2018-07-30	30	1	Lunes	31	6	2	7	Julio	3	2	2018	f
2018-07-31	31	2	Martes	31	6	2	7	Julio	3	2	2018	f
2018-08-01	1	3	Miércoles	31	1	1	8	Agosto	3	2	2018	f
2018-08-02	2	4	Jueves	31	1	1	8	Agosto	3	2	2018	f
2018-08-03	3	5	Viernes	31	1	1	8	Agosto	3	2	2018	f
2018-08-04	4	6	Sábado	31	1	1	8	Agosto	3	2	2018	t
2018-08-05	5	7	Domingo	31	1	1	8	Agosto	3	2	2018	t
2018-08-06	6	1	Lunes	32	2	1	8	Agosto	3	2	2018	f
2018-08-07	7	2	Martes	32	2	1	8	Agosto	3	2	2018	f
2018-08-08	8	3	Miércoles	32	2	1	8	Agosto	3	2	2018	f
2018-08-09	9	4	Jueves	32	2	1	8	Agosto	3	2	2018	f
2018-08-10	10	5	Viernes	32	2	1	8	Agosto	3	2	2018	f
2018-08-11	11	6	Sábado	32	2	1	8	Agosto	3	2	2018	t
2018-08-12	12	7	Domingo	32	2	1	8	Agosto	3	2	2018	t
2018-08-13	13	1	Lunes	33	3	1	8	Agosto	3	2	2018	f
2018-08-14	14	2	Martes	33	3	1	8	Agosto	3	2	2018	f
2018-08-15	15	3	Miércoles	33	3	1	8	Agosto	3	2	2018	f
2018-08-16	16	4	Jueves	33	3	2	8	Agosto	3	2	2018	f
2018-08-17	17	5	Viernes	33	3	2	8	Agosto	3	2	2018	f
2018-08-18	18	6	Sábado	33	3	2	8	Agosto	3	2	2018	t
2018-08-19	19	7	Domingo	33	3	2	8	Agosto	3	2	2018	t
2018-08-20	20	1	Lunes	34	4	2	8	Agosto	3	2	2018	f
2018-08-21	21	2	Martes	34	4	2	8	Agosto	3	2	2018	f
2018-08-22	22	3	Miércoles	34	4	2	8	Agosto	3	2	2018	f
2018-08-23	23	4	Jueves	34	4	2	8	Agosto	3	2	2018	f
2018-08-24	24	5	Viernes	34	4	2	8	Agosto	3	2	2018	f
2018-08-25	25	6	Sábado	34	4	2	8	Agosto	3	2	2018	t
2018-08-26	26	7	Domingo	34	4	2	8	Agosto	3	2	2018	t
2018-08-27	27	1	Lunes	35	5	2	8	Agosto	3	2	2018	f
2018-08-28	28	2	Martes	35	5	2	8	Agosto	3	2	2018	f
2018-08-29	29	3	Miércoles	35	5	2	8	Agosto	3	2	2018	f
2018-08-30	30	4	Jueves	35	5	2	8	Agosto	3	2	2018	f
2018-08-31	31	5	Viernes	35	5	2	8	Agosto	3	2	2018	f
2018-09-01	1	6	Sábado	35	1	1	9	Septiembre	3	2	2018	t
2018-09-02	2	7	Domingo	35	1	1	9	Septiembre	3	2	2018	t
2018-09-03	3	1	Lunes	36	2	1	9	Septiembre	3	2	2018	f
2018-09-04	4	2	Martes	36	2	1	9	Septiembre	3	2	2018	f
2018-09-05	5	3	Miércoles	36	2	1	9	Septiembre	3	2	2018	f
2018-09-06	6	4	Jueves	36	2	1	9	Septiembre	3	2	2018	f
2018-09-07	7	5	Viernes	36	2	1	9	Septiembre	3	2	2018	f
2018-09-08	8	6	Sábado	36	2	1	9	Septiembre	3	2	2018	t
2018-09-09	9	7	Domingo	36	2	1	9	Septiembre	3	2	2018	t
2018-09-10	10	1	Lunes	37	3	1	9	Septiembre	3	2	2018	f
2018-09-11	11	2	Martes	37	3	1	9	Septiembre	3	2	2018	f
2018-09-12	12	3	Miércoles	37	3	1	9	Septiembre	3	2	2018	f
2018-09-13	13	4	Jueves	37	3	1	9	Septiembre	3	2	2018	f
2018-09-14	14	5	Viernes	37	3	1	9	Septiembre	3	2	2018	f
2018-09-15	15	6	Sábado	37	3	1	9	Septiembre	3	2	2018	t
2018-09-16	16	7	Domingo	37	3	2	9	Septiembre	3	2	2018	t
2018-09-17	17	1	Lunes	38	4	2	9	Septiembre	3	2	2018	f
2018-09-18	18	2	Martes	38	4	2	9	Septiembre	3	2	2018	f
2018-09-19	19	3	Miércoles	38	4	2	9	Septiembre	3	2	2018	f
2018-09-20	20	4	Jueves	38	4	2	9	Septiembre	3	2	2018	f
2018-09-21	21	5	Viernes	38	4	2	9	Septiembre	3	2	2018	f
2018-09-22	22	6	Sábado	38	4	2	9	Septiembre	3	2	2018	t
2018-09-23	23	7	Domingo	38	4	2	9	Septiembre	3	2	2018	t
2018-09-24	24	1	Lunes	39	5	2	9	Septiembre	3	2	2018	f
2018-09-25	25	2	Martes	39	5	2	9	Septiembre	3	2	2018	f
2018-09-26	26	3	Miércoles	39	5	2	9	Septiembre	3	2	2018	f
2018-09-27	27	4	Jueves	39	5	2	9	Septiembre	3	2	2018	f
2018-09-28	28	5	Viernes	39	5	2	9	Septiembre	3	2	2018	f
2018-09-29	29	6	Sábado	39	5	2	9	Septiembre	3	2	2018	t
2018-09-30	30	7	Domingo	39	5	2	9	Septiembre	3	2	2018	t
2018-10-01	1	1	Lunes	40	1	1	10	Octubre	4	2	2018	f
2018-10-02	2	2	Martes	40	1	1	10	Octubre	4	2	2018	f
2018-10-03	3	3	Miércoles	40	1	1	10	Octubre	4	2	2018	f
2018-10-04	4	4	Jueves	40	1	1	10	Octubre	4	2	2018	f
2018-10-05	5	5	Viernes	40	1	1	10	Octubre	4	2	2018	f
2018-10-06	6	6	Sábado	40	1	1	10	Octubre	4	2	2018	t
2018-10-07	7	7	Domingo	40	1	1	10	Octubre	4	2	2018	t
2018-10-08	8	1	Lunes	41	2	1	10	Octubre	4	2	2018	f
2018-10-09	9	2	Martes	41	2	1	10	Octubre	4	2	2018	f
2018-10-10	10	3	Miércoles	41	2	1	10	Octubre	4	2	2018	f
2018-10-11	11	4	Jueves	41	2	1	10	Octubre	4	2	2018	f
2018-10-12	12	5	Viernes	41	2	1	10	Octubre	4	2	2018	f
2018-10-13	13	6	Sábado	41	2	1	10	Octubre	4	2	2018	t
2018-10-14	14	7	Domingo	41	2	1	10	Octubre	4	2	2018	t
2018-10-15	15	1	Lunes	42	3	1	10	Octubre	4	2	2018	f
2018-10-16	16	2	Martes	42	3	2	10	Octubre	4	2	2018	f
2018-10-17	17	3	Miércoles	42	3	2	10	Octubre	4	2	2018	f
2018-10-18	18	4	Jueves	42	3	2	10	Octubre	4	2	2018	f
2018-10-19	19	5	Viernes	42	3	2	10	Octubre	4	2	2018	f
2018-10-20	20	6	Sábado	42	3	2	10	Octubre	4	2	2018	t
2018-10-21	21	7	Domingo	42	3	2	10	Octubre	4	2	2018	t
2018-10-22	22	1	Lunes	43	4	2	10	Octubre	4	2	2018	f
2018-10-23	23	2	Martes	43	4	2	10	Octubre	4	2	2018	f
2018-10-24	24	3	Miércoles	43	4	2	10	Octubre	4	2	2018	f
2018-10-25	25	4	Jueves	43	4	2	10	Octubre	4	2	2018	f
2018-10-26	26	5	Viernes	43	4	2	10	Octubre	4	2	2018	f
2018-10-27	27	6	Sábado	43	4	2	10	Octubre	4	2	2018	t
2018-10-28	28	7	Domingo	43	4	2	10	Octubre	4	2	2018	t
2018-10-29	29	1	Lunes	44	5	2	10	Octubre	4	2	2018	f
2018-10-30	30	2	Martes	44	5	2	10	Octubre	4	2	2018	f
2018-10-31	31	3	Miércoles	44	5	2	10	Octubre	4	2	2018	f
2018-11-01	1	4	Jueves	44	1	1	11	Noviembre	4	2	2018	f
2018-11-02	2	5	Viernes	44	1	1	11	Noviembre	4	2	2018	f
2018-11-03	3	6	Sábado	44	1	1	11	Noviembre	4	2	2018	t
2018-11-04	4	7	Domingo	44	1	1	11	Noviembre	4	2	2018	t
2018-11-05	5	1	Lunes	45	2	1	11	Noviembre	4	2	2018	f
2018-11-06	6	2	Martes	45	2	1	11	Noviembre	4	2	2018	f
2018-11-07	7	3	Miércoles	45	2	1	11	Noviembre	4	2	2018	f
2018-11-08	8	4	Jueves	45	2	1	11	Noviembre	4	2	2018	f
2018-11-09	9	5	Viernes	45	2	1	11	Noviembre	4	2	2018	f
2018-11-10	10	6	Sábado	45	2	1	11	Noviembre	4	2	2018	t
2018-11-11	11	7	Domingo	45	2	1	11	Noviembre	4	2	2018	t
2018-11-12	12	1	Lunes	46	3	1	11	Noviembre	4	2	2018	f
2018-11-13	13	2	Martes	46	3	1	11	Noviembre	4	2	2018	f
2018-11-14	14	3	Miércoles	46	3	1	11	Noviembre	4	2	2018	f
2018-11-15	15	4	Jueves	46	3	1	11	Noviembre	4	2	2018	f
2018-11-16	16	5	Viernes	46	3	2	11	Noviembre	4	2	2018	f
2018-11-17	17	6	Sábado	46	3	2	11	Noviembre	4	2	2018	t
2018-11-18	18	7	Domingo	46	3	2	11	Noviembre	4	2	2018	t
2018-11-19	19	1	Lunes	47	4	2	11	Noviembre	4	2	2018	f
2018-11-20	20	2	Martes	47	4	2	11	Noviembre	4	2	2018	f
2018-11-21	21	3	Miércoles	47	4	2	11	Noviembre	4	2	2018	f
2018-11-22	22	4	Jueves	47	4	2	11	Noviembre	4	2	2018	f
2018-11-23	23	5	Viernes	47	4	2	11	Noviembre	4	2	2018	f
2018-11-24	24	6	Sábado	47	4	2	11	Noviembre	4	2	2018	t
2018-11-25	25	7	Domingo	47	4	2	11	Noviembre	4	2	2018	t
2018-11-26	26	1	Lunes	48	5	2	11	Noviembre	4	2	2018	f
2018-11-27	27	2	Martes	48	5	2	11	Noviembre	4	2	2018	f
2018-11-28	28	3	Miércoles	48	5	2	11	Noviembre	4	2	2018	f
2018-11-29	29	4	Jueves	48	5	2	11	Noviembre	4	2	2018	f
2018-11-30	30	5	Viernes	48	5	2	11	Noviembre	4	2	2018	f
2018-12-01	1	6	Sábado	48	1	1	12	Diciembre	4	2	2018	t
2018-12-02	2	7	Domingo	48	1	1	12	Diciembre	4	2	2018	t
2018-12-03	3	1	Lunes	49	2	1	12	Diciembre	4	2	2018	f
2018-12-04	4	2	Martes	49	2	1	12	Diciembre	4	2	2018	f
2018-12-05	5	3	Miércoles	49	2	1	12	Diciembre	4	2	2018	f
2018-12-06	6	4	Jueves	49	2	1	12	Diciembre	4	2	2018	f
2018-12-07	7	5	Viernes	49	2	1	12	Diciembre	4	2	2018	f
2018-12-08	8	6	Sábado	49	2	1	12	Diciembre	4	2	2018	t
2018-12-09	9	7	Domingo	49	2	1	12	Diciembre	4	2	2018	t
2018-12-10	10	1	Lunes	50	3	1	12	Diciembre	4	2	2018	f
2018-12-11	11	2	Martes	50	3	1	12	Diciembre	4	2	2018	f
2018-12-12	12	3	Miércoles	50	3	1	12	Diciembre	4	2	2018	f
2018-12-13	13	4	Jueves	50	3	1	12	Diciembre	4	2	2018	f
2018-12-14	14	5	Viernes	50	3	1	12	Diciembre	4	2	2018	f
2018-12-15	15	6	Sábado	50	3	1	12	Diciembre	4	2	2018	t
2018-12-16	16	7	Domingo	50	3	2	12	Diciembre	4	2	2018	t
2018-12-17	17	1	Lunes	51	4	2	12	Diciembre	4	2	2018	f
2018-12-18	18	2	Martes	51	4	2	12	Diciembre	4	2	2018	f
2018-12-19	19	3	Miércoles	51	4	2	12	Diciembre	4	2	2018	f
2018-12-20	20	4	Jueves	51	4	2	12	Diciembre	4	2	2018	f
2018-12-21	21	5	Viernes	51	4	2	12	Diciembre	4	2	2018	f
2018-12-22	22	6	Sábado	51	4	2	12	Diciembre	4	2	2018	t
2018-12-23	23	7	Domingo	51	4	2	12	Diciembre	4	2	2018	t
2018-12-24	24	1	Lunes	52	5	2	12	Diciembre	4	2	2018	f
2018-12-25	25	2	Martes	52	5	2	12	Diciembre	4	2	2018	f
2018-12-26	26	3	Miércoles	52	5	2	12	Diciembre	4	2	2018	f
2018-12-27	27	4	Jueves	52	5	2	12	Diciembre	4	2	2018	f
2018-12-28	28	5	Viernes	52	5	2	12	Diciembre	4	2	2018	f
2018-12-29	29	6	Sábado	52	5	2	12	Diciembre	4	2	2018	t
2018-12-30	30	7	Domingo	52	5	2	12	Diciembre	4	2	2018	t
2018-12-31	31	1	Lunes	1	6	2	12	Diciembre	4	2	2018	f
2019-01-01	1	2	Martes	1	1	1	1	Enero	1	1	2019	f
2019-01-02	2	3	Miércoles	1	1	1	1	Enero	1	1	2019	f
2019-01-03	3	4	Jueves	1	1	1	1	Enero	1	1	2019	f
2019-01-04	4	5	Viernes	1	1	1	1	Enero	1	1	2019	f
2019-01-05	5	6	Sábado	1	1	1	1	Enero	1	1	2019	t
2019-01-06	6	7	Domingo	1	1	1	1	Enero	1	1	2019	t
2019-01-07	7	1	Lunes	2	2	1	1	Enero	1	1	2019	f
2019-01-08	8	2	Martes	2	2	1	1	Enero	1	1	2019	f
2019-01-09	9	3	Miércoles	2	2	1	1	Enero	1	1	2019	f
2019-01-10	10	4	Jueves	2	2	1	1	Enero	1	1	2019	f
2019-01-11	11	5	Viernes	2	2	1	1	Enero	1	1	2019	f
2019-01-12	12	6	Sábado	2	2	1	1	Enero	1	1	2019	t
2019-01-13	13	7	Domingo	2	2	1	1	Enero	1	1	2019	t
2019-01-14	14	1	Lunes	3	3	1	1	Enero	1	1	2019	f
2019-01-15	15	2	Martes	3	3	1	1	Enero	1	1	2019	f
2019-01-16	16	3	Miércoles	3	3	2	1	Enero	1	1	2019	f
2019-01-17	17	4	Jueves	3	3	2	1	Enero	1	1	2019	f
2019-01-18	18	5	Viernes	3	3	2	1	Enero	1	1	2019	f
2019-01-19	19	6	Sábado	3	3	2	1	Enero	1	1	2019	t
2019-01-20	20	7	Domingo	3	3	2	1	Enero	1	1	2019	t
2019-01-21	21	1	Lunes	4	4	2	1	Enero	1	1	2019	f
2019-01-22	22	2	Martes	4	4	2	1	Enero	1	1	2019	f
2019-01-23	23	3	Miércoles	4	4	2	1	Enero	1	1	2019	f
2019-01-24	24	4	Jueves	4	4	2	1	Enero	1	1	2019	f
2019-01-25	25	5	Viernes	4	4	2	1	Enero	1	1	2019	f
2019-01-26	26	6	Sábado	4	4	2	1	Enero	1	1	2019	t
2019-01-27	27	7	Domingo	4	4	2	1	Enero	1	1	2019	t
2019-01-28	28	1	Lunes	5	5	2	1	Enero	1	1	2019	f
2019-01-29	29	2	Martes	5	5	2	1	Enero	1	1	2019	f
2019-01-30	30	3	Miércoles	5	5	2	1	Enero	1	1	2019	f
2019-01-31	31	4	Jueves	5	5	2	1	Enero	1	1	2019	f
2019-02-01	1	5	Viernes	5	1	1	2	Febrero	1	1	2019	f
2019-02-02	2	6	Sábado	5	1	1	2	Febrero	1	1	2019	t
2019-02-03	3	7	Domingo	5	1	1	2	Febrero	1	1	2019	t
2019-02-04	4	1	Lunes	6	2	1	2	Febrero	1	1	2019	f
2019-02-05	5	2	Martes	6	2	1	2	Febrero	1	1	2019	f
2019-02-06	6	3	Miércoles	6	2	1	2	Febrero	1	1	2019	f
2019-02-07	7	4	Jueves	6	2	1	2	Febrero	1	1	2019	f
2019-02-08	8	5	Viernes	6	2	1	2	Febrero	1	1	2019	f
2019-02-09	9	6	Sábado	6	2	1	2	Febrero	1	1	2019	t
2019-02-10	10	7	Domingo	6	2	1	2	Febrero	1	1	2019	t
2019-02-11	11	1	Lunes	7	3	1	2	Febrero	1	1	2019	f
2019-02-12	12	2	Martes	7	3	1	2	Febrero	1	1	2019	f
2019-02-13	13	3	Miércoles	7	3	1	2	Febrero	1	1	2019	f
2019-02-14	14	4	Jueves	7	3	1	2	Febrero	1	1	2019	f
2019-02-15	15	5	Viernes	7	3	1	2	Febrero	1	1	2019	f
2019-02-16	16	6	Sábado	7	3	2	2	Febrero	1	1	2019	t
2019-02-17	17	7	Domingo	7	3	2	2	Febrero	1	1	2019	t
2019-02-18	18	1	Lunes	8	4	2	2	Febrero	1	1	2019	f
2019-02-19	19	2	Martes	8	4	2	2	Febrero	1	1	2019	f
2019-02-20	20	3	Miércoles	8	4	2	2	Febrero	1	1	2019	f
2019-02-21	21	4	Jueves	8	4	2	2	Febrero	1	1	2019	f
2019-02-22	22	5	Viernes	8	4	2	2	Febrero	1	1	2019	f
2019-02-23	23	6	Sábado	8	4	2	2	Febrero	1	1	2019	t
2019-02-24	24	7	Domingo	8	4	2	2	Febrero	1	1	2019	t
2019-02-25	25	1	Lunes	9	5	2	2	Febrero	1	1	2019	f
2019-02-26	26	2	Martes	9	5	2	2	Febrero	1	1	2019	f
2019-02-27	27	3	Miércoles	9	5	2	2	Febrero	1	1	2019	f
2019-02-28	28	4	Jueves	9	5	2	2	Febrero	1	1	2019	f
2019-03-01	1	5	Viernes	9	1	1	3	Marzo	1	1	2019	f
2019-03-02	2	6	Sábado	9	1	1	3	Marzo	1	1	2019	t
2019-03-03	3	7	Domingo	9	1	1	3	Marzo	1	1	2019	t
2019-03-04	4	1	Lunes	10	2	1	3	Marzo	1	1	2019	f
2019-03-05	5	2	Martes	10	2	1	3	Marzo	1	1	2019	f
2019-03-06	6	3	Miércoles	10	2	1	3	Marzo	1	1	2019	f
2019-03-07	7	4	Jueves	10	2	1	3	Marzo	1	1	2019	f
2019-03-08	8	5	Viernes	10	2	1	3	Marzo	1	1	2019	f
2019-03-09	9	6	Sábado	10	2	1	3	Marzo	1	1	2019	t
2019-03-10	10	7	Domingo	10	2	1	3	Marzo	1	1	2019	t
2019-03-11	11	1	Lunes	11	3	1	3	Marzo	1	1	2019	f
2019-03-12	12	2	Martes	11	3	1	3	Marzo	1	1	2019	f
2019-03-13	13	3	Miércoles	11	3	1	3	Marzo	1	1	2019	f
2019-03-14	14	4	Jueves	11	3	1	3	Marzo	1	1	2019	f
2019-03-15	15	5	Viernes	11	3	1	3	Marzo	1	1	2019	f
2019-03-16	16	6	Sábado	11	3	2	3	Marzo	1	1	2019	t
2019-03-17	17	7	Domingo	11	3	2	3	Marzo	1	1	2019	t
2019-03-18	18	1	Lunes	12	4	2	3	Marzo	1	1	2019	f
2019-03-19	19	2	Martes	12	4	2	3	Marzo	1	1	2019	f
2019-03-20	20	3	Miércoles	12	4	2	3	Marzo	1	1	2019	f
2019-03-21	21	4	Jueves	12	4	2	3	Marzo	1	1	2019	f
2019-03-22	22	5	Viernes	12	4	2	3	Marzo	1	1	2019	f
2019-03-23	23	6	Sábado	12	4	2	3	Marzo	1	1	2019	t
2019-03-24	24	7	Domingo	12	4	2	3	Marzo	1	1	2019	t
2019-03-25	25	1	Lunes	13	5	2	3	Marzo	1	1	2019	f
2019-03-26	26	2	Martes	13	5	2	3	Marzo	1	1	2019	f
2019-03-27	27	3	Miércoles	13	5	2	3	Marzo	1	1	2019	f
2019-03-28	28	4	Jueves	13	5	2	3	Marzo	1	1	2019	f
2019-03-29	29	5	Viernes	13	5	2	3	Marzo	1	1	2019	f
2019-03-30	30	6	Sábado	13	5	2	3	Marzo	1	1	2019	t
2019-03-31	31	7	Domingo	13	5	2	3	Marzo	1	1	2019	t
2019-04-01	1	1	Lunes	14	1	1	4	Abril	2	1	2019	f
2019-04-02	2	2	Martes	14	1	1	4	Abril	2	1	2019	f
2019-04-03	3	3	Miércoles	14	1	1	4	Abril	2	1	2019	f
2019-04-04	4	4	Jueves	14	1	1	4	Abril	2	1	2019	f
2019-04-05	5	5	Viernes	14	1	1	4	Abril	2	1	2019	f
2019-04-06	6	6	Sábado	14	1	1	4	Abril	2	1	2019	t
2019-04-07	7	7	Domingo	14	1	1	4	Abril	2	1	2019	t
2019-04-08	8	1	Lunes	15	2	1	4	Abril	2	1	2019	f
2019-04-09	9	2	Martes	15	2	1	4	Abril	2	1	2019	f
2019-04-10	10	3	Miércoles	15	2	1	4	Abril	2	1	2019	f
2019-04-11	11	4	Jueves	15	2	1	4	Abril	2	1	2019	f
2019-04-12	12	5	Viernes	15	2	1	4	Abril	2	1	2019	f
2019-04-13	13	6	Sábado	15	2	1	4	Abril	2	1	2019	t
2019-04-14	14	7	Domingo	15	2	1	4	Abril	2	1	2019	t
2019-04-15	15	1	Lunes	16	3	1	4	Abril	2	1	2019	f
2019-04-16	16	2	Martes	16	3	2	4	Abril	2	1	2019	f
2019-04-17	17	3	Miércoles	16	3	2	4	Abril	2	1	2019	f
2019-04-18	18	4	Jueves	16	3	2	4	Abril	2	1	2019	f
2019-04-19	19	5	Viernes	16	3	2	4	Abril	2	1	2019	f
2019-04-20	20	6	Sábado	16	3	2	4	Abril	2	1	2019	t
2019-04-21	21	7	Domingo	16	3	2	4	Abril	2	1	2019	t
2019-04-22	22	1	Lunes	17	4	2	4	Abril	2	1	2019	f
2019-04-23	23	2	Martes	17	4	2	4	Abril	2	1	2019	f
2019-04-24	24	3	Miércoles	17	4	2	4	Abril	2	1	2019	f
2019-04-25	25	4	Jueves	17	4	2	4	Abril	2	1	2019	f
2019-04-26	26	5	Viernes	17	4	2	4	Abril	2	1	2019	f
2019-04-27	27	6	Sábado	17	4	2	4	Abril	2	1	2019	t
2019-04-28	28	7	Domingo	17	4	2	4	Abril	2	1	2019	t
2019-04-29	29	1	Lunes	18	5	2	4	Abril	2	1	2019	f
2019-04-30	30	2	Martes	18	5	2	4	Abril	2	1	2019	f
2019-05-01	1	3	Miércoles	18	1	1	5	Mayo	2	1	2019	f
2019-05-02	2	4	Jueves	18	1	1	5	Mayo	2	1	2019	f
2019-05-03	3	5	Viernes	18	1	1	5	Mayo	2	1	2019	f
2019-05-04	4	6	Sábado	18	1	1	5	Mayo	2	1	2019	t
2019-05-05	5	7	Domingo	18	1	1	5	Mayo	2	1	2019	t
2019-05-06	6	1	Lunes	19	2	1	5	Mayo	2	1	2019	f
2019-05-07	7	2	Martes	19	2	1	5	Mayo	2	1	2019	f
2019-05-08	8	3	Miércoles	19	2	1	5	Mayo	2	1	2019	f
2019-05-09	9	4	Jueves	19	2	1	5	Mayo	2	1	2019	f
2019-05-10	10	5	Viernes	19	2	1	5	Mayo	2	1	2019	f
2019-05-11	11	6	Sábado	19	2	1	5	Mayo	2	1	2019	t
2019-05-12	12	7	Domingo	19	2	1	5	Mayo	2	1	2019	t
2019-05-13	13	1	Lunes	20	3	1	5	Mayo	2	1	2019	f
2019-05-14	14	2	Martes	20	3	1	5	Mayo	2	1	2019	f
2019-05-15	15	3	Miércoles	20	3	1	5	Mayo	2	1	2019	f
2019-05-16	16	4	Jueves	20	3	2	5	Mayo	2	1	2019	f
2019-05-17	17	5	Viernes	20	3	2	5	Mayo	2	1	2019	f
2019-05-18	18	6	Sábado	20	3	2	5	Mayo	2	1	2019	t
2019-05-19	19	7	Domingo	20	3	2	5	Mayo	2	1	2019	t
2019-05-20	20	1	Lunes	21	4	2	5	Mayo	2	1	2019	f
2019-05-21	21	2	Martes	21	4	2	5	Mayo	2	1	2019	f
2019-05-22	22	3	Miércoles	21	4	2	5	Mayo	2	1	2019	f
2019-05-23	23	4	Jueves	21	4	2	5	Mayo	2	1	2019	f
2019-05-24	24	5	Viernes	21	4	2	5	Mayo	2	1	2019	f
2019-05-25	25	6	Sábado	21	4	2	5	Mayo	2	1	2019	t
2019-05-26	26	7	Domingo	21	4	2	5	Mayo	2	1	2019	t
2019-05-27	27	1	Lunes	22	5	2	5	Mayo	2	1	2019	f
2019-05-28	28	2	Martes	22	5	2	5	Mayo	2	1	2019	f
2019-05-29	29	3	Miércoles	22	5	2	5	Mayo	2	1	2019	f
2019-05-30	30	4	Jueves	22	5	2	5	Mayo	2	1	2019	f
2019-05-31	31	5	Viernes	22	5	2	5	Mayo	2	1	2019	f
2019-06-01	1	6	Sábado	22	1	1	6	Junio	2	1	2019	t
2019-06-02	2	7	Domingo	22	1	1	6	Junio	2	1	2019	t
2019-06-03	3	1	Lunes	23	2	1	6	Junio	2	1	2019	f
2019-06-04	4	2	Martes	23	2	1	6	Junio	2	1	2019	f
2019-06-05	5	3	Miércoles	23	2	1	6	Junio	2	1	2019	f
2019-06-06	6	4	Jueves	23	2	1	6	Junio	2	1	2019	f
2019-06-07	7	5	Viernes	23	2	1	6	Junio	2	1	2019	f
2019-06-08	8	6	Sábado	23	2	1	6	Junio	2	1	2019	t
2019-06-09	9	7	Domingo	23	2	1	6	Junio	2	1	2019	t
2019-06-10	10	1	Lunes	24	3	1	6	Junio	2	1	2019	f
2019-06-11	11	2	Martes	24	3	1	6	Junio	2	1	2019	f
2019-06-12	12	3	Miércoles	24	3	1	6	Junio	2	1	2019	f
2019-06-13	13	4	Jueves	24	3	1	6	Junio	2	1	2019	f
2019-06-14	14	5	Viernes	24	3	1	6	Junio	2	1	2019	f
2019-06-15	15	6	Sábado	24	3	1	6	Junio	2	1	2019	t
2019-06-16	16	7	Domingo	24	3	2	6	Junio	2	1	2019	t
2019-06-17	17	1	Lunes	25	4	2	6	Junio	2	1	2019	f
2019-06-18	18	2	Martes	25	4	2	6	Junio	2	1	2019	f
2019-06-19	19	3	Miércoles	25	4	2	6	Junio	2	1	2019	f
2019-06-20	20	4	Jueves	25	4	2	6	Junio	2	1	2019	f
2019-06-21	21	5	Viernes	25	4	2	6	Junio	2	1	2019	f
2019-06-22	22	6	Sábado	25	4	2	6	Junio	2	1	2019	t
2019-06-23	23	7	Domingo	25	4	2	6	Junio	2	1	2019	t
2019-06-24	24	1	Lunes	26	5	2	6	Junio	2	1	2019	f
2019-06-25	25	2	Martes	26	5	2	6	Junio	2	1	2019	f
2019-06-26	26	3	Miércoles	26	5	2	6	Junio	2	1	2019	f
2019-06-27	27	4	Jueves	26	5	2	6	Junio	2	1	2019	f
2019-06-28	28	5	Viernes	26	5	2	6	Junio	2	1	2019	f
2019-06-29	29	6	Sábado	26	5	2	6	Junio	2	1	2019	t
2019-06-30	30	7	Domingo	26	5	2	6	Junio	2	1	2019	t
2019-07-01	1	1	Lunes	27	1	1	7	Julio	3	2	2019	f
2019-07-02	2	2	Martes	27	1	1	7	Julio	3	2	2019	f
2019-07-03	3	3	Miércoles	27	1	1	7	Julio	3	2	2019	f
2019-07-04	4	4	Jueves	27	1	1	7	Julio	3	2	2019	f
2019-07-05	5	5	Viernes	27	1	1	7	Julio	3	2	2019	f
2019-07-06	6	6	Sábado	27	1	1	7	Julio	3	2	2019	t
2019-07-07	7	7	Domingo	27	1	1	7	Julio	3	2	2019	t
2019-07-08	8	1	Lunes	28	2	1	7	Julio	3	2	2019	f
2019-07-09	9	2	Martes	28	2	1	7	Julio	3	2	2019	f
2019-07-10	10	3	Miércoles	28	2	1	7	Julio	3	2	2019	f
2019-07-11	11	4	Jueves	28	2	1	7	Julio	3	2	2019	f
2019-07-12	12	5	Viernes	28	2	1	7	Julio	3	2	2019	f
2019-07-13	13	6	Sábado	28	2	1	7	Julio	3	2	2019	t
2019-07-14	14	7	Domingo	28	2	1	7	Julio	3	2	2019	t
2019-07-15	15	1	Lunes	29	3	1	7	Julio	3	2	2019	f
2019-07-16	16	2	Martes	29	3	2	7	Julio	3	2	2019	f
2019-07-17	17	3	Miércoles	29	3	2	7	Julio	3	2	2019	f
2019-07-18	18	4	Jueves	29	3	2	7	Julio	3	2	2019	f
2019-07-19	19	5	Viernes	29	3	2	7	Julio	3	2	2019	f
2019-07-20	20	6	Sábado	29	3	2	7	Julio	3	2	2019	t
2019-07-21	21	7	Domingo	29	3	2	7	Julio	3	2	2019	t
2019-07-22	22	1	Lunes	30	4	2	7	Julio	3	2	2019	f
2019-07-23	23	2	Martes	30	4	2	7	Julio	3	2	2019	f
2019-07-24	24	3	Miércoles	30	4	2	7	Julio	3	2	2019	f
2019-07-25	25	4	Jueves	30	4	2	7	Julio	3	2	2019	f
2019-07-26	26	5	Viernes	30	4	2	7	Julio	3	2	2019	f
2019-07-27	27	6	Sábado	30	4	2	7	Julio	3	2	2019	t
2019-07-28	28	7	Domingo	30	4	2	7	Julio	3	2	2019	t
2019-07-29	29	1	Lunes	31	5	2	7	Julio	3	2	2019	f
2019-07-30	30	2	Martes	31	5	2	7	Julio	3	2	2019	f
2019-07-31	31	3	Miércoles	31	5	2	7	Julio	3	2	2019	f
2019-08-01	1	4	Jueves	31	1	1	8	Agosto	3	2	2019	f
2019-08-02	2	5	Viernes	31	1	1	8	Agosto	3	2	2019	f
2019-08-03	3	6	Sábado	31	1	1	8	Agosto	3	2	2019	t
2019-08-04	4	7	Domingo	31	1	1	8	Agosto	3	2	2019	t
2019-08-05	5	1	Lunes	32	2	1	8	Agosto	3	2	2019	f
2019-08-06	6	2	Martes	32	2	1	8	Agosto	3	2	2019	f
2019-08-07	7	3	Miércoles	32	2	1	8	Agosto	3	2	2019	f
2019-08-08	8	4	Jueves	32	2	1	8	Agosto	3	2	2019	f
2019-08-09	9	5	Viernes	32	2	1	8	Agosto	3	2	2019	f
2019-08-10	10	6	Sábado	32	2	1	8	Agosto	3	2	2019	t
2019-08-11	11	7	Domingo	32	2	1	8	Agosto	3	2	2019	t
2019-08-12	12	1	Lunes	33	3	1	8	Agosto	3	2	2019	f
2019-08-13	13	2	Martes	33	3	1	8	Agosto	3	2	2019	f
2019-08-14	14	3	Miércoles	33	3	1	8	Agosto	3	2	2019	f
2019-08-15	15	4	Jueves	33	3	1	8	Agosto	3	2	2019	f
2019-08-16	16	5	Viernes	33	3	2	8	Agosto	3	2	2019	f
2019-08-17	17	6	Sábado	33	3	2	8	Agosto	3	2	2019	t
2019-08-18	18	7	Domingo	33	3	2	8	Agosto	3	2	2019	t
2019-08-19	19	1	Lunes	34	4	2	8	Agosto	3	2	2019	f
2019-08-20	20	2	Martes	34	4	2	8	Agosto	3	2	2019	f
2019-08-21	21	3	Miércoles	34	4	2	8	Agosto	3	2	2019	f
2019-08-22	22	4	Jueves	34	4	2	8	Agosto	3	2	2019	f
2019-08-23	23	5	Viernes	34	4	2	8	Agosto	3	2	2019	f
2019-08-24	24	6	Sábado	34	4	2	8	Agosto	3	2	2019	t
2019-08-25	25	7	Domingo	34	4	2	8	Agosto	3	2	2019	t
2019-08-26	26	1	Lunes	35	5	2	8	Agosto	3	2	2019	f
2019-08-27	27	2	Martes	35	5	2	8	Agosto	3	2	2019	f
2019-08-28	28	3	Miércoles	35	5	2	8	Agosto	3	2	2019	f
2019-08-29	29	4	Jueves	35	5	2	8	Agosto	3	2	2019	f
2019-08-30	30	5	Viernes	35	5	2	8	Agosto	3	2	2019	f
2019-08-31	31	6	Sábado	35	5	2	8	Agosto	3	2	2019	t
2019-09-01	1	7	Domingo	35	1	1	9	Septiembre	3	2	2019	t
2019-09-02	2	1	Lunes	36	2	1	9	Septiembre	3	2	2019	f
2019-09-03	3	2	Martes	36	2	1	9	Septiembre	3	2	2019	f
2019-09-04	4	3	Miércoles	36	2	1	9	Septiembre	3	2	2019	f
2019-09-05	5	4	Jueves	36	2	1	9	Septiembre	3	2	2019	f
2019-09-06	6	5	Viernes	36	2	1	9	Septiembre	3	2	2019	f
2019-09-07	7	6	Sábado	36	2	1	9	Septiembre	3	2	2019	t
2019-09-08	8	7	Domingo	36	2	1	9	Septiembre	3	2	2019	t
2019-09-09	9	1	Lunes	37	3	1	9	Septiembre	3	2	2019	f
2019-09-10	10	2	Martes	37	3	1	9	Septiembre	3	2	2019	f
2019-09-11	11	3	Miércoles	37	3	1	9	Septiembre	3	2	2019	f
2019-09-12	12	4	Jueves	37	3	1	9	Septiembre	3	2	2019	f
2019-09-13	13	5	Viernes	37	3	1	9	Septiembre	3	2	2019	f
2019-09-14	14	6	Sábado	37	3	1	9	Septiembre	3	2	2019	t
2019-09-15	15	7	Domingo	37	3	1	9	Septiembre	3	2	2019	t
2019-09-16	16	1	Lunes	38	4	2	9	Septiembre	3	2	2019	f
2019-09-17	17	2	Martes	38	4	2	9	Septiembre	3	2	2019	f
2019-09-18	18	3	Miércoles	38	4	2	9	Septiembre	3	2	2019	f
2019-09-19	19	4	Jueves	38	4	2	9	Septiembre	3	2	2019	f
2019-09-20	20	5	Viernes	38	4	2	9	Septiembre	3	2	2019	f
2019-09-21	21	6	Sábado	38	4	2	9	Septiembre	3	2	2019	t
2019-09-22	22	7	Domingo	38	4	2	9	Septiembre	3	2	2019	t
2019-09-23	23	1	Lunes	39	5	2	9	Septiembre	3	2	2019	f
2019-09-24	24	2	Martes	39	5	2	9	Septiembre	3	2	2019	f
2019-09-25	25	3	Miércoles	39	5	2	9	Septiembre	3	2	2019	f
2019-09-26	26	4	Jueves	39	5	2	9	Septiembre	3	2	2019	f
2019-09-27	27	5	Viernes	39	5	2	9	Septiembre	3	2	2019	f
2019-09-28	28	6	Sábado	39	5	2	9	Septiembre	3	2	2019	t
2019-09-29	29	7	Domingo	39	5	2	9	Septiembre	3	2	2019	t
2019-09-30	30	1	Lunes	40	6	2	9	Septiembre	3	2	2019	f
2019-10-01	1	2	Martes	40	1	1	10	Octubre	4	2	2019	f
2019-10-02	2	3	Miércoles	40	1	1	10	Octubre	4	2	2019	f
2019-10-03	3	4	Jueves	40	1	1	10	Octubre	4	2	2019	f
2019-10-04	4	5	Viernes	40	1	1	10	Octubre	4	2	2019	f
2019-10-05	5	6	Sábado	40	1	1	10	Octubre	4	2	2019	t
2019-10-06	6	7	Domingo	40	1	1	10	Octubre	4	2	2019	t
2019-10-07	7	1	Lunes	41	2	1	10	Octubre	4	2	2019	f
2019-10-08	8	2	Martes	41	2	1	10	Octubre	4	2	2019	f
2019-10-09	9	3	Miércoles	41	2	1	10	Octubre	4	2	2019	f
2019-10-10	10	4	Jueves	41	2	1	10	Octubre	4	2	2019	f
2019-10-11	11	5	Viernes	41	2	1	10	Octubre	4	2	2019	f
2019-10-12	12	6	Sábado	41	2	1	10	Octubre	4	2	2019	t
2019-10-13	13	7	Domingo	41	2	1	10	Octubre	4	2	2019	t
2019-10-14	14	1	Lunes	42	3	1	10	Octubre	4	2	2019	f
2019-10-15	15	2	Martes	42	3	1	10	Octubre	4	2	2019	f
2019-10-16	16	3	Miércoles	42	3	2	10	Octubre	4	2	2019	f
2019-10-17	17	4	Jueves	42	3	2	10	Octubre	4	2	2019	f
2019-10-18	18	5	Viernes	42	3	2	10	Octubre	4	2	2019	f
2019-10-19	19	6	Sábado	42	3	2	10	Octubre	4	2	2019	t
2019-10-20	20	7	Domingo	42	3	2	10	Octubre	4	2	2019	t
2019-10-21	21	1	Lunes	43	4	2	10	Octubre	4	2	2019	f
2019-10-22	22	2	Martes	43	4	2	10	Octubre	4	2	2019	f
2019-10-23	23	3	Miércoles	43	4	2	10	Octubre	4	2	2019	f
2019-10-24	24	4	Jueves	43	4	2	10	Octubre	4	2	2019	f
2019-10-25	25	5	Viernes	43	4	2	10	Octubre	4	2	2019	f
2019-10-26	26	6	Sábado	43	4	2	10	Octubre	4	2	2019	t
2019-10-27	27	7	Domingo	43	4	2	10	Octubre	4	2	2019	t
2019-10-28	28	1	Lunes	44	5	2	10	Octubre	4	2	2019	f
2019-10-29	29	2	Martes	44	5	2	10	Octubre	4	2	2019	f
2019-10-30	30	3	Miércoles	44	5	2	10	Octubre	4	2	2019	f
2019-10-31	31	4	Jueves	44	5	2	10	Octubre	4	2	2019	f
2019-11-01	1	5	Viernes	44	1	1	11	Noviembre	4	2	2019	f
2019-11-02	2	6	Sábado	44	1	1	11	Noviembre	4	2	2019	t
2019-11-03	3	7	Domingo	44	1	1	11	Noviembre	4	2	2019	t
2019-11-04	4	1	Lunes	45	2	1	11	Noviembre	4	2	2019	f
2019-11-05	5	2	Martes	45	2	1	11	Noviembre	4	2	2019	f
2019-11-06	6	3	Miércoles	45	2	1	11	Noviembre	4	2	2019	f
2019-11-07	7	4	Jueves	45	2	1	11	Noviembre	4	2	2019	f
2019-11-08	8	5	Viernes	45	2	1	11	Noviembre	4	2	2019	f
2019-11-09	9	6	Sábado	45	2	1	11	Noviembre	4	2	2019	t
2019-11-10	10	7	Domingo	45	2	1	11	Noviembre	4	2	2019	t
2019-11-11	11	1	Lunes	46	3	1	11	Noviembre	4	2	2019	f
2019-11-12	12	2	Martes	46	3	1	11	Noviembre	4	2	2019	f
2019-11-13	13	3	Miércoles	46	3	1	11	Noviembre	4	2	2019	f
2019-11-14	14	4	Jueves	46	3	1	11	Noviembre	4	2	2019	f
2019-11-15	15	5	Viernes	46	3	1	11	Noviembre	4	2	2019	f
2019-11-16	16	6	Sábado	46	3	2	11	Noviembre	4	2	2019	t
2019-11-17	17	7	Domingo	46	3	2	11	Noviembre	4	2	2019	t
2019-11-18	18	1	Lunes	47	4	2	11	Noviembre	4	2	2019	f
2019-11-19	19	2	Martes	47	4	2	11	Noviembre	4	2	2019	f
2019-11-20	20	3	Miércoles	47	4	2	11	Noviembre	4	2	2019	f
2019-11-21	21	4	Jueves	47	4	2	11	Noviembre	4	2	2019	f
2019-11-22	22	5	Viernes	47	4	2	11	Noviembre	4	2	2019	f
2019-11-23	23	6	Sábado	47	4	2	11	Noviembre	4	2	2019	t
2019-11-24	24	7	Domingo	47	4	2	11	Noviembre	4	2	2019	t
2019-11-25	25	1	Lunes	48	5	2	11	Noviembre	4	2	2019	f
2019-11-26	26	2	Martes	48	5	2	11	Noviembre	4	2	2019	f
2019-11-27	27	3	Miércoles	48	5	2	11	Noviembre	4	2	2019	f
2019-11-28	28	4	Jueves	48	5	2	11	Noviembre	4	2	2019	f
2019-11-29	29	5	Viernes	48	5	2	11	Noviembre	4	2	2019	f
2019-11-30	30	6	Sábado	48	5	2	11	Noviembre	4	2	2019	t
2019-12-01	1	7	Domingo	48	1	1	12	Diciembre	4	2	2019	t
2019-12-02	2	1	Lunes	49	2	1	12	Diciembre	4	2	2019	f
2019-12-03	3	2	Martes	49	2	1	12	Diciembre	4	2	2019	f
2019-12-04	4	3	Miércoles	49	2	1	12	Diciembre	4	2	2019	f
2019-12-05	5	4	Jueves	49	2	1	12	Diciembre	4	2	2019	f
2019-12-06	6	5	Viernes	49	2	1	12	Diciembre	4	2	2019	f
2019-12-07	7	6	Sábado	49	2	1	12	Diciembre	4	2	2019	t
2019-12-08	8	7	Domingo	49	2	1	12	Diciembre	4	2	2019	t
2019-12-09	9	1	Lunes	50	3	1	12	Diciembre	4	2	2019	f
2019-12-10	10	2	Martes	50	3	1	12	Diciembre	4	2	2019	f
2019-12-11	11	3	Miércoles	50	3	1	12	Diciembre	4	2	2019	f
2019-12-12	12	4	Jueves	50	3	1	12	Diciembre	4	2	2019	f
2019-12-13	13	5	Viernes	50	3	1	12	Diciembre	4	2	2019	f
2019-12-14	14	6	Sábado	50	3	1	12	Diciembre	4	2	2019	t
2019-12-15	15	7	Domingo	50	3	1	12	Diciembre	4	2	2019	t
2019-12-16	16	1	Lunes	51	4	2	12	Diciembre	4	2	2019	f
2019-12-17	17	2	Martes	51	4	2	12	Diciembre	4	2	2019	f
2019-12-18	18	3	Miércoles	51	4	2	12	Diciembre	4	2	2019	f
2019-12-19	19	4	Jueves	51	4	2	12	Diciembre	4	2	2019	f
2019-12-20	20	5	Viernes	51	4	2	12	Diciembre	4	2	2019	f
2019-12-21	21	6	Sábado	51	4	2	12	Diciembre	4	2	2019	t
2019-12-22	22	7	Domingo	51	4	2	12	Diciembre	4	2	2019	t
2019-12-23	23	1	Lunes	52	5	2	12	Diciembre	4	2	2019	f
2019-12-24	24	2	Martes	52	5	2	12	Diciembre	4	2	2019	f
2019-12-25	25	3	Miércoles	52	5	2	12	Diciembre	4	2	2019	f
2019-12-26	26	4	Jueves	52	5	2	12	Diciembre	4	2	2019	f
2019-12-27	27	5	Viernes	52	5	2	12	Diciembre	4	2	2019	f
2019-12-28	28	6	Sábado	52	5	2	12	Diciembre	4	2	2019	t
2019-12-29	29	7	Domingo	52	5	2	12	Diciembre	4	2	2019	t
2019-12-30	30	1	Lunes	1	6	2	12	Diciembre	4	2	2019	f
2019-12-31	31	2	Martes	1	6	2	12	Diciembre	4	2	2019	f
2020-01-01	1	3	Miércoles	1	1	1	1	Enero	1	1	2020	f
2020-01-02	2	4	Jueves	1	1	1	1	Enero	1	1	2020	f
2020-01-03	3	5	Viernes	1	1	1	1	Enero	1	1	2020	f
2020-01-04	4	6	Sábado	1	1	1	1	Enero	1	1	2020	t
2020-01-05	5	7	Domingo	1	1	1	1	Enero	1	1	2020	t
2020-01-06	6	1	Lunes	2	2	1	1	Enero	1	1	2020	f
2020-01-07	7	2	Martes	2	2	1	1	Enero	1	1	2020	f
2020-01-08	8	3	Miércoles	2	2	1	1	Enero	1	1	2020	f
2020-01-09	9	4	Jueves	2	2	1	1	Enero	1	1	2020	f
2020-01-10	10	5	Viernes	2	2	1	1	Enero	1	1	2020	f
2020-01-11	11	6	Sábado	2	2	1	1	Enero	1	1	2020	t
2020-01-12	12	7	Domingo	2	2	1	1	Enero	1	1	2020	t
2020-01-13	13	1	Lunes	3	3	1	1	Enero	1	1	2020	f
2020-01-14	14	2	Martes	3	3	1	1	Enero	1	1	2020	f
2020-01-15	15	3	Miércoles	3	3	1	1	Enero	1	1	2020	f
2020-01-16	16	4	Jueves	3	3	2	1	Enero	1	1	2020	f
2020-01-17	17	5	Viernes	3	3	2	1	Enero	1	1	2020	f
2020-01-18	18	6	Sábado	3	3	2	1	Enero	1	1	2020	t
2020-01-19	19	7	Domingo	3	3	2	1	Enero	1	1	2020	t
2020-01-20	20	1	Lunes	4	4	2	1	Enero	1	1	2020	f
2020-01-21	21	2	Martes	4	4	2	1	Enero	1	1	2020	f
2020-01-22	22	3	Miércoles	4	4	2	1	Enero	1	1	2020	f
2020-01-23	23	4	Jueves	4	4	2	1	Enero	1	1	2020	f
2020-01-24	24	5	Viernes	4	4	2	1	Enero	1	1	2020	f
2020-01-25	25	6	Sábado	4	4	2	1	Enero	1	1	2020	t
2020-01-26	26	7	Domingo	4	4	2	1	Enero	1	1	2020	t
2020-01-27	27	1	Lunes	5	5	2	1	Enero	1	1	2020	f
2020-01-28	28	2	Martes	5	5	2	1	Enero	1	1	2020	f
2020-01-29	29	3	Miércoles	5	5	2	1	Enero	1	1	2020	f
2020-01-30	30	4	Jueves	5	5	2	1	Enero	1	1	2020	f
2020-01-31	31	5	Viernes	5	5	2	1	Enero	1	1	2020	f
2020-02-01	1	6	Sábado	5	1	1	2	Febrero	1	1	2020	t
2020-02-02	2	7	Domingo	5	1	1	2	Febrero	1	1	2020	t
2020-02-03	3	1	Lunes	6	2	1	2	Febrero	1	1	2020	f
2020-02-04	4	2	Martes	6	2	1	2	Febrero	1	1	2020	f
2020-02-05	5	3	Miércoles	6	2	1	2	Febrero	1	1	2020	f
2020-02-06	6	4	Jueves	6	2	1	2	Febrero	1	1	2020	f
2020-02-07	7	5	Viernes	6	2	1	2	Febrero	1	1	2020	f
2020-02-08	8	6	Sábado	6	2	1	2	Febrero	1	1	2020	t
2020-02-09	9	7	Domingo	6	2	1	2	Febrero	1	1	2020	t
2020-02-10	10	1	Lunes	7	3	1	2	Febrero	1	1	2020	f
2020-02-11	11	2	Martes	7	3	1	2	Febrero	1	1	2020	f
2020-02-12	12	3	Miércoles	7	3	1	2	Febrero	1	1	2020	f
2020-02-13	13	4	Jueves	7	3	1	2	Febrero	1	1	2020	f
2020-02-14	14	5	Viernes	7	3	1	2	Febrero	1	1	2020	f
2020-02-15	15	6	Sábado	7	3	1	2	Febrero	1	1	2020	t
2020-02-16	16	7	Domingo	7	3	2	2	Febrero	1	1	2020	t
2020-02-17	17	1	Lunes	8	4	2	2	Febrero	1	1	2020	f
2020-02-18	18	2	Martes	8	4	2	2	Febrero	1	1	2020	f
2020-02-19	19	3	Miércoles	8	4	2	2	Febrero	1	1	2020	f
2020-02-20	20	4	Jueves	8	4	2	2	Febrero	1	1	2020	f
2020-02-21	21	5	Viernes	8	4	2	2	Febrero	1	1	2020	f
2020-02-22	22	6	Sábado	8	4	2	2	Febrero	1	1	2020	t
2020-02-23	23	7	Domingo	8	4	2	2	Febrero	1	1	2020	t
2020-02-24	24	1	Lunes	9	5	2	2	Febrero	1	1	2020	f
2020-02-25	25	2	Martes	9	5	2	2	Febrero	1	1	2020	f
2020-02-26	26	3	Miércoles	9	5	2	2	Febrero	1	1	2020	f
2020-02-27	27	4	Jueves	9	5	2	2	Febrero	1	1	2020	f
2020-02-28	28	5	Viernes	9	5	2	2	Febrero	1	1	2020	f
2020-02-29	29	6	Sábado	9	5	2	2	Febrero	1	1	2020	t
2020-03-01	1	7	Domingo	9	1	1	3	Marzo	1	1	2020	t
2020-03-02	2	1	Lunes	10	2	1	3	Marzo	1	1	2020	f
2020-03-03	3	2	Martes	10	2	1	3	Marzo	1	1	2020	f
2020-03-04	4	3	Miércoles	10	2	1	3	Marzo	1	1	2020	f
2020-03-05	5	4	Jueves	10	2	1	3	Marzo	1	1	2020	f
2020-03-06	6	5	Viernes	10	2	1	3	Marzo	1	1	2020	f
2020-03-07	7	6	Sábado	10	2	1	3	Marzo	1	1	2020	t
2020-03-08	8	7	Domingo	10	2	1	3	Marzo	1	1	2020	t
2020-03-09	9	1	Lunes	11	3	1	3	Marzo	1	1	2020	f
2020-03-10	10	2	Martes	11	3	1	3	Marzo	1	1	2020	f
2020-03-11	11	3	Miércoles	11	3	1	3	Marzo	1	1	2020	f
2020-03-12	12	4	Jueves	11	3	1	3	Marzo	1	1	2020	f
2020-03-13	13	5	Viernes	11	3	1	3	Marzo	1	1	2020	f
2020-03-14	14	6	Sábado	11	3	1	3	Marzo	1	1	2020	t
2020-03-15	15	7	Domingo	11	3	1	3	Marzo	1	1	2020	t
2020-03-16	16	1	Lunes	12	4	2	3	Marzo	1	1	2020	f
2020-03-17	17	2	Martes	12	4	2	3	Marzo	1	1	2020	f
2020-03-18	18	3	Miércoles	12	4	2	3	Marzo	1	1	2020	f
2020-03-19	19	4	Jueves	12	4	2	3	Marzo	1	1	2020	f
2020-03-20	20	5	Viernes	12	4	2	3	Marzo	1	1	2020	f
2020-03-21	21	6	Sábado	12	4	2	3	Marzo	1	1	2020	t
2020-03-22	22	7	Domingo	12	4	2	3	Marzo	1	1	2020	t
2020-03-23	23	1	Lunes	13	5	2	3	Marzo	1	1	2020	f
2020-03-24	24	2	Martes	13	5	2	3	Marzo	1	1	2020	f
2020-03-25	25	3	Miércoles	13	5	2	3	Marzo	1	1	2020	f
2020-03-26	26	4	Jueves	13	5	2	3	Marzo	1	1	2020	f
2020-03-27	27	5	Viernes	13	5	2	3	Marzo	1	1	2020	f
2020-03-28	28	6	Sábado	13	5	2	3	Marzo	1	1	2020	t
2020-03-29	29	7	Domingo	13	5	2	3	Marzo	1	1	2020	t
2020-03-30	30	1	Lunes	14	6	2	3	Marzo	1	1	2020	f
2020-03-31	31	2	Martes	14	6	2	3	Marzo	1	1	2020	f
2020-04-01	1	3	Miércoles	14	1	1	4	Abril	2	1	2020	f
2020-04-02	2	4	Jueves	14	1	1	4	Abril	2	1	2020	f
2020-04-03	3	5	Viernes	14	1	1	4	Abril	2	1	2020	f
2020-04-04	4	6	Sábado	14	1	1	4	Abril	2	1	2020	t
2020-04-05	5	7	Domingo	14	1	1	4	Abril	2	1	2020	t
2020-04-06	6	1	Lunes	15	2	1	4	Abril	2	1	2020	f
2020-04-07	7	2	Martes	15	2	1	4	Abril	2	1	2020	f
2020-04-08	8	3	Miércoles	15	2	1	4	Abril	2	1	2020	f
2020-04-09	9	4	Jueves	15	2	1	4	Abril	2	1	2020	f
2020-04-10	10	5	Viernes	15	2	1	4	Abril	2	1	2020	f
2020-04-11	11	6	Sábado	15	2	1	4	Abril	2	1	2020	t
2020-04-12	12	7	Domingo	15	2	1	4	Abril	2	1	2020	t
2020-04-13	13	1	Lunes	16	3	1	4	Abril	2	1	2020	f
2020-04-14	14	2	Martes	16	3	1	4	Abril	2	1	2020	f
2020-04-15	15	3	Miércoles	16	3	1	4	Abril	2	1	2020	f
2020-04-16	16	4	Jueves	16	3	2	4	Abril	2	1	2020	f
2020-04-17	17	5	Viernes	16	3	2	4	Abril	2	1	2020	f
2020-04-18	18	6	Sábado	16	3	2	4	Abril	2	1	2020	t
2020-04-19	19	7	Domingo	16	3	2	4	Abril	2	1	2020	t
2020-04-20	20	1	Lunes	17	4	2	4	Abril	2	1	2020	f
2020-04-21	21	2	Martes	17	4	2	4	Abril	2	1	2020	f
2020-04-22	22	3	Miércoles	17	4	2	4	Abril	2	1	2020	f
2020-04-23	23	4	Jueves	17	4	2	4	Abril	2	1	2020	f
2020-04-24	24	5	Viernes	17	4	2	4	Abril	2	1	2020	f
2020-04-25	25	6	Sábado	17	4	2	4	Abril	2	1	2020	t
2020-04-26	26	7	Domingo	17	4	2	4	Abril	2	1	2020	t
2020-04-27	27	1	Lunes	18	5	2	4	Abril	2	1	2020	f
2020-04-28	28	2	Martes	18	5	2	4	Abril	2	1	2020	f
2020-04-29	29	3	Miércoles	18	5	2	4	Abril	2	1	2020	f
2020-04-30	30	4	Jueves	18	5	2	4	Abril	2	1	2020	f
2020-05-01	1	5	Viernes	18	1	1	5	Mayo	2	1	2020	f
2020-05-02	2	6	Sábado	18	1	1	5	Mayo	2	1	2020	t
2020-05-03	3	7	Domingo	18	1	1	5	Mayo	2	1	2020	t
2020-05-04	4	1	Lunes	19	2	1	5	Mayo	2	1	2020	f
2020-05-05	5	2	Martes	19	2	1	5	Mayo	2	1	2020	f
2020-05-06	6	3	Miércoles	19	2	1	5	Mayo	2	1	2020	f
2020-05-07	7	4	Jueves	19	2	1	5	Mayo	2	1	2020	f
2020-05-08	8	5	Viernes	19	2	1	5	Mayo	2	1	2020	f
2020-05-09	9	6	Sábado	19	2	1	5	Mayo	2	1	2020	t
2020-05-10	10	7	Domingo	19	2	1	5	Mayo	2	1	2020	t
2020-05-11	11	1	Lunes	20	3	1	5	Mayo	2	1	2020	f
2020-05-12	12	2	Martes	20	3	1	5	Mayo	2	1	2020	f
2020-05-13	13	3	Miércoles	20	3	1	5	Mayo	2	1	2020	f
2020-05-14	14	4	Jueves	20	3	1	5	Mayo	2	1	2020	f
2020-05-15	15	5	Viernes	20	3	1	5	Mayo	2	1	2020	f
2020-05-16	16	6	Sábado	20	3	2	5	Mayo	2	1	2020	t
2020-05-17	17	7	Domingo	20	3	2	5	Mayo	2	1	2020	t
2020-05-18	18	1	Lunes	21	4	2	5	Mayo	2	1	2020	f
2020-05-19	19	2	Martes	21	4	2	5	Mayo	2	1	2020	f
2020-05-20	20	3	Miércoles	21	4	2	5	Mayo	2	1	2020	f
2020-05-21	21	4	Jueves	21	4	2	5	Mayo	2	1	2020	f
2020-05-22	22	5	Viernes	21	4	2	5	Mayo	2	1	2020	f
2020-05-23	23	6	Sábado	21	4	2	5	Mayo	2	1	2020	t
2020-05-24	24	7	Domingo	21	4	2	5	Mayo	2	1	2020	t
2020-05-25	25	1	Lunes	22	5	2	5	Mayo	2	1	2020	f
2020-05-26	26	2	Martes	22	5	2	5	Mayo	2	1	2020	f
2020-05-27	27	3	Miércoles	22	5	2	5	Mayo	2	1	2020	f
2020-05-28	28	4	Jueves	22	5	2	5	Mayo	2	1	2020	f
2020-05-29	29	5	Viernes	22	5	2	5	Mayo	2	1	2020	f
2020-05-30	30	6	Sábado	22	5	2	5	Mayo	2	1	2020	t
2020-05-31	31	7	Domingo	22	5	2	5	Mayo	2	1	2020	t
2020-06-01	1	1	Lunes	23	1	1	6	Junio	2	1	2020	f
2020-06-02	2	2	Martes	23	1	1	6	Junio	2	1	2020	f
2020-06-03	3	3	Miércoles	23	1	1	6	Junio	2	1	2020	f
2020-06-04	4	4	Jueves	23	1	1	6	Junio	2	1	2020	f
2020-06-05	5	5	Viernes	23	1	1	6	Junio	2	1	2020	f
2020-06-06	6	6	Sábado	23	1	1	6	Junio	2	1	2020	t
2020-06-07	7	7	Domingo	23	1	1	6	Junio	2	1	2020	t
2020-06-08	8	1	Lunes	24	2	1	6	Junio	2	1	2020	f
2020-06-09	9	2	Martes	24	2	1	6	Junio	2	1	2020	f
2020-06-10	10	3	Miércoles	24	2	1	6	Junio	2	1	2020	f
2020-06-11	11	4	Jueves	24	2	1	6	Junio	2	1	2020	f
2020-06-12	12	5	Viernes	24	2	1	6	Junio	2	1	2020	f
2020-06-13	13	6	Sábado	24	2	1	6	Junio	2	1	2020	t
2020-06-14	14	7	Domingo	24	2	1	6	Junio	2	1	2020	t
2020-06-15	15	1	Lunes	25	3	1	6	Junio	2	1	2020	f
2020-06-16	16	2	Martes	25	3	2	6	Junio	2	1	2020	f
2020-06-17	17	3	Miércoles	25	3	2	6	Junio	2	1	2020	f
2020-06-18	18	4	Jueves	25	3	2	6	Junio	2	1	2020	f
2020-06-19	19	5	Viernes	25	3	2	6	Junio	2	1	2020	f
2020-06-20	20	6	Sábado	25	3	2	6	Junio	2	1	2020	t
2020-06-21	21	7	Domingo	25	3	2	6	Junio	2	1	2020	t
2020-06-22	22	1	Lunes	26	4	2	6	Junio	2	1	2020	f
2020-06-23	23	2	Martes	26	4	2	6	Junio	2	1	2020	f
2020-06-24	24	3	Miércoles	26	4	2	6	Junio	2	1	2020	f
2020-06-25	25	4	Jueves	26	4	2	6	Junio	2	1	2020	f
2020-06-26	26	5	Viernes	26	4	2	6	Junio	2	1	2020	f
2020-06-27	27	6	Sábado	26	4	2	6	Junio	2	1	2020	t
2020-06-28	28	7	Domingo	26	4	2	6	Junio	2	1	2020	t
2020-06-29	29	1	Lunes	27	5	2	6	Junio	2	1	2020	f
2020-06-30	30	2	Martes	27	5	2	6	Junio	2	1	2020	f
2020-07-01	1	3	Miércoles	27	1	1	7	Julio	3	2	2020	f
2020-07-02	2	4	Jueves	27	1	1	7	Julio	3	2	2020	f
2020-07-03	3	5	Viernes	27	1	1	7	Julio	3	2	2020	f
2020-07-04	4	6	Sábado	27	1	1	7	Julio	3	2	2020	t
2020-07-05	5	7	Domingo	27	1	1	7	Julio	3	2	2020	t
2020-07-06	6	1	Lunes	28	2	1	7	Julio	3	2	2020	f
2020-07-07	7	2	Martes	28	2	1	7	Julio	3	2	2020	f
2020-07-08	8	3	Miércoles	28	2	1	7	Julio	3	2	2020	f
2020-07-09	9	4	Jueves	28	2	1	7	Julio	3	2	2020	f
2020-07-10	10	5	Viernes	28	2	1	7	Julio	3	2	2020	f
2020-07-11	11	6	Sábado	28	2	1	7	Julio	3	2	2020	t
2020-07-12	12	7	Domingo	28	2	1	7	Julio	3	2	2020	t
2020-07-13	13	1	Lunes	29	3	1	7	Julio	3	2	2020	f
2020-07-14	14	2	Martes	29	3	1	7	Julio	3	2	2020	f
2020-07-15	15	3	Miércoles	29	3	1	7	Julio	3	2	2020	f
2020-07-16	16	4	Jueves	29	3	2	7	Julio	3	2	2020	f
2020-07-17	17	5	Viernes	29	3	2	7	Julio	3	2	2020	f
2020-07-18	18	6	Sábado	29	3	2	7	Julio	3	2	2020	t
2020-07-19	19	7	Domingo	29	3	2	7	Julio	3	2	2020	t
2020-07-20	20	1	Lunes	30	4	2	7	Julio	3	2	2020	f
2020-07-21	21	2	Martes	30	4	2	7	Julio	3	2	2020	f
2020-07-22	22	3	Miércoles	30	4	2	7	Julio	3	2	2020	f
2020-07-23	23	4	Jueves	30	4	2	7	Julio	3	2	2020	f
2020-07-24	24	5	Viernes	30	4	2	7	Julio	3	2	2020	f
2020-07-25	25	6	Sábado	30	4	2	7	Julio	3	2	2020	t
2020-07-26	26	7	Domingo	30	4	2	7	Julio	3	2	2020	t
2020-07-27	27	1	Lunes	31	5	2	7	Julio	3	2	2020	f
2020-07-28	28	2	Martes	31	5	2	7	Julio	3	2	2020	f
2020-07-29	29	3	Miércoles	31	5	2	7	Julio	3	2	2020	f
2020-07-30	30	4	Jueves	31	5	2	7	Julio	3	2	2020	f
2020-07-31	31	5	Viernes	31	5	2	7	Julio	3	2	2020	f
2020-08-01	1	6	Sábado	31	1	1	8	Agosto	3	2	2020	t
2020-08-02	2	7	Domingo	31	1	1	8	Agosto	3	2	2020	t
2020-08-03	3	1	Lunes	32	2	1	8	Agosto	3	2	2020	f
2020-08-04	4	2	Martes	32	2	1	8	Agosto	3	2	2020	f
2020-08-05	5	3	Miércoles	32	2	1	8	Agosto	3	2	2020	f
2020-08-06	6	4	Jueves	32	2	1	8	Agosto	3	2	2020	f
2020-08-07	7	5	Viernes	32	2	1	8	Agosto	3	2	2020	f
2020-08-08	8	6	Sábado	32	2	1	8	Agosto	3	2	2020	t
2020-08-09	9	7	Domingo	32	2	1	8	Agosto	3	2	2020	t
2020-08-10	10	1	Lunes	33	3	1	8	Agosto	3	2	2020	f
2020-08-11	11	2	Martes	33	3	1	8	Agosto	3	2	2020	f
2020-08-12	12	3	Miércoles	33	3	1	8	Agosto	3	2	2020	f
2020-08-13	13	4	Jueves	33	3	1	8	Agosto	3	2	2020	f
2020-08-14	14	5	Viernes	33	3	1	8	Agosto	3	2	2020	f
2020-08-15	15	6	Sábado	33	3	1	8	Agosto	3	2	2020	t
2020-08-16	16	7	Domingo	33	3	2	8	Agosto	3	2	2020	t
2020-08-17	17	1	Lunes	34	4	2	8	Agosto	3	2	2020	f
2020-08-18	18	2	Martes	34	4	2	8	Agosto	3	2	2020	f
2020-08-19	19	3	Miércoles	34	4	2	8	Agosto	3	2	2020	f
2020-08-20	20	4	Jueves	34	4	2	8	Agosto	3	2	2020	f
2020-08-21	21	5	Viernes	34	4	2	8	Agosto	3	2	2020	f
2020-08-22	22	6	Sábado	34	4	2	8	Agosto	3	2	2020	t
2020-08-23	23	7	Domingo	34	4	2	8	Agosto	3	2	2020	t
2020-08-24	24	1	Lunes	35	5	2	8	Agosto	3	2	2020	f
2020-08-25	25	2	Martes	35	5	2	8	Agosto	3	2	2020	f
2020-08-26	26	3	Miércoles	35	5	2	8	Agosto	3	2	2020	f
2020-08-27	27	4	Jueves	35	5	2	8	Agosto	3	2	2020	f
2020-08-28	28	5	Viernes	35	5	2	8	Agosto	3	2	2020	f
2020-08-29	29	6	Sábado	35	5	2	8	Agosto	3	2	2020	t
2020-08-30	30	7	Domingo	35	5	2	8	Agosto	3	2	2020	t
2020-08-31	31	1	Lunes	36	6	2	8	Agosto	3	2	2020	f
2020-09-01	1	2	Martes	36	1	1	9	Septiembre	3	2	2020	f
2020-09-02	2	3	Miércoles	36	1	1	9	Septiembre	3	2	2020	f
2020-09-03	3	4	Jueves	36	1	1	9	Septiembre	3	2	2020	f
2020-09-04	4	5	Viernes	36	1	1	9	Septiembre	3	2	2020	f
2020-09-05	5	6	Sábado	36	1	1	9	Septiembre	3	2	2020	t
2020-09-06	6	7	Domingo	36	1	1	9	Septiembre	3	2	2020	t
2020-09-07	7	1	Lunes	37	2	1	9	Septiembre	3	2	2020	f
2020-09-08	8	2	Martes	37	2	1	9	Septiembre	3	2	2020	f
2020-09-09	9	3	Miércoles	37	2	1	9	Septiembre	3	2	2020	f
2020-09-10	10	4	Jueves	37	2	1	9	Septiembre	3	2	2020	f
2020-09-11	11	5	Viernes	37	2	1	9	Septiembre	3	2	2020	f
2020-09-12	12	6	Sábado	37	2	1	9	Septiembre	3	2	2020	t
2020-09-13	13	7	Domingo	37	2	1	9	Septiembre	3	2	2020	t
2020-09-14	14	1	Lunes	38	3	1	9	Septiembre	3	2	2020	f
2020-09-15	15	2	Martes	38	3	1	9	Septiembre	3	2	2020	f
2020-09-16	16	3	Miércoles	38	3	2	9	Septiembre	3	2	2020	f
2020-09-17	17	4	Jueves	38	3	2	9	Septiembre	3	2	2020	f
2020-09-18	18	5	Viernes	38	3	2	9	Septiembre	3	2	2020	f
2020-09-19	19	6	Sábado	38	3	2	9	Septiembre	3	2	2020	t
2020-09-20	20	7	Domingo	38	3	2	9	Septiembre	3	2	2020	t
2020-09-21	21	1	Lunes	39	4	2	9	Septiembre	3	2	2020	f
2020-09-22	22	2	Martes	39	4	2	9	Septiembre	3	2	2020	f
2020-09-23	23	3	Miércoles	39	4	2	9	Septiembre	3	2	2020	f
2020-09-24	24	4	Jueves	39	4	2	9	Septiembre	3	2	2020	f
2020-09-25	25	5	Viernes	39	4	2	9	Septiembre	3	2	2020	f
2020-09-26	26	6	Sábado	39	4	2	9	Septiembre	3	2	2020	t
2020-09-27	27	7	Domingo	39	4	2	9	Septiembre	3	2	2020	t
2020-09-28	28	1	Lunes	40	5	2	9	Septiembre	3	2	2020	f
2020-09-29	29	2	Martes	40	5	2	9	Septiembre	3	2	2020	f
2020-09-30	30	3	Miércoles	40	5	2	9	Septiembre	3	2	2020	f
2020-10-01	1	4	Jueves	40	1	1	10	Octubre	4	2	2020	f
2020-10-02	2	5	Viernes	40	1	1	10	Octubre	4	2	2020	f
2020-10-03	3	6	Sábado	40	1	1	10	Octubre	4	2	2020	t
2020-10-04	4	7	Domingo	40	1	1	10	Octubre	4	2	2020	t
2020-10-05	5	1	Lunes	41	2	1	10	Octubre	4	2	2020	f
2020-10-06	6	2	Martes	41	2	1	10	Octubre	4	2	2020	f
2020-10-07	7	3	Miércoles	41	2	1	10	Octubre	4	2	2020	f
2020-10-08	8	4	Jueves	41	2	1	10	Octubre	4	2	2020	f
2020-10-09	9	5	Viernes	41	2	1	10	Octubre	4	2	2020	f
2020-10-10	10	6	Sábado	41	2	1	10	Octubre	4	2	2020	t
2020-10-11	11	7	Domingo	41	2	1	10	Octubre	4	2	2020	t
2020-10-12	12	1	Lunes	42	3	1	10	Octubre	4	2	2020	f
2020-10-13	13	2	Martes	42	3	1	10	Octubre	4	2	2020	f
2020-10-14	14	3	Miércoles	42	3	1	10	Octubre	4	2	2020	f
2020-10-15	15	4	Jueves	42	3	1	10	Octubre	4	2	2020	f
2020-10-16	16	5	Viernes	42	3	2	10	Octubre	4	2	2020	f
2020-10-17	17	6	Sábado	42	3	2	10	Octubre	4	2	2020	t
2020-10-18	18	7	Domingo	42	3	2	10	Octubre	4	2	2020	t
2020-10-19	19	1	Lunes	43	4	2	10	Octubre	4	2	2020	f
2020-10-20	20	2	Martes	43	4	2	10	Octubre	4	2	2020	f
2020-10-21	21	3	Miércoles	43	4	2	10	Octubre	4	2	2020	f
2020-10-22	22	4	Jueves	43	4	2	10	Octubre	4	2	2020	f
2020-10-23	23	5	Viernes	43	4	2	10	Octubre	4	2	2020	f
2020-10-24	24	6	Sábado	43	4	2	10	Octubre	4	2	2020	t
2020-10-25	25	7	Domingo	43	4	2	10	Octubre	4	2	2020	t
2020-10-26	26	1	Lunes	44	5	2	10	Octubre	4	2	2020	f
2020-10-27	27	2	Martes	44	5	2	10	Octubre	4	2	2020	f
2020-10-28	28	3	Miércoles	44	5	2	10	Octubre	4	2	2020	f
2020-10-29	29	4	Jueves	44	5	2	10	Octubre	4	2	2020	f
2020-10-30	30	5	Viernes	44	5	2	10	Octubre	4	2	2020	f
2020-10-31	31	6	Sábado	44	5	2	10	Octubre	4	2	2020	t
2020-11-01	1	7	Domingo	44	1	1	11	Noviembre	4	2	2020	t
2020-11-02	2	1	Lunes	45	2	1	11	Noviembre	4	2	2020	f
2020-11-03	3	2	Martes	45	2	1	11	Noviembre	4	2	2020	f
2020-11-04	4	3	Miércoles	45	2	1	11	Noviembre	4	2	2020	f
2020-11-05	5	4	Jueves	45	2	1	11	Noviembre	4	2	2020	f
2020-11-06	6	5	Viernes	45	2	1	11	Noviembre	4	2	2020	f
2020-11-07	7	6	Sábado	45	2	1	11	Noviembre	4	2	2020	t
2020-11-08	8	7	Domingo	45	2	1	11	Noviembre	4	2	2020	t
2020-11-09	9	1	Lunes	46	3	1	11	Noviembre	4	2	2020	f
2020-11-10	10	2	Martes	46	3	1	11	Noviembre	4	2	2020	f
2020-11-11	11	3	Miércoles	46	3	1	11	Noviembre	4	2	2020	f
2020-11-12	12	4	Jueves	46	3	1	11	Noviembre	4	2	2020	f
2020-11-13	13	5	Viernes	46	3	1	11	Noviembre	4	2	2020	f
2020-11-14	14	6	Sábado	46	3	1	11	Noviembre	4	2	2020	t
2020-11-15	15	7	Domingo	46	3	1	11	Noviembre	4	2	2020	t
2020-11-16	16	1	Lunes	47	4	2	11	Noviembre	4	2	2020	f
2020-11-17	17	2	Martes	47	4	2	11	Noviembre	4	2	2020	f
2020-11-18	18	3	Miércoles	47	4	2	11	Noviembre	4	2	2020	f
2020-11-19	19	4	Jueves	47	4	2	11	Noviembre	4	2	2020	f
2020-11-20	20	5	Viernes	47	4	2	11	Noviembre	4	2	2020	f
2020-11-21	21	6	Sábado	47	4	2	11	Noviembre	4	2	2020	t
2020-11-22	22	7	Domingo	47	4	2	11	Noviembre	4	2	2020	t
2020-11-23	23	1	Lunes	48	5	2	11	Noviembre	4	2	2020	f
2020-11-24	24	2	Martes	48	5	2	11	Noviembre	4	2	2020	f
2020-11-25	25	3	Miércoles	48	5	2	11	Noviembre	4	2	2020	f
2020-11-26	26	4	Jueves	48	5	2	11	Noviembre	4	2	2020	f
2020-11-27	27	5	Viernes	48	5	2	11	Noviembre	4	2	2020	f
2020-11-28	28	6	Sábado	48	5	2	11	Noviembre	4	2	2020	t
2020-11-29	29	7	Domingo	48	5	2	11	Noviembre	4	2	2020	t
2020-11-30	30	1	Lunes	49	6	2	11	Noviembre	4	2	2020	f
2020-12-01	1	2	Martes	49	1	1	12	Diciembre	4	2	2020	f
2020-12-02	2	3	Miércoles	49	1	1	12	Diciembre	4	2	2020	f
2020-12-03	3	4	Jueves	49	1	1	12	Diciembre	4	2	2020	f
2020-12-04	4	5	Viernes	49	1	1	12	Diciembre	4	2	2020	f
2020-12-05	5	6	Sábado	49	1	1	12	Diciembre	4	2	2020	t
2020-12-06	6	7	Domingo	49	1	1	12	Diciembre	4	2	2020	t
2020-12-07	7	1	Lunes	50	2	1	12	Diciembre	4	2	2020	f
2020-12-08	8	2	Martes	50	2	1	12	Diciembre	4	2	2020	f
2020-12-09	9	3	Miércoles	50	2	1	12	Diciembre	4	2	2020	f
2020-12-10	10	4	Jueves	50	2	1	12	Diciembre	4	2	2020	f
2020-12-11	11	5	Viernes	50	2	1	12	Diciembre	4	2	2020	f
2020-12-12	12	6	Sábado	50	2	1	12	Diciembre	4	2	2020	t
2020-12-13	13	7	Domingo	50	2	1	12	Diciembre	4	2	2020	t
2020-12-14	14	1	Lunes	51	3	1	12	Diciembre	4	2	2020	f
2020-12-15	15	2	Martes	51	3	1	12	Diciembre	4	2	2020	f
2020-12-16	16	3	Miércoles	51	3	2	12	Diciembre	4	2	2020	f
2020-12-17	17	4	Jueves	51	3	2	12	Diciembre	4	2	2020	f
2020-12-18	18	5	Viernes	51	3	2	12	Diciembre	4	2	2020	f
2020-12-19	19	6	Sábado	51	3	2	12	Diciembre	4	2	2020	t
2020-12-20	20	7	Domingo	51	3	2	12	Diciembre	4	2	2020	t
2020-12-21	21	1	Lunes	52	4	2	12	Diciembre	4	2	2020	f
2020-12-22	22	2	Martes	52	4	2	12	Diciembre	4	2	2020	f
2020-12-23	23	3	Miércoles	52	4	2	12	Diciembre	4	2	2020	f
2020-12-24	24	4	Jueves	52	4	2	12	Diciembre	4	2	2020	f
2020-12-25	25	5	Viernes	52	4	2	12	Diciembre	4	2	2020	f
2020-12-26	26	6	Sábado	52	4	2	12	Diciembre	4	2	2020	t
2020-12-27	27	7	Domingo	52	4	2	12	Diciembre	4	2	2020	t
2020-12-28	28	1	Lunes	53	5	2	12	Diciembre	4	2	2020	f
2020-12-29	29	2	Martes	53	5	2	12	Diciembre	4	2	2020	f
2020-12-30	30	3	Miércoles	53	5	2	12	Diciembre	4	2	2020	f
2020-12-31	31	4	Jueves	53	5	2	12	Diciembre	4	2	2020	f
2021-01-01	1	5	Viernes	53	1	1	1	Enero	1	1	2021	f
2021-01-02	2	6	Sábado	53	1	1	1	Enero	1	1	2021	t
2021-01-03	3	7	Domingo	53	1	1	1	Enero	1	1	2021	t
2021-01-04	4	1	Lunes	1	2	1	1	Enero	1	1	2021	f
2021-01-05	5	2	Martes	1	2	1	1	Enero	1	1	2021	f
2021-01-06	6	3	Miércoles	1	2	1	1	Enero	1	1	2021	f
2021-01-07	7	4	Jueves	1	2	1	1	Enero	1	1	2021	f
2021-01-08	8	5	Viernes	1	2	1	1	Enero	1	1	2021	f
2021-01-09	9	6	Sábado	1	2	1	1	Enero	1	1	2021	t
2021-01-10	10	7	Domingo	1	2	1	1	Enero	1	1	2021	t
2021-01-11	11	1	Lunes	2	3	1	1	Enero	1	1	2021	f
2021-01-12	12	2	Martes	2	3	1	1	Enero	1	1	2021	f
2021-01-13	13	3	Miércoles	2	3	1	1	Enero	1	1	2021	f
2021-01-14	14	4	Jueves	2	3	1	1	Enero	1	1	2021	f
2021-01-15	15	5	Viernes	2	3	1	1	Enero	1	1	2021	f
2021-01-16	16	6	Sábado	2	3	2	1	Enero	1	1	2021	t
2021-01-17	17	7	Domingo	2	3	2	1	Enero	1	1	2021	t
2021-01-18	18	1	Lunes	3	4	2	1	Enero	1	1	2021	f
2021-01-19	19	2	Martes	3	4	2	1	Enero	1	1	2021	f
2021-01-20	20	3	Miércoles	3	4	2	1	Enero	1	1	2021	f
2021-01-21	21	4	Jueves	3	4	2	1	Enero	1	1	2021	f
2021-01-22	22	5	Viernes	3	4	2	1	Enero	1	1	2021	f
2021-01-23	23	6	Sábado	3	4	2	1	Enero	1	1	2021	t
2021-01-24	24	7	Domingo	3	4	2	1	Enero	1	1	2021	t
2021-01-25	25	1	Lunes	4	5	2	1	Enero	1	1	2021	f
2021-01-26	26	2	Martes	4	5	2	1	Enero	1	1	2021	f
2021-01-27	27	3	Miércoles	4	5	2	1	Enero	1	1	2021	f
2021-01-28	28	4	Jueves	4	5	2	1	Enero	1	1	2021	f
2021-01-29	29	5	Viernes	4	5	2	1	Enero	1	1	2021	f
2021-01-30	30	6	Sábado	4	5	2	1	Enero	1	1	2021	t
2021-01-31	31	7	Domingo	4	5	2	1	Enero	1	1	2021	t
2021-02-01	1	1	Lunes	5	1	1	2	Febrero	1	1	2021	f
2021-02-02	2	2	Martes	5	1	1	2	Febrero	1	1	2021	f
2021-02-03	3	3	Miércoles	5	1	1	2	Febrero	1	1	2021	f
2021-02-04	4	4	Jueves	5	1	1	2	Febrero	1	1	2021	f
2021-02-05	5	5	Viernes	5	1	1	2	Febrero	1	1	2021	f
2021-02-06	6	6	Sábado	5	1	1	2	Febrero	1	1	2021	t
2021-02-07	7	7	Domingo	5	1	1	2	Febrero	1	1	2021	t
2021-02-08	8	1	Lunes	6	2	1	2	Febrero	1	1	2021	f
2021-02-09	9	2	Martes	6	2	1	2	Febrero	1	1	2021	f
2021-02-10	10	3	Miércoles	6	2	1	2	Febrero	1	1	2021	f
2021-02-11	11	4	Jueves	6	2	1	2	Febrero	1	1	2021	f
2021-02-12	12	5	Viernes	6	2	1	2	Febrero	1	1	2021	f
2021-02-13	13	6	Sábado	6	2	1	2	Febrero	1	1	2021	t
2021-02-14	14	7	Domingo	6	2	1	2	Febrero	1	1	2021	t
2021-02-15	15	1	Lunes	7	3	1	2	Febrero	1	1	2021	f
2021-02-16	16	2	Martes	7	3	2	2	Febrero	1	1	2021	f
2021-02-17	17	3	Miércoles	7	3	2	2	Febrero	1	1	2021	f
2021-02-18	18	4	Jueves	7	3	2	2	Febrero	1	1	2021	f
2021-02-19	19	5	Viernes	7	3	2	2	Febrero	1	1	2021	f
2021-02-20	20	6	Sábado	7	3	2	2	Febrero	1	1	2021	t
2021-02-21	21	7	Domingo	7	3	2	2	Febrero	1	1	2021	t
2021-02-22	22	1	Lunes	8	4	2	2	Febrero	1	1	2021	f
2021-02-23	23	2	Martes	8	4	2	2	Febrero	1	1	2021	f
2021-02-24	24	3	Miércoles	8	4	2	2	Febrero	1	1	2021	f
2021-02-25	25	4	Jueves	8	4	2	2	Febrero	1	1	2021	f
2021-02-26	26	5	Viernes	8	4	2	2	Febrero	1	1	2021	f
2021-02-27	27	6	Sábado	8	4	2	2	Febrero	1	1	2021	t
2021-02-28	28	7	Domingo	8	4	2	2	Febrero	1	1	2021	t
2021-03-01	1	1	Lunes	9	1	1	3	Marzo	1	1	2021	f
2021-03-02	2	2	Martes	9	1	1	3	Marzo	1	1	2021	f
2021-03-03	3	3	Miércoles	9	1	1	3	Marzo	1	1	2021	f
2021-03-04	4	4	Jueves	9	1	1	3	Marzo	1	1	2021	f
2021-03-05	5	5	Viernes	9	1	1	3	Marzo	1	1	2021	f
2021-03-06	6	6	Sábado	9	1	1	3	Marzo	1	1	2021	t
2021-03-07	7	7	Domingo	9	1	1	3	Marzo	1	1	2021	t
2021-03-08	8	1	Lunes	10	2	1	3	Marzo	1	1	2021	f
2021-03-09	9	2	Martes	10	2	1	3	Marzo	1	1	2021	f
2021-03-10	10	3	Miércoles	10	2	1	3	Marzo	1	1	2021	f
2021-03-11	11	4	Jueves	10	2	1	3	Marzo	1	1	2021	f
2021-03-12	12	5	Viernes	10	2	1	3	Marzo	1	1	2021	f
2021-03-13	13	6	Sábado	10	2	1	3	Marzo	1	1	2021	t
2021-03-14	14	7	Domingo	10	2	1	3	Marzo	1	1	2021	t
2021-03-15	15	1	Lunes	11	3	1	3	Marzo	1	1	2021	f
2021-03-16	16	2	Martes	11	3	2	3	Marzo	1	1	2021	f
2021-03-17	17	3	Miércoles	11	3	2	3	Marzo	1	1	2021	f
2021-03-18	18	4	Jueves	11	3	2	3	Marzo	1	1	2021	f
2021-03-19	19	5	Viernes	11	3	2	3	Marzo	1	1	2021	f
2021-03-20	20	6	Sábado	11	3	2	3	Marzo	1	1	2021	t
2021-03-21	21	7	Domingo	11	3	2	3	Marzo	1	1	2021	t
2021-03-22	22	1	Lunes	12	4	2	3	Marzo	1	1	2021	f
2021-03-23	23	2	Martes	12	4	2	3	Marzo	1	1	2021	f
2021-03-24	24	3	Miércoles	12	4	2	3	Marzo	1	1	2021	f
2021-03-25	25	4	Jueves	12	4	2	3	Marzo	1	1	2021	f
2021-03-26	26	5	Viernes	12	4	2	3	Marzo	1	1	2021	f
2021-03-27	27	6	Sábado	12	4	2	3	Marzo	1	1	2021	t
2021-03-28	28	7	Domingo	12	4	2	3	Marzo	1	1	2021	t
2021-03-29	29	1	Lunes	13	5	2	3	Marzo	1	1	2021	f
2021-03-30	30	2	Martes	13	5	2	3	Marzo	1	1	2021	f
2021-03-31	31	3	Miércoles	13	5	2	3	Marzo	1	1	2021	f
2021-04-01	1	4	Jueves	13	1	1	4	Abril	2	1	2021	f
2021-04-02	2	5	Viernes	13	1	1	4	Abril	2	1	2021	f
2021-04-03	3	6	Sábado	13	1	1	4	Abril	2	1	2021	t
2021-04-04	4	7	Domingo	13	1	1	4	Abril	2	1	2021	t
2021-04-05	5	1	Lunes	14	2	1	4	Abril	2	1	2021	f
2021-04-06	6	2	Martes	14	2	1	4	Abril	2	1	2021	f
2021-04-07	7	3	Miércoles	14	2	1	4	Abril	2	1	2021	f
2021-04-08	8	4	Jueves	14	2	1	4	Abril	2	1	2021	f
2021-04-09	9	5	Viernes	14	2	1	4	Abril	2	1	2021	f
2021-04-10	10	6	Sábado	14	2	1	4	Abril	2	1	2021	t
2021-04-11	11	7	Domingo	14	2	1	4	Abril	2	1	2021	t
2021-04-12	12	1	Lunes	15	3	1	4	Abril	2	1	2021	f
2021-04-13	13	2	Martes	15	3	1	4	Abril	2	1	2021	f
2021-04-14	14	3	Miércoles	15	3	1	4	Abril	2	1	2021	f
2021-04-15	15	4	Jueves	15	3	1	4	Abril	2	1	2021	f
2021-04-16	16	5	Viernes	15	3	2	4	Abril	2	1	2021	f
2021-04-17	17	6	Sábado	15	3	2	4	Abril	2	1	2021	t
2021-04-18	18	7	Domingo	15	3	2	4	Abril	2	1	2021	t
2021-04-19	19	1	Lunes	16	4	2	4	Abril	2	1	2021	f
2021-04-20	20	2	Martes	16	4	2	4	Abril	2	1	2021	f
2021-04-21	21	3	Miércoles	16	4	2	4	Abril	2	1	2021	f
2021-04-22	22	4	Jueves	16	4	2	4	Abril	2	1	2021	f
2021-04-23	23	5	Viernes	16	4	2	4	Abril	2	1	2021	f
2021-04-24	24	6	Sábado	16	4	2	4	Abril	2	1	2021	t
2021-04-25	25	7	Domingo	16	4	2	4	Abril	2	1	2021	t
2021-04-26	26	1	Lunes	17	5	2	4	Abril	2	1	2021	f
2021-04-27	27	2	Martes	17	5	2	4	Abril	2	1	2021	f
2021-04-28	28	3	Miércoles	17	5	2	4	Abril	2	1	2021	f
2021-04-29	29	4	Jueves	17	5	2	4	Abril	2	1	2021	f
2021-04-30	30	5	Viernes	17	5	2	4	Abril	2	1	2021	f
2021-05-01	1	6	Sábado	17	1	1	5	Mayo	2	1	2021	t
2021-05-02	2	7	Domingo	17	1	1	5	Mayo	2	1	2021	t
2021-05-03	3	1	Lunes	18	2	1	5	Mayo	2	1	2021	f
2021-05-04	4	2	Martes	18	2	1	5	Mayo	2	1	2021	f
2021-05-05	5	3	Miércoles	18	2	1	5	Mayo	2	1	2021	f
2021-05-06	6	4	Jueves	18	2	1	5	Mayo	2	1	2021	f
2021-05-07	7	5	Viernes	18	2	1	5	Mayo	2	1	2021	f
2021-05-08	8	6	Sábado	18	2	1	5	Mayo	2	1	2021	t
2021-05-09	9	7	Domingo	18	2	1	5	Mayo	2	1	2021	t
2021-05-10	10	1	Lunes	19	3	1	5	Mayo	2	1	2021	f
2021-05-11	11	2	Martes	19	3	1	5	Mayo	2	1	2021	f
2021-05-12	12	3	Miércoles	19	3	1	5	Mayo	2	1	2021	f
2021-05-13	13	4	Jueves	19	3	1	5	Mayo	2	1	2021	f
2021-05-14	14	5	Viernes	19	3	1	5	Mayo	2	1	2021	f
2021-05-15	15	6	Sábado	19	3	1	5	Mayo	2	1	2021	t
2021-05-16	16	7	Domingo	19	3	2	5	Mayo	2	1	2021	t
2021-05-17	17	1	Lunes	20	4	2	5	Mayo	2	1	2021	f
2021-05-18	18	2	Martes	20	4	2	5	Mayo	2	1	2021	f
2021-05-19	19	3	Miércoles	20	4	2	5	Mayo	2	1	2021	f
2021-05-20	20	4	Jueves	20	4	2	5	Mayo	2	1	2021	f
2021-05-21	21	5	Viernes	20	4	2	5	Mayo	2	1	2021	f
2021-05-22	22	6	Sábado	20	4	2	5	Mayo	2	1	2021	t
2021-05-23	23	7	Domingo	20	4	2	5	Mayo	2	1	2021	t
2021-05-24	24	1	Lunes	21	5	2	5	Mayo	2	1	2021	f
2021-05-25	25	2	Martes	21	5	2	5	Mayo	2	1	2021	f
2021-05-26	26	3	Miércoles	21	5	2	5	Mayo	2	1	2021	f
2021-05-27	27	4	Jueves	21	5	2	5	Mayo	2	1	2021	f
2021-05-28	28	5	Viernes	21	5	2	5	Mayo	2	1	2021	f
2021-05-29	29	6	Sábado	21	5	2	5	Mayo	2	1	2021	t
2021-05-30	30	7	Domingo	21	5	2	5	Mayo	2	1	2021	t
2021-05-31	31	1	Lunes	22	6	2	5	Mayo	2	1	2021	f
2021-06-01	1	2	Martes	22	1	1	6	Junio	2	1	2021	f
2021-06-02	2	3	Miércoles	22	1	1	6	Junio	2	1	2021	f
2021-06-03	3	4	Jueves	22	1	1	6	Junio	2	1	2021	f
2021-06-04	4	5	Viernes	22	1	1	6	Junio	2	1	2021	f
2021-06-05	5	6	Sábado	22	1	1	6	Junio	2	1	2021	t
2021-06-06	6	7	Domingo	22	1	1	6	Junio	2	1	2021	t
2021-06-07	7	1	Lunes	23	2	1	6	Junio	2	1	2021	f
2021-06-08	8	2	Martes	23	2	1	6	Junio	2	1	2021	f
2021-06-09	9	3	Miércoles	23	2	1	6	Junio	2	1	2021	f
2021-06-10	10	4	Jueves	23	2	1	6	Junio	2	1	2021	f
2021-06-11	11	5	Viernes	23	2	1	6	Junio	2	1	2021	f
2021-06-12	12	6	Sábado	23	2	1	6	Junio	2	1	2021	t
2021-06-13	13	7	Domingo	23	2	1	6	Junio	2	1	2021	t
2021-06-14	14	1	Lunes	24	3	1	6	Junio	2	1	2021	f
2021-06-15	15	2	Martes	24	3	1	6	Junio	2	1	2021	f
2021-06-16	16	3	Miércoles	24	3	2	6	Junio	2	1	2021	f
2021-06-17	17	4	Jueves	24	3	2	6	Junio	2	1	2021	f
2021-06-18	18	5	Viernes	24	3	2	6	Junio	2	1	2021	f
2021-06-19	19	6	Sábado	24	3	2	6	Junio	2	1	2021	t
2021-06-20	20	7	Domingo	24	3	2	6	Junio	2	1	2021	t
2021-06-21	21	1	Lunes	25	4	2	6	Junio	2	1	2021	f
2021-06-22	22	2	Martes	25	4	2	6	Junio	2	1	2021	f
2021-06-23	23	3	Miércoles	25	4	2	6	Junio	2	1	2021	f
2021-06-24	24	4	Jueves	25	4	2	6	Junio	2	1	2021	f
2021-06-25	25	5	Viernes	25	4	2	6	Junio	2	1	2021	f
2021-06-26	26	6	Sábado	25	4	2	6	Junio	2	1	2021	t
2021-06-27	27	7	Domingo	25	4	2	6	Junio	2	1	2021	t
2021-06-28	28	1	Lunes	26	5	2	6	Junio	2	1	2021	f
2021-06-29	29	2	Martes	26	5	2	6	Junio	2	1	2021	f
2021-06-30	30	3	Miércoles	26	5	2	6	Junio	2	1	2021	f
2021-07-01	1	4	Jueves	26	1	1	7	Julio	3	2	2021	f
2021-07-02	2	5	Viernes	26	1	1	7	Julio	3	2	2021	f
2021-07-03	3	6	Sábado	26	1	1	7	Julio	3	2	2021	t
2021-07-04	4	7	Domingo	26	1	1	7	Julio	3	2	2021	t
2021-07-05	5	1	Lunes	27	2	1	7	Julio	3	2	2021	f
2021-07-06	6	2	Martes	27	2	1	7	Julio	3	2	2021	f
2021-07-07	7	3	Miércoles	27	2	1	7	Julio	3	2	2021	f
2021-07-08	8	4	Jueves	27	2	1	7	Julio	3	2	2021	f
2021-07-09	9	5	Viernes	27	2	1	7	Julio	3	2	2021	f
2021-07-10	10	6	Sábado	27	2	1	7	Julio	3	2	2021	t
2021-07-11	11	7	Domingo	27	2	1	7	Julio	3	2	2021	t
2021-07-12	12	1	Lunes	28	3	1	7	Julio	3	2	2021	f
2021-07-13	13	2	Martes	28	3	1	7	Julio	3	2	2021	f
2021-07-14	14	3	Miércoles	28	3	1	7	Julio	3	2	2021	f
2021-07-15	15	4	Jueves	28	3	1	7	Julio	3	2	2021	f
2021-07-16	16	5	Viernes	28	3	2	7	Julio	3	2	2021	f
2021-07-17	17	6	Sábado	28	3	2	7	Julio	3	2	2021	t
2021-07-18	18	7	Domingo	28	3	2	7	Julio	3	2	2021	t
2021-07-19	19	1	Lunes	29	4	2	7	Julio	3	2	2021	f
2021-07-20	20	2	Martes	29	4	2	7	Julio	3	2	2021	f
2021-07-21	21	3	Miércoles	29	4	2	7	Julio	3	2	2021	f
2021-07-22	22	4	Jueves	29	4	2	7	Julio	3	2	2021	f
2021-07-23	23	5	Viernes	29	4	2	7	Julio	3	2	2021	f
2021-07-24	24	6	Sábado	29	4	2	7	Julio	3	2	2021	t
2021-07-25	25	7	Domingo	29	4	2	7	Julio	3	2	2021	t
2021-07-26	26	1	Lunes	30	5	2	7	Julio	3	2	2021	f
2021-07-27	27	2	Martes	30	5	2	7	Julio	3	2	2021	f
2021-07-28	28	3	Miércoles	30	5	2	7	Julio	3	2	2021	f
2021-07-29	29	4	Jueves	30	5	2	7	Julio	3	2	2021	f
2021-07-30	30	5	Viernes	30	5	2	7	Julio	3	2	2021	f
2021-07-31	31	6	Sábado	30	5	2	7	Julio	3	2	2021	t
2021-08-01	1	7	Domingo	30	1	1	8	Agosto	3	2	2021	t
2021-08-02	2	1	Lunes	31	2	1	8	Agosto	3	2	2021	f
2021-08-03	3	2	Martes	31	2	1	8	Agosto	3	2	2021	f
2021-08-04	4	3	Miércoles	31	2	1	8	Agosto	3	2	2021	f
2021-08-05	5	4	Jueves	31	2	1	8	Agosto	3	2	2021	f
2021-08-06	6	5	Viernes	31	2	1	8	Agosto	3	2	2021	f
2021-08-07	7	6	Sábado	31	2	1	8	Agosto	3	2	2021	t
2021-08-08	8	7	Domingo	31	2	1	8	Agosto	3	2	2021	t
2021-08-09	9	1	Lunes	32	3	1	8	Agosto	3	2	2021	f
2021-08-10	10	2	Martes	32	3	1	8	Agosto	3	2	2021	f
2021-08-11	11	3	Miércoles	32	3	1	8	Agosto	3	2	2021	f
2021-08-12	12	4	Jueves	32	3	1	8	Agosto	3	2	2021	f
2021-08-13	13	5	Viernes	32	3	1	8	Agosto	3	2	2021	f
2021-08-14	14	6	Sábado	32	3	1	8	Agosto	3	2	2021	t
2021-08-15	15	7	Domingo	32	3	1	8	Agosto	3	2	2021	t
2021-08-16	16	1	Lunes	33	4	2	8	Agosto	3	2	2021	f
2021-08-17	17	2	Martes	33	4	2	8	Agosto	3	2	2021	f
2021-08-18	18	3	Miércoles	33	4	2	8	Agosto	3	2	2021	f
2021-08-19	19	4	Jueves	33	4	2	8	Agosto	3	2	2021	f
2021-08-20	20	5	Viernes	33	4	2	8	Agosto	3	2	2021	f
2021-08-21	21	6	Sábado	33	4	2	8	Agosto	3	2	2021	t
2021-08-22	22	7	Domingo	33	4	2	8	Agosto	3	2	2021	t
2021-08-23	23	1	Lunes	34	5	2	8	Agosto	3	2	2021	f
2021-08-24	24	2	Martes	34	5	2	8	Agosto	3	2	2021	f
2021-08-25	25	3	Miércoles	34	5	2	8	Agosto	3	2	2021	f
2021-08-26	26	4	Jueves	34	5	2	8	Agosto	3	2	2021	f
2021-08-27	27	5	Viernes	34	5	2	8	Agosto	3	2	2021	f
2021-08-28	28	6	Sábado	34	5	2	8	Agosto	3	2	2021	t
2021-08-29	29	7	Domingo	34	5	2	8	Agosto	3	2	2021	t
2021-08-30	30	1	Lunes	35	6	2	8	Agosto	3	2	2021	f
2021-08-31	31	2	Martes	35	6	2	8	Agosto	3	2	2021	f
2021-09-01	1	3	Miércoles	35	1	1	9	Septiembre	3	2	2021	f
2021-09-02	2	4	Jueves	35	1	1	9	Septiembre	3	2	2021	f
2021-09-03	3	5	Viernes	35	1	1	9	Septiembre	3	2	2021	f
2021-09-04	4	6	Sábado	35	1	1	9	Septiembre	3	2	2021	t
2021-09-05	5	7	Domingo	35	1	1	9	Septiembre	3	2	2021	t
2021-09-06	6	1	Lunes	36	2	1	9	Septiembre	3	2	2021	f
2021-09-07	7	2	Martes	36	2	1	9	Septiembre	3	2	2021	f
2021-09-08	8	3	Miércoles	36	2	1	9	Septiembre	3	2	2021	f
2021-09-09	9	4	Jueves	36	2	1	9	Septiembre	3	2	2021	f
2021-09-10	10	5	Viernes	36	2	1	9	Septiembre	3	2	2021	f
2021-09-11	11	6	Sábado	36	2	1	9	Septiembre	3	2	2021	t
2021-09-12	12	7	Domingo	36	2	1	9	Septiembre	3	2	2021	t
2021-09-13	13	1	Lunes	37	3	1	9	Septiembre	3	2	2021	f
2021-09-14	14	2	Martes	37	3	1	9	Septiembre	3	2	2021	f
2021-09-15	15	3	Miércoles	37	3	1	9	Septiembre	3	2	2021	f
2021-09-16	16	4	Jueves	37	3	2	9	Septiembre	3	2	2021	f
2021-09-17	17	5	Viernes	37	3	2	9	Septiembre	3	2	2021	f
2021-09-18	18	6	Sábado	37	3	2	9	Septiembre	3	2	2021	t
2021-09-19	19	7	Domingo	37	3	2	9	Septiembre	3	2	2021	t
2021-09-20	20	1	Lunes	38	4	2	9	Septiembre	3	2	2021	f
2021-09-21	21	2	Martes	38	4	2	9	Septiembre	3	2	2021	f
2021-09-22	22	3	Miércoles	38	4	2	9	Septiembre	3	2	2021	f
2021-09-23	23	4	Jueves	38	4	2	9	Septiembre	3	2	2021	f
2021-09-24	24	5	Viernes	38	4	2	9	Septiembre	3	2	2021	f
2021-09-25	25	6	Sábado	38	4	2	9	Septiembre	3	2	2021	t
2021-09-26	26	7	Domingo	38	4	2	9	Septiembre	3	2	2021	t
2021-09-27	27	1	Lunes	39	5	2	9	Septiembre	3	2	2021	f
2021-09-28	28	2	Martes	39	5	2	9	Septiembre	3	2	2021	f
2021-09-29	29	3	Miércoles	39	5	2	9	Septiembre	3	2	2021	f
2021-09-30	30	4	Jueves	39	5	2	9	Septiembre	3	2	2021	f
2021-10-01	1	5	Viernes	39	1	1	10	Octubre	4	2	2021	f
2021-10-02	2	6	Sábado	39	1	1	10	Octubre	4	2	2021	t
2021-10-03	3	7	Domingo	39	1	1	10	Octubre	4	2	2021	t
2021-10-04	4	1	Lunes	40	2	1	10	Octubre	4	2	2021	f
2021-10-05	5	2	Martes	40	2	1	10	Octubre	4	2	2021	f
2021-10-06	6	3	Miércoles	40	2	1	10	Octubre	4	2	2021	f
2021-10-07	7	4	Jueves	40	2	1	10	Octubre	4	2	2021	f
2021-10-08	8	5	Viernes	40	2	1	10	Octubre	4	2	2021	f
2021-10-09	9	6	Sábado	40	2	1	10	Octubre	4	2	2021	t
2021-10-10	10	7	Domingo	40	2	1	10	Octubre	4	2	2021	t
2021-10-11	11	1	Lunes	41	3	1	10	Octubre	4	2	2021	f
2021-10-12	12	2	Martes	41	3	1	10	Octubre	4	2	2021	f
2021-10-13	13	3	Miércoles	41	3	1	10	Octubre	4	2	2021	f
2021-10-14	14	4	Jueves	41	3	1	10	Octubre	4	2	2021	f
2021-10-15	15	5	Viernes	41	3	1	10	Octubre	4	2	2021	f
2021-10-16	16	6	Sábado	41	3	2	10	Octubre	4	2	2021	t
2021-10-17	17	7	Domingo	41	3	2	10	Octubre	4	2	2021	t
2021-10-18	18	1	Lunes	42	4	2	10	Octubre	4	2	2021	f
2021-10-19	19	2	Martes	42	4	2	10	Octubre	4	2	2021	f
2021-10-20	20	3	Miércoles	42	4	2	10	Octubre	4	2	2021	f
2021-10-21	21	4	Jueves	42	4	2	10	Octubre	4	2	2021	f
2021-10-22	22	5	Viernes	42	4	2	10	Octubre	4	2	2021	f
2021-10-23	23	6	Sábado	42	4	2	10	Octubre	4	2	2021	t
2021-10-24	24	7	Domingo	42	4	2	10	Octubre	4	2	2021	t
2021-10-25	25	1	Lunes	43	5	2	10	Octubre	4	2	2021	f
2021-10-26	26	2	Martes	43	5	2	10	Octubre	4	2	2021	f
2021-10-27	27	3	Miércoles	43	5	2	10	Octubre	4	2	2021	f
2021-10-28	28	4	Jueves	43	5	2	10	Octubre	4	2	2021	f
2021-10-29	29	5	Viernes	43	5	2	10	Octubre	4	2	2021	f
2021-10-30	30	6	Sábado	43	5	2	10	Octubre	4	2	2021	t
2021-10-31	31	7	Domingo	43	5	2	10	Octubre	4	2	2021	t
2021-11-01	1	1	Lunes	44	1	1	11	Noviembre	4	2	2021	f
2021-11-02	2	2	Martes	44	1	1	11	Noviembre	4	2	2021	f
2021-11-03	3	3	Miércoles	44	1	1	11	Noviembre	4	2	2021	f
2021-11-04	4	4	Jueves	44	1	1	11	Noviembre	4	2	2021	f
2021-11-05	5	5	Viernes	44	1	1	11	Noviembre	4	2	2021	f
2021-11-06	6	6	Sábado	44	1	1	11	Noviembre	4	2	2021	t
2021-11-07	7	7	Domingo	44	1	1	11	Noviembre	4	2	2021	t
2021-11-08	8	1	Lunes	45	2	1	11	Noviembre	4	2	2021	f
2021-11-09	9	2	Martes	45	2	1	11	Noviembre	4	2	2021	f
2021-11-10	10	3	Miércoles	45	2	1	11	Noviembre	4	2	2021	f
2021-11-11	11	4	Jueves	45	2	1	11	Noviembre	4	2	2021	f
2021-11-12	12	5	Viernes	45	2	1	11	Noviembre	4	2	2021	f
2021-11-13	13	6	Sábado	45	2	1	11	Noviembre	4	2	2021	t
2021-11-14	14	7	Domingo	45	2	1	11	Noviembre	4	2	2021	t
2021-11-15	15	1	Lunes	46	3	1	11	Noviembre	4	2	2021	f
2021-11-16	16	2	Martes	46	3	2	11	Noviembre	4	2	2021	f
2021-11-17	17	3	Miércoles	46	3	2	11	Noviembre	4	2	2021	f
2021-11-18	18	4	Jueves	46	3	2	11	Noviembre	4	2	2021	f
2021-11-19	19	5	Viernes	46	3	2	11	Noviembre	4	2	2021	f
2021-11-20	20	6	Sábado	46	3	2	11	Noviembre	4	2	2021	t
2021-11-21	21	7	Domingo	46	3	2	11	Noviembre	4	2	2021	t
2021-11-22	22	1	Lunes	47	4	2	11	Noviembre	4	2	2021	f
2021-11-23	23	2	Martes	47	4	2	11	Noviembre	4	2	2021	f
2021-11-24	24	3	Miércoles	47	4	2	11	Noviembre	4	2	2021	f
2021-11-25	25	4	Jueves	47	4	2	11	Noviembre	4	2	2021	f
2021-11-26	26	5	Viernes	47	4	2	11	Noviembre	4	2	2021	f
2021-11-27	27	6	Sábado	47	4	2	11	Noviembre	4	2	2021	t
2021-11-28	28	7	Domingo	47	4	2	11	Noviembre	4	2	2021	t
2021-11-29	29	1	Lunes	48	5	2	11	Noviembre	4	2	2021	f
2021-11-30	30	2	Martes	48	5	2	11	Noviembre	4	2	2021	f
2021-12-01	1	3	Miércoles	48	1	1	12	Diciembre	4	2	2021	f
2021-12-02	2	4	Jueves	48	1	1	12	Diciembre	4	2	2021	f
2021-12-03	3	5	Viernes	48	1	1	12	Diciembre	4	2	2021	f
2021-12-04	4	6	Sábado	48	1	1	12	Diciembre	4	2	2021	t
2021-12-05	5	7	Domingo	48	1	1	12	Diciembre	4	2	2021	t
2021-12-06	6	1	Lunes	49	2	1	12	Diciembre	4	2	2021	f
2021-12-07	7	2	Martes	49	2	1	12	Diciembre	4	2	2021	f
2021-12-08	8	3	Miércoles	49	2	1	12	Diciembre	4	2	2021	f
2021-12-09	9	4	Jueves	49	2	1	12	Diciembre	4	2	2021	f
2021-12-10	10	5	Viernes	49	2	1	12	Diciembre	4	2	2021	f
2021-12-11	11	6	Sábado	49	2	1	12	Diciembre	4	2	2021	t
2021-12-12	12	7	Domingo	49	2	1	12	Diciembre	4	2	2021	t
2021-12-13	13	1	Lunes	50	3	1	12	Diciembre	4	2	2021	f
2021-12-14	14	2	Martes	50	3	1	12	Diciembre	4	2	2021	f
2021-12-15	15	3	Miércoles	50	3	1	12	Diciembre	4	2	2021	f
2021-12-16	16	4	Jueves	50	3	2	12	Diciembre	4	2	2021	f
2021-12-17	17	5	Viernes	50	3	2	12	Diciembre	4	2	2021	f
2021-12-18	18	6	Sábado	50	3	2	12	Diciembre	4	2	2021	t
2021-12-19	19	7	Domingo	50	3	2	12	Diciembre	4	2	2021	t
2021-12-20	20	1	Lunes	51	4	2	12	Diciembre	4	2	2021	f
2021-12-21	21	2	Martes	51	4	2	12	Diciembre	4	2	2021	f
2021-12-22	22	3	Miércoles	51	4	2	12	Diciembre	4	2	2021	f
2021-12-23	23	4	Jueves	51	4	2	12	Diciembre	4	2	2021	f
2021-12-24	24	5	Viernes	51	4	2	12	Diciembre	4	2	2021	f
2021-12-25	25	6	Sábado	51	4	2	12	Diciembre	4	2	2021	t
2021-12-26	26	7	Domingo	51	4	2	12	Diciembre	4	2	2021	t
2021-12-27	27	1	Lunes	52	5	2	12	Diciembre	4	2	2021	f
2021-12-28	28	2	Martes	52	5	2	12	Diciembre	4	2	2021	f
2021-12-29	29	3	Miércoles	52	5	2	12	Diciembre	4	2	2021	f
2021-12-30	30	4	Jueves	52	5	2	12	Diciembre	4	2	2021	f
2021-12-31	31	5	Viernes	52	5	2	12	Diciembre	4	2	2021	f
2022-01-01	1	6	Sábado	52	1	1	1	Enero	1	1	2022	t
2022-01-02	2	7	Domingo	52	1	1	1	Enero	1	1	2022	t
2022-01-03	3	1	Lunes	1	2	1	1	Enero	1	1	2022	f
2022-01-04	4	2	Martes	1	2	1	1	Enero	1	1	2022	f
2022-01-05	5	3	Miércoles	1	2	1	1	Enero	1	1	2022	f
2022-01-06	6	4	Jueves	1	2	1	1	Enero	1	1	2022	f
2022-01-07	7	5	Viernes	1	2	1	1	Enero	1	1	2022	f
2022-01-08	8	6	Sábado	1	2	1	1	Enero	1	1	2022	t
2022-01-09	9	7	Domingo	1	2	1	1	Enero	1	1	2022	t
2022-01-10	10	1	Lunes	2	3	1	1	Enero	1	1	2022	f
2022-01-11	11	2	Martes	2	3	1	1	Enero	1	1	2022	f
2022-01-12	12	3	Miércoles	2	3	1	1	Enero	1	1	2022	f
2022-01-13	13	4	Jueves	2	3	1	1	Enero	1	1	2022	f
2022-01-14	14	5	Viernes	2	3	1	1	Enero	1	1	2022	f
2022-01-15	15	6	Sábado	2	3	1	1	Enero	1	1	2022	t
2022-01-16	16	7	Domingo	2	3	2	1	Enero	1	1	2022	t
2022-01-17	17	1	Lunes	3	4	2	1	Enero	1	1	2022	f
2022-01-18	18	2	Martes	3	4	2	1	Enero	1	1	2022	f
2022-01-19	19	3	Miércoles	3	4	2	1	Enero	1	1	2022	f
2022-01-20	20	4	Jueves	3	4	2	1	Enero	1	1	2022	f
2022-01-21	21	5	Viernes	3	4	2	1	Enero	1	1	2022	f
2022-01-22	22	6	Sábado	3	4	2	1	Enero	1	1	2022	t
2022-01-23	23	7	Domingo	3	4	2	1	Enero	1	1	2022	t
2022-01-24	24	1	Lunes	4	5	2	1	Enero	1	1	2022	f
2022-01-25	25	2	Martes	4	5	2	1	Enero	1	1	2022	f
2022-01-26	26	3	Miércoles	4	5	2	1	Enero	1	1	2022	f
2022-01-27	27	4	Jueves	4	5	2	1	Enero	1	1	2022	f
2022-01-28	28	5	Viernes	4	5	2	1	Enero	1	1	2022	f
2022-01-29	29	6	Sábado	4	5	2	1	Enero	1	1	2022	t
2022-01-30	30	7	Domingo	4	5	2	1	Enero	1	1	2022	t
2022-01-31	31	1	Lunes	5	6	2	1	Enero	1	1	2022	f
2022-02-01	1	2	Martes	5	1	1	2	Febrero	1	1	2022	f
2022-02-02	2	3	Miércoles	5	1	1	2	Febrero	1	1	2022	f
2022-02-03	3	4	Jueves	5	1	1	2	Febrero	1	1	2022	f
2022-02-04	4	5	Viernes	5	1	1	2	Febrero	1	1	2022	f
2022-02-05	5	6	Sábado	5	1	1	2	Febrero	1	1	2022	t
2022-02-06	6	7	Domingo	5	1	1	2	Febrero	1	1	2022	t
2022-02-07	7	1	Lunes	6	2	1	2	Febrero	1	1	2022	f
2022-02-08	8	2	Martes	6	2	1	2	Febrero	1	1	2022	f
2022-02-09	9	3	Miércoles	6	2	1	2	Febrero	1	1	2022	f
2022-02-10	10	4	Jueves	6	2	1	2	Febrero	1	1	2022	f
2022-02-11	11	5	Viernes	6	2	1	2	Febrero	1	1	2022	f
2022-02-12	12	6	Sábado	6	2	1	2	Febrero	1	1	2022	t
2022-02-13	13	7	Domingo	6	2	1	2	Febrero	1	1	2022	t
2022-02-14	14	1	Lunes	7	3	1	2	Febrero	1	1	2022	f
2022-02-15	15	2	Martes	7	3	1	2	Febrero	1	1	2022	f
2022-02-16	16	3	Miércoles	7	3	2	2	Febrero	1	1	2022	f
2022-02-17	17	4	Jueves	7	3	2	2	Febrero	1	1	2022	f
2022-02-18	18	5	Viernes	7	3	2	2	Febrero	1	1	2022	f
2022-02-19	19	6	Sábado	7	3	2	2	Febrero	1	1	2022	t
2022-02-20	20	7	Domingo	7	3	2	2	Febrero	1	1	2022	t
2022-02-21	21	1	Lunes	8	4	2	2	Febrero	1	1	2022	f
2022-02-22	22	2	Martes	8	4	2	2	Febrero	1	1	2022	f
2022-02-23	23	3	Miércoles	8	4	2	2	Febrero	1	1	2022	f
2022-02-24	24	4	Jueves	8	4	2	2	Febrero	1	1	2022	f
2022-02-25	25	5	Viernes	8	4	2	2	Febrero	1	1	2022	f
2022-02-26	26	6	Sábado	8	4	2	2	Febrero	1	1	2022	t
2022-02-27	27	7	Domingo	8	4	2	2	Febrero	1	1	2022	t
2022-02-28	28	1	Lunes	9	5	2	2	Febrero	1	1	2022	f
2022-03-01	1	2	Martes	9	1	1	3	Marzo	1	1	2022	f
2022-03-02	2	3	Miércoles	9	1	1	3	Marzo	1	1	2022	f
2022-03-03	3	4	Jueves	9	1	1	3	Marzo	1	1	2022	f
2022-03-04	4	5	Viernes	9	1	1	3	Marzo	1	1	2022	f
2022-03-05	5	6	Sábado	9	1	1	3	Marzo	1	1	2022	t
2022-03-06	6	7	Domingo	9	1	1	3	Marzo	1	1	2022	t
2022-03-07	7	1	Lunes	10	2	1	3	Marzo	1	1	2022	f
2022-03-08	8	2	Martes	10	2	1	3	Marzo	1	1	2022	f
2022-03-09	9	3	Miércoles	10	2	1	3	Marzo	1	1	2022	f
2022-03-10	10	4	Jueves	10	2	1	3	Marzo	1	1	2022	f
2022-03-11	11	5	Viernes	10	2	1	3	Marzo	1	1	2022	f
2022-03-12	12	6	Sábado	10	2	1	3	Marzo	1	1	2022	t
2022-03-13	13	7	Domingo	10	2	1	3	Marzo	1	1	2022	t
2022-03-14	14	1	Lunes	11	3	1	3	Marzo	1	1	2022	f
2022-03-15	15	2	Martes	11	3	1	3	Marzo	1	1	2022	f
2022-03-16	16	3	Miércoles	11	3	2	3	Marzo	1	1	2022	f
2022-03-17	17	4	Jueves	11	3	2	3	Marzo	1	1	2022	f
2022-03-18	18	5	Viernes	11	3	2	3	Marzo	1	1	2022	f
2022-03-19	19	6	Sábado	11	3	2	3	Marzo	1	1	2022	t
2022-03-20	20	7	Domingo	11	3	2	3	Marzo	1	1	2022	t
2022-03-21	21	1	Lunes	12	4	2	3	Marzo	1	1	2022	f
2022-03-22	22	2	Martes	12	4	2	3	Marzo	1	1	2022	f
2022-03-23	23	3	Miércoles	12	4	2	3	Marzo	1	1	2022	f
2022-03-24	24	4	Jueves	12	4	2	3	Marzo	1	1	2022	f
2022-03-25	25	5	Viernes	12	4	2	3	Marzo	1	1	2022	f
2022-03-26	26	6	Sábado	12	4	2	3	Marzo	1	1	2022	t
2022-03-27	27	7	Domingo	12	4	2	3	Marzo	1	1	2022	t
2022-03-28	28	1	Lunes	13	5	2	3	Marzo	1	1	2022	f
2022-03-29	29	2	Martes	13	5	2	3	Marzo	1	1	2022	f
2022-03-30	30	3	Miércoles	13	5	2	3	Marzo	1	1	2022	f
2022-03-31	31	4	Jueves	13	5	2	3	Marzo	1	1	2022	f
2022-04-01	1	5	Viernes	13	1	1	4	Abril	2	1	2022	f
2022-04-02	2	6	Sábado	13	1	1	4	Abril	2	1	2022	t
2022-04-03	3	7	Domingo	13	1	1	4	Abril	2	1	2022	t
2022-04-04	4	1	Lunes	14	2	1	4	Abril	2	1	2022	f
2022-04-05	5	2	Martes	14	2	1	4	Abril	2	1	2022	f
2022-04-06	6	3	Miércoles	14	2	1	4	Abril	2	1	2022	f
2022-04-07	7	4	Jueves	14	2	1	4	Abril	2	1	2022	f
2022-04-08	8	5	Viernes	14	2	1	4	Abril	2	1	2022	f
2022-04-09	9	6	Sábado	14	2	1	4	Abril	2	1	2022	t
2022-04-10	10	7	Domingo	14	2	1	4	Abril	2	1	2022	t
2022-04-11	11	1	Lunes	15	3	1	4	Abril	2	1	2022	f
2022-04-12	12	2	Martes	15	3	1	4	Abril	2	1	2022	f
2022-04-13	13	3	Miércoles	15	3	1	4	Abril	2	1	2022	f
2022-04-14	14	4	Jueves	15	3	1	4	Abril	2	1	2022	f
2022-04-15	15	5	Viernes	15	3	1	4	Abril	2	1	2022	f
2022-04-16	16	6	Sábado	15	3	2	4	Abril	2	1	2022	t
2022-04-17	17	7	Domingo	15	3	2	4	Abril	2	1	2022	t
2022-04-18	18	1	Lunes	16	4	2	4	Abril	2	1	2022	f
2022-04-19	19	2	Martes	16	4	2	4	Abril	2	1	2022	f
2022-04-20	20	3	Miércoles	16	4	2	4	Abril	2	1	2022	f
2022-04-21	21	4	Jueves	16	4	2	4	Abril	2	1	2022	f
2022-04-22	22	5	Viernes	16	4	2	4	Abril	2	1	2022	f
2022-04-23	23	6	Sábado	16	4	2	4	Abril	2	1	2022	t
2022-04-24	24	7	Domingo	16	4	2	4	Abril	2	1	2022	t
2022-04-25	25	1	Lunes	17	5	2	4	Abril	2	1	2022	f
2022-04-26	26	2	Martes	17	5	2	4	Abril	2	1	2022	f
2022-04-27	27	3	Miércoles	17	5	2	4	Abril	2	1	2022	f
2022-04-28	28	4	Jueves	17	5	2	4	Abril	2	1	2022	f
2022-04-29	29	5	Viernes	17	5	2	4	Abril	2	1	2022	f
2022-04-30	30	6	Sábado	17	5	2	4	Abril	2	1	2022	t
2022-05-01	1	7	Domingo	17	1	1	5	Mayo	2	1	2022	t
2022-05-02	2	1	Lunes	18	2	1	5	Mayo	2	1	2022	f
2022-05-03	3	2	Martes	18	2	1	5	Mayo	2	1	2022	f
2022-05-04	4	3	Miércoles	18	2	1	5	Mayo	2	1	2022	f
2022-05-05	5	4	Jueves	18	2	1	5	Mayo	2	1	2022	f
2022-05-06	6	5	Viernes	18	2	1	5	Mayo	2	1	2022	f
2022-05-07	7	6	Sábado	18	2	1	5	Mayo	2	1	2022	t
2022-05-08	8	7	Domingo	18	2	1	5	Mayo	2	1	2022	t
2022-05-09	9	1	Lunes	19	3	1	5	Mayo	2	1	2022	f
2022-05-10	10	2	Martes	19	3	1	5	Mayo	2	1	2022	f
2022-05-11	11	3	Miércoles	19	3	1	5	Mayo	2	1	2022	f
2022-05-12	12	4	Jueves	19	3	1	5	Mayo	2	1	2022	f
2022-05-13	13	5	Viernes	19	3	1	5	Mayo	2	1	2022	f
2022-05-14	14	6	Sábado	19	3	1	5	Mayo	2	1	2022	t
2022-05-15	15	7	Domingo	19	3	1	5	Mayo	2	1	2022	t
2022-05-16	16	1	Lunes	20	4	2	5	Mayo	2	1	2022	f
2022-05-17	17	2	Martes	20	4	2	5	Mayo	2	1	2022	f
2022-05-18	18	3	Miércoles	20	4	2	5	Mayo	2	1	2022	f
2022-05-19	19	4	Jueves	20	4	2	5	Mayo	2	1	2022	f
2022-05-20	20	5	Viernes	20	4	2	5	Mayo	2	1	2022	f
2022-05-21	21	6	Sábado	20	4	2	5	Mayo	2	1	2022	t
2022-05-22	22	7	Domingo	20	4	2	5	Mayo	2	1	2022	t
2022-05-23	23	1	Lunes	21	5	2	5	Mayo	2	1	2022	f
2022-05-24	24	2	Martes	21	5	2	5	Mayo	2	1	2022	f
2022-05-25	25	3	Miércoles	21	5	2	5	Mayo	2	1	2022	f
2022-05-26	26	4	Jueves	21	5	2	5	Mayo	2	1	2022	f
2022-05-27	27	5	Viernes	21	5	2	5	Mayo	2	1	2022	f
2022-05-28	28	6	Sábado	21	5	2	5	Mayo	2	1	2022	t
2022-05-29	29	7	Domingo	21	5	2	5	Mayo	2	1	2022	t
2022-05-30	30	1	Lunes	22	6	2	5	Mayo	2	1	2022	f
2022-05-31	31	2	Martes	22	6	2	5	Mayo	2	1	2022	f
2022-06-01	1	3	Miércoles	22	1	1	6	Junio	2	1	2022	f
2022-06-02	2	4	Jueves	22	1	1	6	Junio	2	1	2022	f
2022-06-03	3	5	Viernes	22	1	1	6	Junio	2	1	2022	f
2022-06-04	4	6	Sábado	22	1	1	6	Junio	2	1	2022	t
2022-06-05	5	7	Domingo	22	1	1	6	Junio	2	1	2022	t
2022-06-06	6	1	Lunes	23	2	1	6	Junio	2	1	2022	f
2022-06-07	7	2	Martes	23	2	1	6	Junio	2	1	2022	f
2022-06-08	8	3	Miércoles	23	2	1	6	Junio	2	1	2022	f
2022-06-09	9	4	Jueves	23	2	1	6	Junio	2	1	2022	f
2022-06-10	10	5	Viernes	23	2	1	6	Junio	2	1	2022	f
2022-06-11	11	6	Sábado	23	2	1	6	Junio	2	1	2022	t
2022-06-12	12	7	Domingo	23	2	1	6	Junio	2	1	2022	t
2022-06-13	13	1	Lunes	24	3	1	6	Junio	2	1	2022	f
2022-06-14	14	2	Martes	24	3	1	6	Junio	2	1	2022	f
2022-06-15	15	3	Miércoles	24	3	1	6	Junio	2	1	2022	f
2022-06-16	16	4	Jueves	24	3	2	6	Junio	2	1	2022	f
2022-06-17	17	5	Viernes	24	3	2	6	Junio	2	1	2022	f
2022-06-18	18	6	Sábado	24	3	2	6	Junio	2	1	2022	t
2022-06-19	19	7	Domingo	24	3	2	6	Junio	2	1	2022	t
2022-06-20	20	1	Lunes	25	4	2	6	Junio	2	1	2022	f
2022-06-21	21	2	Martes	25	4	2	6	Junio	2	1	2022	f
2022-06-22	22	3	Miércoles	25	4	2	6	Junio	2	1	2022	f
2022-06-23	23	4	Jueves	25	4	2	6	Junio	2	1	2022	f
2022-06-24	24	5	Viernes	25	4	2	6	Junio	2	1	2022	f
2022-06-25	25	6	Sábado	25	4	2	6	Junio	2	1	2022	t
2022-06-26	26	7	Domingo	25	4	2	6	Junio	2	1	2022	t
2022-06-27	27	1	Lunes	26	5	2	6	Junio	2	1	2022	f
2022-06-28	28	2	Martes	26	5	2	6	Junio	2	1	2022	f
2022-06-29	29	3	Miércoles	26	5	2	6	Junio	2	1	2022	f
2022-06-30	30	4	Jueves	26	5	2	6	Junio	2	1	2022	f
2022-07-01	1	5	Viernes	26	1	1	7	Julio	3	2	2022	f
2022-07-02	2	6	Sábado	26	1	1	7	Julio	3	2	2022	t
2022-07-03	3	7	Domingo	26	1	1	7	Julio	3	2	2022	t
2022-07-04	4	1	Lunes	27	2	1	7	Julio	3	2	2022	f
2022-07-05	5	2	Martes	27	2	1	7	Julio	3	2	2022	f
2022-07-06	6	3	Miércoles	27	2	1	7	Julio	3	2	2022	f
2022-07-07	7	4	Jueves	27	2	1	7	Julio	3	2	2022	f
2022-07-08	8	5	Viernes	27	2	1	7	Julio	3	2	2022	f
2022-07-09	9	6	Sábado	27	2	1	7	Julio	3	2	2022	t
2022-07-10	10	7	Domingo	27	2	1	7	Julio	3	2	2022	t
2022-07-11	11	1	Lunes	28	3	1	7	Julio	3	2	2022	f
2022-07-12	12	2	Martes	28	3	1	7	Julio	3	2	2022	f
2022-07-13	13	3	Miércoles	28	3	1	7	Julio	3	2	2022	f
2022-07-14	14	4	Jueves	28	3	1	7	Julio	3	2	2022	f
2022-07-15	15	5	Viernes	28	3	1	7	Julio	3	2	2022	f
2022-07-16	16	6	Sábado	28	3	2	7	Julio	3	2	2022	t
2022-07-17	17	7	Domingo	28	3	2	7	Julio	3	2	2022	t
2022-07-18	18	1	Lunes	29	4	2	7	Julio	3	2	2022	f
2022-07-19	19	2	Martes	29	4	2	7	Julio	3	2	2022	f
2022-07-20	20	3	Miércoles	29	4	2	7	Julio	3	2	2022	f
2022-07-21	21	4	Jueves	29	4	2	7	Julio	3	2	2022	f
2022-07-22	22	5	Viernes	29	4	2	7	Julio	3	2	2022	f
2022-07-23	23	6	Sábado	29	4	2	7	Julio	3	2	2022	t
2022-07-24	24	7	Domingo	29	4	2	7	Julio	3	2	2022	t
2022-07-25	25	1	Lunes	30	5	2	7	Julio	3	2	2022	f
2022-07-26	26	2	Martes	30	5	2	7	Julio	3	2	2022	f
2022-07-27	27	3	Miércoles	30	5	2	7	Julio	3	2	2022	f
2022-07-28	28	4	Jueves	30	5	2	7	Julio	3	2	2022	f
2022-07-29	29	5	Viernes	30	5	2	7	Julio	3	2	2022	f
2022-07-30	30	6	Sábado	30	5	2	7	Julio	3	2	2022	t
2022-07-31	31	7	Domingo	30	5	2	7	Julio	3	2	2022	t
2022-08-01	1	1	Lunes	31	1	1	8	Agosto	3	2	2022	f
2022-08-02	2	2	Martes	31	1	1	8	Agosto	3	2	2022	f
2022-08-03	3	3	Miércoles	31	1	1	8	Agosto	3	2	2022	f
2022-08-04	4	4	Jueves	31	1	1	8	Agosto	3	2	2022	f
2022-08-05	5	5	Viernes	31	1	1	8	Agosto	3	2	2022	f
2022-08-06	6	6	Sábado	31	1	1	8	Agosto	3	2	2022	t
2022-08-07	7	7	Domingo	31	1	1	8	Agosto	3	2	2022	t
2022-08-08	8	1	Lunes	32	2	1	8	Agosto	3	2	2022	f
2022-08-09	9	2	Martes	32	2	1	8	Agosto	3	2	2022	f
2022-08-10	10	3	Miércoles	32	2	1	8	Agosto	3	2	2022	f
2022-08-11	11	4	Jueves	32	2	1	8	Agosto	3	2	2022	f
2022-08-12	12	5	Viernes	32	2	1	8	Agosto	3	2	2022	f
2022-08-13	13	6	Sábado	32	2	1	8	Agosto	3	2	2022	t
2022-08-14	14	7	Domingo	32	2	1	8	Agosto	3	2	2022	t
2022-08-15	15	1	Lunes	33	3	1	8	Agosto	3	2	2022	f
2022-08-16	16	2	Martes	33	3	2	8	Agosto	3	2	2022	f
2022-08-17	17	3	Miércoles	33	3	2	8	Agosto	3	2	2022	f
2022-08-18	18	4	Jueves	33	3	2	8	Agosto	3	2	2022	f
2022-08-19	19	5	Viernes	33	3	2	8	Agosto	3	2	2022	f
2022-08-20	20	6	Sábado	33	3	2	8	Agosto	3	2	2022	t
2022-08-21	21	7	Domingo	33	3	2	8	Agosto	3	2	2022	t
2022-08-22	22	1	Lunes	34	4	2	8	Agosto	3	2	2022	f
2022-08-23	23	2	Martes	34	4	2	8	Agosto	3	2	2022	f
2022-08-24	24	3	Miércoles	34	4	2	8	Agosto	3	2	2022	f
2022-08-25	25	4	Jueves	34	4	2	8	Agosto	3	2	2022	f
2022-08-26	26	5	Viernes	34	4	2	8	Agosto	3	2	2022	f
2022-08-27	27	6	Sábado	34	4	2	8	Agosto	3	2	2022	t
2022-08-28	28	7	Domingo	34	4	2	8	Agosto	3	2	2022	t
2022-08-29	29	1	Lunes	35	5	2	8	Agosto	3	2	2022	f
2022-08-30	30	2	Martes	35	5	2	8	Agosto	3	2	2022	f
2022-08-31	31	3	Miércoles	35	5	2	8	Agosto	3	2	2022	f
2022-09-01	1	4	Jueves	35	1	1	9	Septiembre	3	2	2022	f
2022-09-02	2	5	Viernes	35	1	1	9	Septiembre	3	2	2022	f
2022-09-03	3	6	Sábado	35	1	1	9	Septiembre	3	2	2022	t
2022-09-04	4	7	Domingo	35	1	1	9	Septiembre	3	2	2022	t
2022-09-05	5	1	Lunes	36	2	1	9	Septiembre	3	2	2022	f
2022-09-06	6	2	Martes	36	2	1	9	Septiembre	3	2	2022	f
2022-09-07	7	3	Miércoles	36	2	1	9	Septiembre	3	2	2022	f
2022-09-08	8	4	Jueves	36	2	1	9	Septiembre	3	2	2022	f
2022-09-09	9	5	Viernes	36	2	1	9	Septiembre	3	2	2022	f
2022-09-10	10	6	Sábado	36	2	1	9	Septiembre	3	2	2022	t
2022-09-11	11	7	Domingo	36	2	1	9	Septiembre	3	2	2022	t
2022-09-12	12	1	Lunes	37	3	1	9	Septiembre	3	2	2022	f
2022-09-13	13	2	Martes	37	3	1	9	Septiembre	3	2	2022	f
2022-09-14	14	3	Miércoles	37	3	1	9	Septiembre	3	2	2022	f
2022-09-15	15	4	Jueves	37	3	1	9	Septiembre	3	2	2022	f
2022-09-16	16	5	Viernes	37	3	2	9	Septiembre	3	2	2022	f
2022-09-17	17	6	Sábado	37	3	2	9	Septiembre	3	2	2022	t
2022-09-18	18	7	Domingo	37	3	2	9	Septiembre	3	2	2022	t
2022-09-19	19	1	Lunes	38	4	2	9	Septiembre	3	2	2022	f
2022-09-20	20	2	Martes	38	4	2	9	Septiembre	3	2	2022	f
2022-09-21	21	3	Miércoles	38	4	2	9	Septiembre	3	2	2022	f
2022-09-22	22	4	Jueves	38	4	2	9	Septiembre	3	2	2022	f
2022-09-23	23	5	Viernes	38	4	2	9	Septiembre	3	2	2022	f
2022-09-24	24	6	Sábado	38	4	2	9	Septiembre	3	2	2022	t
2022-09-25	25	7	Domingo	38	4	2	9	Septiembre	3	2	2022	t
2022-09-26	26	1	Lunes	39	5	2	9	Septiembre	3	2	2022	f
2022-09-27	27	2	Martes	39	5	2	9	Septiembre	3	2	2022	f
2022-09-28	28	3	Miércoles	39	5	2	9	Septiembre	3	2	2022	f
2022-09-29	29	4	Jueves	39	5	2	9	Septiembre	3	2	2022	f
2022-09-30	30	5	Viernes	39	5	2	9	Septiembre	3	2	2022	f
2022-10-01	1	6	Sábado	39	1	1	10	Octubre	4	2	2022	t
2022-10-02	2	7	Domingo	39	1	1	10	Octubre	4	2	2022	t
2022-10-03	3	1	Lunes	40	2	1	10	Octubre	4	2	2022	f
2022-10-04	4	2	Martes	40	2	1	10	Octubre	4	2	2022	f
2022-10-05	5	3	Miércoles	40	2	1	10	Octubre	4	2	2022	f
2022-10-06	6	4	Jueves	40	2	1	10	Octubre	4	2	2022	f
2022-10-07	7	5	Viernes	40	2	1	10	Octubre	4	2	2022	f
2022-10-08	8	6	Sábado	40	2	1	10	Octubre	4	2	2022	t
2022-10-09	9	7	Domingo	40	2	1	10	Octubre	4	2	2022	t
2022-10-10	10	1	Lunes	41	3	1	10	Octubre	4	2	2022	f
2022-10-11	11	2	Martes	41	3	1	10	Octubre	4	2	2022	f
2022-10-12	12	3	Miércoles	41	3	1	10	Octubre	4	2	2022	f
2022-10-13	13	4	Jueves	41	3	1	10	Octubre	4	2	2022	f
2022-10-14	14	5	Viernes	41	3	1	10	Octubre	4	2	2022	f
2022-10-15	15	6	Sábado	41	3	1	10	Octubre	4	2	2022	t
2022-10-16	16	7	Domingo	41	3	2	10	Octubre	4	2	2022	t
2022-10-17	17	1	Lunes	42	4	2	10	Octubre	4	2	2022	f
2022-10-18	18	2	Martes	42	4	2	10	Octubre	4	2	2022	f
2022-10-19	19	3	Miércoles	42	4	2	10	Octubre	4	2	2022	f
2022-10-20	20	4	Jueves	42	4	2	10	Octubre	4	2	2022	f
2022-10-21	21	5	Viernes	42	4	2	10	Octubre	4	2	2022	f
2022-10-22	22	6	Sábado	42	4	2	10	Octubre	4	2	2022	t
2022-10-23	23	7	Domingo	42	4	2	10	Octubre	4	2	2022	t
2022-10-24	24	1	Lunes	43	5	2	10	Octubre	4	2	2022	f
2022-10-25	25	2	Martes	43	5	2	10	Octubre	4	2	2022	f
2022-10-26	26	3	Miércoles	43	5	2	10	Octubre	4	2	2022	f
2022-10-27	27	4	Jueves	43	5	2	10	Octubre	4	2	2022	f
2022-10-28	28	5	Viernes	43	5	2	10	Octubre	4	2	2022	f
2022-10-29	29	6	Sábado	43	5	2	10	Octubre	4	2	2022	t
2022-10-30	30	7	Domingo	43	5	2	10	Octubre	4	2	2022	t
2022-10-31	31	1	Lunes	44	6	2	10	Octubre	4	2	2022	f
2022-11-01	1	2	Martes	44	1	1	11	Noviembre	4	2	2022	f
2022-11-02	2	3	Miércoles	44	1	1	11	Noviembre	4	2	2022	f
2022-11-03	3	4	Jueves	44	1	1	11	Noviembre	4	2	2022	f
2022-11-04	4	5	Viernes	44	1	1	11	Noviembre	4	2	2022	f
2022-11-05	5	6	Sábado	44	1	1	11	Noviembre	4	2	2022	t
2022-11-06	6	7	Domingo	44	1	1	11	Noviembre	4	2	2022	t
2022-11-07	7	1	Lunes	45	2	1	11	Noviembre	4	2	2022	f
2022-11-08	8	2	Martes	45	2	1	11	Noviembre	4	2	2022	f
2022-11-09	9	3	Miércoles	45	2	1	11	Noviembre	4	2	2022	f
2022-11-10	10	4	Jueves	45	2	1	11	Noviembre	4	2	2022	f
2022-11-11	11	5	Viernes	45	2	1	11	Noviembre	4	2	2022	f
2022-11-12	12	6	Sábado	45	2	1	11	Noviembre	4	2	2022	t
2022-11-13	13	7	Domingo	45	2	1	11	Noviembre	4	2	2022	t
2022-11-14	14	1	Lunes	46	3	1	11	Noviembre	4	2	2022	f
2022-11-15	15	2	Martes	46	3	1	11	Noviembre	4	2	2022	f
2022-11-16	16	3	Miércoles	46	3	2	11	Noviembre	4	2	2022	f
2022-11-17	17	4	Jueves	46	3	2	11	Noviembre	4	2	2022	f
2022-11-18	18	5	Viernes	46	3	2	11	Noviembre	4	2	2022	f
2022-11-19	19	6	Sábado	46	3	2	11	Noviembre	4	2	2022	t
2022-11-20	20	7	Domingo	46	3	2	11	Noviembre	4	2	2022	t
2022-11-21	21	1	Lunes	47	4	2	11	Noviembre	4	2	2022	f
2022-11-22	22	2	Martes	47	4	2	11	Noviembre	4	2	2022	f
2022-11-23	23	3	Miércoles	47	4	2	11	Noviembre	4	2	2022	f
2022-11-24	24	4	Jueves	47	4	2	11	Noviembre	4	2	2022	f
2022-11-25	25	5	Viernes	47	4	2	11	Noviembre	4	2	2022	f
2022-11-26	26	6	Sábado	47	4	2	11	Noviembre	4	2	2022	t
2022-11-27	27	7	Domingo	47	4	2	11	Noviembre	4	2	2022	t
2022-11-28	28	1	Lunes	48	5	2	11	Noviembre	4	2	2022	f
2022-11-29	29	2	Martes	48	5	2	11	Noviembre	4	2	2022	f
2022-11-30	30	3	Miércoles	48	5	2	11	Noviembre	4	2	2022	f
2022-12-01	1	4	Jueves	48	1	1	12	Diciembre	4	2	2022	f
2022-12-02	2	5	Viernes	48	1	1	12	Diciembre	4	2	2022	f
2022-12-03	3	6	Sábado	48	1	1	12	Diciembre	4	2	2022	t
2022-12-04	4	7	Domingo	48	1	1	12	Diciembre	4	2	2022	t
2022-12-05	5	1	Lunes	49	2	1	12	Diciembre	4	2	2022	f
2022-12-06	6	2	Martes	49	2	1	12	Diciembre	4	2	2022	f
2022-12-07	7	3	Miércoles	49	2	1	12	Diciembre	4	2	2022	f
2022-12-08	8	4	Jueves	49	2	1	12	Diciembre	4	2	2022	f
2022-12-09	9	5	Viernes	49	2	1	12	Diciembre	4	2	2022	f
2022-12-10	10	6	Sábado	49	2	1	12	Diciembre	4	2	2022	t
2022-12-11	11	7	Domingo	49	2	1	12	Diciembre	4	2	2022	t
2022-12-12	12	1	Lunes	50	3	1	12	Diciembre	4	2	2022	f
2022-12-13	13	2	Martes	50	3	1	12	Diciembre	4	2	2022	f
2022-12-14	14	3	Miércoles	50	3	1	12	Diciembre	4	2	2022	f
2022-12-15	15	4	Jueves	50	3	1	12	Diciembre	4	2	2022	f
2022-12-16	16	5	Viernes	50	3	2	12	Diciembre	4	2	2022	f
2022-12-17	17	6	Sábado	50	3	2	12	Diciembre	4	2	2022	t
2022-12-18	18	7	Domingo	50	3	2	12	Diciembre	4	2	2022	t
2022-12-19	19	1	Lunes	51	4	2	12	Diciembre	4	2	2022	f
2022-12-20	20	2	Martes	51	4	2	12	Diciembre	4	2	2022	f
2022-12-21	21	3	Miércoles	51	4	2	12	Diciembre	4	2	2022	f
2022-12-22	22	4	Jueves	51	4	2	12	Diciembre	4	2	2022	f
2022-12-23	23	5	Viernes	51	4	2	12	Diciembre	4	2	2022	f
2022-12-24	24	6	Sábado	51	4	2	12	Diciembre	4	2	2022	t
2022-12-25	25	7	Domingo	51	4	2	12	Diciembre	4	2	2022	t
2022-12-26	26	1	Lunes	52	5	2	12	Diciembre	4	2	2022	f
2022-12-27	27	2	Martes	52	5	2	12	Diciembre	4	2	2022	f
2022-12-28	28	3	Miércoles	52	5	2	12	Diciembre	4	2	2022	f
2022-12-29	29	4	Jueves	52	5	2	12	Diciembre	4	2	2022	f
2022-12-30	30	5	Viernes	52	5	2	12	Diciembre	4	2	2022	f
2022-12-31	31	6	Sábado	52	5	2	12	Diciembre	4	2	2022	t
2023-01-01	1	7	Domingo	52	1	1	1	Enero	1	1	2023	t
2023-01-02	2	1	Lunes	1	2	1	1	Enero	1	1	2023	f
2023-01-03	3	2	Martes	1	2	1	1	Enero	1	1	2023	f
2023-01-04	4	3	Miércoles	1	2	1	1	Enero	1	1	2023	f
2023-01-05	5	4	Jueves	1	2	1	1	Enero	1	1	2023	f
2023-01-06	6	5	Viernes	1	2	1	1	Enero	1	1	2023	f
2023-01-07	7	6	Sábado	1	2	1	1	Enero	1	1	2023	t
2023-01-08	8	7	Domingo	1	2	1	1	Enero	1	1	2023	t
2023-01-09	9	1	Lunes	2	3	1	1	Enero	1	1	2023	f
2023-01-10	10	2	Martes	2	3	1	1	Enero	1	1	2023	f
2023-01-11	11	3	Miércoles	2	3	1	1	Enero	1	1	2023	f
2023-01-12	12	4	Jueves	2	3	1	1	Enero	1	1	2023	f
2023-01-13	13	5	Viernes	2	3	1	1	Enero	1	1	2023	f
2023-01-14	14	6	Sábado	2	3	1	1	Enero	1	1	2023	t
2023-01-15	15	7	Domingo	2	3	1	1	Enero	1	1	2023	t
2023-01-16	16	1	Lunes	3	4	2	1	Enero	1	1	2023	f
2023-01-17	17	2	Martes	3	4	2	1	Enero	1	1	2023	f
2023-01-18	18	3	Miércoles	3	4	2	1	Enero	1	1	2023	f
2023-01-19	19	4	Jueves	3	4	2	1	Enero	1	1	2023	f
2023-01-20	20	5	Viernes	3	4	2	1	Enero	1	1	2023	f
2023-01-21	21	6	Sábado	3	4	2	1	Enero	1	1	2023	t
2023-01-22	22	7	Domingo	3	4	2	1	Enero	1	1	2023	t
2023-01-23	23	1	Lunes	4	5	2	1	Enero	1	1	2023	f
2023-01-24	24	2	Martes	4	5	2	1	Enero	1	1	2023	f
2023-01-25	25	3	Miércoles	4	5	2	1	Enero	1	1	2023	f
2023-01-26	26	4	Jueves	4	5	2	1	Enero	1	1	2023	f
2023-01-27	27	5	Viernes	4	5	2	1	Enero	1	1	2023	f
2023-01-28	28	6	Sábado	4	5	2	1	Enero	1	1	2023	t
2023-01-29	29	7	Domingo	4	5	2	1	Enero	1	1	2023	t
2023-01-30	30	1	Lunes	5	6	2	1	Enero	1	1	2023	f
2023-01-31	31	2	Martes	5	6	2	1	Enero	1	1	2023	f
2023-02-01	1	3	Miércoles	5	1	1	2	Febrero	1	1	2023	f
2023-02-02	2	4	Jueves	5	1	1	2	Febrero	1	1	2023	f
2023-02-03	3	5	Viernes	5	1	1	2	Febrero	1	1	2023	f
2023-02-04	4	6	Sábado	5	1	1	2	Febrero	1	1	2023	t
2023-02-05	5	7	Domingo	5	1	1	2	Febrero	1	1	2023	t
2023-02-06	6	1	Lunes	6	2	1	2	Febrero	1	1	2023	f
2023-02-07	7	2	Martes	6	2	1	2	Febrero	1	1	2023	f
2023-02-08	8	3	Miércoles	6	2	1	2	Febrero	1	1	2023	f
2023-02-09	9	4	Jueves	6	2	1	2	Febrero	1	1	2023	f
2023-02-10	10	5	Viernes	6	2	1	2	Febrero	1	1	2023	f
2023-02-11	11	6	Sábado	6	2	1	2	Febrero	1	1	2023	t
2023-02-12	12	7	Domingo	6	2	1	2	Febrero	1	1	2023	t
2023-02-13	13	1	Lunes	7	3	1	2	Febrero	1	1	2023	f
2023-02-14	14	2	Martes	7	3	1	2	Febrero	1	1	2023	f
2023-02-15	15	3	Miércoles	7	3	1	2	Febrero	1	1	2023	f
2023-02-16	16	4	Jueves	7	3	2	2	Febrero	1	1	2023	f
2023-02-17	17	5	Viernes	7	3	2	2	Febrero	1	1	2023	f
2023-02-18	18	6	Sábado	7	3	2	2	Febrero	1	1	2023	t
2023-02-19	19	7	Domingo	7	3	2	2	Febrero	1	1	2023	t
2023-02-20	20	1	Lunes	8	4	2	2	Febrero	1	1	2023	f
2023-02-21	21	2	Martes	8	4	2	2	Febrero	1	1	2023	f
2023-02-22	22	3	Miércoles	8	4	2	2	Febrero	1	1	2023	f
2023-02-23	23	4	Jueves	8	4	2	2	Febrero	1	1	2023	f
2023-02-24	24	5	Viernes	8	4	2	2	Febrero	1	1	2023	f
2023-02-25	25	6	Sábado	8	4	2	2	Febrero	1	1	2023	t
2023-02-26	26	7	Domingo	8	4	2	2	Febrero	1	1	2023	t
2023-02-27	27	1	Lunes	9	5	2	2	Febrero	1	1	2023	f
2023-02-28	28	2	Martes	9	5	2	2	Febrero	1	1	2023	f
2023-03-01	1	3	Miércoles	9	1	1	3	Marzo	1	1	2023	f
2023-03-02	2	4	Jueves	9	1	1	3	Marzo	1	1	2023	f
2023-03-03	3	5	Viernes	9	1	1	3	Marzo	1	1	2023	f
2023-03-04	4	6	Sábado	9	1	1	3	Marzo	1	1	2023	t
2023-03-05	5	7	Domingo	9	1	1	3	Marzo	1	1	2023	t
2023-03-06	6	1	Lunes	10	2	1	3	Marzo	1	1	2023	f
2023-03-07	7	2	Martes	10	2	1	3	Marzo	1	1	2023	f
2023-03-08	8	3	Miércoles	10	2	1	3	Marzo	1	1	2023	f
2023-03-09	9	4	Jueves	10	2	1	3	Marzo	1	1	2023	f
2023-03-10	10	5	Viernes	10	2	1	3	Marzo	1	1	2023	f
2023-03-11	11	6	Sábado	10	2	1	3	Marzo	1	1	2023	t
2023-03-12	12	7	Domingo	10	2	1	3	Marzo	1	1	2023	t
2023-03-13	13	1	Lunes	11	3	1	3	Marzo	1	1	2023	f
2023-03-14	14	2	Martes	11	3	1	3	Marzo	1	1	2023	f
2023-03-15	15	3	Miércoles	11	3	1	3	Marzo	1	1	2023	f
2023-03-16	16	4	Jueves	11	3	2	3	Marzo	1	1	2023	f
2023-03-17	17	5	Viernes	11	3	2	3	Marzo	1	1	2023	f
2023-03-18	18	6	Sábado	11	3	2	3	Marzo	1	1	2023	t
2023-03-19	19	7	Domingo	11	3	2	3	Marzo	1	1	2023	t
2023-03-20	20	1	Lunes	12	4	2	3	Marzo	1	1	2023	f
2023-03-21	21	2	Martes	12	4	2	3	Marzo	1	1	2023	f
2023-03-22	22	3	Miércoles	12	4	2	3	Marzo	1	1	2023	f
2023-03-23	23	4	Jueves	12	4	2	3	Marzo	1	1	2023	f
2023-03-24	24	5	Viernes	12	4	2	3	Marzo	1	1	2023	f
2023-03-25	25	6	Sábado	12	4	2	3	Marzo	1	1	2023	t
2023-03-26	26	7	Domingo	12	4	2	3	Marzo	1	1	2023	t
2023-03-27	27	1	Lunes	13	5	2	3	Marzo	1	1	2023	f
2023-03-28	28	2	Martes	13	5	2	3	Marzo	1	1	2023	f
2023-03-29	29	3	Miércoles	13	5	2	3	Marzo	1	1	2023	f
2023-03-30	30	4	Jueves	13	5	2	3	Marzo	1	1	2023	f
2023-03-31	31	5	Viernes	13	5	2	3	Marzo	1	1	2023	f
2023-04-01	1	6	Sábado	13	1	1	4	Abril	2	1	2023	t
2023-04-02	2	7	Domingo	13	1	1	4	Abril	2	1	2023	t
2023-04-03	3	1	Lunes	14	2	1	4	Abril	2	1	2023	f
2023-04-04	4	2	Martes	14	2	1	4	Abril	2	1	2023	f
2023-04-05	5	3	Miércoles	14	2	1	4	Abril	2	1	2023	f
2023-04-06	6	4	Jueves	14	2	1	4	Abril	2	1	2023	f
2023-04-07	7	5	Viernes	14	2	1	4	Abril	2	1	2023	f
2023-04-08	8	6	Sábado	14	2	1	4	Abril	2	1	2023	t
2023-04-09	9	7	Domingo	14	2	1	4	Abril	2	1	2023	t
2023-04-10	10	1	Lunes	15	3	1	4	Abril	2	1	2023	f
2023-04-11	11	2	Martes	15	3	1	4	Abril	2	1	2023	f
2023-04-12	12	3	Miércoles	15	3	1	4	Abril	2	1	2023	f
2023-04-13	13	4	Jueves	15	3	1	4	Abril	2	1	2023	f
2023-04-14	14	5	Viernes	15	3	1	4	Abril	2	1	2023	f
2023-04-15	15	6	Sábado	15	3	1	4	Abril	2	1	2023	t
2023-04-16	16	7	Domingo	15	3	2	4	Abril	2	1	2023	t
2023-04-17	17	1	Lunes	16	4	2	4	Abril	2	1	2023	f
2023-04-18	18	2	Martes	16	4	2	4	Abril	2	1	2023	f
2023-04-19	19	3	Miércoles	16	4	2	4	Abril	2	1	2023	f
2023-04-20	20	4	Jueves	16	4	2	4	Abril	2	1	2023	f
2023-04-21	21	5	Viernes	16	4	2	4	Abril	2	1	2023	f
2023-04-22	22	6	Sábado	16	4	2	4	Abril	2	1	2023	t
2023-04-23	23	7	Domingo	16	4	2	4	Abril	2	1	2023	t
2023-04-24	24	1	Lunes	17	5	2	4	Abril	2	1	2023	f
2023-04-25	25	2	Martes	17	5	2	4	Abril	2	1	2023	f
2023-04-26	26	3	Miércoles	17	5	2	4	Abril	2	1	2023	f
2023-04-27	27	4	Jueves	17	5	2	4	Abril	2	1	2023	f
2023-04-28	28	5	Viernes	17	5	2	4	Abril	2	1	2023	f
2023-04-29	29	6	Sábado	17	5	2	4	Abril	2	1	2023	t
2023-04-30	30	7	Domingo	17	5	2	4	Abril	2	1	2023	t
2023-05-01	1	1	Lunes	18	1	1	5	Mayo	2	1	2023	f
2023-05-02	2	2	Martes	18	1	1	5	Mayo	2	1	2023	f
2023-05-03	3	3	Miércoles	18	1	1	5	Mayo	2	1	2023	f
2023-05-04	4	4	Jueves	18	1	1	5	Mayo	2	1	2023	f
2023-05-05	5	5	Viernes	18	1	1	5	Mayo	2	1	2023	f
2023-05-06	6	6	Sábado	18	1	1	5	Mayo	2	1	2023	t
2023-05-07	7	7	Domingo	18	1	1	5	Mayo	2	1	2023	t
2023-05-08	8	1	Lunes	19	2	1	5	Mayo	2	1	2023	f
2023-05-09	9	2	Martes	19	2	1	5	Mayo	2	1	2023	f
2023-05-10	10	3	Miércoles	19	2	1	5	Mayo	2	1	2023	f
2023-05-11	11	4	Jueves	19	2	1	5	Mayo	2	1	2023	f
2023-05-12	12	5	Viernes	19	2	1	5	Mayo	2	1	2023	f
2023-05-13	13	6	Sábado	19	2	1	5	Mayo	2	1	2023	t
2023-05-14	14	7	Domingo	19	2	1	5	Mayo	2	1	2023	t
2023-05-15	15	1	Lunes	20	3	1	5	Mayo	2	1	2023	f
2023-05-16	16	2	Martes	20	3	2	5	Mayo	2	1	2023	f
2023-05-17	17	3	Miércoles	20	3	2	5	Mayo	2	1	2023	f
2023-05-18	18	4	Jueves	20	3	2	5	Mayo	2	1	2023	f
2023-05-19	19	5	Viernes	20	3	2	5	Mayo	2	1	2023	f
2023-05-20	20	6	Sábado	20	3	2	5	Mayo	2	1	2023	t
2023-05-21	21	7	Domingo	20	3	2	5	Mayo	2	1	2023	t
2023-05-22	22	1	Lunes	21	4	2	5	Mayo	2	1	2023	f
2023-05-23	23	2	Martes	21	4	2	5	Mayo	2	1	2023	f
2023-05-24	24	3	Miércoles	21	4	2	5	Mayo	2	1	2023	f
2023-05-25	25	4	Jueves	21	4	2	5	Mayo	2	1	2023	f
2023-05-26	26	5	Viernes	21	4	2	5	Mayo	2	1	2023	f
2023-05-27	27	6	Sábado	21	4	2	5	Mayo	2	1	2023	t
2023-05-28	28	7	Domingo	21	4	2	5	Mayo	2	1	2023	t
2023-05-29	29	1	Lunes	22	5	2	5	Mayo	2	1	2023	f
2023-05-30	30	2	Martes	22	5	2	5	Mayo	2	1	2023	f
2023-05-31	31	3	Miércoles	22	5	2	5	Mayo	2	1	2023	f
2023-06-01	1	4	Jueves	22	1	1	6	Junio	2	1	2023	f
2023-06-02	2	5	Viernes	22	1	1	6	Junio	2	1	2023	f
2023-06-03	3	6	Sábado	22	1	1	6	Junio	2	1	2023	t
2023-06-04	4	7	Domingo	22	1	1	6	Junio	2	1	2023	t
2023-06-05	5	1	Lunes	23	2	1	6	Junio	2	1	2023	f
2023-06-06	6	2	Martes	23	2	1	6	Junio	2	1	2023	f
2023-06-07	7	3	Miércoles	23	2	1	6	Junio	2	1	2023	f
2023-06-08	8	4	Jueves	23	2	1	6	Junio	2	1	2023	f
2023-06-09	9	5	Viernes	23	2	1	6	Junio	2	1	2023	f
2023-06-10	10	6	Sábado	23	2	1	6	Junio	2	1	2023	t
2023-06-11	11	7	Domingo	23	2	1	6	Junio	2	1	2023	t
2023-06-12	12	1	Lunes	24	3	1	6	Junio	2	1	2023	f
2023-06-13	13	2	Martes	24	3	1	6	Junio	2	1	2023	f
2023-06-14	14	3	Miércoles	24	3	1	6	Junio	2	1	2023	f
2023-06-15	15	4	Jueves	24	3	1	6	Junio	2	1	2023	f
2023-06-16	16	5	Viernes	24	3	2	6	Junio	2	1	2023	f
2023-06-17	17	6	Sábado	24	3	2	6	Junio	2	1	2023	t
2023-06-18	18	7	Domingo	24	3	2	6	Junio	2	1	2023	t
2023-06-19	19	1	Lunes	25	4	2	6	Junio	2	1	2023	f
2023-06-20	20	2	Martes	25	4	2	6	Junio	2	1	2023	f
2023-06-21	21	3	Miércoles	25	4	2	6	Junio	2	1	2023	f
2023-06-22	22	4	Jueves	25	4	2	6	Junio	2	1	2023	f
2023-06-23	23	5	Viernes	25	4	2	6	Junio	2	1	2023	f
2023-06-24	24	6	Sábado	25	4	2	6	Junio	2	1	2023	t
2023-06-25	25	7	Domingo	25	4	2	6	Junio	2	1	2023	t
2023-06-26	26	1	Lunes	26	5	2	6	Junio	2	1	2023	f
2023-06-27	27	2	Martes	26	5	2	6	Junio	2	1	2023	f
2023-06-28	28	3	Miércoles	26	5	2	6	Junio	2	1	2023	f
2023-06-29	29	4	Jueves	26	5	2	6	Junio	2	1	2023	f
2023-06-30	30	5	Viernes	26	5	2	6	Junio	2	1	2023	f
2023-07-01	1	6	Sábado	26	1	1	7	Julio	3	2	2023	t
2023-07-02	2	7	Domingo	26	1	1	7	Julio	3	2	2023	t
2023-07-03	3	1	Lunes	27	2	1	7	Julio	3	2	2023	f
2023-07-04	4	2	Martes	27	2	1	7	Julio	3	2	2023	f
2023-07-05	5	3	Miércoles	27	2	1	7	Julio	3	2	2023	f
2023-07-06	6	4	Jueves	27	2	1	7	Julio	3	2	2023	f
2023-07-07	7	5	Viernes	27	2	1	7	Julio	3	2	2023	f
2023-07-08	8	6	Sábado	27	2	1	7	Julio	3	2	2023	t
2023-07-09	9	7	Domingo	27	2	1	7	Julio	3	2	2023	t
2023-07-10	10	1	Lunes	28	3	1	7	Julio	3	2	2023	f
2023-07-11	11	2	Martes	28	3	1	7	Julio	3	2	2023	f
2023-07-12	12	3	Miércoles	28	3	1	7	Julio	3	2	2023	f
2023-07-13	13	4	Jueves	28	3	1	7	Julio	3	2	2023	f
2023-07-14	14	5	Viernes	28	3	1	7	Julio	3	2	2023	f
2023-07-15	15	6	Sábado	28	3	1	7	Julio	3	2	2023	t
2023-07-16	16	7	Domingo	28	3	2	7	Julio	3	2	2023	t
2023-07-17	17	1	Lunes	29	4	2	7	Julio	3	2	2023	f
2023-07-18	18	2	Martes	29	4	2	7	Julio	3	2	2023	f
2023-07-19	19	3	Miércoles	29	4	2	7	Julio	3	2	2023	f
2023-07-20	20	4	Jueves	29	4	2	7	Julio	3	2	2023	f
2023-07-21	21	5	Viernes	29	4	2	7	Julio	3	2	2023	f
2023-07-22	22	6	Sábado	29	4	2	7	Julio	3	2	2023	t
2023-07-23	23	7	Domingo	29	4	2	7	Julio	3	2	2023	t
2023-07-24	24	1	Lunes	30	5	2	7	Julio	3	2	2023	f
2023-07-25	25	2	Martes	30	5	2	7	Julio	3	2	2023	f
2023-07-26	26	3	Miércoles	30	5	2	7	Julio	3	2	2023	f
2023-07-27	27	4	Jueves	30	5	2	7	Julio	3	2	2023	f
2023-07-28	28	5	Viernes	30	5	2	7	Julio	3	2	2023	f
2023-07-29	29	6	Sábado	30	5	2	7	Julio	3	2	2023	t
2023-07-30	30	7	Domingo	30	5	2	7	Julio	3	2	2023	t
2023-07-31	31	1	Lunes	31	6	2	7	Julio	3	2	2023	f
2023-08-01	1	2	Martes	31	1	1	8	Agosto	3	2	2023	f
2023-08-02	2	3	Miércoles	31	1	1	8	Agosto	3	2	2023	f
2023-08-03	3	4	Jueves	31	1	1	8	Agosto	3	2	2023	f
2023-08-04	4	5	Viernes	31	1	1	8	Agosto	3	2	2023	f
2023-08-05	5	6	Sábado	31	1	1	8	Agosto	3	2	2023	t
2023-08-06	6	7	Domingo	31	1	1	8	Agosto	3	2	2023	t
2023-08-07	7	1	Lunes	32	2	1	8	Agosto	3	2	2023	f
2023-08-08	8	2	Martes	32	2	1	8	Agosto	3	2	2023	f
2023-08-09	9	3	Miércoles	32	2	1	8	Agosto	3	2	2023	f
2023-08-10	10	4	Jueves	32	2	1	8	Agosto	3	2	2023	f
2023-08-11	11	5	Viernes	32	2	1	8	Agosto	3	2	2023	f
2023-08-12	12	6	Sábado	32	2	1	8	Agosto	3	2	2023	t
2023-08-13	13	7	Domingo	32	2	1	8	Agosto	3	2	2023	t
2023-08-14	14	1	Lunes	33	3	1	8	Agosto	3	2	2023	f
2023-08-15	15	2	Martes	33	3	1	8	Agosto	3	2	2023	f
2023-08-16	16	3	Miércoles	33	3	2	8	Agosto	3	2	2023	f
2023-08-17	17	4	Jueves	33	3	2	8	Agosto	3	2	2023	f
2023-08-18	18	5	Viernes	33	3	2	8	Agosto	3	2	2023	f
2023-08-19	19	6	Sábado	33	3	2	8	Agosto	3	2	2023	t
2023-08-20	20	7	Domingo	33	3	2	8	Agosto	3	2	2023	t
2023-08-21	21	1	Lunes	34	4	2	8	Agosto	3	2	2023	f
2023-08-22	22	2	Martes	34	4	2	8	Agosto	3	2	2023	f
2023-08-23	23	3	Miércoles	34	4	2	8	Agosto	3	2	2023	f
2023-08-24	24	4	Jueves	34	4	2	8	Agosto	3	2	2023	f
2023-08-25	25	5	Viernes	34	4	2	8	Agosto	3	2	2023	f
2023-08-26	26	6	Sábado	34	4	2	8	Agosto	3	2	2023	t
2023-08-27	27	7	Domingo	34	4	2	8	Agosto	3	2	2023	t
2023-08-28	28	1	Lunes	35	5	2	8	Agosto	3	2	2023	f
2023-08-29	29	2	Martes	35	5	2	8	Agosto	3	2	2023	f
2023-08-30	30	3	Miércoles	35	5	2	8	Agosto	3	2	2023	f
2023-08-31	31	4	Jueves	35	5	2	8	Agosto	3	2	2023	f
2023-09-01	1	5	Viernes	35	1	1	9	Septiembre	3	2	2023	f
2023-09-02	2	6	Sábado	35	1	1	9	Septiembre	3	2	2023	t
2023-09-03	3	7	Domingo	35	1	1	9	Septiembre	3	2	2023	t
2023-09-04	4	1	Lunes	36	2	1	9	Septiembre	3	2	2023	f
2023-09-05	5	2	Martes	36	2	1	9	Septiembre	3	2	2023	f
2023-09-06	6	3	Miércoles	36	2	1	9	Septiembre	3	2	2023	f
2023-09-07	7	4	Jueves	36	2	1	9	Septiembre	3	2	2023	f
2023-09-08	8	5	Viernes	36	2	1	9	Septiembre	3	2	2023	f
2023-09-09	9	6	Sábado	36	2	1	9	Septiembre	3	2	2023	t
2023-09-10	10	7	Domingo	36	2	1	9	Septiembre	3	2	2023	t
2023-09-11	11	1	Lunes	37	3	1	9	Septiembre	3	2	2023	f
2023-09-12	12	2	Martes	37	3	1	9	Septiembre	3	2	2023	f
2023-09-13	13	3	Miércoles	37	3	1	9	Septiembre	3	2	2023	f
2023-09-14	14	4	Jueves	37	3	1	9	Septiembre	3	2	2023	f
2023-09-15	15	5	Viernes	37	3	1	9	Septiembre	3	2	2023	f
2023-09-16	16	6	Sábado	37	3	2	9	Septiembre	3	2	2023	t
2023-09-17	17	7	Domingo	37	3	2	9	Septiembre	3	2	2023	t
2023-09-18	18	1	Lunes	38	4	2	9	Septiembre	3	2	2023	f
2023-09-19	19	2	Martes	38	4	2	9	Septiembre	3	2	2023	f
2023-09-20	20	3	Miércoles	38	4	2	9	Septiembre	3	2	2023	f
2023-09-21	21	4	Jueves	38	4	2	9	Septiembre	3	2	2023	f
2023-09-22	22	5	Viernes	38	4	2	9	Septiembre	3	2	2023	f
2023-09-23	23	6	Sábado	38	4	2	9	Septiembre	3	2	2023	t
2023-09-24	24	7	Domingo	38	4	2	9	Septiembre	3	2	2023	t
2023-09-25	25	1	Lunes	39	5	2	9	Septiembre	3	2	2023	f
2023-09-26	26	2	Martes	39	5	2	9	Septiembre	3	2	2023	f
2023-09-27	27	3	Miércoles	39	5	2	9	Septiembre	3	2	2023	f
2023-09-28	28	4	Jueves	39	5	2	9	Septiembre	3	2	2023	f
2023-09-29	29	5	Viernes	39	5	2	9	Septiembre	3	2	2023	f
2023-09-30	30	6	Sábado	39	5	2	9	Septiembre	3	2	2023	t
2023-10-01	1	7	Domingo	39	1	1	10	Octubre	4	2	2023	t
2023-10-02	2	1	Lunes	40	2	1	10	Octubre	4	2	2023	f
2023-10-03	3	2	Martes	40	2	1	10	Octubre	4	2	2023	f
2023-10-04	4	3	Miércoles	40	2	1	10	Octubre	4	2	2023	f
2023-10-05	5	4	Jueves	40	2	1	10	Octubre	4	2	2023	f
2023-10-06	6	5	Viernes	40	2	1	10	Octubre	4	2	2023	f
2023-10-07	7	6	Sábado	40	2	1	10	Octubre	4	2	2023	t
2023-10-08	8	7	Domingo	40	2	1	10	Octubre	4	2	2023	t
2023-10-09	9	1	Lunes	41	3	1	10	Octubre	4	2	2023	f
2023-10-10	10	2	Martes	41	3	1	10	Octubre	4	2	2023	f
2023-10-11	11	3	Miércoles	41	3	1	10	Octubre	4	2	2023	f
2023-10-12	12	4	Jueves	41	3	1	10	Octubre	4	2	2023	f
2023-10-13	13	5	Viernes	41	3	1	10	Octubre	4	2	2023	f
2023-10-14	14	6	Sábado	41	3	1	10	Octubre	4	2	2023	t
2023-10-15	15	7	Domingo	41	3	1	10	Octubre	4	2	2023	t
2023-10-16	16	1	Lunes	42	4	2	10	Octubre	4	2	2023	f
2023-10-17	17	2	Martes	42	4	2	10	Octubre	4	2	2023	f
2023-10-18	18	3	Miércoles	42	4	2	10	Octubre	4	2	2023	f
2023-10-19	19	4	Jueves	42	4	2	10	Octubre	4	2	2023	f
2023-10-20	20	5	Viernes	42	4	2	10	Octubre	4	2	2023	f
2023-10-21	21	6	Sábado	42	4	2	10	Octubre	4	2	2023	t
2023-10-22	22	7	Domingo	42	4	2	10	Octubre	4	2	2023	t
2023-10-23	23	1	Lunes	43	5	2	10	Octubre	4	2	2023	f
2023-10-24	24	2	Martes	43	5	2	10	Octubre	4	2	2023	f
2023-10-25	25	3	Miércoles	43	5	2	10	Octubre	4	2	2023	f
2023-10-26	26	4	Jueves	43	5	2	10	Octubre	4	2	2023	f
2023-10-27	27	5	Viernes	43	5	2	10	Octubre	4	2	2023	f
2023-10-28	28	6	Sábado	43	5	2	10	Octubre	4	2	2023	t
2023-10-29	29	7	Domingo	43	5	2	10	Octubre	4	2	2023	t
2023-10-30	30	1	Lunes	44	6	2	10	Octubre	4	2	2023	f
2023-10-31	31	2	Martes	44	6	2	10	Octubre	4	2	2023	f
2023-11-01	1	3	Miércoles	44	1	1	11	Noviembre	4	2	2023	f
2023-11-02	2	4	Jueves	44	1	1	11	Noviembre	4	2	2023	f
2023-11-03	3	5	Viernes	44	1	1	11	Noviembre	4	2	2023	f
2023-11-04	4	6	Sábado	44	1	1	11	Noviembre	4	2	2023	t
2023-11-05	5	7	Domingo	44	1	1	11	Noviembre	4	2	2023	t
2023-11-06	6	1	Lunes	45	2	1	11	Noviembre	4	2	2023	f
2023-11-07	7	2	Martes	45	2	1	11	Noviembre	4	2	2023	f
2023-11-08	8	3	Miércoles	45	2	1	11	Noviembre	4	2	2023	f
2023-11-09	9	4	Jueves	45	2	1	11	Noviembre	4	2	2023	f
2023-11-10	10	5	Viernes	45	2	1	11	Noviembre	4	2	2023	f
2023-11-11	11	6	Sábado	45	2	1	11	Noviembre	4	2	2023	t
2023-11-12	12	7	Domingo	45	2	1	11	Noviembre	4	2	2023	t
2023-11-13	13	1	Lunes	46	3	1	11	Noviembre	4	2	2023	f
2023-11-14	14	2	Martes	46	3	1	11	Noviembre	4	2	2023	f
2023-11-15	15	3	Miércoles	46	3	1	11	Noviembre	4	2	2023	f
2023-11-16	16	4	Jueves	46	3	2	11	Noviembre	4	2	2023	f
2023-11-17	17	5	Viernes	46	3	2	11	Noviembre	4	2	2023	f
2023-11-18	18	6	Sábado	46	3	2	11	Noviembre	4	2	2023	t
2023-11-19	19	7	Domingo	46	3	2	11	Noviembre	4	2	2023	t
2023-11-20	20	1	Lunes	47	4	2	11	Noviembre	4	2	2023	f
2023-11-21	21	2	Martes	47	4	2	11	Noviembre	4	2	2023	f
2023-11-22	22	3	Miércoles	47	4	2	11	Noviembre	4	2	2023	f
2023-11-23	23	4	Jueves	47	4	2	11	Noviembre	4	2	2023	f
2023-11-24	24	5	Viernes	47	4	2	11	Noviembre	4	2	2023	f
2023-11-25	25	6	Sábado	47	4	2	11	Noviembre	4	2	2023	t
2023-11-26	26	7	Domingo	47	4	2	11	Noviembre	4	2	2023	t
2023-11-27	27	1	Lunes	48	5	2	11	Noviembre	4	2	2023	f
2023-11-28	28	2	Martes	48	5	2	11	Noviembre	4	2	2023	f
2023-11-29	29	3	Miércoles	48	5	2	11	Noviembre	4	2	2023	f
2023-11-30	30	4	Jueves	48	5	2	11	Noviembre	4	2	2023	f
2023-12-01	1	5	Viernes	48	1	1	12	Diciembre	4	2	2023	f
2023-12-02	2	6	Sábado	48	1	1	12	Diciembre	4	2	2023	t
2023-12-03	3	7	Domingo	48	1	1	12	Diciembre	4	2	2023	t
2023-12-04	4	1	Lunes	49	2	1	12	Diciembre	4	2	2023	f
2023-12-05	5	2	Martes	49	2	1	12	Diciembre	4	2	2023	f
2023-12-06	6	3	Miércoles	49	2	1	12	Diciembre	4	2	2023	f
2023-12-07	7	4	Jueves	49	2	1	12	Diciembre	4	2	2023	f
2023-12-08	8	5	Viernes	49	2	1	12	Diciembre	4	2	2023	f
2023-12-09	9	6	Sábado	49	2	1	12	Diciembre	4	2	2023	t
2023-12-10	10	7	Domingo	49	2	1	12	Diciembre	4	2	2023	t
2023-12-11	11	1	Lunes	50	3	1	12	Diciembre	4	2	2023	f
2023-12-12	12	2	Martes	50	3	1	12	Diciembre	4	2	2023	f
2023-12-13	13	3	Miércoles	50	3	1	12	Diciembre	4	2	2023	f
2023-12-14	14	4	Jueves	50	3	1	12	Diciembre	4	2	2023	f
2023-12-15	15	5	Viernes	50	3	1	12	Diciembre	4	2	2023	f
2023-12-16	16	6	Sábado	50	3	2	12	Diciembre	4	2	2023	t
2023-12-17	17	7	Domingo	50	3	2	12	Diciembre	4	2	2023	t
2023-12-18	18	1	Lunes	51	4	2	12	Diciembre	4	2	2023	f
2023-12-19	19	2	Martes	51	4	2	12	Diciembre	4	2	2023	f
2023-12-20	20	3	Miércoles	51	4	2	12	Diciembre	4	2	2023	f
2023-12-21	21	4	Jueves	51	4	2	12	Diciembre	4	2	2023	f
2023-12-22	22	5	Viernes	51	4	2	12	Diciembre	4	2	2023	f
2023-12-23	23	6	Sábado	51	4	2	12	Diciembre	4	2	2023	t
2023-12-24	24	7	Domingo	51	4	2	12	Diciembre	4	2	2023	t
2023-12-25	25	1	Lunes	52	5	2	12	Diciembre	4	2	2023	f
2023-12-26	26	2	Martes	52	5	2	12	Diciembre	4	2	2023	f
2023-12-27	27	3	Miércoles	52	5	2	12	Diciembre	4	2	2023	f
2023-12-28	28	4	Jueves	52	5	2	12	Diciembre	4	2	2023	f
2023-12-29	29	5	Viernes	52	5	2	12	Diciembre	4	2	2023	f
2023-12-30	30	6	Sábado	52	5	2	12	Diciembre	4	2	2023	t
2023-12-31	31	7	Domingo	52	5	2	12	Diciembre	4	2	2023	t
2024-01-01	1	1	Lunes	1	1	1	1	Enero	1	1	2024	f
2024-01-02	2	2	Martes	1	1	1	1	Enero	1	1	2024	f
2024-01-03	3	3	Miércoles	1	1	1	1	Enero	1	1	2024	f
2024-01-04	4	4	Jueves	1	1	1	1	Enero	1	1	2024	f
2024-01-05	5	5	Viernes	1	1	1	1	Enero	1	1	2024	f
2024-01-06	6	6	Sábado	1	1	1	1	Enero	1	1	2024	t
2024-01-07	7	7	Domingo	1	1	1	1	Enero	1	1	2024	t
2024-01-08	8	1	Lunes	2	2	1	1	Enero	1	1	2024	f
2024-01-09	9	2	Martes	2	2	1	1	Enero	1	1	2024	f
2024-01-10	10	3	Miércoles	2	2	1	1	Enero	1	1	2024	f
2024-01-11	11	4	Jueves	2	2	1	1	Enero	1	1	2024	f
2024-01-12	12	5	Viernes	2	2	1	1	Enero	1	1	2024	f
2024-01-13	13	6	Sábado	2	2	1	1	Enero	1	1	2024	t
2024-01-14	14	7	Domingo	2	2	1	1	Enero	1	1	2024	t
2024-01-15	15	1	Lunes	3	3	1	1	Enero	1	1	2024	f
2024-01-16	16	2	Martes	3	3	2	1	Enero	1	1	2024	f
2024-01-17	17	3	Miércoles	3	3	2	1	Enero	1	1	2024	f
2024-01-18	18	4	Jueves	3	3	2	1	Enero	1	1	2024	f
2024-01-19	19	5	Viernes	3	3	2	1	Enero	1	1	2024	f
2024-01-20	20	6	Sábado	3	3	2	1	Enero	1	1	2024	t
2024-01-21	21	7	Domingo	3	3	2	1	Enero	1	1	2024	t
2024-01-22	22	1	Lunes	4	4	2	1	Enero	1	1	2024	f
2024-01-23	23	2	Martes	4	4	2	1	Enero	1	1	2024	f
2024-01-24	24	3	Miércoles	4	4	2	1	Enero	1	1	2024	f
2024-01-25	25	4	Jueves	4	4	2	1	Enero	1	1	2024	f
2024-01-26	26	5	Viernes	4	4	2	1	Enero	1	1	2024	f
2024-01-27	27	6	Sábado	4	4	2	1	Enero	1	1	2024	t
2024-01-28	28	7	Domingo	4	4	2	1	Enero	1	1	2024	t
2024-01-29	29	1	Lunes	5	5	2	1	Enero	1	1	2024	f
2024-01-30	30	2	Martes	5	5	2	1	Enero	1	1	2024	f
2024-01-31	31	3	Miércoles	5	5	2	1	Enero	1	1	2024	f
2024-02-01	1	4	Jueves	5	1	1	2	Febrero	1	1	2024	f
2024-02-02	2	5	Viernes	5	1	1	2	Febrero	1	1	2024	f
2024-02-03	3	6	Sábado	5	1	1	2	Febrero	1	1	2024	t
2024-02-04	4	7	Domingo	5	1	1	2	Febrero	1	1	2024	t
2024-02-05	5	1	Lunes	6	2	1	2	Febrero	1	1	2024	f
2024-02-06	6	2	Martes	6	2	1	2	Febrero	1	1	2024	f
2024-02-07	7	3	Miércoles	6	2	1	2	Febrero	1	1	2024	f
2024-02-08	8	4	Jueves	6	2	1	2	Febrero	1	1	2024	f
2024-02-09	9	5	Viernes	6	2	1	2	Febrero	1	1	2024	f
2024-02-10	10	6	Sábado	6	2	1	2	Febrero	1	1	2024	t
2024-02-11	11	7	Domingo	6	2	1	2	Febrero	1	1	2024	t
2024-02-12	12	1	Lunes	7	3	1	2	Febrero	1	1	2024	f
2024-02-13	13	2	Martes	7	3	1	2	Febrero	1	1	2024	f
2024-02-14	14	3	Miércoles	7	3	1	2	Febrero	1	1	2024	f
2024-02-15	15	4	Jueves	7	3	1	2	Febrero	1	1	2024	f
2024-02-16	16	5	Viernes	7	3	2	2	Febrero	1	1	2024	f
2024-02-17	17	6	Sábado	7	3	2	2	Febrero	1	1	2024	t
2024-02-18	18	7	Domingo	7	3	2	2	Febrero	1	1	2024	t
2024-02-19	19	1	Lunes	8	4	2	2	Febrero	1	1	2024	f
2024-02-20	20	2	Martes	8	4	2	2	Febrero	1	1	2024	f
2024-02-21	21	3	Miércoles	8	4	2	2	Febrero	1	1	2024	f
2024-02-22	22	4	Jueves	8	4	2	2	Febrero	1	1	2024	f
2024-02-23	23	5	Viernes	8	4	2	2	Febrero	1	1	2024	f
2024-02-24	24	6	Sábado	8	4	2	2	Febrero	1	1	2024	t
2024-02-25	25	7	Domingo	8	4	2	2	Febrero	1	1	2024	t
2024-02-26	26	1	Lunes	9	5	2	2	Febrero	1	1	2024	f
2024-02-27	27	2	Martes	9	5	2	2	Febrero	1	1	2024	f
2024-02-28	28	3	Miércoles	9	5	2	2	Febrero	1	1	2024	f
2024-02-29	29	4	Jueves	9	5	2	2	Febrero	1	1	2024	f
2024-03-01	1	5	Viernes	9	1	1	3	Marzo	1	1	2024	f
2024-03-02	2	6	Sábado	9	1	1	3	Marzo	1	1	2024	t
2024-03-03	3	7	Domingo	9	1	1	3	Marzo	1	1	2024	t
2024-03-04	4	1	Lunes	10	2	1	3	Marzo	1	1	2024	f
2024-03-05	5	2	Martes	10	2	1	3	Marzo	1	1	2024	f
2024-03-06	6	3	Miércoles	10	2	1	3	Marzo	1	1	2024	f
2024-03-07	7	4	Jueves	10	2	1	3	Marzo	1	1	2024	f
2024-03-08	8	5	Viernes	10	2	1	3	Marzo	1	1	2024	f
2024-03-09	9	6	Sábado	10	2	1	3	Marzo	1	1	2024	t
2024-03-10	10	7	Domingo	10	2	1	3	Marzo	1	1	2024	t
2024-03-11	11	1	Lunes	11	3	1	3	Marzo	1	1	2024	f
2024-03-12	12	2	Martes	11	3	1	3	Marzo	1	1	2024	f
2024-03-13	13	3	Miércoles	11	3	1	3	Marzo	1	1	2024	f
2024-03-14	14	4	Jueves	11	3	1	3	Marzo	1	1	2024	f
2024-03-15	15	5	Viernes	11	3	1	3	Marzo	1	1	2024	f
2024-03-16	16	6	Sábado	11	3	2	3	Marzo	1	1	2024	t
2024-03-17	17	7	Domingo	11	3	2	3	Marzo	1	1	2024	t
2024-03-18	18	1	Lunes	12	4	2	3	Marzo	1	1	2024	f
2024-03-19	19	2	Martes	12	4	2	3	Marzo	1	1	2024	f
2024-03-20	20	3	Miércoles	12	4	2	3	Marzo	1	1	2024	f
2024-03-21	21	4	Jueves	12	4	2	3	Marzo	1	1	2024	f
2024-03-22	22	5	Viernes	12	4	2	3	Marzo	1	1	2024	f
2024-03-23	23	6	Sábado	12	4	2	3	Marzo	1	1	2024	t
2024-03-24	24	7	Domingo	12	4	2	3	Marzo	1	1	2024	t
2024-03-25	25	1	Lunes	13	5	2	3	Marzo	1	1	2024	f
2024-03-26	26	2	Martes	13	5	2	3	Marzo	1	1	2024	f
2024-03-27	27	3	Miércoles	13	5	2	3	Marzo	1	1	2024	f
2024-03-28	28	4	Jueves	13	5	2	3	Marzo	1	1	2024	f
2024-03-29	29	5	Viernes	13	5	2	3	Marzo	1	1	2024	f
2024-03-30	30	6	Sábado	13	5	2	3	Marzo	1	1	2024	t
2024-03-31	31	7	Domingo	13	5	2	3	Marzo	1	1	2024	t
2024-04-01	1	1	Lunes	14	1	1	4	Abril	2	1	2024	f
2024-04-02	2	2	Martes	14	1	1	4	Abril	2	1	2024	f
2024-04-03	3	3	Miércoles	14	1	1	4	Abril	2	1	2024	f
2024-04-04	4	4	Jueves	14	1	1	4	Abril	2	1	2024	f
2024-04-05	5	5	Viernes	14	1	1	4	Abril	2	1	2024	f
2024-04-06	6	6	Sábado	14	1	1	4	Abril	2	1	2024	t
2024-04-07	7	7	Domingo	14	1	1	4	Abril	2	1	2024	t
2024-04-08	8	1	Lunes	15	2	1	4	Abril	2	1	2024	f
2024-04-09	9	2	Martes	15	2	1	4	Abril	2	1	2024	f
2024-04-10	10	3	Miércoles	15	2	1	4	Abril	2	1	2024	f
2024-04-11	11	4	Jueves	15	2	1	4	Abril	2	1	2024	f
2024-04-12	12	5	Viernes	15	2	1	4	Abril	2	1	2024	f
2024-04-13	13	6	Sábado	15	2	1	4	Abril	2	1	2024	t
2024-04-14	14	7	Domingo	15	2	1	4	Abril	2	1	2024	t
2024-04-15	15	1	Lunes	16	3	1	4	Abril	2	1	2024	f
2024-04-16	16	2	Martes	16	3	2	4	Abril	2	1	2024	f
2024-04-17	17	3	Miércoles	16	3	2	4	Abril	2	1	2024	f
2024-04-18	18	4	Jueves	16	3	2	4	Abril	2	1	2024	f
2024-04-19	19	5	Viernes	16	3	2	4	Abril	2	1	2024	f
2024-04-20	20	6	Sábado	16	3	2	4	Abril	2	1	2024	t
2024-04-21	21	7	Domingo	16	3	2	4	Abril	2	1	2024	t
2024-04-22	22	1	Lunes	17	4	2	4	Abril	2	1	2024	f
2024-04-23	23	2	Martes	17	4	2	4	Abril	2	1	2024	f
2024-04-24	24	3	Miércoles	17	4	2	4	Abril	2	1	2024	f
2024-04-25	25	4	Jueves	17	4	2	4	Abril	2	1	2024	f
2024-04-26	26	5	Viernes	17	4	2	4	Abril	2	1	2024	f
2024-04-27	27	6	Sábado	17	4	2	4	Abril	2	1	2024	t
2024-04-28	28	7	Domingo	17	4	2	4	Abril	2	1	2024	t
2024-04-29	29	1	Lunes	18	5	2	4	Abril	2	1	2024	f
2024-04-30	30	2	Martes	18	5	2	4	Abril	2	1	2024	f
2024-05-01	1	3	Miércoles	18	1	1	5	Mayo	2	1	2024	f
2024-05-02	2	4	Jueves	18	1	1	5	Mayo	2	1	2024	f
2024-05-03	3	5	Viernes	18	1	1	5	Mayo	2	1	2024	f
2024-05-04	4	6	Sábado	18	1	1	5	Mayo	2	1	2024	t
2024-05-05	5	7	Domingo	18	1	1	5	Mayo	2	1	2024	t
2024-05-06	6	1	Lunes	19	2	1	5	Mayo	2	1	2024	f
2024-05-07	7	2	Martes	19	2	1	5	Mayo	2	1	2024	f
2024-05-08	8	3	Miércoles	19	2	1	5	Mayo	2	1	2024	f
2024-05-09	9	4	Jueves	19	2	1	5	Mayo	2	1	2024	f
2024-05-10	10	5	Viernes	19	2	1	5	Mayo	2	1	2024	f
2024-05-11	11	6	Sábado	19	2	1	5	Mayo	2	1	2024	t
2024-05-12	12	7	Domingo	19	2	1	5	Mayo	2	1	2024	t
2024-05-13	13	1	Lunes	20	3	1	5	Mayo	2	1	2024	f
2024-05-14	14	2	Martes	20	3	1	5	Mayo	2	1	2024	f
2024-05-15	15	3	Miércoles	20	3	1	5	Mayo	2	1	2024	f
2024-05-16	16	4	Jueves	20	3	2	5	Mayo	2	1	2024	f
2024-05-17	17	5	Viernes	20	3	2	5	Mayo	2	1	2024	f
2024-05-18	18	6	Sábado	20	3	2	5	Mayo	2	1	2024	t
2024-05-19	19	7	Domingo	20	3	2	5	Mayo	2	1	2024	t
2024-05-20	20	1	Lunes	21	4	2	5	Mayo	2	1	2024	f
2024-05-21	21	2	Martes	21	4	2	5	Mayo	2	1	2024	f
2024-05-22	22	3	Miércoles	21	4	2	5	Mayo	2	1	2024	f
2024-05-23	23	4	Jueves	21	4	2	5	Mayo	2	1	2024	f
2024-05-24	24	5	Viernes	21	4	2	5	Mayo	2	1	2024	f
2024-05-25	25	6	Sábado	21	4	2	5	Mayo	2	1	2024	t
2024-05-26	26	7	Domingo	21	4	2	5	Mayo	2	1	2024	t
2024-05-27	27	1	Lunes	22	5	2	5	Mayo	2	1	2024	f
2024-05-28	28	2	Martes	22	5	2	5	Mayo	2	1	2024	f
2024-05-29	29	3	Miércoles	22	5	2	5	Mayo	2	1	2024	f
2024-05-30	30	4	Jueves	22	5	2	5	Mayo	2	1	2024	f
2024-05-31	31	5	Viernes	22	5	2	5	Mayo	2	1	2024	f
2024-06-01	1	6	Sábado	22	1	1	6	Junio	2	1	2024	t
2024-06-02	2	7	Domingo	22	1	1	6	Junio	2	1	2024	t
2024-06-03	3	1	Lunes	23	2	1	6	Junio	2	1	2024	f
2024-06-04	4	2	Martes	23	2	1	6	Junio	2	1	2024	f
2024-06-05	5	3	Miércoles	23	2	1	6	Junio	2	1	2024	f
2024-06-06	6	4	Jueves	23	2	1	6	Junio	2	1	2024	f
2024-06-07	7	5	Viernes	23	2	1	6	Junio	2	1	2024	f
2024-06-08	8	6	Sábado	23	2	1	6	Junio	2	1	2024	t
2024-06-09	9	7	Domingo	23	2	1	6	Junio	2	1	2024	t
2024-06-10	10	1	Lunes	24	3	1	6	Junio	2	1	2024	f
2024-06-11	11	2	Martes	24	3	1	6	Junio	2	1	2024	f
2024-06-12	12	3	Miércoles	24	3	1	6	Junio	2	1	2024	f
2024-06-13	13	4	Jueves	24	3	1	6	Junio	2	1	2024	f
2024-06-14	14	5	Viernes	24	3	1	6	Junio	2	1	2024	f
2024-06-15	15	6	Sábado	24	3	1	6	Junio	2	1	2024	t
2024-06-16	16	7	Domingo	24	3	2	6	Junio	2	1	2024	t
2024-06-17	17	1	Lunes	25	4	2	6	Junio	2	1	2024	f
2024-06-18	18	2	Martes	25	4	2	6	Junio	2	1	2024	f
2024-06-19	19	3	Miércoles	25	4	2	6	Junio	2	1	2024	f
2024-06-20	20	4	Jueves	25	4	2	6	Junio	2	1	2024	f
2024-06-21	21	5	Viernes	25	4	2	6	Junio	2	1	2024	f
2024-06-22	22	6	Sábado	25	4	2	6	Junio	2	1	2024	t
2024-06-23	23	7	Domingo	25	4	2	6	Junio	2	1	2024	t
2024-06-24	24	1	Lunes	26	5	2	6	Junio	2	1	2024	f
2024-06-25	25	2	Martes	26	5	2	6	Junio	2	1	2024	f
2024-06-26	26	3	Miércoles	26	5	2	6	Junio	2	1	2024	f
2024-06-27	27	4	Jueves	26	5	2	6	Junio	2	1	2024	f
2024-06-28	28	5	Viernes	26	5	2	6	Junio	2	1	2024	f
2024-06-29	29	6	Sábado	26	5	2	6	Junio	2	1	2024	t
2024-06-30	30	7	Domingo	26	5	2	6	Junio	2	1	2024	t
2024-07-01	1	1	Lunes	27	1	1	7	Julio	3	2	2024	f
2024-07-02	2	2	Martes	27	1	1	7	Julio	3	2	2024	f
2024-07-03	3	3	Miércoles	27	1	1	7	Julio	3	2	2024	f
2024-07-04	4	4	Jueves	27	1	1	7	Julio	3	2	2024	f
2024-07-05	5	5	Viernes	27	1	1	7	Julio	3	2	2024	f
2024-07-06	6	6	Sábado	27	1	1	7	Julio	3	2	2024	t
2024-07-07	7	7	Domingo	27	1	1	7	Julio	3	2	2024	t
2024-07-08	8	1	Lunes	28	2	1	7	Julio	3	2	2024	f
2024-07-09	9	2	Martes	28	2	1	7	Julio	3	2	2024	f
2024-07-10	10	3	Miércoles	28	2	1	7	Julio	3	2	2024	f
2024-07-11	11	4	Jueves	28	2	1	7	Julio	3	2	2024	f
2024-07-12	12	5	Viernes	28	2	1	7	Julio	3	2	2024	f
2024-07-13	13	6	Sábado	28	2	1	7	Julio	3	2	2024	t
2024-07-14	14	7	Domingo	28	2	1	7	Julio	3	2	2024	t
2024-07-15	15	1	Lunes	29	3	1	7	Julio	3	2	2024	f
2024-07-16	16	2	Martes	29	3	2	7	Julio	3	2	2024	f
2024-07-17	17	3	Miércoles	29	3	2	7	Julio	3	2	2024	f
2024-07-18	18	4	Jueves	29	3	2	7	Julio	3	2	2024	f
2024-07-19	19	5	Viernes	29	3	2	7	Julio	3	2	2024	f
2024-07-20	20	6	Sábado	29	3	2	7	Julio	3	2	2024	t
2024-07-21	21	7	Domingo	29	3	2	7	Julio	3	2	2024	t
2024-07-22	22	1	Lunes	30	4	2	7	Julio	3	2	2024	f
2024-07-23	23	2	Martes	30	4	2	7	Julio	3	2	2024	f
2024-07-24	24	3	Miércoles	30	4	2	7	Julio	3	2	2024	f
2024-07-25	25	4	Jueves	30	4	2	7	Julio	3	2	2024	f
2024-07-26	26	5	Viernes	30	4	2	7	Julio	3	2	2024	f
2024-07-27	27	6	Sábado	30	4	2	7	Julio	3	2	2024	t
2024-07-28	28	7	Domingo	30	4	2	7	Julio	3	2	2024	t
2024-07-29	29	1	Lunes	31	5	2	7	Julio	3	2	2024	f
2024-07-30	30	2	Martes	31	5	2	7	Julio	3	2	2024	f
2024-07-31	31	3	Miércoles	31	5	2	7	Julio	3	2	2024	f
2024-08-01	1	4	Jueves	31	1	1	8	Agosto	3	2	2024	f
2024-08-02	2	5	Viernes	31	1	1	8	Agosto	3	2	2024	f
2024-08-03	3	6	Sábado	31	1	1	8	Agosto	3	2	2024	t
2024-08-04	4	7	Domingo	31	1	1	8	Agosto	3	2	2024	t
2024-08-05	5	1	Lunes	32	2	1	8	Agosto	3	2	2024	f
2024-08-06	6	2	Martes	32	2	1	8	Agosto	3	2	2024	f
2024-08-07	7	3	Miércoles	32	2	1	8	Agosto	3	2	2024	f
2024-08-08	8	4	Jueves	32	2	1	8	Agosto	3	2	2024	f
2024-08-09	9	5	Viernes	32	2	1	8	Agosto	3	2	2024	f
2024-08-10	10	6	Sábado	32	2	1	8	Agosto	3	2	2024	t
2024-08-11	11	7	Domingo	32	2	1	8	Agosto	3	2	2024	t
2024-08-12	12	1	Lunes	33	3	1	8	Agosto	3	2	2024	f
2024-08-13	13	2	Martes	33	3	1	8	Agosto	3	2	2024	f
2024-08-14	14	3	Miércoles	33	3	1	8	Agosto	3	2	2024	f
2024-08-15	15	4	Jueves	33	3	1	8	Agosto	3	2	2024	f
2024-08-16	16	5	Viernes	33	3	2	8	Agosto	3	2	2024	f
2024-08-17	17	6	Sábado	33	3	2	8	Agosto	3	2	2024	t
2024-08-18	18	7	Domingo	33	3	2	8	Agosto	3	2	2024	t
2024-08-19	19	1	Lunes	34	4	2	8	Agosto	3	2	2024	f
2024-08-20	20	2	Martes	34	4	2	8	Agosto	3	2	2024	f
2024-08-21	21	3	Miércoles	34	4	2	8	Agosto	3	2	2024	f
2024-08-22	22	4	Jueves	34	4	2	8	Agosto	3	2	2024	f
2024-08-23	23	5	Viernes	34	4	2	8	Agosto	3	2	2024	f
2024-08-24	24	6	Sábado	34	4	2	8	Agosto	3	2	2024	t
2024-08-25	25	7	Domingo	34	4	2	8	Agosto	3	2	2024	t
2024-08-26	26	1	Lunes	35	5	2	8	Agosto	3	2	2024	f
2024-08-27	27	2	Martes	35	5	2	8	Agosto	3	2	2024	f
2024-08-28	28	3	Miércoles	35	5	2	8	Agosto	3	2	2024	f
2024-08-29	29	4	Jueves	35	5	2	8	Agosto	3	2	2024	f
2024-08-30	30	5	Viernes	35	5	2	8	Agosto	3	2	2024	f
2024-08-31	31	6	Sábado	35	5	2	8	Agosto	3	2	2024	t
2024-09-01	1	7	Domingo	35	1	1	9	Septiembre	3	2	2024	t
2024-09-02	2	1	Lunes	36	2	1	9	Septiembre	3	2	2024	f
2024-09-03	3	2	Martes	36	2	1	9	Septiembre	3	2	2024	f
2024-09-04	4	3	Miércoles	36	2	1	9	Septiembre	3	2	2024	f
2024-09-05	5	4	Jueves	36	2	1	9	Septiembre	3	2	2024	f
2024-09-06	6	5	Viernes	36	2	1	9	Septiembre	3	2	2024	f
2024-09-07	7	6	Sábado	36	2	1	9	Septiembre	3	2	2024	t
2024-09-08	8	7	Domingo	36	2	1	9	Septiembre	3	2	2024	t
2024-09-09	9	1	Lunes	37	3	1	9	Septiembre	3	2	2024	f
2024-09-10	10	2	Martes	37	3	1	9	Septiembre	3	2	2024	f
2024-09-11	11	3	Miércoles	37	3	1	9	Septiembre	3	2	2024	f
2024-09-12	12	4	Jueves	37	3	1	9	Septiembre	3	2	2024	f
2024-09-13	13	5	Viernes	37	3	1	9	Septiembre	3	2	2024	f
2024-09-14	14	6	Sábado	37	3	1	9	Septiembre	3	2	2024	t
2024-09-15	15	7	Domingo	37	3	1	9	Septiembre	3	2	2024	t
2024-09-16	16	1	Lunes	38	4	2	9	Septiembre	3	2	2024	f
2024-09-17	17	2	Martes	38	4	2	9	Septiembre	3	2	2024	f
2024-09-18	18	3	Miércoles	38	4	2	9	Septiembre	3	2	2024	f
2024-09-19	19	4	Jueves	38	4	2	9	Septiembre	3	2	2024	f
2024-09-20	20	5	Viernes	38	4	2	9	Septiembre	3	2	2024	f
2024-09-21	21	6	Sábado	38	4	2	9	Septiembre	3	2	2024	t
2024-09-22	22	7	Domingo	38	4	2	9	Septiembre	3	2	2024	t
2024-09-23	23	1	Lunes	39	5	2	9	Septiembre	3	2	2024	f
2024-09-24	24	2	Martes	39	5	2	9	Septiembre	3	2	2024	f
2024-09-25	25	3	Miércoles	39	5	2	9	Septiembre	3	2	2024	f
2024-09-26	26	4	Jueves	39	5	2	9	Septiembre	3	2	2024	f
2024-09-27	27	5	Viernes	39	5	2	9	Septiembre	3	2	2024	f
2024-09-28	28	6	Sábado	39	5	2	9	Septiembre	3	2	2024	t
2024-09-29	29	7	Domingo	39	5	2	9	Septiembre	3	2	2024	t
2024-09-30	30	1	Lunes	40	6	2	9	Septiembre	3	2	2024	f
2024-10-01	1	2	Martes	40	1	1	10	Octubre	4	2	2024	f
2024-10-02	2	3	Miércoles	40	1	1	10	Octubre	4	2	2024	f
2024-10-03	3	4	Jueves	40	1	1	10	Octubre	4	2	2024	f
2024-10-04	4	5	Viernes	40	1	1	10	Octubre	4	2	2024	f
2024-10-05	5	6	Sábado	40	1	1	10	Octubre	4	2	2024	t
2024-10-06	6	7	Domingo	40	1	1	10	Octubre	4	2	2024	t
2024-10-07	7	1	Lunes	41	2	1	10	Octubre	4	2	2024	f
2024-10-08	8	2	Martes	41	2	1	10	Octubre	4	2	2024	f
2024-10-09	9	3	Miércoles	41	2	1	10	Octubre	4	2	2024	f
2024-10-10	10	4	Jueves	41	2	1	10	Octubre	4	2	2024	f
2024-10-11	11	5	Viernes	41	2	1	10	Octubre	4	2	2024	f
2024-10-12	12	6	Sábado	41	2	1	10	Octubre	4	2	2024	t
2024-10-13	13	7	Domingo	41	2	1	10	Octubre	4	2	2024	t
2024-10-14	14	1	Lunes	42	3	1	10	Octubre	4	2	2024	f
2024-10-15	15	2	Martes	42	3	1	10	Octubre	4	2	2024	f
2024-10-16	16	3	Miércoles	42	3	2	10	Octubre	4	2	2024	f
2024-10-17	17	4	Jueves	42	3	2	10	Octubre	4	2	2024	f
2024-10-18	18	5	Viernes	42	3	2	10	Octubre	4	2	2024	f
2024-10-19	19	6	Sábado	42	3	2	10	Octubre	4	2	2024	t
2024-10-20	20	7	Domingo	42	3	2	10	Octubre	4	2	2024	t
2024-10-21	21	1	Lunes	43	4	2	10	Octubre	4	2	2024	f
2024-10-22	22	2	Martes	43	4	2	10	Octubre	4	2	2024	f
2024-10-23	23	3	Miércoles	43	4	2	10	Octubre	4	2	2024	f
2024-10-24	24	4	Jueves	43	4	2	10	Octubre	4	2	2024	f
2024-10-25	25	5	Viernes	43	4	2	10	Octubre	4	2	2024	f
2024-10-26	26	6	Sábado	43	4	2	10	Octubre	4	2	2024	t
2024-10-27	27	7	Domingo	43	4	2	10	Octubre	4	2	2024	t
2024-10-28	28	1	Lunes	44	5	2	10	Octubre	4	2	2024	f
2024-10-29	29	2	Martes	44	5	2	10	Octubre	4	2	2024	f
2024-10-30	30	3	Miércoles	44	5	2	10	Octubre	4	2	2024	f
2024-10-31	31	4	Jueves	44	5	2	10	Octubre	4	2	2024	f
2024-11-01	1	5	Viernes	44	1	1	11	Noviembre	4	2	2024	f
2024-11-02	2	6	Sábado	44	1	1	11	Noviembre	4	2	2024	t
2024-11-03	3	7	Domingo	44	1	1	11	Noviembre	4	2	2024	t
2024-11-04	4	1	Lunes	45	2	1	11	Noviembre	4	2	2024	f
2024-11-05	5	2	Martes	45	2	1	11	Noviembre	4	2	2024	f
2024-11-06	6	3	Miércoles	45	2	1	11	Noviembre	4	2	2024	f
2024-11-07	7	4	Jueves	45	2	1	11	Noviembre	4	2	2024	f
2024-11-08	8	5	Viernes	45	2	1	11	Noviembre	4	2	2024	f
2024-11-09	9	6	Sábado	45	2	1	11	Noviembre	4	2	2024	t
2024-11-10	10	7	Domingo	45	2	1	11	Noviembre	4	2	2024	t
2024-11-11	11	1	Lunes	46	3	1	11	Noviembre	4	2	2024	f
2024-11-12	12	2	Martes	46	3	1	11	Noviembre	4	2	2024	f
2024-11-13	13	3	Miércoles	46	3	1	11	Noviembre	4	2	2024	f
2024-11-14	14	4	Jueves	46	3	1	11	Noviembre	4	2	2024	f
2024-11-15	15	5	Viernes	46	3	1	11	Noviembre	4	2	2024	f
2024-11-16	16	6	Sábado	46	3	2	11	Noviembre	4	2	2024	t
2024-11-17	17	7	Domingo	46	3	2	11	Noviembre	4	2	2024	t
2024-11-18	18	1	Lunes	47	4	2	11	Noviembre	4	2	2024	f
2024-11-19	19	2	Martes	47	4	2	11	Noviembre	4	2	2024	f
2024-11-20	20	3	Miércoles	47	4	2	11	Noviembre	4	2	2024	f
2024-11-21	21	4	Jueves	47	4	2	11	Noviembre	4	2	2024	f
2024-11-22	22	5	Viernes	47	4	2	11	Noviembre	4	2	2024	f
2024-11-23	23	6	Sábado	47	4	2	11	Noviembre	4	2	2024	t
2024-11-24	24	7	Domingo	47	4	2	11	Noviembre	4	2	2024	t
2024-11-25	25	1	Lunes	48	5	2	11	Noviembre	4	2	2024	f
2024-11-26	26	2	Martes	48	5	2	11	Noviembre	4	2	2024	f
2024-11-27	27	3	Miércoles	48	5	2	11	Noviembre	4	2	2024	f
2024-11-28	28	4	Jueves	48	5	2	11	Noviembre	4	2	2024	f
2024-11-29	29	5	Viernes	48	5	2	11	Noviembre	4	2	2024	f
2024-11-30	30	6	Sábado	48	5	2	11	Noviembre	4	2	2024	t
2024-12-01	1	7	Domingo	48	1	1	12	Diciembre	4	2	2024	t
2024-12-02	2	1	Lunes	49	2	1	12	Diciembre	4	2	2024	f
2024-12-03	3	2	Martes	49	2	1	12	Diciembre	4	2	2024	f
2024-12-04	4	3	Miércoles	49	2	1	12	Diciembre	4	2	2024	f
2024-12-05	5	4	Jueves	49	2	1	12	Diciembre	4	2	2024	f
2024-12-06	6	5	Viernes	49	2	1	12	Diciembre	4	2	2024	f
2024-12-07	7	6	Sábado	49	2	1	12	Diciembre	4	2	2024	t
2024-12-08	8	7	Domingo	49	2	1	12	Diciembre	4	2	2024	t
2024-12-09	9	1	Lunes	50	3	1	12	Diciembre	4	2	2024	f
2024-12-10	10	2	Martes	50	3	1	12	Diciembre	4	2	2024	f
2024-12-11	11	3	Miércoles	50	3	1	12	Diciembre	4	2	2024	f
2024-12-12	12	4	Jueves	50	3	1	12	Diciembre	4	2	2024	f
2024-12-13	13	5	Viernes	50	3	1	12	Diciembre	4	2	2024	f
2024-12-14	14	6	Sábado	50	3	1	12	Diciembre	4	2	2024	t
2024-12-15	15	7	Domingo	50	3	1	12	Diciembre	4	2	2024	t
2024-12-16	16	1	Lunes	51	4	2	12	Diciembre	4	2	2024	f
2024-12-17	17	2	Martes	51	4	2	12	Diciembre	4	2	2024	f
2024-12-18	18	3	Miércoles	51	4	2	12	Diciembre	4	2	2024	f
2024-12-19	19	4	Jueves	51	4	2	12	Diciembre	4	2	2024	f
2024-12-20	20	5	Viernes	51	4	2	12	Diciembre	4	2	2024	f
2024-12-21	21	6	Sábado	51	4	2	12	Diciembre	4	2	2024	t
2024-12-22	22	7	Domingo	51	4	2	12	Diciembre	4	2	2024	t
2024-12-23	23	1	Lunes	52	5	2	12	Diciembre	4	2	2024	f
2024-12-24	24	2	Martes	52	5	2	12	Diciembre	4	2	2024	f
2024-12-25	25	3	Miércoles	52	5	2	12	Diciembre	4	2	2024	f
2024-12-26	26	4	Jueves	52	5	2	12	Diciembre	4	2	2024	f
2024-12-27	27	5	Viernes	52	5	2	12	Diciembre	4	2	2024	f
2024-12-28	28	6	Sábado	52	5	2	12	Diciembre	4	2	2024	t
2024-12-29	29	7	Domingo	52	5	2	12	Diciembre	4	2	2024	t
2024-12-30	30	1	Lunes	1	6	2	12	Diciembre	4	2	2024	f
2024-12-31	31	2	Martes	1	6	2	12	Diciembre	4	2	2024	f
2025-01-01	1	3	Miércoles	1	1	1	1	Enero	1	1	2025	f
2025-01-02	2	4	Jueves	1	1	1	1	Enero	1	1	2025	f
2025-01-03	3	5	Viernes	1	1	1	1	Enero	1	1	2025	f
2025-01-04	4	6	Sábado	1	1	1	1	Enero	1	1	2025	t
2025-01-05	5	7	Domingo	1	1	1	1	Enero	1	1	2025	t
2025-01-06	6	1	Lunes	2	2	1	1	Enero	1	1	2025	f
2025-01-07	7	2	Martes	2	2	1	1	Enero	1	1	2025	f
2025-01-08	8	3	Miércoles	2	2	1	1	Enero	1	1	2025	f
2025-01-09	9	4	Jueves	2	2	1	1	Enero	1	1	2025	f
2025-01-10	10	5	Viernes	2	2	1	1	Enero	1	1	2025	f
2025-01-11	11	6	Sábado	2	2	1	1	Enero	1	1	2025	t
2025-01-12	12	7	Domingo	2	2	1	1	Enero	1	1	2025	t
2025-01-13	13	1	Lunes	3	3	1	1	Enero	1	1	2025	f
2025-01-14	14	2	Martes	3	3	1	1	Enero	1	1	2025	f
2025-01-15	15	3	Miércoles	3	3	1	1	Enero	1	1	2025	f
2025-01-16	16	4	Jueves	3	3	2	1	Enero	1	1	2025	f
2025-01-17	17	5	Viernes	3	3	2	1	Enero	1	1	2025	f
2025-01-18	18	6	Sábado	3	3	2	1	Enero	1	1	2025	t
2025-01-19	19	7	Domingo	3	3	2	1	Enero	1	1	2025	t
2025-01-20	20	1	Lunes	4	4	2	1	Enero	1	1	2025	f
2025-01-21	21	2	Martes	4	4	2	1	Enero	1	1	2025	f
2025-01-22	22	3	Miércoles	4	4	2	1	Enero	1	1	2025	f
2025-01-23	23	4	Jueves	4	4	2	1	Enero	1	1	2025	f
2025-01-24	24	5	Viernes	4	4	2	1	Enero	1	1	2025	f
2025-01-25	25	6	Sábado	4	4	2	1	Enero	1	1	2025	t
2025-01-26	26	7	Domingo	4	4	2	1	Enero	1	1	2025	t
2025-01-27	27	1	Lunes	5	5	2	1	Enero	1	1	2025	f
2025-01-28	28	2	Martes	5	5	2	1	Enero	1	1	2025	f
2025-01-29	29	3	Miércoles	5	5	2	1	Enero	1	1	2025	f
2025-01-30	30	4	Jueves	5	5	2	1	Enero	1	1	2025	f
2025-01-31	31	5	Viernes	5	5	2	1	Enero	1	1	2025	f
2025-02-01	1	6	Sábado	5	1	1	2	Febrero	1	1	2025	t
2025-02-02	2	7	Domingo	5	1	1	2	Febrero	1	1	2025	t
2025-02-03	3	1	Lunes	6	2	1	2	Febrero	1	1	2025	f
2025-02-04	4	2	Martes	6	2	1	2	Febrero	1	1	2025	f
2025-02-05	5	3	Miércoles	6	2	1	2	Febrero	1	1	2025	f
2025-02-06	6	4	Jueves	6	2	1	2	Febrero	1	1	2025	f
2025-02-07	7	5	Viernes	6	2	1	2	Febrero	1	1	2025	f
2025-02-08	8	6	Sábado	6	2	1	2	Febrero	1	1	2025	t
2025-02-09	9	7	Domingo	6	2	1	2	Febrero	1	1	2025	t
2025-02-10	10	1	Lunes	7	3	1	2	Febrero	1	1	2025	f
2025-02-11	11	2	Martes	7	3	1	2	Febrero	1	1	2025	f
2025-02-12	12	3	Miércoles	7	3	1	2	Febrero	1	1	2025	f
2025-02-13	13	4	Jueves	7	3	1	2	Febrero	1	1	2025	f
2025-02-14	14	5	Viernes	7	3	1	2	Febrero	1	1	2025	f
2025-02-15	15	6	Sábado	7	3	1	2	Febrero	1	1	2025	t
2025-02-16	16	7	Domingo	7	3	2	2	Febrero	1	1	2025	t
2025-02-17	17	1	Lunes	8	4	2	2	Febrero	1	1	2025	f
2025-02-18	18	2	Martes	8	4	2	2	Febrero	1	1	2025	f
2025-02-19	19	3	Miércoles	8	4	2	2	Febrero	1	1	2025	f
2025-02-20	20	4	Jueves	8	4	2	2	Febrero	1	1	2025	f
2025-02-21	21	5	Viernes	8	4	2	2	Febrero	1	1	2025	f
2025-02-22	22	6	Sábado	8	4	2	2	Febrero	1	1	2025	t
2025-02-23	23	7	Domingo	8	4	2	2	Febrero	1	1	2025	t
2025-02-24	24	1	Lunes	9	5	2	2	Febrero	1	1	2025	f
2025-02-25	25	2	Martes	9	5	2	2	Febrero	1	1	2025	f
2025-02-26	26	3	Miércoles	9	5	2	2	Febrero	1	1	2025	f
2025-02-27	27	4	Jueves	9	5	2	2	Febrero	1	1	2025	f
2025-02-28	28	5	Viernes	9	5	2	2	Febrero	1	1	2025	f
2025-03-01	1	6	Sábado	9	1	1	3	Marzo	1	1	2025	t
2025-03-02	2	7	Domingo	9	1	1	3	Marzo	1	1	2025	t
2025-03-03	3	1	Lunes	10	2	1	3	Marzo	1	1	2025	f
2025-03-04	4	2	Martes	10	2	1	3	Marzo	1	1	2025	f
2025-03-05	5	3	Miércoles	10	2	1	3	Marzo	1	1	2025	f
2025-03-06	6	4	Jueves	10	2	1	3	Marzo	1	1	2025	f
2025-03-07	7	5	Viernes	10	2	1	3	Marzo	1	1	2025	f
2025-03-08	8	6	Sábado	10	2	1	3	Marzo	1	1	2025	t
2025-03-09	9	7	Domingo	10	2	1	3	Marzo	1	1	2025	t
2025-03-10	10	1	Lunes	11	3	1	3	Marzo	1	1	2025	f
2025-03-11	11	2	Martes	11	3	1	3	Marzo	1	1	2025	f
2025-03-12	12	3	Miércoles	11	3	1	3	Marzo	1	1	2025	f
2025-03-13	13	4	Jueves	11	3	1	3	Marzo	1	1	2025	f
2025-03-14	14	5	Viernes	11	3	1	3	Marzo	1	1	2025	f
2025-03-15	15	6	Sábado	11	3	1	3	Marzo	1	1	2025	t
2025-03-16	16	7	Domingo	11	3	2	3	Marzo	1	1	2025	t
2025-03-17	17	1	Lunes	12	4	2	3	Marzo	1	1	2025	f
2025-03-18	18	2	Martes	12	4	2	3	Marzo	1	1	2025	f
2025-03-19	19	3	Miércoles	12	4	2	3	Marzo	1	1	2025	f
2025-03-20	20	4	Jueves	12	4	2	3	Marzo	1	1	2025	f
2025-03-21	21	5	Viernes	12	4	2	3	Marzo	1	1	2025	f
2025-03-22	22	6	Sábado	12	4	2	3	Marzo	1	1	2025	t
2025-03-23	23	7	Domingo	12	4	2	3	Marzo	1	1	2025	t
2025-03-24	24	1	Lunes	13	5	2	3	Marzo	1	1	2025	f
2025-03-25	25	2	Martes	13	5	2	3	Marzo	1	1	2025	f
2025-03-26	26	3	Miércoles	13	5	2	3	Marzo	1	1	2025	f
2025-03-27	27	4	Jueves	13	5	2	3	Marzo	1	1	2025	f
2025-03-28	28	5	Viernes	13	5	2	3	Marzo	1	1	2025	f
2025-03-29	29	6	Sábado	13	5	2	3	Marzo	1	1	2025	t
2025-03-30	30	7	Domingo	13	5	2	3	Marzo	1	1	2025	t
2025-03-31	31	1	Lunes	14	6	2	3	Marzo	1	1	2025	f
2025-04-01	1	2	Martes	14	1	1	4	Abril	2	1	2025	f
2025-04-02	2	3	Miércoles	14	1	1	4	Abril	2	1	2025	f
2025-04-03	3	4	Jueves	14	1	1	4	Abril	2	1	2025	f
2025-04-04	4	5	Viernes	14	1	1	4	Abril	2	1	2025	f
2025-04-05	5	6	Sábado	14	1	1	4	Abril	2	1	2025	t
2025-04-06	6	7	Domingo	14	1	1	4	Abril	2	1	2025	t
2025-04-07	7	1	Lunes	15	2	1	4	Abril	2	1	2025	f
2025-04-08	8	2	Martes	15	2	1	4	Abril	2	1	2025	f
2025-04-09	9	3	Miércoles	15	2	1	4	Abril	2	1	2025	f
2025-04-10	10	4	Jueves	15	2	1	4	Abril	2	1	2025	f
2025-04-11	11	5	Viernes	15	2	1	4	Abril	2	1	2025	f
2025-04-12	12	6	Sábado	15	2	1	4	Abril	2	1	2025	t
2025-04-13	13	7	Domingo	15	2	1	4	Abril	2	1	2025	t
2025-04-14	14	1	Lunes	16	3	1	4	Abril	2	1	2025	f
2025-04-15	15	2	Martes	16	3	1	4	Abril	2	1	2025	f
2025-04-16	16	3	Miércoles	16	3	2	4	Abril	2	1	2025	f
2025-04-17	17	4	Jueves	16	3	2	4	Abril	2	1	2025	f
2025-04-18	18	5	Viernes	16	3	2	4	Abril	2	1	2025	f
2025-04-19	19	6	Sábado	16	3	2	4	Abril	2	1	2025	t
2025-04-20	20	7	Domingo	16	3	2	4	Abril	2	1	2025	t
2025-04-21	21	1	Lunes	17	4	2	4	Abril	2	1	2025	f
2025-04-22	22	2	Martes	17	4	2	4	Abril	2	1	2025	f
2025-04-23	23	3	Miércoles	17	4	2	4	Abril	2	1	2025	f
2025-04-24	24	4	Jueves	17	4	2	4	Abril	2	1	2025	f
2025-04-25	25	5	Viernes	17	4	2	4	Abril	2	1	2025	f
2025-04-26	26	6	Sábado	17	4	2	4	Abril	2	1	2025	t
2025-04-27	27	7	Domingo	17	4	2	4	Abril	2	1	2025	t
2025-04-28	28	1	Lunes	18	5	2	4	Abril	2	1	2025	f
2025-04-29	29	2	Martes	18	5	2	4	Abril	2	1	2025	f
2025-04-30	30	3	Miércoles	18	5	2	4	Abril	2	1	2025	f
2025-05-01	1	4	Jueves	18	1	1	5	Mayo	2	1	2025	f
2025-05-02	2	5	Viernes	18	1	1	5	Mayo	2	1	2025	f
2025-05-03	3	6	Sábado	18	1	1	5	Mayo	2	1	2025	t
2025-05-04	4	7	Domingo	18	1	1	5	Mayo	2	1	2025	t
2025-05-05	5	1	Lunes	19	2	1	5	Mayo	2	1	2025	f
2025-05-06	6	2	Martes	19	2	1	5	Mayo	2	1	2025	f
2025-05-07	7	3	Miércoles	19	2	1	5	Mayo	2	1	2025	f
2025-05-08	8	4	Jueves	19	2	1	5	Mayo	2	1	2025	f
2025-05-09	9	5	Viernes	19	2	1	5	Mayo	2	1	2025	f
2025-05-10	10	6	Sábado	19	2	1	5	Mayo	2	1	2025	t
2025-05-11	11	7	Domingo	19	2	1	5	Mayo	2	1	2025	t
2025-05-12	12	1	Lunes	20	3	1	5	Mayo	2	1	2025	f
2025-05-13	13	2	Martes	20	3	1	5	Mayo	2	1	2025	f
2025-05-14	14	3	Miércoles	20	3	1	5	Mayo	2	1	2025	f
2025-05-15	15	4	Jueves	20	3	1	5	Mayo	2	1	2025	f
2025-05-16	16	5	Viernes	20	3	2	5	Mayo	2	1	2025	f
2025-05-17	17	6	Sábado	20	3	2	5	Mayo	2	1	2025	t
2025-05-18	18	7	Domingo	20	3	2	5	Mayo	2	1	2025	t
2025-05-19	19	1	Lunes	21	4	2	5	Mayo	2	1	2025	f
2025-05-20	20	2	Martes	21	4	2	5	Mayo	2	1	2025	f
2025-05-21	21	3	Miércoles	21	4	2	5	Mayo	2	1	2025	f
2025-05-22	22	4	Jueves	21	4	2	5	Mayo	2	1	2025	f
2025-05-23	23	5	Viernes	21	4	2	5	Mayo	2	1	2025	f
2025-05-24	24	6	Sábado	21	4	2	5	Mayo	2	1	2025	t
2025-05-25	25	7	Domingo	21	4	2	5	Mayo	2	1	2025	t
2025-05-26	26	1	Lunes	22	5	2	5	Mayo	2	1	2025	f
2025-05-27	27	2	Martes	22	5	2	5	Mayo	2	1	2025	f
2025-05-28	28	3	Miércoles	22	5	2	5	Mayo	2	1	2025	f
2025-05-29	29	4	Jueves	22	5	2	5	Mayo	2	1	2025	f
2025-05-30	30	5	Viernes	22	5	2	5	Mayo	2	1	2025	f
2025-05-31	31	6	Sábado	22	5	2	5	Mayo	2	1	2025	t
2025-06-01	1	7	Domingo	22	1	1	6	Junio	2	1	2025	t
2025-06-02	2	1	Lunes	23	2	1	6	Junio	2	1	2025	f
2025-06-03	3	2	Martes	23	2	1	6	Junio	2	1	2025	f
2025-06-04	4	3	Miércoles	23	2	1	6	Junio	2	1	2025	f
2025-06-05	5	4	Jueves	23	2	1	6	Junio	2	1	2025	f
2025-06-06	6	5	Viernes	23	2	1	6	Junio	2	1	2025	f
2025-06-07	7	6	Sábado	23	2	1	6	Junio	2	1	2025	t
2025-06-08	8	7	Domingo	23	2	1	6	Junio	2	1	2025	t
2025-06-09	9	1	Lunes	24	3	1	6	Junio	2	1	2025	f
2025-06-10	10	2	Martes	24	3	1	6	Junio	2	1	2025	f
2025-06-11	11	3	Miércoles	24	3	1	6	Junio	2	1	2025	f
2025-06-12	12	4	Jueves	24	3	1	6	Junio	2	1	2025	f
2025-06-13	13	5	Viernes	24	3	1	6	Junio	2	1	2025	f
2025-06-14	14	6	Sábado	24	3	1	6	Junio	2	1	2025	t
2025-06-15	15	7	Domingo	24	3	1	6	Junio	2	1	2025	t
2025-06-16	16	1	Lunes	25	4	2	6	Junio	2	1	2025	f
2025-06-17	17	2	Martes	25	4	2	6	Junio	2	1	2025	f
2025-06-18	18	3	Miércoles	25	4	2	6	Junio	2	1	2025	f
2025-06-19	19	4	Jueves	25	4	2	6	Junio	2	1	2025	f
2025-06-20	20	5	Viernes	25	4	2	6	Junio	2	1	2025	f
2025-06-21	21	6	Sábado	25	4	2	6	Junio	2	1	2025	t
2025-06-22	22	7	Domingo	25	4	2	6	Junio	2	1	2025	t
2025-06-23	23	1	Lunes	26	5	2	6	Junio	2	1	2025	f
2025-06-24	24	2	Martes	26	5	2	6	Junio	2	1	2025	f
2025-06-25	25	3	Miércoles	26	5	2	6	Junio	2	1	2025	f
2025-06-26	26	4	Jueves	26	5	2	6	Junio	2	1	2025	f
2025-06-27	27	5	Viernes	26	5	2	6	Junio	2	1	2025	f
2025-06-28	28	6	Sábado	26	5	2	6	Junio	2	1	2025	t
2025-06-29	29	7	Domingo	26	5	2	6	Junio	2	1	2025	t
2025-06-30	30	1	Lunes	27	6	2	6	Junio	2	1	2025	f
2025-07-01	1	2	Martes	27	1	1	7	Julio	3	2	2025	f
2025-07-02	2	3	Miércoles	27	1	1	7	Julio	3	2	2025	f
2025-07-03	3	4	Jueves	27	1	1	7	Julio	3	2	2025	f
2025-07-04	4	5	Viernes	27	1	1	7	Julio	3	2	2025	f
2025-07-05	5	6	Sábado	27	1	1	7	Julio	3	2	2025	t
2025-07-06	6	7	Domingo	27	1	1	7	Julio	3	2	2025	t
2025-07-07	7	1	Lunes	28	2	1	7	Julio	3	2	2025	f
2025-07-08	8	2	Martes	28	2	1	7	Julio	3	2	2025	f
2025-07-09	9	3	Miércoles	28	2	1	7	Julio	3	2	2025	f
2025-07-10	10	4	Jueves	28	2	1	7	Julio	3	2	2025	f
2025-07-11	11	5	Viernes	28	2	1	7	Julio	3	2	2025	f
2025-07-12	12	6	Sábado	28	2	1	7	Julio	3	2	2025	t
2025-07-13	13	7	Domingo	28	2	1	7	Julio	3	2	2025	t
2025-07-14	14	1	Lunes	29	3	1	7	Julio	3	2	2025	f
2025-07-15	15	2	Martes	29	3	1	7	Julio	3	2	2025	f
2025-07-16	16	3	Miércoles	29	3	2	7	Julio	3	2	2025	f
2025-07-17	17	4	Jueves	29	3	2	7	Julio	3	2	2025	f
2025-07-18	18	5	Viernes	29	3	2	7	Julio	3	2	2025	f
2025-07-19	19	6	Sábado	29	3	2	7	Julio	3	2	2025	t
2025-07-20	20	7	Domingo	29	3	2	7	Julio	3	2	2025	t
2025-07-21	21	1	Lunes	30	4	2	7	Julio	3	2	2025	f
2025-07-22	22	2	Martes	30	4	2	7	Julio	3	2	2025	f
2025-07-23	23	3	Miércoles	30	4	2	7	Julio	3	2	2025	f
2025-07-24	24	4	Jueves	30	4	2	7	Julio	3	2	2025	f
2025-07-25	25	5	Viernes	30	4	2	7	Julio	3	2	2025	f
2025-07-26	26	6	Sábado	30	4	2	7	Julio	3	2	2025	t
2025-07-27	27	7	Domingo	30	4	2	7	Julio	3	2	2025	t
2025-07-28	28	1	Lunes	31	5	2	7	Julio	3	2	2025	f
2025-07-29	29	2	Martes	31	5	2	7	Julio	3	2	2025	f
2025-07-30	30	3	Miércoles	31	5	2	7	Julio	3	2	2025	f
2025-07-31	31	4	Jueves	31	5	2	7	Julio	3	2	2025	f
2025-08-01	1	5	Viernes	31	1	1	8	Agosto	3	2	2025	f
2025-08-02	2	6	Sábado	31	1	1	8	Agosto	3	2	2025	t
2025-08-03	3	7	Domingo	31	1	1	8	Agosto	3	2	2025	t
2025-08-04	4	1	Lunes	32	2	1	8	Agosto	3	2	2025	f
2025-08-05	5	2	Martes	32	2	1	8	Agosto	3	2	2025	f
2025-08-06	6	3	Miércoles	32	2	1	8	Agosto	3	2	2025	f
2025-08-07	7	4	Jueves	32	2	1	8	Agosto	3	2	2025	f
2025-08-08	8	5	Viernes	32	2	1	8	Agosto	3	2	2025	f
2025-08-09	9	6	Sábado	32	2	1	8	Agosto	3	2	2025	t
2025-08-10	10	7	Domingo	32	2	1	8	Agosto	3	2	2025	t
2025-08-11	11	1	Lunes	33	3	1	8	Agosto	3	2	2025	f
2025-08-12	12	2	Martes	33	3	1	8	Agosto	3	2	2025	f
2025-08-13	13	3	Miércoles	33	3	1	8	Agosto	3	2	2025	f
2025-08-14	14	4	Jueves	33	3	1	8	Agosto	3	2	2025	f
2025-08-15	15	5	Viernes	33	3	1	8	Agosto	3	2	2025	f
2025-08-16	16	6	Sábado	33	3	2	8	Agosto	3	2	2025	t
2025-08-17	17	7	Domingo	33	3	2	8	Agosto	3	2	2025	t
2025-08-18	18	1	Lunes	34	4	2	8	Agosto	3	2	2025	f
2025-08-19	19	2	Martes	34	4	2	8	Agosto	3	2	2025	f
2025-08-20	20	3	Miércoles	34	4	2	8	Agosto	3	2	2025	f
2025-08-21	21	4	Jueves	34	4	2	8	Agosto	3	2	2025	f
2025-08-22	22	5	Viernes	34	4	2	8	Agosto	3	2	2025	f
2025-08-23	23	6	Sábado	34	4	2	8	Agosto	3	2	2025	t
2025-08-24	24	7	Domingo	34	4	2	8	Agosto	3	2	2025	t
2025-08-25	25	1	Lunes	35	5	2	8	Agosto	3	2	2025	f
2025-08-26	26	2	Martes	35	5	2	8	Agosto	3	2	2025	f
2025-08-27	27	3	Miércoles	35	5	2	8	Agosto	3	2	2025	f
2025-08-28	28	4	Jueves	35	5	2	8	Agosto	3	2	2025	f
2025-08-29	29	5	Viernes	35	5	2	8	Agosto	3	2	2025	f
2025-08-30	30	6	Sábado	35	5	2	8	Agosto	3	2	2025	t
2025-08-31	31	7	Domingo	35	5	2	8	Agosto	3	2	2025	t
2025-09-01	1	1	Lunes	36	1	1	9	Septiembre	3	2	2025	f
2025-09-02	2	2	Martes	36	1	1	9	Septiembre	3	2	2025	f
2025-09-03	3	3	Miércoles	36	1	1	9	Septiembre	3	2	2025	f
2025-09-04	4	4	Jueves	36	1	1	9	Septiembre	3	2	2025	f
2025-09-05	5	5	Viernes	36	1	1	9	Septiembre	3	2	2025	f
2025-09-06	6	6	Sábado	36	1	1	9	Septiembre	3	2	2025	t
2025-09-07	7	7	Domingo	36	1	1	9	Septiembre	3	2	2025	t
2025-09-08	8	1	Lunes	37	2	1	9	Septiembre	3	2	2025	f
2025-09-09	9	2	Martes	37	2	1	9	Septiembre	3	2	2025	f
2025-09-10	10	3	Miércoles	37	2	1	9	Septiembre	3	2	2025	f
2025-09-11	11	4	Jueves	37	2	1	9	Septiembre	3	2	2025	f
2025-09-12	12	5	Viernes	37	2	1	9	Septiembre	3	2	2025	f
2025-09-13	13	6	Sábado	37	2	1	9	Septiembre	3	2	2025	t
2025-09-14	14	7	Domingo	37	2	1	9	Septiembre	3	2	2025	t
2025-09-15	15	1	Lunes	38	3	1	9	Septiembre	3	2	2025	f
2025-09-16	16	2	Martes	38	3	2	9	Septiembre	3	2	2025	f
2025-09-17	17	3	Miércoles	38	3	2	9	Septiembre	3	2	2025	f
2025-09-18	18	4	Jueves	38	3	2	9	Septiembre	3	2	2025	f
2025-09-19	19	5	Viernes	38	3	2	9	Septiembre	3	2	2025	f
2025-09-20	20	6	Sábado	38	3	2	9	Septiembre	3	2	2025	t
2025-09-21	21	7	Domingo	38	3	2	9	Septiembre	3	2	2025	t
2025-09-22	22	1	Lunes	39	4	2	9	Septiembre	3	2	2025	f
2025-09-23	23	2	Martes	39	4	2	9	Septiembre	3	2	2025	f
2025-09-24	24	3	Miércoles	39	4	2	9	Septiembre	3	2	2025	f
2025-09-25	25	4	Jueves	39	4	2	9	Septiembre	3	2	2025	f
2025-09-26	26	5	Viernes	39	4	2	9	Septiembre	3	2	2025	f
2025-09-27	27	6	Sábado	39	4	2	9	Septiembre	3	2	2025	t
2025-09-28	28	7	Domingo	39	4	2	9	Septiembre	3	2	2025	t
2025-09-29	29	1	Lunes	40	5	2	9	Septiembre	3	2	2025	f
2025-09-30	30	2	Martes	40	5	2	9	Septiembre	3	2	2025	f
2025-10-01	1	3	Miércoles	40	1	1	10	Octubre	4	2	2025	f
2025-10-02	2	4	Jueves	40	1	1	10	Octubre	4	2	2025	f
2025-10-03	3	5	Viernes	40	1	1	10	Octubre	4	2	2025	f
2025-10-04	4	6	Sábado	40	1	1	10	Octubre	4	2	2025	t
2025-10-05	5	7	Domingo	40	1	1	10	Octubre	4	2	2025	t
2025-10-06	6	1	Lunes	41	2	1	10	Octubre	4	2	2025	f
2025-10-07	7	2	Martes	41	2	1	10	Octubre	4	2	2025	f
2025-10-08	8	3	Miércoles	41	2	1	10	Octubre	4	2	2025	f
2025-10-09	9	4	Jueves	41	2	1	10	Octubre	4	2	2025	f
2025-10-10	10	5	Viernes	41	2	1	10	Octubre	4	2	2025	f
2025-10-11	11	6	Sábado	41	2	1	10	Octubre	4	2	2025	t
2025-10-12	12	7	Domingo	41	2	1	10	Octubre	4	2	2025	t
2025-10-13	13	1	Lunes	42	3	1	10	Octubre	4	2	2025	f
2025-10-14	14	2	Martes	42	3	1	10	Octubre	4	2	2025	f
2025-10-15	15	3	Miércoles	42	3	1	10	Octubre	4	2	2025	f
2025-10-16	16	4	Jueves	42	3	2	10	Octubre	4	2	2025	f
2025-10-17	17	5	Viernes	42	3	2	10	Octubre	4	2	2025	f
2025-10-18	18	6	Sábado	42	3	2	10	Octubre	4	2	2025	t
2025-10-19	19	7	Domingo	42	3	2	10	Octubre	4	2	2025	t
2025-10-20	20	1	Lunes	43	4	2	10	Octubre	4	2	2025	f
2025-10-21	21	2	Martes	43	4	2	10	Octubre	4	2	2025	f
2025-10-22	22	3	Miércoles	43	4	2	10	Octubre	4	2	2025	f
2025-10-23	23	4	Jueves	43	4	2	10	Octubre	4	2	2025	f
2025-10-24	24	5	Viernes	43	4	2	10	Octubre	4	2	2025	f
2025-10-25	25	6	Sábado	43	4	2	10	Octubre	4	2	2025	t
2025-10-26	26	7	Domingo	43	4	2	10	Octubre	4	2	2025	t
2025-10-27	27	1	Lunes	44	5	2	10	Octubre	4	2	2025	f
2025-10-28	28	2	Martes	44	5	2	10	Octubre	4	2	2025	f
2025-10-29	29	3	Miércoles	44	5	2	10	Octubre	4	2	2025	f
2025-10-30	30	4	Jueves	44	5	2	10	Octubre	4	2	2025	f
2025-10-31	31	5	Viernes	44	5	2	10	Octubre	4	2	2025	f
2025-11-01	1	6	Sábado	44	1	1	11	Noviembre	4	2	2025	t
2025-11-02	2	7	Domingo	44	1	1	11	Noviembre	4	2	2025	t
2025-11-03	3	1	Lunes	45	2	1	11	Noviembre	4	2	2025	f
2025-11-04	4	2	Martes	45	2	1	11	Noviembre	4	2	2025	f
2025-11-05	5	3	Miércoles	45	2	1	11	Noviembre	4	2	2025	f
2025-11-06	6	4	Jueves	45	2	1	11	Noviembre	4	2	2025	f
2025-11-07	7	5	Viernes	45	2	1	11	Noviembre	4	2	2025	f
2025-11-08	8	6	Sábado	45	2	1	11	Noviembre	4	2	2025	t
2025-11-09	9	7	Domingo	45	2	1	11	Noviembre	4	2	2025	t
2025-11-10	10	1	Lunes	46	3	1	11	Noviembre	4	2	2025	f
2025-11-11	11	2	Martes	46	3	1	11	Noviembre	4	2	2025	f
2025-11-12	12	3	Miércoles	46	3	1	11	Noviembre	4	2	2025	f
2025-11-13	13	4	Jueves	46	3	1	11	Noviembre	4	2	2025	f
2025-11-14	14	5	Viernes	46	3	1	11	Noviembre	4	2	2025	f
2025-11-15	15	6	Sábado	46	3	1	11	Noviembre	4	2	2025	t
2025-11-16	16	7	Domingo	46	3	2	11	Noviembre	4	2	2025	t
2025-11-17	17	1	Lunes	47	4	2	11	Noviembre	4	2	2025	f
2025-11-18	18	2	Martes	47	4	2	11	Noviembre	4	2	2025	f
2025-11-19	19	3	Miércoles	47	4	2	11	Noviembre	4	2	2025	f
2025-11-20	20	4	Jueves	47	4	2	11	Noviembre	4	2	2025	f
2025-11-21	21	5	Viernes	47	4	2	11	Noviembre	4	2	2025	f
2025-11-22	22	6	Sábado	47	4	2	11	Noviembre	4	2	2025	t
2025-11-23	23	7	Domingo	47	4	2	11	Noviembre	4	2	2025	t
2025-11-24	24	1	Lunes	48	5	2	11	Noviembre	4	2	2025	f
2025-11-25	25	2	Martes	48	5	2	11	Noviembre	4	2	2025	f
2025-11-26	26	3	Miércoles	48	5	2	11	Noviembre	4	2	2025	f
2025-11-27	27	4	Jueves	48	5	2	11	Noviembre	4	2	2025	f
2025-11-28	28	5	Viernes	48	5	2	11	Noviembre	4	2	2025	f
2025-11-29	29	6	Sábado	48	5	2	11	Noviembre	4	2	2025	t
2025-11-30	30	7	Domingo	48	5	2	11	Noviembre	4	2	2025	t
2025-12-01	1	1	Lunes	49	1	1	12	Diciembre	4	2	2025	f
2025-12-02	2	2	Martes	49	1	1	12	Diciembre	4	2	2025	f
2025-12-03	3	3	Miércoles	49	1	1	12	Diciembre	4	2	2025	f
2025-12-04	4	4	Jueves	49	1	1	12	Diciembre	4	2	2025	f
2025-12-05	5	5	Viernes	49	1	1	12	Diciembre	4	2	2025	f
2025-12-06	6	6	Sábado	49	1	1	12	Diciembre	4	2	2025	t
2025-12-07	7	7	Domingo	49	1	1	12	Diciembre	4	2	2025	t
2025-12-08	8	1	Lunes	50	2	1	12	Diciembre	4	2	2025	f
2025-12-09	9	2	Martes	50	2	1	12	Diciembre	4	2	2025	f
2025-12-10	10	3	Miércoles	50	2	1	12	Diciembre	4	2	2025	f
2025-12-11	11	4	Jueves	50	2	1	12	Diciembre	4	2	2025	f
2025-12-12	12	5	Viernes	50	2	1	12	Diciembre	4	2	2025	f
2025-12-13	13	6	Sábado	50	2	1	12	Diciembre	4	2	2025	t
2025-12-14	14	7	Domingo	50	2	1	12	Diciembre	4	2	2025	t
2025-12-15	15	1	Lunes	51	3	1	12	Diciembre	4	2	2025	f
2025-12-16	16	2	Martes	51	3	2	12	Diciembre	4	2	2025	f
2025-12-17	17	3	Miércoles	51	3	2	12	Diciembre	4	2	2025	f
2025-12-18	18	4	Jueves	51	3	2	12	Diciembre	4	2	2025	f
2025-12-19	19	5	Viernes	51	3	2	12	Diciembre	4	2	2025	f
2025-12-20	20	6	Sábado	51	3	2	12	Diciembre	4	2	2025	t
2025-12-21	21	7	Domingo	51	3	2	12	Diciembre	4	2	2025	t
2025-12-22	22	1	Lunes	52	4	2	12	Diciembre	4	2	2025	f
2025-12-23	23	2	Martes	52	4	2	12	Diciembre	4	2	2025	f
2025-12-24	24	3	Miércoles	52	4	2	12	Diciembre	4	2	2025	f
2025-12-25	25	4	Jueves	52	4	2	12	Diciembre	4	2	2025	f
2025-12-26	26	5	Viernes	52	4	2	12	Diciembre	4	2	2025	f
2025-12-27	27	6	Sábado	52	4	2	12	Diciembre	4	2	2025	t
2025-12-28	28	7	Domingo	52	4	2	12	Diciembre	4	2	2025	t
2025-12-29	29	1	Lunes	1	5	2	12	Diciembre	4	2	2025	f
2025-12-30	30	2	Martes	1	5	2	12	Diciembre	4	2	2025	f
2025-12-31	31	3	Miércoles	1	5	2	12	Diciembre	4	2	2025	f
\.


--
-- Data for Name: horas; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- Data for Name: permisos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permisos (id_permisos, activo, controlador, accion, recurso, modulo) FROM stdin;
1	t	NULL	NULL	*	*
1500	t	targets	get	/targets/exist	BI
1501	t	targets	get	/targets/:id	BI
1502	t	targets	put	/targets/:id	BI
1503	t	targets	delete	/targets/:id	BI
1504	t	targets	get	/targets/detail/:id	BI
1505	t	targets	get	/targets	BI
1506	t	targets	post	/targets	BI
1507	t	targets	get	/targets/perspective/:id	BI
1508	t	indicators	get	/indicators	BI
1509	t	indicators	get	/indicators/tag/:id	BI
1510	t	formula	get	/formula/exist	BI
1511	t	formula	get	/formula	BI
1512	t	formula	post	/formula	BI
1513	t	formula	get	/formula/tag	BI
1514	t	formula	get	/formula/tag/:id	BI
1515	t	formula	get	/formula/:id	BI
1516	t	formula	put	/formula/:id	BI
1517	t	formula	delete	/formula/:id	BI
1518	t	tags	get	/tags/exist	BI
1519	t	tags	get	/tags	BI
1520	t	tags	post	/tags	BI
1521	t	tags	get	/tags/:id	BI
1522	t	tags	put	/tags/:id	BI
1523	t	tags	delete	/tags/:id	BI
1524	t	perspectives	get	/perspectives/exist	BI
1525	t	perspectives	get	/perspectives	BI
1526	t	perspectives	post	/perspectives	BI
1527	t	perspectives	get	/perspectives/icons	BI
1528	t	perspectives	get	/perspectives/:id	BI
1529	t	perspectives	put	/perspectives/:id	BI
1530	t	perspectives	delete	/perspectives/:id	BI
1531	t	icons	get	/icons/exist	BI
1532	t	icons	get	/icons	BI
1533	t	icons	post	/icons	BI
1534	t	icons	get	/icons/:id	BI
1535	t	icons	put	/icons/:id	BI
1536	t	icons	delete	/icons/:id	BI
1537	t	*	*	*	BI
1538	t	targets	*	/targets/*	BI
1539	t	indicators	*	/indicators/*	BI
1540	t	formula	*	/formula/*	BI
1541	t	tags	*	/tags/*	BI
1542	t	perspectives	*	/perspectives/*	BI
1543	t	icons	*	/icons/*	BI
1544	t	reports	*	/reports/*	BI
1545	t	etl	*	/etl/*	BI
1546	t	reports	get	/reports/sale	BI
1547	t	reports	get	/reports/purchase	BI
1548	t	reports	get	/reports/warehouse	BI
1549	t	etl	post	/etl/logs	BI
1550	t	etl	post	/etl/extract	BI
1551	t	etl	post	/etl/sync	BI
1552	t	etl	post	/etl/resource	BI
1553	t	etl	post	/etl/clear	BI
1554	t	dashboard	*	*	BI
1557	t	targets	get	/targets/perspective/7	BI
1558	t	targets	get	/targets/perspective/8	BI
1559	t	targets	get	/targets/perspective/11	BI
\.


--
-- Data for Name: personas; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- Data for Name: role_permiso; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_permiso (id_roles, id_permisos) FROM stdin;
1	1
201	1500
202	1500
203	1500
204	1500
201	1501
202	1501
203	1501
204	1501
201	1502
202	1502
203	1502
204	1502
201	1503
202	1503
203	1503
204	1503
201	1504
202	1504
203	1504
204	1504
201	1505
202	1505
203	1505
204	1505
205	1505
201	1506
202	1506
203	1506
204	1506
205	1507
205	1524
205	1525
205	1527
205	1528
205	1529
205	1530
200	1538
200	1539
201	1539
204	1539
205	1539
200	1540
204	1540
205	1540
201	1540
200	1541
201	1541
204	1541
205	1541
200	1542
201	1542
204	1542
200	1543
201	1543
204	1543
205	1543
200	1544
201	1546
202	1547
203	1548
200	1554
201	1554
202	1554
203	1554
204	1554
205	1554
201	1557
203	1558
202	1559
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
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
Gerente General	t	200
Gerente de ventas	t	201
Gerente de compras	t	202
Gerente de almacenes	t	203
Analista	t	204
Operador BI	t	205
\.


--
-- Data for Name: tipo_facturas; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id_usuarios, nombre_usuario, "contraseña", correo, nombre, apellido, acceso, id_roles) FROM stdin;
3	admin	7c4a8d09ca3762af61e59520943dc26494f8941b	admin@admin.com	Super	Admin	t	1
4	soporte	2081ab297d5be74ab716bae982eb39294f5a6098	admin@admin.com	soporte	Admin	t	1
6	vendedor1	$2y$10$ptOFv5vQkr.JzM5fKymQVOCNuCsWjTHUz6D.knhU8Ddd.B8/oIzIS	WZAMBRANO@GMAIL.COM	WILLIAM	ZAMBRANO	t	17
7	YRON	$2y$10$ld4iBUmjYa2LKP0Bv2wUJOaDuxr1BDG8mP4YX/g66vLBwMhLQ5HbK	yohelyron@gmail.com	Yohely	Ron	t	6
8	user	$2y$10$JYARVdNkycWt9sXFlGENF.8vdKWdbqKdtguX4ChfWILFIrW7Vzvra	usaer@gmail.com	user	user	t	18
9	pedidos	$2y$10$CL86KXGpI5nNrM62VOg6susweimy/ew7GR/EVhMuVxH9RI2eieuDy	soporte@gmail.com	fv	sdsdvd	t	16
10	cobrar1	$2y$10$SvC1lm6fWfQ5cGlLJfmb4O/Ejdu/4wiiRW1tJlW21OkT6OzgTyLuO	admin@gai.com	user	user	t	18
200	general	7c4a8d09ca3762af61e59520943dc26494f8941b	gerenteg@gmail.com	Gerente	General	t	200
201	venta	7c4a8d09ca3762af61e59520943dc26494f8941b	gerentev@gmail.com	Gerente	Venta	t	201
202	compra	7c4a8d09ca3762af61e59520943dc26494f8941b	gerentec@gmail.com	Gerente	Compra	t	202
203	almacen	7c4a8d09ca3762af61e59520943dc26494f8941b	gerentea@gmail.com	Gerente	Almacen	t	203
204	analista	7c4a8d09ca3762af61e59520943dc26494f8941b	analistag@gmail.com	Analista	General	t	204
205	operador	7c4a8d09ca3762af61e59520943dc26494f8941b	operadorBI@gmail.com	Operador	BI	t	205
\.


--
-- Data for Name: cotizaciones; Type: TABLE DATA; Schema: ventas; Owner: postgres
--

COPY ventas.cotizaciones (id_cotizaciones, num_control, tasa, id_personas, id_vendedores, id_estados, id_ciudades, id_tipo_clientes, fecha) FROM stdin;
1	\N	37.0	3	\N	4	72	1	2024-05-28 00:00:00
2	\N	36.3723	4	\N	1	1	1	2024-06-25 00:00:00
3	\N	36.55	2	\N	16	322	1	2024-07-19 00:00:00
4	\N	50.0	5	\N	1	1	1	2024-10-01 00:00:00
9	\N	21.4615	26	\N	16	321	1	2025-01-07 00:00:00
10	141.0	55.7628	8	\N	17	339	1	2025-01-22 00:00:00
\.


--
-- Data for Name: det_cotizacion; Type: TABLE DATA; Schema: ventas; Owner: postgres
--

COPY ventas.det_cotizacion (id_det_cotizacion, id_cotizaciones, id_productos, id_depositos, id_vendedores, precio, descuento, cantidad) FROM stdin;
1	1	3	1	1	0.78	0.0	12.0
2	2	20	1	2	10.34	0.0	5.0
3	3	2	1	1	0.2	0.0	1.0
5	4	97	1	2	50.0	0.0	1.0
7	9	10	1	1	2.0	0.0	20.0
8	9	24	1	1	1.47	0.0	20.0
9	9	23	1	1	1.47	0.0	20.0
13	10	132	1	1	30.17	0.0	2.0
14	10	134	1	1	1.0	0.0	1.0
15	10	133	1	1	100.0	0.0	1.0
\.


--
-- Data for Name: det_venta; Type: TABLE DATA; Schema: ventas; Owner: postgres
--

COPY ventas.det_venta (id_det_venta, id_productos, id_depositos, precio, cantidad, id_ventas, descuento, id_presentaciones, id_vendedores, devuelto) FROM stdin;
1	3	1	0.78	10.0	1	0.0	\N	1	0.0
2	1	1	0.2	1.0	1	0.0	\N	1	0.0
3	3	1	0.78	5.0	2	0.0	\N	1	0.0
4	3	1	0.78	1.0	3	0.0	\N	1	0.0
5	3	1	0.78	12.0	4	0.0	\N	1	0.0
6	1	3	0.2	1.0	6	0.0	\N	2	0.0
7	1	3	0.2	1.0	7	0.0	\N	2	0.0
8	1	3	0.2	1.0	8	0.0	\N	2	0.0
10	16	1	4.31	1.0	10	0.0	\N	1	0.0
11	16	1	4.31	2.0	11	0.0	\N	1	0.0
12	18	3	28.8	2.0	12	0.0	\N	1	0.0
13	3	1	0.78	1.0	13	0.0	\N	1	0.0
14	8	1	1.5	1.0	13	0.0	\N	1	0.0
15	3	1	0.78	3.0	14	0.0	\N	1	0.0
16	4	1	20.0	5.0	14	0.0	\N	1	0.0
17	3	1	0.78	2.0	15	0.0	\N	2	0.0
18	4	1	20.0	3.0	15	0.0	\N	2	0.0
19	1	3	0.2	1.0	16	0.0	\N	1	0.0
20	9	1	3.0	1.0	17	0.0	\N	1	0.0
21	3	1	0.78	1.0	18	0.0	\N	2	0.0
22	3	1	0.78	2.0	19	0.0	\N	1	0.0
23	4	1	20.0	1.0	19	0.0	\N	1	0.0
24	1	1	10.0	1.0	20	0.0	\N	1	0.0
25	1	1	10.0	1.0	21	0.0	\N	1	0.0
26	3	1	10.0	1.0	22	0.0	\N	1	0.0
27	8	1	10.0	1.0	23	0.0	\N	1	0.0
28	21	1	600.0	1.0	25	0.0	\N	1	0.0
29	25	1	5.17	2.0	26	0.0	\N	1	0.0
32	25	1	5.17	1.0	29	0.0	\N	1	0.0
33	25	1	5.17	1.0	30	0.0	\N	1	0.0
34	25	1	5.17	1.0	31	0.0	\N	1	0.0
35	25	1	5.17	1.0	32	0.0	\N	1	0.0
36	16	1	4.31	1.0	33	0.0	\N	1	0.0
37	24	1	1.47	1.0	34	0.0	\N	1	0.0
38	25	1	5.17	1.0	34	0.0	\N	1	0.0
39	27	1	1.7	3.0	35	0.0	\N	1	0.0
40	24	1	1.47	1.0	36	0.0	\N	1	0.0
41	23	1	1.47	13.0	37	0.0	\N	1	0.0
42	27	1	1.7	9.0	37	0.0	\N	1	0.0
46	25	1	5.17	1.0	39	0.0	\N	1	0.0
47	17	1	6.5	1.0	40	0.0	\N	1	0.0
48	17	1	6.5	1.0	40	0.0	\N	1	0.0
49	17	1	6.5	1.0	41	0.0	\N	1	0.0
50	17	1	6.5	1.0	42	0.0	\N	2	0.0
51	7	1	10.0	1.0	43	0.0	\N	2	0.0
55	3	1	0.78	1.0	46	0.0	\N	1	0.0
56	5	1	5.0	1.0	46	0.0	\N	1	0.0
57	17	1	6.5	1.0	47	0.0	\N	2	0.0
58	3	1	0.78	1.0	48	0.0	\N	1	0.0
59	5	1	5.0	1.0	48	0.0	\N	1	0.0
60	3	1	0.78	1.0	49	0.0	\N	1	0.0
61	33	1	156.0	1.0	50	0.0	\N	1	0.0
62	32	1	10.4	10.0	50	0.0	\N	1	0.0
63	3	1	0.78	1.0	51	0.0	\N	1	0.0
64	7	1	10.0	1.0	52	0.0	\N	2	0.0
65	7	1	10.0	1.0	53	0.0	\N	1	0.0
66	36	1	30.0	1.0	54	0.0	\N	2	0.0
67	38	3	22.0	12.0	55	0.0	\N	1	0.0
68	8	1	1.5	1.0	56	0.0	\N	1	0.0
71	8	1	1.5	1.0	58	0.0	\N	1	0.0
72	4	1	20.0	1.0	58	0.0	\N	1	0.0
73	3	4	0.78	1.0	59	0.0	\N	1	0.0
74	9	1	3.0	1.0	60	0.0	\N	1	0.0
75	24	1	1.47	1.0	61	0.0	\N	2	0.0
76	35	1	12.0	1.0	61	0.0	\N	2	0.0
77	1	1	0.2	1.0	62	0.0	\N	2	0.0
78	3	1	0.78	1.0	62	0.0	\N	3	0.0
79	18	1	13.61	1.0	63	0.0	\N	1	0.0
80	19	1	25.86207	1.0	63	0.0	\N	1	0.0
81	95	1	8.62	1.0	64	0.0	\N	1	0.0
82	3	1	0.78	1.0	65	0.0	\N	1	0.0
83	4	1	20.0	1.0	66	0.0	\N	1	0.0
84	8	1	1.5	1.0	67	0.0	\N	2	0.0
85	1	1	0.13543	1.0	69	0.0	\N	1	0.0
86	2	1	0.2	1.0	71	0.0	\N	1	1.0
87	4	1	30.0	1.0	71	0.0	\N	1	1.0
88	2	1	0.2	1.0	72	0.0	\N	1	1.0
89	4	1	30.0	1.0	72	0.0	\N	1	1.0
90	3	1	5.0	1.0	73	0.0	\N	1	0.0
91	8	1	1.5	1.0	74	0.0	\N	1	0.0
92	7	1	10.0	1.0	74	0.0	\N	1	0.0
93	4	1	30.0	1.0	75	0.0	\N	3	0.0
94	7	1	10.0	1.0	75	0.0	\N	3	0.0
95	12	1	1.0	1.0	75	0.0	\N	3	0.0
96	19	1	25.86	1.0	75	0.0	\N	3	0.0
97	23	1	1.47	1.0	76	0.0	\N	1	0.0
98	4	1	30.0	1.0	77	0.0	\N	1	0.0
99	3	1	5.0	1.0	78	0.0	\N	1	0.0
100	3	1	5.0	1.0	79	0.0	\N	1	0.0
101	4	1	30.0	1.0	80	0.0	\N	1	0.0
102	4	1	30.0	1.0	81	0.0	\N	1	0.0
103	4	1	30.0	1.0	82	0.0	\N	1	0.0
104	3	1	5.0	1.0	83	0.0	\N	1	0.0
105	12	1	1.0	1.0	84	0.0	\N	1	0.0
106	4	1	30.0	1.0	85	0.0	\N	1	0.0
107	5	1	5.0	1.0	86	0.0	\N	1	0.0
108	2	1	20.0	1.0	87	0.0	\N	1	0.0
109	3	1	5.0	1.0	88	0.0	\N	1	0.0
110	4	1	30.0	1.0	89	0.0	\N	1	0.0
111	3	1	5.0	1.0	90	0.0	\N	1	0.0
112	3	1	5.0	1.0	91	0.0	\N	1	0.0
113	101	1	1250.0	1.0	92	0.0	\N	1	0.0
114	102	3	1.1	1.0	93	0.0	\N	1	0.0
115	102	3	1.1	10.0	93	0.0	\N	1	0.0
116	102	1	1.1	30.0	94	0.0	5	1	0.0
117	102	1	1.1	30.0	95	0.0	5	2	0.0
118	30	1	30.0	7.0	96	0.0	\N	2	0.0
119	9	1	3.0	1.0	97	0.0	\N	1	0.0
120	12	1	1.2	1.0	97	0.0	\N	1	0.0
121	4	1	0.1	1.0	98	0.0	\N	1	0.0
122	2	1	0.1	1.0	99	0.0	\N	1	0.0
123	1	1	0.1	1.0	100	0.0	\N	1	1.0
124	1	1	0.1	1.0	101	0.0	\N	1	1.0
126	1	1	0.1	1.0	103	0.0	\N	1	1.0
127	1	1	0.1	1.0	104	0.0	\N	1	1.0
128	3	1	5.0	1.0	105	0.0	\N	1	0.0
129	3	1	5.0	10.0	106	0.0	\N	1	0.0
130	3	1	5.0	5.0	107	0.0	\N	1	0.0
131	111	1	3.44828	1.0	108	0.0	\N	1	0.0
132	117	1	3.0	2.0	109	0.0	\N	1	0.0
134	117	1	3.0	1.0	111	0.0	\N	1	0.0
136	3	1	5.0	1.0	113	0.0	\N	1	0.0
137	3	1	5.0	1.0	114	0.0	\N	1	0.0
138	3	1	5.0	1.0	115	0.0	\N	1	0.0
139	3	1	5.0	1.0	116	0.0	\N	1	0.0
140	3	1	5.0	1.0	117	0.0	\N	1	0.0
141	3	1	5.0	1.0	118	0.0	\N	1	0.0
142	4	1	30.0	1.0	119	0.0	\N	1	0.0
143	9	1	3.0	1.0	120	0.0	\N	2	0.0
144	9	1	3.0	1.0	121	0.0	\N	2	0.0
145	4	1	30.0	1.0	122	0.0	\N	1	0.0
146	3	1	5.0	1.0	123	0.0	\N	1	0.0
147	7	1	1.2	1.0	123	0.0	\N	1	0.0
148	3	1	5.0	1.0	124	0.0	\N	1	0.0
149	4	1	30.0	1.0	124	0.0	\N	1	0.0
150	3	1	5.0	1.0	125	0.0	\N	1	0.0
151	10	1	2.0	1.0	125	0.0	\N	1	0.0
152	33	1	156.0	1.0	125	0.0	\N	1	0.0
153	114	1	3.0	1.0	125	0.0	\N	1	0.0
154	3	1	5.0	1.0	126	0.0	\N	1	0.0
155	35	1	12.0	1.0	127	0.0	\N	1	0.0
156	18	1	13.61	1.0	127	0.0	\N	1	0.0
157	35	1	12.0	1.0	127	0.0	\N	1	0.0
158	9	1	3.0	12.0	128	0.0	\N	1	0.0
159	19	1	25.86207	1.0	130	0.0	\N	1	0.0
160	3	1	5.0	1.0	131	0.0	\N	1	0.0
161	2	1	25.9605	1.0	132	0.0	\N	1	0.0
163	127	1	0.43103	3.0	134	0.0	\N	1	0.0
164	128	1	1.72414	1.0	134	0.0	\N	1	0.0
165	126	1	4.31034	1.0	134	0.0	\N	1	0.0
166	126	1	4.31034	1.0	135	0.0	\N	1	0.0
167	126	1	4.31034	1.0	136	0.0	\N	4	0.0
168	127	1	0.43	2.0	137	0.0	\N	2	0.0
169	126	1	4.31	1.0	137	0.0	\N	2	0.0
170	18	1	13.61	1.0	138	0.0	\N	4	0.0
171	35	1	12.0	1.0	138	0.0	\N	4	0.0
172	3	1	5.0	1.0	139	0.0	\N	4	0.0
173	6	1	3.0	1.0	139	0.0	\N	4	0.0
174	16	1	4.31	1.0	139	0.0	\N	4	0.0
175	127	1	0.43103	1.0	140	0.0	\N	4	0.0
176	132	1	30.17	2.0	141	0.0	\N	1	0.0
177	134	1	1.0	1.0	141	0.0	\N	1	0.0
178	133	1	100.0	1.0	141	0.0	\N	1	0.0
179	133	1	100.0	1.0	142	0.0	\N	1	0.0
\.


--
-- Data for Name: tipo_clientes; Type: TABLE DATA; Schema: ventas; Owner: postgres
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
-- Data for Name: vendedores; Type: TABLE DATA; Schema: ventas; Owner: postgres
--

COPY ventas.vendedores (id_vendedores, nombre, porcentaje) FROM stdin;
1	Marcos 	5.0
2	WILLIAM ZAMBRANO	3.0
3	luia	0.0
4	JULIO	2.0
\.


--
-- Data for Name: ventas; Type: TABLE DATA; Schema: ventas; Owner: postgres
--

COPY ventas.ventas (id_ventas, id_personas, id_cajas, id_tipo_facturas, num_factura, num_control, id_ciudades, tasa, id_tipo_clientes, id_estados, fecha, id_cotizaciones) FROM stdin;
1	2	3	6	1212123	00000001	322	0.0	1	16	2024-05-28 10:00:42	\N
2	3	3	5	12323	00000001	72	37.0	1	4	2024-05-28 10:07:17	\N
3	3	1	6	00000002	00000002	72	37.0	1	4	2024-05-28 10:22:39	\N
4	3	3	6	23423434	00000003	72	37.0	1	4	2024-05-28 10:29:54	\N
6	2	1	7	00000001	00000001	322	36.5114	1	16	2024-05-30 16:15:49	\N
7	5	1	7	00000002	00000002	1	36.5114	1	1	2024-05-30 16:18:19	\N
8	2	1	7	00000003	00000003	322	36.5114	1	16	2024-05-30 16:24:56	\N
10	1	1	7	00000004	00000004	331	36.5344	1	16	2024-06-03 11:26:52	\N
11	6	1	7	00000005	00000005	1	36.5344	1	1	2024-06-03 11:31:21	\N
12	4	1	7	00000006	00000006	1	36.5408	1	1	2024-06-05 14:48:04	\N
13	2	3	5	2121	00000002	322	36.4787	1	16	2024-06-10 16:31:36	\N
14	4	3	5	122	00000003	1	36.47	1	1	2024-06-10 21:11:35	\N
15	3	1	5	7788	00000004	72	36.47	1	4	2024-06-10 21:31:19	\N
16	8	1	7	00000007	00000007	339	36.45	1	17	2024-06-20 10:21:53	\N
17	7	1	7	00000008	00000008	1	36.45	1	1	2024-06-20 10:44:36	\N
18	3	3	6	00000004	00000004	72	36.3725	1	4	2024-06-25 09:40:05	\N
19	6	1	7	00000009	00000009	1	36.3725	1	1	2024-06-25 09:48:26	\N
20	7	1	5	00000005	00000005	1	36.3823	1	1	2024-06-27 15:07:10	\N
21	7	1	5	00000006	00000006	1	36.3823	1	1	2024-06-27 15:24:22	\N
22	7	1	5	00000007	00000007	1	36.3823	1	1	2024-06-27 15:26:45	\N
23	7	1	5	00000008	00000008	1	36.3823	1	1	2024-06-27 15:30:09	\N
24	1	3	7	0	00000001	331	36408500000000.0	1	16	2024-07-01 15:20:34	\N
25	1	3	7	00000001	00000001	331	36408500000000.0	1	16	2024-07-01 15:23:03	\N
26	1	3	7	00000002	00000002	331	40.0	1	16	2024-07-01 15:46:46	\N
29	1	3	7	00000003	00000003	331	40.0	1	16	2024-07-01 16:02:29	\N
30	1	3	7	00000004	00000004	331	40.0	1	16	2024-07-01 16:05:48	\N
31	1	3	7	00000005	00000005	331	40.0	1	16	2024-07-01 16:11:16	\N
32	1	3	7	00000006	00000006	331	40.0	1	16	2024-07-01 16:13:11	\N
33	1	3	7	00000007	00000007	331	40.0	1	16	2024-07-01 16:18:30	\N
34	1	3	7	00000008	00000008	331	40.0	1	16	2024-07-01 17:45:22	\N
35	10	3	7	00000009	00000009	331	40.0	1	16	2024-07-01 17:58:10	\N
36	10	3	7	00000010	00000010	331	40.0	1	16	2024-07-01 17:59:48	\N
37	10	3	7	00000011	00000011	331	40.0	1	16	2024-07-01 18:15:51	\N
39	1	3	7	00000012	00000012	331	36.4551	1	16	2024-07-01 21:03:20	\N
40	7	1	6	00000005	00000005	1	36.46	1	1	2024-07-02 17:41:39	\N
41	10	1	6	00000006	00000006	331	36.46	1	16	2024-07-02 17:50:27	\N
42	4	3	5	1212	00000001	1	36.46	1	1	2024-07-04 15:52:23	\N
43	4	3	5	1213	00000009	1	36.46	1	1	2024-07-04 15:53:11	\N
46	4	3	7	00000013	00000013	1	36.46	1	1	2024-07-04 16:03:37	\N
47	7	3	7	00000014	00000014	1	36.46	1	1	2024-07-04 16:04:22	\N
48	4	1	7	00000010	00000010	1	36.4787	1	1	2024-07-04 16:04:25	\N
49	1	3	7	00000015	00000015	331	36.53	1	16	2024-07-17 11:05:57	\N
50	4	1	5	5115	00000010	1	36.53	1	1	2024-07-17 15:34:32	\N
51	2	1	6	00000007	00000007	322	36.53	1	16	2024-07-19 11:56:46	\N
52	4	1	5	00000012	00000011	1	36.5724	1	1	2024-07-19 11:59:10	\N
53	1	1	6	00000008	00000008	331	36.5724	1	16	2024-07-19 12:23:51	\N
54	3	1	5	000158	00000012	72	36.6066	1	4	2024-07-22 14:37:44	\N
55	11	3	6	00000009	00000009	138	36.6066	51	8	2024-07-25 15:40:01	\N
56	2	1	7	00000011	00000011	322	36.6305	1	16	2024-08-21 09:22:24	\N
58	2	1	7	00000012	00000012	322	36.6305	1	16	2024-08-21 09:24:21	\N
59	1	3	7	00000016	00000016	331	36.9187	1	16	2024-08-21 09:30:18	\N
60	2	1	5	00000013	00000013	322	36.6305	1	16	2024-09-02 10:35:39	\N
61	5	1	6	00000010	00000010	1	36.6305	1	1	2024-09-03 19:13:46	\N
62	8	1	7	00000013	00000013	339	36.6391	1	17	2024-09-17 10:05:44	\N
63	2	1	7	00000014	00000014	322	36.7789	1	16	2024-09-19 17:09:06	\N
64	13	1	5	00000014	00000014	510	36.813	36	21	2024-09-24 09:47:40	\N
65	3	1	6	00000011	00000011	72	36.813	1	4	2024-09-24 17:34:07	\N
66	4	1	7	00000015	00000015	1	36.813	1	1	2024-10-02 12:05:04	\N
67	2	1	6	00000012	00000012	322	53.02	1	16	2024-10-02 12:05:45	\N
68	1	3	4	00000001	00000001	331	36.9187	1	16	2024-10-02 15:40:28	\N
69	14	1	7	00000016	00000016	325	36.9187	1	16	2024-10-02 15:52:24	\N
70	2	1	4	00000001	00000001	322	37.0358	1	16	2024-10-04 16:57:41	\N
71	1	1	7	00000017	00000017	331	37.0	1	16	2024-10-06 12:27:26	\N
72	1	1	3	00000017	00000001	331	37.0	1	16	2024-10-06 12:29:18	\N
73	1	1	7	00000018	00000018	331	37.0	1	16	2024-10-06 12:30:25	\N
74	1	1	7	00000019	00000019	331	37.0	1	16	2024-10-06 12:31:19	\N
75	15	1	7	00000020	00000020	89	37.0	1	6	2024-10-06 12:46:36	\N
76	17	1	6	00000013	00000013	127	1000.0	1	7	2024-10-09 11:08:08	\N
77	1	1	7	00000021	00000021	331	38.8857	1	16	2024-10-14 15:20:37	\N
78	1	1	7	00000022	00000022	331	38.9179	1	16	2024-10-16 16:47:37	\N
79	1	1	7	00000023	00000023	331	38.9179	1	16	2024-10-16 16:48:08	\N
80	1	1	7	00000024	00000024	331	38.9179	1	16	2024-10-16 16:58:21	\N
81	1	1	7	00000025	00000025	331	38.9179	1	16	2024-10-16 17:00:49	\N
82	1	1	7	00000026	00000026	331	38.9179	1	16	2024-10-16 17:00:50	\N
83	1	1	7	00000027	00000027	331	38.9179	1	16	2024-10-16 17:01:44	\N
84	1	1	7	00000028	00000028	331	38.9179	1	16	2024-10-16 17:03:27	\N
85	1	1	7	00000029	00000029	331	38.9179	1	16	2024-10-16 17:03:27	\N
86	1	1	7	00000030	00000030	331	38.9179	1	16	2024-10-16 17:03:27	\N
87	1	1	7	00000031	00000031	331	38.9179	1	16	2024-10-16 17:03:28	\N
88	1	1	7	00000032	00000032	331	38.9179	1	16	2024-10-16 17:03:28	\N
89	1	1	7	00000033	00000033	331	38.9179	1	16	2024-10-16 17:03:28	\N
90	1	1	7	00000034	00000034	331	38.9179	1	16	2024-10-16 17:03:28	\N
91	1	1	7	00000035	00000035	331	38.9179	1	16	2024-10-16 17:03:41	\N
92	17	1	6	00000014	00000014	127	39.323	1	7	2024-10-23 16:09:19	\N
93	8	1	5	00000015	00000015	339	39.323	1	17	2024-10-24 10:21:28	\N
94	4	1	7	00000036	00000036	1	39.323	1	1	2024-10-24 10:30:04	\N
95	5	1	7	00000037	00000037	1	39.323	1	1	2024-10-24 10:37:41	\N
96	4	1	7	00000038	00000038	1	39.323	1	1	2024-10-24 10:42:05	\N
97	20	1	5	00000016	00000016	212	41.0429	1	12	2024-10-27 20:53:19	\N
98	1	3	1	6827	00000001	331	42.8569	1	16	2024-11-07 14:55:10	\N
99	1	3	1	6828	00000002	331	42.8569	1	16	2024-11-07 15:02:58	\N
100	1	3	1	6829	00000003	331	42.8569	1	16	2024-11-07 15:47:53	\N
101	1	3	3	35	35	331	42.8569	1	16	2024-11-07 15:48:23	\N
103	1	3	1	6830	00000004	331	42.8569	1	16	2024-11-07 15:50:42	\N
104	1	3	3	37	37	331	42.8569	1	16	2024-11-07 15:51:12	\N
105	1	1	7	00000039	00000039	331	45.053	1	16	2024-11-15 11:13:04	\N
106	2	1	7	00000040	00000040	322	45.053	1	16	2024-11-15 11:22:16	\N
107	4	1	7	00000041	00000041	1	45.053	1	1	2024-11-15 11:23:30	\N
108	7	1	7	00000042	00000042	1	45.7894	1	1	2024-11-18 14:37:50	\N
109	1	1	6	00000015	00000015	331	45.841	1	16	2024-11-22 12:12:27	\N
111	1	1	6	00000016	00000016	331	45.841	1	16	2024-11-22 12:48:57	\N
113	2	1	7	00000043	00000043	322	46.7537	1	16	2024-11-27 10:39:51	\N
114	1	3	7	00000017	00000017	331	46.7537	1	16	2024-11-27 11:36:58	\N
115	1	1	7	00000044	00000044	331	46.7537	1	16	2024-11-27 14:09:04	\N
116	1	1	7	00000045	00000045	331	46.7537	1	16	2024-11-27 14:10:00	\N
117	24	1	7	00000046	00000046	325	46.7537	1	16	2024-11-27 14:14:47	\N
118	24	1	7	00000047	00000047	325	46.7537	1	16	2024-11-27 14:16:21	\N
119	1	1	7	00000048	00000048	331	45.841	1	16	2024-11-29 12:36:06	\N
120	4	1	5	000	00000017	1	47.61	1	1	2024-11-30 13:09:31	\N
121	5	1	5	0000000018	00000018	1	47.6074	1	1	2024-11-30 23:19:18	\N
122	1	1	7	00000049	00000049	331	45.841	1	16	2024-12-06 11:50:28	\N
123	1	1	7	00000050	00000050	331	49.1111	1	16	2024-12-11 10:29:19	\N
124	1	1	7	00000051	00000051	331	49.1111	1	16	2024-12-11 10:39:03	\N
125	1	4	6	00000017	00000017	331	49.1111	1	16	2024-12-11 17:57:33	\N
126	1	5	5	1	00000019	331	53.012	1	16	2025-01-04 00:08:10	\N
127	25	1	5	1	00000020	325	53.012	1	16	2025-01-04 19:25:33	\N
128	7	1	6	00000018	00000018	1	53.02	1	1	2025-01-06 16:42:45	\N
129	2	1	4	00000002	00000002	322	53.02	1	16	2025-01-06 16:53:32	\N
130	6	1	7	00000052	00000052	1	53.2827	1	1	2025-01-09 11:35:05	\N
131	8	1	7	00000053	00000053	339	53.2827	1	17	2025-01-09 11:38:07	\N
132	1	3	7	00000018	00000018	331	36.5621	1	16	2025-01-13 11:05:13	\N
134	1	1	7	00000054	00000054	331	56.0	1	16	2025-01-20 14:46:09	\N
135	1	1	7	00000055	00000055	331	56.0	1	16	2025-01-20 14:47:17	\N
136	1	1	7	00000056	00000056	331	56.0	1	16	2025-01-20 14:56:26	\N
137	4	1	5	1313	00000021	1	56.0	1	1	2025-01-20 15:05:06	\N
138	2	4	5	01	00000002	322	61.0	1	16	2025-01-20 15:21:42	\N
139	1	1	7	00000057	00000057	331	56.0	1	16	2025-01-20 15:24:30	\N
140	1	1	7	00000058	00000058	331	56.0	1	16	2025-01-20 16:16:05	\N
141	8	4	5	4242	00000022	339	55.7611	1	17	2025-01-22 16:08:22	\N
142	2	1	5	424	00000023	322	55.7611	1	16	2025-01-22 16:16:17	\N
\.


--
-- Name: egreso_banco_id_egreso_banco_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.egreso_banco_id_egreso_banco_seq', 138, true);


--
-- Name: egreso_caja_id_egreso_caja_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.egreso_caja_id_egreso_caja_seq', 456, true);


--
-- Name: egresos_id_egresos_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.egresos_id_egresos_seq', 146, true);


--
-- Name: ingreso_banco_id_ingreso_banco_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.ingreso_banco_id_ingreso_banco_seq', 9, true);


--
-- Name: ingreso_caja_id_ingreso_caja_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.ingreso_caja_id_ingreso_caja_seq', 33, true);


--
-- Name: ingresos_id_ingresos_seq; Type: SEQUENCE SET; Schema: finanzas; Owner: postgres
--

SELECT pg_catalog.setval('finanzas.ingresos_id_ingresos_seq', 18, true);


--
-- Name: etiquetas_id_etiquetas_seq; Type: SEQUENCE SET; Schema: objetivos; Owner: postgres
--

SELECT pg_catalog.setval('objetivos.etiquetas_id_etiquetas_seq', 12, true);


--
-- Name: formulas_id_formulas_seq; Type: SEQUENCE SET; Schema: objetivos; Owner: postgres
--

SELECT pg_catalog.setval('objetivos.formulas_id_formulas_seq', 32, true);


--
-- Name: iconos_id_iconos_seq; Type: SEQUENCE SET; Schema: objetivos; Owner: postgres
--

SELECT pg_catalog.setval('objetivos.iconos_id_iconos_seq', 285, true);


--
-- Name: objetivos_id_objetivos_seq; Type: SEQUENCE SET; Schema: objetivos; Owner: postgres
--

SELECT pg_catalog.setval('objetivos.objetivos_id_objetivos_seq', 38, true);


--
-- Name: perspectivas_id_perspectivas_seq; Type: SEQUENCE SET; Schema: objetivos; Owner: postgres
--

SELECT pg_catalog.setval('objetivos.perspectivas_id_perspectivas_seq', 17, true);


--
-- Name: depositos depositos_pk; Type: CONSTRAINT; Schema: almacenes; Owner: postgres
--

ALTER TABLE ONLY almacenes.depositos
    ADD CONSTRAINT depositos_pk PRIMARY KEY (id_depositos);


--
-- Name: movimientos movimientos_pk; Type: CONSTRAINT; Schema: almacenes; Owner: postgres
--

ALTER TABLE ONLY almacenes.movimientos
    ADD CONSTRAINT movimientos_pk PRIMARY KEY (id_movimientos, id_tipo_movimientos);


--
-- Name: tipo_movimientos tipo_salidas_pk; Type: CONSTRAINT; Schema: almacenes; Owner: postgres
--

ALTER TABLE ONLY almacenes.tipo_movimientos
    ADD CONSTRAINT tipo_salidas_pk PRIMARY KEY (id_tipo_movimientos);


--
-- Name: compras compras_pk; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT compras_pk PRIMARY KEY (id_compras);


--
-- Name: det_compra det_compras_pk; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.det_compra
    ADD CONSTRAINT det_compras_pk PRIMARY KEY (id_det_compra);


--
-- Name: det_orden_compra det_orden_compra_pk; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.det_orden_compra
    ADD CONSTRAINT det_orden_compra_pk PRIMARY KEY (id_det_orden_compra);


--
-- Name: ordenes_compras ordenes_compras_pk; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.ordenes_compras
    ADD CONSTRAINT ordenes_compras_pk PRIMARY KEY (id_ordenes_compras);


--
-- Name: proveedores proveedores_pk; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.proveedores
    ADD CONSTRAINT proveedores_pk PRIMARY KEY (id_proveedores);


--
-- Name: tipo_proveedores tipo_proveedores_pk; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.tipo_proveedores
    ADD CONSTRAINT tipo_proveedores_pk PRIMARY KEY (id_tipo_proveedores);


--
-- Name: tipo_proveedores tipo_proveedores_unique; Type: CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.tipo_proveedores
    ADD CONSTRAINT tipo_proveedores_unique UNIQUE (tipo);


--
-- Name: bancos bancos_pk; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.bancos
    ADD CONSTRAINT bancos_pk PRIMARY KEY (id_bancos);


--
-- Name: cajas cajas_pk; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.cajas
    ADD CONSTRAINT cajas_pk PRIMARY KEY (id_cajas);


--
-- Name: egreso_banco egreso_banco_pk; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egreso_banco
    ADD CONSTRAINT egreso_banco_pk PRIMARY KEY (id_egreso_banco);


--
-- Name: egreso_caja egreso_caja_pk; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egreso_caja
    ADD CONSTRAINT egreso_caja_pk PRIMARY KEY (id_egreso_caja);


--
-- Name: egresos egresos_pk; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egresos
    ADD CONSTRAINT egresos_pk PRIMARY KEY (id_mov_egresos, id_medios);


--
-- Name: egresos egresos_unique; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egresos
    ADD CONSTRAINT egresos_unique UNIQUE (id_egresos);


--
-- Name: ingreso_banco ingreso_banco_pk; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.ingreso_banco
    ADD CONSTRAINT ingreso_banco_pk PRIMARY KEY (id_ingreso_banco);


--
-- Name: ingreso_caja ingreso_caja_pk; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.ingreso_caja
    ADD CONSTRAINT ingreso_caja_pk PRIMARY KEY (id_ingreso_caja);


--
-- Name: ingresos ingresos_pk; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.ingresos
    ADD CONSTRAINT ingresos_pk PRIMARY KEY (id_mov_ingresos, id_medios);


--
-- Name: ingresos ingresos_unique; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.ingresos
    ADD CONSTRAINT ingresos_unique UNIQUE (id_ingresos);


--
-- Name: medios medios_pk; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.medios
    ADD CONSTRAINT medios_pk PRIMARY KEY (id_medios);


--
-- Name: metodo_pagos metodo_pagos_pk; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.metodo_pagos
    ADD CONSTRAINT metodo_pagos_pk PRIMARY KEY (id_metodo_pagos);


--
-- Name: monedas monedas_pk; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.monedas
    ADD CONSTRAINT monedas_pk PRIMARY KEY (id_monedas);


--
-- Name: tipo_bancos tipo_bancos_pk; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.tipo_bancos
    ADD CONSTRAINT tipo_bancos_pk PRIMARY KEY (id_tipo_bancos);


--
-- Name: tipo_movimientos tipo_entradas_cajas_pk; Type: CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.tipo_movimientos
    ADD CONSTRAINT tipo_entradas_cajas_pk PRIMARY KEY (id_tipo_movimientos);


--
-- Name: etiqueta_indicador etiqueta_indicador_unique; Type: CONSTRAINT; Schema: objetivos; Owner: postgres
--

ALTER TABLE ONLY objetivos.etiqueta_indicador
    ADD CONSTRAINT etiqueta_indicador_unique UNIQUE (id_etiquetas, id_indicadores);


--
-- Name: etiquetas etiquetas_pk; Type: CONSTRAINT; Schema: objetivos; Owner: postgres
--

ALTER TABLE ONLY objetivos.etiquetas
    ADD CONSTRAINT etiquetas_pk PRIMARY KEY (id_etiquetas);


--
-- Name: etiquetas etiquetas_unique; Type: CONSTRAINT; Schema: objetivos; Owner: postgres
--

ALTER TABLE ONLY objetivos.etiquetas
    ADD CONSTRAINT etiquetas_unique UNIQUE (etiqueta);


--
-- Name: formulas formulas_pk; Type: CONSTRAINT; Schema: objetivos; Owner: postgres
--

ALTER TABLE ONLY objetivos.formulas
    ADD CONSTRAINT formulas_pk PRIMARY KEY (id_formulas);


--
-- Name: iconos iconos_pk; Type: CONSTRAINT; Schema: objetivos; Owner: postgres
--

ALTER TABLE ONLY objetivos.iconos
    ADD CONSTRAINT iconos_pk PRIMARY KEY (id_iconos);


--
-- Name: iconos iconos_unique; Type: CONSTRAINT; Schema: objetivos; Owner: postgres
--

ALTER TABLE ONLY objetivos.iconos
    ADD CONSTRAINT iconos_unique UNIQUE (icono);


--
-- Name: indicadores indicadores_pk; Type: CONSTRAINT; Schema: objetivos; Owner: postgres
--

ALTER TABLE ONLY objetivos.indicadores
    ADD CONSTRAINT indicadores_pk PRIMARY KEY (id_indicadores);


--
-- Name: objetivos objetivos_pkey; Type: CONSTRAINT; Schema: objetivos; Owner: postgres
--

ALTER TABLE ONLY objetivos.objetivos
    ADD CONSTRAINT objetivos_pkey PRIMARY KEY (id_objetivos);


--
-- Name: perspectiva_etiqueta perspectiva_etiqueta_unique; Type: CONSTRAINT; Schema: objetivos; Owner: postgres
--

ALTER TABLE ONLY objetivos.perspectiva_etiqueta
    ADD CONSTRAINT perspectiva_etiqueta_unique UNIQUE (id_etiquetas, id_perspectivas);


--
-- Name: perspectivas perspectivas_pk; Type: CONSTRAINT; Schema: objetivos; Owner: postgres
--

ALTER TABLE ONLY objetivos.perspectivas
    ADD CONSTRAINT perspectivas_pk PRIMARY KEY (id_perspectivas);


--
-- Name: perspectivas perspectivas_unique; Type: CONSTRAINT; Schema: objetivos; Owner: postgres
--

ALTER TABLE ONLY objetivos.perspectivas
    ADD CONSTRAINT perspectivas_unique UNIQUE (id_iconos);


--
-- Name: categorias categorias_pk; Type: CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.categorias
    ADD CONSTRAINT categorias_pk PRIMARY KEY (id_categorias);


--
-- Name: categorias categorias_unique; Type: CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.categorias
    ADD CONSTRAINT categorias_unique UNIQUE (categoria);


--
-- Name: detalle_productos detalle_productos_pk; Type: CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.detalle_productos
    ADD CONSTRAINT detalle_productos_pk PRIMARY KEY (id_detalle_productos);


--
-- Name: marcas marcas_pk; Type: CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.marcas
    ADD CONSTRAINT marcas_pk PRIMARY KEY (id_marcas);


--
-- Name: marcas marcas_unique; Type: CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.marcas
    ADD CONSTRAINT marcas_unique UNIQUE (marca);


--
-- Name: presentaciones presentaciones_pk; Type: CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.presentaciones
    ADD CONSTRAINT presentaciones_pk PRIMARY KEY (id_presentaciones);


--
-- Name: productos productos_pk; Type: CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.productos
    ADD CONSTRAINT productos_pk PRIMARY KEY (id_productos);


--
-- Name: productos productos_unique; Type: CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.productos
    ADD CONSTRAINT productos_unique UNIQUE (codigo);


--
-- Name: subcategorias subcategorias_pk; Type: CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.subcategorias
    ADD CONSTRAINT subcategorias_pk PRIMARY KEY (id_subcategorias);


--
-- Name: subcategorias subcategorias_unique; Type: CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.subcategorias
    ADD CONSTRAINT subcategorias_unique UNIQUE (subcategoria);


--
-- Name: tipo_productos tipo_productos_pk; Type: CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.tipo_productos
    ADD CONSTRAINT tipo_productos_pk PRIMARY KEY (id_tipo_productos);


--
-- Name: tipo_productos tipo_productos_unique; Type: CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.tipo_productos
    ADD CONSTRAINT tipo_productos_unique UNIQUE (tipo);


--
-- Name: unidades unidades_pk; Type: CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.unidades
    ADD CONSTRAINT unidades_pk PRIMARY KEY (id_unidades);


--
-- Name: unidades unidades_unique; Type: CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.unidades
    ADD CONSTRAINT unidades_unique UNIQUE (unidad);


--
-- Name: ciudades ciudades_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ciudades
    ADD CONSTRAINT ciudades_pk PRIMARY KEY (id_ciudades);


--
-- Name: ciudades ciudades_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ciudades
    ADD CONSTRAINT ciudades_unique UNIQUE (ciudad, id_estados);


--
-- Name: estados estados_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estados
    ADD CONSTRAINT estados_pk PRIMARY KEY (id_estados);


--
-- Name: estados estados_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estados
    ADD CONSTRAINT estados_unique UNIQUE (estado);


--
-- Name: fechas fechas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fechas
    ADD CONSTRAINT fechas_pkey PRIMARY KEY (fecha);


--
-- Name: horas horas_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.horas
    ADD CONSTRAINT horas_pk PRIMARY KEY (id_horas);


--
-- Name: permisos permisos_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permisos
    ADD CONSTRAINT permisos_pk PRIMARY KEY (id_permisos);


--
-- Name: personas personas_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personas
    ADD CONSTRAINT personas_pk PRIMARY KEY (id_personas);


--
-- Name: role_permiso role_permiso_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permiso
    ADD CONSTRAINT role_permiso_unique UNIQUE (id_roles, id_permisos);


--
-- Name: roles roles_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pk PRIMARY KEY (id_roles);


--
-- Name: tipo_facturas tipo_facturas_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_facturas
    ADD CONSTRAINT tipo_facturas_pk PRIMARY KEY (id_tipo_facturas);


--
-- Name: tipo_facturas tipo_facturas_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tipo_facturas
    ADD CONSTRAINT tipo_facturas_unique UNIQUE (tipo);


--
-- Name: usuarios usuarios_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pk PRIMARY KEY (id_usuarios);


--
-- Name: cotizaciones cotizaciones_pk; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cotizaciones
    ADD CONSTRAINT cotizaciones_pk PRIMARY KEY (id_cotizaciones);


--
-- Name: det_cotizacion det_cotizacion_pk; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.det_cotizacion
    ADD CONSTRAINT det_cotizacion_pk PRIMARY KEY (id_det_cotizacion);


--
-- Name: det_venta det_venta_pk; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.det_venta
    ADD CONSTRAINT det_venta_pk PRIMARY KEY (id_det_venta);


--
-- Name: tipo_clientes tipo_clientes_pk; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.tipo_clientes
    ADD CONSTRAINT tipo_clientes_pk PRIMARY KEY (id_tipo_clientes);


--
-- Name: tipo_clientes tipo_clientes_unique; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.tipo_clientes
    ADD CONSTRAINT tipo_clientes_unique UNIQUE (tipo);


--
-- Name: vendedores vendedores_pk; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.vendedores
    ADD CONSTRAINT vendedores_pk PRIMARY KEY (id_vendedores);


--
-- Name: ventas ventas_pk; Type: CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT ventas_pk PRIMARY KEY (id_ventas);


--
-- Name: idx_vw_almacenes_id; Type: INDEX; Schema: almacenes; Owner: postgres
--

CREATE UNIQUE INDEX idx_vw_almacenes_id ON almacenes.vw_almacenes USING btree (id);


--
-- Name: idx_vw_compras_id; Type: INDEX; Schema: compras; Owner: postgres
--

CREATE UNIQUE INDEX idx_vw_compras_id ON compras.vw_compras USING btree (id);


--
-- Name: idx_vw_ordenes_id; Type: INDEX; Schema: compras; Owner: postgres
--

CREATE UNIQUE INDEX idx_vw_ordenes_id ON compras.vw_ordenes USING btree (id);


--
-- Name: idx_vw_productos_id; Type: INDEX; Schema: productos; Owner: postgres
--

CREATE UNIQUE INDEX idx_vw_productos_id ON productos.vw_productos USING btree (id_productos);


--
-- Name: idx_vw_cotizaciones_id; Type: INDEX; Schema: ventas; Owner: postgres
--

CREATE UNIQUE INDEX idx_vw_cotizaciones_id ON ventas.vw_cotizaciones USING btree (id);


--
-- Name: idx_vw_ventas_id; Type: INDEX; Schema: ventas; Owner: postgres
--

CREATE UNIQUE INDEX idx_vw_ventas_id ON ventas.vw_ventas USING btree (id);


--
-- Name: movimientos tg_actualizar_almacenes; Type: TRIGGER; Schema: almacenes; Owner: postgres
--

CREATE TRIGGER tg_actualizar_almacenes AFTER INSERT OR DELETE OR UPDATE ON almacenes.movimientos FOR EACH STATEMENT EXECUTE FUNCTION almacenes.fn_refrescar_almacenes();


--
-- Name: compras tg_actualizar_compras; Type: TRIGGER; Schema: compras; Owner: postgres
--

CREATE TRIGGER tg_actualizar_compras AFTER INSERT OR DELETE OR UPDATE ON compras.compras FOR EACH STATEMENT EXECUTE FUNCTION compras.fn_refrescar_compras();


--
-- Name: compras tg_actualizar_ordenes; Type: TRIGGER; Schema: compras; Owner: postgres
--

CREATE TRIGGER tg_actualizar_ordenes AFTER INSERT OR DELETE OR UPDATE ON compras.compras FOR EACH STATEMENT EXECUTE FUNCTION compras.fn_refrescar_ordenes();


--
-- Name: productos tg_actualizar_productos; Type: TRIGGER; Schema: productos; Owner: postgres
--

CREATE TRIGGER tg_actualizar_productos AFTER INSERT OR DELETE OR UPDATE ON productos.productos FOR EACH STATEMENT EXECUTE FUNCTION productos.fn_refrescar_productos();


--
-- Name: cotizaciones tg_actualizar_cotizaciones; Type: TRIGGER; Schema: ventas; Owner: postgres
--

CREATE TRIGGER tg_actualizar_cotizaciones AFTER INSERT OR DELETE OR UPDATE ON ventas.cotizaciones FOR EACH STATEMENT EXECUTE FUNCTION ventas.fn_refrescar_cotizaciones();


--
-- Name: ventas tg_actualizar_ventas; Type: TRIGGER; Schema: ventas; Owner: postgres
--

CREATE TRIGGER tg_actualizar_ventas AFTER INSERT OR DELETE OR UPDATE ON ventas.ventas FOR EACH STATEMENT EXECUTE FUNCTION ventas.fn_refrescar_ventas();


--
-- Name: movimientos entradas_depositos_fk; Type: FK CONSTRAINT; Schema: almacenes; Owner: postgres
--

ALTER TABLE ONLY almacenes.movimientos
    ADD CONSTRAINT entradas_depositos_fk FOREIGN KEY (id_depositos) REFERENCES almacenes.depositos(id_depositos);


--
-- Name: movimientos entradas_productos_fk; Type: FK CONSTRAINT; Schema: almacenes; Owner: postgres
--

ALTER TABLE ONLY almacenes.movimientos
    ADD CONSTRAINT entradas_productos_fk FOREIGN KEY (id_productos) REFERENCES productos.productos(id_productos);


--
-- Name: movimientos entradas_tipo_movimientos_fk; Type: FK CONSTRAINT; Schema: almacenes; Owner: postgres
--

ALTER TABLE ONLY almacenes.movimientos
    ADD CONSTRAINT entradas_tipo_movimientos_fk FOREIGN KEY (id_tipo_movimientos) REFERENCES almacenes.tipo_movimientos(id_tipo_movimientos);


--
-- Name: compras compras_ordenes_compras_fk; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT compras_ordenes_compras_fk FOREIGN KEY (id_ordenes_compras) REFERENCES compras.ordenes_compras(id_ordenes_compras);


--
-- Name: compras compras_proveedores_fk; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT compras_proveedores_fk FOREIGN KEY (id_proveedores) REFERENCES compras.proveedores(id_proveedores);


--
-- Name: compras compras_tipo_facturas_fk; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.compras
    ADD CONSTRAINT compras_tipo_facturas_fk FOREIGN KEY (id_tipo_facturas) REFERENCES public.tipo_facturas(id_tipo_facturas);


--
-- Name: det_compra det_compra_compras_fk; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.det_compra
    ADD CONSTRAINT det_compra_compras_fk FOREIGN KEY (id_compras) REFERENCES compras.compras(id_compras);


--
-- Name: det_compra det_compra_depositos_fk; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.det_compra
    ADD CONSTRAINT det_compra_depositos_fk FOREIGN KEY (id_depositos) REFERENCES almacenes.depositos(id_depositos);


--
-- Name: det_compra det_compra_presentaciones_fk; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.det_compra
    ADD CONSTRAINT det_compra_presentaciones_fk FOREIGN KEY (id_presentaciones) REFERENCES productos.presentaciones(id_presentaciones);


--
-- Name: det_compra det_compra_productos_fk; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.det_compra
    ADD CONSTRAINT det_compra_productos_fk FOREIGN KEY (id_productos) REFERENCES productos.productos(id_productos);


--
-- Name: det_orden_compra det_orden_compra_depositos_fk; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.det_orden_compra
    ADD CONSTRAINT det_orden_compra_depositos_fk FOREIGN KEY (id_depositos) REFERENCES almacenes.depositos(id_depositos);


--
-- Name: det_orden_compra det_orden_compra_ordenes_compras_fk; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.det_orden_compra
    ADD CONSTRAINT det_orden_compra_ordenes_compras_fk FOREIGN KEY (id_ordenes_compras) REFERENCES compras.ordenes_compras(id_ordenes_compras);


--
-- Name: det_orden_compra det_orden_compra_productos_fk; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.det_orden_compra
    ADD CONSTRAINT det_orden_compra_productos_fk FOREIGN KEY (id_productos) REFERENCES productos.productos(id_productos);


--
-- Name: ordenes_compras ordenes_compras_proveedores_fk; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.ordenes_compras
    ADD CONSTRAINT ordenes_compras_proveedores_fk FOREIGN KEY (id_proveedores) REFERENCES compras.proveedores(id_proveedores);


--
-- Name: proveedores proveedores_tipo_proveedores_fk; Type: FK CONSTRAINT; Schema: compras; Owner: postgres
--

ALTER TABLE ONLY compras.proveedores
    ADD CONSTRAINT proveedores_tipo_proveedores_fk FOREIGN KEY (id_tipo_proveedores) REFERENCES compras.tipo_proveedores(id_tipo_proveedores);


--
-- Name: bancos bancos_tipo_bancos_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.bancos
    ADD CONSTRAINT bancos_tipo_bancos_fk FOREIGN KEY (id_tipo_bancos) REFERENCES finanzas.tipo_bancos(id_tipo_bancos);


--
-- Name: egreso_banco egreso_banco_bancos_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egreso_banco
    ADD CONSTRAINT egreso_banco_bancos_fk FOREIGN KEY (id_bancos) REFERENCES finanzas.bancos(id_bancos);


--
-- Name: egreso_banco egreso_banco_tipo_bancos_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egreso_banco
    ADD CONSTRAINT egreso_banco_tipo_bancos_fk FOREIGN KEY (id_tipo_bancos) REFERENCES finanzas.tipo_bancos(id_tipo_bancos);


--
-- Name: egreso_caja egreso_caja_cajas_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egreso_caja
    ADD CONSTRAINT egreso_caja_cajas_fk FOREIGN KEY (id_cajas) REFERENCES finanzas.cajas(id_cajas);


--
-- Name: egresos egresos_medios_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egresos
    ADD CONSTRAINT egresos_medios_fk FOREIGN KEY (id_medios) REFERENCES finanzas.medios(id_medios);


--
-- Name: egresos egresos_metodo_pagos_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egresos
    ADD CONSTRAINT egresos_metodo_pagos_fk FOREIGN KEY (id_metodo_pagos) REFERENCES finanzas.metodo_pagos(id_metodo_pagos);


--
-- Name: egresos egresos_monedas_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egresos
    ADD CONSTRAINT egresos_monedas_fk FOREIGN KEY (id_monedas) REFERENCES finanzas.monedas(id_monedas);


--
-- Name: egresos egresos_tipo_movimientos_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.egresos
    ADD CONSTRAINT egresos_tipo_movimientos_fk FOREIGN KEY (id_tipo_movimientos) REFERENCES finanzas.tipo_movimientos(id_tipo_movimientos);


--
-- Name: ingreso_banco ingreso_banco_bancos_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.ingreso_banco
    ADD CONSTRAINT ingreso_banco_bancos_fk FOREIGN KEY (id_bancos) REFERENCES finanzas.bancos(id_bancos);


--
-- Name: ingreso_banco ingreso_banco_tipo_bancos_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.ingreso_banco
    ADD CONSTRAINT ingreso_banco_tipo_bancos_fk FOREIGN KEY (id_tipo_bancos) REFERENCES finanzas.tipo_bancos(id_tipo_bancos);


--
-- Name: ingreso_caja ingreso_caja_cajas_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.ingreso_caja
    ADD CONSTRAINT ingreso_caja_cajas_fk FOREIGN KEY (id_cajas) REFERENCES finanzas.cajas(id_cajas);


--
-- Name: ingresos ingresos_medios_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.ingresos
    ADD CONSTRAINT ingresos_medios_fk FOREIGN KEY (id_medios) REFERENCES finanzas.medios(id_medios);


--
-- Name: ingresos ingresos_metodo_pagos_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.ingresos
    ADD CONSTRAINT ingresos_metodo_pagos_fk FOREIGN KEY (id_metodo_pagos) REFERENCES finanzas.metodo_pagos(id_metodo_pagos);


--
-- Name: ingresos ingresos_monedas_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.ingresos
    ADD CONSTRAINT ingresos_monedas_fk FOREIGN KEY (id_monedas) REFERENCES finanzas.monedas(id_monedas);


--
-- Name: ingresos ingresos_tipo_movimientos_fk; Type: FK CONSTRAINT; Schema: finanzas; Owner: postgres
--

ALTER TABLE ONLY finanzas.ingresos
    ADD CONSTRAINT ingresos_tipo_movimientos_fk FOREIGN KEY (id_tipo_movimientos) REFERENCES finanzas.tipo_movimientos(id_tipo_movimientos);


--
-- Name: etiqueta_indicador etiqueta_indicador_etiquetas_fk; Type: FK CONSTRAINT; Schema: objetivos; Owner: postgres
--

ALTER TABLE ONLY objetivos.etiqueta_indicador
    ADD CONSTRAINT etiqueta_indicador_etiquetas_fk FOREIGN KEY (id_etiquetas) REFERENCES objetivos.etiquetas(id_etiquetas);


--
-- Name: etiqueta_indicador etiqueta_indicador_indicadores_fk; Type: FK CONSTRAINT; Schema: objetivos; Owner: postgres
--

ALTER TABLE ONLY objetivos.etiqueta_indicador
    ADD CONSTRAINT etiqueta_indicador_indicadores_fk FOREIGN KEY (id_indicadores) REFERENCES objetivos.indicadores(id_indicadores);


--
-- Name: formulas formulas_etiquetas_fk; Type: FK CONSTRAINT; Schema: objetivos; Owner: postgres
--

ALTER TABLE ONLY objetivos.formulas
    ADD CONSTRAINT formulas_etiquetas_fk FOREIGN KEY (id_etiquetas) REFERENCES objetivos.etiquetas(id_etiquetas);


--
-- Name: objetivos objetivos_formulas_fk; Type: FK CONSTRAINT; Schema: objetivos; Owner: postgres
--

ALTER TABLE ONLY objetivos.objetivos
    ADD CONSTRAINT objetivos_formulas_fk FOREIGN KEY (id_formulas) REFERENCES objetivos.formulas(id_formulas);


--
-- Name: perspectiva_etiqueta perspectiva_etiqueta_etiquetas_fk; Type: FK CONSTRAINT; Schema: objetivos; Owner: postgres
--

ALTER TABLE ONLY objetivos.perspectiva_etiqueta
    ADD CONSTRAINT perspectiva_etiqueta_etiquetas_fk FOREIGN KEY (id_etiquetas) REFERENCES objetivos.etiquetas(id_etiquetas);


--
-- Name: perspectivas perspectivas_iconos_fk; Type: FK CONSTRAINT; Schema: objetivos; Owner: postgres
--

ALTER TABLE ONLY objetivos.perspectivas
    ADD CONSTRAINT perspectivas_iconos_fk FOREIGN KEY (id_iconos) REFERENCES objetivos.iconos(id_iconos);


--
-- Name: detalle_productos detalle_productos_ingredientes_fk; Type: FK CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.detalle_productos
    ADD CONSTRAINT detalle_productos_ingredientes_fk FOREIGN KEY (id_ingredientes) REFERENCES productos.productos(id_productos);


--
-- Name: detalle_productos detalle_productos_productos_fk; Type: FK CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.detalle_productos
    ADD CONSTRAINT detalle_productos_productos_fk FOREIGN KEY (id_productos) REFERENCES productos.productos(id_productos);


--
-- Name: detalle_productos detalle_productos_unidades_fk; Type: FK CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.detalle_productos
    ADD CONSTRAINT detalle_productos_unidades_fk FOREIGN KEY (id_unidades) REFERENCES productos.unidades(id_unidades);


--
-- Name: presentaciones presentaciones_productos_fk; Type: FK CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.presentaciones
    ADD CONSTRAINT presentaciones_productos_fk FOREIGN KEY (id_productos) REFERENCES productos.productos(id_productos);


--
-- Name: productos productos_categorias_fk; Type: FK CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.productos
    ADD CONSTRAINT productos_categorias_fk FOREIGN KEY (id_categorias) REFERENCES productos.categorias(id_categorias);


--
-- Name: productos productos_marcas_fk; Type: FK CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.productos
    ADD CONSTRAINT productos_marcas_fk FOREIGN KEY (id_marcas) REFERENCES productos.marcas(id_marcas);


--
-- Name: productos productos_subcategorias_fk; Type: FK CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.productos
    ADD CONSTRAINT productos_subcategorias_fk FOREIGN KEY (id_subcategorias) REFERENCES productos.subcategorias(id_subcategorias);


--
-- Name: productos productos_tipo_productos_fk; Type: FK CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.productos
    ADD CONSTRAINT productos_tipo_productos_fk FOREIGN KEY (id_tipo_productos) REFERENCES productos.tipo_productos(id_tipo_productos);


--
-- Name: productos productos_unidades_fk; Type: FK CONSTRAINT; Schema: productos; Owner: postgres
--

ALTER TABLE ONLY productos.productos
    ADD CONSTRAINT productos_unidades_fk FOREIGN KEY (id_unidades) REFERENCES productos.unidades(id_unidades);


--
-- Name: ciudades ciudades_estados_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ciudades
    ADD CONSTRAINT ciudades_estados_fk FOREIGN KEY (id_estados) REFERENCES public.estados(id_estados);


--
-- Name: personas personas_ciudades_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.personas
    ADD CONSTRAINT personas_ciudades_fk FOREIGN KEY (id_ciudades) REFERENCES public.ciudades(id_ciudades);


--
-- Name: role_permiso role_permiso_permisos_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permiso
    ADD CONSTRAINT role_permiso_permisos_fk FOREIGN KEY (id_permisos) REFERENCES public.permisos(id_permisos);


--
-- Name: role_permiso role_permiso_roles_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permiso
    ADD CONSTRAINT role_permiso_roles_fk FOREIGN KEY (id_roles) REFERENCES public.roles(id_roles);


--
-- Name: usuarios usuarios_roles_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_roles_fk FOREIGN KEY (id_roles) REFERENCES public.roles(id_roles);


--
-- Name: cotizaciones cotizaciones_ciudades_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cotizaciones
    ADD CONSTRAINT cotizaciones_ciudades_fk FOREIGN KEY (id_ciudades) REFERENCES public.ciudades(id_ciudades);


--
-- Name: cotizaciones cotizaciones_estados_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cotizaciones
    ADD CONSTRAINT cotizaciones_estados_fk FOREIGN KEY (id_estados) REFERENCES public.estados(id_estados);


--
-- Name: cotizaciones cotizaciones_personas_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cotizaciones
    ADD CONSTRAINT cotizaciones_personas_fk FOREIGN KEY (id_personas) REFERENCES public.personas(id_personas);


--
-- Name: cotizaciones cotizaciones_tipo_clientes_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cotizaciones
    ADD CONSTRAINT cotizaciones_tipo_clientes_fk FOREIGN KEY (id_tipo_clientes) REFERENCES ventas.tipo_clientes(id_tipo_clientes);


--
-- Name: cotizaciones cotizaciones_vendedores_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.cotizaciones
    ADD CONSTRAINT cotizaciones_vendedores_fk FOREIGN KEY (id_vendedores) REFERENCES ventas.vendedores(id_vendedores);


--
-- Name: det_cotizacion det_cotizacion_cotizaciones_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.det_cotizacion
    ADD CONSTRAINT det_cotizacion_cotizaciones_fk FOREIGN KEY (id_cotizaciones) REFERENCES ventas.cotizaciones(id_cotizaciones);


--
-- Name: det_cotizacion det_cotizacion_depositos_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.det_cotizacion
    ADD CONSTRAINT det_cotizacion_depositos_fk FOREIGN KEY (id_depositos) REFERENCES almacenes.depositos(id_depositos);


--
-- Name: det_cotizacion det_cotizacion_productos_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.det_cotizacion
    ADD CONSTRAINT det_cotizacion_productos_fk FOREIGN KEY (id_productos) REFERENCES productos.productos(id_productos);


--
-- Name: det_cotizacion det_cotizacion_vendedores_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.det_cotizacion
    ADD CONSTRAINT det_cotizacion_vendedores_fk FOREIGN KEY (id_vendedores) REFERENCES ventas.vendedores(id_vendedores);


--
-- Name: det_venta det_venta_depositos_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.det_venta
    ADD CONSTRAINT det_venta_depositos_fk FOREIGN KEY (id_depositos) REFERENCES almacenes.depositos(id_depositos);


--
-- Name: det_venta det_venta_presentaciones_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.det_venta
    ADD CONSTRAINT det_venta_presentaciones_fk FOREIGN KEY (id_presentaciones) REFERENCES productos.presentaciones(id_presentaciones);


--
-- Name: det_venta det_venta_productos_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.det_venta
    ADD CONSTRAINT det_venta_productos_fk FOREIGN KEY (id_productos) REFERENCES productos.productos(id_productos);


--
-- Name: det_venta det_venta_vendedores_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.det_venta
    ADD CONSTRAINT det_venta_vendedores_fk FOREIGN KEY (id_vendedores) REFERENCES ventas.vendedores(id_vendedores);


--
-- Name: det_venta det_venta_ventas_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.det_venta
    ADD CONSTRAINT det_venta_ventas_fk FOREIGN KEY (id_ventas) REFERENCES ventas.ventas(id_ventas);


--
-- Name: ventas ventas_cajas_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT ventas_cajas_fk FOREIGN KEY (id_cajas) REFERENCES finanzas.cajas(id_cajas);


--
-- Name: ventas ventas_ciudades_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT ventas_ciudades_fk FOREIGN KEY (id_ciudades) REFERENCES public.ciudades(id_ciudades);


--
-- Name: ventas ventas_cotizaciones_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT ventas_cotizaciones_fk FOREIGN KEY (id_cotizaciones) REFERENCES ventas.cotizaciones(id_cotizaciones);


--
-- Name: ventas ventas_estados_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT ventas_estados_fk FOREIGN KEY (id_estados) REFERENCES public.estados(id_estados);


--
-- Name: ventas ventas_personas_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT ventas_personas_fk FOREIGN KEY (id_personas) REFERENCES public.personas(id_personas);


--
-- Name: ventas ventas_tipo_clientes_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT ventas_tipo_clientes_fk FOREIGN KEY (id_tipo_clientes) REFERENCES ventas.tipo_clientes(id_tipo_clientes);


--
-- Name: ventas ventas_tipo_facturas_fk; Type: FK CONSTRAINT; Schema: ventas; Owner: postgres
--

ALTER TABLE ONLY ventas.ventas
    ADD CONSTRAINT ventas_tipo_facturas_fk FOREIGN KEY (id_tipo_facturas) REFERENCES public.tipo_facturas(id_tipo_facturas);


--
-- Name: vw_productos; Type: MATERIALIZED VIEW DATA; Schema: productos; Owner: postgres
--

REFRESH MATERIALIZED VIEW productos.vw_productos;


--
-- Name: vw_almacenes; Type: MATERIALIZED VIEW DATA; Schema: almacenes; Owner: postgres
--

REFRESH MATERIALIZED VIEW almacenes.vw_almacenes;


--
-- Name: vw_compras; Type: MATERIALIZED VIEW DATA; Schema: compras; Owner: postgres
--

REFRESH MATERIALIZED VIEW compras.vw_compras;


--
-- Name: vw_ordenes; Type: MATERIALIZED VIEW DATA; Schema: compras; Owner: postgres
--

REFRESH MATERIALIZED VIEW compras.vw_ordenes;


--
-- Name: vw_cotizaciones; Type: MATERIALIZED VIEW DATA; Schema: ventas; Owner: postgres
--

REFRESH MATERIALIZED VIEW ventas.vw_cotizaciones;


--
-- Name: vw_ventas; Type: MATERIALIZED VIEW DATA; Schema: ventas; Owner: postgres
--

REFRESH MATERIALIZED VIEW ventas.vw_ventas;


--
-- PostgreSQL database dump complete
--

