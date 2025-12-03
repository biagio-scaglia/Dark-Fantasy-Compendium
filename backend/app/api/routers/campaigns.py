from fastapi import APIRouter, HTTPException
from typing import List, Dict, Any
from datetime import datetime
from app.models.campaign import Campaign, Session
from app.schemas.campaign import CampaignCreate, CampaignUpdate
from app.services.json_service import JSONService
from app.core.config import settings

router = APIRouter(prefix="/campaigns", tags=["campaigns"])
json_service = JSONService(settings.data_dir)


@router.get("", response_model=List[Campaign])
async def get_campaigns():
    """Ottiene tutte le campagne"""
    campaigns = json_service.read_all("campaigns")
    return campaigns


@router.get("/{campaign_id}", response_model=Campaign)
async def get_campaign(campaign_id: int):
    """Ottiene una campagna per ID"""
    campaign = json_service.read_one("campaigns", campaign_id)
    if not campaign:
        raise HTTPException(status_code=404, detail="Campaign not found")
    return campaign


@router.post("", response_model=Campaign, status_code=201)
async def create_campaign(campaign: CampaignCreate):
    """Crea una nuova campagna"""
    campaign_dict = campaign.model_dump()
    created = json_service.create("campaigns", campaign_dict)
    return created


@router.put("/{campaign_id}", response_model=Campaign)
async def update_campaign(campaign_id: int, campaign: CampaignUpdate):
    """Aggiorna una campagna esistente"""
    updates = campaign.model_dump(exclude_unset=True)
    updated = json_service.update("campaigns", campaign_id, updates)
    if not updated:
        raise HTTPException(status_code=404, detail="Campaign not found")
    return updated


@router.delete("/{campaign_id}", status_code=204)
async def delete_campaign(campaign_id: int):
    """Elimina una campagna"""
    try:
        if not json_service.delete("campaigns", campaign_id, min_items=0):
            raise HTTPException(status_code=404, detail="Campaign not found")
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/{campaign_id}/sessions", response_model=List[Session])
async def get_campaign_sessions(campaign_id: int):
    """Ottiene tutte le sessioni di una campagna"""
    campaign = json_service.read_one("campaigns", campaign_id)
    if not campaign:
        raise HTTPException(status_code=404, detail="Campaign not found")
    return campaign.get("sessions", [])


@router.post("/{campaign_id}/sessions", response_model=Campaign)
async def add_session_to_campaign(campaign_id: int, session: Dict[str, Any]):
    """Aggiunge una nuova sessione a una campagna"""
    campaign = json_service.read_one("campaigns", campaign_id)
    if not campaign:
        raise HTTPException(status_code=404, detail="Campaign not found")
    
    # Genera ID per la sessione
    sessions = campaign.get("sessions", [])
    max_id = max([s.get("id", 0) for s in sessions], default=0)
    session["id"] = max_id + 1
    
    sessions.append(session)
    campaign["sessions"] = sessions
    
    # Aggiorna la campagna
    updated = json_service.update("campaigns", campaign_id, {"sessions": sessions})
    return updated


@router.get("/sessions/calendar", response_model=Dict[str, List[Dict[str, Any]]])
async def get_sessions_calendar(year: int = None, month: int = None):
    """Ottiene tutte le sessioni organizzate per data (calendario)"""
    campaigns = json_service.read_all("campaigns")
    calendar: Dict[str, List[Dict[str, Any]]] = {}
    
    for campaign in campaigns:
        sessions = campaign.get("sessions", [])
        for session in sessions:
            date_str = session.get("date", "")
            if date_str:
                # Filtra per anno/mese se specificati
                try:
                    session_date = datetime.fromisoformat(date_str)
                    if year and session_date.year != year:
                        continue
                    if month and session_date.month != month:
                        continue
                    
                    if date_str not in calendar:
                        calendar[date_str] = []
                    
                    session_with_campaign = {
                        **session,
                        "campaign_id": campaign["id"],
                        "campaign_name": campaign.get("name", ""),
                    }
                    calendar[date_str].append(session_with_campaign)
                except ValueError:
                    continue
    
    return calendar

