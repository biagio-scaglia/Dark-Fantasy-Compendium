from typing import Optional
from pydantic import BaseModel


class Faction(BaseModel):
    id: int
    name: str
    description: str
    lore: Optional[str] = None
    color: str  # hex color for UI
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

