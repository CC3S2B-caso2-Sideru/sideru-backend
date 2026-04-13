CREATE TABLE categoria (
                           id SERIAL PRIMARY KEY,
                           nombre VARCHAR(100) NOT NULL UNIQUE ,
                           descripcion TEXT
);

CREATE TABLE producto (
                          id SERIAL PRIMARY KEY,
                          categoria_id INT NOT NULL,
                          sku VARCHAR(50) UNIQUE NOT NULL,
                          nombre VARCHAR(150) NOT NULL,
                          descripcion TEXT,
                          imagen TEXT,
                          precio DECIMAL(10,2) NOT NULL,
                          stock INT NOT NULL DEFAULT 0,
                          stock_minimo INT DEFAULT 0,
                          activo BOOLEAN DEFAULT TRUE,

                          FOREIGN KEY (categoria_id) REFERENCES categoria(id)
);