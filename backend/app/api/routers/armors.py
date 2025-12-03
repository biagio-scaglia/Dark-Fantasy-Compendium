from fastapi import APIRouter, HTTPException
from typing import List
from app.models.armor import Armor
from app.schemas.armor import ArmorCreate, ArmorUpdate
from app.services.json_service import JSONService
from app.core.config import settings

router = APIRouter(prefix="/armors", tags=["armors"])
json_service = JSONService(settings.data_dir)


@router.get("", response_model=List[Armor])
async def get_armors():
    """Ottiene tutte le armature"""
    armors = json_service.read_all("armors")
    return armors


@router.get("/{armor_id}", response_model=Armor)
async def get_armor(armor_id: int):
    """Ottiene un'armatura per ID"""
    armor = json_service.read_one("armors", armor_id)
    if not armor:
        raise HTTPException(status_code=404, detail="Armor not found")
    return armor


@router.post("", response_model=Armor, status_code=201)
async def create_armor(armor: ArmorCreate):
    """Crea una nuova armatura"""
    armor_dict = armor.model_dump()
    created = json_service.create("armors", armor_dict)
    return created


@router.put("/{armor_id}", response_model=Armor)
async def update_armor(armor_id: int, armor: ArmorUpdate):
    """Aggiorna un'armatura esistente"""
    updates = armor.model_dump(exclude_unset=True)
    updated = json_service.update("armors", armor_id, updates)
    if not updated:
        raise HTTPException(status_code=404, detail="Armor not found")
    return updated


@router.delete("/{armor_id}", status_code=204)
async def delete_armor(armor_id: int):
    """Elimina un'armatura"""
    if not json_service.delete("armors", armor_id):
        raise HTTPException(status_code=404, detail="Armor not found")

