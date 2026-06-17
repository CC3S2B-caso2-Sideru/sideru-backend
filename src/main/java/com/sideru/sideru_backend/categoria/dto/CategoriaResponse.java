package com.sideru.sideru_backend.categoria.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.math.BigDecimal;

public record CategoriaResponse(
        Integer id,
        String nombre
) {
}
