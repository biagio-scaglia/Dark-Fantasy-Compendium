from typing import Optional, List, Dict
from pydantic import BaseModel, Field


class Party(BaseModel):
    id: int
    name: str
    description: Optional[str] = None
    campaign_id: Optional[int] = Field(None, description="Associated campaign ID")
    characters: List[int] = Field(default_factory=list, description="IDs of characters in the party")
    level: int = Field(ge=1, le=20, default=1, description="Average party level")
    experience_points: int = Field(ge=0, default=0, description="Total experience points of the party")
    notes: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None
