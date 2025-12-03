from typing import Optional
from pydantic import BaseModel, Field


class Weapon(BaseModel):
    id: int
    name: str
    type: str  # sword, axe, mace, etc.
    attack_bonus: int = Field(ge=0)
    durability: int = Field(ge=0, le=100)
    rarity: str = Field(default="common", pattern="^(common|rare|epic|legendary)$")
    description: str
    lore: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

