from typing import Optional, List, Dict
from pydantic import BaseModel, Field
from datetime import datetime


class Session(BaseModel):
    id: int
    date: str = Field(description="Data della sessione (ISO format)")
    title: str
    description: str
    notes: Optional[str] = None
    experience_awarded: int = Field(ge=0, default=0)
    characters_present: List[int] = Field(default_factory=list, description="IDs dei personaggi presenti")


class Campaign(BaseModel):
    id: int
    name: str
    description: str
    dungeon_master: str = Field(description="Nome del DM")
    players: List[str] = Field(default_factory=list, description="Nomi dei giocatori")
    characters: List[int] = Field(default_factory=list, description="IDs dei personaggi della campagna")
    sessions: List[Session] = Field(default_factory=list)
    current_level: int = Field(ge=1, default=1, description="Livello attuale della campagna")
    setting: Optional[str] = None
    notes: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

