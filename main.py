from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from api.token import verify_jwt_token
from routers import indicators, targets, aggregations
from routers.target import customer, finance, innovation, process

app = FastAPI()

origins = [
    "http://localhost:3000",
    "http://localhost:3000/home",
    "http://localhost:3000/",
    "http://localhost",
    "http://localhost:8080",
    "https://inventario-lime.vercel.app/home",
    "https://inventario-lime.vercel.app/auth",
    "https://inventario-lime.vercel.app"
]

# Agrega el middleware CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Middleware de autenticación
def get_current_user(token: str = Depends(verify_jwt_token)):
    return token

# Montamos los routers
app.include_router(targets.router)
app.include_router(indicators.router)
app.include_router(aggregations.router)
app.include_router(customer.router)
app.include_router(finance.router)
app.include_router(innovation.router)
app.include_router(process.router)