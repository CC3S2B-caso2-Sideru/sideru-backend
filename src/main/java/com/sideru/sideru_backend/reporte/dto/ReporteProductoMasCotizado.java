package com.sideru.sideru_backend.reporte.dto;

import java.math.BigDecimal;

public record ReporteProductoMasCotizado(
    String sku,
    String nombre,
    Long cantidadTotal
) {}
