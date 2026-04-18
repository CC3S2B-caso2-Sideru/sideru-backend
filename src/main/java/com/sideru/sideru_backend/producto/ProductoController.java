package com.sideru.sideru_backend.producto;

import com.sideru.sideru_backend.producto.dto.ProductoResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@Validated
@RequestMapping("/productos")
@Tag(name = "Productos", description = "Operaciones para la gestión de productos Sideru")
public class ProductoController {
    private ProductoService productoService;

    ProductoController(ProductoService productoService) {
        this.productoService = productoService;
    }

    @Operation(
            summary = "Consulta de productos con filtros",
            description = """
        Retorna un listado de productos aplicando filtros. 
        
        **Orden de prioridad (solo se aplicará el primer parámetro encontrado):**\n
        1. `search`: Realiza una búsqueda global por coincidencia parcial en **nombre, SKU o nombre de su categoría**.\n
        2. `categoria`: filtra por categoria usando su Id.\n
        3. `page`: Indica la página de productos a mostrar. Se hace un offset de `n*(page-1)` productos.\n
        4. `n`: Indica la cantidad de productos a mostrar.
        """
    )
    @GetMapping
    public List<ProductoResponse> filterProductos(
        @RequestParam(required = false) String search,
        @RequestParam(name = "categoria", required = false) Integer categoriaId,
        @RequestParam(name = "page", required = false, defaultValue = "1")
            @Min(1)
            Long page,
        @RequestParam(name = "n", required = false, defaultValue = "18")
//            @Min(12)
            @Min(1)
            @Max(72)
            Integer pageSize
    ) {
//        try {
//            Thread.sleep(2000);
//        }  catch (InterruptedException e) {
//            e.printStackTrace();
//        }
        return productoService.findByFilters(categoriaId, search, page, pageSize);
    }
}
