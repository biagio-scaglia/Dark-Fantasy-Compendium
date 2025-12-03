from typing import Optional
from pydantic import BaseModel


class LoreCreate(BaseModel):
    title: str
    category: str
    content: str
    related_entity_type: Optional[str] = None
    related_entity_id: Optional[int] = None
    image_url: Optional[str] = None


class LoreUpdate(BaseModel):
    title: Optional[str] = None
    category: Optional[str] = None
    content: Optional[str] = None
    related_entity_type: Optional[str] = None
    related_entity_id: Optional[int] = None
    image_url: Optional[str] = None

