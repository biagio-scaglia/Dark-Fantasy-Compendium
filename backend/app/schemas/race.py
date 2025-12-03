from typing import Optional, List, Dict
from pydantic import BaseModel, Field


class RaceCreate(BaseModel):
    name: str
    description: str
    size: str = "Media"
    speed: int = Field(ge=0, default=30)
    ability_score_increases: Dict[str, int] = Field(default_factory=dict)
    traits: List[str] = Field(default_factory=list)
    languages: List[str] = Field(default_factory=list)
    subraces: List[str] = Field(default_factory=list)
    image_url: Optional[str] = None
    icon_url: Optional[str] = None


class RaceUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    size: Optional[str] = None
    speed: Optional[int] = Field(None, ge=0)
    ability_score_increases: Optional[Dict[str, int]] = None
    traits: Optional[List[str]] = None
    languages: Optional[List[str]] = None
    subraces: Optional[List[str]] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

