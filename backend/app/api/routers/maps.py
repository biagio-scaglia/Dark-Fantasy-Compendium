from fastapi import APIRouter, HTTPException
from typing import List
from app.models.map import Map
from app.schemas.map import MapCreate, MapUpdate
from app.services.json_service import JSONService
from app.core.config import settings

router = APIRouter(prefix="/maps", tags=["maps"])
json_service = JSONService(settings.data_dir)


@router.get("", response_model=List[Map])
async def get_maps():
    """Ottiene tutte le mappe"""
    maps = json_service.read_all("maps")
    return maps


@router.get("/{map_id}", response_model=Map)
async def get_map(map_id: int):
    """Ottiene una mappa per ID"""
    map = json_service.read_one("maps", map_id)
    if not map:
        raise HTTPException(status_code=404, detail="Map not found")
    return map


@router.post("", response_model=Map, status_code=201)
async def create_map(map: MapCreate):
    """Crea una nuova mappa"""
    map_dict = map.model_dump()
    created = json_service.create("maps", map_dict)
    return created


@router.put("/{map_id}", response_model=Map)
async def update_map(map_id: int, map: MapUpdate):
    """Aggiorna una mappa esistente"""
    updates = map.model_dump(exclude_unset=True)
    updated = json_service.update("maps", map_id, updates)
    if not updated:
        raise HTTPException(status_code=404, detail="Map not found")
    return updated


@router.delete("/{map_id}", status_code=204)
async def delete_map(map_id: int):
    """Elimina una mappa"""
    try:
        if not json_service.delete("maps", map_id, min_items=0):
            raise HTTPException(status_code=404, detail="Map not found")
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

