from typing import Optional, List
from pydantic import BaseModel, Field
from app.models.map import MapMarker


class MapCreate(BaseModel):
    name: str
    description: str
    image_url: str
    width: int = Field(ge=1, default=1000)
    height: int = Field(ge=1, default=1000)
    markers: List[MapMarker] = Field(default_factory=list)
    layers: List[str] = Field(default_factory=list)
    campaign_id: Optional[int] = None
    notes: Optional[str] = None


class MapUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    image_url: Optional[str] = None
    width: Optional[int] = Field(None, ge=1)
    height: Optional[int] = Field(None, ge=1)
    markers: Optional[List[MapMarker]] = None
    layers: Optional[List[str]] = None
    campaign_id: Optional[int] = None
    notes: Optional[str] = None

