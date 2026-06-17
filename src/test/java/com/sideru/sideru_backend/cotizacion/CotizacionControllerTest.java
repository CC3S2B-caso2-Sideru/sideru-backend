package com.sideru.sideru_backend.cotizacion;

import com.sideru.sideru_backend.cotizacion.dto.*;
import com.sideru.sideru_backend.security.UsuarioDetails;
import com.sideru.sideru_backend.security.jwt.JwtService;
import com.sideru.sideru_backend.security.UsuarioDetailsService;
import com.sideru.sideru_backend.usuario.entity.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;

import java.math.BigDecimal;
import java.time.*;
import java.util.List;
import java.util.Set;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.springframework.boot.security.autoconfigure.UserDetailsServiceAutoConfiguration;
import org.springframework.context.annotation.Import;
import com.sideru.sideru_backend.security.SecurityConfig;
import com.sideru.sideru_backend.security.CustomAuthenticationEntryPoint;

/**
 * Pruebas de integración de API y Seguridad de CotizacionController.
 * - @WebMvcTest(controllers = ...) inicializa el entorno de controladores MVC de Spring.
 * - excludeAutoConfiguration = ... previene conflictos de UserDetailsService simulando un entorno de pruebas aislado.
 * - @Import(...) carga la configuración de seguridad real del backend para aplicar las reglas de protección.
 */
@WebMvcTest(
    controllers = CotizacionController.class,
    excludeAutoConfiguration = UserDetailsServiceAutoConfiguration.class
)
@Import({SecurityConfig.class, CustomAuthenticationEntryPoint.class})
public class CotizacionControllerTest {

    // Utilidad de Spring para realizar peticiones HTTP virtuales contra los endpoints del controlador
    @Autowired
    private MockMvc mockMvc;

    // Se mockea la capa de servicios porque el objetivo es probar el controlador y su seguridad
    @MockitoBean
    private CotizacionService cotizacionService;

    // Dependencia del filtro JwtAuthenticationFilter en el backend (se mockea)
    @MockitoBean
    private JwtService jwtService;

    // Dependencia de SecurityConfig (se mockea para inyectar usuarios personalizados en los tests)
    @MockitoBean
    private UsuarioDetailsService userDetailsService;

    // Detalles de usuarios de prueba para inyecta000r en el contexto de seguridad
    private UsuarioDetails clienteDetails;
    private UsuarioDetails adminDetails;

    /**
     * Preparación previa a cada prueba.
     * Crea usuarios y asigna permisos específicos simulando la base de datos de producción.
     */
    @BeforeEach
    void setUp() throws Exception {
        // 1. Configurar un usuario CLIENTE ficticio con permisos para ver y crear cotizaciones
        Usuario clienteUsuario = new Usuario();
        clienteUsuario.setId(1);
        clienteUsuario.setUsername("cliente");
        
        Rol clienteRol = new Rol();
        clienteRol.setNombre("CLIENTE");
        clienteRol.setPermisos(Set.of(
            Permiso.builder().codigo("cotizacion.crear").build(),
            Permiso.builder().codigo("cotizacion.ver").build()
        ));
        clienteUsuario.setRol(clienteRol);
        
        clienteDetails = new UsuarioDetails(clienteUsuario, 
            List.of(new SimpleGrantedAuthority("cotizacion.crear"), new SimpleGrantedAuthority("cotizacion.ver")));
            
        // Registrar mock para cuando Spring Security intente resolver el usuario en tiempo de ejecución
        when(userDetailsService.loadUserByUsername("cliente")).thenReturn(clienteDetails);
        
        // 2. Configurar un usuario ADMINISTRADOR ficticio con permiso solo para ver
        Usuario adminUsuario = new Usuario();
        adminUsuario.setId(2);
        adminUsuario.setUsername("admin");
        
        Rol adminRol = new Rol();
        adminRol.setNombre("ADMIN");
        adminRol.setPermisos(Set.of(
            Permiso.builder().codigo("cotizacion.ver").build()
        ));
        adminUsuario.setRol(adminRol);
        
        adminDetails = new UsuarioDetails(adminUsuario, 
            List.of(new SimpleGrantedAuthority("cotizacion.ver")));
            
        when(userDetailsService.loadUserByUsername("admin")).thenReturn(adminDetails);
    }

    /**
     * Prueba: Intento de creación de cotización sin autenticación.
     * Resultado: El entry point de seguridad real debe interceptar la llamada y responder 401 Unauthorized.
     */
    @Test
    void crearCotizacion_SinAutenticacion_Retorna401() throws Exception {
        String json = "{\"observaciones\":\"Test\",\"items\":[{\"sku\":\"PROD01\",\"cantidad\":10}]}";
        
        mockMvc.perform(post("/cotizaciones")
                        .with(csrf()) // Agrega el token CSRF para pasar validaciones de Spring Security
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json))
                .andExpect(status().isUnauthorized()); // Debe rechazar y retornar 401
    }

    /**
     * Prueba: Intento de creación con rol no autorizado (Administrador).
     * Resultado: A pesar de estar autenticado, al no poseer el permiso 'cotizacion.crear',
     * la anotación @PreAuthorize debe denegar el acceso y retornar 403 Forbidden.
     */
    @Test
    void crearCotizacion_RolIncorrectoAdmin_Retorna403() throws Exception {
        String json = "{\"observaciones\":\"Test\",\"items\":[{\"sku\":\"PROD01\",\"cantidad\":10}]}";
        
        mockMvc.perform(post("/cotizaciones")
                        .with(csrf())
                        .with(user(adminDetails)) // Simula sesión con el usuario admin (que no tiene permiso de creación)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json))
                .andExpect(status().isForbidden()); // Debe retornar 403
    }

    /**
     * Prueba: Envío de solicitud exitosa con rol de cliente autorizado.
     * Resultado: Debe procesar la cotización en el servicio y retornar 201 Created.
     */
    @Test
    void crearCotizacion_ConRolCliente_RetornaCreated() throws Exception {
        String json = "{\"observaciones\":\"Test\",\"items\":[{\"sku\":\"PROD01\",\"cantidad\":10}]}";
        
        CotizacionResponse response = new CotizacionResponse(
                1, OffsetDateTime.now(), LocalDate.now().plusDays(7),
                "aceptada", "Test", BigDecimal.valueOf(100), BigDecimal.valueOf(18),
                BigDecimal.valueOf(118), "Juan Perez", List.of()
        );
        
        // Simular que el servicio ejecuta la creación con éxito
        when(cotizacionService.crearCotizacion(any(CotizacionRequest.class), any(Usuario.class)))
                .thenReturn(response);

        mockMvc.perform(post("/cotizaciones")
                        .with(csrf())
                        .with(user(clienteDetails)) // Simula sesión con el usuario cliente autorizado
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json))
                .andExpect(status().isCreated()); // Debe retornar 201
    }

    /**
     * Prueba: Validación de entrada - Lista de ítems vacía.
     * Resultado: La anotación @NotEmpty en CotizacionRequest debe invalidar la entrada y retornar 400 Bad Request.
     */
    @Test
    void crearCotizacion_ConItemsVacios_RetornaBadRequest() throws Exception {
        String json = "{\"observaciones\":\"Test\",\"items\":[]}"; // Carrito vacío
        
        mockMvc.perform(post("/cotizaciones")
                        .with(csrf())
                        .with(user(clienteDetails))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json))
                .andExpect(status().isBadRequest()); // Debe retornar 400
    }

    /**
     * Prueba: Validación de entrada - SKU en blanco.
     * Resultado: La anotación @NotBlank en CotizacionItemRequest debe activarse (gracias a @Valid en la lista)
     * e invalidar la petición retornando 400 Bad Request.
     */
    @Test
    void crearCotizacion_ConSkuEnBlanco_RetornaBadRequest() throws Exception {
        String json = "{\"observaciones\":\"Test\",\"items\":[{\"sku\":\"\",\"cantidad\":10}]}"; // SKU vacío
        
        mockMvc.perform(post("/cotizaciones")
                        .with(csrf())
                        .with(user(clienteDetails))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json))
                .andExpect(status().isBadRequest()); // Debe retornar 400
    }

    /**
     * Prueba: Validación de entrada - Cantidad menor a 1.
     * Resultado: La anotación @Min(1) en CotizacionItemRequest debe activarse y rechazar la petición con 400 Bad Request.
     */
    @Test
    void crearCotizacion_ConCantidadMenorAUno_RetornaBadRequest() throws Exception {
        String json = "{\"observaciones\":\"Test\",\"items\":[{\"sku\":\"PROD01\",\"cantidad\":0}]}"; // Cantidad menor a 1
        
        mockMvc.perform(post("/cotizaciones")
                        .with(csrf())
                        .with(user(clienteDetails))
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json))
                .andExpect(status().isBadRequest()); // Debe retornar 400
    }

    /**
     * Prueba: Consulta de historial con rol de cliente autorizado.
     * Resultado: Retorna el historial propio del cliente logueado con código 200 OK.
     */
    @Test
    void listarMisCotizaciones_ConRolCliente_RetornaOk() throws Exception {
        when(cotizacionService.listarMisCotizaciones(any(Usuario.class))).thenReturn(List.of());

        mockMvc.perform(get("/cotizaciones/mis-cotizaciones")
                        .with(user(clienteDetails))) // Cliente tiene permiso 'cotizacion.ver'
                .andExpect(status().isOk()); // Debe retornar 200
    }
}
