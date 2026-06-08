package com.sideru.sideru_backend.cotizacion;

import com.sideru.sideru_backend.cliente.Cliente;
import com.sideru.sideru_backend.cliente.ClienteRepository;
import com.sideru.sideru_backend.cotizacion.dto.*;
import com.sideru.sideru_backend.cotizacion.entity.Cotizacion;
import com.sideru.sideru_backend.cotizacion.entity.EstadoCotizacion;
import com.sideru.sideru_backend.exception.ResourceNotFoundException;
import com.sideru.sideru_backend.producto.Producto;
import com.sideru.sideru_backend.producto.ProductoRepository;
import com.sideru.sideru_backend.usuario.entity.Usuario;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class CotizacionServiceTest {

    @Mock
    private CotizacionRepository cotizacionRepository;

    @Mock
    private ClienteRepository clienteRepository;

    @Mock
    private ProductoRepository productoRepository;

    @InjectMocks
    private CotizacionService cotizacionService;

    @Test
    void crearCotizacion_Exito_AceptadaAutomaticamente() {
        // Arrange
        Usuario usuario = Usuario.builder().id(1).username("cliente_test").build();
        Cliente cliente = Cliente.builder().id(1).nombre("Jorge").apellido("Silva").build();

        Producto producto = new Producto();
        producto.setId(1);
        producto.setSku("ACR-BAR-001");
        producto.setNombre("Barra de acero 1/2\"");
        producto.setPrecio(BigDecimal.valueOf(45.50));
        producto.setStockMinimo(20);

        CotizacionItemRequest itemReq = new CotizacionItemRequest("ACR-BAR-001", 5); // 5 <= stockMinimo (20)
        CotizacionRequest request = new CotizacionRequest("Prueba de cotizacion", List.of(itemReq));

        when(clienteRepository.findByUsuario(usuario)).thenReturn(Optional.of(cliente));
        when(productoRepository.findBySku("ACR-BAR-001")).thenReturn(Optional.of(producto));
        when(cotizacionRepository.save(any(Cotizacion.class))).thenAnswer(invocation -> {
            Cotizacion saved = invocation.getArgument(0);
            saved.setId(100);
            return saved;
        });

        // Act
        CotizacionResponse response = cotizacionService.crearCotizacion(request, usuario);

        // Assert
        assertNotNull(response);
        assertEquals(100, response.id());
        assertEquals("aceptada", response.estado().toLowerCase());
        // subtotal = 227.50; igv = 227.50 * 0.18 = 40.95; total = 268.45
        assertEquals(BigDecimal.valueOf(268.45), response.total());
        verify(cotizacionRepository, times(1)).save(any(Cotizacion.class));
    }

    @Test
    void crearCotizacion_Exito_EnviadaPorExcesoStockMinimo() {
        // Arrange
        Usuario usuario = Usuario.builder().id(1).username("cliente_test").build();
        Cliente cliente = Cliente.builder().id(1).nombre("Jorge").apellido("Silva").build();

        Producto producto = new Producto();
        producto.setId(1);
        producto.setSku("ACR-BAR-001");
        producto.setNombre("Barra de acero 1/2\"");
        producto.setPrecio(BigDecimal.valueOf(45.50));
        producto.setStockMinimo(20);

        CotizacionItemRequest itemReq = new CotizacionItemRequest("ACR-BAR-001", 25); // 25 > stockMinimo (20)
        CotizacionRequest request = new CotizacionRequest("Prueba de cotizacion", List.of(itemReq));

        when(clienteRepository.findByUsuario(usuario)).thenReturn(Optional.of(cliente));
        when(productoRepository.findBySku("ACR-BAR-001")).thenReturn(Optional.of(producto));
        when(cotizacionRepository.save(any(Cotizacion.class))).thenAnswer(invocation -> {
            Cotizacion saved = invocation.getArgument(0);
            saved.setId(101);
            return saved;
        });

        // Act
        CotizacionResponse response = cotizacionService.crearCotizacion(request, usuario);

        // Assert
        assertNotNull(response);
        assertEquals(101, response.id());
        assertEquals("enviada", response.estado().toLowerCase()); // Debe ser enviado para revision
        verify(cotizacionRepository, times(1)).save(any(Cotizacion.class));
    }

    @Test
    void crearCotizacion_ClienteNoEncontrado_LanzaExcepcion() {
        // Arrange
        Usuario usuario = Usuario.builder().id(1).username("cliente_test").build();
        CotizacionRequest request = new CotizacionRequest("Prueba", List.of());

        when(clienteRepository.findByUsuario(usuario)).thenReturn(Optional.empty());

        // Act & Assert
        assertThrows(ResourceNotFoundException.class, () -> {
            cotizacionService.crearCotizacion(request, usuario);
        });
        verify(cotizacionRepository, never()).save(any());
    }

    @Test
    void crearCotizacion_ProductoNoEncontrado_LanzaExcepcion() {
        // Arrange
        Usuario usuario = Usuario.builder().id(1).username("cliente_test").build();
        Cliente cliente = Cliente.builder().id(1).nombre("Jorge").apellido("Silva").build();
        CotizacionItemRequest itemReq = new CotizacionItemRequest("SKU-INEXISTENTE", 5);
        CotizacionRequest request = new CotizacionRequest("Prueba", List.of(itemReq));

        when(clienteRepository.findByUsuario(usuario)).thenReturn(Optional.of(cliente));
        when(productoRepository.findBySku("SKU-INEXISTENTE")).thenReturn(Optional.empty());

        // Act & Assert
        assertThrows(ResourceNotFoundException.class, () -> {
            cotizacionService.crearCotizacion(request, usuario);
        });
        verify(cotizacionRepository, never()).save(any());
    }
}
