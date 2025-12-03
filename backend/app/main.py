from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.api.routers import knights, weapons, armors, factions, bosses, items, lores, upload

app = FastAPI(
    title=settings.app_name,
    version=settings.version,
    description="API per il Dark Fantasy Compendium"
)

# CORS middleware per permettere chiamate dal frontend Flutter
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In produzione, specificare gli origin corretti
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include tutti i router
app.include_router(knights.router, prefix=settings.api_prefix)
app.include_router(weapons.router, prefix=settings.api_prefix)
app.include_router(armors.router, prefix=settings.api_prefix)
app.include_router(factions.router, prefix=settings.api_prefix)
app.include_router(bosses.router, prefix=settings.api_prefix)
app.include_router(items.router, prefix=settings.api_prefix)
app.include_router(lores.router, prefix=settings.api_prefix)
app.include_router(upload.router, prefix=settings.api_prefix)


@app.get("/")
async def root():
    """Endpoint root"""
    return {
        "message": "Dark Fantasy Compendium API",
        "version": settings.version,
        "docs": "/docs"
    }


@app.get("/health")
async def health():
    """Health check endpoint"""
    return {"status": "healthy"}

