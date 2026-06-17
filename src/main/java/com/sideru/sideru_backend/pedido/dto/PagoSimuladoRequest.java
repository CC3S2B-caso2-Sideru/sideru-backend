package com.sideru.sideru_backend.pedido.dto;

import jakarta.validation.constraints.Size;

public record PagoSimuladoRequest(
        @Size(max = 50)
        String metodoPago,
        @Size(max = 100)
        String referencia
) {
}
