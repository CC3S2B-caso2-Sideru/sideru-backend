package com.sideru.sideru_backend.producto;

import com.sideru.sideru_backend.categoria.Categoria;
import com.sideru.sideru_backend.categoria.CategoriaRepository;
import com.sideru.sideru_backend.exception.ResourceNotFoundException;
import com.sideru.sideru_backend.producto.dto.ProductoAdminResponse;
import com.sideru.sideru_backend.producto.dto.ProductoRequest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ProductoServiceTest {

    @Mock private ProductoRepository productoRepository;
    @Mock private ProductoMapper productoMapper;
    @Mock private CategoriaRepository categoriaRepository;

    @InjectMocks
    private ProductoService productoService;

    private Producto producto;
    private Categoria categoria;
    private ProductoAdminResponse adminResponse;

    @BeforeEach
    void setUp() {
        categoria = new Categoria();
        categoria.setId(1);
        categoria.setNombre("Aceros");

        producto = new Producto();
        producto.setId(1);
        producto.setSku("TUB-001");
        producto.setNombre("Tubo de acero");
        producto.setDescripcion("Tubo 4 pulgadas");
        producto.setImagen("tubo.jpg");
        producto.setPrecio(new BigDecimal("100.00"));
        producto.setStock(150);
        producto.setStockMinimo(50);
        producto.setActivo(true);
        producto.setCategoria(categoria);

        adminResponse = new ProductoAdminResponse(
                1, "TUB-001", "Tubo de acero", "Tubo 4 pulgadas",
                "tubo.jpg", new BigDecimal("100.00"), 150, 50, true, "Aceros"
        );
    }

    private ProductoRequest request(String sku) {
        return new ProductoRequest(
                sku, "Tubo de acero", "Tubo 4 pulgadas", "tubo.jpg",
                new BigDecimal("100.00"), 150, 50, 1
        );
    }

    @Nested
    class Create {

        @Test
        void shouldCreateProductSuccessfully() {
            ProductoRequest req = request("TUB-001");
            when(productoRepository.findBySku("TUB-001")).thenReturn(Optional.empty());
            when(categoriaRepository.findById(1)).thenReturn(Optional.of(categoria));
            when(productoRepository.save(any(Producto.class))).thenReturn(producto);
            when(productoMapper.toAdminResponse(any(Producto.class))).thenReturn(adminResponse);

            ProductoAdminResponse result = productoService.create(req);

            assertThat(result.sku()).isEqualTo("TUB-001");
            assertThat(result.activo()).isTrue();
            verify(productoRepository).save(any(Producto.class));
        }

        @Test
        void shouldThrowWhenSkuAlreadyExists() {
            ProductoRequest req = request("TUB-001");
            when(productoRepository.findBySku("TUB-001")).thenReturn(Optional.of(producto));

            assertThatThrownBy(() -> productoService.create(req))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Ya existe un producto con el SKU");
        }

        @Test
        void shouldThrowWhenCategoriaNotFound() {
            ProductoRequest req = request("TUB-001");
            when(productoRepository.findBySku("TUB-001")).thenReturn(Optional.empty());
            when(categoriaRepository.findById(1)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> productoService.create(req))
                    .isInstanceOf(ResourceNotFoundException.class)
                    .hasMessageContaining("Categoria");
        }

        @Test
        void shouldDefaultStockMinimoToZeroWhenNull() {
            ProductoRequest req = new ProductoRequest(
                    "TUB-001", "Tubo", null, null,
                    new BigDecimal("100.00"), 150, null, 1
            );
            when(productoRepository.findBySku("TUB-001")).thenReturn(Optional.empty());
            when(categoriaRepository.findById(1)).thenReturn(Optional.of(categoria));
            when(productoRepository.save(any(Producto.class))).thenAnswer(inv -> {
                Producto saved = inv.getArgument(0);
                assertThat(saved.getStockMinimo()).isZero();
                return saved;
            });
            when(productoMapper.toAdminResponse(any(Producto.class))).thenReturn(adminResponse);

            productoService.create(req);
            verify(productoRepository).save(any(Producto.class));
        }

        @Test
        void shouldThrowWhenStockMinimoExceedsStock() {
            ProductoRequest req = new ProductoRequest(
                    "TUB-001", "Tubo", null, null,
                    new BigDecimal("100.00"), 50, 100, 1
            );
            when(productoRepository.findBySku("TUB-001")).thenReturn(Optional.empty());

            assertThatThrownBy(() -> productoService.create(req))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("umbral");
        }
    }

    @Nested
    class Update {

        @Test
        void shouldUpdateProductSuccessfully() {
            ProductoRequest req = request("TUB-002");
            when(productoRepository.findBySku("TUB-001")).thenReturn(Optional.of(producto));
            when(productoRepository.findBySku("TUB-002")).thenReturn(Optional.empty());
            when(categoriaRepository.findById(1)).thenReturn(Optional.of(categoria));
            when(productoRepository.save(any(Producto.class))).thenReturn(producto);
            when(productoMapper.toAdminResponse(any(Producto.class))).thenReturn(adminResponse);

            ProductoAdminResponse result = productoService.update("TUB-001", req);

            assertThat(result).isNotNull();
            verify(productoRepository).save(any(Producto.class));
        }

        @Test
        void shouldThrowWhenProductoNotFound() {
            ProductoRequest req = request("TUB-001");
            when(productoRepository.findBySku("TUB-001")).thenReturn(Optional.empty());

            assertThatThrownBy(() -> productoService.update("TUB-001", req))
                    .isInstanceOf(ResourceNotFoundException.class)
                    .hasMessageContaining("Producto");
        }

        @Test
        void shouldThrowWhenNewSkuAlreadyTaken() {
            ProductoRequest req = request("TUB-002");
            Producto otro = new Producto();
            otro.setSku("TUB-002");
            when(productoRepository.findBySku("TUB-001")).thenReturn(Optional.of(producto));
            when(productoRepository.findBySku("TUB-002")).thenReturn(Optional.of(otro));

            assertThatThrownBy(() -> productoService.update("TUB-001", req))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("Ya existe un producto con el SKU");
            verify(productoRepository, never()).save(any());
        }

        @Test
        void shouldThrowWhenStockMinimoExceedsStock() {
            ProductoRequest req = new ProductoRequest(
                    "TUB-001", "Tubo", null, null,
                    new BigDecimal("100.00"), 50, 100, 1
            );
            when(productoRepository.findBySku("TUB-001")).thenReturn(Optional.of(producto));

            assertThatThrownBy(() -> productoService.update("TUB-001", req))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("umbral");
        }
    }

    @Nested
    class ToggleActive {

        @Test
        void shouldToggleFromTrueToFalse() {
            producto.setActivo(true);
            when(productoRepository.findBySku("TUB-001")).thenReturn(Optional.of(producto));
            when(productoRepository.save(any(Producto.class))).thenAnswer(inv -> inv.getArgument(0));
            ProductoAdminResponse toggled = new ProductoAdminResponse(
                    1, "TUB-001", "Tubo", null, null, BigDecimal.TEN, 150, 50, false, "Aceros"
            );
            when(productoMapper.toAdminResponse(any(Producto.class))).thenReturn(toggled);

            ProductoAdminResponse result = productoService.toggleActive("TUB-001");

            assertThat(result.activo()).isFalse();
        }

        @Test
        void shouldToggleFromFalseToTrue() {
            producto.setActivo(false);
            when(productoRepository.findBySku("TUB-001")).thenReturn(Optional.of(producto));
            when(productoRepository.save(any(Producto.class))).thenAnswer(inv -> inv.getArgument(0));
            ProductoAdminResponse toggled = new ProductoAdminResponse(
                    1, "TUB-001", "Tubo", null, null, BigDecimal.TEN, 150, 50, true, "Aceros"
            );
            when(productoMapper.toAdminResponse(any(Producto.class))).thenReturn(toggled);

            ProductoAdminResponse result = productoService.toggleActive("TUB-001");

            assertThat(result.activo()).isTrue();
        }

        @Test
        void shouldThrowWhenProductoNotFound() {
            when(productoRepository.findBySku("NONEXISTENT")).thenReturn(Optional.empty());

            assertThatThrownBy(() -> productoService.toggleActive("NONEXISTENT"))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void shouldToggleNullActivoToTrue() {
            producto.setActivo(null);
            when(productoRepository.findBySku("TUB-001")).thenReturn(Optional.of(producto));
            when(productoRepository.save(any(Producto.class))).thenAnswer(inv -> inv.getArgument(0));
            ProductoAdminResponse toggled = new ProductoAdminResponse(
                    1, "TUB-001", "Tubo", null, null, BigDecimal.TEN, 150, 50, true, "Aceros"
            );
            when(productoMapper.toAdminResponse(any(Producto.class))).thenReturn(toggled);

            ProductoAdminResponse result = productoService.toggleActive("TUB-001");

            assertThat(result.activo()).isTrue();
        }
    }

    @Nested
    class AdjustStock {

        @Test
        void shouldAddStock() {
            producto.setStock(100);
            when(productoRepository.findBySku("TUB-001")).thenReturn(Optional.of(producto));
            when(productoRepository.save(any(Producto.class))).thenAnswer(inv -> inv.getArgument(0));
            ProductoAdminResponse adjusted = new ProductoAdminResponse(
                    1, "TUB-001", "Tubo", null, null, BigDecimal.TEN, 130, 50, true, "Aceros"
            );
            when(productoMapper.toAdminResponse(any(Producto.class))).thenReturn(adjusted);

            ProductoAdminResponse result = productoService.adjustStock("TUB-001", 30);

            assertThat(result.stock()).isEqualTo(130);
        }

        @Test
        void shouldSubtractStock() {
            producto.setStock(100);
            when(productoRepository.findBySku("TUB-001")).thenReturn(Optional.of(producto));
            when(productoRepository.save(any(Producto.class))).thenAnswer(inv -> inv.getArgument(0));
            ProductoAdminResponse adjusted = new ProductoAdminResponse(
                    1, "TUB-001", "Tubo", null, null, BigDecimal.TEN, 80, 50, true, "Aceros"
            );
            when(productoMapper.toAdminResponse(any(Producto.class))).thenReturn(adjusted);

            ProductoAdminResponse result = productoService.adjustStock("TUB-001", -20);

            assertThat(result.stock()).isEqualTo(80);
        }

        @Test
        void shouldThrowWhenStockGoesNegative() {
            producto.setStock(10);
            when(productoRepository.findBySku("TUB-001")).thenReturn(Optional.of(producto));

            assertThatThrownBy(() -> productoService.adjustStock("TUB-001", -20))
                    .isInstanceOf(IllegalArgumentException.class)
                    .hasMessageContaining("stock no puede ser negativo");
            verify(productoRepository, never()).save(any());
        }

        @Test
        void shouldThrowWhenProductoNotFound() {
            when(productoRepository.findBySku("NONEXISTENT")).thenReturn(Optional.empty());

            assertThatThrownBy(() -> productoService.adjustStock("NONEXISTENT", 10))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class FindBySkuAdmin {

        @Test
        void shouldReturnProductoWhenFound() {
            when(productoRepository.findBySku("TUB-001")).thenReturn(Optional.of(producto));
            when(productoMapper.toAdminResponse(producto)).thenReturn(adminResponse);

            ProductoAdminResponse result = productoService.findBySkuAdmin("TUB-001");

            assertThat(result.sku()).isEqualTo("TUB-001");
            assertThat(result.categoria()).isEqualTo("Aceros");
        }

        @Test
        void shouldThrowWhenNotFound() {
            when(productoRepository.findBySku("NONEXISTENT")).thenReturn(Optional.empty());

            assertThatThrownBy(() -> productoService.findBySkuAdmin("NONEXISTENT"))
                    .isInstanceOf(ResourceNotFoundException.class)
                    .hasMessageContaining("Producto");
        }
    }

    @Nested
    class FindStockBajo {

        @Test
        void shouldReturnListOfLowStockProducts() {
            when(productoRepository.findStockBajo()).thenReturn(List.of(producto));
            when(productoMapper.toAdminResponse(producto)).thenReturn(adminResponse);

            List<ProductoAdminResponse> result = productoService.findStockBajo();

            assertThat(result).hasSize(1);
            assertThat(result.get(0).sku()).isEqualTo("TUB-001");
        }

        @Test
        void shouldReturnEmptyListWhenNoLowStock() {
            when(productoRepository.findStockBajo()).thenReturn(Collections.emptyList());

            List<ProductoAdminResponse> result = productoService.findStockBajo();

            assertThat(result).isEmpty();
        }
    }

    @Nested
    class FindAllAdmin {

        @Test
        void shouldReturnPaginatedProducts() {
            PageRequest pageable = PageRequest.of(0, 12);
            Page<Producto> page = new PageImpl<>(List.of(producto), pageable, 1);
            when(productoRepository.findAdminByFilters(null, null, null, pageable)).thenReturn(page);
            when(productoMapper.toAdminResponse(producto)).thenReturn(adminResponse);

            Page<ProductoAdminResponse> result = productoService.findAllAdmin(null, null, null, pageable);

            assertThat(result.getContent()).hasSize(1);
            assertThat(result.getTotalElements()).isEqualTo(1);
        }

        @Test
        void shouldPassFiltersToRepository() {
            PageRequest pageable = PageRequest.of(0, 12);
            Page<Producto> page = new PageImpl<>(List.of(), pageable, 0);
            when(productoRepository.findAdminByFilters("tubo", 1, true, pageable)).thenReturn(page);

            productoService.findAllAdmin("tubo", 1, true, pageable);

            verify(productoRepository).findAdminByFilters("tubo", 1, true, pageable);
        }
    }
}
