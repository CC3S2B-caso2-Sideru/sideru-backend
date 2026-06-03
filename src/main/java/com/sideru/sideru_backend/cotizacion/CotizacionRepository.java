package com.sideru.sideru_backend.cotizacion.repository;
import com.sideru.sideru_backend.cotizacion.entity.Cotizacion;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CotizacionRepository extends JpaRepository<Cotizacion, Integer>{
    // listar solicitudes en orden cronológico para el cliente
    //SELECT * FROM cotizacion WHERE cliente_id = ? ORDER BY fecha_emision DESC
    List<Cotizacion> findAllByClienteIdOrderByFechaEmisionDesc(Integer clienteId);
}