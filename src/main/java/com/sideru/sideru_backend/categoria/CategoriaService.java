package com.sideru.sideru_backend.categoria;

import com.sideru.sideru_backend.categoria.dto.CategoriaResponse;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoriaService {
    private CategoriaRepository categoriaRepository;
    private CategoriaMapper categoriaMapper;

    public CategoriaService(
            CategoriaRepository categoriaRepository,
            CategoriaMapper categoriaMapper
    ) {
        this.categoriaRepository = categoriaRepository;
        this.categoriaMapper = categoriaMapper;
    }

    public List<CategoriaResponse>  findAll() {
        return categoriaRepository.findAll()
                .stream()
                .map(categoriaMapper::toCategoriaResponse)
                .toList();
    }
}
