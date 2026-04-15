package com.sideru.sideru_backend.producto;

import com.sideru.sideru_backend.producto.dto.ProductoResponse;
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

    public List<ProductoResponse> findAll() {
        return productoRepository.findAll()
                .stream()
                .map(
                        producto -> productoMapper.toProductoResponse(producto)
                ).toList();
    }
}
