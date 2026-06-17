# Informe Técnico: Estrategia de Pruebas y Base de Datos en Memoria H2
**Proyecto:** Distribución Siderúrgica Perú (Backend)  
**Autor/Presentador:** Equipo de Desarrollo Backend  
**Fecha:** Junio 2026  

---

## 1. Introducción
El presente informe documenta el diseño, la implementación y la ejecución de la suite de pruebas del backend de la aplicación de **Siderúrgica Perú**. El objetivo principal de estas pruebas es garantizar la integridad del flujo crítico de cotizaciones de acero, validando tanto la capa de controladores y seguridad como la lógica de negocio y persistencia de datos.

Cumpliendo con los requisitos del proyecto, se ha configurado e integrado una base de datos en memoria **H2** que emula el comportamiento de la base de datos de producción (PostgreSQL), asegurando pruebas rápidas, aisladas y sin efectos secundarios en entornos de desarrollo.

---

## 2. Arquitectura de Pruebas
Para maximizar la cobertura y eficiencia, se implementó una estrategia dual que separa responsabilidades:

```mermaid
graph TD
    subgraph Pruebas de Controladores (CotizacionControllerTest)
        A[MockMvc] -->|HTTP Virtual| B[CotizacionController]
        B -->|Seguridad y Roles| C[Spring Security]
        B -->|Datos Simulados| D[Servicios Mockeados]
    end

    subgraph Pruebas de Integración (CotizacionServiceTest)
        E[JUnit Runner] -->|Ejecución| F[CotizacionService]
        F -->|Lógica Real| G[Repositories JPA]
        G -->|Acceso a Datos| H[BD H2 en Memoria]
        H -.->|Rollback al terminar| H
    end
```

### A. Pruebas Unitarias del Controlador (`CotizacionControllerTest`)
* **Propósito:** Probar exclusivamente los endpoints HTTP, la autenticación/autorización con Spring Security (roles `CLIENTE` y `ADMIN`) y las anotaciones de validación (ej. campos vacíos, valores mínimos).
* **Enfoque:** Mockeo completo de dependencias (`CotizacionService`, `JwtService`) mediante `@WebMvcTest`.

### B. Pruebas de Integración del Servicio (`CotizacionServiceTest`)
* **Propósito:** Probar la lógica de negocio real del servicio (`CotizacionService`) y su interacción directa con la persistencia.
* **Enfoque:** Uso de `@SpringBootTest` y `@Transactional`. Las consultas JPA y operaciones de guardado se realizan directamente contra la base de datos en memoria **H2**.

---

## 3. Configuración de Base de Datos en Memoria H2
El backend cuenta con perfiles de configuración separados para producción/desarrollo local y para pruebas. 

### A. Propiedades del Entorno de Prueba (`application.properties` en `src/test/resources`)
Para activar H2 en modo compatibilidad con PostgreSQL, se configuró lo siguiente:
```properties
spring.datasource.url=jdbc:h2:mem:sideru_test;DB_CLOSE_DELAY=-1;MODE=PostgreSQL;DATABASE_TO_LOWER=TRUE
spring.datasource.username=sa
spring.datasource.password=
spring.datasource.driver-class-name=org.h2.Driver
spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.properties.hibernate.dialect=com.sideru.sideru_backend.config.CustomH2Dialect
```

### B. Soporte de Tipos Nativos: `CustomH2Dialect`
Debido a que el backend en producción utiliza enums nativos de PostgreSQL (`SqlTypes.NAMED_ENUM`), se construyó un dialecto personalizado en las pruebas para asegurar que H2 reconozca y mapee automáticamente estos tipos como `VARCHAR` estándar a nivel JDBC sin alterar las clases del código principal:
```java
public class CustomH2Dialect extends H2Dialect {
    @Override
    protected void registerColumnTypes(TypeContributions typeContributions, ServiceRegistry serviceRegistry) {
        super.registerColumnTypes(typeContributions, serviceRegistry);
        
        typeContributions.getTypeConfiguration().getDdlTypeRegistry()
            .addDescriptor(SqlTypes.NAMED_ENUM, new DdlTypeImpl(
                SqlTypes.NAMED_ENUM, "varchar(255)", this
            ));
            
        typeContributions.getTypeConfiguration().getJdbcTypeRegistry()
            .addDescriptor(SqlTypes.NAMED_ENUM, VarcharJdbcType.INSTANCE);
    }
}
```

---

## 4. Escenarios de Prueba Validados en el Servicio
Las pruebas integradas con H2 en `CotizacionServiceTest` cubren los siguientes escenarios:

1. **Aceptación Automática:** Se valida la creación de una cotización cuyo volumen solicitado está por debajo del stock mínimo. Se comprueba que el estado sea auto-asignado a `aceptada` y que los cálculos matemáticos (Subtotal, IGV del 18%, y Total) coincidan perfectamente con el redondeo monetario en la base de datos.
2. **Revisión Manual por Stock:** Se valida que si la cotización excede el stock mínimo permitido, el estado quede en `enviada` para evaluación manual del área de ventas.
3. **Validación de Relación Cliente-Usuario:** Se valida que se dispare la excepción `ResourceNotFoundException` si el usuario que intenta cotizar no cuenta con una ficha de cliente creada en la BD H2.
4. **Validación de Catálogo de Productos:** Se valida que si un SKU solicitado no existe físicamente en las tablas de productos de H2, el sistema aborte la transacción y lance la excepción correspondiente.

---

## 5. Resultados de Ejecución de Pruebas
Al ejecutar la suite de pruebas localmente mediante `.\mvnw.cmd test`, el reporte de consola demuestra la compilación exitosa del código Java 21 y la ejecución correcta del 100% de los casos:

```text
[INFO] Scanning for projects...
[INFO] Compiling 57 source files with javac [debug parameters release 21] to target\classes
...
[INFO] Running com.sideru.sideru_backend.cotizacion.CotizacionServiceTest
Hibernate: insert into rol (descripcion,nombre,id) values (?,?,default)
Hibernate: insert into usuario (activo,created_at,email,password_hash,rol_id,tipo,ultimo_login,updated_at,username,id) values (?,?,?,?,?,?,?,?,?,default)
Hibernate: insert into cliente (activo,apellido,created_at,direccion,dni,nombre,razon_social,ruc,telefono,updated_at,usuario_id,id) values (?,?,?,?,?,?,?,?,?,?,?,default)
Hibernate: insert into producto (activo,categoria_id,created_at,descripcion,imagen,nombre,precio,sku,stock,stock_minimo,updated_at,id) values (?,?,?,?,?,?,?,?,?,?,?,default)
Hibernate: insert into cotizacion ...
[INFO] Tests run: 4, Failures: 0, Errors: 0, Skipped: 0
[INFO] Running com.sideru.sideru_backend.SideruBackendApplicationTests
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
[INFO] 
[INFO] Results:
[INFO] 
[INFO] Tests run: 12, Failures: 0, Errors: 0, Skipped: 0
[INFO] 
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
```

### Conclusiones de Ejecución:
* **Pruebas Totales:** 12 ejecutadas exitosamente.
* **Fallos y Errores:** 0 fallos (0% de tasa de error).
* **Estado:** Aprobado para integración continua.

---

## 6. Beneficios de esta Implementación
1. **Calidad del Código:** Las consultas SQL e interacciones complejas de JPA son validadas a nivel lógico (H2 ejecuta queries de verdad, a diferencia de los mocks que solo simulan la respuesta).
2. **Velocidad e Aislamiento:** Toda la base de datos de pruebas se levanta en memoria RAM, dura únicamente la fracción de segundo en la que corren los tests, y es totalmente independiente del estado del gestor PostgreSQL local o de desarrollo.
3. **Consistencia de Transacciones:** Gracias al decorador `@Transactional` en las pruebas de Spring Boot, cada caso limpia su propio estado después de ejecutarse (`rollback`), lo que previene que los datos de un test interfieran con los resultados de otro.
