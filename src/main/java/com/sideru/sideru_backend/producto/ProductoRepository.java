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
           WHERE LOWER(p.nombre) LIKE LOWER(CONCAT('%', :term, '%')) 
              OR LOWER(p.sku) LIKE LOWER(CONCAT('%', :term, '%')) 
              OR LOWER(p.categoria.nombre) LIKE LOWER(CONCAT('%', :term, '%'))
           """)
    List<Producto> searchByTerm(@Param("term") String term);
}
