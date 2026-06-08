package com.sideru.sideru_backend.security;

import com.sideru.sideru_backend.usuario.UsuarioRepository;
import com.sideru.sideru_backend.usuario.entity.Usuario;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UsuarioDetailsService implements UserDetailsService {
    private final UsuarioRepository usuarioRepository;

    @Override
    @NonNull
    public UserDetails loadUserByUsername(@NonNull String username) throws UsernameNotFoundException {
        Usuario usuario = usuarioRepository.findByUsername(username).orElseThrow(
                () -> new UsernameNotFoundException("Usuario no encontrado:" + username)
        );

        List<GrantedAuthority> grantedAuthorities = buildAuthorities(usuario);

        return new UsuarioDetails(usuario, grantedAuthorities);
    }

    private List<GrantedAuthority> buildAuthorities(Usuario usuario) {
        List<GrantedAuthority> authorities = new java.util.ArrayList<>(
            usuario.getRol().getPermisosCodigos().stream()
                .map(codigo -> (GrantedAuthority) (new SimpleGrantedAuthority(codigo)))
                .toList()
        );
        authorities.add(new SimpleGrantedAuthority("ROLE_" + usuario.getRol().getNombre()));
        return authorities;
    }
}

