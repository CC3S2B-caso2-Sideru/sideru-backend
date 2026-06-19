package com.sideru.sideru_backend.pedido;

import com.sideru.sideru_backend.pedido.entity.Pedido;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface PedidoRepository extends JpaRepository<Pedido, Integer> {
    boolean existsByCotizacionId(Integer cotizacionId);
    Optional<Pedido> findByCotizacionId(Integer cotizacionId);
    List<Pedido> findAllByClienteIdOrderByFechaPedidoDesc(Integer clienteId);
    List<Pedido> findAllByOrderByFechaPedidoDesc();
}
