# Sideru backend

Backend del proyecto Sideru. Es necesario la base de datos corriendo y un archivo `.env` en la raíz del proyecto.

Ejemplo del archivo `.env`:
```.env
DB_NAME=<database_name>
DB_URL=jdbc:postgresql://localhost:5432/<database_name>
DB_USER=<database_user>
DB_PASSWORD=<database_password>
```

Levantar la base de datos con datos de prueba:
```bash
docker compose up -d
```

Eliminar el contenedor y el volumen creado.
```bash
docker compose down -v
```

# Sideru Backend

Backend del sistema **Sideru**, encargado de gestionar ventas, inventario y procesos internos de una empresa siderúrgica.

---

## Requisitos

Antes de iniciar, asegúrate de tener instalado:

* Docker y Docker Compose
* Java
* Maven

---

## Variables de entorno

Se debe crear un archivo `.env` en la raíz del proyecto con la siguiente configuración:

```env
DB_NAME=<database_name>
DB_URL=jdbc:postgresql://localhost:5432/<database_name>
DB_USER=<database_user>
DB_PASSWORD=<database_password>
```

**Ejemplo:**

```env
DB_NAME=sideru_db
DB_URL=jdbc:postgresql://localhost:5432/sideru_db
DB_USER=user
DB_PASSWORD=pass
```

---

## Base de datos (PostgreSQL con Docker)

### Levantar la base de datos

```bash
docker compose up -d
```

---

### Detener y eliminar contenedores

```bash
docker compose down
```

---

### Eliminar contenedores + volúmenes (reset completo)

```bash
docker compose down -v
```

---

## Ejecutar la aplicación

Dependiendo de tu configuración:

### Con Maven:

```bash
./mvnw spring-boot:run
```
---

## Documentación de la API

La API cuenta con documentación interactiva mediante Swagger UI, donde puedes explorar y probar los endpoints.

**Accede a la documentación en:**
  http://localhost:8080/docs