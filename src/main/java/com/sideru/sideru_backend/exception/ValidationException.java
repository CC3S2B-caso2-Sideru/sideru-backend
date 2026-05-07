package com.sideru.sideru_backend.exception;

public class ValidationException extends AppException {
    public ValidationException(String message) {
        super(message, "VALIDATION_ERROR", 400);
    }
}
