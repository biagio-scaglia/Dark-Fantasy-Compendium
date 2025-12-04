"""
Router per generare personaggi D&D automaticamente
"""
from fastapi import APIRouter, HTTPException
from typing import Optional, List
from pydantic import BaseModel, Field
from app.services.dnd_services import DnDCharacterService
from app.schemas.character import CharacterCreate
from app.models.character import Character
from app.services.json_service import JSONService
from app.core.config import settings

router = APIRouter(prefix="/character-generator", tags=["character-generator"])
json_service = JSONService(settings.data_dir)


class GenerateCharacterRequest(BaseModel):
    """Richiesta per generare un personaggio"""
    name: str = Field(..., description="Nome del personaggio")
    class_name: Optional[str] = Field(None, description="Nome della classe (es. 'Fighter', 'Wizard')")
    race_name: Optional[str] = Field(None, description="Nome della razza (es. 'Human', 'Elf')")
    level: int = Field(default=1, ge=1, le=20, description="Livello del personaggio (1-20)")
    auto_save: bool = Field(default=False, description="Salva automaticamente il personaggio generato")
    
    class Config:
        json_schema_extra = {
            "example": {
                "name": "Aragorn",
                "class_name": "Ranger",
                "race_name": "Human",
                "level": 5,
                "auto_save": True
            }
        }


class CharacterGeneratorStatus(BaseModel):
    """Stato del generatore di personaggi"""
    available: bool
    available_classes: List[str]
    available_races: List[str]
    service: str = "dnd-character"


@router.get("/status", response_model=CharacterGeneratorStatus)
async def generator_status():
    """Verifica se il generatore di personaggi è disponibile e ottiene le opzioni"""
    available = DnDCharacterService.is_available()
    classes = DnDCharacterService.get_available_classes() if available else []
    races = DnDCharacterService.get_available_races() if available else []
    
    return CharacterGeneratorStatus(
        available=available,
        available_classes=classes,
        available_races=races
    )


@router.post("/generate")
async def generate_character(request: GenerateCharacterRequest):
    """
    Genera un personaggio D&D automaticamente usando dnd-character
    
    Il personaggio generato può essere salvato automaticamente se auto_save=True,
    altrimenti viene solo restituito senza essere salvato nel database.
    """
    if not DnDCharacterService.is_available():
        raise HTTPException(
            status_code=503,
            detail="Generatore di personaggi non disponibile. Installa dnd-character: pip install dnd-character"
        )
    
    try:
        # Genera il personaggio
        generated_data = DnDCharacterService.generate_character(
            name=request.name,
            class_name=request.class_name,
            race_name=request.race_name,
            level=request.level
        )
        
        # Se auto_save è True, salva il personaggio
        if request.auto_save:
            # Mappa i dati generati al formato CharacterCreate
            # Nota: dobbiamo mappare class_name e race_name agli ID nel nostro sistema
            # Per ora, creiamo un personaggio con i dati generati
            
            # Leggi classi e razze per trovare gli ID corrispondenti
            classes = json_service.read_all("dnd_classes")
            races = json_service.read_all("races")
            
            # Trova la classe per nome (approssimativo)
            class_id = 1  # Default
            if request.class_name:
                matching_class = next(
                    (c for c in classes if request.class_name.lower() in c.get("name", "").lower()),
                    None
                )
                if matching_class:
                    class_id = matching_class.get("id", 1)
            
            # Trova la razza per nome (approssimativo)
            race_id = 1  # Default
            if request.race_name:
                matching_race = next(
                    (r for r in races if request.race_name.lower() in r.get("name", "").lower()),
                    None
                )
                if matching_race:
                    race_id = matching_race.get("id", 1)
            
            # Crea il personaggio usando CharacterCreate
            character_create = CharacterCreate(
                name=generated_data["name"],
                level=generated_data["level"],
                class_id=class_id,
                race_id=race_id,
                strength=generated_data["strength"],
                dexterity=generated_data["dexterity"],
                constitution=generated_data["constitution"],
                intelligence=generated_data["intelligence"],
                wisdom=generated_data["wisdom"],
                charisma=generated_data["charisma"],
                max_hit_points=generated_data["max_hit_points"],
                current_hit_points=generated_data["current_hit_points"],
                armor_class=generated_data["armor_class"],
                experience_points=generated_data.get("experience_points", 0),
                skill_proficiencies=generated_data.get("proficiencies", [])
            )
            
            # Salva il personaggio
            character_dict = character_create.model_dump()
            saved_character = json_service.create("characters", character_dict)
            
            return {
                "message": "Personaggio generato e salvato con successo",
                "generated_data": generated_data,
                "saved_character": saved_character
            }
        else:
            return {
                "message": "Personaggio generato (non salvato)",
                "generated_data": generated_data,
                "note": "Usa auto_save=true per salvare automaticamente il personaggio"
            }
    
    except ImportError as e:
        raise HTTPException(status_code=503, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Errore nella generazione del personaggio: {str(e)}")


@router.get("/classes")
async def get_available_classes():
    """Ottiene la lista delle classi disponibili per la generazione"""
    if not DnDCharacterService.is_available():
        # Restituisci lista vuota invece di errore, così il frontend può funzionare
        return {
            "classes": [],
            "message": "Libreria dnd-character non installata. Installa con: pip install dnd-character"
        }
    
    return {
        "classes": DnDCharacterService.get_available_classes()
    }


@router.get("/races")
async def get_available_races():
    """Ottiene la lista delle razze disponibili per la generazione"""
    if not DnDCharacterService.is_available():
        # Restituisci lista vuota invece di errore, così il frontend può funzionare
        return {
            "races": [],
            "message": "Libreria dnd-character non installata. Installa con: pip install dnd-character"
        }
    
    return {
        "races": DnDCharacterService.get_available_races()
    }

