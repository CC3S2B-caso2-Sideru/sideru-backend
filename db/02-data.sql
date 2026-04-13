INSERT INTO categoria (nombre, descripcion)
VALUES ('Barras de acero', 'Barras para construcción y estructuras'),
       ('Tubos metálicos', 'Tubos de acero para uso estructural'),
       ('Planchas de acero', 'Láminas de acero de distintos espesores'),
       ('Perfiles metálicos', 'Perfiles estructurales como ángulos y canales');

INSERT INTO producto (categoria_id, sku, nombre, descripcion, precio, stock, stock_minimo, imagen)
VALUES
-- Barras de acero
(1, 'ACR-BAR-001', 'Barra de acero 1/2"', 'Barra corrugada de 1/2 pulgada', 45.50, 100, 20,
 'https://d34fyu2ua7aizz.cloudfront.net/images/product/24/large/ts_image_5efab149052110_81097952.png'),
(1, 'ACR-BAR-002', 'Barra de acero 3/4"', 'Barra corrugada de 3/4 pulgada', 70.00, 80, 15,
 'https://d34fyu2ua7aizz.cloudfront.net/images/product/24/large/ts_image_5efab36d826891_21256458.png'),

-- Tubos metálicos
(2, 'TUB-NEG-001', 'Tubo negro 2"', 'Tubo de acero negro de 2 pulgadas', 60.00, 50, 10,
 'https://www.sodimac.com.pe/sodimac-pe/articulo/120584782/tubo-redondo-23-5-negro-2-5m/120584784'),
(2, 'TUB-GAL-002', 'Tubo galvanizado 1"', 'Tubo galvanizado resistente a la corrosión', 55.00, 30, 10,
 'https://ferreteria-laestrella.com/808-large_default/tubo-galvanizado-1-c-40-tramo.jpg'),

-- Planchas de acero
(3, 'PLA-ACE-001', 'Plancha de acero 1mm', 'Plancha delgada de acero', 120.00, 0, 5,
 'https://aba.com.pe/wp-content/uploads/2024/12/naval.png'),
(3, 'PLA-ACE-002', 'Plancha de acero 3mm', 'Plancha gruesa de acero', 250.00, 20, 5,
 'https://fixmetal.shop/wp-content/uploads/2024/07/PLANCHAS_NAVALES.jpg'),

-- Perfiles
(4, 'PER-ANG-001', 'Ángulo 2x2', 'Perfil angular de acero 2x2 pulgadas', 35.00, 60, 15,
 'https://cdn-haoob.nitrocdn.com/DSNuMdcXsYBrEWHsQCEyKvmsrgktJPmJ/assets/images/optimized/rev-f3136ac/www.montanstahl.com/wp-content/uploads/2017/07/L-Mix.jpg'),
(4, 'PER-CAN-002', 'Canal U 3"', 'Perfil tipo canal U de 3 pulgadas', 90.00, 25, 5,
 'https://www.covema.pe/wp-content/uploads/2019/12/canal-perfilado-hq.jpg');