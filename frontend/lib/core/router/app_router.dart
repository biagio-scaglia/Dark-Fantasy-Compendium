import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../features/knights/pages/knights_list_page.dart';
import '../../features/knights/pages/knight_detail_page.dart';
import '../../features/knights/pages/knight_form_page.dart';
import '../../features/weapons/pages/weapons_list_page.dart';
import '../../features/weapons/pages/weapon_detail_page.dart';
import '../../features/weapons/pages/weapon_form_page.dart';
import '../../features/armors/pages/armors_list_page.dart';
import '../../features/armors/pages/armor_detail_page.dart';
import '../../features/armors/pages/armor_form_page.dart';
import '../../features/factions/pages/factions_list_page.dart';
import '../../features/factions/pages/faction_detail_page.dart';
import '../../features/factions/pages/faction_form_page.dart';
import '../../features/bosses/pages/bosses_list_page.dart';
import '../../features/bosses/pages/boss_detail_page.dart';
import '../../features/items/pages/items_list_page.dart';
import '../../features/items/pages/item_detail_page.dart';
import '../../features/lores/pages/lores_list_page.dart';
import '../../features/lores/pages/lore_detail_page.dart';
import '../../features/maps/pages/maps_list_page.dart';
import '../../features/maps/pages/map_detail_page.dart';
import '../../features/maps/pages/map_form_page.dart';
import '../../features/dnd_classes/pages/dnd_classes_list_page.dart';
import '../../features/dnd_classes/pages/dnd_class_detail_page.dart';
import '../../features/dnd_classes/pages/dnd_class_form_page.dart';
import '../../features/characters/pages/characters_list_page.dart';
import '../../features/characters/pages/character_detail_page.dart';
import '../../features/campaigns/pages/campaigns_list_page.dart';
import '../../features/campaigns/pages/campaign_detail_page.dart';
import '../../features/parties/pages/parties_list_page.dart';
import '../../features/parties/pages/party_detail_page.dart';
import '../../features/parties/pages/party_form_page.dart';
import '../../features/sessions/pages/sessions_calendar_page.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/characters/pages/character_form_page.dart';
import '../../features/campaigns/pages/campaign_form_page.dart';
import '../../features/items/pages/item_form_page.dart';
import '../../features/bosses/pages/boss_form_page.dart';
import '../../features/lores/pages/lore_form_page.dart';
import '../../features/sessions/pages/session_form_page.dart';
import '../../features/encyclopedia/pages/encyclopedia_page.dart';
import '../../features/party_characters/pages/party_characters_page.dart';
import '../../features/info/pages/info_page.dart';
import '../../features/races/pages/races_list_page.dart';
import '../../features/races/pages/race_form_page.dart';
import '../../features/races/pages/race_detail_page.dart';
import '../../features/spells/pages/spells_list_page.dart';
import '../../features/abilities/pages/abilities_list_page.dart';
import '../theme/app_theme.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      if (state.uri.path == '/') {
        return '/home';
      }
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _MainScaffoldWithNavBar(
            navigationShell: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/campaigns',
                builder: (context, state) => const CampaignsListPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/encyclopedia',
                builder: (context, state) => const EncyclopediaPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/party-characters',
                builder: (context, state) => const PartyCharactersPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/info',
                builder: (context, state) => const InfoPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/knights',
        builder: (context, state) => const KnightsListPage(),
      ),
      GoRoute(
        path: '/knights/new',
        builder: (context, state) => const KnightFormPage(),
      ),
      GoRoute(
        path: '/knights/:id/edit',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return KnightFormPage(knight: {'id': id});
        },
      ),
      GoRoute(
        path: '/knights/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return KnightDetailPage(knightId: id);
        },
      ),
      GoRoute(
        path: '/weapons',
        builder: (context, state) => const WeaponsListPage(),
      ),
      GoRoute(
        path: '/weapons/new',
        builder: (context, state) => const WeaponFormPage(),
      ),
      GoRoute(
        path: '/weapons/:id/edit',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return WeaponFormPage(weapon: {'id': id});
        },
      ),
      GoRoute(
        path: '/weapons/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return WeaponDetailPage(weaponId: id);
        },
      ),
      GoRoute(
        path: '/armors',
        builder: (context, state) => const ArmorsListPage(),
      ),
      GoRoute(
        path: '/armors/new',
        builder: (context, state) => const ArmorFormPage(),
      ),
      GoRoute(
        path: '/armors/:id/edit',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ArmorFormPage(armor: {'id': id});
        },
      ),
      GoRoute(
        path: '/armors/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ArmorDetailPage(armorId: id);
        },
      ),
      GoRoute(
        path: '/factions',
        builder: (context, state) => const FactionsListPage(),
      ),
      GoRoute(
        path: '/factions/new',
        builder: (context, state) => const FactionFormPage(),
      ),
      GoRoute(
        path: '/factions/:id/edit',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return FactionFormPage(faction: {'id': id});
        },
      ),
      GoRoute(
        path: '/factions/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return FactionDetailPage(factionId: id);
        },
      ),
      GoRoute(
        path: '/bosses',
        builder: (context, state) => const BossesListPage(),
      ),
      GoRoute(
        path: '/bosses/new',
        builder: (context, state) => const BossFormPage(),
      ),
      GoRoute(
        path: '/bosses/:id/edit',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return BossFormPage(boss: {'id': id});
        },
      ),
      GoRoute(
        path: '/bosses/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return BossDetailPage(bossId: id);
        },
      ),
      GoRoute(
        path: '/items',
        builder: (context, state) => const ItemsListPage(),
      ),
      GoRoute(
        path: '/items/new',
        builder: (context, state) => const ItemFormPage(),
      ),
      GoRoute(
        path: '/items/:id/edit',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ItemFormPage(item: {'id': id});
        },
      ),
      GoRoute(
        path: '/items/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ItemDetailPage(itemId: id);
        },
      ),
      GoRoute(
        path: '/lores',
        builder: (context, state) => const LoresListPage(),
      ),
      GoRoute(
        path: '/lores/new',
        builder: (context, state) => const LoreFormPage(),
      ),
      GoRoute(
        path: '/lores/:id/edit',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return LoreFormPage(lore: {'id': id});
        },
      ),
      GoRoute(
        path: '/lores/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return LoreDetailPage(loreId: id);
        },
      ),
      GoRoute(
        path: '/maps',
        builder: (context, state) => const MapsListPage(),
      ),
      GoRoute(
        path: '/maps/new',
        builder: (context, state) => const MapFormPage(),
      ),
      GoRoute(
        path: '/maps/:id/edit',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return MapFormPage(map: {'id': id});
        },
      ),
      GoRoute(
        path: '/maps/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return MapDetailPage(mapId: id);
        },
      ),
      GoRoute(
        path: '/dnd-classes',
        builder: (context, state) => const DndClassesListPage(),
      ),
      GoRoute(
        path: '/dnd-classes/new',
        builder: (context, state) => const DndClassFormPage(),
      ),
      GoRoute(
        path: '/dnd-classes/:id/edit',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DndClassFormPage(dndClass: {'id': id});
        },
      ),
      GoRoute(
        path: '/dnd-classes/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DndClassDetailPage(classId: id);
        },
      ),
      GoRoute(
        path: '/characters',
        builder: (context, state) => const CharactersListPage(),
      ),
      GoRoute(
        path: '/characters/new',
        builder: (context, state) => const CharacterFormPage(),
      ),
      GoRoute(
        path: '/characters/:id/edit',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CharacterFormPage(character: {'id': id});
        },
      ),
      GoRoute(
        path: '/characters/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CharacterDetailPage(characterId: id);
        },
      ),
      GoRoute(
        path: '/campaigns/new',
        builder: (context, state) => const CampaignFormPage(),
      ),
      GoRoute(
        path: '/campaigns/:id/edit',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CampaignFormPage(campaign: {'id': id});
        },
      ),
      GoRoute(
        path: '/campaigns/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CampaignDetailPage(campaignId: id);
        },
      ),
      GoRoute(
        path: '/parties',
        builder: (context, state) => const PartiesListPage(),
      ),
      GoRoute(
        path: '/parties/new',
        builder: (context, state) => const PartyFormPage(),
      ),
      GoRoute(
        path: '/parties/:id/edit',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return PartyFormPage(party: {'id': id});
        },
      ),
      GoRoute(
        path: '/parties/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return PartyDetailPage(partyId: id);
        },
      ),
      GoRoute(
        path: '/sessions/calendar',
        builder: (context, state) => const SessionsCalendarPage(),
      ),
      GoRoute(
        path: '/sessions/new',
        builder: (context, state) {
          final campaignIdStr = state.uri.queryParameters['campaignId'];
          final dateStr = state.uri.queryParameters['date'];
          final campaignId = campaignIdStr != null ? int.parse(campaignIdStr) : 1;
          Map<String, dynamic>? session;
          if (dateStr != null) {
            session = {'date': dateStr};
          }
          return SessionFormPage(campaignId: campaignId, session: session);
        },
      ),
      GoRoute(
        path: '/races',
        builder: (context, state) => const RacesListPage(),
      ),
      GoRoute(
        path: '/races/new',
        builder: (context, state) => const RaceFormPage(),
      ),
      GoRoute(
        path: '/races/:id/edit',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return RaceFormPage(raceId: id);
        },
      ),
      GoRoute(
        path: '/races/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return RaceDetailPage(raceId: id);
        },
      ),
      GoRoute(
        path: '/spells',
        builder: (context, state) => const SpellsListPage(),
      ),
      GoRoute(
        path: '/abilities',
        builder: (context, state) => const AbilitiesListPage(),
      ),
    ],
  );
}

class _MainScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _MainScaffoldWithNavBar({
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.getSecondaryBackgroundFromContext(context),
              AppTheme.getPrimaryBackgroundFromContext(context),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: _onTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: AppTheme.getAccentGoldFromContext(context),
            unselectedItemColor: AppTheme.getTextSecondaryFromContext(context),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.house),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.flag),
                label: 'Campaigns',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.book),
                label: 'Encyclopedia',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.users),
                label: 'Party',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.circleInfo),
                label: 'Info',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
