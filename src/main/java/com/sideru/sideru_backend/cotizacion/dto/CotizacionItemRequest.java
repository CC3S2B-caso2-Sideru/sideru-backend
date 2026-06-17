package com.sideru.sideru_backend.cotizacion.dto;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record CotizacionItemRequest(
    @NotBlank String sku,
    @NotNull @Min(1) Integer cantidad
) {}