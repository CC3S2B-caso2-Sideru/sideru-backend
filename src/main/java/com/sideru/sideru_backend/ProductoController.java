package com.sideru.sideru_backend;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
public class ProductoController {
    @GetMapping("/")
    public Map<String, String> index() {
        Map<String, String> saludo =  new HashMap<>();
        saludo.put("message", "Bienvenido a Sideru backend!");

        return saludo;
    }
}
