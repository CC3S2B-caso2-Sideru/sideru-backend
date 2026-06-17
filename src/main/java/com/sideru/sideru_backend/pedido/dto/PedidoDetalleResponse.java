package com.sideru.sideru_backend.pedido.dto;

import java.math.BigDecimal;

public record PedidoDetalleResponse(
        Integer id,
        String sku,
        String productoNombre,
        Integer cantidad,
        BigDecimal precioUnitario,
        BigDecimal descuento,
        BigDecimal subtotal
) {
}
