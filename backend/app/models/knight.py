from typing import Optional, List
from pydantic import BaseModel, Field


class Knight(BaseModel):
    id: int
    name: str
    title: str
    faction_id: int
    level: int = Field(ge=1, le=100)
    health: int = Field(ge=0)
    max_health: int = Field(ge=1)
    attack: int = Field(ge=0)
    defense: int = Field(ge=0)
    weapon_id: Optional[int] = None
    armor_id: Optional[int] = None
    description: str
    lore: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

