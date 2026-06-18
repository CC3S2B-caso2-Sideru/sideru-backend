package com.sideru.sideru_backend.reporte.dto;

import java.math.BigDecimal;
import java.util.List;

public record ReporteEstado(
    String estado,
    Long total
) {}
