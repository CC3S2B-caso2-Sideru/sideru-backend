package com.sideru.sideru_backend.cotizacion;

import com.sideru.sideru_backend.cotizacion.entity.Cotizacion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;
import java.util.List;

public interface CotizacionRepository extends JpaRepository<Cotizacion, Integer> {
    List<Cotizacion> findAllByClienteIdOrderByFechaEmisionDesc(Integer clienteId);
    List<Cotizacion> findAllByOrderByFechaEmisionDesc();

    @Query(value = """
            SELECT CAST(c.estado AS text), COUNT(*)
            FROM cotizacion c
            GROUP BY c.estado
            ORDER BY COUNT(*) DESC
            """, nativeQuery = true)
    List<Object[]> countByEstadoRaw();

    @Query(value = """
            SELECT TO_CHAR(c.fecha_emision, 'Mon'), COUNT(*)
            FROM cotizacion c
            WHERE c.fecha_emision >= CURRENT_DATE - (:meses || ' months')::INTERVAL
            GROUP BY TO_CHAR(c.fecha_emision, 'Mon'), TO_CHAR(c.fecha_emision, 'MM')
            ORDER BY TO_CHAR(c.fecha_emision, 'MM')
            """, nativeQuery = true)
    List<Object[]> countByMonthRaw(@Param("meses") int meses);

    @Query(value = """
            SELECT
                TO_CHAR(c.fecha_emision, 'Mon'),
                COALESCE(SUM(CASE WHEN c.estado = 'aceptada' THEN c.total ELSE 0 END), 0),
                COALESCE(SUM(CASE WHEN c.estado = 'rechazada' THEN c.total ELSE 0 END), 0)
            FROM cotizacion c
            WHERE c.fecha_emision >= CURRENT_DATE - (:meses || ' months')::INTERVAL
            GROUP BY TO_CHAR(c.fecha_emision, 'Mon'), TO_CHAR(c.fecha_emision, 'MM')
            ORDER BY TO_CHAR(c.fecha_emision, 'MM')
            """, nativeQuery = true)
    List<Object[]> findIngresoRealVsPotencialRaw(@Param("meses") int meses);

    @Query(value = """
            SELECT COALESCE(SUM(c.total), 0)
            FROM cotizacion c
            WHERE c.estado = 'aceptada'
            AND c.fecha_emision >= CURRENT_DATE - (:meses || ' months')::INTERVAL
            """, nativeQuery = true)
    BigDecimal sumTotalAceptadas(@Param("meses") int meses);

    @Query(value = """
            SELECT COALESCE(SUM(c.total), 0)
            FROM cotizacion c
            WHERE c.estado = 'rechazada'
            AND c.fecha_emision >= CURRENT_DATE - (:meses || ' months')::INTERVAL
            """, nativeQuery = true)
    BigDecimal sumTotalRechazadas(@Param("meses") int meses);

    @Query(value = """
            SELECT p.sku, p.nombre, SUM(d.cantidad)
            FROM cotizacion_detalle d
            JOIN producto p ON p.id = d.producto_id
            GROUP BY p.sku, p.nombre
            ORDER BY SUM(d.cantidad) DESC
            LIMIT :top
            """, nativeQuery = true)
    List<Object[]> findProductosMasCotizadosRaw(@Param("top") int top);
}
