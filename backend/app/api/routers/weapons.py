from fastapi import APIRouter, HTTPException
from typing import List
from app.models.weapon import Weapon
from app.schemas.weapon import WeaponCreate, WeaponUpdate
from app.services.json_service import JSONService
from app.core.config import settings

router = APIRouter(prefix="/weapons", tags=["weapons"])
json_service = JSONService(settings.data_dir)


@router.get("", response_model=List[Weapon])
async def get_weapons():
    """Ottiene tutte le armi"""
    weapons = json_service.read_all("weapons")
    return weapons


@router.get("/{weapon_id}", response_model=Weapon)
async def get_weapon(weapon_id: int):
    """Ottiene un'arma per ID"""
    weapon = json_service.read_one("weapons", weapon_id)
    if not weapon:
        raise HTTPException(status_code=404, detail="Weapon not found")
    return weapon


@router.post("", response_model=Weapon, status_code=201)
async def create_weapon(weapon: WeaponCreate):
    """Crea una nuova arma"""
    weapon_dict = weapon.model_dump()
    created = json_service.create("weapons", weapon_dict)
    return created


@router.put("/{weapon_id}", response_model=Weapon)
async def update_weapon(weapon_id: int, weapon: WeaponUpdate):
    """Aggiorna un'arma esistente"""
    updates = weapon.model_dump(exclude_unset=True)
    updated = json_service.update("weapons", weapon_id, updates)
    if not updated:
        raise HTTPException(status_code=404, detail="Weapon not found")
    return updated


@router.delete("/{weapon_id}", status_code=204)
async def delete_weapon(weapon_id: int):
    """Elimina un'arma"""
    if not json_service.delete("weapons", weapon_id):
        raise HTTPException(status_code=404, detail="Weapon not found")

