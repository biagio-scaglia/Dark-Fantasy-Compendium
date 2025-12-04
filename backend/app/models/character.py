from typing import Optional, List, Dict
from pydantic import BaseModel, Field


class Character(BaseModel):
    id: int
    name: str
    player_name: Optional[str] = None
    level: int = Field(ge=1, le=20, default=1)
    class_id: int = Field(description="D&D class ID")
    race_id: int = Field(description="Race ID")
    background: Optional[str] = None
    alignment: Optional[str] = Field(None, description="Alignment (e.g., 'Lawful Good')")
    
    # Ability Scores
    strength: int = Field(ge=1, le=30, default=10)
    dexterity: int = Field(ge=1, le=30, default=10)
    constitution: int = Field(ge=1, le=30, default=10)
    intelligence: int = Field(ge=1, le=30, default=10)
    wisdom: int = Field(ge=1, le=30, default=10)
    charisma: int = Field(ge=1, le=30, default=10)
    
    # Hit Points
    max_hit_points: int = Field(ge=1)
    current_hit_points: int = Field(ge=0)
    temporary_hit_points: int = Field(ge=0, default=0)
    
    # Armor Class
    armor_class: int = Field(ge=0, default=10)
    
    # Proficiencies
    skill_proficiencies: List[str] = Field(default_factory=list)
    saving_throw_proficiencies: List[str] = Field(default_factory=list)
    tool_proficiencies: List[str] = Field(default_factory=list)
    weapon_proficiencies: List[str] = Field(default_factory=list)
    armor_proficiencies: List[str] = Field(default_factory=list)
    
    # Equipment
    equipment: List[str] = Field(default_factory=list)
    weapons: List[int] = Field(default_factory=list, description="Weapon IDs")
    armors: List[int] = Field(default_factory=list, description="Armor IDs")
    items: List[int] = Field(default_factory=list, description="Item IDs")
    
    # Spells
    known_spells: List[int] = Field(default_factory=list, description="Known spell IDs")
    prepared_spells: List[int] = Field(default_factory=list, description="Prepared spell IDs")
    spell_slots: Dict[str, int] = Field(default_factory=dict, description="Spell slots by level")
    
    # Experience
    experience_points: int = Field(ge=0, default=0)
    
    # Notes
    notes: Optional[str] = None
    backstory: Optional[str] = None
    image_url: Optional[str] = None
    icon_url: Optional[str] = None
