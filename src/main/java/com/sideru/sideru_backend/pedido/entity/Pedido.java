package com.sideru.sideru_backend.pedido.entity;

import com.sideru.sideru_backend.cliente.Cliente;
import com.sideru.sideru_backend.cotizacion.entity.Cotizacion;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "pedido")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@EntityListeners(AuditingEntityListener.class)
public class Pedido {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cotizacion_id", nullable = false)
    private Cotizacion cotizacion;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "cliente_id", nullable = false)
    private Cliente cliente;

    @Column(name = "fecha_pedido", nullable = false, updatable = false)
    private OffsetDateTime fechaPedido;

    @Enumerated(EnumType.STRING)
    @JdbcTypeCode(SqlTypes.NAMED_ENUM)
    @Column(name = "estado", nullable = false)
    private EstadoPedido estado;

    @Column(name = "motivo_rechazo", columnDefinition = "TEXT")
    private String motivoRechazo;

    @Column(name = "total", nullable = false)
    private BigDecimal total;

    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @LastModifiedDate
    @Column(name = "updated_at", nullable = false)
    private Instant updatedAt;

    @OneToMany(mappedBy = "pedido", cascade = CascadeType.ALL, orphanRemoval = true)
    @Builder.Default
    private List<PedidoDetalle> detalles = new ArrayList<>();

    @PrePersist
    protected void onCreate() {
        if (fechaPedido == null) {
            fechaPedido = OffsetDateTime.now();
        }
        if (estado == null) {
            estado = EstadoPedido.pendiente;
        }
    }
}
