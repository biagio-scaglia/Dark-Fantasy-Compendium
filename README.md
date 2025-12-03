# Dark Fantasy Compendium

Un'applicazione full stack dark fantasy con Flutter per il frontend e Python FastAPI per il backend.

## Struttura del Progetto

```
dark-fantasy-compendium/
├── backend/
│   ├── app/
│   │   ├── api/
│   │   │   └── routers/      # Router CRUD per ogni entità
│   │   ├── models/            # Modelli Pydantic
│   │   ├── schemas/           # Schemas per create/update
│   │   ├── services/           # Servizi per gestione JSON
│   │   ├── utils/             # Utilità
│   │   ├── core/              # Configurazione core
│   │   ├── data/              # Directory per file JSON
│   │   └── main.py            # Entry point FastAPI
│   └── requirements.txt
│
└── frontend/
    ├── lib/
    │   ├── core/              # Tema, router, configurazione
    │   ├── features/          # Feature-based architecture
    │   ├── services/          # Servizi API
    │   ├── widgets/           # Widget riutilizzabili
    │   └── main.dart
    ├── assets/
    │   ├── icons/
    │   └── images/
    └── pubspec.yaml
```

## Backend (FastAPI)

### Installazione

1. Crea un ambiente virtuale Python:
```bash
cd backend
python -m venv venv
source venv/bin/activate  # Su Windows: venv\Scripts\activate
```

2. Installa le dipendenze:
```bash
pip install -r requirements.txt
```

3. Inizializza i dati di esempio:
```bash
python -m app.utils.init_data
```

### Avvio

```bash
uvicorn app.main:app --reload
```

L'API sarà disponibile su `http://localhost:8000`
Documentazione API: `http://localhost:8000/docs`

### Endpoints Disponibili

- `GET /api/v1/knights` - Lista cavalieri
- `GET /api/v1/knights/{id}` - Dettaglio cavaliere
- `POST /api/v1/knights` - Crea cavaliere
- `PUT /api/v1/knights/{id}` - Aggiorna cavaliere
- `DELETE /api/v1/knights/{id}` - Elimina cavaliere

Stessi endpoint disponibili per:
- `/weapons` - Armi
- `/armors` - Armature
- `/factions` - Fazioni
- `/bosses` - Boss
- `/items` - Oggetti
- `/lores` - Storie/Lore

## Frontend (Flutter)

### Installazione

1. Assicurati di avere Flutter installato:
```bash
flutter --version
```

2. Installa le dipendenze:
```bash
cd frontend
flutter pub get
```

### Avvio

```bash
flutter run
```

### Configurazione API

Il frontend si connette al backend su `http://localhost:8000/api/v1` di default.
Per cambiare l'URL, modifica `lib/main.dart`:

```dart
Provider<ApiService>(
  create: (_) => ApiService(baseUrl: 'YOUR_API_URL'),
),
```

## Entità del Sistema

### Knight (Cavaliere)
- Statistiche: livello, salute, attacco, difesa
- Equipaggiamento: arma, armatura
- Fazione di appartenenza

### Weapon (Arma)
- Tipo, bonus attacco, durabilità
- Rarità: common, rare, epic, legendary

### Armor (Armatura)
- Tipo, bonus difesa, durabilità
- Rarità: common, rare, epic, legendary

### Faction (Fazione)
- Nome, descrizione, lore
- Colore identificativo

### Boss
- Statistiche elevate
- Ricompense (lista di item IDs)

### Item (Oggetto)
- Tipo: consumable, material, quest_item
- Effetto, valore, rarità

### Lore (Storia)
- Categoria: history, legend, prophecy
- Contenuto narrativo
- Collegamento opzionale ad altre entità

## Caratteristiche

- ✅ Architettura modulare e scalabile
- ✅ Tema dark fantasy con colori e gradient
- ✅ Componenti riutilizzabili
- ✅ CRUD completo per tutte le entità
- ✅ Dati JSON locali (senza database)
- ✅ Routing con go_router
- ✅ State management con Provider
- ✅ Design responsive

## Sviluppo Futuro

- [ ] Autenticazione utenti
- [ ] Sistema di ricerca e filtri
- [ ] Immagini e icone personalizzate
- [ ] Sistema di notifiche
- [ ] Database reale (PostgreSQL/MongoDB)
- [ ] Test unitari e di integrazione
- [ ] CI/CD pipeline

## Licenza

Questo progetto è stato creato per scopi educativi e di sviluppo.

