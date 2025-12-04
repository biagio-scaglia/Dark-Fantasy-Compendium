# Dark Fantasy Compendium - Offline D&D Manager

A fully offline Flutter application for managing D&D (Dungeons & Dragons) campaigns using local JSON files. All data is stored locally on the device with no backend or internet connection required.

## Features

- **Fully Offline** - No backend, no internet required
- **Local JSON Storage** - All data stored in local JSON files
- **Full CRUD Operations** - Create, Read, Update, Delete for all entities
- **Local Image Management** - Pick and store images locally on device
- **ID-Based Relationships** - Entities linked through IDs
- **User Profile** - Local user profile with optional PIN protection
- **D&D Campaign Management** - Create and manage campaigns with sessions, DM, and players
- **Character Management** - Create characters with ability scores, levels, HP, AC
- **Classes and Races** - Complete database of D&D classes and races
- **Interactive Maps** - Create and manage maps with markers and layers
- **Party Management** - Organize character groups with levels and experience points
- **Spells Database** - Complete spells database with details
- **Dark Fantasy System** - Manage knights, weapons, armors, factions, bosses, and lore

## Project Structure

```
dark-fantasy-compendium/
└── frontend/
    ├── lib/
    │   ├── core/                    # Theme, router, configuration
    │   ├── data/
    │   │   ├── models/              # Entity model classes
    │   │   ├── services/            # CRUD services and LocalJsonService
    │   │   └── json/                # JSON utilities
    │   ├── features/                # Feature-based architecture
    │   │   ├── characters/
    │   │   ├── races/
    │   │   ├── campaigns/
    │   │   ├── spells/
    │   │   └── ...
    │   ├── widgets/                 # Reusable widgets
    │   │   └── image_picker_helper.dart
    │   └── main.dart
    ├── assets/
    │   ├── data/                    # Initial JSON data files
    │   │   ├── classes.json
    │   │   ├── races.json
    │   │   ├── characters.json
    │   │   ├── spells.json
    │   │   ├── items.json
    │   │   ├── campaigns.json
    │   │   ├── parties.json
    │   │   ├── maps.json
    │   │   ├── bosses.json
    │   │   ├── factions.json
    │   │   ├── armors.json
    │   │   ├── weapons.json
    │   │   ├── knights.json
    │   │   ├── lores.json
    │   │   └── abilities.json
    │   ├── icons/
    │   └── images/
    └── pubspec.yaml
```

## Architecture

### Data Layer

The application uses a three-layer data architecture:

1. **Models** (`lib/data/models/`) - Entity classes with fromJson/toJson methods
2. **Services** (`lib/data/services/`) - CRUD services for each entity type
3. **LocalJsonService** - Core service for reading/writing JSON files

### Data Storage

- **Initial Data**: JSON files in `assets/data/` are bundled with the app
- **User Data**: JSON files are copied to app documents directory on first use
- **Images**: Stored in app documents directory under `data/images/`
- **User Profile**: Stored in SharedPreferences

### CRUD Operations

All entities support full CRUD operations:

- **Create**: `service.create(entity)` - Creates new entity with auto-generated ID
- **Read**: `service.getAll()` or `service.getById(id)` - Retrieves entities
- **Update**: `service.update(entity)` - Updates existing entity
- **Delete**: `service.delete(id)` - Deletes entity and associated images

### Relationships Through IDs

Entities are linked through ID references:

- `character.classId` → references `ClassModel.id`
- `character.raceId` → references `Race.id`
- `item.ownerId` → references `Character.id`
- `spell.allowedClassIds` → references `ClassModel.id[]`
- `map.campaignId` → references `Campaign.id`
- `map.markers[].campaignId` → references `Campaign.id`
- `party.memberIds` → references `Character.id[]`
- `party.campaignId` → references `Campaign.id`
- `knight.factionId` → references `Faction.id`
- `knight.weaponId` → references `Weapon.id`
- `knight.armorId` → references `Armor.id`
- `boss.rewardIds` → references `Item.id[]`

Helper methods in services fetch related entities:
- `characterService.getClass(classId)`
- `characterService.getRace(raceId)`
- `itemService.getOwner(ownerId)`
- `spellService.getAllowedClasses(spell)`

### Image Handling

Images are handled entirely offline:

1. **Image Picker**: User can pick images from:
   - Gallery
   - Camera
   - File picker

2. **Image Storage**: Images are saved to app documents directory:
   - Path format: `data/images/{entityType}_{entityId}.{extension}`
   - Example: `data/images/character_1.jpg`

3. **Image Display**: Uses `Image.file()` to load local images
   - Falls back to placeholder if image not found
   - Handles missing or corrupted files gracefully

4. **Image Deletion**: When entity is deleted, associated images are also deleted

### User Profile

Local user profile stored in SharedPreferences:

- **Username**: Required
- **PIN**: Optional password for app protection
- **Storage**: SharedPreferences (encrypted on supported platforms)
- **Validation**: `UserProfileService.validatePin(pin)` for PIN verification

## Installation

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd dark-fantasy-compendium
```

2. Navigate to frontend directory:
```bash
cd frontend
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Entity Models

### Core Entities

#### Character
- `id`, `name`, `classId`, `raceId`, `level`
- `stats` (ability scores, HP, AC, etc.)
- `imagePath`, `iconPath`

#### Race
- `id`, `name`, `description`, `size`, `speed`
- `abilityScoreIncreases`, `traits`, `languages`, `subraces`
- `imagePath`, `iconPath`

#### ClassModel
- `id`, `name`, `description`, `hitDice`
- `hitPointsAt1stLevel`, `hitPointsAtHigherLevels`
- `proficiencies`, `savingThrows`, `startingEquipment`
- `classFeatures`, `spellcastingAbility`
- `imagePath`, `iconPath`

#### Spell
- `id`, `name`, `level`, `school`, `castingTime`, `range`
- `components`, `materialComponents`, `duration`
- `description`, `higherLevel`
- `allowedClassIds` (array of class IDs)
- `ritual`, `concentration`
- `imagePath`, `iconPath`

#### Item
- `id`, `name`, `type`, `description`, `effect`
- `value`, `rarity`, `lore`
- `ownerId` (references Character)
- `imagePath`, `iconPath`

#### Campaign
- `id`, `name`, `description`, `dungeonMaster`
- `players` (array of strings)
- `characterIds` (array of character IDs)
- `sessions` (array of session objects)
- `currentLevel`, `setting`, `notes`
- `imagePath`, `iconPath`

#### Party
- `id`, `name`, `description`
- `campaignId` (references Campaign)
- `memberIds` (array of character IDs)
- `level`, `experiencePoints`, `notes`
- `imagePath`, `iconPath`

#### MapModel
- `id`, `name`, `description`
- `imagePath`, `width`, `height`
- `markers` (array of marker objects with campaignId)
- `layers` (array of strings)
- `campaignId` (references Campaign)
- `notes`

#### Boss
- `id`, `name`, `title`, `level`
- `health`, `maxHealth`, `attack`, `defense`
- `description`, `lore`
- `rewardIds` (array of item IDs)
- `imagePath`, `iconPath`

#### Faction
- `id`, `name`, `description`, `lore`, `color`
- `imagePath`, `iconPath`

#### Armor
- `id`, `name`, `type`, `defenseBonus`, `durability`
- `rarity`, `description`, `lore`
- `imagePath`, `iconPath`

#### Weapon
- `id`, `name`, `type`, `attackBonus`, `durability`
- `rarity`, `description`, `lore`
- `imagePath`, `iconPath`

#### Knight
- `id`, `name`, `title`, `level`
- `health`, `maxHealth`, `attack`, `defense`
- `factionId` (references Faction)
- `weaponId` (references Weapon)
- `armorId` (references Armor)
- `description`, `lore`
- `imagePath`, `iconPath`

#### Lore
- `id`, `title`, `category`, `content`
- `relatedEntityType`, `relatedEntityId`
- `imagePath`

#### Ability
- `id`, `name`, `description`
- `abilityType`, `abilityScore`, `modifier`
- `proficiencyBonus`
- `imagePath`, `iconPath`

## Services

Each entity has a dedicated service class:

- `CharacterService`
- `RaceService`
- `ClassService`
- `SpellService`
- `ItemService`
- `CampaignService`
- `PartyService`
- `MapService`
- `BossService`
- `FactionService`
- `ArmorService`
- `WeaponService`
- `KnightService`
- `LoreService`
- `AbilityService`
- `UserProfileService`

All services use `LocalJsonService` for JSON file operations.

## JSON File Format

JSON files use English keys with snake_case naming:

```json
{
  "id": 1,
  "name": "Character Name",
  "class_id": 1,
  "race_id": 2,
  "level": 5,
  "image_path": "/path/to/image.jpg",
  "icon_path": "/path/to/icon.jpg"
}
```

Old format keys (image_url, icon_url) are automatically converted to new format (image_path, icon_path) by `JsonConverter`.

## Image Picker Helper

The `ImagePickerHelper` widget provides:

- `pickImageFromGallery()` - Pick from device gallery
- `pickImageFromCamera()` - Take photo with camera
- `pickImageFromFile()` - Pick from file system
- `showImageSourceDialog(context)` - Show dialog with all options
- `saveImageForEntity(path, entityType, entityId)` - Save image for entity
- `deleteImageForEntity(imagePath)` - Delete entity image
- `buildImageWidget(imagePath, ...)` - Display image widget

## Technologies

- **Flutter** - UI framework
- **Dart** - Programming language
- **Provider** - State management
- **go_router** - Routing
- **path_provider** - File system access
- **shared_preferences** - User preferences storage
- **image_picker** - Image selection
- **file_picker** - File selection
- **intl** - Internationalization

## Features Implemented

- ✅ Fully offline architecture
- ✅ Local JSON data storage
- ✅ Full CRUD for all entities
- ✅ ID-based relationships
- ✅ Local image management
- ✅ User profile with PIN
- ✅ Automatic JSON file creation
- ✅ Data migration from assets
- ✅ Image picker integration
- ✅ Modular service architecture
- ✅ English naming throughout
- ✅ Clean, scalable codebase

## Future Enhancements

- [ ] Data export/import functionality
- [ ] Backup and restore
- [ ] Search and filtering
- [ ] Advanced image editing
- [ ] PDF export for characters
- [ ] Data synchronization (optional)
- [ ] Cloud backup (optional)

## License

This project is created for educational and development purposes.

## Contributing

Contributions are welcome! Feel free to open issues or pull requests.
