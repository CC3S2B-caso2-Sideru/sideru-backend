package com.sideru.sideru_backend.reporte;

import com.sideru.sideru_backend.reporte.dto.*;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/reportes")
@RequiredArgsConstructor
@Tag(name = "Reportes", description = "Endpoints de reportes y gráficos del dashboard")
public class ReporteController {

    private final ReporteService reporteService;

    @GetMapping("/cotizaciones-por-estado")
    @PreAuthorize("hasAuthority('reporte.ver')")
    @Operation(summary = "Cantidad de cotizaciones agrupadas por estado")
    public ResponseEntity<List<ReporteEstado>> cotizacionesPorEstado() {
        return ResponseEntity.ok(reporteService.cotizacionesPorEstado());
    }

    @GetMapping("/cotizaciones-por-mes")
    @PreAuthorize("hasAuthority('reporte.ver')")
    @Operation(summary = "Cantidad de cotizaciones por mes (últimos N meses)")
    public ResponseEntity<List<ReporteMensual>> cotizacionesPorMes(
            @RequestParam(defaultValue = "6") int meses) {
        return ResponseEntity.ok(reporteService.cotizacionesPorMes(meses));
    }

    @GetMapping("/ingreso-real-vs-potencial")
    @PreAuthorize("hasAuthority('reporte.ver')")
    @Operation(summary = "Ingreso de cotizaciones aceptadas vs potencial perdido por rechazadas")
    public ResponseEntity<ReporteIngresoRealVsPotencialResponse> ingresoRealVsPotencial(
            @RequestParam(defaultValue = "6") int meses) {
        return ResponseEntity.ok(reporteService.ingresoRealVsPotencial(meses));
    }

    @GetMapping("/productos-mas-cotizados")
    @PreAuthorize("hasAuthority('reporte.ver')")
    @Operation(summary = "Top N productos más solicitados en cotizaciones")
    public ResponseEntity<List<ReporteProductoMasCotizado>> productosMasCotizados(
            @RequestParam(defaultValue = "5") int top) {
        return ResponseEntity.ok(reporteService.productosMasCotizados(top));
    }
}
