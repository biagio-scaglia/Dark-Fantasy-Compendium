from fastapi import APIRouter, HTTPException
from typing import List
from app.models.lore import Lore
from app.schemas.lore import LoreCreate, LoreUpdate
from app.services.json_service import JSONService
from app.core.config import settings

router = APIRouter(prefix="/lores", tags=["lores"])
json_service = JSONService(settings.data_dir)


@router.get("", response_model=List[Lore])
async def get_lores():
    """Ottiene tutte le storie"""
    lores = json_service.read_all("lores")
    return lores


@router.get("/{lore_id}", response_model=Lore)
async def get_lore(lore_id: int):
    """Ottiene una storia per ID"""
    lore = json_service.read_one("lores", lore_id)
    if not lore:
        raise HTTPException(status_code=404, detail="Lore not found")
    return lore


@router.post("", response_model=Lore, status_code=201)
async def create_lore(lore: LoreCreate):
    """Crea una nuova storia"""
    lore_dict = lore.model_dump()
    created = json_service.create("lores", lore_dict)
    return created


@router.put("/{lore_id}", response_model=Lore)
async def update_lore(lore_id: int, lore: LoreUpdate):
    """Aggiorna una storia esistente"""
    updates = lore.model_dump(exclude_unset=True)
    updated = json_service.update("lores", lore_id, updates)
    if not updated:
        raise HTTPException(status_code=404, detail="Lore not found")
    return updated


@router.delete("/{lore_id}", status_code=204)
async def delete_lore(lore_id: int):
    """Elimina una storia"""
    if not json_service.delete("lores", lore_id):
        raise HTTPException(status_code=404, detail="Lore not found")

