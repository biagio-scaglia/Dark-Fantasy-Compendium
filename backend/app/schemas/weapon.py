from typing import Optional
from pydantic import BaseModel, Field


class WeaponCreate(BaseModel):
    name: str
    type: str
    attack_bonus: int = Field(ge=0, default=0)
    durability: int = Field(ge=0, le=100, default=100)
    rarity: str = Field(default="common", pattern="^(common|rare|epic|legendary)$")
    description: str
    lore: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None


class WeaponUpdate(BaseModel):
    name: Optional[str] = None
    type: Optional[str] = None
    attack_bonus: Optional[int] = Field(None, ge=0)
    durability: Optional[int] = Field(None, ge=0, le=100)
    rarity: Optional[str] = Field(None, pattern="^(common|rare|epic|legendary)$")
    description: Optional[str] = None
    lore: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

