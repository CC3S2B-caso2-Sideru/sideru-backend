package com.sideru.sideru_backend.producto;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
public class ProductoController {
    private ProductoRepository productoRepository;

    ProductoController(ProductoRepository productoRepository) {
        this.productoRepository = productoRepository;
    }

    @GetMapping("/")
    public Map<String, String> index() {
        Map<String, String> saludo =  new HashMap<>();
        saludo.put("message", "Bienvenido a Sideru backend!");

        return saludo;
    }

    @GetMapping("/productos")
    public List<Producto> productos() {
        return productoRepository.findAll();
    }
}
