from fastapi import APIRouter, HTTPException
from typing import List
from app.models.race import Race
from app.schemas.race import RaceCreate, RaceUpdate
from app.services.json_service import JSONService
from app.core.config import settings

router = APIRouter(prefix="/races", tags=["races"])
json_service = JSONService(settings.data_dir)


@router.get("", response_model=List[Race])
async def get_races():
    """Ottiene tutte le razze"""
    races = json_service.read_all("races")
    return races


@router.get("/{race_id}", response_model=Race)
async def get_race(race_id: int):
    """Ottiene una razza per ID"""
    race = json_service.read_one("races", race_id)
    if not race:
        raise HTTPException(status_code=404, detail="Race not found")
    return race


@router.post("", response_model=Race, status_code=201)
async def create_race(race: RaceCreate):
    """Crea una nuova razza"""
    race_dict = race.model_dump()
    created = json_service.create("races", race_dict)
    return created


@router.put("/{race_id}", response_model=Race)
async def update_race(race_id: int, race: RaceUpdate):
    """Aggiorna una razza esistente"""
    updates = race.model_dump(exclude_unset=True)
    updated = json_service.update("races", race_id, updates)
    if not updated:
        raise HTTPException(status_code=404, detail="Race not found")
    return updated


@router.delete("/{race_id}", status_code=204)
async def delete_race(race_id: int):
    """Elimina una razza"""
    try:
        if not json_service.delete("races", race_id, min_items=0):
            raise HTTPException(status_code=404, detail="Race not found")
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

