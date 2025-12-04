# Dark Fantasy Compendium - D&D Manager

Un'applicazione full stack per la gestione di campagne D&D (Dungeons & Dragons) con Flutter per il frontend e Python FastAPI per il backend.

## 🎲 Funzionalità Principali

- **Gestione Campagne D&D** - Crea e gestisci le tue campagne con sessioni, DM e giocatori
- **Calendario Sessioni** - Visualizza e organizza tutte le sessioni in un calendario interattivo
- **Gestione Personaggi** - Crea personaggi con ability scores, livelli, HP, AC e molto altro
- **Classi e Razze D&D** - Database completo di classi e razze con tutte le caratteristiche
- **Mappe Interattive** - Crea e gestisci mappe con markers e layers
- **Gestione Party** - Organizza gruppi di personaggi con livelli e punti esperienza
- **Incantesimi** - Database completo di incantesimi con dettagli
- **Sistema Dark Fantasy** - Gestione di cavalieri, armi, armature, fazioni, boss e lore

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

**Nota:** `dnd5epy` è stata rimossa per conflitti di dipendenze con pydantic>=2.7.0

3. I dati di esempio sono già presenti nei file JSON in `app/data/`

### Avvio

**IMPORTANTE:** Prima di avviare il backend, assicurati di aver installato tutte le dipendenze:
```bash
pip install -r requirements.txt
```

**Opzione 1: Usando Python (consigliato)**
```bash
cd backend
python run.py
```

**Opzione 2: Usando uvicorn direttamente**
```bash
cd backend
uvicorn app.main:app --reload
```

L'API sarà disponibile su `http://localhost:8000`
Documentazione API: `http://localhost:8000/docs`

### Endpoints Disponibili

#### Entità Dark Fantasy
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

#### Entità D&D
- `/dnd-classes` - Classi D&D (Guerriero, Mago, Ranger, Ladro, ecc.)
- `/races` - Razze (Umano, Elfo, Nano, Halfling, ecc.)
- `/characters` - Personaggi con ability scores, livelli, HP, AC
- `/campaigns` - Campagne con DM, giocatori, sessioni
- `/campaigns/{id}/sessions` - Sessioni di una campagna
- `/campaigns/sessions/calendar` - Calendario di tutte le sessioni
- `/maps` - Mappe con markers e layers
- `/spells` - Incantesimi con livello, scuola, componenti
- `/abilities` - Abilità e skill
- `/parties` - Gruppi di personaggi con livelli e XP

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

### Entità Dark Fantasy

#### Knight (Cavaliere)
- Statistiche: livello, salute, attacco, difesa
- Equipaggiamento: arma, armatura
- Fazione di appartenenza

#### Weapon (Arma)
- Tipo, bonus attacco, durabilità
- Rarità: common, rare, epic, legendary

#### Armor (Armatura)
- Tipo, bonus difesa, durabilità
- Rarità: common, rare, epic, legendary

#### Faction (Fazione)
- Nome, descrizione, lore
- Colore identificativo

#### Boss
- Statistiche elevate
- Ricompense (lista di item IDs)

#### Item (Oggetto)
- Tipo: consumable, material, quest_item
- Effetto, valore, rarità

#### Lore (Storia)
- Categoria: history, legend, prophecy
- Contenuto narrativo
- Collegamento opzionale ad altre entità

### Entità D&D

#### DndClass (Classe D&D)
- Hit dice (es. 1d10, 1d6)
- Punti vita al 1° livello e livelli superiori
- Competenze (proficiencies)
- Tiri salvezza
- Equipaggiamento iniziale
- Caratteristiche di classe
- Caratteristica per incantesimi (se applicabile)

#### Race (Razza)
- Taglia (Piccola, Media, Grande)
- Velocità
- Aumenti ai punteggi di caratteristica
- Tratti razziali
- Linguaggi conosciuti
- Sottorazze disponibili

#### Character (Personaggio)
- Livello (1-20)
- Classe e razza
- Ability scores: Forza, Destrezza, Costituzione, Intelligenza, Saggezza, Carisma
- Punti ferita (correnti, massimi, temporanei)
- Classe armatura (AC)
- Competenze: skill, tiri salvezza, strumenti, armi, armature
- Equipaggiamento e oggetti
- Incantesimi conosciuti e preparati
- Slot incantesimi per livello
- Punti esperienza
- Background e allineamento
- Backstory e note

#### Campaign (Campagna)
- Nome e descrizione
- Dungeon Master
- Giocatori
- Personaggi della campagna
- Sessioni con date, titoli, descrizioni, note, XP assegnati
- Livello attuale della campagna
- Ambientazione
- Note

#### Map (Mappa)
- Immagine della mappa
- Dimensioni (larghezza, altezza)
- Markers con posizioni (x, y in percentuale)
- Tipi di marker: location, npc, encounter, treasure
- Layers (terrain, buildings, npcs)
- Collegamento a campagna
- Note

#### Spell (Incantesimo)
- Livello (0-9, 0 = trucchetti)
- Scuola di magia
- Tempo di lancio
- Gittata
- Componenti (V, S, M)
- Componenti materiali specifici
- Durata
- Descrizione
- Effetti a livelli superiori
- Classi che possono lanciarlo
- Rituale e concentrazione

#### Party (Gruppo)
- Nome e descrizione
- Collegamento a campagna
- Personaggi nel party
- Livello medio del party
- Punti esperienza totali
- Note

## Caratteristiche

### Funzionalità Implementate
- ✅ Architettura modulare e scalabile
- ✅ Tema dark fantasy con colori e gradient
- ✅ Componenti riutilizzabili
- ✅ CRUD completo per tutte le entità
- ✅ Dati JSON locali (senza database)
- ✅ Routing con go_router
- ✅ State management con Provider
- ✅ Design responsive
- ✅ Calendario sessioni interattivo
- ✅ Gestione party con livelli e XP
- ✅ Visualizzazione ability scores con modificatori
- ✅ Gestione mappe con markers
- ✅ Database classi e razze D&D
- ✅ Sistema di incantesimi completo

### Funzionalità D&D
- ✅ Creazione e gestione campagne
- ✅ Calendario sessioni con navigazione mensile
- ✅ Gestione personaggi con tutte le stats D&D
- ✅ Database classi D&D con hit dice e features
- ✅ Database razze con ability score increases
- ✅ Mappe interattive con markers
- ✅ Gestione party con livelli e XP
- ✅ Database incantesimi completo
- ✅ Visualizzazione ability scores con modificatori automatici

## Dati di Esempio

Il progetto include dati di esempio per:
- **Classi D&D**: Guerriero, Mago, Ranger, Ladro
- **Razze**: Umano, Elfo, Nano, Halfling
- **Incantesimi**: Palla di Fuoco, Cura Ferite, Dardo Magico
- **Campagne**: "La Maledizione di Strahd" con sessione di esempio
- **Mappe**: Mappa di Barovia con markers
- **Party**: "I Guardiani della Notte"

## Sviluppo Futuro

- [ ] Autenticazione utenti
- [ ] Sistema di ricerca e filtri avanzati
- [ ] Immagini e icone personalizzate
- [ ] Sistema di notifiche
- [ ] Database reale (PostgreSQL/MongoDB)
- [ ] Test unitari e di integrazione
- [ ] CI/CD pipeline
- [ ] Editor mappe avanzato con disegno
- [ ] Sistema di combattimento
- [ ] Export PDF per schede personaggio (usando dungeonsheets)
- [ ] Integrazione completa dnd-engine per meccaniche di combattimento

## Tecnologie Utilizzate

### Backend
- Python 3.x
- FastAPI
- Pydantic
- Uvicorn
- **dungeonsheets** - Creazione schede personaggio e note (per export PDF futuro)

### Frontend
- Flutter
- Dart
- Provider (State Management)
- go_router (Routing)
- intl (Internazionalizzazione)
- font_awesome_flutter (Icone)
- http (HTTP Client)

## Licenza

Questo progetto è stato creato per scopi educativi e di sviluppo.

## Contribuire

Le contribuzioni sono benvenute! Sentiti libero di aprire issue o pull request.
