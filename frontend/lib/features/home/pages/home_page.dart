import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/api_service.dart';
import '../../../widgets/knight_card.dart';
import '../../../widgets/weapon_card.dart';
import '../../../widgets/lore_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  Map<String, int> _stats = {};
  List<dynamic> _featuredKnights = [];
  List<dynamic> _featuredWeapons = [];
  List<dynamic> _recentLores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = Provider.of<ApiService>(context, listen: false);
      
      // Carica statistiche
      final knights = await apiService.getAll('knights');
      final weapons = await apiService.getAll('weapons');
      final armors = await apiService.getAll('armors');
      final bosses = await apiService.getAll('bosses');
      final items = await apiService.getAll('items');
      final lores = await apiService.getAll('lores');
      final factions = await apiService.getAll('factions');

      // Prendi alcuni elementi in evidenza
      _featuredKnights = knights.length > 3 ? knights.sublist(0, 3) : knights;
      _featuredWeapons = weapons.length > 3 ? weapons.sublist(0, 3) : weapons;
      _recentLores = lores.length > 2 ? lores.sublist(0, 2) : lores;

      setState(() {
        _stats = {
          'knights': knights.length,
          'weapons': weapons.length,
          'armors': armors.length,
          'bosses': bosses.length,
          'items': items.length,
          'lores': lores.length,
          'factions': factions.length,
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home,
      label: 'Home',
      route: '/',
    ),
    NavigationItem(
      icon: Icons.person,
      label: 'Cavalieri',
      route: '/knights',
    ),
    NavigationItem(
      icon: FontAwesomeIcons.gavel,
      label: 'Armi',
      route: '/weapons',
    ),
    NavigationItem(
      icon: Icons.shield,
      label: 'Armature',
      route: '/armors',
    ),
    NavigationItem(
      icon: Icons.menu_book,
      label: 'Lore',
      route: '/lores',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final em = screenWidth / 16; // Base em unit (1em = 1/16 della larghezza schermo)
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dark Fantasy Compendium'),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.darkGradient,
          ),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _loadHomeData,
                  child: CustomScrollView(
                    slivers: [
                    // Hero Section
                    _buildHeroSection(),
                    
                    // Statistiche
                    _buildStatsSection(),
                    
                    // Citazione Medievale
                    _buildQuoteSection(),
                    
                    // Cavalieri in Evidenza
                    if (_featuredKnights.isNotEmpty) _buildFeaturedSection(
                      title: 'Cavalieri Eroici',
                      icon: Icons.person,
                      route: '/knights',
                      items: _featuredKnights,
                      builder: (item) => KnightCard(knight: item),
                    ),
                    
                    // Armi in Evidenza
                    if (_featuredWeapons.isNotEmpty) _buildFeaturedSection(
                      title: 'Armi Leggendarie',
                      icon: FontAwesomeIcons.gavel,
                      route: '/weapons',
                      items: _featuredWeapons,
                      builder: (item) => WeaponCard(weapon: item),
                    ),
                    
                    // Lore Recenti
                    if (_recentLores.isNotEmpty) _buildLoreSection(),
                    
                    // Sezione Card Principali
                    _buildMainCardsSection(),
                    
                    SliverToBoxAdapter(
                      child: SizedBox(height: MediaQuery.of(context).size.width / 16 * 5),
                    ),
                  ],
                ),
              ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.secondaryDark,
              AppTheme.primaryDark,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentGold.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            final route = _navigationItems[index].route;
            if (route != '/') {
              context.push(route);
            } else {
              context.go(route);
            }
          },
          items: _navigationItems.map((item) {
            Widget iconWidget;
            if (item.icon is IconData) {
              final iconData = item.icon as IconData;
              // Controlla se è un'icona FontAwesome confrontando il package
              if (iconData.fontPackage == 'font_awesome_flutter') {
                // Usa la stessa dimensione delle icone Material per allineamento corretto
                iconWidget = SizedBox(
                  width: 24,
                  height: 24,
                  child: Center(
                    child: FaIcon(iconData, size: 24),
                  ),
                );
              } else {
                iconWidget = Icon(iconData);
              }
            } else {
              iconWidget = Icon(item.icon);
            }
            return BottomNavigationBarItem(
              icon: iconWidget,
              label: item.label,
            );
          }).toList(),
        ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    final mediaQuery = MediaQuery.of(context);
    final em = mediaQuery.size.width / 16;
    
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.all(em),
        padding: EdgeInsets.all(em * 2),
        decoration: BoxDecoration(
          gradient: AppTheme.medievalGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.accentGold,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.accentGold.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            FaIcon(
              FontAwesomeIcons.crown,
              size: 64,
              color: AppTheme.accentGold,
            ),
            const SizedBox(height: 16),
            Text(
              'Benvenuto, Cavaliere',
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Esplora il Compendio delle Tenebre',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    final mediaQuery = MediaQuery.of(context);
    final em = mediaQuery.size.width / 16;
    
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: em, vertical: em * 0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FaIcon(FontAwesomeIcons.chartBar, color: AppTheme.accentGold, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Statistiche del Regno',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _StatCard(
                  icon: FontAwesomeIcons.userNinja,
                  label: 'Cavalieri',
                  value: '${_stats['knights'] ?? 0}',
                  color: AppTheme.accentGold,
                ),
                _StatCard(
                  icon: FontAwesomeIcons.gavel,
                  label: 'Armi',
                  value: '${_stats['weapons'] ?? 0}',
                  color: AppTheme.accentBrown,
                ),
                _StatCard(
                  icon: FontAwesomeIcons.shield,
                  label: 'Armature',
                  value: '${_stats['armors'] ?? 0}',
                  color: AppTheme.accentDarkGold,
                ),
                _StatCard(
                  icon: FontAwesomeIcons.skull,
                  label: 'Boss',
                  value: '${_stats['bosses'] ?? 0}',
                  color: AppTheme.accentCrimson,
                ),
                _StatCard(
                  icon: FontAwesomeIcons.box,
                  label: 'Oggetti',
                  value: '${_stats['items'] ?? 0}',
                  color: AppTheme.accentGold,
                ),
                _StatCard(
                  icon: FontAwesomeIcons.book,
                  label: 'Lore',
                  value: '${_stats['lores'] ?? 0}',
                  color: AppTheme.accentBrown,
                ),
                _StatCard(
                  icon: FontAwesomeIcons.users,
                  label: 'Fazioni',
                  value: '${_stats['factions'] ?? 0}',
                  color: AppTheme.accentDarkGold,
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuoteSection() {
    final mediaQuery = MediaQuery.of(context);
    final em = mediaQuery.size.width / 16;
    
    final quotes = [
      'Nelle tenebre più profonde, la luce del coraggio brilla più forte.',
      'Un cavaliere non è definito dalla sua armatura, ma dal suo cuore.',
      'Le leggende nascono dalle battaglie combattute, non da quelle evitate.',
      'Il destino si forgia con il fuoco della determinazione.',
    ];
    final quote = quotes[DateTime.now().day % quotes.length];

    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: em, vertical: em * 0.5),
        padding: EdgeInsets.all(em * 1.25),
        decoration: BoxDecoration(
          color: AppTheme.secondaryDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.accentGold.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.quoteLeft,
              color: AppTheme.accentGold,
              size: 40,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                quote,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedSection({
    required String title,
    required IconData icon,
    required String route,
    required List<dynamic> items,
    required Widget Function(dynamic) builder,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final em = mediaQuery.size.width / 16;
    
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(em, em * 1.5, em, em),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    FaIcon(icon, color: AppTheme.accentGold, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => context.push(route),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Vedi tutti',
                        style: TextStyle(color: AppTheme.accentGold),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 16, color: AppTheme.accentGold),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: em * 12.5,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: em),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: em * 18.75,
                  child: Padding(
                    padding: EdgeInsets.only(right: em * 0.75),
                    child: builder(items[index]),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildLoreSection() {
    final mediaQuery = MediaQuery.of(context);
    final em = mediaQuery.size.width / 16;
    
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(em, em * 1.5, em, em),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    FaIcon(FontAwesomeIcons.book, color: AppTheme.accentGold, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Storie e Leggende',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => context.push('/lores'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Vedi tutte',
                        style: TextStyle(color: AppTheme.accentGold),
                      ),
                      const SizedBox(width: 4),
                      FaIcon(FontAwesomeIcons.arrowRight, size: 14, color: AppTheme.accentGold),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ..._recentLores.map((lore) {
            final mediaQuery = MediaQuery.of(context);
            final em = mediaQuery.size.width / 16;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: em, vertical: em * 0.25),
              child: LoreCard(lore: lore),
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMainCardsSection() {
    final mediaQuery = MediaQuery.of(context);
    final em = mediaQuery.size.width / 16;
    
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: em, vertical: em * 0.5),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: em,
          mainAxisSpacing: em,
          childAspectRatio: 0.85,
        ),
        delegate: SliverChildListDelegate([
          _HomeCard(
            title: 'Cavalieri',
            icon: FontAwesomeIcons.userNinja,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.accentGold,
                AppTheme.accentDarkGold,
              ],
            ),
            onTap: () => context.push('/knights'),
          ),
          _HomeCard(
            title: 'Armi',
            icon: FontAwesomeIcons.gavel,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.accentBrown,
                AppTheme.primaryDark,
              ],
            ),
            onTap: () => context.push('/weapons'),
          ),
          _HomeCard(
            title: 'Armature',
            icon: FontAwesomeIcons.shield,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.accentGold,
                AppTheme.accentBrown,
              ],
            ),
            onTap: () => context.push('/armors'),
          ),
          _HomeCard(
            title: 'Fazioni',
            icon: FontAwesomeIcons.users,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.accentDarkGold,
                AppTheme.accentBrown,
              ],
            ),
            onTap: () => context.push('/factions'),
          ),
          _HomeCard(
            title: 'Boss',
            icon: FontAwesomeIcons.skull,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.accentCrimson,
                AppTheme.accentBrown,
              ],
            ),
            onTap: () => context.push('/bosses'),
          ),
          _HomeCard(
            title: 'Oggetti',
            icon: FontAwesomeIcons.box,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.accentGold,
                AppTheme.accentDarkGold,
              ],
            ),
            onTap: () => context.push('/items'),
          ),
          _HomeCard(
            title: 'Lore',
            icon: FontAwesomeIcons.book,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.accentBrown,
                AppTheme.primaryDark,
              ],
            ),
            onTap: () => context.push('/lores'),
          ),
        ]),
      ),
    );
  }
}

class NavigationItem {
  final dynamic icon; // Può essere IconData o FontAwesomeIcons
  final String label;
  final String route;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

class _HomeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  const _HomeCard({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.accentGold.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentGold.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryDark.withOpacity(0.3),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.accentGold.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: FaIcon(
                  icon,
                  size: 48,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: AppTheme.primaryDark.withOpacity(0.8),
                      blurRadius: 4,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

