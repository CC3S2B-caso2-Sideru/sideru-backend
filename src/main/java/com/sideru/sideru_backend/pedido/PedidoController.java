package com.sideru.sideru_backend.pedido;

import com.sideru.sideru_backend.pedido.dto.PagoSimuladoRequest;
import com.sideru.sideru_backend.pedido.dto.PedidoResponse;
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
@RequestMapping("/pedidos")
@RequiredArgsConstructor
@Tag(name = "Pedidos", description = "Operaciones para pedidos generados desde cotizaciones aceptadas")
public class PedidoController {

    private final PedidoService pedidoService;

    @PostMapping("/desde-cotizacion/{cotizacionId}")
    @PreAuthorize("hasAuthority('cotizacion.aprobar')")
    @Operation(summary = "Generar pedido desde una cotizacion aceptada")
    public ResponseEntity<PedidoResponse> crearDesdeCotizacion(@PathVariable Integer cotizacionId) {
        PedidoResponse response = pedidoService.crearDesdeCotizacion(cotizacionId);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/mis-pedidos")
    @PreAuthorize("hasAuthority('cotizacion.ver')")
    @Operation(summary = "Obtener pedidos del cliente logueado")
    public ResponseEntity<List<PedidoResponse>> listarMisPedidos(
            @AuthenticationPrincipal UsuarioDetails userDetails
    ) {
        return ResponseEntity.ok(pedidoService.listarMisPedidos(userDetails.getUsuario()));
    }

    @GetMapping("/admin/todos")
    @PreAuthorize("hasAuthority('cotizacion.ver')")
    @Operation(summary = "Listar todos los pedidos")
    public ResponseEntity<List<PedidoResponse>> listarTodos() {
        return ResponseEntity.ok(pedidoService.listarTodos());
    }

    @PatchMapping("/{id}/registrar-pago")
    @PreAuthorize("hasAuthority('cotizacion.crear')")
    @Operation(summary = "Registrar pago simulado de un pedido")
    public ResponseEntity<PedidoResponse> registrarPagoSimulado(
            @PathVariable Integer id,
            @Valid @RequestBody(required = false) PagoSimuladoRequest request,
            @AuthenticationPrincipal UsuarioDetails userDetails
    ) {
        PagoSimuladoRequest safeRequest = request != null ? request : new PagoSimuladoRequest(null, null);
        return ResponseEntity.ok(pedidoService.registrarPagoSimulado(id, safeRequest, userDetails.getUsuario()));
    }
}
