import 'package:go_router/go_router.dart';
import '../../features/knights/pages/knights_list_page.dart';
import '../../features/knights/pages/knight_detail_page.dart';
import '../../features/weapons/pages/weapons_list_page.dart';
import '../../features/weapons/pages/weapon_detail_page.dart';
import '../../features/armors/pages/armors_list_page.dart';
import '../../features/armors/pages/armor_detail_page.dart';
import '../../features/factions/pages/factions_list_page.dart';
import '../../features/factions/pages/faction_detail_page.dart';
import '../../features/bosses/pages/bosses_list_page.dart';
import '../../features/bosses/pages/boss_detail_page.dart';
import '../../features/items/pages/items_list_page.dart';
import '../../features/items/pages/item_detail_page.dart';
import '../../features/lores/pages/lores_list_page.dart';
import '../../features/lores/pages/lore_detail_page.dart';
import '../../features/home/pages/home_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/knights',
        builder: (context, state) => const KnightsListPage(),
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
        path: '/lores/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return LoreDetailPage(loreId: id);
        },
      ),
    ],
  );
}

