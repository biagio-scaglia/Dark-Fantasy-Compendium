from typing import Optional, List
from pydantic import BaseModel, Field
from app.models.campaign import Session


class CampaignCreate(BaseModel):
    name: str
    description: str
    dungeon_master: str
    players: List[str] = Field(default_factory=list)
    characters: List[int] = Field(default_factory=list)
    sessions: List[Session] = Field(default_factory=list)
    current_level: int = Field(ge=1, default=1)
    setting: Optional[str] = None
    notes: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None


class CampaignUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    dungeon_master: Optional[str] = None
    players: Optional[List[str]] = None
    characters: Optional[List[int]] = None
    sessions: Optional[List[Session]] = None
    current_level: Optional[int] = Field(None, ge=1)
    setting: Optional[str] = None
    notes: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

