package com.sideru.sideru_backend.categoria;

import com.sideru.sideru_backend.categoria.dto.CategoriaResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/categorias")
@Tag(name = "Categorias", description = "Operaciones para la gestión de categorias Sideru")
public class CategoriaController {
//        try {
//            Thread.sleep(2000);
//        }  catch (InterruptedException e) {
//            e.printStackTrace();
//        }
    private CategoriaService categoriaService;

    public CategoriaController(CategoriaService categoriaService) {
        this.categoriaService = categoriaService;
    }

    @Operation(summary = "Lista las categorias de los productos Sideru")
    @GetMapping
    public List<CategoriaResponse> findAll() {
        return categoriaService.findAll();
    }
}
