from typing import Optional
from pydantic import BaseModel, Field


class ItemCreate(BaseModel):
    name: str
    type: str
    description: str
    effect: Optional[str] = None
    value: int = Field(ge=0, default=0)
    rarity: str = Field(default="common", pattern="^(common|rare|epic|legendary)$")
    lore: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None


class ItemUpdate(BaseModel):
    name: Optional[str] = None
    type: Optional[str] = None
    description: Optional[str] = None
    effect: Optional[str] = None
    value: Optional[int] = Field(None, ge=0)
    rarity: Optional[str] = Field(None, pattern="^(common|rare|epic|legendary)$")
    lore: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

