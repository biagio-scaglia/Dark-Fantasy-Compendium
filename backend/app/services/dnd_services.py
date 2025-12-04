"""
Servizi per integrare librerie Python D&D nel backend
"""
from typing import Dict, Any, Optional, List
import json
try:
    from dnd_character import Character as DnDCharacter
    from dnd_character import CLASSES, RACES
    DND_CHARACTER_AVAILABLE = True
except ImportError:
    DND_CHARACTER_AVAILABLE = False
    DnDCharacter = None

try:
    import dndice
    DNDICE_AVAILABLE = True
except ImportError:
    DNDICE_AVAILABLE = False
    dndice = None

try:
    import dnd5epy
    DND5EPY_AVAILABLE = True
except ImportError:
    DND5EPY_AVAILABLE = False
    dnd5epy = None


class DnDCharacterService:
    """Servizio per generare e gestire personaggi usando dnd-character"""
    
    @staticmethod
    def is_available() -> bool:
        """Verifica se la libreria è disponibile"""
        return DND_CHARACTER_AVAILABLE
    
    @staticmethod
    def get_available_classes() -> List[str]:
        """Ottiene la lista delle classi disponibili"""
        if not DND_CHARACTER_AVAILABLE:
            return []
        return list(CLASSES.keys())
    
    @staticmethod
    def get_available_races() -> List[str]:
        """Ottiene la lista delle razze disponibili"""
        if not DND_CHARACTER_AVAILABLE:
            return []
        return list(RACES.keys())
    
    @staticmethod
    def generate_character(
        name: str,
        class_name: Optional[str] = None,
        race_name: Optional[str] = None,
        level: int = 1,
        **kwargs
    ) -> Dict[str, Any]:
        """
        Genera un personaggio usando dnd-character
        
        Args:
            name: Nome del personaggio
            class_name: Nome della classe (es. 'Fighter', 'Wizard')
            race_name: Nome della razza (es. 'Human', 'Elf')
            level: Livello del personaggio (1-20)
            **kwargs: Altri parametri opzionali
        
        Returns:
            Dict con i dati del personaggio in formato compatibile con il nostro sistema
        """
        if not DND_CHARACTER_AVAILABLE:
            raise ImportError("dnd-character non è installato. Installa con: pip install dnd-character")
        
        # Crea il personaggio usando dnd-character
        character = DnDCharacter(
            name=name,
            classs=class_name or "Fighter",
            race=race_name or "Human",
            level=level,
            **kwargs
        )
        
        # Converti in dict e serializza
        char_dict = character.to_dict()
        
        # Mappa i dati al formato del nostro sistema
        return {
            "name": char_dict.get("name", name),
            "level": char_dict.get("level", level),
            "strength": char_dict.get("strength", 10),
            "dexterity": char_dict.get("dexterity", 10),
            "constitution": char_dict.get("constitution", 10),
            "intelligence": char_dict.get("intelligence", 10),
            "wisdom": char_dict.get("wisdom", 10),
            "charisma": char_dict.get("charisma", 10),
            "max_hit_points": char_dict.get("hp_max", 8),
            "current_hit_points": char_dict.get("hp", 8),
            "armor_class": char_dict.get("armor_class", 10),
            "experience_points": char_dict.get("xp", 0),
            "class_name": char_dict.get("class", class_name),
            "race_name": char_dict.get("race", race_name),
            "proficiencies": char_dict.get("proficiencies", []),
            "spellcasting": char_dict.get("spellcasting", {}),
            "equipment": char_dict.get("equipment", []),
            "raw_data": char_dict  # Mantieni i dati originali per riferimento
        }
    
    @staticmethod
    def character_to_json(character: Any) -> str:
        """Converte un personaggio dnd-character in JSON"""
        if not DND_CHARACTER_AVAILABLE:
            raise ImportError("dnd-character non è installato")
        
        if hasattr(character, 'to_dict'):
            return json.dumps(character.to_dict(), indent=2)
        return json.dumps(character, indent=2)


class DnDDiceService:
    """Servizio per gestire tiri di dadi usando dndice"""
    
    @staticmethod
    def is_available() -> bool:
        """Verifica se la libreria è disponibile"""
        return DNDICE_AVAILABLE
    
    @staticmethod
    def roll(dice_notation: str) -> Dict[str, Any]:
        """
        Tira i dadi usando la notazione D&D (es. '1d20', '2d6+3', '1d4-1')
        
        Args:
            dice_notation: Notazione dei dadi (es. '1d20', '2d6+3', '4d6')
        
        Returns:
            Dict con il risultato del tiro
        """
        if not DNDICE_AVAILABLE:
            raise ImportError("dndice non è installato. Installa con: pip install dndice")
        
        try:
            result = dndice.roll(dice_notation)
            
            # Se il risultato è un int, crea una struttura più dettagliata
            if isinstance(result, int):
                return {
                    "notation": dice_notation,
                    "result": result,
                    "rolls": [result],  # Per semplicità, se non abbiamo dettagli
                    "total": result
                }
            # Se è un oggetto con più dettagli
            elif hasattr(result, 'total'):
                return {
                    "notation": dice_notation,
                    "result": result.total,
                    "rolls": getattr(result, 'rolls', [result.total]),
                    "total": result.total,
                    "details": str(result)
                }
            else:
                return {
                    "notation": dice_notation,
                    "result": result,
                    "rolls": [result],
                    "total": result
                }
        except Exception as e:
            raise ValueError(f"Errore nel tiro dei dadi '{dice_notation}': {str(e)}")
    
    @staticmethod
    def roll_ability_check(modifier: int = 0) -> Dict[str, Any]:
        """Tira un d20 per una prova di caratteristica"""
        return DnDDiceService.roll(f"1d20{modifier:+d}" if modifier != 0 else "1d20")
    
    @staticmethod
    def roll_saving_throw(modifier: int = 0) -> Dict[str, Any]:
        """Tira un d20 per un tiro salvezza"""
        return DnDDiceService.roll(f"1d20{modifier:+d}" if modifier != 0 else "1d20")
    
    @staticmethod
    def roll_damage(dice_notation: str, modifier: int = 0) -> Dict[str, Any]:
        """Tira i dadi per il danno"""
        notation = f"{dice_notation}{modifier:+d}" if modifier != 0 else dice_notation
        return DnDDiceService.roll(notation)
    
    @staticmethod
    def roll_multiple(notations: List[str]) -> List[Dict[str, Any]]:
        """Tira multiple notazioni di dadi"""
        return [DnDDiceService.roll(notation) for notation in notations]


class DnD5ePyService:
    """Servizio per interfacciarsi con contenuti D&D 5e usando dnd5epy"""
    
    @staticmethod
    def is_available() -> bool:
        """Verifica se la libreria è disponibile"""
        return DND5EPY_AVAILABLE
    
    @staticmethod
    def get_spell_info(spell_name: str) -> Optional[Dict[str, Any]]:
        """Ottiene informazioni su un incantesimo"""
        if not DND5EPY_AVAILABLE:
            return None
        # Implementazione dipende dall'API di dnd5epy
        try:
            # Esempio - dipende dalla struttura effettiva di dnd5epy
            return None  # Placeholder
        except Exception:
            return None
    
    @staticmethod
    def get_class_info(class_name: str) -> Optional[Dict[str, Any]]:
        """Ottiene informazioni su una classe"""
        if not DND5EPY_AVAILABLE:
            return None
        try:
            return None  # Placeholder
        except Exception:
            return None

