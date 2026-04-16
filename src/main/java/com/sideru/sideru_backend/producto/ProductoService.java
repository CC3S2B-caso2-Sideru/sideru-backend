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

    public List<ProductoResponse> findByCategoriaId(Integer categoriaId) {
        return productoRepository.findAllByCategoriaId(categoriaId)
                .stream()
                .map(
                        producto -> productoMapper.toProductoResponse(producto)
                ).toList();
    }

    public List<ProductoResponse> findByCategoriaNombre(String categoriaNombre) {
        return productoRepository.findAllByCategoriaNombre(categoriaNombre)
                .stream()
                .map(
                        producto -> productoMapper.toProductoResponse(producto)
                ).toList();
    }

    public List<ProductoResponse> findByFilters(Integer categoriaId, String search) {
        return productoRepository.findByFilters(categoriaId, search)
                .stream()
                .map(productoMapper::toProductoResponse)
                .toList();
    }
}
