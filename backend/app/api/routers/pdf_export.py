"""
Router per esportare schede personaggio in PDF
"""
from fastapi import APIRouter, HTTPException
from fastapi.responses import FileResponse, Response
from typing import Optional
import os
import tempfile
from pathlib import Path
from app.services.json_service import JSONService
from app.core.config import settings
from app.models.character import Character

router = APIRouter(prefix="/pdf-export", tags=["pdf-export"])
json_service = JSONService(settings.data_dir)

# Verifica disponibilità dungeonsheets
try:
    from dungeonsheets import Character as DungeonSheetsCharacter
    from dungeonsheets import create_character_sheet
    DUNGEONSHEETS_AVAILABLE = True
except ImportError:
    DUNGEONSHEETS_AVAILABLE = False
    DungeonSheetsCharacter = None
    create_character_sheet = None


def convert_character_to_dungeonsheets(character_data: dict) -> dict:
    """
    Converte un personaggio dal nostro formato a quello di dungeonsheets
    """
    # Mappa i dati base
    ds_char = {
        'name': character_data.get('name', 'Unknown'),
        'level': character_data.get('level', 1),
        'strength': character_data.get('strength', 10),
        'dexterity': character_data.get('dexterity', 10),
        'constitution': character_data.get('constitution', 10),
        'intelligence': character_data.get('intelligence', 10),
        'wisdom': character_data.get('wisdom', 10),
        'charisma': character_data.get('charisma', 10),
        'hp_max': character_data.get('max_hit_points', 8),
        'hp': character_data.get('current_hit_points', 8),
        'armor_class': character_data.get('armor_class', 10),
        'xp': character_data.get('experience_points', 0),
    }
    
    # Aggiungi informazioni aggiuntive se disponibili
    if character_data.get('player_name'):
        ds_char['player_name'] = character_data['player_name']
    if character_data.get('background'):
        ds_char['background'] = character_data['background']
    if character_data.get('alignment'):
        ds_char['alignment'] = character_data['alignment']
    if character_data.get('backstory'):
        ds_char['backstory'] = character_data['backstory']
    if character_data.get('notes'):
        ds_char['notes'] = character_data['notes']
    
    # Proficiencies
    if character_data.get('skill_proficiencies'):
        ds_char['skill_proficiencies'] = character_data['skill_proficiencies']
    if character_data.get('saving_throw_proficiencies'):
        ds_char['saving_throw_proficiencies'] = character_data['saving_throw_proficiencies']
    
    # Equipment
    if character_data.get('equipment'):
        ds_char['equipment'] = character_data['equipment']
    
    # Spells
    if character_data.get('known_spells'):
        ds_char['spells'] = character_data['known_spells']
    
    return ds_char


@router.get("/status")
async def pdf_export_status():
    """Verifica se il servizio di export PDF è disponibile"""
    return {
        "available": DUNGEONSHEETS_AVAILABLE,
        "service": "dungeonsheets",
        "note": "Richiede LaTeX/pdflatex installato per generare PDF"
    }


@router.get("/character/{character_id}")
async def export_character_pdf(character_id: int):
    """
    Esporta una scheda personaggio in PDF
    
    Nota: Richiede dungeonsheets e LaTeX/pdflatex installato sul sistema
    """
    if not DUNGEONSHEETS_AVAILABLE:
        raise HTTPException(
            status_code=503,
            detail="Servizio PDF export non disponibile. Installa dungeonsheets: pip install dungeonsheets"
        )
    
    # Recupera il personaggio
    character_data = json_service.read_one("characters", character_id)
    if not character_data:
        raise HTTPException(status_code=404, detail="Character not found")
    
    try:
        # Converti il personaggio al formato dungeonsheets
        ds_char_data = convert_character_to_dungeonsheets(character_data)
        
        # Crea un file temporaneo per il PDF
        with tempfile.NamedTemporaryFile(delete=False, suffix='.pdf') as tmp_file:
            pdf_path = tmp_file.name
        
        # Prova a creare il PDF usando dungeonsheets
        # Nota: dungeonsheets richiede LaTeX, quindi potrebbe non funzionare senza
        # Per ora, creiamo un PDF semplice o restituiamo un errore informativo
        
        # Se dungeonsheets ha bisogno di un file Python, creiamolo temporaneamente
        try:
            # Crea un character object di dungeonsheets
            char = DungeonSheetsCharacter(**ds_char_data)
            
            # Genera il PDF
            # Nota: create_character_sheet potrebbe richiedere configurazioni specifiche
            # Per ora, restituiamo un messaggio informativo
            raise HTTPException(
                status_code=501,
                detail="PDF export richiede LaTeX/pdflatex installato. Funzionalità in sviluppo."
            )
        except Exception as e:
            # Se LaTeX non è disponibile, restituiamo un PDF semplice generato manualmente
            # Per ora, restituiamo un errore informativo
            raise HTTPException(
                status_code=503,
                detail=f"Errore nella generazione PDF. Assicurati che LaTeX/pdflatex sia installato. Errore: {str(e)}"
            )
    
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Errore nell'export PDF: {str(e)}")


@router.get("/character/{character_id}/simple")
async def export_character_pdf_simple(character_id: int):
    """
    Esporta una scheda personaggio in PDF semplice (senza LaTeX)
    Usa una libreria Python per PDF come reportlab o fpdf
    """
    # Recupera il personaggio
    character_data = json_service.read_one("characters", character_id)
    if not character_data:
        raise HTTPException(status_code=404, detail="Character not found")
    
    try:
        # Prova a usare reportlab o fpdf per creare un PDF semplice
        try:
            from reportlab.lib.pagesizes import letter
            from reportlab.pdfgen import canvas
            REPORTLAB_AVAILABLE = True
        except ImportError:
            REPORTLAB_AVAILABLE = False
        
        if not REPORTLAB_AVAILABLE:
            raise HTTPException(
                status_code=503,
                detail="Libreria PDF non disponibile. Installa reportlab: pip install reportlab"
            )
        
        # Crea un file temporaneo per il PDF
        with tempfile.NamedTemporaryFile(delete=False, suffix='.pdf', delete_on_close=False) as tmp_file:
            pdf_path = tmp_file.name
        
        # Crea il PDF con reportlab
        c = canvas.Canvas(pdf_path, pagesize=letter)
        width, height = letter
        
        # Titolo
        c.setFont("Helvetica-Bold", 20)
        c.drawString(50, height - 50, f"Scheda Personaggio: {character_data.get('name', 'Unknown')}")
        
        # Informazioni base
        y = height - 100
        c.setFont("Helvetica", 12)
        c.drawString(50, y, f"Livello: {character_data.get('level', 1)}")
        y -= 20
        c.drawString(50, y, f"Punti Ferita: {character_data.get('current_hit_points', 0)}/{character_data.get('max_hit_points', 0)}")
        y -= 20
        c.drawString(50, y, f"Classe Armatura: {character_data.get('armor_class', 10)}")
        
        # Ability Scores
        y -= 40
        c.setFont("Helvetica-Bold", 14)
        c.drawString(50, y, "Ability Scores:")
        y -= 20
        c.setFont("Helvetica", 12)
        abilities = ['strength', 'dexterity', 'constitution', 'intelligence', 'wisdom', 'charisma']
        for ability in abilities:
            value = character_data.get(ability, 10)
            modifier = (value - 10) // 2
            c.drawString(50, y, f"{ability.capitalize()}: {value} ({modifier:+d})")
            y -= 20
        
        # Equipment
        if character_data.get('equipment'):
            y -= 20
            c.setFont("Helvetica-Bold", 14)
            c.drawString(50, y, "Equipment:")
            y -= 20
            c.setFont("Helvetica", 10)
            for item in character_data['equipment'][:10]:  # Limita a 10 items
                c.drawString(50, y, f"- {item}")
                y -= 15
        
        # Notes
        if character_data.get('notes'):
            y -= 20
            c.setFont("Helvetica-Bold", 14)
            c.drawString(50, y, "Note:")
            y -= 20
            c.setFont("Helvetica", 10)
            notes = character_data['notes']
            # Wrappa il testo se troppo lungo
            for line in notes.split('\n')[:10]:  # Limita a 10 righe
                c.drawString(50, y, line[:80])  # Limita a 80 caratteri per riga
                y -= 15
        
        c.save()
        
        # Restituisci il file PDF
        return FileResponse(
            pdf_path,
            media_type='application/pdf',
            filename=f"character_{character_id}_{character_data.get('name', 'unknown')}.pdf"
        )
    
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Errore nell'export PDF: {str(e)}")

