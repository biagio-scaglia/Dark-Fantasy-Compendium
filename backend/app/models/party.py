from typing import Optional, List, Dict
from pydantic import BaseModel, Field


class Party(BaseModel):
    id: int
    name: str
    description: Optional[str] = None
    campaign_id: Optional[int] = Field(None, description="ID della campagna associata")
    characters: List[int] = Field(default_factory=list, description="IDs dei personaggi nel party")
    level: int = Field(ge=1, le=20, default=1, description="Livello medio del party")
    experience_points: int = Field(ge=0, default=0, description="Punti esperienza totali del party")
    notes: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

