package com.sideru.sideru_backend.cotizacion.entity;

public enum EstadoCotizacion {
    borrador,
    enviada,
    aceptada,
    rechazada,
    expirada;

    public static EstadoCotizacion fromString(String value) {
        if (value == null) return null;
        return EstadoCotizacion.valueOf(value.toLowerCase());
    }
}
