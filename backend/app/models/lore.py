from typing import Optional
from pydantic import BaseModel


class Lore(BaseModel):
    id: int
    title: str
    category: str  # history, legend, prophecy, etc.
    content: str
    related_entity_type: Optional[str] = None  # knight, weapon, etc.
    related_entity_id: Optional[int] = None
    image_url: Optional[str] = None

