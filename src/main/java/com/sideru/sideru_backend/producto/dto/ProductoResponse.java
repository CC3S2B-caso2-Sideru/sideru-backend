package com.sideru.sideru_backend.producto.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.math.BigDecimal;

public record ProductoResponse(
        String sku,
        String nombre,
        String imagen,
        BigDecimal precio,
        @JsonProperty("stock")
        Integer StockMinimo
) {
}
