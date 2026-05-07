package com.sideru.sideru_backend.exception;

public class ResourceNotFoundException extends AppException {
    public ResourceNotFoundException(String resource, String id) {
        super(
                String.format("%s no encontrado: %s", resource, id),
                "RESOURCE_NOT_FOUND",
                404
        );
    }

    public ResourceNotFoundException(String resource) {
        super(
                String.format("%s no encontrado", resource),
                "RESOURCE_NOT_FOUND",
                404
        );
    }
}
