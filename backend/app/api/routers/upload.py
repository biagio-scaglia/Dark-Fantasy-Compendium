from fastapi import APIRouter, UploadFile, File, HTTPException
from fastapi.responses import FileResponse
from pathlib import Path
import shutil
import uuid
from app.core.config import settings

router = APIRouter(prefix="/upload", tags=["upload"])

# Directory per salvare le immagini (relativa alla root del progetto)
BASE_DIR = Path(__file__).parent.parent.parent.parent
UPLOAD_DIR = BASE_DIR / "backend" / "assets" / "images"
ICON_DIR = BASE_DIR / "backend" / "assets" / "icons"

# Crea le directory se non esistono
UPLOAD_DIR.mkdir(parents=True, exist_ok=True)
ICON_DIR.mkdir(parents=True, exist_ok=True)


@router.post("/image")
async def upload_image(file: UploadFile = File(...)):
    """Carica un'immagine e restituisce l'URL"""
    try:
        # Genera un nome univoco per il file
        file_extension = Path(file.filename).suffix
        unique_filename = f"{uuid.uuid4()}{file_extension}"
        file_path = UPLOAD_DIR / unique_filename
        
        # Salva il file
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        
        # Restituisce l'URL relativo (il frontend aggiungerà il baseUrl)
        return {"url": f"upload/image/{unique_filename}"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Errore nel caricamento: {str(e)}")


@router.post("/icon")
async def upload_icon(file: UploadFile = File(...)):
    """Carica un'icona e restituisce l'URL"""
    try:
        # Genera un nome univoco per il file
        file_extension = Path(file.filename).suffix
        unique_filename = f"{uuid.uuid4()}{file_extension}"
        file_path = ICON_DIR / unique_filename
        
        # Salva il file
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        
        # Restituisce l'URL relativo (il frontend aggiungerà il baseUrl)
        return {"url": f"upload/icon/{unique_filename}"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Errore nel caricamento: {str(e)}")


@router.get("/image/{filename}")
async def get_image(filename: str):
    """Restituisce un'immagine"""
    file_path = UPLOAD_DIR / filename
    if not file_path.exists():
        raise HTTPException(status_code=404, detail="Immagine non trovata")
    return FileResponse(file_path)


@router.get("/icon/{filename}")
async def get_icon(filename: str):
    """Restituisce un'icona"""
    file_path = ICON_DIR / filename
    if not file_path.exists():
        raise HTTPException(status_code=404, detail="Icona non trovata")
    return FileResponse(file_path)

