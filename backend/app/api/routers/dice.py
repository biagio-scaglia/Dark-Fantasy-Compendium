"""
Router per gestire tiri di dadi D&D
"""
from fastapi import APIRouter, HTTPException
from typing import List, Optional
from pydantic import BaseModel, Field
from app.services.dnd_services import DnDDiceService

router = APIRouter(prefix="/dice", tags=["dice"])


class DiceRollRequest(BaseModel):
    """Richiesta per un tiro di dadi"""
    notation: str = Field(..., description="Notazione dei dadi (es. '1d20', '2d6+3', '4d6')")
    
    class Config:
        json_schema_extra = {
            "example": {
                "notation": "1d20+5"
            }
        }


class DiceRollResponse(BaseModel):
    """Risposta per un tiro di dadi"""
    notation: str
    result: int
    rolls: List[int]
    total: int
    details: Optional[str] = None


class MultipleDiceRollRequest(BaseModel):
    """Richiesta per multiple tirate di dadi"""
    notations: List[str] = Field(..., description="Lista di notazioni dei dadi")


class AbilityCheckRequest(BaseModel):
    """Richiesta per una prova di caratteristica"""
    modifier: int = Field(default=0, description="Modificatore alla prova")


class SavingThrowRequest(BaseModel):
    """Richiesta per un tiro salvezza"""
    modifier: int = Field(default=0, description="Modificatore al tiro salvezza")


class DamageRollRequest(BaseModel):
    """Richiesta per un tiro di danno"""
    dice_notation: str = Field(..., description="Notazione dei dadi (es. '1d8', '2d6')")
    modifier: int = Field(default=0, description="Modificatore al danno")


@router.get("/status")
async def dice_status():
    """Verifica se il servizio dadi è disponibile"""
    return {
        "available": DnDDiceService.is_available(),
        "service": "dndice"
    }


@router.post("/roll", response_model=DiceRollResponse)
async def roll_dice(request: DiceRollRequest):
    """
    Tira i dadi usando la notazione D&D
    
    Esempi di notazione:
    - '1d20' - un d20
    - '2d6+3' - due d6 più 3
    - '4d6' - quattro d6
    - '1d4-1' - un d4 meno 1
    """
    if not DnDDiceService.is_available():
        raise HTTPException(
            status_code=503,
            detail="Servizio dadi non disponibile. Installa dndice: pip install dndice"
        )
    
    try:
        result = DnDDiceService.roll(request.notation)
        return DiceRollResponse(**result)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Errore nel tiro dei dadi: {str(e)}")


@router.post("/roll/multiple", response_model=List[DiceRollResponse])
async def roll_multiple_dice(request: MultipleDiceRollRequest):
    """Tira multiple notazioni di dadi in una singola richiesta"""
    if not DnDDiceService.is_available():
        raise HTTPException(
            status_code=503,
            detail="Servizio dadi non disponibile. Installa dndice: pip install dndice"
        )
    
    try:
        results = DnDDiceService.roll_multiple(request.notations)
        return [DiceRollResponse(**result) for result in results]
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Errore nel tiro dei dadi: {str(e)}")


@router.post("/ability-check", response_model=DiceRollResponse)
async def roll_ability_check(request: AbilityCheckRequest):
    """Tira un d20 per una prova di caratteristica"""
    if not DnDDiceService.is_available():
        raise HTTPException(
            status_code=503,
            detail="Servizio dadi non disponibile. Installa dndice: pip install dndice"
        )
    
    try:
        result = DnDDiceService.roll_ability_check(request.modifier)
        return DiceRollResponse(**result)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Errore nel tiro: {str(e)}")


@router.post("/saving-throw", response_model=DiceRollResponse)
async def roll_saving_throw(request: SavingThrowRequest):
    """Tira un d20 per un tiro salvezza"""
    if not DnDDiceService.is_available():
        raise HTTPException(
            status_code=503,
            detail="Servizio dadi non disponibile. Installa dndice: pip install dndice"
        )
    
    try:
        result = DnDDiceService.roll_saving_throw(request.modifier)
        return DiceRollResponse(**result)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Errore nel tiro: {str(e)}")


@router.post("/damage", response_model=DiceRollResponse)
async def roll_damage(request: DamageRollRequest):
    """Tira i dadi per il danno"""
    if not DnDDiceService.is_available():
        raise HTTPException(
            status_code=503,
            detail="Servizio dadi non disponibile. Installa dndice: pip install dndice"
        )
    
    try:
        result = DnDDiceService.roll_damage(request.dice_notation, request.modifier)
        return DiceRollResponse(**result)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Errore nel tiro: {str(e)}")

