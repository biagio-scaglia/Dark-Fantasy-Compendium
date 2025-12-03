# Backend - Dark Fantasy Compendium API

API RESTful costruita con FastAPI per gestire le entità del Dark Fantasy Compendium e D&D Manager.

## Setup

1. Installa le dipendenze:
```bash
pip install -r requirements.txt
```

2. I dati di esempio sono già presenti nei file JSON in `app/data/`

3. Avvia il server:
```bash
uvicorn app.main:app --reload
```

## Struttura

- `app/models/` - Modelli Pydantic per le entità
- `app/schemas/` - Schemas per create/update
- `app/api/routers/` - Router CRUD per ogni entità
- `app/services/` - Servizi per gestione JSON
- `app/data/` - File JSON per i dati

## Entità e Endpoints

### Entità Dark Fantasy
- `knights.json` - Cavalieri
- `weapons.json` - Armi
- `armors.json` - Armature
- `factions.json` - Fazioni
- `bosses.json` - Boss
- `items.json` - Oggetti
- `lores.json` - Storie/Lore

### Entità D&D
- `dnd_classes.json` - Classi D&D
- `races.json` - Razze
- `characters.json` - Personaggi
- `campaigns.json` - Campagne
- `maps.json` - Mappe
- `spells.json` - Incantesimi
- `abilities.json` - Abilità
- `parties.json` - Party

## Endpoints Speciali

### Calendario Sessioni
- `GET /api/v1/campaigns/sessions/calendar?year={year}&month={month}` - Ottiene tutte le sessioni organizzate per data

### Sessioni Campagna
- `GET /api/v1/campaigns/{id}/sessions` - Ottiene tutte le sessioni di una campagna
- `POST /api/v1/campaigns/{id}/sessions` - Aggiunge una nuova sessione a una campagna

## Dati

I dati sono salvati in file JSON nella directory `app/data/`. Ogni entità ha il suo file JSON che viene letto e scritto dal servizio `JSONService`.

## Documentazione API

Una volta avviato il server, la documentazione interattiva è disponibile su:
- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`
