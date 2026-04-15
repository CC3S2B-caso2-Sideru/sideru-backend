package com.sideru.sideru_backend.producto;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ProductoRepository extends JpaRepository<Producto, Integer> {
    List<Producto> findAllByCategoriaId(Integer categoriaId);
    List<Producto> findAllByCategoriaNombre(String nombre);
}
