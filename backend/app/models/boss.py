from typing import Optional
from pydantic import BaseModel, Field


class Boss(BaseModel):
    id: int
    name: str
    title: str
    level: int = Field(ge=1, le=100)
    health: int = Field(ge=1)
    max_health: int = Field(ge=1)
    attack: int = Field(ge=0)
    defense: int = Field(ge=0)
    description: str
    lore: Optional[str] = None
    rewards: list = Field(default_factory=list)  # list of item IDs
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

