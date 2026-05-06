package com.sideru.sideru_backend.usuario;

import com.sideru.sideru_backend.usuario.dto.RolResponse;
import com.sideru.sideru_backend.usuario.dto.UsuarioResponse;
import com.sideru.sideru_backend.usuario.entity.Permiso;
import com.sideru.sideru_backend.usuario.entity.Rol;
import com.sideru.sideru_backend.usuario.entity.Usuario;
import org.springframework.stereotype.Service;

@Service
public class UsuarioMapper {
    public UsuarioResponse toUsuarioResponse(Usuario usuario) {
        Rol rol = usuario.getRol();

        RolResponse rolResponse = RolResponse.builder()
                .nombre(rol.getNombre())
                .permisos(rol.getPermisosCodigos())
                .build();

        return UsuarioResponse.builder()
                .username(usuario.getUsername())
                .email(usuario.getEmail())
                .rol(rolResponse)
                .build();
    }
}
