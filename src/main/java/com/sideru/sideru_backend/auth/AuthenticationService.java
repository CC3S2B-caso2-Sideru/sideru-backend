package com.sideru.sideru_backend.auth;

import com.sideru.sideru_backend.auth.dto.AuthenticationRequest;
import com.sideru.sideru_backend.auth.dto.AuthenticationResponse;
import com.sideru.sideru_backend.auth.dto.RegisterRequest;
import com.sideru.sideru_backend.cliente.Cliente;
import com.sideru.sideru_backend.cliente.ClienteRepository;
import com.sideru.sideru_backend.cliente.dto.ClienteCreate;
import com.sideru.sideru_backend.exception.DuplicateResourceException;
import com.sideru.sideru_backend.exception.ResourceNotFoundException;
import com.sideru.sideru_backend.exception.ValidationException;
import com.sideru.sideru_backend.security.UsuarioDetailsService;
import com.sideru.sideru_backend.security.jwt.JwtService;
import com.sideru.sideru_backend.usuario.RolRepository;
import com.sideru.sideru_backend.usuario.UsuarioRepository;
import com.sideru.sideru_backend.usuario.entity.Rol;
import com.sideru.sideru_backend.usuario.entity.TipoUsuario;
import com.sideru.sideru_backend.usuario.entity.Usuario;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthenticationService {

    private final AuthenticationManager authenticationManager;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final UsuarioRepository usuarioRepository;
    private final RolRepository rolRepository;
    private final ClienteRepository clienteRepository;
    private final UsuarioDetailsService usuarioDetailsService;

    @Transactional
    public AuthenticationResponse register(RegisterRequest registerRequest) {
        // Verificar que el usuario no exista
        if (usuarioRepository.findByUsername(registerRequest.getUsername()).isPresent()) {
            throw new DuplicateResourceException("Usuario","username",registerRequest.getUsername());
        }

        // Obtener el rol por defecto "cliente"
        Rol rolCliente = rolRepository.findByNombre("cliente")
                .orElseThrow(() -> new ResourceNotFoundException("Rol", "cliente"));

        // Crear usuario
        Usuario usuario = Usuario.builder()
                .username(registerRequest.getUsername())
                .email(registerRequest.getEmail())
                .passwordHash(passwordEncoder.encode(registerRequest.getPassword()))
                .tipo(TipoUsuario.CLIENTE)
                .rol(rolCliente)
                .activo(true)
                .build();

        Usuario usuarioGuardado = usuarioRepository.save(usuario);

        // Crear cliente con los datos del RegisterRequest
        ClienteCreate clienteCreate = registerRequest.getClienteCreate();

        Cliente cliente = Cliente.builder()
                .usuario(usuarioGuardado)
                .dni(clienteCreate.getDni())
                .ruc(clienteCreate.getRuc())
                .razonSocial(clienteCreate.getRazonSocial())
                .nombre(clienteCreate.getNombre())
                .apellido(clienteCreate.getApellido())
                .telefono(clienteCreate.getTelefono())
                .direccion(clienteCreate.getDireccion())
                .build();

        clienteRepository.save(cliente);

        log.info("Usuario registrado exitosamente: {}", registerRequest.getUsername());

        // Generar token JWT
        String token = jwtService.generateToken(Map.of(
                        "rol", usuario.getRol().getNombre(),
                        "tipo", usuario.getTipo().toString()
                ),
                usuarioDetailsService.loadUserByUsername(usuario.getUsername())
        );

        return AuthenticationResponse.builder()
                .token(token)
                .build();
    }

    public AuthenticationResponse authenticate(AuthenticationRequest authRequest) {
        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            authRequest.getUsername(),
                            authRequest.getPassword()
                    )
            );
        } catch (Exception e) {
            throw new ValidationException("Credenciales no válidas");
        }

        // Obtener usuario
        Usuario usuario = usuarioRepository.findByUsername(authRequest.getUsername())
                .orElseThrow(() -> new UsernameNotFoundException("Usuario no encontrado"));

        // Generar token JWT
        String token = jwtService.generateToken(
                Map.of(
                        "rol", usuario.getRol().getNombre(),
                        "tipo", usuario.getTipo().toString()
                ),
                usuarioDetailsService.loadUserByUsername(usuario.getUsername())
        );

        log.info("Usuario autenticado exitosamente: {}", authRequest.getUsername());

        return AuthenticationResponse.builder()
                .token(token)
                .build();
    }
}
