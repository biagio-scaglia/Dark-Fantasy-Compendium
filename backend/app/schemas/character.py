from typing import Optional, List, Dict
from pydantic import BaseModel, Field


class CharacterCreate(BaseModel):
    name: str
    player_name: Optional[str] = None
    level: int = Field(ge=1, le=20, default=1)
    class_id: int
    race_id: int
    background: Optional[str] = None
    alignment: Optional[str] = None
    strength: int = Field(ge=1, le=30, default=10)
    dexterity: int = Field(ge=1, le=30, default=10)
    constitution: int = Field(ge=1, le=30, default=10)
    intelligence: int = Field(ge=1, le=30, default=10)
    wisdom: int = Field(ge=1, le=30, default=10)
    charisma: int = Field(ge=1, le=30, default=10)
    max_hit_points: int = Field(ge=1, default=8)
    current_hit_points: int = Field(ge=0, default=8)
    temporary_hit_points: int = Field(ge=0, default=0)
    armor_class: int = Field(ge=0, default=10)
    skill_proficiencies: List[str] = Field(default_factory=list)
    saving_throw_proficiencies: List[str] = Field(default_factory=list)
    tool_proficiencies: List[str] = Field(default_factory=list)
    weapon_proficiencies: List[str] = Field(default_factory=list)
    armor_proficiencies: List[str] = Field(default_factory=list)
    equipment: List[str] = Field(default_factory=list)
    weapons: List[int] = Field(default_factory=list)
    armors: List[int] = Field(default_factory=list)
    items: List[int] = Field(default_factory=list)
    known_spells: List[int] = Field(default_factory=list)
    prepared_spells: List[int] = Field(default_factory=list)
    spell_slots: Dict[str, int] = Field(default_factory=dict)
    experience_points: int = Field(ge=0, default=0)
    notes: Optional[str] = None
    backstory: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None


class CharacterUpdate(BaseModel):
    name: Optional[str] = None
    player_name: Optional[str] = None
    level: Optional[int] = Field(None, ge=1, le=20)
    class_id: Optional[int] = None
    race_id: Optional[int] = None
    background: Optional[str] = None
    alignment: Optional[str] = None
    strength: Optional[int] = Field(None, ge=1, le=30)
    dexterity: Optional[int] = Field(None, ge=1, le=30)
    constitution: Optional[int] = Field(None, ge=1, le=30)
    intelligence: Optional[int] = Field(None, ge=1, le=30)
    wisdom: Optional[int] = Field(None, ge=1, le=30)
    charisma: Optional[int] = Field(None, ge=1, le=30)
    max_hit_points: Optional[int] = Field(None, ge=1)
    current_hit_points: Optional[int] = Field(None, ge=0)
    temporary_hit_points: Optional[int] = Field(None, ge=0)
    armor_class: Optional[int] = Field(None, ge=0)
    skill_proficiencies: Optional[List[str]] = None
    saving_throw_proficiencies: Optional[List[str]] = None
    tool_proficiencies: Optional[List[str]] = None
    weapon_proficiencies: Optional[List[str]] = None
    armor_proficiencies: Optional[List[str]] = None
    equipment: Optional[List[str]] = None
    weapons: Optional[List[int]] = None
    armors: Optional[List[int]] = None
    items: Optional[List[int]] = None
    known_spells: Optional[List[int]] = None
    prepared_spells: Optional[List[int]] = None
    spell_slots: Optional[Dict[str, int]] = None
    experience_points: Optional[int] = Field(None, ge=0)
    notes: Optional[str] = None
    backstory: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None

