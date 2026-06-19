package com.sideru.sideru_backend.cotizacion;

import com.sideru.sideru_backend.cliente.Cliente;
import com.sideru.sideru_backend.cliente.ClienteRepository;
import com.sideru.sideru_backend.cotizacion.dto.*;
import com.sideru.sideru_backend.cotizacion.entity.Cotizacion;
import com.sideru.sideru_backend.cotizacion.entity.EstadoCotizacion;
import com.sideru.sideru_backend.exception.ResourceNotFoundException;
import com.sideru.sideru_backend.pedido.PedidoRepository;
import com.sideru.sideru_backend.pedido.entity.Pedido;
import com.sideru.sideru_backend.producto.Producto;
import com.sideru.sideru_backend.producto.ProductoRepository;
import com.sideru.sideru_backend.usuario.entity.Usuario;
import com.sideru.sideru_backend.usuario.entity.Rol;
import com.sideru.sideru_backend.usuario.entity.TipoUsuario;
import com.sideru.sideru_backend.usuario.UsuarioRepository;
import com.sideru.sideru_backend.usuario.RolRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Clase de pruebas de integración para CotizacionService.
 * Utiliza la base de datos en memoria H2 real (con transacciones que se revierten automáticamente).
 */
@SpringBootTest
@Transactional
public class CotizacionServiceTest {

    @Autowired
    private CotizacionRepository cotizacionRepository;

    @Autowired
    private ClienteRepository clienteRepository;

    @Autowired
    private ProductoRepository productoRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private RolRepository rolRepository;

    @Autowired
    private CotizacionService cotizacionService;

    @Autowired
    private PedidoRepository pedidoRepository;

    // Entidades reales guardadas en H2 para las pruebas
    private Usuario mockUsuario;
    private Cliente mockCliente;
    private Producto mockProducto;

    /**
     * Configuración inicial antes de cada prueba.
     * Guarda objetos reales en la base de datos H2.
     */
    @BeforeEach
    void setUp() {
        // Crear y guardar Rol
        Rol rol = Rol.builder()
                .nombre("CLIENTE")
                .descripcion("Rol para clientes")
                .build();
        rol = rolRepository.save(rol);

        // 2. Crear y guardar Usuario
        mockUsuario = Usuario.builder()
                .tipo(TipoUsuario.CLIENTE)
                .username("testclient")
                .email("testclient@sideru.com")
                .passwordHash("password_hash")
                .rol(rol)
                .activo(true)
                .build();
        mockUsuario = usuarioRepository.save(mockUsuario);

        // Crear y guardar Cliente
        mockCliente = Cliente.builder()
                .nombre("Juan")
                .apellido("Perez")
                .razonSocial(null) // Esto provoca que el servicio use "Juan Perez" en el mapeo
                .usuario(mockUsuario)
                .activo(true)
                .build();
        mockCliente = clienteRepository.save(mockCliente);

        // Crear y guardar Producto de prueba: Precio S/ 10.00 y stock mínimo de 20 unidades
        mockProducto = new Producto();
        mockProducto.setSku("PROD01");
        mockProducto.setNombre("Clavos de Acero");
        mockProducto.setPrecio(BigDecimal.valueOf(10.00));
        mockProducto.setStock(100);
        mockProducto.setStockMinimo(20);
        mockProducto.setActivo(true);
        mockProducto = productoRepository.save(mockProducto);
    }

    /**
     * Prueba: Aceptación automática de cotización.
     * El estado debe ser "aceptada"
     */
    @Test
    void crearCotizacion_Exito_AceptadaAutomaticamente() {
        // ARRANGE (Preparación) 
        CotizacionItemRequest item = new CotizacionItemRequest("PROD01", 15);
        CotizacionRequest request = new CotizacionRequest("Observacion de prueba", List.of(item));

        // ACT (Ejecución)
        CotizacionResponse response = cotizacionService.crearCotizacion(request, mockUsuario);

        // ASSERT (Verificación)
        assertNotNull(response);
        assertTrue(response.id() > 0);
        assertEquals("Juan Perez", response.cliente());
        assertEquals("aceptada", response.estado().toLowerCase()); // Debe auto-aceptarse
        
        // Subtotal = 10.00 * 15 = 150.00
        // IGV (18%) = 150.00 * 0.18 = 27.00
        // Total = 150.00 + 27.00 = 177.00
        assertEquals(0, response.subtotal().compareTo(BigDecimal.valueOf(150.00)));
        assertEquals(0, response.igv().compareTo(BigDecimal.valueOf(27.00)));
        assertEquals(0, response.total().compareTo(BigDecimal.valueOf(177.00)));
        assertEquals(1, response.detalles().size());
        assertEquals("PROD01", response.detalles().get(0).sku());

        // verif persistencia en base de datos H2
        Optional<Cotizacion> savedCotizacionOpt = cotizacionRepository.findById(response.id());
        assertTrue(savedCotizacionOpt.isPresent());
        Cotizacion savedCotizacion = savedCotizacionOpt.get();
        assertEquals(EstadoCotizacion.aceptada, savedCotizacion.getEstado());
        assertEquals(0, savedCotizacion.getTotal().compareTo(BigDecimal.valueOf(177.00)));

        Optional<Pedido> savedPedidoOpt = pedidoRepository.findByCotizacionId(response.id());
        assertTrue(savedPedidoOpt.isPresent());
        assertEquals("pendiente", savedPedidoOpt.get().getEstado().name());
    }

    /**
     * Prueba: Envío para revisión manual por exceso de stock mínimo.
     * Caso: Cantidad solicitada (25) supera el stock mínimo (20).
     * El estado debe quedar en "enviada" para que un vendedor o gerente la apruebe.
     */
    @Test
    void crearCotizacion_Exito_EnviadaPorExcesoStockMinimo() {
        // ARRANGE (Preparación) ---
        CotizacionItemRequest item = new CotizacionItemRequest("PROD01", 25); // 25 > 20 stock mínimo
        CotizacionRequest request = new CotizacionRequest("Prueba exceso stock", List.of(item));

        // ACT (Ejecución) ---
        CotizacionResponse response = cotizacionService.crearCotizacion(request, mockUsuario);

        // ASSERT (Verificación) ---
        assertNotNull(response);
        assertEquals("enviada", response.estado().toLowerCase()); // Estado correcto

        // Verificar persistencia en base de datos H2
        Optional<Cotizacion> savedCotizacionOpt = cotizacionRepository.findById(response.id());
        assertTrue(savedCotizacionOpt.isPresent());
        assertEquals(EstadoCotizacion.enviada, savedCotizacionOpt.get().getEstado());
        assertFalse(pedidoRepository.existsByCotizacionId(response.id()));
    }

    /**
     * Prueba: al aceptar manualmente una cotizaciÃ³n enviada, se genera su pedido pendiente.
     */
    @Test
    void aceptarCotizacion_GeneraPedidoPendiente() {
        CotizacionItemRequest item = new CotizacionItemRequest("PROD01", 25);
        CotizacionRequest request = new CotizacionRequest("Prueba aceptacion manual", List.of(item));
        CotizacionResponse enviada = cotizacionService.crearCotizacion(request, mockUsuario);

        CotizacionResponse aceptada = cotizacionService.aceptarCotizacion(enviada.id());

        assertEquals("aceptada", aceptada.estado().toLowerCase());
        Optional<Pedido> savedPedidoOpt = pedidoRepository.findByCotizacionId(aceptada.id());
        assertTrue(savedPedidoOpt.isPresent());
        assertEquals("pendiente", savedPedidoOpt.get().getEstado().name());
    }

    /**
     * Prueba: Cliente inexistente lanza excepción.
     * Caso: El usuario autenticado no tiene un cliente vinculado.
     * Debe lanzar una excepción del tipo ResourceNotFoundException.
     */
    @Test
    void crearCotizacion_ClienteNoEncontrado_LanzaExcepcion() {
        // --- 1. ARRANGE (Preparación) ---
        // Crear un usuario ficticio que no tenga cliente
        Usuario sinClienteUsuario = Usuario.builder()
                .tipo(TipoUsuario.CLIENTE)
                .username("noclient")
                .email("noclient@sideru.com")
                .passwordHash("password_hash")
                .rol(mockUsuario.getRol())
                .activo(true)
                .build();
        final Usuario targetUser = usuarioRepository.save(sinClienteUsuario);

        CotizacionItemRequest item = new CotizacionItemRequest("PROD01", 10);
        CotizacionRequest request = new CotizacionRequest("Prueba cliente no existe", List.of(item));

        // --- 2. ACT & ASSERT (Ejecución y Verificación conjunta) ---
        assertThrows(ResourceNotFoundException.class, () -> {
            cotizacionService.crearCotizacion(request, targetUser);
        });
    }

    /**
     * Prueba: SKU de producto no encontrado lanza excepción.
     * Caso: Uno de los SKU enviados en el carrito no existe en el catálogo.
     * Debe lanzar una excepción del tipo ResourceNotFoundException.
     */
    @Test
    void crearCotizacion_ProductoNoEncontrado_LanzaExcepcion() {
        // --- 1. ARRANGE (Preparación) ---
        CotizacionItemRequest item = new CotizacionItemRequest("PROD_INEXISTENTE", 10);
        CotizacionRequest request = new CotizacionRequest("Prueba producto no existe", List.of(item));

        // --- 2. ACT & ASSERT (Ejecución y Verificación conjunta) ---
        assertThrows(ResourceNotFoundException.class, () -> {
            cotizacionService.crearCotizacion(request, mockUsuario);
        });
    }
}
