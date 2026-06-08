package com.sideru.sideru_backend.producto;

import com.sideru.sideru_backend.producto.dto.ProductoResponse;
import org.springframework.stereotype.Service;

@Service
public class ProductoMapper {
    public ProductoResponse toProductoResponse(Producto producto) {
        return new ProductoResponse(
            producto.getSku(),
            producto.getNombre(),
            producto.getImagen(),
            producto.getPrecio(),
                producto.getStockMinimo()
        );
    }
}
