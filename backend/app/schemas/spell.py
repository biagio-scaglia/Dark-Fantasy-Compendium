from typing import Optional, List
from pydantic import BaseModel, Field


class SpellCreate(BaseModel):
    name: str
    level: int = Field(ge=0, le=9, default=0)
    school: str
    casting_time: str = "1 azione"
    range: str = "30 piedi"
    components: List[str] = Field(default_factory=list)
    material_components: Optional[str] = None
    duration: str = "Istantaneo"
    description: str
    higher_level: Optional[str] = None
    classes: List[str] = Field(default_factory=list)
    ritual: bool = False
    concentration: bool = False
    image_url: Optional[str] = None
    icon_url: Optional[str] = None


class SpellUpdate(BaseModel):
    name: Optional[str] = None
    level: Optional[int] = Field(None, ge=0, le=9)
    school: Optional[str] = None
    casting_time: Optional[str] = None
    range: Optional[str] = None
    components: Optional[List[str]] = None
    material_components: Optional[str] = None
    duration: Optional[str] = None
    description: Optional[str] = None
    higher_level: Optional[str] = None
    classes: Optional[List[str]] = None
    ritual: Optional[bool] = None
    concentration: Optional[bool] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

