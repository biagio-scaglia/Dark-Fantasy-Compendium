from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field


class MapMarker(BaseModel):
    id: str
    name: str
    x: float = Field(ge=0, le=100, description="X position in percentage")
    y: float = Field(ge=0, le=100, description="Y position in percentage")
    type: str = Field(description="Marker type: location, npc, encounter, treasure")
    description: Optional[str] = None
    color: Optional[str] = None


class Map(BaseModel):
    id: int
    name: str
    description: str
    image_url: str = Field(description="Map image URL or path")
    width: int = Field(ge=1, description="Width in pixels")
    height: int = Field(ge=1, description="Height in pixels")
    markers: List[MapMarker] = Field(default_factory=list)
    layers: List[str] = Field(default_factory=list, description="Map layers (e.g., ['terrain', 'buildings', 'npcs'])")
    campaign_id: Optional[int] = Field(None, description="Associated campaign ID")
    notes: Optional[str] = None
