package com.sideru.sideru_backend.producto.dto;

import java.math.BigDecimal;

public record ProductoAdminResponse(
    Integer id,
    String sku,
    String nombre,
    String descripcion,
    String imagen,
    BigDecimal precio,
    Integer stock,
    Integer stockMinimo,
    Boolean activo,
    String categoria
) {}
