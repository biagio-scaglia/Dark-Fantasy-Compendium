# Backend - Dark Fantasy Compendium API

API RESTful costruita con FastAPI per gestire le entità del Dark Fantasy Compendium.

## Setup

1. Installa le dipendenze:
```bash
pip install -r requirements.txt
```

2. Inizializza i dati di esempio:
```bash
python -m app.utils.init_data
```

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

## Dati

I dati sono salvati in file JSON nella directory `app/data/`. Ogni entità ha il suo file:
- `knights.json`
- `weapons.json`
- `armors.json`
- `factions.json`
- `bosses.json`
- `items.json`
- `lores.json`

