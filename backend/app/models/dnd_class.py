from typing import Optional, List
from pydantic import BaseModel, Field


class DndClass(BaseModel):
    id: int
    name: str
    description: str
    hit_dice: str = Field(description="Dado vita (es. '1d8', '1d10')")
    hit_points_at_1st_level: int = Field(ge=1)
    hit_points_at_higher_levels: str = Field(description="Es. '1d8 (o 5) + modificatore di Costituzione'")
    proficiencies: List[str] = Field(default_factory=list, description="Lista di competenze")
    saving_throws: List[str] = Field(default_factory=list, description="Tiri salvezza (es. ['Forza', 'Costituzione'])")
    starting_equipment: List[str] = Field(default_factory=list)
    class_features: List[str] = Field(default_factory=list, description="Caratteristiche di classe")
    spellcasting_ability: Optional[str] = Field(None, description="Caratteristica per incantesimi (es. 'Saggezza')")
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

