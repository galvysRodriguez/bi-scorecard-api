# python-BI

Backend de la aplicación de Business Intelligence: API REST en **FastAPI** para el cuadro de mando integral (perspectivas, objetivos, indicadores y fórmulas) y los reportes del ERP (almacén, compras, ventas, pedidos y cotizaciones), más un **ETL** que copia el ERP en MySQL a una base de datos BI en PostgreSQL.

El frontend vive en el repositorio hermano [`nextBI`](../nextBI) (Next.js).

- Producción: https://python-bi-9695.vercel.app (Swagger en [`/docs`](https://python-bi-9695.vercel.app/docs))
- Frontend: https://next-bi-omega.vercel.app

## Stack

- Python 3.10+ (Vercel usa 3.12)
- FastAPI + Uvicorn
- asyncpg (API) y SQLAlchemy + PyMySQL/psycopg2 (ETL)
- SymPy + ANTLR4 para evaluar fórmulas escritas en LaTeX
- PyJWT + bcrypt/passlib para autenticación
- APScheduler para la sincronización periódica del ETL
- pytest + pytest-asyncio

## Estructura

```
├── main.py              # App FastAPI: lifespan, CORS, middleware y routers
├── routers/             # Endpoints (APIRouter); reports/ para reportes
├── services/            # Lógica de negocio; devuelven api_response(...)
├── repositories/        # SQL crudo con asyncpg
├── schemas/target.py    # Todos los modelos Pydantic
├── auth/                # JWT y dependencia get_current_user
├── middleware/          # check_access: permisos por rol/recurso
├── db/                  # Conexión asyncpg (get_db)
├── config/              # OpenAPI personalizado y manejadores de excepciones
├── utils/               # api_response, api_response_etl, helpers
├── etl/                 # Extracción MySQL → Postgres, sync, vistas, seeds, backups
│   ├── json/<schema>/   # Definición de cada tabla a copiar
│   ├── table_config.py  # TABLE_PROCESS, en orden de dependencias FK
│   ├── view/            # Vistas y vistas materializadas de reportes
│   ├── logs/            # Triggers MySQL que llenan la tabla logs
│   └── seed/            # Usuarios, perfiles y recursos iniciales
└── test/                # Tests async contra Postgres local
```

Cada dominio sigue tres capas: `routers/<x>.py` → `services/<x>_service.py` → `repositories/<x>_repo.py`.

## Instalación

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements-dev.txt   # requirements.txt solo incluye lo que va a Vercel
cp .env.example .env
```

### Variables de entorno

| Variable         | Obligatoria | Descripción                                                                 |
| ---------------- | ----------- | --------------------------------------------------------------------------- |
| `DATABASE_URL`   | Sí          | Postgres de la API (Neon en producción).                                    |
| `JWT_SECRET_KEY` | Sí en prod  | Clave para firmar los JWT. Tiene un valor por defecto inseguro para local.  |
| `CORS_ORIGINS`   | No          | Orígenes extra permitidos, separados por coma.                              |
| `VERCEL`         | Automática  | La define Vercel; desactiva el scheduler del ETL.                           |

Las credenciales de MySQL (ERP) y Postgres (BI) que usa el ETL están en `etl/db/erp.py` y `etl/db/bi.py`, separadas de `DATABASE_URL`.

## Ejecutar

```bash
uvicorn main:app --reload --port 8000
```

Documentación interactiva en http://localhost:8000/docs.

Con Docker:

```bash
docker build -t python-bi .
docker run -p 8000:8000 --env-file .env python-bi
```

## API

### Formato de respuesta

La mayoría de los endpoints responden HTTP 200 con este sobre, incluso ante errores lógicos; el cliente debe revisar `status`:

```json
{ "message": "...", "status": true, "data": {}, "error": null }
```

Los endpoints del ETL usan `utils/api_response_etl.py`, que además informa el rango de fechas procesado.

### Autenticación y permisos

1. `POST /users/login` devuelve un JWT.
2. Las demás rutas requieren `Authorization: Bearer <token>`.
3. `middleware/permission.py:check_access` toma el primer segmento de la ruta como recurso y el método HTTP como acción, y verifica el permiso del rol del usuario. `/docs`, `/openapi*` y `/users*` quedan libres.

Los usuarios, perfiles y recursos iniciales se cargan con `POST /seed/all`.

### Endpoints principales

| Prefijo                | Descripción                                                    |
| ---------------------- | -------------------------------------------------------------- |
| `/perspectives`        | Perspectivas del cuadro de mando                               |
| `/targets`             | Objetivos/metas, con detalle y datos para gráficos             |
| `/tags`                | Etiquetas de indicadores por perspectiva                       |
| `/formula`             | Fórmulas en LaTeX que combinan indicadores                     |
| `/indicators`          | Indicadores disponibles                                        |
| `/icons`               | Íconos de perspectivas                                         |
| `/dashboard`           | Métricas y objetivos para el tablero                           |
| `/reports/warehouse`   | Reporte de movimientos de almacén                              |
| `/reports/purchase`    | Reporte de compras                                             |
| `/reports/sale`        | Reporte de ventas                                              |
| `/reports/order`       | Reporte de pedidos                                             |
| `/reports/quote`       | Reporte de cotizaciones                                        |
| `/etl`, `/etl/view`    | Carga, sincronización, vistas y backups                        |
| `/seed`                | Datos iniciales de usuarios y permisos                         |

Consulta `/docs` para los parámetros de cada ruta.

### Fórmulas e indicadores

Las fórmulas se guardan en LaTeX (escritas con MathLive en el frontend), se parsean con `sympy.parsing.latex.parse_latex` en `services/formula_service.py` y sus símbolos se resuelven con los valores de los indicadores (`services/indicator_service.py`). Los objetivos se evalúan a partir de su fórmula, opcionalmente en un rango de fechas o agrupados.

### Reportes

Los reportes trabajan en dos pasos: primero obtienen los IDs paginados, filtrados y buscados (`repositories/reports/query_base.py`) y luego traen las filas agrupadas de esos IDs. Los valores de `order_by` pasan por una lista blanca (`validation_order_by`) porque se interpolan en el SQL.

## ETL

El ETL necesita acceso a MySQL y Postgres locales, por lo que **no funciona en Vercel**.

| Endpoint                 | Acción                                                                    |
| ------------------------ | ------------------------------------------------------------------------- |
| `POST /etl/logs`         | Crea en MySQL la tabla `logs` y los triggers que registran cambios        |
| `DELETE /etl/logs`       | Elimina esos triggers                                                     |
| `POST /etl/extract`      | Carga completa del ERP a la base BI                                       |
| `POST /etl/sync`         | Sincronización incremental a partir de `logs` (upsert/delete por ID)      |
| `DELETE /etl/clear`      | Vacía la base BI                                                          |
| `POST /etl/backup`       | Backup de `source` (MySQL) o `destination` (Postgres) en `backups/`       |
| `POST /etl/view/vw_all`  | Crea todas las vistas de reportes (`DELETE` para eliminarlas)             |

Orden típico para una base nueva: `POST /etl/logs` → `POST /etl/extract` → `POST /etl/view/vw_all` → `POST /seed/all`.

Notas:

- Para agregar una tabla, crea su definición en `etl/json/<schema>/<tabla>.py` (`source_table`, `target_table`, `schema`, `query`) y regístrala en `etl/table_config.py:TABLE_PROCESS` respetando el orden de las FK.
- El último log procesado se guarda **en memoria** (`etl/main.py:last_log_ids`) y se reinicia al reiniciar el servidor.
- Fuera de Vercel, APScheduler (`routers/task.py`) ejecuta la sincronización automáticamente cada 2 horas.

## Tests

```bash
pytest
pytest test/formula/test_formula_repo.py::test_exist_formula_true
```

Los tests se ejecutan desde la raíz del repo y usan una **base Postgres local real** (`postgresql://postgres:olap22@localhost/postgres`, definida en `db/test_database.py` y `test/conftest.py`). Validan filas y conteos concretos, así que fallan si esa base no tiene los datos esperados.

## Despliegue (Vercel)

- Cada push a `master` despliega el proyecto `python-bi-9695` (entrypoint `main.py`).
- Configura `DATABASE_URL`, `JWT_SECRET_KEY` y, si hace falta, `CORS_ORIGINS` en Vercel.
- No nombres ningún directorio del backend `public`: Vercel lo trata como estáticos y lo excluye de la función (por eso existe `etl/json/public_schema`).
- Si la función falla (`FUNCTION_INVOCATION_FAILED`), el navegador lo muestra como error de CORS. Revisa los logs con:

  ```bash
  npx vercel logs --scope galvys-rodriguezs-projects --project python-bi-9695
  ```
