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
            summary = "Consulta de productos con filtros exclusivos",
            description = """
        Retorna un listado de productos basado en un único criterio de búsqueda. 
        
        **Orden de prioridad (solo se aplicará el primer parámetro encontrado):**
        1. `search`: Realiza una búsqueda global por coincidencia parcial en **nombre, SKU o categoría**.
        2. `categoriaId`: Si no hay 'search', filtra por el ID exacto de la categoría.
        3. `categoriaNombre`: Si los anteriores son nulos, filtra por el nombre exacto de la categoría.
        4. **Sin parámetros**: Si no se recibe ninguno, retorna todos los productos.

        *Nota: Estos filtros no son combinables; el sistema ignora los parámetros de menor prioridad.*
        """
    )
    @GetMapping
    public List<ProductoResponse> filterProductos(
        @RequestParam(required = false) String search,
        @RequestParam(required = false) Integer categoriaId,
        @RequestParam(required = false) String categoriaNombre
    ) {
        if (search != null)
            return productoService.search(search);
        else if (categoriaId != null)
            return productoService.findByCategoriaId(categoriaId);
        else if (categoriaNombre != null)
            return productoService.findByCategoriaNombre(categoriaNombre);
        else
            return productoService.findAll();
    }
}
