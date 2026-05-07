package com.sideru.sideru_backend.exception;

public class AppException extends RuntimeException {
    private final String code;
    private final int httpStatus;

    public AppException(String message, String code, int httpStatus) {
        super(message);
        this.code = code;
        this.httpStatus = httpStatus;
    }

    public String getCode() { return code; }
    public int getHttpStatus() { return httpStatus; }
}
