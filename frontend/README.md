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

- `lib/core/` - Core functionality
  - `design_system/` - Enhanced design system (colors, typography, shadows, animations)
  - `theme/` - Theme configuration and constants
  - `router/` - Navigation and routing
  - `animations/` - Animation utilities (legacy compatibility)
- `lib/features/` - Feature-based architecture
  - Ogni feature ha le sue pagine (list, detail, form)
- `lib/data/` - Data layer
  - `services/` - Servizi per la gestione dei dati locali (JSON)
  - `models/` - Modelli dei dati
- `lib/widgets/` - Widget riutilizzabili
  - `animated_card.dart` - Enhanced animated card component
  - `animated_button.dart` - Enhanced animated button components
  - Other reusable widgets

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

## Design System & Theming

### Enhanced Design System

The app now features a comprehensive design system located in `lib/core/design_system/`:

- **`app_colors.dart`** - Enhanced color palette with improved contrast and harmony
  - Light mode: Gold/Brown accents on warm backgrounds
  - Dark mode: Crimson/Violet accents on dark backgrounds
  - Context-aware color helpers for easy theme switching
  - Improved accessibility with better contrast ratios

- **`app_typography.dart`** - Typography system with clear hierarchy
  - Display, Headline, Title, Body, and Label styles
  - Responsive text scaling
  - Accent text styles for highlighted content

- **`app_shadows.dart`** - Shadow system for depth and elevation
  - Standard shadows (shadow1 through shadow16)
  - Glow shadows for accent elements
  - Context-aware shadows (soft, card, elevated, button)

- **`app_animations.dart`** - Enhanced animation system
  - Standard durations and curves
  - Page transitions (fade, slide, scale, slideUp)
  - Widget animations (fadeIn, slideIn, scaleIn, fadeSlideIn)
  - Staggered animations for lists

### Theme Configuration

The theme is defined in `lib/core/theme/app_theme.dart` with:
- Refined color palette with improved contrast
- Gradient personalizzati
- Stili per rarità (common, rare, epic, legendary)
- Smooth animations throughout the app
- Adaptive theming for light and dark modes

### UI Components

**Animated Components:**
- `AnimatedCard` - Cards with hover, press, and focus states
- `AnimatedButton` - Buttons with interactive animations
- `AnimatedElevatedButton` - Enhanced elevated button with animations

**Features:**
- Smooth page transitions
- Staggered list animations
- Interactive hover effects (desktop)
- Press feedback on all interactive elements
- Lazy loading for all lists (ListView.builder, GridView.builder)
- Responsive layout with adaptive spacing
- Safe area management for all device sizes

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
- `intl` - Internazionalizzazione e formattazione date
- `image_picker` - Selezione immagini
- `flutter_svg` - Rendering icone SVG
- `path_provider` - Accesso al file system
- `shared_preferences` - Storage preferenze utente

## Note

L'app utilizza `intl` per la formattazione delle date in italiano. Il formato data viene inizializzato automaticamente all'avvio dell'app.
