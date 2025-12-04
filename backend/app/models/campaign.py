from typing import Optional, List, Dict
from pydantic import BaseModel, Field
from datetime import datetime


class Session(BaseModel):
    id: int
    date: str = Field(description="Session date (ISO format)")
    title: str
    description: str
    notes: Optional[str] = None
    experience_awarded: int = Field(ge=0, default=0)
    characters_present: List[int] = Field(default_factory=list, description="IDs of characters present")


class Campaign(BaseModel):
    id: int
    name: str
    description: str
    dungeon_master: str = Field(description="DM name")
    players: List[str] = Field(default_factory=list, description="Player names")
    characters: List[int] = Field(default_factory=list, description="IDs of the campaign's characters")
    sessions: List[Session] = Field(default_factory=list)
    current_level: int = Field(ge=1, default=1, description="Current campaign level")
    setting: Optional[str] = None
    notes: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None
