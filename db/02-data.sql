--  CATÁLOGO

INSERT INTO categoria (nombre, descripcion)
VALUES ('Barras y Varillas',    'Barras de acero liso y corrugado para construcción'),
       ('Tubos y Cañerías',     'Tubería negra, galvanizada y de acero inoxidable'),
       ('Planchas y Bobinas',   'Planchas laminadas en frío, en caliente y galvanizadas'),
       ('Perfiles Estructurales','Ángulos, vigas, canales y tubos estructurales'),
        ('Alambre y Malla',      'Alambre recocido, malla electrosoldada y gaviones');


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

-- TODO: verficar que estos nuevos productos esten en la categoria correcta
INSERT INTO producto (categoria_id, sku, nombre, descripcion, precio, stock, stock_minimo) VALUES
       (1, 'BAR-COR-6MM',  'Varilla corrugada 6mm x 9m',   'Acero corrugado grado 60, barra de 9 metros',  18.50,  850, 100),
       (1, 'BAR-COR-8MM',  'Varilla corrugada 8mm x 9m',   'Acero corrugado grado 60, barra de 9 metros',  28.90,  620, 100),
       (1, 'BAR-COR-12MM', 'Varilla corrugada 12mm x 9m',  'Acero corrugado grado 60, barra de 9 metros',  58.00,  430,  80),
       (1, 'BAR-LIS-16MM', 'Barra lisa 16mm x 6m',         'Acero liso SAE 1020, barra de 6 metros',       42.00,  200,  50),
       (2, 'PER-ANG-2X2',  'Ángulo 2"x2"x3/16" x 6m',     'Ángulo de acero A36',                         55.00,  310,  60),
       (2, 'PER-VIG-4',    'Viga H 4" x 13lb/pie x 6m',   'Viga de acero estructural A36',               195.00,  120,  30),
       (2, 'PER-CAN-3',    'Canal C 3" x 5lb/pie x 6m',   'Canal de acero A36',                           88.00,  180,  40),
       (3, 'PLA-CAL-2MM',  'Plancha laminada caliente 2mm','Plancha LAC 1.22m x 2.44m',                   210.00,  95,  20),
       (3, 'PLA-GAL-1MM',  'Plancha galvanizada 1mm',      'Plancha galvanizada 1.22m x 2.44m, Z275',    185.00,  140,  25),
       (4, 'TUB-NEG-1',    'Tubo negro 1" x 6m',           'Tubo negro ERW ASTM A53',                      38.00,  500,  80),
       (4, 'TUB-GAL-3_4',  'Tubo galvanizado 3/4" x 6m',  'Tubo galvanizado ASTM A53',                    44.00,  380,  80),
       (5, 'ALA-REC-16',   'Alambre recocido N°16 x 30kg', 'Rollo de alambre recocido calibre 16',         98.00,  220,  50),
       (5, 'MAL-ELS-15',   'Malla electrosoldada 15x15cm', 'Panel 2.4m x 6m, alambre 4mm',               145.00,   75,  20);

--  ROLES Y PERMISOS

INSERT INTO rol (nombre, descripcion) VALUES
                                          ('admin',      'Administrador general del sistema'),
                                          ('gerente',    'Gerencia — acceso a reportes y aprobaciones'),
                                          ('vendedor',   'Gestión de cotizaciones, pedidos y facturación'),
                                          ('almacenero', 'Control de stock, recepciones y despachos'),
                                          ('rrhh',       'Recursos humanos: empleados, asistencia y planilla'),
                                          ('cliente',    'Cliente del portal web');

INSERT INTO permiso (codigo, modulo, accion, descripcion) VALUES
                                                              ('cotizacion.ver',       'ventas',    'ver',      'Ver listado y detalle de cotizaciones'),
                                                              ('cotizacion.crear',     'ventas',    'crear',    'Crear nuevas cotizaciones'),
                                                              ('cotizacion.editar',    'ventas',    'editar',   'Editar cotizaciones existentes'),
                                                              ('cotizacion.aprobar',   'ventas',    'aprobar',  'Aprobar o rechazar cotizaciones'),
                                                              ('pedido.ver',           'ventas',    'ver',      'Ver pedidos'),
                                                              ('pedido.crear',         'ventas',    'crear',    'Registrar pedidos'),
                                                              ('pedido.editar',        'ventas',    'editar',   'Actualizar estado de pedidos'),
                                                              ('comprobante.crear',    'ventas',    'crear',    'Emitir facturas y boletas'),
                                                              ('stock.ver',            'logistica', 'ver',      'Consultar stock de productos'),
                                                              ('stock.editar',         'logistica', 'editar',   'Ajustar stock manualmente'),
                                                              ('orden_compra.ver',     'logistica', 'ver',      'Ver órdenes de compra'),
                                                              ('orden_compra.crear',   'logistica', 'crear',    'Crear órdenes de compra'),
                                                              ('recepcion.crear',      'logistica', 'crear',    'Registrar recepciones de mercadería'),
                                                              ('empleado.ver',         'rrhh',      'ver',      'Ver empleados'),
                                                              ('empleado.crear',       'rrhh',      'crear',    'Registrar nuevos empleados'),
                                                              ('asistencia.ver',       'rrhh',      'ver',      'Ver registros de asistencia'),
                                                              ('planilla.ver',         'rrhh',      'ver',      'Ver planillas'),
                                                              ('planilla.procesar',    'rrhh',      'aprobar',  'Procesar planilla mensual'),
                                                              ('reporte.ver',          'reportes',  'ver',      'Acceder a reportes gerenciales'),
                                                              ('usuario.gestionar',    'admin',     'editar',   'Gestionar usuarios y roles');

-- Permisos por rol
-- admin: todos
INSERT INTO rol_permiso (rol_id, permiso_id)
SELECT 1, id FROM permiso;

-- gerente: ver todo + aprobar cotizaciones + reportes
INSERT INTO rol_permiso (rol_id, permiso_id)
SELECT 2, id FROM permiso
WHERE codigo IN (
                 'cotizacion.ver','cotizacion.aprobar',
                 'pedido.ver','comprobante.crear',
                 'stock.ver','orden_compra.ver',
                 'empleado.ver','planilla.ver','reporte.ver'
    );

-- vendedor
INSERT INTO rol_permiso (rol_id, permiso_id)
SELECT 3, id FROM permiso
WHERE codigo IN (
                 'cotizacion.ver','cotizacion.crear','cotizacion.editar',
                 'pedido.ver','pedido.crear','pedido.editar',
                 'comprobante.crear','stock.ver'
    );

-- almacenero
INSERT INTO rol_permiso (rol_id, permiso_id)
SELECT 4, id FROM permiso
WHERE codigo IN (
                 'stock.ver','stock.editar',
                 'orden_compra.ver','orden_compra.crear',
                 'recepcion.crear','pedido.ver','pedido.editar'
    );

-- rrhh
INSERT INTO rol_permiso (rol_id, permiso_id)
SELECT 5, id FROM permiso
WHERE codigo IN (
                 'empleado.ver','empleado.crear',
                 'asistencia.ver','planilla.ver','planilla.procesar'
    );

-- cliente: portal — ver y crear sus propias cotizaciones
INSERT INTO rol_permiso (rol_id, permiso_id)
SELECT 6, id FROM permiso
WHERE codigo IN (
                 'cotizacion.ver','cotizacion.crear'
    );

--  USUARIOS INTERNOS

INSERT INTO usuario (rol_id, tipo, username, email, password_hash) VALUES
                                                                       (1, 'INTERNO', 'admin.torres',    'admin@siderurgicaperu.com',     '$2b$12$HASH_ADMIN_001'),
                                                                       (2, 'INTERNO', 'gerente.vargas',  'gerente@siderurgicaperu.com',   '$2b$12$HASH_GERE_001'),
                                                                       (3, 'INTERNO', 'vendedor.luna',   'vluna@siderurgicaperu.com',     '$2b$12$HASH_VEND_001'),
                                                                       (3, 'INTERNO', 'vendedor.rios',   'vrios@siderurgicaperu.com',     '$2b$12$HASH_VEND_002'),
                                                                       (4, 'INTERNO', 'almacen.huanca',  'ahuanca@siderurgicaperu.com',   '$2b$12$HASH_ALMA_001'),
                                                                       (5, 'INTERNO', 'rrhh.mendoza',    'rmendoza@siderurgicaperu.com',  '$2b$12$HASH_RRHH_001');

-- USUARIOS CLIENTES (portal)
INSERT INTO usuario (rol_id, tipo, username, email, password_hash) VALUES
                                                                       (6, 'CLIENTE', 'acero_sur',     'compras@acerosur.com.pe',      '$2a$10$GB4LsBTGQo4dVC4lNUNWVePNFcTSsB9H9S.CvJAKq3b.9wtzk6Sri'), -- pwd: acero
                                                                       (6, 'CLIENTE', 'construcciones','admin@construccionesrm.pe',     '$2a$10$12YBoiOhIR8nYztvzqs8ge/M633ScKF6Ron2uwelxdrBYbINt.8sW'), -- pwd: construcciones
                                                                       (6, 'CLIENTE', 'silva',         'jsilva@gmail.com',             '$2a$10$mxBQoHYDxxp1HOx2AgdOs.lh2nVKSHCRVbqA7IwT9WMOEC7Il0.ou'), -- pwd: silva
                                                                       (6, 'CLIENTE', 'ferreteria_jm', 'fjm@ferreteriajesusm.pe',      '$2a$10$XBWyCZ17sd7HpjBWP/dakuGGANEudLmfrY7kT/IeAwS0sR47fXjNG'), -- pwd: ferreteria
                                                                       (6, 'CLIENTE', 'palacios',      'rpalacios@outlook.com',        '$2a$10$TLoldUQeHjEOCIgvjUpA8.3J41G5if5yEy/zCQvyYHYjpCsXgf.Ja'); -- pwd: palacios

--  CLIENTES

INSERT INTO cliente (usuario_id, ruc, razon_social, nombre, apellido, telefono, direccion) VALUES
                                                                                               (7,  '20512345678', 'Acero Sur S.A.C.',          'Carlos',  'Delgado',   '01-3451234', 'Av. Industrial 432, Villa El Salvador, Lima'),
                                                                                               (8,  '20601234567', 'Construcciones R&M E.I.R.L.','Roberto', 'Meza',      '01-2567890', 'Jr. Los Pinos 123, San Juan de Lurigancho, Lima'),
                                                                                               (9,  NULL,          NULL,                         'Jorge',   'Silva',     '987654321',  'Calle Las Flores 45, Surquillo, Lima'),
                                                                                               (10, '10345678901', NULL,                         'Fernando','Quispe',    '976543210',  'Av. Grau 890, Trujillo'),
                                                                                               (11, NULL,          NULL,                         'Rosa',    'Palacios',  '965432109',  'Jr. Amazonas 234, Arequipa');

--  DEPARTAMENTOS, CARGOS Y EMPLEADOS

INSERT INTO departamento (nombre) VALUES
                                      ('Gerencia General'),
                                      ('Ventas'),
                                      ('Logística y Almacén'),
                                      ('Recursos Humanos'),
                                      ('Administración y Finanzas');

INSERT INTO cargo (nombre, descripcion, salario_base) VALUES
                                                          ('Gerente General',         'Dirección estratégica de la empresa',        8500.00),
                                                          ('Jefe de Ventas',          'Coordinación del equipo comercial',          4200.00),
                                                          ('Vendedor',                'Atención de clientes y cotizaciones',        2400.00),
                                                          ('Jefe de Almacén',         'Control de stock y logística',               3800.00),
                                                          ('Almacenero',              'Recepción, almacenamiento y despacho',       1800.00),
                                                          ('Administrador de RRHH',   'Gestión de personal y planilla',             3200.00),
                                                          ('Asistente Administrativo','Soporte administrativo y contable',          1900.00);

INSERT INTO empleado (usuario_id, departamento_id, cargo_id, dni, nombres, apellidos, email, telefono, fecha_ingreso, salario, cuenta_bancaria) VALUES
                                                                                                                                                    (1,  1, 1, '08123456', 'Miguel',    'Torres Salas',      'admin@siderurgicaperu.com',    '01-4561234', '2018-03-01', 8500.00, '00-123-456789'),
                                                                                                                                                    (2,  1, 1, '09234567', 'Patricia',  'Vargas Huamán',     'gerente@siderurgicaperu.com',  '01-4561235', '2019-06-15', 8500.00, '00-123-456790'),
                                                                                                                                                    (3,  2, 3, '10345678', 'Lucía',     'Luna Ccopa',        'vluna@siderurgicaperu.com',    '987001122', '2021-01-10', 2400.00, '00-234-567891'),
                                                                                                                                                    (4,  2, 3, '11456789', 'Marco',     'Ríos Paredes',      'vrios@siderurgicaperu.com',    '987002233', '2021-04-05', 2400.00, '00-234-567892'),
                                                                                                                                                    (5,  3, 4, '12567890', 'Eduardo',   'Huanca Flores',     'ahuanca@siderurgicaperu.com',  '987003344', '2020-07-20', 3800.00, '00-345-678903'),
                                                                                                                                                    (6,  4, 6, '13678901', 'Carmen',    'Mendoza Díaz',      'rmendoza@siderurgicaperu.com', '987004455', '2020-02-01', 3200.00, '00-456-789014'),
                                                                                                                                                    (NULL,2, 2, '14789012', 'Andrés',   'Castillo Vega',     'acastillo@siderurgicaperu.com','987005566', '2017-09-12', 4200.00, '00-234-567893'),
                                                                                                                                                    (NULL,3, 5, '15890123', 'Rocío',    'Apaza Torres',      'rapaza@siderurgicaperu.com',   '987006677', '2022-03-15', 1800.00, '00-345-678904'),
                                                                                                                                                    (NULL,5, 7, '16901234', 'Silvana',  'Campos Ruiz',       'scampos@siderurgicaperu.com',  '987007788', '2023-01-09', 1900.00, '00-567-890125');


--  PROVEEDORES


INSERT INTO proveedor (ruc, razon_social, contacto, email, telefono, direccion) VALUES
                                                                                    ('20100070970', 'Aceros Arequipa S.A.',         'Javier Salas',     'ventas@acerosarequipa.com.pe',  '054-380700', 'Av. Enrique Meiggs s/n, Parque Industrial, Arequipa'),
                                                                                    ('20100017491', 'Corporación Aceros Chilca S.A.','María Quispe',     'mquispe@aceroschi.pe',          '01-3800900', 'Carretera Panamericana Sur km 60, Chilca, Lima'),
                                                                                    ('20503480264', 'Ferreyros S.A.',               'Luis Pariona',     'lpariona@ferreyros.com.pe',     '01-6146000', 'Av. Argentina 3099, Callao'),
                                                                                    ('20100007641', 'Sider Perú S.A.',              'Giuliana Mendez',  'gmendez@siderperu.com.pe',      '043-395050', 'Av. Gálvez Chipoco s/n, Chimbote, Áncash');


--  COTIZACIONES


-- Cotización 1: cliente Acero Sur — aceptada → tiene pedido
INSERT INTO cotizacion (cliente_id, fecha_emision, fecha_expiracion, estado, subtotal, descuento_total, igv, total) VALUES
    (1, '2025-03-10 09:00:00-05', '2025-03-17', 'aceptada', 3364.00, 168.20, 575.47, 3771.27);

INSERT INTO cotizacion_detalle (cotizacion_id, producto_id, cantidad, precio_unitario, descuento, subtotal) VALUES
                                                                                                                (1, 1, 50,  18.50, 5.00,  877.25),   -- 50 varillas 6mm, 5% dto
                                                                                                                (1, 2, 30,  28.90, 5.00,  822.15),   -- 30 varillas 8mm, 5% dto
                                                                                                                (1, 5, 20,  55.00, 5.00, 1045.00),   -- 20 ángulos, 5% dto
                                                                                                                (1, 10,15,  38.00, 5.00,  541.50);   -- 15 tubos negros, 5% dto

-- Cotización 2: cliente Construcciones R&M — aceptada → tiene pedido
INSERT INTO cotizacion (cliente_id, fecha_emision, fecha_expiracion, estado, subtotal, descuento_total, igv, total) VALUES
    (2, '2025-03-12 11:30:00-05', '2025-03-19', 'aceptada', 7540.00, 754.00, 1223.46, 8009.46);

INSERT INTO cotizacion_detalle (cotizacion_id, producto_id, cantidad, precio_unitario, descuento, subtotal) VALUES
                                                                                                                (2, 3,  60, 58.00, 10.00, 3132.00),  -- 60 varillas 12mm, 10% dto
                                                                                                                (2, 6,  15, 195.00,10.00, 2632.50),  -- 15 vigas H, 10% dto
                                                                                                                (2, 8,  10, 210.00,10.00, 1890.00);  -- 10 planchas cal, 10% dto

-- Cotización 3: cliente Jorge Silva — enviada (pendiente respuesta)
INSERT INTO cotizacion (cliente_id, fecha_emision, fecha_expiracion, estado, subtotal, descuento_total, igv, total) VALUES
    (3, '2025-04-01 14:00:00-05', '2025-04-08', 'enviada', 693.00, 0, 124.74, 817.74);

INSERT INTO cotizacion_detalle (cotizacion_id, producto_id, cantidad, precio_unitario, descuento, subtotal) VALUES
                                                                                                                (3, 11, 10, 44.00, 0, 440.00),
                                                                                                                (3, 12,  1, 98.00, 0,  98.00),
                                                                                                                (3, 1,   5, 18.50, 0,  92.50),
                                                                                                                (3, 10,  1, 38.00, 0,  38.00);

-- Cotización 4: cliente Ferretería JM — rechazada
INSERT INTO cotizacion (cliente_id, fecha_emision, fecha_expiracion, estado, observaciones, subtotal, descuento_total, igv, total) VALUES
    (4, '2025-02-20 10:00:00-05', '2025-02-27', 'rechazada', 'Cliente no aceptó precio de vigas.', 1560.00, 0, 280.80, 1840.80);

INSERT INTO cotizacion_detalle (cotizacion_id, producto_id, cantidad, precio_unitario, descuento, subtotal) VALUES
    (4, 6, 8, 195.00, 0, 1560.00);

-- Cotización 5: cliente Rosa Palacios — borrador
INSERT INTO cotizacion (cliente_id, fecha_emision, fecha_expiracion, estado, subtotal, descuento_total, igv, total) VALUES
    (5, '2025-04-05 16:00:00-05', '2025-04-12', 'borrador', 185.00, 0, 33.30, 218.30);

INSERT INTO cotizacion_detalle (cotizacion_id, producto_id, cantidad, precio_unitario, descuento, subtotal) VALUES
    (5, 9, 1, 185.00, 0, 185.00);


--  PEDIDOS


-- Pedido 1: de cotización 1 — entregado
INSERT INTO pedido (cotizacion_id, cliente_id, fecha_pedido, estado, total) VALUES
    (1, 1, '2025-03-11 08:30:00-05', 'entregado', 3771.27);

INSERT INTO pedido_detalle (pedido_id, producto_id, cantidad, precio_unitario, descuento, subtotal) VALUES
                                                                                                        (1, 1, 50, 18.50, 5.00,  877.25),
                                                                                                        (1, 2, 30, 28.90, 5.00,  822.15),
                                                                                                        (1, 5, 20, 55.00, 5.00, 1045.00),
                                                                                                        (1, 10,15, 38.00, 5.00,  541.50);

-- Pedido 2: de cotización 2 — en preparación
INSERT INTO pedido (cotizacion_id, cliente_id, fecha_pedido, estado, total) VALUES
    (2, 2, '2025-03-13 09:00:00-05', 'en_preparacion', 8009.46);

INSERT INTO pedido_detalle (pedido_id, producto_id, cantidad, precio_unitario, descuento, subtotal) VALUES
                                                                                                        (2, 3, 60, 58.00, 10.00, 3132.00),
                                                                                                        (2, 6, 15,195.00, 10.00, 2632.50),
                                                                                                        (2, 8, 10,210.00, 10.00, 1890.00);

-- Pedido 3: rechazado por falta de stock (caso de negocio KPI)
INSERT INTO pedido (cotizacion_id, cliente_id, fecha_pedido, estado, motivo_rechazo, total) VALUES
    (4, 4, '2025-02-21 10:15:00-05', 'rechazado_stock',
     'Stock insuficiente de Viga H 4": disponible 5 unidades, solicitadas 8.',
     1840.80);

INSERT INTO pedido_detalle (pedido_id, producto_id, cantidad, precio_unitario, descuento, subtotal) VALUES
    (3, 6, 8, 195.00, 0, 1560.00);


--  COMPROBANTES


-- Factura para pedido 1 (Acero Sur tiene RUC) — pagada
INSERT INTO comprobante (pedido_id, tipo, serie, numero, fecha_emision, subtotal, igv, total, estado_pago, fecha_pago, metodo_pago) VALUES
    (1, 'factura', 'F001', '00000001', '2025-03-11 12:00:00-05', 3364.00, 407.27, 3771.27, 'pagado', '2025-03-11 15:30:00-05', 'transferencia');

-- Factura para pedido 2 (Construcciones R&M tiene RUC) — pendiente pago
INSERT INTO comprobante (pedido_id, tipo, serie, numero, fecha_emision, subtotal, igv, total, estado_pago, metodo_pago) VALUES
    (2, 'factura', 'F001', '00000002', '2025-03-13 10:00:00-05', 7540.00, 469.46, 8009.46, 'pendiente', 'transferencia');


--  ÓRDENES DE COMPRA


-- OC 1: reposición de vigas (stock bajo tras pedido rechazado) — recibida
INSERT INTO orden_compra (proveedor_id, fecha_emision, fecha_estimada, estado, requiere_prestamo, total_estimado, observaciones) VALUES
    (1, '2025-02-22 09:00:00-05', '2025-03-05', 'recibida', FALSE, 9750.00,
     'Reposición urgente de Viga H tras rechazo de pedido #3.');

INSERT INTO orden_compra_detalle (orden_compra_id, producto_id, cantidad, precio_unitario, subtotal) VALUES
                                                                                                         (1, 6, 50, 175.00, 8750.00),
                                                                                                         (1, 7, 10,  70.00, 700.00),
                                                                                                         (1, 8,  1, 140.00, 140.00);

-- OC 2: abastecimiento general — confirmada (en tránsito)
INSERT INTO orden_compra (proveedor_id, fecha_emision, fecha_estimada, estado, requiere_prestamo, total_estimado) VALUES
    (4, '2025-04-02 11:00:00-05', '2025-04-20', 'confirmada', TRUE, 24600.00);

INSERT INTO orden_compra_detalle (orden_compra_id, producto_id, cantidad, precio_unitario, subtotal) VALUES
                                                                                                         (2, 1, 500, 14.00,  7000.00),
                                                                                                         (2, 2, 400, 22.00,  8800.00),
                                                                                                         (2, 3, 150, 44.00,  6600.00),
                                                                                                         (2, 4, 100, 32.00,  3200.00),
                                                                                                         (2,10, 200, 25.00,  5000.00);


--  RECEPCIÓN DE MERCADERÍA


INSERT INTO recepcion_mercaderia (orden_compra_id, fecha_recepcion, observaciones) VALUES
    (1, '2025-03-04 08:00:00-05', 'Mercadería recibida conforme, sin observaciones.');

INSERT INTO recepcion_detalle (recepcion_mercaderia_id, producto_id, cantidad_recibida) VALUES
                                                                                            (1, 6, 50),
                                                                                            (1, 7, 10),
                                                                                            (1, 8,  1);


--  FACTURAS DE PROVEEDOR


INSERT INTO factura_proveedor (orden_compra_id, numero_factura, fecha_factura, monto_total, estado_pago, fecha_pago) VALUES
    (1, 'F001-00045231', '2025-03-04', 9750.00, 'pagado', '2025-03-15');

INSERT INTO factura_proveedor (orden_compra_id, numero_factura, fecha_factura, monto_total, estado_pago) VALUES
    (2, 'F001-00048890', '2025-04-02', 24600.00, 'pendiente');


--  ASISTENCIA — Abril 2025 (muestra de una semana)


-- Empleado 3 (Lucía Luna) — semana normal
INSERT INTO asistencia (empleado_id, fecha, tipo, hora, ip_origen) VALUES
                                                                       (3, '2025-04-07', 'entrada', '08:02', '192.168.1.10'),
                                                                       (3, '2025-04-07', 'salida',  '17:01', '192.168.1.10'),
                                                                       (3, '2025-04-08', 'entrada', '08:05', '192.168.1.10'),
                                                                       (3, '2025-04-08', 'salida',  '17:00', '192.168.1.10'),
                                                                       (3, '2025-04-09', 'entrada', '08:35', '192.168.1.10'),  -- tardanza
                                                                       (3, '2025-04-09', 'salida',  '17:00', '192.168.1.10'),
                                                                       (3, '2025-04-10', 'entrada', '08:01', '192.168.1.10'),
                                                                       (3, '2025-04-10', 'salida',  '17:02', '192.168.1.10'),
                                                                       (3, '2025-04-11', 'entrada', '08:00', '192.168.1.10'),
                                                                       (3, '2025-04-11', 'salida',  '17:00', '192.168.1.10');

-- Empleado 5 (Eduardo Huanca) — falta el miércoles
INSERT INTO asistencia (empleado_id, fecha, tipo, hora, ip_origen) VALUES
                                                                       (5, '2025-04-07', 'entrada', '07:58', '192.168.1.20'),
                                                                       (5, '2025-04-07', 'salida',  '17:00', '192.168.1.20'),
                                                                       (5, '2025-04-08', 'entrada', '08:00', '192.168.1.20'),
                                                                       (5, '2025-04-08', 'salida',  '17:05', '192.168.1.20'),
                                                                       -- 2025-04-09: falta (sin registro)
                                                                       (5, '2025-04-10', 'entrada', '08:02', '192.168.1.20'),
                                                                       (5, '2025-04-10', 'salida',  '17:00', '192.168.1.20'),
                                                                       (5, '2025-04-11', 'entrada', '08:00', '192.168.1.20'),
                                                                       (5, '2025-04-11', 'salida',  '17:00', '192.168.1.20');

-- Empleado 8 (Rocío Apaza) — semana normal
INSERT INTO asistencia (empleado_id, fecha, tipo, hora, ip_origen) VALUES
                                                                       (8, '2025-04-07', 'entrada', '08:00', '192.168.1.30'),
                                                                       (8, '2025-04-07', 'salida',  '17:00', '192.168.1.30'),
                                                                       (8, '2025-04-08', 'entrada', '08:03', '192.168.1.30'),
                                                                       (8, '2025-04-08', 'salida',  '17:00', '192.168.1.30'),
                                                                       (8, '2025-04-09', 'entrada', '08:01', '192.168.1.30'),
                                                                       (8, '2025-04-09', 'salida',  '17:00', '192.168.1.30'),
                                                                       (8, '2025-04-10', 'entrada', '08:00', '192.168.1.30'),
                                                                       (8, '2025-04-10', 'salida',  '17:02', '192.168.1.30'),
                                                                       (8, '2025-04-11', 'entrada', '08:00', '192.168.1.30'),
                                                                       (8, '2025-04-11', 'salida',  '17:00', '192.168.1.30');


--  JUSTIFICACIONES


-- Tardanza de Lucía Luna el 09/04
INSERT INTO justificacion (empleado_id, fecha_incidencia, tipo_incidencia, descripcion, estado, revisado_por, fecha_revision) VALUES
    (3, '2025-04-09', 'tardanza',
     'Demora por accidente en Av. Javier Prado que bloqueó el tránsito. Adjunto foto de accidente.',
     'aprobada', 6, '2025-04-10 09:00:00-05');

-- Falta de Eduardo Huanca el 09/04
INSERT INTO justificacion (empleado_id, fecha_incidencia, tipo_incidencia, descripcion, estado, revisado_por, fecha_revision) VALUES
    (5, '2025-04-09', 'falta',
     'Atención médica de emergencia por infección estomacal. Adjunto descanso médico del Hospital Rebagliati.',
     'aprobada', 6, '2025-04-10 10:30:00-05');

-- Justificación pendiente de revisión
INSERT INTO justificacion (empleado_id, fecha_incidencia, tipo_incidencia, descripcion, estado) VALUES
    (8, '2025-04-14', 'tardanza',
     'El reloj marcador presentó falla técnica a las 8:00 am del lunes 14. Se informó al administrador en el momento.',
     'pendiente');


--  PLANILLA — Marzo 2025


INSERT INTO planilla (periodo, fecha_proceso, procesado_por) VALUES
    ('2025-03', '2025-04-01 10:00:00-05', 6);

-- planilla_id = 1
INSERT INTO planilla_detalle
(planilla_id, empleado_id, dias_trabajados, dias_falta, dias_tardanza,
 horas_extras, salario_bruto, descuento_faltas, descuento_tardanzas,
 otros_descuentos, bonificaciones, salario_neto, cumplio_horas, fecha_deposito)
VALUES
    -- Lucía Luna: 1 tardanza, sin faltas, sin horas extras
    (1, 3, 21, 0, 1, 0.00, 2400.00,   0.00,  40.00,   0.00,   0.00, 2360.00, TRUE,  '2025-04-05'),
    -- Marco Ríos: sin incidencias
    (1, 4, 22, 0, 0, 2.00, 2400.00,   0.00,   0.00,   0.00,  60.00, 2460.00, TRUE,  '2025-04-05'),
    -- Eduardo Huanca: 1 falta justificada
    (1, 5, 21, 1, 0, 0.00, 3800.00, 172.73,   0.00,   0.00,   0.00, 3627.27, FALSE, '2025-04-05'),
    -- Carmen Mendoza: perfecta asistencia
    (1, 6, 22, 0, 0, 0.00, 3200.00,   0.00,   0.00,   0.00,   0.00, 3200.00, TRUE,  '2025-04-05'),
    -- Andrés Castillo: jefe ventas, sin incidencias
    (1, 7, 22, 0, 0, 4.00, 4200.00,   0.00,   0.00,   0.00, 160.00, 4360.00, TRUE,  '2025-04-05'),
    -- Rocío Apaza: sin incidencias
    (1, 8, 22, 0, 0, 0.00, 1800.00,   0.00,   0.00,   0.00,   0.00, 1800.00, TRUE,  '2025-04-05'),
    -- Silvana Campos: 2 tardanzas
    (1, 9, 20, 0, 2, 0.00, 1900.00,   0.00,  57.58,   0.00,   0.00, 1842.42, FALSE, '2025-04-05');