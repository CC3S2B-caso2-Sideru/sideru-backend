package com.sideru.sideru_backend.pedido;

import com.sideru.sideru_backend.cliente.Cliente;
import com.sideru.sideru_backend.cliente.ClienteRepository;
import com.sideru.sideru_backend.cotizacion.CotizacionRepository;
import com.sideru.sideru_backend.cotizacion.entity.Cotizacion;
import com.sideru.sideru_backend.cotizacion.entity.CotizacionDetalle;
import com.sideru.sideru_backend.cotizacion.entity.EstadoCotizacion;
import com.sideru.sideru_backend.exception.DuplicateResourceException;
import com.sideru.sideru_backend.exception.ForbiddenException;
import com.sideru.sideru_backend.exception.ResourceNotFoundException;
import com.sideru.sideru_backend.pedido.dto.PagoSimuladoRequest;
import com.sideru.sideru_backend.pedido.dto.PedidoDetalleResponse;
import com.sideru.sideru_backend.pedido.dto.PedidoResponse;
import com.sideru.sideru_backend.pedido.entity.EstadoPedido;
import com.sideru.sideru_backend.pedido.entity.Pedido;
import com.sideru.sideru_backend.pedido.entity.PedidoDetalle;
import com.sideru.sideru_backend.usuario.entity.Usuario;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class PedidoService {

    private final PedidoRepository pedidoRepository;
    private final CotizacionRepository cotizacionRepository;
    private final ClienteRepository clienteRepository;

    @Transactional
    public PedidoResponse crearDesdeCotizacion(Integer cotizacionId) {
        Cotizacion cotizacion = cotizacionRepository.findById(cotizacionId)
                .orElseThrow(() -> new ResourceNotFoundException("Cotizacion", cotizacionId.toString()));

        if (cotizacion.getEstado() != EstadoCotizacion.aceptada) {
            throw new IllegalStateException("Solo se puede generar pedido desde una cotizacion aceptada");
        }

        if (pedidoRepository.existsByCotizacionId(cotizacionId)) {
            throw new DuplicateResourceException("Pedido", "cotizacion", cotizacionId.toString());
        }

        Pedido pedido = Pedido.builder()
                .cotizacion(cotizacion)
                .cliente(cotizacion.getCliente())
                .estado(EstadoPedido.pendiente)
                .total(cotizacion.getTotal())
                .build();

        List<PedidoDetalle> detalles = new ArrayList<>();
        for (CotizacionDetalle detalleCotizacion : cotizacion.getDetalles()) {
            PedidoDetalle detalle = PedidoDetalle.builder()
                    .pedido(pedido)
                    .producto(detalleCotizacion.getProducto())
                    .cantidad(detalleCotizacion.getCantidad())
                    .precioUnitario(detalleCotizacion.getPrecioUnitario())
                    .descuento(detalleCotizacion.getDescuento())
                    .subtotal(detalleCotizacion.getSubtotal())
                    .build();
            detalles.add(detalle);
        }
        pedido.setDetalles(detalles);

        return mapearAResponse(pedidoRepository.save(pedido));
    }

    @Transactional(readOnly = true)
    public List<PedidoResponse> listarMisPedidos(Usuario usuario) {
        Cliente cliente = clienteRepository.findByUsuario(usuario)
                .orElseThrow(() -> new ResourceNotFoundException("Cliente", usuario.getId().toString()));

        return pedidoRepository.findAllByClienteIdOrderByFechaPedidoDesc(cliente.getId())
                .stream()
                .map(this::mapearAResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<PedidoResponse> listarTodos() {
        return pedidoRepository.findAllByOrderByFechaPedidoDesc()
                .stream()
                .map(this::mapearAResponse)
                .toList();
    }

    @Transactional
    public PedidoResponse registrarPagoSimulado(Integer pedidoId, PagoSimuladoRequest request, Usuario usuario) {
        Pedido pedido = pedidoRepository.findById(pedidoId)
                .orElseThrow(() -> new ResourceNotFoundException("Pedido", pedidoId.toString()));

        Cliente cliente = clienteRepository.findByUsuario(usuario)
                .orElseThrow(() -> new ResourceNotFoundException("Cliente", usuario.getId().toString()));

        if (!pedido.getCliente().getId().equals(cliente.getId())) {
            throw new ForbiddenException("No puedes pagar un pedido de otro cliente");
        }

        if (pedido.getEstado() != EstadoPedido.pendiente) {
            throw new IllegalStateException("Solo se pueden pagar pedidos pendientes");
        }

        pedido.setEstado(EstadoPedido.confirmado);
        return mapearAResponse(pedidoRepository.save(pedido));
    }

    private PedidoResponse mapearAResponse(Pedido pedido) {
        List<PedidoDetalleResponse> detalles = pedido.getDetalles().stream()
                .map(d -> new PedidoDetalleResponse(
                        d.getId(),
                        d.getProducto().getSku(),
                        d.getProducto().getNombre(),
                        d.getCantidad(),
                        d.getPrecioUnitario(),
                        d.getDescuento(),
                        d.getSubtotal()
                ))
                .toList();

        String nombreCliente = pedido.getCliente().getRazonSocial() != null
                ? pedido.getCliente().getRazonSocial()
                : pedido.getCliente().getNombre() + " " + (pedido.getCliente().getApellido() != null ? pedido.getCliente().getApellido() : "");

        return new PedidoResponse(
                pedido.getId(),
                pedido.getCotizacion().getId(),
                pedido.getFechaPedido(),
                pedido.getEstado().name(),
                pedido.getMotivoRechazo(),
                pedido.getTotal(),
                nombreCliente.trim(),
                detalles
        );
    }
}
