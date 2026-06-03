package com.sideru.sideru_backend.cotizacion.entity;

import com.sideru.sideru_backend.cliente.Cliente;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "cotizacion")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Cotizacion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cliente_id", nullable = false)
    private Cliente cliente;

    @Column(name = "fecha_emision", nullable = false, updatable = false)
    private OffsetDateTime fechaEmision;

    @Column(name = "fecha_expiracion", nullable = false)
    private LocalDate fechaExpiracion;

    @Enumerated(EnumType.STRING)
    @Column(name = "estado", nullable = false)
    private EstadoCotizacion estado;

    @Column(name = "observaciones", columnDefinition = "TEXT")
    private String observaciones;

    @Column(name = "subtotal", nullable = false)
    private BigDecimal subtotal;

    @Column(name = "descuento_total", nullable = false)
    private BigDecimal descuentoTotal;

    @Column(name = "igv", nullable = false)
    private BigDecimal igv;

    @Column(name = "total", nullable = false)
    private BigDecimal total;

    @Column(name = "created_at", nullable = false, updatable = false)
    private OffsetDateTime createdAt;

    @Column(name = "updated_at", nullable = false)
    private OffsetDateTime updatedAt;

    @OneToMany(mappedBy = "cotizacion", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<CotizacionDetalle> detalles = new ArrayList<>();

    @PrePersist
    protected void onCreate() {
        createdAt = OffsetDateTime.now();
        updatedAt = OffsetDateTime.now();
        fechaEmision = OffsetDateTime.now();
        if (descuentoTotal == null) {
            descuentoTotal = BigDecimal.ZERO;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = OffsetDateTime.now();
    }
}
