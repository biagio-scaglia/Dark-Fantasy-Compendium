# Frontend - Dark Fantasy Compendium

Applicazione Flutter con architettura feature-based e tema dark fantasy.

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
  - Ogni feature ha le sue pagine (list e detail)
- `lib/services/` - Servizi API
- `lib/widgets/` - Widget riutilizzabili

## Tema Dark Fantasy

Il tema è definito in `lib/core/theme/app_theme.dart` con:
- Colori: rosso scuro, viola, cremisi
- Gradient personalizzati
- Stili per rarità (common, rare, epic, legendary)

## Configurazione API

L'URL del backend è configurato in `lib/main.dart`. Assicurati che il backend sia in esecuzione su `http://localhost:8000`.

