package com.sideru.sideru_backend.producto.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;

import java.math.BigDecimal;

public record ProductoRequest(
    @NotBlank String sku,
    @NotBlank String nombre,
    String descripcion,
    String imagen,
    @NotNull @Positive BigDecimal precio,
    @NotNull @PositiveOrZero Integer stock,
    @PositiveOrZero Integer stockMinimo,
    @NotNull Integer categoriaId
) {}
