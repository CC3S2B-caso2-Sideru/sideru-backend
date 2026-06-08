package com.sideru.sideru_backend.categoria;

import com.sideru.sideru_backend.categoria.dto.CategoriaResponse;
import org.springframework.stereotype.Service;

@Service
public class CategoriaMapper {
    public CategoriaResponse toCategoriaResponse(Categoria categoria) {
        return new CategoriaResponse(categoria.getId(), categoria.getNombre());
    }
}
