import json
import os
from typing import List, Dict, Any, Optional
from pathlib import Path


class JSONService:
    """Service per gestire lettura e scrittura di dati JSON locali"""
    
    def __init__(self, data_dir: str = "app/data"):
        self.data_dir = Path(data_dir)
        self.data_dir.mkdir(parents=True, exist_ok=True)
    
    def _get_file_path(self, entity_type: str) -> Path:
        """Ottiene il percorso del file JSON per un'entità"""
        return self.data_dir / f"{entity_type}.json"
    
    def read_all(self, entity_type: str) -> List[Dict[str, Any]]:
        """Legge tutti i record di un'entità"""
        file_path = self._get_file_path(entity_type)
        if not file_path.exists():
            return []
        
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                return json.load(f)
        except (json.JSONDecodeError, IOError):
            return []
    
    def read_one(self, entity_type: str, entity_id: int) -> Optional[Dict[str, Any]]:
        """Legge un singolo record per ID"""
        entities = self.read_all(entity_type)
        return next((e for e in entities if e.get('id') == entity_id), None)
    
    def write_all(self, entity_type: str, entities: List[Dict[str, Any]]) -> bool:
        """Scrive tutti i record di un'entità"""
        file_path = self._get_file_path(entity_type)
        try:
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(entities, f, indent=2, ensure_ascii=False)
            return True
        except IOError:
            return False
    
    def create(self, entity_type: str, entity: Dict[str, Any]) -> Dict[str, Any]:
        """Crea un nuovo record"""
        entities = self.read_all(entity_type)
        # Genera nuovo ID
        max_id = max([e.get('id', 0) for e in entities], default=0)
        entity['id'] = max_id + 1
        entities.append(entity)
        self.write_all(entity_type, entities)
        return entity
    
    def update(self, entity_type: str, entity_id: int, updates: Dict[str, Any]) -> Optional[Dict[str, Any]]:
        """Aggiorna un record esistente"""
        entities = self.read_all(entity_type)
        entity = next((e for e in entities if e.get('id') == entity_id), None)
        
        if not entity:
            return None
        
        # Aggiorna solo i campi forniti
        for key, value in updates.items():
            if value is not None:
                entity[key] = value
        
        self.write_all(entity_type, entities)
        return entity
    
    def delete(self, entity_type: str, entity_id: int) -> bool:
        """Elimina un record"""
        entities = self.read_all(entity_type)
        original_count = len(entities)
        entities = [e for e in entities if e.get('id') != entity_id]
        
        if len(entities) == original_count:
            return False
        
        self.write_all(entity_type, entities)
        return True

