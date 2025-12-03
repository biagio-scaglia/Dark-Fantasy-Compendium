from typing import Optional, List, Dict
from pydantic import BaseModel, Field


class Race(BaseModel):
    id: int
    name: str
    description: str
    size: str = Field(description="Taglia: Piccola, Media, Grande")
    speed: int = Field(ge=0, description="Velocità in piedi")
    ability_score_increases: Dict[str, int] = Field(
        default_factory=dict,
        description="Aumenti ai punteggi di caratteristica (es. {'Forza': 2, 'Destrezza': 1})"
    )
    traits: List[str] = Field(default_factory=list, description="Tratti razziali")
    languages: List[str] = Field(default_factory=list, description="Linguaggi conosciuti")
    subraces: List[str] = Field(default_factory=list, description="Sottorazze disponibili")
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

