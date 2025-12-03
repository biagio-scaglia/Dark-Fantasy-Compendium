from fastapi import APIRouter, HTTPException
from typing import List
from app.models.item import Item
from app.schemas.item import ItemCreate, ItemUpdate
from app.services.json_service import JSONService
from app.core.config import settings

router = APIRouter(prefix="/items", tags=["items"])
json_service = JSONService(settings.data_dir)


@router.get("", response_model=List[Item])
async def get_items():
    """Ottiene tutti gli oggetti"""
    items = json_service.read_all("items")
    return items


@router.get("/{item_id}", response_model=Item)
async def get_item(item_id: int):
    """Ottiene un oggetto per ID"""
    item = json_service.read_one("items", item_id)
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")
    return item


@router.post("", response_model=Item, status_code=201)
async def create_item(item: ItemCreate):
    """Crea un nuovo oggetto"""
    item_dict = item.model_dump()
    created = json_service.create("items", item_dict)
    return created


@router.put("/{item_id}", response_model=Item)
async def update_item(item_id: int, item: ItemUpdate):
    """Aggiorna un oggetto esistente"""
    updates = item.model_dump(exclude_unset=True)
    updated = json_service.update("items", item_id, updates)
    if not updated:
        raise HTTPException(status_code=404, detail="Item not found")
    return updated


@router.delete("/{item_id}", status_code=204)
async def delete_item(item_id: int):
    """Elimina un oggetto (mantiene almeno un elemento minimo)"""
    try:
        if not json_service.delete("items", item_id, min_items=1):
            raise HTTPException(status_code=404, detail="Item not found")
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))

