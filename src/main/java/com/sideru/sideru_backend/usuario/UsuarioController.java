package com.sideru.sideru_backend.usuario;

import com.sideru.sideru_backend.usuario.dto.UsuarioResponse;
import com.sideru.sideru_backend.usuario.entity.Usuario;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/usuario")
@RequiredArgsConstructor
public class UsuarioController {
    private final UsuarioService usuarioService;

    @GetMapping
    public List<UsuarioResponse> getUsuarios() {
        return usuarioService.getUsuarios();
    }
}
