from typing import Optional
from pydantic import BaseModel, Field


class AbilityCreate(BaseModel):
    name: str
    description: str
    ability_type: str = "skill"
    ability_score: str
    modifier: Optional[int] = None
    proficiency_bonus: bool = False
    image_url: Optional[str] = None
    icon_url: Optional[str] = None


class AbilityUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    ability_type: Optional[str] = None
    ability_score: Optional[str] = None
    modifier: Optional[int] = None
    proficiency_bonus: Optional[bool] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

