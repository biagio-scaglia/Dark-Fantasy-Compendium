# Frontend - Dark Fantasy Compendium D&D Manager

Applicazione Flutter con architettura feature-based e tema dark fantasy per la gestione di campagne D&D.

## Setup

1. Installa le dipendenze:
```bash
flutter pub get
```

2. Avvia l'app:
```bash
flutter run
```

## Struttura

- `lib/core/` - Tema, router, configurazione
- `lib/features/` - Feature-based architecture
  - Ogni feature ha le sue pagine (list, detail, form)
- `lib/data/services/` - Servizi per la gestione dei dati locali (JSON)
- `lib/data/models/` - Modelli dei dati
- `lib/widgets/` - Widget riutilizzabili

## Features Implementate

### Dark Fantasy
- ✅ Cavalieri (list, detail, form)
- ✅ Armi (list, detail, form)
- ✅ Armature (list, detail, form)
- ✅ Fazioni (list, detail, form)
- ✅ Boss (list, detail)
- ✅ Oggetti (list, detail)
- ✅ Lore (list, detail)
- ✅ **Widget Icone SVG** - Widget riutilizzabile con colori adattivi al tema (Light/Dark mode)
- ✅ **Pagina Esempio Icone SVG** - Layout a griglia che mostra le icone disponibili

### D&D Manager
- ✅ Classi D&D (list, detail, form)
- ✅ Razze (list)
- ✅ Personaggi (list, detail)
- ✅ Campagne (list, detail con sessioni)
- ✅ Mappe (list, detail, form)
- ✅ Incantesimi (list)
- ✅ Abilità (list)
- ✅ Party (list, detail, form)
- ✅ Calendario Sessioni (calendario mensile interattivo)

## Tema Dark Fantasy

Il tema è definito in `lib/core/theme/app_theme.dart` con:
- Colori: rosso scuro, viola, cremisi, oro
- Gradient personalizzati
- Stili per rarità (common, rare, epic, legendary)
- Animazioni fluide

## Architettura Dati

L'app utilizza un sistema di storage locale basato su JSON. I dati vengono caricati dai file JSON in `assets/data/` e salvati localmente sul dispositivo. Non è necessario un backend per utilizzare l'applicazione.

## Funzionalità Principali

### Calendario Sessioni
- Visualizzazione mensile interattiva
- Navigazione tra mesi
- Indicatori visivi per giorni con sessioni
- Dialog con dettagli sessione
- Link alle campagne

### Gestione Personaggi
- Visualizzazione ability scores
- Calcolo automatico modificatori
- Statistiche complete (HP, AC, livello)
- Collegamento a classi e razze

### Gestione Campagne
- Informazioni campagna (DM, giocatori, livello)
- Lista sessioni con date formattate
- Link al calendario sessioni
- Dettagli sessione in dialog

### Gestione Mappe
- Visualizzazione mappe con immagini
- Markers con posizioni
- Note e descrizioni
- Collegamento a campagne

### Gestione Party
- Livello medio del party
- Punti esperienza totali
- Lista personaggi
- Note e descrizioni

## Dipendenze Principali

- `flutter` - Framework UI
- `provider` - State management
- `go_router` - Routing
- `http` - HTTP client
- `intl` - Internazionalizzazione e formattazione date
- `font_awesome_flutter` - Icone
- `image_picker` - Selezione immagini
- `flutter_svg` - Rendering icone SVG

## Note

L'app utilizza `intl` per la formattazione delle date in italiano. Il formato data viene inizializzato automaticamente all'avvio dell'app.
