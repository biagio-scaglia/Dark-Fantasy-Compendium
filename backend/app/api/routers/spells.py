from fastapi import APIRouter, HTTPException
from typing import List
from app.models.spell import Spell
from app.schemas.spell import SpellCreate, SpellUpdate
from app.services.json_service import JSONService
from app.core.config import settings

router = APIRouter(prefix="/spells", tags=["spells"])
json_service = JSONService(settings.data_dir)


@router.get("", response_model=List[Spell])
async def get_spells():
    """Ottiene tutti gli incantesimi"""
    spells = json_service.read_all("spells")
    return spells


@router.get("/{spell_id}", response_model=Spell)
async def get_spell(spell_id: int):
    """Ottiene un incantesimo per ID"""
    spell = json_service.read_one("spells", spell_id)
    if not spell:
        raise HTTPException(status_code=404, detail="Spell not found")
    return spell


@router.post("", response_model=Spell, status_code=201)
async def create_spell(spell: SpellCreate):
    """Crea un nuovo incantesimo"""
    spell_dict = spell.model_dump()
    created = json_service.create("spells", spell_dict)
    return created


@router.put("/{spell_id}", response_model=Spell)
async def update_spell(spell_id: int, spell: SpellUpdate):
    """Aggiorna un incantesimo esistente"""
    updates = spell.model_dump(exclude_unset=True)
    updated = json_service.update("spells", spell_id, updates)
    if not updated:
        raise HTTPException(status_code=404, detail="Spell not found")
    return updated


@router.delete("/{spell_id}", status_code=204)
async def delete_spell(spell_id: int):
    """Elimina un incantesimo"""
    try:
        if not json_service.delete("spells", spell_id, min_items=0):
            raise HTTPException(status_code=404, detail="Spell not found")
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

