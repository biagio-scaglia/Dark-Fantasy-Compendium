from typing import Optional, List
from pydantic import BaseModel, Field


class BossCreate(BaseModel):
    name: str
    title: str
    level: int = Field(ge=1, le=100, default=1)
    health: int = Field(ge=1, default=1000)
    max_health: int = Field(ge=1, default=1000)
    attack: int = Field(ge=0, default=50)
    defense: int = Field(ge=0, default=30)
    description: str
    lore: Optional[str] = None
    rewards: List[int] = Field(default_factory=list)
    image_url: Optional[str] = None
    icon_url: Optional[str] = None


class BossUpdate(BaseModel):
    name: Optional[str] = None
    title: Optional[str] = None
    level: Optional[int] = Field(None, ge=1, le=100)
    health: Optional[int] = Field(None, ge=1)
    max_health: Optional[int] = Field(None, ge=1)
    attack: Optional[int] = Field(None, ge=0)
    defense: Optional[int] = Field(None, ge=0)
    description: Optional[str] = None
    lore: Optional[str] = None
    rewards: Optional[List[int]] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

