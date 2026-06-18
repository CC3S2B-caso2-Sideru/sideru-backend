package com.sideru.sideru_backend.producto;

<<<<<<< HEAD
=======
import com.sideru.sideru_backend.producto.dto.ProductoAdminResponse;
>>>>>>> ccf3d5da26ddc823de61935b46cb22af71946569
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
<<<<<<< HEAD
=======

    public ProductoAdminResponse toAdminResponse(Producto producto) {
        return new ProductoAdminResponse(
            producto.getId(),
            producto.getSku(),
            producto.getNombre(),
            producto.getDescripcion(),
            producto.getImagen(),
            producto.getPrecio(),
            producto.getStock(),
            producto.getStockMinimo(),
            producto.getActivo(),
            producto.getCategoria().getNombre()
        );
    }
>>>>>>> ccf3d5da26ddc823de61935b46cb22af71946569
}
