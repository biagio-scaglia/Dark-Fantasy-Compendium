from typing import Optional, List
from pydantic import BaseModel, Field


class Spell(BaseModel):
    id: int
    name: str
    level: int = Field(ge=0, le=9, description="Spell level (0 = cantrips)")
    school: str = Field(description="Magic school (e.g., 'Evocation', 'Enchantment')")
    casting_time: str = Field(description="Casting time (e.g., '1 action', '1 minute')")
    range: str = Field(description="Range (e.g., '30 feet', 'Touch', 'Self')")
    components: List[str] = Field(description="Components: V (verbal), S (somatic), M (material)")
    material_components: Optional[str] = Field(None, description="Specific material components")
    duration: str = Field(description="Duration (e.g., 'Instantaneous', 'Concentration, up to 1 minute')")
    description: str
    higher_level: Optional[str] = Field(None, description="Effects at higher levels")
    classes: List[str] = Field(default_factory=list, description="Classes that can cast this spell")
    ritual: bool = Field(default=False)
    concentration: bool = Field(default=False)
    image_url: Optional[str] = None
    icon_url: Optional[str] = None
