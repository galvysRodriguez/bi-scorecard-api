import os
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from routers import indicators, targets, formula, tag, perspective, test, icon, etl, task, user, seed, view
from routers.reports import warehouse, sale, purchase, order, quote, metric
from middleware.permission import check_access
from contextlib import asynccontextmanager
from config.openapi_config import custom_openapi

@asynccontextmanager
async def lifespan(app: FastAPI):
    # En Vercel (serverless) no hay proceso persistente para el scheduler
    if os.getenv("VERCEL"):
        yield
        return
    task.scheduler.start()
    print("Scheduler iniciado automáticamente.")
    yield
    task.scheduler.shutdown()
    print("Scheduler detenido.")

app = FastAPI(lifespan=lifespan)
app.middleware("http")(check_access)

origins = [
    "http://localhost:3000",
    "http://localhost",
    "http://localhost:8080",
    "https://inventario-lime.vercel.app",
    "https://next-ld7wnhs03-galvys-rodriguezs-projects.vercel.app",
    "https://next-bi-omega.vercel.app",
]

# Orígenes extra separados por coma, configurables desde Vercel sin redeploy de código
origins += [o.strip() for o in os.getenv("CORS_ORIGINS", "").split(",") if o.strip()]

# Agrega el middleware CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    # Dominios del frontend en Vercel y cualquier deploy del equipo (xxxx-galvys-rodriguezs-projects.vercel.app)
    allow_origin_regex=r"https://(next-bi(-[a-z0-9-]+)?|[a-z0-9-]+-galvys-rodriguezs-projects)\.vercel\.app",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Configurar OpenAPI personalizado
app.openapi = lambda: custom_openapi(app)
# Montamos los routers
app.include_router(targets.router)
app.include_router(indicators.router)
app.include_router(formula.router)
app.include_router(tag.router)
app.include_router(perspective.router)
app.include_router(icon.router)
app.include_router(warehouse.router)
app.include_router(sale.router)
app.include_router(purchase.router)
app.include_router(order.router)
app.include_router(quote.router)
app.include_router(metric.router)
app.include_router(user.router)
app.include_router(etl.router)
app.include_router(view.router)
app.include_router(seed.router)
app.include_router(task.router)
app.include_router(test.router)