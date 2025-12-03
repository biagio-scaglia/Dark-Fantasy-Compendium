from typing import Optional, List
from pydantic import BaseModel, Field


class DndClassCreate(BaseModel):
    name: str
    description: str
    hit_dice: str = "1d8"
    hit_points_at_1st_level: int = Field(ge=1, default=8)
    hit_points_at_higher_levels: str = "1d8 (o 5) + modificatore di Costituzione"
    proficiencies: List[str] = Field(default_factory=list)
    saving_throws: List[str] = Field(default_factory=list)
    starting_equipment: List[str] = Field(default_factory=list)
    class_features: List[str] = Field(default_factory=list)
    spellcasting_ability: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None


class DndClassUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    hit_dice: Optional[str] = None
    hit_points_at_1st_level: Optional[int] = Field(None, ge=1)
    hit_points_at_higher_levels: Optional[str] = None
    proficiencies: Optional[List[str]] = None
    saving_throws: Optional[List[str]] = None
    starting_equipment: Optional[List[str]] = None
    class_features: Optional[List[str]] = None
    spellcasting_ability: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

