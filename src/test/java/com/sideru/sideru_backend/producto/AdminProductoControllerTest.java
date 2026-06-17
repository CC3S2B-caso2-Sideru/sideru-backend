package com.sideru.sideru_backend.producto;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.sideru.sideru_backend.producto.dto.ProductoAdminResponse;
import com.sideru.sideru_backend.producto.dto.ProductoRequest;
import com.sideru.sideru_backend.producto.dto.StockAdjustmentRequest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.web.PageableHandlerMethodArgumentResolver;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.math.BigDecimal;
import java.util.List;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

class AdminProductoControllerTest {

    private MockMvc mockMvc;
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final ProductoService productoService = mock(ProductoService.class);

    private final ProductoAdminResponse response = new ProductoAdminResponse(
            1, "TUB-001", "Tubo de acero", "Desc", "img.jpg",
            new BigDecimal("100.00"), 150, 50, true, "Aceros"
    );

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders
                .standaloneSetup(new AdminProductoController(productoService))
                .setCustomArgumentResolvers(new PageableHandlerMethodArgumentResolver())
                .build();
    }

    @Nested
    class ListarTodos {

        @Test
        void shouldReturnPaginatedProducts() throws Exception {
            when(productoService.findAllAdmin(isNull(), isNull(), isNull(), any()))
                    .thenReturn(new PageImpl<>(List.of(response), PageRequest.of(0, 12), 1));

            mockMvc.perform(get("/admin/productos"))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.content[0].sku").value("TUB-001"))
                    .andExpect(jsonPath("$.totalElements").value(1));
        }

        @Test
        void shouldPassQueryParams() throws Exception {
            when(productoService.findAllAdmin(eq("tubo"), eq(1), eq(true), any()))
                    .thenReturn(new PageImpl<>(List.of(), PageRequest.of(0, 12), 0));

            mockMvc.perform(get("/admin/productos?search=tubo&categoriaId=1&activo=true&page=0&size=12"))
                    .andExpect(status().isOk());

            verify(productoService).findAllAdmin(eq("tubo"), eq(1), eq(true), any());
        }
    }

    @Nested
    class ListarStockBajo {

        @Test
        void shouldReturnLowStockProducts() throws Exception {
            when(productoService.findStockBajo()).thenReturn(List.of(response));

            mockMvc.perform(get("/admin/productos/stock-bajo"))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$[0].sku").value("TUB-001"));
        }
    }

    @Nested
    class ObtenerPorSku {

        @Test
        void shouldReturnProductBySku() throws Exception {
            when(productoService.findBySkuAdmin("TUB-001")).thenReturn(response);

            mockMvc.perform(get("/admin/productos/TUB-001"))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.sku").value("TUB-001"));
        }
    }

    @Nested
    class Crear {

        @Test
        void shouldCreateProductAndReturn201() throws Exception {
            ProductoRequest request = new ProductoRequest(
                    "TUB-001", "Tubo", "Desc", "img.jpg",
                    new BigDecimal("100.00"), 150, 50, 1
            );
            when(productoService.create(any())).thenReturn(response);

            mockMvc.perform(post("/admin/productos")
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(objectMapper.writeValueAsString(request)))
                    .andExpect(status().isCreated())
                    .andExpect(jsonPath("$.sku").value("TUB-001"));
        }

        @Test
        void shouldReturn400WhenValidationFails() throws Exception {
            ProductoRequest request = new ProductoRequest(
                    "", "", null, null,
                    BigDecimal.ZERO, 0, null, null
            );

            mockMvc.perform(post("/admin/productos")
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(objectMapper.writeValueAsString(request)))
                    .andExpect(status().isBadRequest());
        }
    }

    @Nested
    class Actualizar {

        @Test
        void shouldUpdateProduct() throws Exception {
            ProductoRequest request = new ProductoRequest(
                    "TUB-002", "Tubo actualizado", "Nueva desc", "img.jpg",
                    new BigDecimal("120.00"), 200, 60, 1
            );
            when(productoService.update(eq("TUB-001"), any())).thenReturn(response);

            mockMvc.perform(put("/admin/productos/TUB-001")
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(objectMapper.writeValueAsString(request)))
                    .andExpect(status().isOk());
        }
    }

    @Nested
    class ToggleActivo {

        @Test
        void shouldToggleActive() throws Exception {
            when(productoService.toggleActive("TUB-001")).thenReturn(response);

            mockMvc.perform(patch("/admin/productos/TUB-001/activar"))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.activo").value(true));
        }
    }

    @Nested
    class AjustarStock {

        @Test
        void shouldAdjustStock() throws Exception {
            StockAdjustmentRequest request = new StockAdjustmentRequest(30);
            when(productoService.adjustStock("TUB-001", 30)).thenReturn(response);

            mockMvc.perform(patch("/admin/productos/TUB-001/stock")
                            .contentType(MediaType.APPLICATION_JSON)
                            .content(objectMapper.writeValueAsString(request)))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.sku").value("TUB-001"));
        }

        @Test
        void shouldReturn400WhenCantidadIsNull() throws Exception {
            mockMvc.perform(patch("/admin/productos/TUB-001/stock")
                            .contentType(MediaType.APPLICATION_JSON)
                            .content("{}"))
                    .andExpect(status().isBadRequest());
        }
    }
}
