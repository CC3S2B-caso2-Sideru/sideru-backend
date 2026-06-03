package com.sideru.sideru_backend.cotizacion;

import com.sideru.sideru_backend.cotizacion.dto.CotizacionRequest;
import com.sideru.sideru_backend.cotizacion.dto.CotizacionResponse;
import com.sideru.sideru_backend.security.UsuarioDetails;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/cotizaciones")
@RequiredArgsConstructor
@Tag(name = "Cotizaciones", description = "Operaciones para la solicitud de cotizaciones")
public class CotizacionController {

    private final CotizacionService cotizacionService;

    @PostMapping
    @PreAuthorize("hasAuthority('cotizacion.crear')")
    @Operation(summary = "Crear una nueva solicitud de cotización")
    public ResponseEntity<CotizacionResponse> crear(
            @Valid @RequestBody CotizacionRequest request,
            @AuthenticationPrincipal UsuarioDetails userDetails
    ) {
        CotizacionResponse response = cotizacionService.crearCotizacion(request, userDetails.getUsuario());
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/mis-cotizaciones")
    @PreAuthorize("hasAuthority('cotizacion.ver')")
    @Operation(summary = "Obtener el historial de cotizaciones del cliente logueado")
    public ResponseEntity<List<CotizacionResponse>> listarMisCotizaciones(
            @AuthenticationPrincipal UsuarioDetails userDetails
    ) {
        List<CotizacionResponse> response = cotizacionService.listarMisCotizaciones(userDetails.getUsuario());
        return ResponseEntity.ok(response);
    }
}