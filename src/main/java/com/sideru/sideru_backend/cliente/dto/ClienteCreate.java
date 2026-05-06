package com.sideru.sideru_backend.cliente.dto;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ClienteCreate {
    @Size(min = 8, max = 8)
    private String dni;

    @Size(min = 11, max = 11)
    private String ruc;

    @Size(max = 200)
    private String razonSocial;

    @NotBlank
    @Size(max = 100)
    private String nombre;

    @Size(max = 100)
    private String apellido;

    @Size(max = 20)
    private String telefono;

    private String direccion;

    @AssertTrue(message = "Debe proporcionar dni o ruc")
    public boolean isDocumentoValido() {
        return (dni != null && !dni.isBlank()) ||
                (ruc != null && !ruc.isBlank());
    }
}
