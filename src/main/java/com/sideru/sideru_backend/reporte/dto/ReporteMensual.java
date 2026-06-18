package com.sideru.sideru_backend.reporte.dto;

import java.math.BigDecimal;

public record ReporteMensual(
    String mes,
    Long cantidad
) {}
