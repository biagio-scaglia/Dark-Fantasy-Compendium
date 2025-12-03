from fastapi import APIRouter, HTTPException
from typing import List
from app.models.faction import Faction
from app.schemas.faction import FactionCreate, FactionUpdate
from app.services.json_service import JSONService
from app.core.config import settings

router = APIRouter(prefix="/factions", tags=["factions"])
json_service = JSONService(settings.data_dir)


@router.get("", response_model=List[Faction])
async def get_factions():
    """Ottiene tutte le fazioni"""
    factions = json_service.read_all("factions")
    return factions


@router.get("/{faction_id}", response_model=Faction)
async def get_faction(faction_id: int):
    """Ottiene una fazione per ID"""
    faction = json_service.read_one("factions", faction_id)
    if not faction:
        raise HTTPException(status_code=404, detail="Faction not found")
    return faction


@router.post("", response_model=Faction, status_code=201)
async def create_faction(faction: FactionCreate):
    """Crea una nuova fazione"""
    faction_dict = faction.model_dump()
    created = json_service.create("factions", faction_dict)
    return created


@router.put("/{faction_id}", response_model=Faction)
async def update_faction(faction_id: int, faction: FactionUpdate):
    """Aggiorna una fazione esistente"""
    updates = faction.model_dump(exclude_unset=True)
    updated = json_service.update("factions", faction_id, updates)
    if not updated:
        raise HTTPException(status_code=404, detail="Faction not found")
    return updated


@router.delete("/{faction_id}", status_code=204)
async def delete_faction(faction_id: int):
    """Elimina una fazione (mantiene almeno un elemento minimo)"""
    try:
        if not json_service.delete("factions", faction_id, min_items=1):
            raise HTTPException(status_code=404, detail="Faction not found")
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

