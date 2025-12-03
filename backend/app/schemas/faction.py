from typing import Optional
from pydantic import BaseModel


class FactionCreate(BaseModel):
    name: str
    description: str
    lore: Optional[str] = None
    color: str
    image_url: Optional[str] = None
    icon_url: Optional[str] = None


class FactionUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    lore: Optional[str] = None
    color: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

