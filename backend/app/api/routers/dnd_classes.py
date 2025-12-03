from fastapi import APIRouter, HTTPException
from typing import List
from app.models.dnd_class import DndClass
from app.schemas.dnd_class import DndClassCreate, DndClassUpdate
from app.services.json_service import JSONService
from app.core.config import settings

router = APIRouter(prefix="/dnd-classes", tags=["dnd-classes"])
json_service = JSONService(settings.data_dir)


@router.get("", response_model=List[DndClass])
async def get_dnd_classes():
    """Ottiene tutte le classi D&D"""
    classes = json_service.read_all("dnd_classes")
    return classes


@router.get("/{class_id}", response_model=DndClass)
async def get_dnd_class(class_id: int):
    """Ottiene una classe D&D per ID"""
    dnd_class = json_service.read_one("dnd_classes", class_id)
    if not dnd_class:
        raise HTTPException(status_code=404, detail="D&D Class not found")
    return dnd_class


@router.post("", response_model=DndClass, status_code=201)
async def create_dnd_class(dnd_class: DndClassCreate):
    """Crea una nuova classe D&D"""
    class_dict = dnd_class.model_dump()
    created = json_service.create("dnd_classes", class_dict)
    return created


@router.put("/{class_id}", response_model=DndClass)
async def update_dnd_class(class_id: int, dnd_class: DndClassUpdate):
    """Aggiorna una classe D&D esistente"""
    updates = dnd_class.model_dump(exclude_unset=True)
    updated = json_service.update("dnd_classes", class_id, updates)
    if not updated:
        raise HTTPException(status_code=404, detail="D&D Class not found")
    return updated


@router.delete("/{class_id}", status_code=204)
async def delete_dnd_class(class_id: int):
    """Elimina una classe D&D"""
    try:
        if not json_service.delete("dnd_classes", class_id, min_items=0):
            raise HTTPException(status_code=404, detail="D&D Class not found")
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

