from typing import Optional, List
from pydantic import BaseModel, Field


class DndClass(BaseModel):
    id: int
    name: str
    description: str
    hit_dice: str = Field(description="Hit dice (e.g., '1d8', '1d10')")
    hit_points_at_1st_level: int = Field(ge=1)
    hit_points_at_higher_levels: str = Field(description="e.g., '1d8 (or 5) + Constitution modifier'")
    proficiencies: List[str] = Field(default_factory=list, description="List of proficiencies")
    saving_throws: List[str] = Field(default_factory=list, description="Saving throws (e.g., ['Strength', 'Constitution'])")
    starting_equipment: List[str] = Field(default_factory=list)
    class_features: List[str] = Field(default_factory=list, description="Class features")
    spellcasting_ability: Optional[str] = Field(None, description="Spellcasting ability (e.g., 'Wisdom')")
    image_url: Optional[str] = None
    icon_url: Optional[str] = None
