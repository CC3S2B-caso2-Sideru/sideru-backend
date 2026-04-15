package com.sideru.sideru_backend.producto;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductoService {
    private ProductoRepository productoRepository;
    private ProductoMapper productoMapper;

    public ProductoService(
            ProductoRepository productoRepository,
            ProductoMapper productoMapper
    ) {
        this.productoRepository = productoRepository;
        this.productoMapper = productoMapper;
    }

    public List<Producto> findAll() {
        return productoRepository.findAll();
    }
}
