from fastapi import APIRouter, HTTPException
from typing import List
from app.models.boss import Boss
from app.schemas.boss import BossCreate, BossUpdate
from app.services.json_service import JSONService
from app.core.config import settings

router = APIRouter(prefix="/bosses", tags=["bosses"])
json_service = JSONService(settings.data_dir)


@router.get("", response_model=List[Boss])
async def get_bosses():
    """Ottiene tutti i boss"""
    bosses = json_service.read_all("bosses")
    return bosses


@router.get("/{boss_id}", response_model=Boss)
async def get_boss(boss_id: int):
    """Ottiene un boss per ID"""
    boss = json_service.read_one("bosses", boss_id)
    if not boss:
        raise HTTPException(status_code=404, detail="Boss not found")
    return boss


@router.post("", response_model=Boss, status_code=201)
async def create_boss(boss: BossCreate):
    """Crea un nuovo boss"""
    boss_dict = boss.model_dump()
    created = json_service.create("bosses", boss_dict)
    return created


@router.put("/{boss_id}", response_model=Boss)
async def update_boss(boss_id: int, boss: BossUpdate):
    """Aggiorna un boss esistente"""
    updates = boss.model_dump(exclude_unset=True)
    updated = json_service.update("bosses", boss_id, updates)
    if not updated:
        raise HTTPException(status_code=404, detail="Boss not found")
    return updated


@router.delete("/{boss_id}", status_code=204)
async def delete_boss(boss_id: int):
    """Elimina un boss (mantiene almeno un elemento minimo)"""
    try:
        if not json_service.delete("bosses", boss_id, min_items=1):
            raise HTTPException(status_code=404, detail="Boss not found")
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

