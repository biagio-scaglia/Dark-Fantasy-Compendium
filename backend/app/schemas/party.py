from typing import Optional, List
from pydantic import BaseModel, Field


class PartyCreate(BaseModel):
    name: str
    description: Optional[str] = None
    campaign_id: Optional[int] = None
    characters: List[int] = Field(default_factory=list)
    level: int = Field(ge=1, le=20, default=1)
    experience_points: int = Field(ge=0, default=0)
    notes: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None


class PartyUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    campaign_id: Optional[int] = None
    characters: Optional[List[int]] = None
    level: Optional[int] = Field(None, ge=1, le=20)
    experience_points: Optional[int] = Field(None, ge=0)
    notes: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

