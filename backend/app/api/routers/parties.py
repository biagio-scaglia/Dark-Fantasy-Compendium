from fastapi import APIRouter, HTTPException
from typing import List
from app.models.party import Party
from app.schemas.party import PartyCreate, PartyUpdate
from app.services.json_service import JSONService
from app.core.config import settings

router = APIRouter(prefix="/parties", tags=["parties"])
json_service = JSONService(settings.data_dir)


@router.get("", response_model=List[Party])
async def get_parties():
    """Ottiene tutti i party"""
    parties = json_service.read_all("parties")
    return parties


@router.get("/{party_id}", response_model=Party)
async def get_party(party_id: int):
    """Ottiene un party per ID"""
    party = json_service.read_one("parties", party_id)
    if not party:
        raise HTTPException(status_code=404, detail="Party not found")
    return party


@router.post("", response_model=Party, status_code=201)
async def create_party(party: PartyCreate):
    """Crea un nuovo party"""
    party_dict = party.model_dump()
    created = json_service.create("parties", party_dict)
    return created


@router.put("/{party_id}", response_model=Party)
async def update_party(party_id: int, party: PartyUpdate):
    """Aggiorna un party esistente"""
    updates = party.model_dump(exclude_unset=True)
    updated = json_service.update("parties", party_id, updates)
    if not updated:
        raise HTTPException(status_code=404, detail="Party not found")
    return updated


@router.delete("/{party_id}", status_code=204)
async def delete_party(party_id: int):
    """Elimina un party"""
    try:
        if not json_service.delete("parties", party_id, min_items=0):
            raise HTTPException(status_code=404, detail="Party not found")
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

