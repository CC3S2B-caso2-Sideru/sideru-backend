package com.sideru.sideru_backend.reporte;

import com.sideru.sideru_backend.cotizacion.CotizacionRepository;
import com.sideru.sideru_backend.reporte.dto.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ReporteService {

    private final CotizacionRepository cotizacionRepository;

    @Transactional(readOnly = true)
    public List<ReporteEstado> cotizacionesPorEstado() {
        List<Object[]> raw = cotizacionRepository.countByEstadoRaw();
        return raw.stream()
                .map(row -> new ReporteEstado((String) row[0], ((Number) row[1]).longValue()))
                .toList();
    }

    @Transactional(readOnly = true)
    public List<ReporteMensual> cotizacionesPorMes(int meses) {
        List<Object[]> raw = cotizacionRepository.countByMonthRaw(meses);
        return raw.stream()
                .map(row -> new ReporteMensual((String) row[0], ((Number) row[1]).longValue()))
                .toList();
    }

    @Transactional(readOnly = true)
    public ReporteIngresoRealVsPotencialResponse ingresoRealVsPotencial(int meses) {
        List<Object[]> raw = cotizacionRepository.findIngresoRealVsPotencialRaw(meses);
        List<ReporteIngresoRealVsPotencialResponse.IngresoMensual> porMes = new ArrayList<>();

        for (Object[] row : raw) {
            String mes = (String) row[0];
            BigDecimal aceptado = (BigDecimal) row[1];
            BigDecimal rechazado = (BigDecimal) row[2];
            porMes.add(new ReporteIngresoRealVsPotencialResponse.IngresoMensual(mes, aceptado, rechazado));
        }

        BigDecimal totalAceptado = cotizacionRepository.sumTotalAceptadas(meses);
        BigDecimal totalRechazado = cotizacionRepository.sumTotalRechazadas(meses);

        return new ReporteIngresoRealVsPotencialResponse(porMes, totalAceptado, totalRechazado);
    }

    @Transactional(readOnly = true)
    public List<ReporteProductoMasCotizado> productosMasCotizados(int top) {
        List<Object[]> raw = cotizacionRepository.findProductosMasCotizadosRaw(top);
        return raw.stream()
                .map(row -> new ReporteProductoMasCotizado(
                        (String) row[0],
                        (String) row[1],
                        ((Number) row[2]).longValue()
                ))
                .toList();
    }
}
