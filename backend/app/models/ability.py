from typing import Optional
from pydantic import BaseModel, Field


class Ability(BaseModel):
    id: int
    name: str
    description: str
    ability_type: str = Field(description="Tipo: skill, saving_throw, attack, other")
    ability_score: str = Field(description="Caratteristica associata: Forza, Destrezza, Costituzione, Intelligenza, Saggezza, Carisma")
    modifier: Optional[int] = Field(None, description="Modificatore fisso (se applicabile)")
    proficiency_bonus: bool = Field(default=False, description="Se può beneficiare del bonus di competenza")
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

