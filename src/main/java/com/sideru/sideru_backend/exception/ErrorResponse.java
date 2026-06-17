package com.sideru.sideru_backend.exception;

import lombok.Builder;
import lombok.Data;

import java.util.Map;

@Data
@Builder
public class ErrorResponse {
    private String code;
    private String message;
    private long timestamp;
    private String path;
    private Map<String, String> details; // Para errores de validación
}
