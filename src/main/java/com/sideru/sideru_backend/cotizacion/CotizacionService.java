package com.sideru.sideru_backend.cotizacion;

import com.sideru.sideru_backend.cliente.Cliente;
import com.sideru.sideru_backend.cliente.ClienteRepository;
import com.sideru.sideru_backend.cotizacion.dto.*;
import com.sideru.sideru_backend.cotizacion.entity.Cotizacion;
import com.sideru.sideru_backend.cotizacion.entity.CotizacionDetalle;
import com.sideru.sideru_backend.cotizacion.entity.EstadoCotizacion;
import com.sideru.sideru_backend.cotizacion.CotizacionRepository;
import com.sideru.sideru_backend.exception.ResourceNotFoundException;
import com.sideru.sideru_backend.producto.Producto;
import com.sideru.sideru_backend.producto.ProductoRepository;
import com.sideru.sideru_backend.usuario.entity.Usuario;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CotizacionService {

    private final CotizacionRepository cotizacionRepository;
    private final ClienteRepository clienteRepository;
    private final ProductoRepository productoRepository;

    @Transactional
    public CotizacionResponse crearCotizacion(CotizacionRequest request, Usuario usuario) {
        // Obtener cliente asociado al usuario logueado
        Cliente cliente = clienteRepository.findByUsuario(usuario)
                .orElseThrow(() -> new ResourceNotFoundException("Cliente", usuario.getId().toString()));

        // Instanciar la cabecera (estado se asigna después de verificar stockMinimo)
        Cotizacion cotizacion = Cotizacion.builder()
                .cliente(cliente)
                .fechaExpiracion(LocalDate.now().plusDays(7)) // Expira en 7 días
                .observaciones(request.observaciones())
                .build();

        BigDecimal subtotalAcumulado = BigDecimal.ZERO;
        boolean excedeStockMinimo = false;

        List<CotizacionDetalle> detalles = new ArrayList<>();

        // Procesar cada producto enviado desde el carrito
        for (CotizacionItemRequest itemReq : request.items()) {
            Producto producto = productoRepository.findBySku(itemReq.sku())
                    .orElseThrow(() -> new ResourceNotFoundException("Producto", itemReq.sku()));

            // Verificar si la cantidad excede el stockMinimo del producto
            Integer minimo = producto.getStockMinimo();
            if (minimo == null || itemReq.cantidad() > minimo) {
                excedeStockMinimo = true;
            }

            // Subtotal del item = precio * cantidad
            BigDecimal precio = producto.getPrecio();
            BigDecimal cantidad = BigDecimal.valueOf(itemReq.cantidad());
            BigDecimal itemSubtotal = precio.multiply(cantidad);

            subtotalAcumulado = subtotalAcumulado.add(itemSubtotal);

            CotizacionDetalle detalle = CotizacionDetalle.builder()
                    .cotizacion(cotizacion)
                    .producto(producto)
                    .cantidad(itemReq.cantidad())
                    .precioUnitario(precio)
                    .subtotal(itemSubtotal)
                    .build();

            detalles.add(detalle);
        }

        // IGV: 18% sobre la base imponible (subtotal). Total = subtotal + IGV.
        BigDecimal subtotal = subtotalAcumulado;
        BigDecimal igv = subtotal.multiply(BigDecimal.valueOf(0.18)).setScale(2, RoundingMode.HALF_UP);
        BigDecimal total = subtotal.add(igv);

        // Si ningún item excede stockMinimo → aceptada automáticamente
        // Si algún item excede → enviada (pendiente revisión manual)
        cotizacion.setEstado(excedeStockMinimo
                ? EstadoCotizacion.enviada
                : EstadoCotizacion.aceptada);

        cotizacion.setSubtotal(subtotal);
        cotizacion.setIgv(igv);
        cotizacion.setTotal(total);
        cotizacion.setDetalles(detalles);

        // Guardar en Base de Datos
        Cotizacion guardada = cotizacionRepository.save(cotizacion);

        return mapearAResponse(guardada);
    }

    @Transactional(readOnly = true)
    public List<CotizacionResponse> listarMisCotizaciones(Usuario usuario) {
        Cliente cliente = clienteRepository.findByUsuario(usuario)
                .orElseThrow(() -> new ResourceNotFoundException("Cliente", usuario.getId().toString()));

        return cotizacionRepository.findAllByClienteIdOrderByFechaEmisionDesc(cliente.getId())
                .stream()
                .map(this::mapearAResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<CotizacionResponse> listarTodas() {
        return cotizacionRepository.findAllByOrderByFechaEmisionDesc()
                .stream()
                .map(this::mapearAResponse)
                .toList();
    }

    @Transactional
    public CotizacionResponse aceptarCotizacion(Integer id) {
        Cotizacion cotizacion = cotizacionRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Cotizacion", id.toString()));

        if (cotizacion.getEstado() != EstadoCotizacion.enviada) {
            throw new IllegalStateException("Solo se pueden aceptar cotizaciones en estado enviada");
        }

        cotizacion.setEstado(EstadoCotizacion.aceptada);
        return mapearAResponse(cotizacionRepository.save(cotizacion));
    }

    @Transactional
    public CotizacionResponse rechazarCotizacion(Integer id) {
        Cotizacion cotizacion = cotizacionRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Cotizacion", id.toString()));

        if (cotizacion.getEstado() != EstadoCotizacion.enviada) {
            throw new IllegalStateException("Solo se pueden rechazar cotizaciones en estado enviada");
        }

        cotizacion.setEstado(EstadoCotizacion.rechazada);
        return mapearAResponse(cotizacionRepository.save(cotizacion));
    }

    private CotizacionResponse mapearAResponse(Cotizacion c) {
        List<CotizacionDetalleResponse> detallesResponse = c.getDetalles().stream()
                .map(d -> new CotizacionDetalleResponse(
                        d.getId(),
                        d.getProducto().getSku(),
                        d.getProducto().getNombre(),
                        d.getCantidad(),
                        d.getPrecioUnitario(),
                        d.getDescuento(),
                        d.getSubtotal()
                )).toList();

        String nombreCliente = c.getCliente().getRazonSocial() != null
                ? c.getCliente().getRazonSocial()
                : c.getCliente().getNombre() + " " + (c.getCliente().getApellido() != null ? c.getCliente().getApellido() : "");

        return new CotizacionResponse(
                c.getId(),
                c.getFechaEmision(),
                c.getFechaExpiracion(),
                c.getEstado().name(),
                c.getObservaciones(),
                c.getSubtotal(),
                c.getIgv(),
                c.getTotal(),
                nombreCliente.trim(),
                detallesResponse
        );
    }
}
