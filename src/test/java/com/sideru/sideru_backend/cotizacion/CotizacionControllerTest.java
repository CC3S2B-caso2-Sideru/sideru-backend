package com.sideru.sideru_backend.cotizacion;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.sideru.sideru_backend.cotizacion.dto.CotizacionItemRequest;
import com.sideru.sideru_backend.cotizacion.dto.CotizacionRequest;
import com.sideru.sideru_backend.security.CustomAuthenticationEntryPoint;
import com.sideru.sideru_backend.security.UsuarioDetailsService;
import com.sideru.sideru_backend.security.jwt.JwtService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(CotizacionController.class)
class CotizacionControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private CotizacionService cotizacionService;

    @MockBean
    private JwtService jwtService;

    @MockBean
    private UsuarioDetailsService usuarioDetailsService;

    @MockBean
    private CustomAuthenticationEntryPoint customAuthenticationEntryPoint;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    void crearCotizacion_SinAutenticacion_RetornaError() throws Exception {
        CotizacionItemRequest item = new CotizacionItemRequest("ACR-BAR-001", 5);
        CotizacionRequest request = new CotizacionRequest("Prueba", List.of(item));

        // Peticiones anónimas a endpoints protegidos deben ser rechazadas
        mockMvc.perform(post("/cotizaciones")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().is4xxClientError());
    }

    @Test
    @WithMockUser(username = "admin", roles = "admin") // Rol admin, no tiene rol cliente
    void crearCotizacion_RolIncorrectoAdmin_Retorna403() throws Exception {
        CotizacionItemRequest item = new CotizacionItemRequest("ACR-BAR-001", 5);
        CotizacionRequest request = new CotizacionRequest("Prueba", List.of(item));

        // Debe dar 403 Forbidden ya que el endpoint exige ROLE_cliente o ventas.cotizacion.crear
        mockMvc.perform(post("/cotizaciones")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isForbidden());
    }

    @Test
    @WithMockUser(username = "cliente_user", roles = "cliente") // Rol correcto
    void crearCotizacion_ConRolCliente_RetornaCreated() throws Exception {
        CotizacionItemRequest item = new CotizacionItemRequest("ACR-BAR-001", 5);
        CotizacionRequest request = new CotizacionRequest("Prueba", List.of(item));

        mockMvc.perform(post("/cotizaciones")
                        .with(csrf())
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated());
    }

    @Test
    @WithMockUser(username = "cliente_user", roles = "cliente")
    void listarMisCotizaciones_ConRolCliente_RetornaOk() throws Exception {
        mockMvc.perform(get("/cotizaciones/mis-cotizaciones"))
                .andExpect(status().isOk());
    }
}
