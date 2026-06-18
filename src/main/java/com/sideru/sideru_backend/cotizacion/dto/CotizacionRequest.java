package com.sideru.sideru_backend.cotizacion.dto;

import jakarta.validation.constraints.NotEmpty;
import java.util.List;

public record CotizacionRequest(
    String observaciones,
    // Evita que la lista venga vacía o nula
    @NotEmpty List<CotizacionItemRequest> items
) {}