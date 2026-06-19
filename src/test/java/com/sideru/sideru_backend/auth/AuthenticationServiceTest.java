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
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AuthenticationServiceTest {

    @Mock private AuthenticationManager authenticationManager;
    @Mock private PasswordEncoder passwordEncoder;
    @Mock private JwtService jwtService;
    @Mock private UsuarioRepository usuarioRepository;
    @Mock private RolRepository rolRepository;
    @Mock private ClienteRepository clienteRepository;
    @Mock private UsuarioDetailsService usuarioDetailsService;

    @InjectMocks
    private AuthenticationService authenticationService;

    private static final String TOKEN = "eyJhbGciOiJIUzI1NiJ9.mockToken";

    @Nested
    class Authenticate {

        @Test
        void shouldReturnTokenWithValidCredentials() {
            AuthenticationRequest request = new AuthenticationRequest("user1", "pass123");
            Usuario usuario = buildUsuario("user1", "cliente");
            UserDetails userDetails = mock(UserDetails.class);

            when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class)))
                    .thenReturn(null);
            when(usuarioRepository.findByUsername("user1")).thenReturn(Optional.of(usuario));
            when(usuarioDetailsService.loadUserByUsername("user1")).thenReturn(userDetails);
            when(jwtService.generateToken(anyMap(), eq(userDetails))).thenReturn(TOKEN);

            AuthenticationResponse result = authenticationService.authenticate(request);

            assertThat(result.getToken()).isEqualTo(TOKEN);
            verify(authenticationManager).authenticate(any(UsernamePasswordAuthenticationToken.class));
        }

        @Test
        void shouldThrowValidationExceptionOnBadCredentials() {
            AuthenticationRequest request = new AuthenticationRequest("user1", "wrong");
            when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class)))
                    .thenThrow(new BadCredentialsException("Bad credentials"));

            assertThatThrownBy(() -> authenticationService.authenticate(request))
                    .isInstanceOf(ValidationException.class)
                    .hasMessageContaining("Credenciales no válidas");
        }

        @Test
        void shouldThrowValidationExceptionOnAnyAuthException() {
            AuthenticationRequest request = new AuthenticationRequest("user1", "pass");
            when(authenticationManager.authenticate(any(UsernamePasswordAuthenticationToken.class)))
                    .thenThrow(new RuntimeException("Unexpected"));

            assertThatThrownBy(() -> authenticationService.authenticate(request))
                    .isInstanceOf(ValidationException.class)
                    .hasMessageContaining("Credenciales no válidas");
        }
    }

    @Nested
    class Register {

        @Test
        // Registrar un cliente
        void shouldRegisterAndReturnToken() {
            RegisterRequest request = new RegisterRequest("newuser", "pass", "new@test.com", buildClienteCreate());
            Rol rolCliente = new Rol();
            rolCliente.setNombre("cliente");
            Usuario usuarioGuardado = buildUsuario("newuser", "cliente");
            UserDetails userDetails = mock(UserDetails.class);

            when(usuarioRepository.findByUsername("newuser")).thenReturn(Optional.empty());
            when(rolRepository.findByNombre("cliente")).thenReturn(Optional.of(rolCliente));
            when(passwordEncoder.encode("pass")).thenReturn("hashed");
            when(usuarioRepository.save(any(Usuario.class))).thenReturn(usuarioGuardado);
            when(clienteRepository.save(any(Cliente.class))).thenReturn(new Cliente());
            when(usuarioDetailsService.loadUserByUsername("newuser")).thenReturn(userDetails);
            when(jwtService.generateToken(anyMap(), eq(userDetails))).thenReturn(TOKEN);

            AuthenticationResponse result = authenticationService.register(request);

            assertThat(result.getToken()).isEqualTo(TOKEN);
            verify(usuarioRepository).save(any(Usuario.class));
            verify(clienteRepository).save(any(Cliente.class));
        }

        @Test
        void shouldThrowWhenUsernameAlreadyExists() {
            RegisterRequest request = new RegisterRequest("existing", "pass", "e@t.com", buildClienteCreate());
            when(usuarioRepository.findByUsername("existing")).thenReturn(Optional.of(new Usuario()));

            assertThatThrownBy(() -> authenticationService.register(request))
                    .isInstanceOf(DuplicateResourceException.class)
                    .hasMessageContaining("Usuario");
        }

        @Test
        void shouldThrowWhenClienteRoleNotFound() {
            RegisterRequest request = new RegisterRequest("newuser", "pass", "e@t.com", buildClienteCreate());
            when(usuarioRepository.findByUsername("newuser")).thenReturn(Optional.empty());
            when(rolRepository.findByNombre("cliente")).thenReturn(Optional.empty());

            assertThatThrownBy(() -> authenticationService.register(request))
                    .isInstanceOf(ResourceNotFoundException.class)
                    .hasMessageContaining("Rol");
        }

        @Test
        void shouldEncodePasswordBeforeSaving() {
            RegisterRequest request = new RegisterRequest("newuser", "rawpass", "e@t.com", buildClienteCreate());
            Rol rolCliente = new Rol();
            rolCliente.setNombre("cliente");
            UserDetails userDetails = mock(UserDetails.class);

            when(usuarioRepository.findByUsername("newuser")).thenReturn(Optional.empty());
            when(rolRepository.findByNombre("cliente")).thenReturn(Optional.of(rolCliente));
            when(passwordEncoder.encode("rawpass")).thenReturn("encodedPass");
            when(usuarioRepository.save(any(Usuario.class))).thenAnswer(inv -> {
                Usuario u = inv.getArgument(0);
                assertThat(u.getPasswordHash()).isEqualTo("encodedPass");
                return u;
            });
            when(clienteRepository.save(any(Cliente.class))).thenReturn(new Cliente());
            when(usuarioDetailsService.loadUserByUsername("newuser")).thenReturn(userDetails);
            when(jwtService.generateToken(anyMap(), eq(userDetails))).thenReturn(TOKEN);

            authenticationService.register(request);
            verify(passwordEncoder).encode("rawpass");
        }

        @Test
        void shouldIncludeRoleAndTypeInJwtClaims() {
            RegisterRequest request = new RegisterRequest("newuser", "pass", "e@t.com", buildClienteCreate());
            Rol rolCliente = new Rol();
            rolCliente.setNombre("cliente");
            Usuario usuarioGuardado = buildUsuario("newuser", "cliente");
            UserDetails userDetails = mock(UserDetails.class);

            when(usuarioRepository.findByUsername("newuser")).thenReturn(Optional.empty());
            when(rolRepository.findByNombre("cliente")).thenReturn(Optional.of(rolCliente));
            when(passwordEncoder.encode(anyString())).thenReturn("hashed");
            when(usuarioRepository.save(any(Usuario.class))).thenReturn(usuarioGuardado);
            when(clienteRepository.save(any(Cliente.class))).thenReturn(new Cliente());
            when(usuarioDetailsService.loadUserByUsername("newuser")).thenReturn(userDetails);
            when(jwtService.generateToken(anyMap(), eq(userDetails))).thenReturn(TOKEN);

            authenticationService.register(request);

            verify(jwtService).generateToken(argThat((Map<String, Object> claims) ->
                    "cliente".equals(claims.get("rol")) && "CLIENTE".equals(claims.get("tipo"))
            ), eq(userDetails));
        }
    }

    private ClienteCreate buildClienteCreate() {
        return ClienteCreate.builder()
                .nombre("Juan").apellido("Perez").dni("12345678").build();
    }

    private Usuario buildUsuario(String username, String rolNombre) {
        Rol rol = new Rol();
        rol.setNombre(rolNombre);
        return Usuario.builder()
                .username(username).rol(rol).tipo(TipoUsuario.CLIENTE).build();
    }
}
