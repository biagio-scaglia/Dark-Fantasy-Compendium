from typing import Optional
from pydantic import BaseModel, Field


class Item(BaseModel):
    id: int
    name: str
    type: str  # consumable, material, quest_item, etc.
    description: str
    effect: Optional[str] = None
    value: int = Field(ge=0, default=0)
    rarity: str = Field(default="common", pattern="^(common|rare|epic|legendary)$")
    lore: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

