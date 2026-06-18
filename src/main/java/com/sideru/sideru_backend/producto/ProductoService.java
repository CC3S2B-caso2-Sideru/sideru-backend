package com.sideru.sideru_backend.producto;

import com.sideru.sideru_backend.categoria.Categoria;
import com.sideru.sideru_backend.categoria.CategoriaRepository;
import com.sideru.sideru_backend.exception.ResourceNotFoundException;
import com.sideru.sideru_backend.producto.dto.ProductoAdminResponse;
import com.sideru.sideru_backend.producto.dto.ProductoRequest;
import com.sideru.sideru_backend.producto.dto.ProductoResponse;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ProductoService {
    private ProductoRepository productoRepository;
    private ProductoMapper productoMapper;
    private CategoriaRepository categoriaRepository;

    public ProductoService(
            ProductoRepository productoRepository,
            ProductoMapper productoMapper,
            CategoriaRepository categoriaRepository
    ) {
        this.productoRepository = productoRepository;
        this.productoMapper = productoMapper;
        this.categoriaRepository = categoriaRepository;
    }

    public List<ProductoResponse> findAll() {
        return productoRepository.findAll()
                .stream()
                .map(
                        producto -> productoMapper.toProductoResponse(producto)
                ).toList();
    }

    public List<ProductoResponse> findByCategoriaId(Integer categoriaId) {
        return productoRepository.findAllByCategoriaId(categoriaId)
                .stream()
                .map(
                        producto -> productoMapper.toProductoResponse(producto)
                ).toList();
    }

    public List<ProductoResponse> findByCategoriaNombre(String categoriaNombre) {
        return productoRepository.findAllByCategoriaNombre(categoriaNombre)
                .stream()
                .map(
                        producto -> productoMapper.toProductoResponse(producto)
                ).toList();
    }

    public List<ProductoResponse> findByFilters(Integer categoriaId, String search, Long page, Integer pageSize) {
        Long limit = pageSize.longValue();
        Long offset =  (page - 1) * limit;

        return productoRepository.findByFilters(categoriaId, search, limit, offset)
                .stream()
                .map(productoMapper::toProductoResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public Page<ProductoAdminResponse> findAllAdmin(
            String search, Integer categoriaId, Boolean activo, Pageable pageable) {
        return productoRepository.findAdminByFilters(search, categoriaId, activo, pageable)
                .map(productoMapper::toAdminResponse);
    }

    @Transactional(readOnly = true)
    public ProductoAdminResponse findBySkuAdmin(String sku) {
        Producto producto = productoRepository.findBySku(sku)
                .orElseThrow(() -> new ResourceNotFoundException("Producto", sku));
        return productoMapper.toAdminResponse(producto);
    }

    @Transactional
    public ProductoAdminResponse create(ProductoRequest request) {
        if (productoRepository.findBySku(request.sku()).isPresent()) {
            throw new IllegalArgumentException("Ya existe un producto con el SKU: " + request.sku());
        }

        if (request.stockMinimo() != null && request.stockMinimo() > request.stock()) {
            throw new IllegalArgumentException("El umbral de auto-aprobación no puede ser mayor que el stock");
        }

        Categoria categoria = categoriaRepository.findById(request.categoriaId())
                .orElseThrow(() -> new ResourceNotFoundException("Categoria", request.categoriaId().toString()));

        Producto producto = new Producto();
        producto.setSku(request.sku());
        producto.setNombre(request.nombre());
        producto.setDescripcion(request.descripcion());
        producto.setImagen(request.imagen());
        producto.setPrecio(request.precio());
        producto.setStock(request.stock());
        producto.setStockMinimo(request.stockMinimo() != null ? request.stockMinimo() : 0);
        producto.setActivo(true);
        producto.setCategoria(categoria);

        return productoMapper.toAdminResponse(productoRepository.save(producto));
    }

    @Transactional
    public ProductoAdminResponse update(String sku, ProductoRequest request) {
        Producto producto = productoRepository.findBySku(sku)
                .orElseThrow(() -> new ResourceNotFoundException("Producto", sku));

        // Si el SKU cambió, verificar que no exista otro producto con ese SKU
        if (!sku.equals(request.sku()) && productoRepository.findBySku(request.sku()).isPresent()) {
            throw new IllegalArgumentException("Ya existe un producto con el SKU: " + request.sku());
        }

        if (request.stockMinimo() != null && request.stockMinimo() > request.stock()) {
            throw new IllegalArgumentException("El umbral de auto-aprobación no puede ser mayor que el stock");
        }

        Categoria categoria = categoriaRepository.findById(request.categoriaId())
                .orElseThrow(() -> new ResourceNotFoundException("Categoria", request.categoriaId().toString()));

        producto.setSku(request.sku());
        producto.setNombre(request.nombre());
        producto.setDescripcion(request.descripcion());
        producto.setImagen(request.imagen());
        producto.setPrecio(request.precio());
        producto.setStock(request.stock());
        producto.setStockMinimo(request.stockMinimo() != null ? request.stockMinimo() : 0);
        producto.setCategoria(categoria);

        return productoMapper.toAdminResponse(productoRepository.save(producto));
    }

    @Transactional
    public ProductoAdminResponse toggleActive(String sku) {
        Producto producto = productoRepository.findBySku(sku)
                .orElseThrow(() -> new ResourceNotFoundException("Producto", sku));
        producto.setActivo(!Boolean.TRUE.equals(producto.getActivo()));
        return productoMapper.toAdminResponse(productoRepository.save(producto));
    }

    @Transactional
    public ProductoAdminResponse adjustStock(String sku, int cantidad) {
        Producto producto = productoRepository.findBySku(sku)
                .orElseThrow(() -> new ResourceNotFoundException("Producto", sku));
        int nuevoStock = producto.getStock() + cantidad;
        if (nuevoStock < 0) {
            throw new IllegalArgumentException("El stock no puede ser negativo");
        }
        producto.setStock(nuevoStock);
        return productoMapper.toAdminResponse(productoRepository.save(producto));
    }

    @Transactional(readOnly = true)
    public List<ProductoAdminResponse> findStockBajo() {
        return productoRepository.findStockBajo()
                .stream()
                .map(productoMapper::toAdminResponse)
                .toList();
    }
}
