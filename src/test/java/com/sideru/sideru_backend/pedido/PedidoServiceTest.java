package com.sideru.sideru_backend.pedido;

import com.sideru.sideru_backend.cliente.Cliente;
import com.sideru.sideru_backend.cliente.ClienteRepository;
import com.sideru.sideru_backend.cotizacion.CotizacionRepository;
import com.sideru.sideru_backend.cotizacion.entity.Cotizacion;
import com.sideru.sideru_backend.cotizacion.entity.CotizacionDetalle;
import com.sideru.sideru_backend.cotizacion.entity.EstadoCotizacion;
import com.sideru.sideru_backend.exception.DuplicateResourceException;
import com.sideru.sideru_backend.exception.ForbiddenException;
import com.sideru.sideru_backend.pedido.dto.PagoSimuladoRequest;
import com.sideru.sideru_backend.pedido.dto.PedidoResponse;
import com.sideru.sideru_backend.pedido.entity.EstadoPedido;
import com.sideru.sideru_backend.pedido.entity.Pedido;
import com.sideru.sideru_backend.producto.Producto;
import com.sideru.sideru_backend.usuario.entity.Usuario;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class PedidoServiceTest {

    @Mock
    private PedidoRepository pedidoRepository;

    @Mock
    private CotizacionRepository cotizacionRepository;

    @Mock
    private ClienteRepository clienteRepository;

    @InjectMocks
    private PedidoService pedidoService;

    private Cliente cliente;
    private Usuario usuario;
    private Producto producto;
    private Cotizacion cotizacionAceptada;

    @BeforeEach
    void setUp() {
        usuario = Usuario.builder()
                .id(10)
                .username("cliente_demo")
                .email("cliente@sideru.test")
                .build();

        cliente = Cliente.builder()
                .id(20)
                .usuario(usuario)
                .razonSocial("Acero Sur")
                .nombre("Acero")
                .apellido("Sur")
                .build();

        producto = new Producto();
        producto.setId(30);
        producto.setSku("PER-ANG-001");
        producto.setNombre("Angulo 2x2");
        producto.setPrecio(new BigDecimal("35.00"));

        cotizacionAceptada = Cotizacion.builder()
                .id(40)
                .cliente(cliente)
                .estado(EstadoCotizacion.aceptada)
                .subtotal(new BigDecimal("70.00"))
                .igv(new BigDecimal("12.60"))
                .total(new BigDecimal("82.60"))
                .build();

        CotizacionDetalle detalle = CotizacionDetalle.builder()
                .id(50)
                .cotizacion(cotizacionAceptada)
                .producto(producto)
                .cantidad(2)
                .precioUnitario(new BigDecimal("35.00"))
                .descuento(BigDecimal.ZERO)
                .subtotal(new BigDecimal("70.00"))
                .build();

        cotizacionAceptada.setDetalles(List.of(detalle));
    }

    @Test
    void creaPedidoDesdeCotizacionAceptada() {
        when(cotizacionRepository.findById(40)).thenReturn(Optional.of(cotizacionAceptada));
        when(pedidoRepository.existsByCotizacionId(40)).thenReturn(false);
        when(pedidoRepository.save(any(Pedido.class))).thenAnswer(invocation -> {
            Pedido pedido = invocation.getArgument(0);
            pedido.setId(60);
            return pedido;
        });

        PedidoResponse response = pedidoService.crearDesdeCotizacion(40);

        assertThat(response.id()).isEqualTo(60);
        assertThat(response.cotizacionId()).isEqualTo(40);
        assertThat(response.estado()).isEqualTo("pendiente");
        assertThat(response.total()).isEqualByComparingTo("82.60");
        assertThat(response.cliente()).isEqualTo("Acero Sur");
        assertThat(response.detalles()).hasSize(1);
        assertThat(response.detalles().getFirst().sku()).isEqualTo("PER-ANG-001");
        assertThat(response.detalles().getFirst().cantidad()).isEqualTo(2);

        verify(pedidoRepository).save(argThat(pedido ->
                pedido.getCotizacion().getId().equals(40)
                        && pedido.getCliente().getId().equals(20)
                        && pedido.getEstado() == EstadoPedido.pendiente
                        && pedido.getDetalles().size() == 1
        ));
    }

    @Test
    void noCreaPedidoDesdeCotizacionNoAceptada() {
        cotizacionAceptada.setEstado(EstadoCotizacion.enviada);
        when(cotizacionRepository.findById(40)).thenReturn(Optional.of(cotizacionAceptada));

        assertThatThrownBy(() -> pedidoService.crearDesdeCotizacion(40))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("cotizacion aceptada");

        verify(pedidoRepository, never()).save(any());
    }

    @Test
    void noCreaPedidoDuplicadoParaMismaCotizacion() {
        when(cotizacionRepository.findById(40)).thenReturn(Optional.of(cotizacionAceptada));
        when(pedidoRepository.existsByCotizacionId(40)).thenReturn(true);

        assertThatThrownBy(() -> pedidoService.crearDesdeCotizacion(40))
                .isInstanceOf(DuplicateResourceException.class);

        verify(pedidoRepository, never()).save(any());
    }

    @Test
    void registrarPagoSimuladoConfirmaPedidoPendienteDelCliente() {
        Pedido pedido = Pedido.builder()
                .id(60)
                .cotizacion(cotizacionAceptada)
                .cliente(cliente)
                .estado(EstadoPedido.pendiente)
                .total(new BigDecimal("82.60"))
                .detalles(List.of(PedidoTestData.detalleDesdeCotizacion(cotizacionAceptada.getDetalles().getFirst())))
                .build();
        pedido.getDetalles().getFirst().setPedido(pedido);

        when(pedidoRepository.findById(60)).thenReturn(Optional.of(pedido));
        when(clienteRepository.findByUsuario(usuario)).thenReturn(Optional.of(cliente));
        when(pedidoRepository.save(any(Pedido.class))).thenAnswer(invocation -> invocation.getArgument(0));

        PedidoResponse response = pedidoService.registrarPagoSimulado(
                60,
                new PagoSimuladoRequest("transferencia", "OP-123"),
                usuario
        );

        assertThat(response.estado()).isEqualTo("confirmado");
        verify(pedidoRepository).save(argThat(p -> p.getEstado() == EstadoPedido.confirmado));
    }

    @Test
    void noPermitePagarPedidoDeOtroCliente() {
        Cliente otroCliente = Cliente.builder()
                .id(99)
                .nombre("Otro")
                .apellido("Cliente")
                .build();
        Pedido pedido = Pedido.builder()
                .id(60)
                .cotizacion(cotizacionAceptada)
                .cliente(otroCliente)
                .estado(EstadoPedido.pendiente)
                .total(new BigDecimal("82.60"))
                .build();

        when(pedidoRepository.findById(60)).thenReturn(Optional.of(pedido));
        when(clienteRepository.findByUsuario(usuario)).thenReturn(Optional.of(cliente));

        assertThatThrownBy(() -> pedidoService.registrarPagoSimulado(60, new PagoSimuladoRequest(null, null), usuario))
                .isInstanceOf(ForbiddenException.class);

        verify(pedidoRepository, never()).save(any());
    }

    @Test
    void noPermitePagarPedidoQueNoEstaPendiente() {
        Pedido pedido = Pedido.builder()
                .id(60)
                .cotizacion(cotizacionAceptada)
                .cliente(cliente)
                .estado(EstadoPedido.confirmado)
                .total(new BigDecimal("82.60"))
                .build();

        when(pedidoRepository.findById(60)).thenReturn(Optional.of(pedido));
        when(clienteRepository.findByUsuario(usuario)).thenReturn(Optional.of(cliente));

        assertThatThrownBy(() -> pedidoService.registrarPagoSimulado(60, new PagoSimuladoRequest(null, null), usuario))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("pedidos pendientes");

        verify(pedidoRepository, never()).save(any());
    }

    private static class PedidoTestData {
        static com.sideru.sideru_backend.pedido.entity.PedidoDetalle detalleDesdeCotizacion(CotizacionDetalle detalle) {
            return com.sideru.sideru_backend.pedido.entity.PedidoDetalle.builder()
                    .producto(detalle.getProducto())
                    .cantidad(detalle.getCantidad())
                    .precioUnitario(detalle.getPrecioUnitario())
                    .descuento(detalle.getDescuento())
                    .subtotal(detalle.getSubtotal())
                    .build();
        }
    }
}
