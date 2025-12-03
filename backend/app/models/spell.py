from typing import Optional, List
from pydantic import BaseModel, Field


class Spell(BaseModel):
    id: int
    name: str
    level: int = Field(ge=0, le=9, description="Livello incantesimo (0 = trucchetti)")
    school: str = Field(description="Scuola di magia (es. 'Evocazione', 'Ammaliamento')")
    casting_time: str = Field(description="Tempo di lancio (es. '1 azione', '1 minuto')")
    range: str = Field(description="Gittata (es. '30 piedi', 'Tocco', 'Sé stesso')")
    components: List[str] = Field(description="Componenti: V (verbale), S (somatico), M (materiale)")
    material_components: Optional[str] = Field(None, description="Componenti materiali specifici")
    duration: str = Field(description="Durata (es. 'Istantaneo', 'Concentrazione, fino a 1 minuto')")
    description: str
    higher_level: Optional[str] = Field(None, description="Effetti a livelli superiori")
    classes: List[str] = Field(default_factory=list, description="Classi che possono lanciare questo incantesimo")
    ritual: bool = Field(default=False)
    concentration: bool = Field(default=False)
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

