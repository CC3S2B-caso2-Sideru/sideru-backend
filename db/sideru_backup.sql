--
-- PostgreSQL database dump
--

\restrict Q7PGIxL4gXzr56FLgud1OcWp3IQi6ubz9hPpgvewlQtq5s9hqYUUC8oyQOixfFl

-- Dumped from database version 16.14 (Debian 16.14-1.pgdg12+1)
-- Dumped by pg_dump version 16.13 (Ubuntu 16.13-0ubuntu0.24.04.1)

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
-- Name: public; Type: SCHEMA; Schema: -; Owner: sideru_db_user
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO sideru_db_user;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: sideru_db_user
--

COMMENT ON SCHEMA public IS '';


--
-- Name: estado_cotizacion; Type: TYPE; Schema: public; Owner: sideru_db_user
--

CREATE TYPE public.estado_cotizacion AS ENUM (
    'borrador',
    'enviada',
    'aceptada',
    'rechazada',
    'expirada'
);


ALTER TYPE public.estado_cotizacion OWNER TO sideru_db_user;

--
-- Name: estado_justificacion; Type: TYPE; Schema: public; Owner: sideru_db_user
--

CREATE TYPE public.estado_justificacion AS ENUM (
    'pendiente',
    'aprobada',
    'rechazada'
);


ALTER TYPE public.estado_justificacion OWNER TO sideru_db_user;

--
-- Name: estado_orden_compra; Type: TYPE; Schema: public; Owner: sideru_db_user
--

CREATE TYPE public.estado_orden_compra AS ENUM (
    'borrador',
    'enviada',
    'confirmada',
    'recibida_parcial',
    'recibida',
    'anulada'
);


ALTER TYPE public.estado_orden_compra OWNER TO sideru_db_user;

--
-- Name: estado_pago; Type: TYPE; Schema: public; Owner: sideru_db_user
--

CREATE TYPE public.estado_pago AS ENUM (
    'pendiente',
    'pagado',
    'anulado'
);


ALTER TYPE public.estado_pago OWNER TO sideru_db_user;

--
-- Name: estado_pedido; Type: TYPE; Schema: public; Owner: sideru_db_user
--

CREATE TYPE public.estado_pedido AS ENUM (
    'pendiente',
    'confirmado',
    'en_preparacion',
    'despachado',
    'entregado',
    'cancelado',
    'rechazado_stock'
);


ALTER TYPE public.estado_pedido OWNER TO sideru_db_user;

--
-- Name: estadocotizacion; Type: TYPE; Schema: public; Owner: sideru_db_user
--

CREATE TYPE public.estadocotizacion AS ENUM (
    'aceptada',
    'borrador',
    'enviada',
    'expirada',
    'rechazada'
);


ALTER TYPE public.estadocotizacion OWNER TO sideru_db_user;

--
-- Name: estadopedido; Type: TYPE; Schema: public; Owner: sideru_db_user
--

CREATE TYPE public.estadopedido AS ENUM (
    'cancelado',
    'confirmado',
    'despachado',
    'en_preparacion',
    'entregado',
    'pendiente',
    'rechazado_stock'
);


ALTER TYPE public.estadopedido OWNER TO sideru_db_user;

--
-- Name: tipo_comprobante; Type: TYPE; Schema: public; Owner: sideru_db_user
--

CREATE TYPE public.tipo_comprobante AS ENUM (
    'factura',
    'boleta'
);


ALTER TYPE public.tipo_comprobante OWNER TO sideru_db_user;

--
-- Name: tipo_marcado; Type: TYPE; Schema: public; Owner: sideru_db_user
--

CREATE TYPE public.tipo_marcado AS ENUM (
    'entrada',
    'salida'
);


ALTER TYPE public.tipo_marcado OWNER TO sideru_db_user;

--
-- Name: CAST (public.estadocotizacion AS character varying); Type: CAST; Schema: -; Owner: -
--

CREATE CAST (public.estadocotizacion AS character varying) WITH INOUT AS IMPLICIT;


--
-- Name: CAST (public.estadopedido AS character varying); Type: CAST; Schema: -; Owner: -
--

CREATE CAST (public.estadopedido AS character varying) WITH INOUT AS IMPLICIT;


--
-- Name: CAST (character varying AS public.estadocotizacion); Type: CAST; Schema: -; Owner: -
--

CREATE CAST (character varying AS public.estadocotizacion) WITH INOUT AS IMPLICIT;


--
-- Name: CAST (character varying AS public.estadopedido); Type: CAST; Schema: -; Owner: -
--

CREATE CAST (character varying AS public.estadopedido) WITH INOUT AS IMPLICIT;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: asistencia; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.asistencia (
    id integer NOT NULL,
    empleado_id integer NOT NULL,
    fecha date NOT NULL,
    tipo public.tipo_marcado NOT NULL,
    hora time without time zone NOT NULL,
    ip_origen character varying(45),
    observacion text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.asistencia OWNER TO sideru_db_user;

--
-- Name: asistencia_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.asistencia_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.asistencia_id_seq OWNER TO sideru_db_user;

--
-- Name: asistencia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.asistencia_id_seq OWNED BY public.asistencia.id;


--
-- Name: cargo; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.cargo (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text,
    salario_base numeric(10,2) DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cargo OWNER TO sideru_db_user;

--
-- Name: cargo_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.cargo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cargo_id_seq OWNER TO sideru_db_user;

--
-- Name: cargo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.cargo_id_seq OWNED BY public.cargo.id;


--
-- Name: categoria; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.categoria (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion character varying(255),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.categoria OWNER TO sideru_db_user;

--
-- Name: categoria_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.categoria_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categoria_id_seq OWNER TO sideru_db_user;

--
-- Name: categoria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.categoria_id_seq OWNED BY public.categoria.id;


--
-- Name: cliente; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.cliente (
    id integer NOT NULL,
    usuario_id integer NOT NULL,
    ruc character varying(11),
    dni character varying(8),
    razon_social character varying(200),
    nombre character varying(100) NOT NULL,
    apellido character varying(100),
    telefono character varying(20),
    direccion text,
    activo boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cliente OWNER TO sideru_db_user;

--
-- Name: cliente_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.cliente_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cliente_id_seq OWNER TO sideru_db_user;

--
-- Name: cliente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.cliente_id_seq OWNED BY public.cliente.id;


--
-- Name: comprobante; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.comprobante (
    id integer NOT NULL,
    pedido_id integer NOT NULL,
    tipo public.tipo_comprobante NOT NULL,
    serie character varying(4) NOT NULL,
    numero character varying(8) NOT NULL,
    fecha_emision timestamp with time zone DEFAULT now() NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    igv numeric(12,2) NOT NULL,
    total numeric(12,2) NOT NULL,
    estado_pago public.estado_pago DEFAULT 'pendiente'::public.estado_pago NOT NULL,
    fecha_pago timestamp with time zone,
    metodo_pago character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.comprobante OWNER TO sideru_db_user;

--
-- Name: comprobante_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.comprobante_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comprobante_id_seq OWNER TO sideru_db_user;

--
-- Name: comprobante_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.comprobante_id_seq OWNED BY public.comprobante.id;


--
-- Name: cotizacion; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.cotizacion (
    id integer NOT NULL,
    cliente_id integer NOT NULL,
    fecha_emision timestamp with time zone DEFAULT now() NOT NULL,
    fecha_expiracion date NOT NULL,
    estado public.estado_cotizacion DEFAULT 'borrador'::public.estado_cotizacion NOT NULL,
    observaciones text,
    subtotal numeric(38,2) DEFAULT 0 NOT NULL,
    descuento_total numeric(38,2) DEFAULT 0 NOT NULL,
    igv numeric(38,2) DEFAULT 0 NOT NULL,
    total numeric(38,2) DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cotizacion OWNER TO sideru_db_user;

--
-- Name: cotizacion_detalle; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.cotizacion_detalle (
    id integer NOT NULL,
    cotizacion_id integer NOT NULL,
    producto_id integer NOT NULL,
    cantidad integer NOT NULL,
    precio_unitario numeric(38,2) NOT NULL,
    descuento numeric(38,2) DEFAULT 0 NOT NULL,
    subtotal numeric(38,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT cotizacion_detalle_cantidad_check CHECK ((cantidad > 0))
);


ALTER TABLE public.cotizacion_detalle OWNER TO sideru_db_user;

--
-- Name: cotizacion_detalle_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.cotizacion_detalle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cotizacion_detalle_id_seq OWNER TO sideru_db_user;

--
-- Name: cotizacion_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.cotizacion_detalle_id_seq OWNED BY public.cotizacion_detalle.id;


--
-- Name: cotizacion_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.cotizacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cotizacion_id_seq OWNER TO sideru_db_user;

--
-- Name: cotizacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.cotizacion_id_seq OWNED BY public.cotizacion.id;


--
-- Name: departamento; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.departamento (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.departamento OWNER TO sideru_db_user;

--
-- Name: departamento_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.departamento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.departamento_id_seq OWNER TO sideru_db_user;

--
-- Name: departamento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.departamento_id_seq OWNED BY public.departamento.id;


--
-- Name: empleado; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.empleado (
    id integer NOT NULL,
    usuario_id integer,
    departamento_id integer NOT NULL,
    cargo_id integer NOT NULL,
    dni character varying(8) NOT NULL,
    nombres character varying(100) NOT NULL,
    apellidos character varying(100) NOT NULL,
    email character varying(150) NOT NULL,
    telefono character varying(20),
    fecha_ingreso date NOT NULL,
    fecha_cese date,
    salario numeric(10,2) NOT NULL,
    cuenta_bancaria character varying(30),
    activo boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.empleado OWNER TO sideru_db_user;

--
-- Name: empleado_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.empleado_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.empleado_id_seq OWNER TO sideru_db_user;

--
-- Name: empleado_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.empleado_id_seq OWNED BY public.empleado.id;


--
-- Name: factura_proveedor; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.factura_proveedor (
    id integer NOT NULL,
    orden_compra_id integer NOT NULL,
    numero_factura character varying(50) NOT NULL,
    fecha_factura date NOT NULL,
    monto_total numeric(12,2) NOT NULL,
    estado_pago public.estado_pago DEFAULT 'pendiente'::public.estado_pago NOT NULL,
    fecha_pago date,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.factura_proveedor OWNER TO sideru_db_user;

--
-- Name: factura_proveedor_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.factura_proveedor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.factura_proveedor_id_seq OWNER TO sideru_db_user;

--
-- Name: factura_proveedor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.factura_proveedor_id_seq OWNED BY public.factura_proveedor.id;


--
-- Name: justificacion; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.justificacion (
    id integer NOT NULL,
    empleado_id integer NOT NULL,
    fecha_incidencia date NOT NULL,
    tipo_incidencia character varying(50) NOT NULL,
    descripcion text NOT NULL,
    estado public.estado_justificacion DEFAULT 'pendiente'::public.estado_justificacion NOT NULL,
    revisado_por integer,
    fecha_revision timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.justificacion OWNER TO sideru_db_user;

--
-- Name: justificacion_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.justificacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.justificacion_id_seq OWNER TO sideru_db_user;

--
-- Name: justificacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.justificacion_id_seq OWNED BY public.justificacion.id;


--
-- Name: orden_compra; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.orden_compra (
    id integer NOT NULL,
    proveedor_id integer NOT NULL,
    fecha_emision timestamp with time zone DEFAULT now() NOT NULL,
    fecha_estimada date,
    estado public.estado_orden_compra DEFAULT 'borrador'::public.estado_orden_compra NOT NULL,
    requiere_prestamo boolean DEFAULT false,
    total_estimado numeric(12,2) DEFAULT 0 NOT NULL,
    observaciones text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.orden_compra OWNER TO sideru_db_user;

--
-- Name: orden_compra_detalle; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.orden_compra_detalle (
    id integer NOT NULL,
    orden_compra_id integer NOT NULL,
    producto_id integer NOT NULL,
    cantidad integer NOT NULL,
    precio_unitario numeric(10,2) NOT NULL,
    subtotal numeric(12,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT orden_compra_detalle_cantidad_check CHECK ((cantidad > 0))
);


ALTER TABLE public.orden_compra_detalle OWNER TO sideru_db_user;

--
-- Name: orden_compra_detalle_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.orden_compra_detalle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orden_compra_detalle_id_seq OWNER TO sideru_db_user;

--
-- Name: orden_compra_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.orden_compra_detalle_id_seq OWNED BY public.orden_compra_detalle.id;


--
-- Name: orden_compra_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.orden_compra_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orden_compra_id_seq OWNER TO sideru_db_user;

--
-- Name: orden_compra_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.orden_compra_id_seq OWNED BY public.orden_compra.id;


--
-- Name: pedido; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.pedido (
    id integer NOT NULL,
    cotizacion_id integer NOT NULL,
    cliente_id integer NOT NULL,
    fecha_pedido timestamp with time zone DEFAULT now() NOT NULL,
    estado public.estado_pedido DEFAULT 'pendiente'::public.estado_pedido NOT NULL,
    motivo_rechazo text,
    total numeric(38,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.pedido OWNER TO sideru_db_user;

--
-- Name: pedido_detalle; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.pedido_detalle (
    id integer NOT NULL,
    pedido_id integer NOT NULL,
    producto_id integer NOT NULL,
    cantidad integer NOT NULL,
    precio_unitario numeric(38,2) NOT NULL,
    descuento numeric(38,2) DEFAULT 0 NOT NULL,
    subtotal numeric(38,2) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT pedido_detalle_cantidad_check CHECK ((cantidad > 0))
);


ALTER TABLE public.pedido_detalle OWNER TO sideru_db_user;

--
-- Name: pedido_detalle_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.pedido_detalle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pedido_detalle_id_seq OWNER TO sideru_db_user;

--
-- Name: pedido_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.pedido_detalle_id_seq OWNED BY public.pedido_detalle.id;


--
-- Name: pedido_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.pedido_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pedido_id_seq OWNER TO sideru_db_user;

--
-- Name: pedido_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.pedido_id_seq OWNED BY public.pedido.id;


--
-- Name: permiso; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.permiso (
    id integer NOT NULL,
    codigo character varying(255) NOT NULL,
    modulo character varying(255) NOT NULL,
    accion character varying(255) NOT NULL,
    descripcion character varying(255),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.permiso OWNER TO sideru_db_user;

--
-- Name: permiso_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.permiso_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.permiso_id_seq OWNER TO sideru_db_user;

--
-- Name: permiso_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.permiso_id_seq OWNED BY public.permiso.id;


--
-- Name: planilla; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.planilla (
    id integer NOT NULL,
    periodo character varying(7) NOT NULL,
    fecha_proceso timestamp with time zone DEFAULT now() NOT NULL,
    procesado_por integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.planilla OWNER TO sideru_db_user;

--
-- Name: planilla_detalle; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.planilla_detalle (
    id integer NOT NULL,
    planilla_id integer NOT NULL,
    empleado_id integer NOT NULL,
    dias_trabajados integer DEFAULT 0 NOT NULL,
    dias_falta integer DEFAULT 0 NOT NULL,
    dias_tardanza integer DEFAULT 0 NOT NULL,
    horas_extras numeric(5,2) DEFAULT 0 NOT NULL,
    salario_bruto numeric(10,2) NOT NULL,
    descuento_faltas numeric(10,2) DEFAULT 0 NOT NULL,
    descuento_tardanzas numeric(10,2) DEFAULT 0 NOT NULL,
    otros_descuentos numeric(10,2) DEFAULT 0 NOT NULL,
    bonificaciones numeric(10,2) DEFAULT 0 NOT NULL,
    salario_neto numeric(10,2) NOT NULL,
    cumplio_horas boolean DEFAULT true NOT NULL,
    fecha_deposito date,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.planilla_detalle OWNER TO sideru_db_user;

--
-- Name: planilla_detalle_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.planilla_detalle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.planilla_detalle_id_seq OWNER TO sideru_db_user;

--
-- Name: planilla_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.planilla_detalle_id_seq OWNED BY public.planilla_detalle.id;


--
-- Name: planilla_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.planilla_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.planilla_id_seq OWNER TO sideru_db_user;

--
-- Name: planilla_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.planilla_id_seq OWNED BY public.planilla.id;


--
-- Name: producto; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.producto (
    id integer NOT NULL,
    categoria_id integer NOT NULL,
    sku character varying(50) NOT NULL,
    nombre character varying(150) NOT NULL,
    descripcion character varying(255),
    imagen character varying(255),
    precio numeric(10,2) NOT NULL,
    stock integer DEFAULT 0 NOT NULL,
    stock_minimo integer DEFAULT 0,
    activo boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.producto OWNER TO sideru_db_user;

--
-- Name: producto_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.producto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.producto_id_seq OWNER TO sideru_db_user;

--
-- Name: producto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.producto_id_seq OWNED BY public.producto.id;


--
-- Name: proveedor; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.proveedor (
    id integer NOT NULL,
    ruc character varying(11) NOT NULL,
    razon_social character varying(200) NOT NULL,
    contacto character varying(100),
    email character varying(150),
    telefono character varying(20),
    direccion text,
    activo boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.proveedor OWNER TO sideru_db_user;

--
-- Name: proveedor_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.proveedor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.proveedor_id_seq OWNER TO sideru_db_user;

--
-- Name: proveedor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.proveedor_id_seq OWNED BY public.proveedor.id;


--
-- Name: recepcion_detalle; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.recepcion_detalle (
    id integer NOT NULL,
    recepcion_mercaderia_id integer NOT NULL,
    producto_id integer NOT NULL,
    cantidad_recibida integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT recepcion_detalle_cantidad_recibida_check CHECK ((cantidad_recibida > 0))
);


ALTER TABLE public.recepcion_detalle OWNER TO sideru_db_user;

--
-- Name: recepcion_detalle_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.recepcion_detalle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recepcion_detalle_id_seq OWNER TO sideru_db_user;

--
-- Name: recepcion_detalle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.recepcion_detalle_id_seq OWNED BY public.recepcion_detalle.id;


--
-- Name: recepcion_mercaderia; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.recepcion_mercaderia (
    id integer NOT NULL,
    orden_compra_id integer NOT NULL,
    fecha_recepcion timestamp with time zone DEFAULT now() NOT NULL,
    observaciones text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.recepcion_mercaderia OWNER TO sideru_db_user;

--
-- Name: recepcion_mercaderia_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.recepcion_mercaderia_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.recepcion_mercaderia_id_seq OWNER TO sideru_db_user;

--
-- Name: recepcion_mercaderia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.recepcion_mercaderia_id_seq OWNED BY public.recepcion_mercaderia.id;


--
-- Name: rol; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.rol (
    id integer NOT NULL,
    nombre character varying(255) NOT NULL,
    descripcion character varying(255),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.rol OWNER TO sideru_db_user;

--
-- Name: rol_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.rol_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rol_id_seq OWNER TO sideru_db_user;

--
-- Name: rol_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.rol_id_seq OWNED BY public.rol.id;


--
-- Name: rol_permiso; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.rol_permiso (
    rol_id integer NOT NULL,
    permiso_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.rol_permiso OWNER TO sideru_db_user;

--
-- Name: usuario; Type: TABLE; Schema: public; Owner: sideru_db_user
--

CREATE TABLE public.usuario (
    id integer NOT NULL,
    rol_id integer NOT NULL,
    tipo character varying(255) NOT NULL,
    username character varying(60) NOT NULL,
    email character varying(150) NOT NULL,
    password_hash text NOT NULL,
    activo boolean DEFAULT true,
    ultimo_login timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT usuario_tipo_check CHECK (((tipo)::text = ANY (ARRAY[('CLIENTE'::character varying)::text, ('INTERNO'::character varying)::text])))
);


ALTER TABLE public.usuario OWNER TO sideru_db_user;

--
-- Name: usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: sideru_db_user
--

CREATE SEQUENCE public.usuario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuario_id_seq OWNER TO sideru_db_user;

--
-- Name: usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sideru_db_user
--

ALTER SEQUENCE public.usuario_id_seq OWNED BY public.usuario.id;


--
-- Name: asistencia id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.asistencia ALTER COLUMN id SET DEFAULT nextval('public.asistencia_id_seq'::regclass);


--
-- Name: cargo id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.cargo ALTER COLUMN id SET DEFAULT nextval('public.cargo_id_seq'::regclass);


--
-- Name: categoria id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.categoria ALTER COLUMN id SET DEFAULT nextval('public.categoria_id_seq'::regclass);


--
-- Name: cliente id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.cliente ALTER COLUMN id SET DEFAULT nextval('public.cliente_id_seq'::regclass);


--
-- Name: comprobante id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.comprobante ALTER COLUMN id SET DEFAULT nextval('public.comprobante_id_seq'::regclass);


--
-- Name: cotizacion id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.cotizacion ALTER COLUMN id SET DEFAULT nextval('public.cotizacion_id_seq'::regclass);


--
-- Name: cotizacion_detalle id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.cotizacion_detalle ALTER COLUMN id SET DEFAULT nextval('public.cotizacion_detalle_id_seq'::regclass);


--
-- Name: departamento id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.departamento ALTER COLUMN id SET DEFAULT nextval('public.departamento_id_seq'::regclass);


--
-- Name: empleado id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.empleado ALTER COLUMN id SET DEFAULT nextval('public.empleado_id_seq'::regclass);


--
-- Name: factura_proveedor id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.factura_proveedor ALTER COLUMN id SET DEFAULT nextval('public.factura_proveedor_id_seq'::regclass);


--
-- Name: justificacion id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.justificacion ALTER COLUMN id SET DEFAULT nextval('public.justificacion_id_seq'::regclass);


--
-- Name: orden_compra id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.orden_compra ALTER COLUMN id SET DEFAULT nextval('public.orden_compra_id_seq'::regclass);


--
-- Name: orden_compra_detalle id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.orden_compra_detalle ALTER COLUMN id SET DEFAULT nextval('public.orden_compra_detalle_id_seq'::regclass);


--
-- Name: pedido id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.pedido ALTER COLUMN id SET DEFAULT nextval('public.pedido_id_seq'::regclass);


--
-- Name: pedido_detalle id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.pedido_detalle ALTER COLUMN id SET DEFAULT nextval('public.pedido_detalle_id_seq'::regclass);


--
-- Name: permiso id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.permiso ALTER COLUMN id SET DEFAULT nextval('public.permiso_id_seq'::regclass);


--
-- Name: planilla id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.planilla ALTER COLUMN id SET DEFAULT nextval('public.planilla_id_seq'::regclass);


--
-- Name: planilla_detalle id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.planilla_detalle ALTER COLUMN id SET DEFAULT nextval('public.planilla_detalle_id_seq'::regclass);


--
-- Name: producto id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.producto ALTER COLUMN id SET DEFAULT nextval('public.producto_id_seq'::regclass);


--
-- Name: proveedor id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.proveedor ALTER COLUMN id SET DEFAULT nextval('public.proveedor_id_seq'::regclass);


--
-- Name: recepcion_detalle id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.recepcion_detalle ALTER COLUMN id SET DEFAULT nextval('public.recepcion_detalle_id_seq'::regclass);


--
-- Name: recepcion_mercaderia id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.recepcion_mercaderia ALTER COLUMN id SET DEFAULT nextval('public.recepcion_mercaderia_id_seq'::regclass);


--
-- Name: rol id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.rol ALTER COLUMN id SET DEFAULT nextval('public.rol_id_seq'::regclass);


--
-- Name: usuario id; Type: DEFAULT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id SET DEFAULT nextval('public.usuario_id_seq'::regclass);


--
-- Data for Name: asistencia; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.asistencia (id, empleado_id, fecha, tipo, hora, ip_origen, observacion, created_at) FROM stdin;
1	3	2025-04-07	entrada	08:02:00	192.168.1.10	\N	2026-06-19 06:25:43.083426+00
2	3	2025-04-07	salida	17:01:00	192.168.1.10	\N	2026-06-19 06:25:43.083426+00
3	3	2025-04-08	entrada	08:05:00	192.168.1.10	\N	2026-06-19 06:25:43.083426+00
4	3	2025-04-08	salida	17:00:00	192.168.1.10	\N	2026-06-19 06:25:43.083426+00
5	3	2025-04-09	entrada	08:35:00	192.168.1.10	\N	2026-06-19 06:25:43.083426+00
6	3	2025-04-09	salida	17:00:00	192.168.1.10	\N	2026-06-19 06:25:43.083426+00
7	3	2025-04-10	entrada	08:01:00	192.168.1.10	\N	2026-06-19 06:25:43.083426+00
8	3	2025-04-10	salida	17:02:00	192.168.1.10	\N	2026-06-19 06:25:43.083426+00
9	3	2025-04-11	entrada	08:00:00	192.168.1.10	\N	2026-06-19 06:25:43.083426+00
10	3	2025-04-11	salida	17:00:00	192.168.1.10	\N	2026-06-19 06:25:43.083426+00
11	5	2025-04-07	entrada	07:58:00	192.168.1.20	\N	2026-06-19 06:25:43.250993+00
12	5	2025-04-07	salida	17:00:00	192.168.1.20	\N	2026-06-19 06:25:43.250993+00
13	5	2025-04-08	entrada	08:00:00	192.168.1.20	\N	2026-06-19 06:25:43.250993+00
14	5	2025-04-08	salida	17:05:00	192.168.1.20	\N	2026-06-19 06:25:43.250993+00
15	5	2025-04-10	entrada	08:02:00	192.168.1.20	\N	2026-06-19 06:25:43.250993+00
16	5	2025-04-10	salida	17:00:00	192.168.1.20	\N	2026-06-19 06:25:43.250993+00
17	5	2025-04-11	entrada	08:00:00	192.168.1.20	\N	2026-06-19 06:25:43.250993+00
18	5	2025-04-11	salida	17:00:00	192.168.1.20	\N	2026-06-19 06:25:43.250993+00
19	8	2025-04-07	entrada	08:00:00	192.168.1.30	\N	2026-06-19 06:25:43.412417+00
20	8	2025-04-07	salida	17:00:00	192.168.1.30	\N	2026-06-19 06:25:43.412417+00
21	8	2025-04-08	entrada	08:03:00	192.168.1.30	\N	2026-06-19 06:25:43.412417+00
22	8	2025-04-08	salida	17:00:00	192.168.1.30	\N	2026-06-19 06:25:43.412417+00
23	8	2025-04-09	entrada	08:01:00	192.168.1.30	\N	2026-06-19 06:25:43.412417+00
24	8	2025-04-09	salida	17:00:00	192.168.1.30	\N	2026-06-19 06:25:43.412417+00
25	8	2025-04-10	entrada	08:00:00	192.168.1.30	\N	2026-06-19 06:25:43.412417+00
26	8	2025-04-10	salida	17:02:00	192.168.1.30	\N	2026-06-19 06:25:43.412417+00
27	8	2025-04-11	entrada	08:00:00	192.168.1.30	\N	2026-06-19 06:25:43.412417+00
28	8	2025-04-11	salida	17:00:00	192.168.1.30	\N	2026-06-19 06:25:43.412417+00
\.


--
-- Data for Name: cargo; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.cargo (id, nombre, descripcion, salario_base, created_at, updated_at) FROM stdin;
1	Gerente General	Dirección estratégica de la empresa	8500.00	2026-06-19 06:25:38.204302+00	2026-06-19 06:25:38.204302+00
2	Jefe de Ventas	Coordinación del equipo comercial	4200.00	2026-06-19 06:25:38.204302+00	2026-06-19 06:25:38.204302+00
3	Vendedor	Atención de clientes y cotizaciones	2400.00	2026-06-19 06:25:38.204302+00	2026-06-19 06:25:38.204302+00
4	Jefe de Almacén	Control de stock y logística	3800.00	2026-06-19 06:25:38.204302+00	2026-06-19 06:25:38.204302+00
5	Almacenero	Recepción, almacenamiento y despacho	1800.00	2026-06-19 06:25:38.204302+00	2026-06-19 06:25:38.204302+00
6	Administrador de RRHH	Gestión de personal y planilla	3200.00	2026-06-19 06:25:38.204302+00	2026-06-19 06:25:38.204302+00
7	Asistente Administrativo	Soporte administrativo y contable	1900.00	2026-06-19 06:25:38.204302+00	2026-06-19 06:25:38.204302+00
\.


--
-- Data for Name: categoria; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.categoria (id, nombre, descripcion, created_at, updated_at) FROM stdin;
1	Barras y Varillas	Barras de acero liso y corrugado para construcción	2026-06-19 06:25:35.619474+00	2026-06-19 06:25:35.619474+00
2	Tubos y Cañerías	Tubería negra, galvanizada y de acero inoxidable	2026-06-19 06:25:35.619474+00	2026-06-19 06:25:35.619474+00
3	Planchas y Bobinas	Planchas laminadas en frío, en caliente y galvanizadas	2026-06-19 06:25:35.619474+00	2026-06-19 06:25:35.619474+00
4	Perfiles Estructurales	Ángulos, vigas, canales y tubos estructurales	2026-06-19 06:25:35.619474+00	2026-06-19 06:25:35.619474+00
5	Alambre y Malla	Alambre recocido, malla electrosoldada y gaviones	2026-06-19 06:25:35.619474+00	2026-06-19 06:25:35.619474+00
\.


--
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.cliente (id, usuario_id, ruc, dni, razon_social, nombre, apellido, telefono, direccion, activo, created_at, updated_at) FROM stdin;
1	7	20512345678	\N	Acero Sur S.A.C.	Carlos	Delgado	01-3451234	Av. Industrial 432, Villa El Salvador, Lima	t	2026-06-19 06:25:37.86237+00	2026-06-19 06:25:37.86237+00
2	8	20601234567	\N	Construcciones R&M E.I.R.L.	Roberto	Meza	01-2567890	Jr. Los Pinos 123, San Juan de Lurigancho, Lima	t	2026-06-19 06:25:37.86237+00	2026-06-19 06:25:37.86237+00
3	9	\N	\N	\N	Jorge	Silva	987654321	Calle Las Flores 45, Surquillo, Lima	t	2026-06-19 06:25:37.86237+00	2026-06-19 06:25:37.86237+00
4	10	10345678901	\N	\N	Fernando	Quispe	976543210	Av. Grau 890, Trujillo	t	2026-06-19 06:25:37.86237+00	2026-06-19 06:25:37.86237+00
5	11	\N	\N	\N	Rosa	Palacios	965432109	Jr. Amazonas 234, Arequipa	t	2026-06-19 06:25:37.86237+00	2026-06-19 06:25:37.86237+00
\.


--
-- Data for Name: comprobante; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.comprobante (id, pedido_id, tipo, serie, numero, fecha_emision, subtotal, igv, total, estado_pago, fecha_pago, metodo_pago, created_at, updated_at) FROM stdin;
1	1	factura	F001	00000001	2025-03-11 17:00:00+00	3364.00	407.27	3771.27	pagado	2025-03-11 20:30:00+00	transferencia	2026-06-19 06:25:41.415325+00	2026-06-19 06:25:41.415325+00
2	2	factura	F001	00000002	2025-03-13 15:00:00+00	7540.00	469.46	8009.46	pendiente	\N	transferencia	2026-06-19 06:25:41.579899+00	2026-06-19 06:25:41.579899+00
\.


--
-- Data for Name: cotizacion; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.cotizacion (id, cliente_id, fecha_emision, fecha_expiracion, estado, observaciones, subtotal, descuento_total, igv, total, created_at, updated_at) FROM stdin;
1	1	2025-03-10 14:00:00+00	2025-03-17	aceptada	\N	3364.00	168.20	575.47	3771.27	2026-06-19 06:25:38.706447+00	2026-06-19 06:25:38.706447+00
2	2	2025-03-12 16:30:00+00	2025-03-19	aceptada	\N	7540.00	754.00	1223.46	8009.46	2026-06-19 06:25:39.047912+00	2026-06-19 06:25:39.047912+00
3	3	2025-04-01 19:00:00+00	2025-04-08	enviada	\N	693.00	0.00	124.74	817.74	2026-06-19 06:25:39.380515+00	2026-06-19 06:25:39.380515+00
4	4	2025-02-20 15:00:00+00	2025-02-27	rechazada	Cliente no aceptó precio de vigas.	1560.00	0.00	280.80	1840.80	2026-06-19 06:25:39.705443+00	2026-06-19 06:25:39.705443+00
5	5	2025-04-05 21:00:00+00	2025-04-12	borrador	\N	185.00	0.00	33.30	218.30	2026-06-19 06:25:40.064726+00	2026-06-19 06:25:40.064726+00
6	1	2026-01-15 13:30:00+00	2026-01-22	aceptada	\N	5000.00	0.00	900.00	5900.00	2026-06-19 06:25:44.506012+00	2026-06-19 06:25:44.506012+00
7	2	2026-01-20 15:00:00+00	2026-01-27	rechazada	\N	3000.00	0.00	540.00	3540.00	2026-06-19 06:25:44.828985+00	2026-06-19 06:25:44.828985+00
8	3	2026-01-25 19:00:00+00	2026-02-01	aceptada	\N	8000.00	400.00	1368.00	8968.00	2026-06-19 06:25:45.15474+00	2026-06-19 06:25:45.15474+00
9	4	2026-02-05 14:00:00+00	2026-02-12	aceptada	\N	6500.00	0.00	1170.00	7670.00	2026-06-19 06:25:45.576621+00	2026-06-19 06:25:45.576621+00
10	5	2026-02-12 16:00:00+00	2026-02-19	rechazada	\N	4200.00	0.00	756.00	4956.00	2026-06-19 06:25:45.900574+00	2026-06-19 06:25:45.900574+00
11	1	2026-02-22 21:00:00+00	2026-03-01	enviada	\N	2000.00	0.00	360.00	2360.00	2026-06-19 06:25:46.293555+00	2026-06-19 06:25:46.293555+00
12	2	2026-03-01 13:00:00+00	2026-03-08	aceptada	\N	10000.00	500.00	1710.00	11210.00	2026-06-19 06:25:46.647868+00	2026-06-19 06:25:46.647868+00
13	3	2026-03-10 18:00:00+00	2026-03-17	enviada	\N	3500.00	0.00	630.00	4130.00	2026-06-19 06:25:46.987053+00	2026-06-19 06:25:46.987053+00
14	4	2026-03-18 15:30:00+00	2026-03-25	rechazada	\N	7000.00	0.00	1260.00	8260.00	2026-06-19 06:25:47.314677+00	2026-06-19 06:25:47.314677+00
15	5	2026-03-25 20:00:00+00	2026-04-01	aceptada	\N	4500.00	0.00	810.00	5310.00	2026-06-19 06:25:47.689367+00	2026-06-19 06:25:47.689367+00
16	1	2026-04-05 14:00:00+00	2026-04-12	aceptada	\N	5500.00	0.00	990.00	6490.00	2026-06-19 06:25:48.020892+00	2026-06-19 06:25:48.020892+00
17	2	2026-04-12 16:00:00+00	2026-04-19	rechazada	\N	9000.00	450.00	1539.00	10089.00	2026-06-19 06:25:48.349424+00	2026-06-19 06:25:48.349424+00
18	3	2026-04-20 19:00:00+00	2026-04-27	enviada	\N	1500.00	0.00	270.00	1770.00	2026-06-19 06:25:48.672422+00	2026-06-19 06:25:48.672422+00
19	4	2026-05-02 13:30:00+00	2026-05-09	aceptada	\N	7500.00	0.00	1350.00	8850.00	2026-06-19 06:25:49.113948+00	2026-06-19 06:25:49.113948+00
20	5	2026-05-10 15:00:00+00	2026-05-17	enviada	\N	3200.00	0.00	576.00	3776.00	2026-06-19 06:25:49.438055+00	2026-06-19 06:25:49.438055+00
21	1	2026-05-18 18:00:00+00	2026-05-25	rechazada	\N	11000.00	0.00	1980.00	12980.00	2026-06-19 06:25:49.763616+00	2026-06-19 06:25:49.763616+00
22	2	2026-05-25 21:00:00+00	2026-06-01	aceptada	\N	6000.00	300.00	1026.00	6726.00	2026-06-19 06:25:50.087342+00	2026-06-19 06:25:50.087342+00
23	3	2026-06-01 14:00:00+00	2026-06-08	aceptada	\N	4000.00	0.00	720.00	4720.00	2026-06-19 06:25:50.434631+00	2026-06-19 06:25:50.434631+00
24	4	2026-06-08 15:30:00+00	2026-06-15	enviada	\N	5000.00	0.00	900.00	5900.00	2026-06-19 06:25:50.759569+00	2026-06-19 06:25:50.759569+00
25	5	2026-06-12 19:00:00+00	2026-06-19	aceptada	\N	8500.00	425.00	1453.50	9528.50	2026-06-19 06:25:51.082693+00	2026-06-19 06:25:51.082693+00
26	1	2026-06-16 13:00:00+00	2026-06-23	rechazada	\N	2500.00	0.00	450.00	2950.00	2026-06-19 06:25:51.441994+00	2026-06-19 06:25:51.441994+00
\.


--
-- Data for Name: cotizacion_detalle; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.cotizacion_detalle (id, cotizacion_id, producto_id, cantidad, precio_unitario, descuento, subtotal, created_at, updated_at) FROM stdin;
1	1	1	50	18.50	5.00	877.25	2026-06-19 06:25:38.87565+00	2026-06-19 06:25:38.87565+00
2	1	2	30	28.90	5.00	822.15	2026-06-19 06:25:38.87565+00	2026-06-19 06:25:38.87565+00
3	1	5	20	55.00	5.00	1045.00	2026-06-19 06:25:38.87565+00	2026-06-19 06:25:38.87565+00
4	1	10	15	38.00	5.00	541.50	2026-06-19 06:25:38.87565+00	2026-06-19 06:25:38.87565+00
5	2	3	60	58.00	10.00	3132.00	2026-06-19 06:25:39.211847+00	2026-06-19 06:25:39.211847+00
6	2	6	15	195.00	10.00	2632.50	2026-06-19 06:25:39.211847+00	2026-06-19 06:25:39.211847+00
7	2	8	10	210.00	10.00	1890.00	2026-06-19 06:25:39.211847+00	2026-06-19 06:25:39.211847+00
8	3	11	10	44.00	0.00	440.00	2026-06-19 06:25:39.542319+00	2026-06-19 06:25:39.542319+00
9	3	12	1	98.00	0.00	98.00	2026-06-19 06:25:39.542319+00	2026-06-19 06:25:39.542319+00
10	3	1	5	18.50	0.00	92.50	2026-06-19 06:25:39.542319+00	2026-06-19 06:25:39.542319+00
11	3	10	1	38.00	0.00	38.00	2026-06-19 06:25:39.542319+00	2026-06-19 06:25:39.542319+00
12	4	6	8	195.00	0.00	1560.00	2026-06-19 06:25:39.899926+00	2026-06-19 06:25:39.899926+00
13	5	9	1	185.00	0.00	185.00	2026-06-19 06:25:40.235899+00	2026-06-19 06:25:40.235899+00
14	6	1	100	50.00	0.00	5000.00	2026-06-19 06:25:44.66746+00	2026-06-19 06:25:44.66746+00
15	7	2	50	60.00	0.00	3000.00	2026-06-19 06:25:44.990527+00	2026-06-19 06:25:44.990527+00
16	8	3	100	80.00	5.00	7600.00	2026-06-19 06:25:45.414671+00	2026-06-19 06:25:45.414671+00
17	8	4	10	40.00	0.00	400.00	2026-06-19 06:25:45.414671+00	2026-06-19 06:25:45.414671+00
18	9	5	50	130.00	0.00	6500.00	2026-06-19 06:25:45.739535+00	2026-06-19 06:25:45.739535+00
19	10	6	20	210.00	0.00	4200.00	2026-06-19 06:25:46.132573+00	2026-06-19 06:25:46.132573+00
20	11	7	40	50.00	0.00	2000.00	2026-06-19 06:25:46.473003+00	2026-06-19 06:25:46.473003+00
21	12	8	50	200.00	5.00	9500.00	2026-06-19 06:25:46.810948+00	2026-06-19 06:25:46.810948+00
22	12	9	5	100.00	0.00	500.00	2026-06-19 06:25:46.810948+00	2026-06-19 06:25:46.810948+00
23	13	10	70	50.00	0.00	3500.00	2026-06-19 06:25:47.150246+00	2026-06-19 06:25:47.150246+00
24	14	11	100	70.00	0.00	7000.00	2026-06-19 06:25:47.527875+00	2026-06-19 06:25:47.527875+00
25	15	12	30	150.00	0.00	4500.00	2026-06-19 06:25:47.851151+00	2026-06-19 06:25:47.851151+00
26	16	1	100	55.00	0.00	5500.00	2026-06-19 06:25:48.184814+00	2026-06-19 06:25:48.184814+00
27	17	2	150	60.00	5.00	8550.00	2026-06-19 06:25:48.511021+00	2026-06-19 06:25:48.511021+00
28	17	3	10	45.00	0.00	450.00	2026-06-19 06:25:48.511021+00	2026-06-19 06:25:48.511021+00
29	18	4	30	50.00	0.00	1500.00	2026-06-19 06:25:48.841341+00	2026-06-19 06:25:48.841341+00
30	19	5	50	150.00	0.00	7500.00	2026-06-19 06:25:49.27693+00	2026-06-19 06:25:49.27693+00
31	20	6	20	160.00	0.00	3200.00	2026-06-19 06:25:49.601445+00	2026-06-19 06:25:49.601445+00
32	21	7	100	110.00	0.00	11000.00	2026-06-19 06:25:49.925544+00	2026-06-19 06:25:49.925544+00
33	22	8	60	100.00	5.00	5700.00	2026-06-19 06:25:50.263269+00	2026-06-19 06:25:50.263269+00
34	22	9	5	60.00	0.00	300.00	2026-06-19 06:25:50.263269+00	2026-06-19 06:25:50.263269+00
35	23	10	80	50.00	0.00	4000.00	2026-06-19 06:25:50.596203+00	2026-06-19 06:25:50.596203+00
36	24	11	50	100.00	0.00	5000.00	2026-06-19 06:25:50.921008+00	2026-06-19 06:25:50.921008+00
37	25	12	50	170.00	5.00	8075.00	2026-06-19 06:25:51.263998+00	2026-06-19 06:25:51.263998+00
38	25	1	10	42.50	0.00	425.00	2026-06-19 06:25:51.263998+00	2026-06-19 06:25:51.263998+00
39	26	2	50	50.00	0.00	2500.00	2026-06-19 06:25:51.604179+00	2026-06-19 06:25:51.604179+00
\.


--
-- Data for Name: departamento; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.departamento (id, nombre, created_at, updated_at) FROM stdin;
1	Gerencia General	2026-06-19 06:25:38.029712+00	2026-06-19 06:25:38.029712+00
2	Ventas	2026-06-19 06:25:38.029712+00	2026-06-19 06:25:38.029712+00
3	Logística y Almacén	2026-06-19 06:25:38.029712+00	2026-06-19 06:25:38.029712+00
4	Recursos Humanos	2026-06-19 06:25:38.029712+00	2026-06-19 06:25:38.029712+00
5	Administración y Finanzas	2026-06-19 06:25:38.029712+00	2026-06-19 06:25:38.029712+00
\.


--
-- Data for Name: empleado; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.empleado (id, usuario_id, departamento_id, cargo_id, dni, nombres, apellidos, email, telefono, fecha_ingreso, fecha_cese, salario, cuenta_bancaria, activo, created_at, updated_at) FROM stdin;
1	1	1	1	08123456	Miguel	Torres Salas	admin@siderurgicaperu.com	01-4561234	2018-03-01	\N	8500.00	00-123-456789	t	2026-06-19 06:25:38.369075+00	2026-06-19 06:25:38.369075+00
2	2	1	1	09234567	Patricia	Vargas Huamán	gerente@siderurgicaperu.com	01-4561235	2019-06-15	\N	8500.00	00-123-456790	t	2026-06-19 06:25:38.369075+00	2026-06-19 06:25:38.369075+00
3	3	2	3	10345678	Lucía	Luna Ccopa	vluna@siderurgicaperu.com	987001122	2021-01-10	\N	2400.00	00-234-567891	t	2026-06-19 06:25:38.369075+00	2026-06-19 06:25:38.369075+00
4	4	2	3	11456789	Marco	Ríos Paredes	vrios@siderurgicaperu.com	987002233	2021-04-05	\N	2400.00	00-234-567892	t	2026-06-19 06:25:38.369075+00	2026-06-19 06:25:38.369075+00
5	5	3	4	12567890	Eduardo	Huanca Flores	ahuanca@siderurgicaperu.com	987003344	2020-07-20	\N	3800.00	00-345-678903	t	2026-06-19 06:25:38.369075+00	2026-06-19 06:25:38.369075+00
6	6	4	6	13678901	Carmen	Mendoza Díaz	rmendoza@siderurgicaperu.com	987004455	2020-02-01	\N	3200.00	00-456-789014	t	2026-06-19 06:25:38.369075+00	2026-06-19 06:25:38.369075+00
7	\N	2	2	14789012	Andrés	Castillo Vega	acastillo@siderurgicaperu.com	987005566	2017-09-12	\N	4200.00	00-234-567893	t	2026-06-19 06:25:38.369075+00	2026-06-19 06:25:38.369075+00
8	\N	3	5	15890123	Rocío	Apaza Torres	rapaza@siderurgicaperu.com	987006677	2022-03-15	\N	1800.00	00-345-678904	t	2026-06-19 06:25:38.369075+00	2026-06-19 06:25:38.369075+00
9	\N	5	7	16901234	Silvana	Campos Ruiz	scampos@siderurgicaperu.com	987007788	2023-01-09	\N	1900.00	00-567-890125	t	2026-06-19 06:25:38.369075+00	2026-06-19 06:25:38.369075+00
\.


--
-- Data for Name: factura_proveedor; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.factura_proveedor (id, orden_compra_id, numero_factura, fecha_factura, monto_total, estado_pago, fecha_pago, created_at, updated_at) FROM stdin;
1	1	F001-00045231	2025-03-04	9750.00	pagado	2025-03-15	2026-06-19 06:25:42.756762+00	2026-06-19 06:25:42.756762+00
2	2	F001-00048890	2025-04-02	24600.00	pendiente	\N	2026-06-19 06:25:42.921992+00	2026-06-19 06:25:42.921992+00
\.


--
-- Data for Name: justificacion; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.justificacion (id, empleado_id, fecha_incidencia, tipo_incidencia, descripcion, estado, revisado_por, fecha_revision, created_at, updated_at) FROM stdin;
1	3	2025-04-09	tardanza	Demora por accidente en Av. Javier Prado que bloqueó el tránsito. Adjunto foto de accidente.	aprobada	6	2025-04-10 14:00:00+00	2026-06-19 06:25:43.58871+00	2026-06-19 06:25:43.58871+00
2	5	2025-04-09	falta	Atención médica de emergencia por infección estomacal. Adjunto descanso médico del Hospital Rebagliati.	aprobada	6	2025-04-10 15:30:00+00	2026-06-19 06:25:43.775943+00	2026-06-19 06:25:43.775943+00
3	8	2025-04-14	tardanza	El reloj marcador presentó falla técnica a las 8:00 am del lunes 14. Se informó al administrador en el momento.	pendiente	\N	\N	2026-06-19 06:25:43.993915+00	2026-06-19 06:25:43.993915+00
\.


--
-- Data for Name: orden_compra; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.orden_compra (id, proveedor_id, fecha_emision, fecha_estimada, estado, requiere_prestamo, total_estimado, observaciones, created_at, updated_at) FROM stdin;
1	1	2025-02-22 14:00:00+00	2025-03-05	recibida	f	9750.00	Reposición urgente de Viga H tras rechazo de pedido #3.	2026-06-19 06:25:41.743779+00	2026-06-19 06:25:41.743779+00
2	4	2025-04-02 16:00:00+00	2025-04-20	confirmada	t	24600.00	\N	2026-06-19 06:25:42.08305+00	2026-06-19 06:25:42.08305+00
\.


--
-- Data for Name: orden_compra_detalle; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.orden_compra_detalle (id, orden_compra_id, producto_id, cantidad, precio_unitario, subtotal, created_at, updated_at) FROM stdin;
1	1	6	50	175.00	8750.00	2026-06-19 06:25:41.914925+00	2026-06-19 06:25:41.914925+00
2	1	7	10	70.00	700.00	2026-06-19 06:25:41.914925+00	2026-06-19 06:25:41.914925+00
3	1	8	1	140.00	140.00	2026-06-19 06:25:41.914925+00	2026-06-19 06:25:41.914925+00
4	2	1	500	14.00	7000.00	2026-06-19 06:25:42.247588+00	2026-06-19 06:25:42.247588+00
5	2	2	400	22.00	8800.00	2026-06-19 06:25:42.247588+00	2026-06-19 06:25:42.247588+00
6	2	3	150	44.00	6600.00	2026-06-19 06:25:42.247588+00	2026-06-19 06:25:42.247588+00
7	2	4	100	32.00	3200.00	2026-06-19 06:25:42.247588+00	2026-06-19 06:25:42.247588+00
8	2	10	200	25.00	5000.00	2026-06-19 06:25:42.247588+00	2026-06-19 06:25:42.247588+00
\.


--
-- Data for Name: pedido; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.pedido (id, cotizacion_id, cliente_id, fecha_pedido, estado, motivo_rechazo, total, created_at, updated_at) FROM stdin;
1	1	1	2025-03-11 13:30:00+00	entregado	\N	3771.27	2026-06-19 06:25:40.408462+00	2026-06-19 06:25:40.408462+00
2	2	2	2025-03-13 14:00:00+00	en_preparacion	\N	8009.46	2026-06-19 06:25:40.751906+00	2026-06-19 06:25:40.751906+00
3	4	4	2025-02-21 15:15:00+00	rechazado_stock	Stock insuficiente de Viga H 4": disponible 5 unidades, solicitadas 8.	1840.80	2026-06-19 06:25:41.079298+00	2026-06-19 06:25:41.079298+00
\.


--
-- Data for Name: pedido_detalle; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.pedido_detalle (id, pedido_id, producto_id, cantidad, precio_unitario, descuento, subtotal, created_at, updated_at) FROM stdin;
1	1	1	50	18.50	5.00	877.25	2026-06-19 06:25:40.574909+00	2026-06-19 06:25:40.574909+00
2	1	2	30	28.90	5.00	822.15	2026-06-19 06:25:40.574909+00	2026-06-19 06:25:40.574909+00
3	1	5	20	55.00	5.00	1045.00	2026-06-19 06:25:40.574909+00	2026-06-19 06:25:40.574909+00
4	1	10	15	38.00	5.00	541.50	2026-06-19 06:25:40.574909+00	2026-06-19 06:25:40.574909+00
5	2	3	60	58.00	10.00	3132.00	2026-06-19 06:25:40.914928+00	2026-06-19 06:25:40.914928+00
6	2	6	15	195.00	10.00	2632.50	2026-06-19 06:25:40.914928+00	2026-06-19 06:25:40.914928+00
7	2	8	10	210.00	10.00	1890.00	2026-06-19 06:25:40.914928+00	2026-06-19 06:25:40.914928+00
8	3	6	8	195.00	0.00	1560.00	2026-06-19 06:25:41.248112+00	2026-06-19 06:25:41.248112+00
\.


--
-- Data for Name: permiso; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.permiso (id, codigo, modulo, accion, descripcion, created_at, updated_at) FROM stdin;
1	cotizacion.ver	ventas	ver	Ver listado y detalle de cotizaciones	2026-06-19 06:25:36.280805+00	2026-06-19 06:25:36.280805+00
2	cotizacion.crear	ventas	crear	Crear nuevas cotizaciones	2026-06-19 06:25:36.280805+00	2026-06-19 06:25:36.280805+00
3	cotizacion.editar	ventas	editar	Editar cotizaciones existentes	2026-06-19 06:25:36.280805+00	2026-06-19 06:25:36.280805+00
4	cotizacion.aprobar	ventas	aprobar	Aprobar o rechazar cotizaciones	2026-06-19 06:25:36.280805+00	2026-06-19 06:25:36.280805+00
5	pedido.ver	ventas	ver	Ver pedidos	2026-06-19 06:25:36.280805+00	2026-06-19 06:25:36.280805+00
6	pedido.crear	ventas	crear	Registrar pedidos	2026-06-19 06:25:36.280805+00	2026-06-19 06:25:36.280805+00
7	pedido.editar	ventas	editar	Actualizar estado de pedidos	2026-06-19 06:25:36.280805+00	2026-06-19 06:25:36.280805+00
8	comprobante.crear	ventas	crear	Emitir facturas y boletas	2026-06-19 06:25:36.280805+00	2026-06-19 06:25:36.280805+00
9	stock.ver	logistica	ver	Consultar stock de productos	2026-06-19 06:25:36.280805+00	2026-06-19 06:25:36.280805+00
10	stock.editar	logistica	editar	Ajustar stock manualmente	2026-06-19 06:25:36.280805+00	2026-06-19 06:25:36.280805+00
11	orden_compra.ver	logistica	ver	Ver órdenes de compra	2026-06-19 06:25:36.280805+00	2026-06-19 06:25:36.280805+00
12	orden_compra.crear	logistica	crear	Crear órdenes de compra	2026-06-19 06:25:36.280805+00	2026-06-19 06:25:36.280805+00
13	recepcion.crear	logistica	crear	Registrar recepciones de mercadería	2026-06-19 06:25:36.280805+00	2026-06-19 06:25:36.280805+00
14	empleado.ver	rrhh	ver	Ver empleados	2026-06-19 06:25:36.280805+00	2026-06-19 06:25:36.280805+00
15	empleado.crear	rrhh	crear	Registrar nuevos empleados	2026-06-19 06:25:36.280805+00	2026-06-19 06:25:36.280805+00
16	asistencia.ver	rrhh	ver	Ver registros de asistencia	2026-06-19 06:25:36.280805+00	2026-06-19 06:25:36.280805+00
17	planilla.ver	rrhh	ver	Ver planillas	2026-06-19 06:25:36.280805+00	2026-06-19 06:25:36.280805+00
18	planilla.procesar	rrhh	aprobar	Procesar planilla mensual	2026-06-19 06:25:36.280805+00	2026-06-19 06:25:36.280805+00
19	reporte.ver	reportes	ver	Acceder a reportes gerenciales	2026-06-19 06:25:36.280805+00	2026-06-19 06:25:36.280805+00
20	usuario.gestionar	admin	editar	Gestionar usuarios y roles	2026-06-19 06:25:36.280805+00	2026-06-19 06:25:36.280805+00
\.


--
-- Data for Name: planilla; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.planilla (id, periodo, fecha_proceso, procesado_por, created_at, updated_at) FROM stdin;
1	2025-03	2025-04-01 15:00:00+00	6	2026-06-19 06:25:44.157776+00	2026-06-19 06:25:44.157776+00
\.


--
-- Data for Name: planilla_detalle; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.planilla_detalle (id, planilla_id, empleado_id, dias_trabajados, dias_falta, dias_tardanza, horas_extras, salario_bruto, descuento_faltas, descuento_tardanzas, otros_descuentos, bonificaciones, salario_neto, cumplio_horas, fecha_deposito, created_at, updated_at) FROM stdin;
1	1	3	21	0	1	0.00	2400.00	0.00	40.00	0.00	0.00	2360.00	t	2025-04-05	2026-06-19 06:25:44.322152+00	2026-06-19 06:25:44.322152+00
2	1	4	22	0	0	2.00	2400.00	0.00	0.00	0.00	60.00	2460.00	t	2025-04-05	2026-06-19 06:25:44.322152+00	2026-06-19 06:25:44.322152+00
3	1	5	21	1	0	0.00	3800.00	172.73	0.00	0.00	0.00	3627.27	f	2025-04-05	2026-06-19 06:25:44.322152+00	2026-06-19 06:25:44.322152+00
4	1	6	22	0	0	0.00	3200.00	0.00	0.00	0.00	0.00	3200.00	t	2025-04-05	2026-06-19 06:25:44.322152+00	2026-06-19 06:25:44.322152+00
5	1	7	22	0	0	4.00	4200.00	0.00	0.00	0.00	160.00	4360.00	t	2025-04-05	2026-06-19 06:25:44.322152+00	2026-06-19 06:25:44.322152+00
6	1	8	22	0	0	0.00	1800.00	0.00	0.00	0.00	0.00	1800.00	t	2025-04-05	2026-06-19 06:25:44.322152+00	2026-06-19 06:25:44.322152+00
7	1	9	20	0	2	0.00	1900.00	0.00	57.58	0.00	0.00	1842.42	f	2025-04-05	2026-06-19 06:25:44.322152+00	2026-06-19 06:25:44.322152+00
\.


--
-- Data for Name: producto; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.producto (id, categoria_id, sku, nombre, descripcion, imagen, precio, stock, stock_minimo, activo, created_at, updated_at) FROM stdin;
1	1	ACR-BAR-001	Barra de acero 1/2"	Barra corrugada de 1/2 pulgada	https://d34fyu2ua7aizz.cloudfront.net/images/product/24/large/ts_image_5efab149052110_81097952.png	45.50	100	20	t	2026-06-19 06:25:35.782237+00	2026-06-19 06:25:35.782237+00
2	1	ACR-BAR-002	Barra de acero 3/4"	Barra corrugada de 3/4 pulgada	https://d34fyu2ua7aizz.cloudfront.net/images/product/24/large/ts_image_5efab36d826891_21256458.png	70.00	80	15	t	2026-06-19 06:25:35.782237+00	2026-06-19 06:25:35.782237+00
3	2	TUB-NEG-001	Tubo negro 2"	Tubo de acero negro de 2 pulgadas	https://www.sodimac.com.pe/sodimac-pe/articulo/120584782/tubo-redondo-23-5-negro-2-5m/120584784	60.00	50	10	t	2026-06-19 06:25:35.782237+00	2026-06-19 06:25:35.782237+00
4	2	TUB-GAL-002	Tubo galvanizado 1"	Tubo galvanizado resistente a la corrosión	https://ferreteria-laestrella.com/808-large_default/tubo-galvanizado-1-c-40-tramo.jpg	55.00	30	10	t	2026-06-19 06:25:35.782237+00	2026-06-19 06:25:35.782237+00
5	3	PLA-ACE-001	Plancha de acero 1mm	Plancha delgada de acero	https://aba.com.pe/wp-content/uploads/2024/12/naval.png	120.00	0	5	t	2026-06-19 06:25:35.782237+00	2026-06-19 06:25:35.782237+00
6	3	PLA-ACE-002	Plancha de acero 3mm	Plancha gruesa de acero	https://fixmetal.shop/wp-content/uploads/2024/07/PLANCHAS_NAVALES.jpg	250.00	20	5	t	2026-06-19 06:25:35.782237+00	2026-06-19 06:25:35.782237+00
7	4	PER-ANG-001	Ángulo 2x2	Perfil angular de acero 2x2 pulgadas	https://cdn-haoob.nitrocdn.com/DSNuMdcXsYBrEWHsQCEyKvmsrgktJPmJ/assets/images/optimized/rev-f3136ac/www.montanstahl.com/wp-content/uploads/2017/07/L-Mix.jpg	35.00	60	15	t	2026-06-19 06:25:35.782237+00	2026-06-19 06:25:35.782237+00
8	4	PER-CAN-002	Canal U 3"	Perfil tipo canal U de 3 pulgadas	https://www.covema.pe/wp-content/uploads/2019/12/canal-perfilado-hq.jpg	90.00	25	5	t	2026-06-19 06:25:35.782237+00	2026-06-19 06:25:35.782237+00
9	1	BAR-COR-6MM	Varilla corrugada 6mm x 9m	Acero corrugado grado 60, barra de 9 metros	\N	18.50	850	100	t	2026-06-19 06:25:35.950355+00	2026-06-19 06:25:35.950355+00
10	1	BAR-COR-8MM	Varilla corrugada 8mm x 9m	Acero corrugado grado 60, barra de 9 metros	\N	28.90	620	100	t	2026-06-19 06:25:35.950355+00	2026-06-19 06:25:35.950355+00
11	1	BAR-COR-12MM	Varilla corrugada 12mm x 9m	Acero corrugado grado 60, barra de 9 metros	\N	58.00	430	80	t	2026-06-19 06:25:35.950355+00	2026-06-19 06:25:35.950355+00
12	1	BAR-LIS-16MM	Barra lisa 16mm x 6m	Acero liso SAE 1020, barra de 6 metros	\N	42.00	200	50	t	2026-06-19 06:25:35.950355+00	2026-06-19 06:25:35.950355+00
13	2	PER-ANG-2X2	Ángulo 2"x2"x3/16" x 6m	Ángulo de acero A36	\N	55.00	310	60	t	2026-06-19 06:25:35.950355+00	2026-06-19 06:25:35.950355+00
14	2	PER-VIG-4	Viga H 4" x 13lb/pie x 6m	Viga de acero estructural A36	\N	195.00	120	30	t	2026-06-19 06:25:35.950355+00	2026-06-19 06:25:35.950355+00
15	2	PER-CAN-3	Canal C 3" x 5lb/pie x 6m	Canal de acero A36	\N	88.00	180	40	t	2026-06-19 06:25:35.950355+00	2026-06-19 06:25:35.950355+00
16	3	PLA-CAL-2MM	Plancha laminada caliente 2mm	Plancha LAC 1.22m x 2.44m	\N	210.00	95	20	t	2026-06-19 06:25:35.950355+00	2026-06-19 06:25:35.950355+00
17	3	PLA-GAL-1MM	Plancha galvanizada 1mm	Plancha galvanizada 1.22m x 2.44m, Z275	\N	185.00	140	25	t	2026-06-19 06:25:35.950355+00	2026-06-19 06:25:35.950355+00
18	4	TUB-NEG-1	Tubo negro 1" x 6m	Tubo negro ERW ASTM A53	\N	38.00	500	80	t	2026-06-19 06:25:35.950355+00	2026-06-19 06:25:35.950355+00
19	4	TUB-GAL-3_4	Tubo galvanizado 3/4" x 6m	Tubo galvanizado ASTM A53	\N	44.00	380	80	t	2026-06-19 06:25:35.950355+00	2026-06-19 06:25:35.950355+00
20	5	ALA-REC-16	Alambre recocido N°16 x 30kg	Rollo de alambre recocido calibre 16	\N	98.00	220	50	t	2026-06-19 06:25:35.950355+00	2026-06-19 06:25:35.950355+00
21	5	MAL-ELS-15	Malla electrosoldada 15x15cm	Panel 2.4m x 6m, alambre 4mm	\N	145.00	75	20	t	2026-06-19 06:25:35.950355+00	2026-06-19 06:25:35.950355+00
\.


--
-- Data for Name: proveedor; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.proveedor (id, ruc, razon_social, contacto, email, telefono, direccion, activo, created_at, updated_at) FROM stdin;
1	20100070970	Aceros Arequipa S.A.	Javier Salas	ventas@acerosarequipa.com.pe	054-380700	Av. Enrique Meiggs s/n, Parque Industrial, Arequipa	t	2026-06-19 06:25:38.539213+00	2026-06-19 06:25:38.539213+00
2	20100017491	Corporación Aceros Chilca S.A.	María Quispe	mquispe@aceroschi.pe	01-3800900	Carretera Panamericana Sur km 60, Chilca, Lima	t	2026-06-19 06:25:38.539213+00	2026-06-19 06:25:38.539213+00
3	20503480264	Ferreyros S.A.	Luis Pariona	lpariona@ferreyros.com.pe	01-6146000	Av. Argentina 3099, Callao	t	2026-06-19 06:25:38.539213+00	2026-06-19 06:25:38.539213+00
4	20100007641	Sider Perú S.A.	Giuliana Mendez	gmendez@siderperu.com.pe	043-395050	Av. Gálvez Chipoco s/n, Chimbote, Áncash	t	2026-06-19 06:25:38.539213+00	2026-06-19 06:25:38.539213+00
\.


--
-- Data for Name: recepcion_detalle; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.recepcion_detalle (id, recepcion_mercaderia_id, producto_id, cantidad_recibida, created_at) FROM stdin;
1	1	6	50	2026-06-19 06:25:42.5829+00
2	1	7	10	2026-06-19 06:25:42.5829+00
3	1	8	1	2026-06-19 06:25:42.5829+00
\.


--
-- Data for Name: recepcion_mercaderia; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.recepcion_mercaderia (id, orden_compra_id, fecha_recepcion, observaciones, created_at, updated_at) FROM stdin;
1	1	2025-03-04 13:00:00+00	Mercadería recibida conforme, sin observaciones.	2026-06-19 06:25:42.417936+00	2026-06-19 06:25:42.417936+00
\.


--
-- Data for Name: rol; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.rol (id, nombre, descripcion, created_at, updated_at) FROM stdin;
1	admin	Administrador general del sistema	2026-06-19 06:25:36.115624+00	2026-06-19 06:25:36.115624+00
2	gerente	Gerencia — acceso a reportes y aprobaciones	2026-06-19 06:25:36.115624+00	2026-06-19 06:25:36.115624+00
3	vendedor	Gestión de cotizaciones, pedidos y facturación	2026-06-19 06:25:36.115624+00	2026-06-19 06:25:36.115624+00
4	almacenero	Control de stock, recepciones y despachos	2026-06-19 06:25:36.115624+00	2026-06-19 06:25:36.115624+00
5	rrhh	Recursos humanos: empleados, asistencia y planilla	2026-06-19 06:25:36.115624+00	2026-06-19 06:25:36.115624+00
6	cliente	Cliente del portal web	2026-06-19 06:25:36.115624+00	2026-06-19 06:25:36.115624+00
\.


--
-- Data for Name: rol_permiso; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.rol_permiso (rol_id, permiso_id, created_at) FROM stdin;
1	1	2026-06-19 06:25:36.450673+00
1	2	2026-06-19 06:25:36.450673+00
1	3	2026-06-19 06:25:36.450673+00
1	4	2026-06-19 06:25:36.450673+00
1	5	2026-06-19 06:25:36.450673+00
1	6	2026-06-19 06:25:36.450673+00
1	7	2026-06-19 06:25:36.450673+00
1	8	2026-06-19 06:25:36.450673+00
1	9	2026-06-19 06:25:36.450673+00
1	10	2026-06-19 06:25:36.450673+00
1	11	2026-06-19 06:25:36.450673+00
1	12	2026-06-19 06:25:36.450673+00
1	13	2026-06-19 06:25:36.450673+00
1	14	2026-06-19 06:25:36.450673+00
1	15	2026-06-19 06:25:36.450673+00
1	16	2026-06-19 06:25:36.450673+00
1	17	2026-06-19 06:25:36.450673+00
1	18	2026-06-19 06:25:36.450673+00
1	19	2026-06-19 06:25:36.450673+00
1	20	2026-06-19 06:25:36.450673+00
2	1	2026-06-19 06:25:36.62565+00
2	4	2026-06-19 06:25:36.62565+00
2	5	2026-06-19 06:25:36.62565+00
2	8	2026-06-19 06:25:36.62565+00
2	9	2026-06-19 06:25:36.62565+00
2	11	2026-06-19 06:25:36.62565+00
2	14	2026-06-19 06:25:36.62565+00
2	17	2026-06-19 06:25:36.62565+00
2	19	2026-06-19 06:25:36.62565+00
3	1	2026-06-19 06:25:36.791198+00
3	2	2026-06-19 06:25:36.791198+00
3	3	2026-06-19 06:25:36.791198+00
3	5	2026-06-19 06:25:36.791198+00
3	6	2026-06-19 06:25:36.791198+00
3	7	2026-06-19 06:25:36.791198+00
3	8	2026-06-19 06:25:36.791198+00
3	9	2026-06-19 06:25:36.791198+00
4	5	2026-06-19 06:25:36.96365+00
4	7	2026-06-19 06:25:36.96365+00
4	9	2026-06-19 06:25:36.96365+00
4	10	2026-06-19 06:25:36.96365+00
4	11	2026-06-19 06:25:36.96365+00
4	12	2026-06-19 06:25:36.96365+00
4	13	2026-06-19 06:25:36.96365+00
5	14	2026-06-19 06:25:37.205905+00
5	15	2026-06-19 06:25:37.205905+00
5	16	2026-06-19 06:25:37.205905+00
5	17	2026-06-19 06:25:37.205905+00
5	18	2026-06-19 06:25:37.205905+00
6	1	2026-06-19 06:25:37.372236+00
6	2	2026-06-19 06:25:37.372236+00
\.


--
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: sideru_db_user
--

COPY public.usuario (id, rol_id, tipo, username, email, password_hash, activo, ultimo_login, created_at, updated_at) FROM stdin;
1	1	INTERNO	admin	admin@siderurgicaperu.com	$2a$10$R2Svc.PJ15/GYbLHXr74We4/uT4Oo.FRyXw21Ey/yVaopWKiBW2nW	t	\N	2026-06-19 06:25:37.533856+00	2026-06-19 06:25:37.533856+00
2	2	INTERNO	gerente.vargas	gerente@siderurgicaperu.com	$2b$12$HASH_GERE_001	t	\N	2026-06-19 06:25:37.533856+00	2026-06-19 06:25:37.533856+00
3	3	INTERNO	vendedor.luna	vluna@siderurgicaperu.com	$2a$10$15YlWTm1vAAMLsGtQj45xuFngVtd2AozwCl3qjudzT6jjoBT/33FW	t	\N	2026-06-19 06:25:37.533856+00	2026-06-19 06:25:37.533856+00
4	3	INTERNO	vendedor.rios	vrios@siderurgicaperu.com	$2b$12$HASH_VEND_002	t	\N	2026-06-19 06:25:37.533856+00	2026-06-19 06:25:37.533856+00
5	4	INTERNO	almacen.huanca	ahuanca@siderurgicaperu.com	$2a$10$xA8ssFOmy267L2P/5eHzeeuxlGC2L0RKvE2dRLyvCgcMQYk5go8r6	t	\N	2026-06-19 06:25:37.533856+00	2026-06-19 06:25:37.533856+00
6	5	INTERNO	rrhh.mendoza	rmendoza@siderurgicaperu.com	$2b$12$HASH_RRHH_001	t	\N	2026-06-19 06:25:37.533856+00	2026-06-19 06:25:37.533856+00
7	6	CLIENTE	acero_sur	compras@acerosur.com.pe	$2a$10$GB4LsBTGQo4dVC4lNUNWVePNFcTSsB9H9S.CvJAKq3b.9wtzk6Sri	t	\N	2026-06-19 06:25:37.698951+00	2026-06-19 06:25:37.698951+00
8	6	CLIENTE	construcciones	admin@construccionesrm.pe	$2a$10$12YBoiOhIR8nYztvzqs8ge/M633ScKF6Ron2uwelxdrBYbINt.8sW	t	\N	2026-06-19 06:25:37.698951+00	2026-06-19 06:25:37.698951+00
9	6	CLIENTE	silva	jsilva@gmail.com	$2a$10$mxBQoHYDxxp1HOx2AgdOs.lh2nVKSHCRVbqA7IwT9WMOEC7Il0.ou	t	\N	2026-06-19 06:25:37.698951+00	2026-06-19 06:25:37.698951+00
10	6	CLIENTE	ferreteria_jm	fjm@ferreteriajesusm.pe	$2a$10$XBWyCZ17sd7HpjBWP/dakuGGANEudLmfrY7kT/IeAwS0sR47fXjNG	t	\N	2026-06-19 06:25:37.698951+00	2026-06-19 06:25:37.698951+00
11	6	CLIENTE	palacios	rpalacios@outlook.com	$2a$10$TLoldUQeHjEOCIgvjUpA8.3J41G5if5yEy/zCQvyYHYjpCsXgf.Ja	t	\N	2026-06-19 06:25:37.698951+00	2026-06-19 06:25:37.698951+00
\.


--
-- Name: asistencia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.asistencia_id_seq', 28, true);


--
-- Name: cargo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.cargo_id_seq', 7, true);


--
-- Name: categoria_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.categoria_id_seq', 5, true);


--
-- Name: cliente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.cliente_id_seq', 5, true);


--
-- Name: comprobante_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.comprobante_id_seq', 2, true);


--
-- Name: cotizacion_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.cotizacion_detalle_id_seq', 39, true);


--
-- Name: cotizacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.cotizacion_id_seq', 26, true);


--
-- Name: departamento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.departamento_id_seq', 5, true);


--
-- Name: empleado_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.empleado_id_seq', 9, true);


--
-- Name: factura_proveedor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.factura_proveedor_id_seq', 2, true);


--
-- Name: justificacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.justificacion_id_seq', 3, true);


--
-- Name: orden_compra_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.orden_compra_detalle_id_seq', 8, true);


--
-- Name: orden_compra_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.orden_compra_id_seq', 2, true);


--
-- Name: pedido_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.pedido_detalle_id_seq', 8, true);


--
-- Name: pedido_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.pedido_id_seq', 3, true);


--
-- Name: permiso_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.permiso_id_seq', 20, true);


--
-- Name: planilla_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.planilla_detalle_id_seq', 7, true);


--
-- Name: planilla_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.planilla_id_seq', 1, true);


--
-- Name: producto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.producto_id_seq', 21, true);


--
-- Name: proveedor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.proveedor_id_seq', 4, true);


--
-- Name: recepcion_detalle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.recepcion_detalle_id_seq', 3, true);


--
-- Name: recepcion_mercaderia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.recepcion_mercaderia_id_seq', 1, true);


--
-- Name: rol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.rol_id_seq', 6, true);


--
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sideru_db_user
--

SELECT pg_catalog.setval('public.usuario_id_seq', 11, true);


--
-- Name: asistencia asistencia_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.asistencia
    ADD CONSTRAINT asistencia_pkey PRIMARY KEY (id);


--
-- Name: cargo cargo_nombre_key; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.cargo
    ADD CONSTRAINT cargo_nombre_key UNIQUE (nombre);


--
-- Name: cargo cargo_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.cargo
    ADD CONSTRAINT cargo_pkey PRIMARY KEY (id);


--
-- Name: categoria categoria_nombre_key; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_nombre_key UNIQUE (nombre);


--
-- Name: categoria categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id);


--
-- Name: cliente cliente_dni_key; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_dni_key UNIQUE (dni);


--
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id);


--
-- Name: cliente cliente_ruc_key; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_ruc_key UNIQUE (ruc);


--
-- Name: cliente cliente_usuario_id_key; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_usuario_id_key UNIQUE (usuario_id);


--
-- Name: comprobante comprobante_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.comprobante
    ADD CONSTRAINT comprobante_pkey PRIMARY KEY (id);


--
-- Name: comprobante comprobante_serie_numero_key; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.comprobante
    ADD CONSTRAINT comprobante_serie_numero_key UNIQUE (serie, numero);


--
-- Name: cotizacion_detalle cotizacion_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.cotizacion_detalle
    ADD CONSTRAINT cotizacion_detalle_pkey PRIMARY KEY (id);


--
-- Name: cotizacion cotizacion_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.cotizacion
    ADD CONSTRAINT cotizacion_pkey PRIMARY KEY (id);


--
-- Name: departamento departamento_nombre_key; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.departamento
    ADD CONSTRAINT departamento_nombre_key UNIQUE (nombre);


--
-- Name: departamento departamento_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.departamento
    ADD CONSTRAINT departamento_pkey PRIMARY KEY (id);


--
-- Name: empleado empleado_dni_key; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_dni_key UNIQUE (dni);


--
-- Name: empleado empleado_email_key; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_email_key UNIQUE (email);


--
-- Name: empleado empleado_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_pkey PRIMARY KEY (id);


--
-- Name: empleado empleado_usuario_id_key; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_usuario_id_key UNIQUE (usuario_id);


--
-- Name: factura_proveedor factura_proveedor_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.factura_proveedor
    ADD CONSTRAINT factura_proveedor_pkey PRIMARY KEY (id);


--
-- Name: justificacion justificacion_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.justificacion
    ADD CONSTRAINT justificacion_pkey PRIMARY KEY (id);


--
-- Name: orden_compra_detalle orden_compra_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.orden_compra_detalle
    ADD CONSTRAINT orden_compra_detalle_pkey PRIMARY KEY (id);


--
-- Name: orden_compra orden_compra_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.orden_compra
    ADD CONSTRAINT orden_compra_pkey PRIMARY KEY (id);


--
-- Name: pedido pedido_cotizacion_id_key; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_cotizacion_id_key UNIQUE (cotizacion_id);


--
-- Name: pedido_detalle pedido_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.pedido_detalle
    ADD CONSTRAINT pedido_detalle_pkey PRIMARY KEY (id);


--
-- Name: pedido pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_pkey PRIMARY KEY (id);


--
-- Name: permiso permiso_codigo_key; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.permiso
    ADD CONSTRAINT permiso_codigo_key UNIQUE (codigo);


--
-- Name: permiso permiso_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.permiso
    ADD CONSTRAINT permiso_pkey PRIMARY KEY (id);


--
-- Name: planilla_detalle planilla_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.planilla_detalle
    ADD CONSTRAINT planilla_detalle_pkey PRIMARY KEY (id);


--
-- Name: planilla planilla_periodo_key; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.planilla
    ADD CONSTRAINT planilla_periodo_key UNIQUE (periodo);


--
-- Name: planilla planilla_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.planilla
    ADD CONSTRAINT planilla_pkey PRIMARY KEY (id);


--
-- Name: producto producto_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (id);


--
-- Name: producto producto_sku_key; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_sku_key UNIQUE (sku);


--
-- Name: proveedor proveedor_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_pkey PRIMARY KEY (id);


--
-- Name: proveedor proveedor_ruc_key; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_ruc_key UNIQUE (ruc);


--
-- Name: recepcion_detalle recepcion_detalle_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.recepcion_detalle
    ADD CONSTRAINT recepcion_detalle_pkey PRIMARY KEY (id);


--
-- Name: recepcion_mercaderia recepcion_mercaderia_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.recepcion_mercaderia
    ADD CONSTRAINT recepcion_mercaderia_pkey PRIMARY KEY (id);


--
-- Name: rol rol_nombre_key; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_nombre_key UNIQUE (nombre);


--
-- Name: rol_permiso rol_permiso_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.rol_permiso
    ADD CONSTRAINT rol_permiso_pkey PRIMARY KEY (rol_id, permiso_id);


--
-- Name: rol rol_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (id);


--
-- Name: usuario usuario_email_key; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_email_key UNIQUE (email);


--
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- Name: usuario usuario_username_key; Type: CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_username_key UNIQUE (username);


--
-- Name: idx_asistencia_empleado_fecha; Type: INDEX; Schema: public; Owner: sideru_db_user
--

CREATE INDEX idx_asistencia_empleado_fecha ON public.asistencia USING btree (empleado_id, fecha);


--
-- Name: idx_cliente_usuario; Type: INDEX; Schema: public; Owner: sideru_db_user
--

CREATE INDEX idx_cliente_usuario ON public.cliente USING btree (usuario_id);


--
-- Name: idx_comprobante_created_at; Type: INDEX; Schema: public; Owner: sideru_db_user
--

CREATE INDEX idx_comprobante_created_at ON public.comprobante USING btree (created_at);


--
-- Name: idx_comprobante_pedido; Type: INDEX; Schema: public; Owner: sideru_db_user
--

CREATE INDEX idx_comprobante_pedido ON public.comprobante USING btree (pedido_id);


--
-- Name: idx_cotizacion_cliente; Type: INDEX; Schema: public; Owner: sideru_db_user
--

CREATE INDEX idx_cotizacion_cliente ON public.cotizacion USING btree (cliente_id);


--
-- Name: idx_cotizacion_estado; Type: INDEX; Schema: public; Owner: sideru_db_user
--

CREATE INDEX idx_cotizacion_estado ON public.cotizacion USING btree (estado);


--
-- Name: idx_empleado_usuario; Type: INDEX; Schema: public; Owner: sideru_db_user
--

CREATE INDEX idx_empleado_usuario ON public.empleado USING btree (usuario_id);


--
-- Name: idx_justificacion_empleado; Type: INDEX; Schema: public; Owner: sideru_db_user
--

CREATE INDEX idx_justificacion_empleado ON public.justificacion USING btree (empleado_id);


--
-- Name: idx_orden_compra_created_at; Type: INDEX; Schema: public; Owner: sideru_db_user
--

CREATE INDEX idx_orden_compra_created_at ON public.orden_compra USING btree (created_at);


--
-- Name: idx_orden_compra_estado; Type: INDEX; Schema: public; Owner: sideru_db_user
--

CREATE INDEX idx_orden_compra_estado ON public.orden_compra USING btree (estado);


--
-- Name: idx_orden_compra_proveedor; Type: INDEX; Schema: public; Owner: sideru_db_user
--

CREATE INDEX idx_orden_compra_proveedor ON public.orden_compra USING btree (proveedor_id);


--
-- Name: idx_pedido_cliente; Type: INDEX; Schema: public; Owner: sideru_db_user
--

CREATE INDEX idx_pedido_cliente ON public.pedido USING btree (cliente_id);


--
-- Name: idx_pedido_created_at; Type: INDEX; Schema: public; Owner: sideru_db_user
--

CREATE INDEX idx_pedido_created_at ON public.pedido USING btree (created_at);


--
-- Name: idx_pedido_estado; Type: INDEX; Schema: public; Owner: sideru_db_user
--

CREATE INDEX idx_pedido_estado ON public.pedido USING btree (estado);


--
-- Name: idx_planilla_detalle_created_at; Type: INDEX; Schema: public; Owner: sideru_db_user
--

CREATE INDEX idx_planilla_detalle_created_at ON public.planilla_detalle USING btree (created_at);


--
-- Name: idx_planilla_detalle_empleado; Type: INDEX; Schema: public; Owner: sideru_db_user
--

CREATE INDEX idx_planilla_detalle_empleado ON public.planilla_detalle USING btree (empleado_id);


--
-- Name: idx_planilla_detalle_planilla; Type: INDEX; Schema: public; Owner: sideru_db_user
--

CREATE INDEX idx_planilla_detalle_planilla ON public.planilla_detalle USING btree (planilla_id);


--
-- Name: idx_usuario_rol; Type: INDEX; Schema: public; Owner: sideru_db_user
--

CREATE INDEX idx_usuario_rol ON public.usuario USING btree (rol_id);


--
-- Name: asistencia asistencia_empleado_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.asistencia
    ADD CONSTRAINT asistencia_empleado_id_fkey FOREIGN KEY (empleado_id) REFERENCES public.empleado(id);


--
-- Name: cliente cliente_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- Name: comprobante comprobante_pedido_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.comprobante
    ADD CONSTRAINT comprobante_pedido_id_fkey FOREIGN KEY (pedido_id) REFERENCES public.pedido(id);


--
-- Name: cotizacion cotizacion_cliente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.cotizacion
    ADD CONSTRAINT cotizacion_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.cliente(id);


--
-- Name: cotizacion_detalle cotizacion_detalle_cotizacion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.cotizacion_detalle
    ADD CONSTRAINT cotizacion_detalle_cotizacion_id_fkey FOREIGN KEY (cotizacion_id) REFERENCES public.cotizacion(id);


--
-- Name: cotizacion_detalle cotizacion_detalle_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.cotizacion_detalle
    ADD CONSTRAINT cotizacion_detalle_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.producto(id);


--
-- Name: empleado empleado_cargo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_cargo_id_fkey FOREIGN KEY (cargo_id) REFERENCES public.cargo(id);


--
-- Name: empleado empleado_departamento_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_departamento_id_fkey FOREIGN KEY (departamento_id) REFERENCES public.departamento(id);


--
-- Name: empleado empleado_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- Name: factura_proveedor factura_proveedor_orden_compra_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.factura_proveedor
    ADD CONSTRAINT factura_proveedor_orden_compra_id_fkey FOREIGN KEY (orden_compra_id) REFERENCES public.orden_compra(id);


--
-- Name: justificacion justificacion_empleado_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.justificacion
    ADD CONSTRAINT justificacion_empleado_id_fkey FOREIGN KEY (empleado_id) REFERENCES public.empleado(id);


--
-- Name: justificacion justificacion_revisado_por_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.justificacion
    ADD CONSTRAINT justificacion_revisado_por_fkey FOREIGN KEY (revisado_por) REFERENCES public.empleado(id);


--
-- Name: orden_compra_detalle orden_compra_detalle_orden_compra_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.orden_compra_detalle
    ADD CONSTRAINT orden_compra_detalle_orden_compra_id_fkey FOREIGN KEY (orden_compra_id) REFERENCES public.orden_compra(id);


--
-- Name: orden_compra_detalle orden_compra_detalle_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.orden_compra_detalle
    ADD CONSTRAINT orden_compra_detalle_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.producto(id);


--
-- Name: orden_compra orden_compra_proveedor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.orden_compra
    ADD CONSTRAINT orden_compra_proveedor_id_fkey FOREIGN KEY (proveedor_id) REFERENCES public.proveedor(id);


--
-- Name: pedido pedido_cliente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.cliente(id);


--
-- Name: pedido pedido_cotizacion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_cotizacion_id_fkey FOREIGN KEY (cotizacion_id) REFERENCES public.cotizacion(id);


--
-- Name: pedido_detalle pedido_detalle_pedido_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.pedido_detalle
    ADD CONSTRAINT pedido_detalle_pedido_id_fkey FOREIGN KEY (pedido_id) REFERENCES public.pedido(id);


--
-- Name: pedido_detalle pedido_detalle_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.pedido_detalle
    ADD CONSTRAINT pedido_detalle_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.producto(id);


--
-- Name: planilla_detalle planilla_detalle_empleado_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.planilla_detalle
    ADD CONSTRAINT planilla_detalle_empleado_id_fkey FOREIGN KEY (empleado_id) REFERENCES public.empleado(id);


--
-- Name: planilla_detalle planilla_detalle_planilla_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.planilla_detalle
    ADD CONSTRAINT planilla_detalle_planilla_id_fkey FOREIGN KEY (planilla_id) REFERENCES public.planilla(id);


--
-- Name: planilla planilla_procesado_por_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.planilla
    ADD CONSTRAINT planilla_procesado_por_fkey FOREIGN KEY (procesado_por) REFERENCES public.empleado(id);


--
-- Name: producto producto_categoria_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_categoria_id_fkey FOREIGN KEY (categoria_id) REFERENCES public.categoria(id);


--
-- Name: recepcion_detalle recepcion_detalle_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.recepcion_detalle
    ADD CONSTRAINT recepcion_detalle_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.producto(id);


--
-- Name: recepcion_detalle recepcion_detalle_recepcion_mercaderia_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.recepcion_detalle
    ADD CONSTRAINT recepcion_detalle_recepcion_mercaderia_id_fkey FOREIGN KEY (recepcion_mercaderia_id) REFERENCES public.recepcion_mercaderia(id);


--
-- Name: recepcion_mercaderia recepcion_mercaderia_orden_compra_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.recepcion_mercaderia
    ADD CONSTRAINT recepcion_mercaderia_orden_compra_id_fkey FOREIGN KEY (orden_compra_id) REFERENCES public.orden_compra(id);


--
-- Name: rol_permiso rol_permiso_permiso_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.rol_permiso
    ADD CONSTRAINT rol_permiso_permiso_id_fkey FOREIGN KEY (permiso_id) REFERENCES public.permiso(id);


--
-- Name: rol_permiso rol_permiso_rol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.rol_permiso
    ADD CONSTRAINT rol_permiso_rol_id_fkey FOREIGN KEY (rol_id) REFERENCES public.rol(id);


--
-- Name: usuario usuario_rol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sideru_db_user
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_rol_id_fkey FOREIGN KEY (rol_id) REFERENCES public.rol(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: sideru_db_user
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON SEQUENCES TO sideru_db_user;


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TYPES TO sideru_db_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON FUNCTIONS TO sideru_db_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres GRANT ALL ON TABLES TO sideru_db_user;


--
-- PostgreSQL database dump complete
--

\unrestrict Q7PGIxL4gXzr56FLgud1OcWp3IQi6ubz9hPpgvewlQtq5s9hqYUUC8oyQOixfFl

