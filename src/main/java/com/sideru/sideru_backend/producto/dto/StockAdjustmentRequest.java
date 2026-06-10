package com.sideru.sideru_backend.producto.dto;

import jakarta.validation.constraints.NotNull;

public record StockAdjustmentRequest(@NotNull Integer cantidad) {}
