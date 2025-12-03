from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field


class MapMarker(BaseModel):
    id: str
    name: str
    x: float = Field(ge=0, le=100, description="Posizione X in percentuale")
    y: float = Field(ge=0, le=100, description="Posizione Y in percentuale")
    type: str = Field(description="Tipo di marker: location, npc, encounter, treasure")
    description: Optional[str] = None
    color: Optional[str] = None


class Map(BaseModel):
    id: int
    name: str
    description: str
    image_url: str = Field(description="URL o path dell'immagine della mappa")
    width: int = Field(ge=1, description="Larghezza in pixel")
    height: int = Field(ge=1, description="Altezza in pixel")
    markers: List[MapMarker] = Field(default_factory=list)
    layers: List[str] = Field(default_factory=list, description="Layer della mappa (es. ['terrain', 'buildings', 'npcs'])")
    campaign_id: Optional[int] = Field(None, description="ID della campagna associata")
    notes: Optional[str] = None

