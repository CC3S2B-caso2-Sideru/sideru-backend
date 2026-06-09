package com.sideru.sideru_backend.cotizacion;

import com.sideru.sideru_backend.cotizacion.entity.Cotizacion;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CotizacionRepository extends JpaRepository<Cotizacion, Integer> {
    List<Cotizacion> findAllByClienteIdOrderByFechaEmisionDesc(Integer clienteId);
    List<Cotizacion> findAllByOrderByFechaEmisionDesc();
}