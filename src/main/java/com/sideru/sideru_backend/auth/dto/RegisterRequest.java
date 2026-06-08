package com.sideru.sideru_backend.auth.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.sideru.sideru_backend.cliente.dto.ClienteCreate;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class RegisterRequest {
    @NotBlank
    private String username;
    @NotBlank
    private String password;

    @NotBlank
    private String email;

    @JsonProperty("persona")
    private ClienteCreate clienteCreate;
}
