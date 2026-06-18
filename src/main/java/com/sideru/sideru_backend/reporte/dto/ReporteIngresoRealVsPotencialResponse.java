package com.sideru.sideru_backend.reporte.dto;

import java.math.BigDecimal;
import java.util.List;

public record ReporteIngresoRealVsPotencialResponse(
    List<IngresoMensual> porMes,
    BigDecimal totalAceptado,
    BigDecimal totalRechazado
) {
    public record IngresoMensual(
        String mes,
        BigDecimal aceptado,
        BigDecimal rechazado
    ) {}
}
