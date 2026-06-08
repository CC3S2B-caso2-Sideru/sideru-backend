package com.sideru.sideru_backend.exception;

public class DuplicateResourceException extends AppException {
    public DuplicateResourceException(String resource, String field, String value) {
        super(
                String.format("%s con %s '%s' ya existe", resource, field, value),
                "DUPLICATE_RESOURCE",
                409
        );
    }

    public DuplicateResourceException(String resource) {
        super(
                String.format("%s ya existe", resource),
                "DUPLICATE_RESOURCE",
                409
        );
    }
}
