package com.sideru.sideru_backend.auth;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.sideru.sideru_backend.auth.dto.AuthenticationRequest;
import com.sideru.sideru_backend.auth.dto.AuthenticationResponse;
import com.sideru.sideru_backend.auth.dto.RegisterRequest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.util.HashMap;
import java.util.Map;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

class AuthenticationControllerTest {

    private MockMvc mockMvc;
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final AuthenticationService authService = mock(AuthenticationService.class);

    private static final String TOKEN = "eyJhbGci.mock.token";

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders
                .standaloneSetup(new AuthenticationController(authService))
                .build();
    }

    @Nested
    class Login {

        @Test
        void shouldReturnTokenAnd201WithValidCredentials() throws Exception {
            AuthenticationRequest request = AuthenticationRequest.builder()
                    .username("user1").password("pass123").build();
            when(authService.authenticate(any())).thenReturn(
                    AuthenticationResponse.builder().token(TOKEN).build());

            mockMvc.perform(post("/auth/login")
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(objectMapper.writeValueAsString(request)))
                    .andExpect(status().isCreated())
                    .andExpect(jsonPath("$.token").value(TOKEN));
        }
    }

    @Nested
    class Register {

        @Test
        void shouldReturnTokenAnd201WithValidData() throws Exception {
            Map<String, Object> body = new HashMap<>();
            body.put("username", "newuser");
            body.put("password", "pass123");
            body.put("email", "new@test.com");
            Map<String, String> persona = new HashMap<>();
            persona.put("nombre", "Juan");
            persona.put("apellido", "Perez");
            persona.put("dni", "12345678");
            body.put("persona", persona);

            when(authService.register(any())).thenReturn(
                    AuthenticationResponse.builder().token(TOKEN).build());

            mockMvc.perform(post("/auth/register")
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(objectMapper.writeValueAsString(body)))
                    .andExpect(status().isCreated())
                    .andExpect(jsonPath("$.token").value(TOKEN));
        }
    }
}
