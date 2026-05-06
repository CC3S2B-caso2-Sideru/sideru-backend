package com.sideru.sideru_backend.usuario;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;

import java.time.Instant;

//id            SERIAL PRIMARY KEY,
//rol_id        INT          NOT NULL,
//tipo          tipo_usuario NOT NULL,
//username      VARCHAR(60)  NOT NULL UNIQUE,
//email         VARCHAR(150) NOT NULL UNIQUE,
//password_hash TEXT         NOT NULL,
//activo        BOOLEAN               DEFAULT TRUE,
//ultimo_login  TIMESTAMPTZ,
//    -- auditoría
//created_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
//updated_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
//
//FOREIGN KEY (rol_id) REFERENCES rol (id)
@Entity
@Table(name = "usuario")
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Usuario {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // Si es ENUM: @Enumerated(EnumType.STRING) @Column(nullable = false)
    @Column(name = "tipo", nullable = false)
    private String tipoUsuario;

    @Column(name = "username", nullable = false, length = 60, unique = true)
    private String username;

    @Column(name = "email", nullable = false, length = 150, unique = true)
    private String email;

    @Column(name = "password_hash", nullable = false, columnDefinition = "TEXT")
    private String passwordHash;

    @Column(name = "activo", nullable = false)
    @Builder.Default
    private Boolean activo = true;

    @Column(name = "ultimo_login")
    private Instant ultimoLogin;

    // Relación con tabla rol
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "rol_id", nullable = false)
    private Rol rol;

    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @LastModifiedDate
    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;
}
