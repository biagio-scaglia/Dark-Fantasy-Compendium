from fastapi import APIRouter, HTTPException
from typing import List
from app.models.ability import Ability
from app.schemas.ability import AbilityCreate, AbilityUpdate
from app.services.json_service import JSONService
from app.core.config import settings

router = APIRouter(prefix="/abilities", tags=["abilities"])
json_service = JSONService(settings.data_dir)


@router.get("", response_model=List[Ability])
async def get_abilities():
    """Ottiene tutte le abilità"""
    abilities = json_service.read_all("abilities")
    return abilities


@router.get("/{ability_id}", response_model=Ability)
async def get_ability(ability_id: int):
    """Ottiene un'abilità per ID"""
    ability = json_service.read_one("abilities", ability_id)
    if not ability:
        raise HTTPException(status_code=404, detail="Ability not found")
    return ability


@router.post("", response_model=Ability, status_code=201)
async def create_ability(ability: AbilityCreate):
    """Crea una nuova abilità"""
    ability_dict = ability.model_dump()
    created = json_service.create("abilities", ability_dict)
    return created


@router.put("/{ability_id}", response_model=Ability)
async def update_ability(ability_id: int, ability: AbilityUpdate):
    """Aggiorna un'abilità esistente"""
    updates = ability.model_dump(exclude_unset=True)
    updated = json_service.update("abilities", ability_id, updates)
    if not updated:
        raise HTTPException(status_code=404, detail="Ability not found")
    return updated


@router.delete("/{ability_id}", status_code=204)
async def delete_ability(ability_id: int):
    """Elimina un'abilità"""
    try:
        if not json_service.delete("abilities", ability_id, min_items=0):
            raise HTTPException(status_code=404, detail="Ability not found")
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

