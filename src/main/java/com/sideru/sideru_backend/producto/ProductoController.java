package com.sideru.sideru_backend.producto;

import com.sideru.sideru_backend.producto.dto.ProductoResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/productos")
@Tag(name = "Productos", description = "Operaciones para la gestión de productos Sideru")
public class ProductoController {
    private ProductoService productoService;

    ProductoController(ProductoService productoService) {
        this.productoService = productoService;
    }

    @Operation(
            summary = "Consulta los productos Sideru con filtros",
            description = """
        Retorna un listado de productos con soporte para filtrado opcional por categoría.
        
        **Lógica de filtrado:** 
        * Si se proporciona `categoriaId`, se filtrará exclusivamente por el ID.
        * Si no hay ID pero se proporciona `categoriaNombre`, se filtrará por el nombre de la categoría.
        * Si no se envía ningún parámetro, se retornará la lista completa de productos.
        
        *Nota: El parámetro `categoriaId` tiene prioridad sobre `categoriaNombre`.*
        """
    )
    @GetMapping
    public List<ProductoResponse> filterProductos(
        @RequestParam(required = false) Integer categoriaId,
        @RequestParam(required = false) String categoriaNombre
    ) {
        if (categoriaId != null)
            return productoService.findByCategoriaId(categoriaId);
        else if (categoriaNombre != null)
            return productoService.findByCategoriaNombre(categoriaNombre);
        else
            return productoService.findAll();
    }
}
