from fastapi import APIRouter, HTTPException
from typing import List
from app.models.character import Character
from app.schemas.character import CharacterCreate, CharacterUpdate
from app.services.json_service import JSONService
from app.core.config import settings

router = APIRouter(prefix="/characters", tags=["characters"])
json_service = JSONService(settings.data_dir)


@router.get("", response_model=List[Character])
async def get_characters():
    """Ottiene tutti i personaggi"""
    characters = json_service.read_all("characters")
    return characters


@router.get("/{character_id}", response_model=Character)
async def get_character(character_id: int):
    """Ottiene un personaggio per ID"""
    character = json_service.read_one("characters", character_id)
    if not character:
        raise HTTPException(status_code=404, detail="Character not found")
    return character


@router.post("", response_model=Character, status_code=201)
async def create_character(character: CharacterCreate):
    """Crea un nuovo personaggio"""
    character_dict = character.model_dump()
    created = json_service.create("characters", character_dict)
    return created


@router.put("/{character_id}", response_model=Character)
async def update_character(character_id: int, character: CharacterUpdate):
    """Aggiorna un personaggio esistente"""
    updates = character.model_dump(exclude_unset=True)
    updated = json_service.update("characters", character_id, updates)
    if not updated:
        raise HTTPException(status_code=404, detail="Character not found")
    return updated


@router.delete("/{character_id}", status_code=204)
async def delete_character(character_id: int):
    """Elimina un personaggio"""
    try:
        if not json_service.delete("characters", character_id, min_items=0):
            raise HTTPException(status_code=404, detail="Character not found")
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

