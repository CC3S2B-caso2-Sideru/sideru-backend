package com.sideru.sideru_backend.producto;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;


public interface ProductoRepository extends JpaRepository<Producto, Integer> {
    List<Producto> findAllByCategoriaId(Integer categoriaId);

    List<Producto> findAllByCategoriaNombre(String nombre);

    Optional<Producto> findBySku(String sku);

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
            ) AND p.activo = true ORDER BY (p.nombre) LIMIT :limit OFFSET :offset
            """)
    List<Producto> findByFilters(Integer categoriaId, String search,  Long limit, Long offset);

    @Query(value = """
            SELECT p FROM Producto p
            JOIN p.categoria c
            WHERE (:search IS NULL OR
                   LOWER(p.nombre) LIKE LOWER(CONCAT('%', CAST(:search AS string), '%'))
                   OR LOWER(p.sku) LIKE LOWER(CONCAT('%', CAST(:search AS string), '%'))
                   OR LOWER(c.nombre) LIKE LOWER(CONCAT('%', CAST(:search AS string), '%')))
            AND (:categoriaId IS NULL OR p.categoria.id = :categoriaId)
            AND (:activo IS NULL OR p.activo = :activo)
            """,
            countQuery = """
            SELECT COUNT(p) FROM Producto p
            JOIN p.categoria c
            WHERE (:search IS NULL OR
                   LOWER(p.nombre) LIKE LOWER(CONCAT('%', CAST(:search AS string), '%'))
                   OR LOWER(p.sku) LIKE LOWER(CONCAT('%', CAST(:search AS string), '%'))
                   OR LOWER(c.nombre) LIKE LOWER(CONCAT('%', CAST(:search AS string), '%')))
            AND (:categoriaId IS NULL OR p.categoria.id = :categoriaId)
            AND (:activo IS NULL OR p.activo = :activo)
            """)
    Page<Producto> findAdminByFilters(
            @Param("search") String search,
            @Param("categoriaId") Integer categoriaId,
            @Param("activo") Boolean activo,
            Pageable pageable
    );

    @Query("SELECT p FROM Producto p WHERE p.stock <= p.stockMinimo AND p.activo = true")
    List<Producto> findStockBajo();

}
