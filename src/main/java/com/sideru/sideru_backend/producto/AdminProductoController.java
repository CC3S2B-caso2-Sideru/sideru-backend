package com.sideru.sideru_backend.producto;

import com.sideru.sideru_backend.producto.dto.ProductoAdminResponse;
import com.sideru.sideru_backend.producto.dto.ProductoRequest;
import com.sideru.sideru_backend.producto.dto.StockAdjustmentRequest;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/admin/productos")
@Tag(name = "Admin Productos", description = "Gestión de productos (admin/almacenero/gerente)")
public class AdminProductoController {

    private final ProductoService productoService;

    public AdminProductoController(ProductoService productoService) {
        this.productoService = productoService;
    }

    @GetMapping
    @PreAuthorize("hasAuthority('stock.ver')")
    @Operation(summary = "Listar productos con filtros y paginación")
    public ResponseEntity<Page<ProductoAdminResponse>> listarTodos(
            @RequestParam(required = false) String search,
            @RequestParam(required = false) Integer categoriaId,
            @RequestParam(required = false) Boolean activo,
            @PageableDefault(size = 12, sort = "updatedAt",
                    direction = org.springframework.data.domain.Sort.Direction.DESC
            ) Pageable pageable
    ) {
        return ResponseEntity.ok(productoService.findAllAdmin(search, categoriaId, activo, pageable));
    }

    @GetMapping("/stock-bajo")
    @PreAuthorize("hasAuthority('stock.ver')")
    @Operation(summary = "Productos con stock bajo o crítico (stock ≤ umbral auto-aprobación)")
    public ResponseEntity<List<ProductoAdminResponse>> listarStockBajo() {
        return ResponseEntity.ok(productoService.findStockBajo());
    }

    @GetMapping("/{sku}")
    @PreAuthorize("hasAuthority('stock.ver')")
    @Operation(summary = "Obtener un producto por SKU")
    public ResponseEntity<ProductoAdminResponse> obtenerPorSku(@PathVariable String sku) {
        return ResponseEntity.ok(productoService.findBySkuAdmin(sku));
    }

    @PostMapping
    @PreAuthorize("hasAuthority('stock.editar')")
    @Operation(summary = "Crear un nuevo producto")
    public ResponseEntity<ProductoAdminResponse> crear(@Valid @RequestBody ProductoRequest request) {
        ProductoAdminResponse response = productoService.create(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PutMapping("/{sku}")
    @PreAuthorize("hasAuthority('stock.editar')")
    @Operation(summary = "Actualizar un producto existente")
    public ResponseEntity<ProductoAdminResponse> actualizar(
            @PathVariable String sku, @Valid @RequestBody ProductoRequest request) {
        return ResponseEntity.ok(productoService.update(sku, request));
    }

    @PatchMapping("/{sku}/activar")
    @PreAuthorize("hasAuthority('stock.editar')")
    @Operation(summary = "Activar o desactivar un producto")
    public ResponseEntity<ProductoAdminResponse> toggleActivo(@PathVariable String sku) {
        return ResponseEntity.ok(productoService.toggleActive(sku));
    }

    @PatchMapping("/{sku}/stock")
    @PreAuthorize("hasAuthority('stock.editar')")
    @Operation(summary = "Ajustar el stock de un producto (cantidad positiva = añadir, negativa = retirar)")
    public ResponseEntity<ProductoAdminResponse> ajustarStock(
            @PathVariable String sku, @Valid @RequestBody StockAdjustmentRequest request) {
        return ResponseEntity.ok(productoService.adjustStock(sku, request.cantidad()));
    }
}
