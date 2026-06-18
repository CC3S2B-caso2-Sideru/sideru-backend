package com.sideru.sideru_backend.pedido;

import com.sideru.sideru_backend.pedido.entity.Pedido;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PedidoRepository extends JpaRepository<Pedido, Integer> {
    boolean existsByCotizacionId(Integer cotizacionId);
    List<Pedido> findAllByClienteIdOrderByFechaPedidoDesc(Integer clienteId);
    List<Pedido> findAllByOrderByFechaPedidoDesc();
}
