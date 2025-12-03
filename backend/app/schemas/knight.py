from typing import Optional
from pydantic import BaseModel, Field


class KnightCreate(BaseModel):
    name: str
    title: str
    faction_id: int
    level: int = Field(ge=1, le=100, default=1)
    health: int = Field(ge=0, default=100)
    max_health: int = Field(ge=1, default=100)
    attack: int = Field(ge=0, default=10)
    defense: int = Field(ge=0, default=10)
    weapon_id: Optional[int] = None
    armor_id: Optional[int] = None
    description: str
    lore: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None


class KnightUpdate(BaseModel):
    name: Optional[str] = None
    title: Optional[str] = None
    faction_id: Optional[int] = None
    level: Optional[int] = Field(None, ge=1, le=100)
    health: Optional[int] = Field(None, ge=0)
    max_health: Optional[int] = Field(None, ge=1)
    attack: Optional[int] = Field(None, ge=0)
    defense: Optional[int] = Field(None, ge=0)
    weapon_id: Optional[int] = None
    armor_id: Optional[int] = None
    description: Optional[str] = None
    lore: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

