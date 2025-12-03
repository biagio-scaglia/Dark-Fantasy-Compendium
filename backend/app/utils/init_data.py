"""
Script per inizializzare i dati di esempio nel database JSON
"""
from app.services.json_service import JSONService
from app.core.config import settings


def init_sample_data():
    """Inizializza dati di esempio per tutte le entità"""
    json_service = JSONService(settings.data_dir)
    
    # Fazioni
    factions = [
        {
            "id": 1,
            "name": "Ordine delle Ombre",
            "description": "Un ordine segreto di cavalieri che combatte le forze oscure",
            "lore": "Fondato durante la Grande Guerra delle Tenebre, l'Ordine delle Ombre protegge i reami dai demoni.",
            "color": "#8B0000",
            "image_url": None,
            "icon_url": None
        },
        {
            "id": 2,
            "name": "Guardiani del Vuoto",
            "description": "Cavalieri che hanno abbracciato il potere del vuoto",
            "lore": "Coloro che hanno guardato nell'abisso e ne sono usciti trasformati.",
            "color": "#4B0082",
            "image_url": None,
            "icon_url": None
        },
        {
            "id": 3,
            "name": "Cavalieri del Sangue",
            "description": "Un ordine maledetto che si nutre di battaglie",
            "lore": "Maledetti da un antico patto, questi cavalieri sono immortali ma assetati di sangue.",
            "color": "#DC143C",
            "image_url": None,
            "icon_url": None
        }
    ]
    json_service.write_all("factions", factions)
    
    # Armi
    weapons = [
        {
            "id": 1,
            "name": "Spada delle Tenebre",
            "type": "sword",
            "attack_bonus": 25,
            "durability": 100,
            "rarity": "legendary",
            "description": "Una spada forgiata nelle fiamme dell'inferno",
            "lore": "Si dice che questa spada sia stata forgiata con il sangue di mille demoni.",
            "image_url": None,
            "icon_url": None
        },
        {
            "id": 2,
            "name": "Ascia del Flagello",
            "type": "axe",
            "attack_bonus": 20,
            "durability": 85,
            "rarity": "epic",
            "description": "Un'ascia pesante che infligge danni devastanti",
            "lore": None,
            "image_url": None,
            "icon_url": None
        },
        {
            "id": 3,
            "name": "Mazza Corrotta",
            "type": "mace",
            "attack_bonus": 15,
            "durability": 70,
            "rarity": "rare",
            "description": "Una mazza corrotta dal potere oscuro",
            "lore": None,
            "image_url": None,
            "icon_url": None
        }
    ]
    json_service.write_all("weapons", weapons)
    
    # Armature
    armors = [
        {
            "id": 1,
            "name": "Armatura delle Ombre",
            "type": "chest",
            "defense_bonus": 30,
            "durability": 100,
            "rarity": "legendary",
            "description": "Un'armatura che assorbe la luce",
            "lore": "Forgiata con metallo delle stelle cadute.",
            "image_url": None,
            "icon_url": None
        },
        {
            "id": 2,
            "name": "Elmo del Vuoto",
            "type": "helmet",
            "defense_bonus": 15,
            "durability": 80,
            "rarity": "epic",
            "description": "Un elmo che nasconde il volto nell'oscurità",
            "lore": None,
            "image_url": None,
            "icon_url": None
        },
        {
            "id": 3,
            "name": "Gambali Corrotti",
            "type": "legs",
            "defense_bonus": 12,
            "durability": 65,
            "rarity": "rare",
            "description": "Gambali protetti da rune oscure",
            "lore": None,
            "image_url": None,
            "icon_url": None
        }
    ]
    json_service.write_all("armors", armors)
    
    # Cavalieri
    knights = [
        {
            "id": 1,
            "name": "Sir Malachar",
            "title": "Il Cavaliere delle Ombre",
            "faction_id": 1,
            "level": 50,
            "health": 500,
            "max_health": 500,
            "attack": 80,
            "defense": 60,
            "weapon_id": 1,
            "armor_id": 1,
            "description": "Un cavaliere leggendario che ha combattuto mille battaglie",
            "lore": "Sir Malachar ha perso la sua famiglia durante la Grande Guerra. Ora combatte solo per vendetta.",
            "image_url": None,
            "icon_url": None
        },
        {
            "id": 2,
            "name": "Void Knight",
            "title": "Guardiano dell'Abisso",
            "faction_id": 2,
            "level": 45,
            "health": 450,
            "max_health": 450,
            "attack": 75,
            "defense": 55,
            "weapon_id": 2,
            "armor_id": 2,
            "description": "Un cavaliere che ha guardato nel vuoto e ne è stato trasformato",
            "lore": None,
            "image_url": None,
            "icon_url": None
        },
        {
            "id": 3,
            "name": "Bloodreaver",
            "title": "Il Sanguinario",
            "faction_id": 3,
            "level": 60,
            "health": 600,
            "max_health": 600,
            "attack": 90,
            "defense": 50,
            "weapon_id": 3,
            "armor_id": 3,
            "description": "Un cavaliere maledetto assetato di sangue",
            "lore": "Maledetto da un antico patto, Bloodreaver è immortale ma deve nutrirsi di battaglie.",
            "image_url": None,
            "icon_url": None
        }
    ]
    json_service.write_all("knights", knights)
    
    # Boss
    bosses = [
        {
            "id": 1,
            "name": "Draco Ombra",
            "title": "Il Drago delle Tenebre",
            "level": 80,
            "health": 5000,
            "max_health": 5000,
            "attack": 150,
            "defense": 100,
            "description": "Un drago antico corrotto dalle forze oscure",
            "lore": "Un tempo era il guardiano della luce, ora è diventato il portatore delle tenebre.",
            "rewards": [1, 2],
            "image_url": None,
            "icon_url": None
        },
        {
            "id": 2,
            "name": "Re Lich",
            "title": "Il Signore dei Non Morti",
            "level": 90,
            "health": 6000,
            "max_health": 6000,
            "attack": 180,
            "defense": 120,
            "description": "Un re morto che comanda un esercito di non morti",
            "lore": "Un tempo era un re giusto, ma la maledizione lo ha trasformato in un mostro.",
            "rewards": [1, 3],
            "image_url": None,
            "icon_url": None
        }
    ]
    json_service.write_all("bosses", bosses)
    
    # Oggetti
    items = [
        {
            "id": 1,
            "name": "Pozione di Sangue",
            "type": "consumable",
            "description": "Ripristina 200 HP",
            "effect": "heal_200",
            "value": 50,
            "rarity": "common",
            "lore": None,
            "image_url": None,
            "icon_url": None
        },
        {
            "id": 2,
            "name": "Cristallo Oscuro",
            "type": "material",
            "description": "Materiale raro per la forgiatura",
            "effect": None,
            "value": 500,
            "rarity": "epic",
            "lore": "Un cristallo che pulsa con energia oscura.",
            "image_url": None,
            "icon_url": None
        },
        {
            "id": 3,
            "name": "Chiave del Vuoto",
            "type": "quest_item",
            "description": "Una chiave che apre portali verso il vuoto",
            "effect": None,
            "value": 0,
            "rarity": "legendary",
            "lore": "Si dice che questa chiave possa aprire porte verso altre dimensioni.",
            "image_url": None,
            "icon_url": None
        }
    ]
    json_service.write_all("items", items)
    
    # Lore
    lores = [
        {
            "id": 1,
            "title": "La Grande Guerra delle Tenebre",
            "category": "history",
            "content": "Cento anni fa, le forze oscure invasero i reami. Solo l'Ordine delle Ombre riuscì a respingerle, ma a caro prezzo.",
            "related_entity_type": "faction",
            "related_entity_id": 1,
            "image_url": None
        },
        {
            "id": 2,
            "title": "La Profezia del Cavaliere",
            "category": "prophecy",
            "content": "Un cavaliere delle ombre un giorno risveglierà il drago e porrà fine alle tenebre.",
            "related_entity_type": None,
            "related_entity_id": None,
            "image_url": None
        }
    ]
    json_service.write_all("lores", lores)
    
    print("Dati di esempio inizializzati con successo!")


if __name__ == "__main__":
    init_sample_data()

