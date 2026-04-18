package com.sideru.sideru_backend.producto;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ProductoRepository extends JpaRepository<Producto, Integer> {
    List<Producto> findAllByCategoriaId(Integer categoriaId);

    List<Producto> findAllByCategoriaNombre(String nombre);

    @Query("""
            SELECT p FROM Producto p
            JOIN p.categoria c
            WHERE (:categoriaId IS NULL OR p.categoria.id = :categoriaId)
            AND (
                :search IS NULL OR (
                    LOWER(p.nombre) LIKE LOWER(CONCAT('%', CAST(:search AS string), '%'))
                    OR LOWER(p.sku) LIKE LOWER(CONCAT('%', CAST(:search AS string), '%'))
                    OR LOWER(c.nombre) LIKE LOWER(CONCAT('%', CAST(:search AS string), '%'))
                )
            ) ORDER BY (p.nombre) LIMIT :limit OFFSET :offset
            """)
    List<Producto> findByFilters(Integer categoriaId, String search,  Long limit, Long offset);
}
