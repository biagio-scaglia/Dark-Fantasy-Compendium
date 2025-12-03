from fastapi import APIRouter, HTTPException, Depends
from typing import List
from app.models.knight import Knight
from app.schemas.knight import KnightCreate, KnightUpdate
from app.services.json_service import JSONService
from app.core.config import settings

router = APIRouter(prefix="/knights", tags=["knights"])
json_service = JSONService(settings.data_dir)


@router.get("", response_model=List[Knight])
async def get_knights():
    """Ottiene tutti i cavalieri"""
    knights = json_service.read_all("knights")
    return knights


@router.get("/{knight_id}", response_model=Knight)
async def get_knight(knight_id: int):
    """Ottiene un cavaliere per ID"""
    knight = json_service.read_one("knights", knight_id)
    if not knight:
        raise HTTPException(status_code=404, detail="Knight not found")
    return knight


@router.post("", response_model=Knight, status_code=201)
async def create_knight(knight: KnightCreate):
    """Crea un nuovo cavaliere"""
    knight_dict = knight.model_dump()
    created = json_service.create("knights", knight_dict)
    return created


@router.put("/{knight_id}", response_model=Knight)
async def update_knight(knight_id: int, knight: KnightUpdate):
    """Aggiorna un cavaliere esistente"""
    updates = knight.model_dump(exclude_unset=True)
    updated = json_service.update("knights", knight_id, updates)
    if not updated:
        raise HTTPException(status_code=404, detail="Knight not found")
    return updated


@router.delete("/{knight_id}", status_code=204)
async def delete_knight(knight_id: int):
    """Elimina un cavaliere"""
    if not json_service.delete("knights", knight_id):
        raise HTTPException(status_code=404, detail="Knight not found")

