import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/animations/app_animations.dart';
import '../../../services/api_service.dart';
import '../../../widgets/lore_card.dart';
import '../../../widgets/knight_card.dart';
import '../../../widgets/weapon_card.dart';
import '../../../widgets/boss_card.dart';
import '../../../widgets/faction_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  Map<String, int> _stats = {};
  List<dynamic> _featuredKnights = [];
  List<dynamic> _featuredWeapons = [];
  List<dynamic> _topBosses = [];
  List<dynamic> _featuredFactions = [];
  List<dynamic> _recentLores = [];
  bool _isLoading = true;
  AnimationController? _heroAnimationController;
  AnimationController? _statsAnimationController;

  @override
  void initState() {
    super.initState();
    _heroAnimationController = AnimationController(
      vsync: this,
      duration: AppAnimations.longDuration,
    );
    _statsAnimationController = AnimationController(
      vsync: this,
      duration: AppAnimations.mediumDuration,
    );
    _loadHomeData();
    _heroAnimationController?.forward();
  }


  @override
  void dispose() {
    _heroAnimationController?.dispose();
    _statsAnimationController?.dispose();
    super.dispose();
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
      final maps = await apiService.getAll('maps');
      final dndClasses = await apiService.getAll('dnd-classes');
      final characters = await apiService.getAll('characters');
      final campaigns = await apiService.getAll('campaigns');

      // Prendi alcuni elementi in evidenza
      _featuredKnights = knights.length > 3 ? knights.sublist(0, 3) : knights;
      _featuredWeapons = weapons.length > 3 ? weapons.sublist(0, 3) : weapons;
      _recentLores = lores.length > 2 ? lores.sublist(0, 2) : lores;
      
      // Top Bosses (ordinati per livello)
      final sortedBosses = List<Map<String, dynamic>>.from(bosses);
      sortedBosses.sort((a, b) => (b['level'] ?? 0).compareTo(a['level'] ?? 0));
      _topBosses = sortedBosses.length > 3 ? sortedBosses.sublist(0, 3) : sortedBosses;
      
      // Featured Factions
      _featuredFactions = factions.length > 3 ? factions.sublist(0, 3) : factions;

      if (mounted) {
        setState(() {
          _stats = {
            'knights': knights.length,
            'weapons': weapons.length,
            'armors': armors.length,
            'bosses': bosses.length,
            'items': items.length,
            'lores': lores.length,
            'factions': factions.length,
            'maps': maps.length,
            'dnd_classes': dndClasses.length,
            'characters': characters.length,
            'campaigns': campaigns.length,
          };
          _isLoading = false;
        });
        
        // Avvia animazione statistiche
        _statsAnimationController?.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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

  int _getIndexForRoute(String location) {
    return _navigationItems.indexWhere((item) {
      if (item.route == '/') {
        return location == '/';
      }
      return location.startsWith(item.route);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sincronizza l'indice della tab con la route corrente
    final router = GoRouter.of(context);
    final currentLocation = router.routerDelegate.currentConfiguration.uri.path;
    final index = _getIndexForRoute(currentLocation);
    
    if (index != -1 && index != _currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _currentIndex = index;
          });
        }
      });
    }
    
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
                    if (_featuredKnights.isNotEmpty) _buildFeaturedKnightsSection(),
                    
                    // Armi in Evidenza
                    if (_featuredWeapons.isNotEmpty) _buildFeaturedWeaponsSection(),
                    
                    // Top Bosses
                    if (_topBosses.isNotEmpty) _buildTopBossesSection(),
                    
                    // Fazioni in Evidenza
                    if (_featuredFactions.isNotEmpty) _buildFeaturedFactionsSection(),
                    
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
      bottomNavigationBar: AppAnimations.fadeSlideIn(
        duration: AppAnimations.mediumDuration,
        offset: const Offset(0, 20),
        fromBottom: true,
        child: SafeArea(
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
              final route = _navigationItems[index].route;
              setState(() {
                _currentIndex = index;
              });
              if (route != '/') {
                context.go(route);
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
      ),
    );
  }

  Widget _buildHeroSection() {
    final mediaQuery = MediaQuery.of(context);
    final em = mediaQuery.size.width / 16;
    
    return SliverToBoxAdapter(
      child: AppAnimations.fadeSlideIn(
        duration: AppAnimations.longDuration,
        offset: const Offset(0, -30),
        fromTop: true,
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
              AppAnimations.scaleIn(
                duration: AppAnimations.longDuration,
                begin: 0.5,
                curve: AppAnimations.bounceCurve,
                child: FaIcon(
                  FontAwesomeIcons.crown,
                  size: 64,
                  color: AppTheme.accentGold,
                ),
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
              children: _statsAnimationController != null
                  ? [
                      _AnimatedStatCard(
                        icon: FontAwesomeIcons.userNinja,
                        label: 'Cavalieri',
                        value: '${_stats['knights'] ?? 0}',
                        color: AppTheme.accentGold,
                        delay: 0,
                        animationController: _statsAnimationController!,
                      ),
                      _AnimatedStatCard(
                        icon: FontAwesomeIcons.gavel,
                        label: 'Armi',
                        value: '${_stats['weapons'] ?? 0}',
                        color: AppTheme.accentBrown,
                        delay: 100,
                        animationController: _statsAnimationController!,
                      ),
                      _AnimatedStatCard(
                        icon: FontAwesomeIcons.shield,
                        label: 'Armature',
                        value: '${_stats['armors'] ?? 0}',
                        color: AppTheme.accentDarkGold,
                        delay: 200,
                        animationController: _statsAnimationController!,
                      ),
                      _AnimatedStatCard(
                        icon: FontAwesomeIcons.skull,
                        label: 'Boss',
                        value: '${_stats['bosses'] ?? 0}',
                        color: AppTheme.accentCrimson,
                        delay: 300,
                        animationController: _statsAnimationController!,
                      ),
                      _AnimatedStatCard(
                        icon: FontAwesomeIcons.box,
                        label: 'Oggetti',
                        value: '${_stats['items'] ?? 0}',
                        color: AppTheme.accentGold,
                        delay: 400,
                        animationController: _statsAnimationController!,
                      ),
                      _AnimatedStatCard(
                        icon: FontAwesomeIcons.book,
                        label: 'Lore',
                        value: '${_stats['lores'] ?? 0}',
                        color: AppTheme.accentBrown,
                        delay: 500,
                        animationController: _statsAnimationController!,
                      ),
                      _AnimatedStatCard(
                        icon: FontAwesomeIcons.users,
                        label: 'Fazioni',
                        value: '${_stats['factions'] ?? 0}',
                        color: AppTheme.accentDarkGold,
                        delay: 600,
                        animationController: _statsAnimationController!,
                      ),
                    ]
                  : [
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
      'Nella battaglia, solo i coraggiosi sopravvivono.',
      'La spada del giusto taglia più profondo delle tenebre.',
    ];
    final quote = quotes[DateTime.now().day % quotes.length];

    return SliverToBoxAdapter(
      child: AppAnimations.fadeSlideIn(
        duration: AppAnimations.mediumDuration,
        offset: const Offset(30, 0),
        fromLeft: true,
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
              AppAnimations.scaleIn(
                duration: AppAnimations.mediumDuration,
                begin: 0.5,
                child: FaIcon(
                  FontAwesomeIcons.quoteLeft,
                  color: AppTheme.accentGold,
                  size: 40,
                ),
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

  Widget _buildFeaturedKnightsSection() {
    final mediaQuery = MediaQuery.of(context);
    final em = mediaQuery.size.width / 16;
    
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(em, em * 1.5, em, em),
            child: AppAnimations.fadeSlideIn(
              duration: AppAnimations.mediumDuration,
              offset: const Offset(0, -20),
              fromTop: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      FaIcon(FontAwesomeIcons.userNinja, color: AppTheme.accentGold, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Cavalieri in Evidenza',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => context.push('/knights'),
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
          ),
          SizedBox(
            height: em * 8,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: em),
              itemCount: _featuredKnights.length,
              itemBuilder: (context, index) {
                return AppAnimations.fadeSlideIn(
                  duration: AppAnimations.mediumDuration,
                  offset: const Offset(30, 0),
                  fromRight: true,
                  delay: Duration(milliseconds: index * 100),
                  child: SizedBox(
                    width: em * 12,
                    child: Padding(
                      padding: EdgeInsets.only(right: em * 0.75),
                      child: _SmallKnightCard(knight: _featuredKnights[index]),
                    ),
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

  Widget _buildFeaturedWeaponsSection() {
    final mediaQuery = MediaQuery.of(context);
    final em = mediaQuery.size.width / 16;
    
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(em, em * 1.5, em, em),
            child: AppAnimations.fadeSlideIn(
              duration: AppAnimations.mediumDuration,
              offset: const Offset(0, -20),
              fromTop: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      FaIcon(FontAwesomeIcons.gavel, color: AppTheme.accentGold, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Armi Leggendarie',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => context.push('/weapons'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Vedi tutte',
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
          ),
          SizedBox(
            height: em * 8,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: em),
              itemCount: _featuredWeapons.length,
              itemBuilder: (context, index) {
                return AppAnimations.fadeSlideIn(
                  duration: AppAnimations.mediumDuration,
                  offset: const Offset(30, 0),
                  fromRight: true,
                  delay: Duration(milliseconds: index * 100),
                  child: SizedBox(
                    width: em * 12,
                    child: Padding(
                      padding: EdgeInsets.only(right: em * 0.75),
                      child: _SmallWeaponCard(weapon: _featuredWeapons[index]),
                    ),
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

  Widget _buildTopBossesSection() {
    final mediaQuery = MediaQuery.of(context);
    final em = mediaQuery.size.width / 16;
    
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(em, em * 1.5, em, em),
            child: AppAnimations.fadeSlideIn(
              duration: AppAnimations.mediumDuration,
              offset: const Offset(0, -20),
              fromTop: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      FaIcon(FontAwesomeIcons.skull, color: AppTheme.accentCrimson, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Boss Più Potenti',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => context.push('/bosses'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Vedi tutti',
                          style: TextStyle(color: AppTheme.accentCrimson),
                        ),
                        const SizedBox(width: 4),
                        FaIcon(FontAwesomeIcons.arrowRight, size: 14, color: AppTheme.accentCrimson),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ..._topBosses.asMap().entries.map((entry) {
            final index = entry.key;
            final boss = entry.value;
            return AppAnimations.fadeSlideIn(
              duration: AppAnimations.mediumDuration,
              offset: const Offset(30, 0),
              fromRight: true,
              delay: Duration(milliseconds: index * 100),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: em, vertical: em * 0.25),
                child: BossCard(boss: boss),
              ),
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFeaturedFactionsSection() {
    final mediaQuery = MediaQuery.of(context);
    final em = mediaQuery.size.width / 16;
    
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(em, em * 1.5, em, em),
            child: AppAnimations.fadeSlideIn(
              duration: AppAnimations.mediumDuration,
              offset: const Offset(0, -20),
              fromTop: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      FaIcon(FontAwesomeIcons.users, color: AppTheme.accentGold, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Fazioni Principali',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => context.push('/factions'),
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
          ),
          ..._featuredFactions.asMap().entries.map((entry) {
            final index = entry.key;
            final faction = entry.value;
            return AppAnimations.fadeSlideIn(
              duration: AppAnimations.mediumDuration,
              offset: const Offset(-30, 0),
              fromLeft: true,
              delay: Duration(milliseconds: index * 100),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: em, vertical: em * 0.25),
                child: FactionCard(faction: faction),
              ),
            );
          }),
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
          ..._recentLores.asMap().entries.map((entry) {
            final index = entry.key;
            final lore = entry.value;
            final mediaQuery = MediaQuery.of(context);
            final em = mediaQuery.size.width / 16;
            return AppAnimations.fadeSlideIn(
              duration: AppAnimations.mediumDuration,
              offset: const Offset(0, 20),
              fromBottom: true,
              delay: Duration(milliseconds: index * 150),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: em, vertical: em * 0.25),
                child: LoreCard(lore: lore),
              ),
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
          _AnimatedHomeCard(
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
            delay: 0,
          ),
          _AnimatedHomeCard(
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
            delay: 100,
          ),
          _AnimatedHomeCard(
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
            delay: 200,
          ),
          _AnimatedHomeCard(
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
            delay: 300,
          ),
          _AnimatedHomeCard(
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
            delay: 400,
          ),
          _AnimatedHomeCard(
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
            delay: 500,
          ),
          _AnimatedHomeCard(
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
            delay: 600,
          ),
          // D&D Cards
          _AnimatedHomeCard(
            title: 'Mappe',
            icon: FontAwesomeIcons.map,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.accentGold,
                AppTheme.accentCrimson,
              ],
            ),
            onTap: () => context.push('/maps'),
            delay: 700,
          ),
          _AnimatedHomeCard(
            title: 'Classi D&D',
            icon: FontAwesomeIcons.userShield,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.accentDarkGold,
                AppTheme.accentGold,
              ],
            ),
            onTap: () => context.push('/dnd-classes'),
            delay: 800,
          ),
          _AnimatedHomeCard(
            title: 'Personaggi',
            icon: FontAwesomeIcons.user,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.accentCrimson,
                AppTheme.accentGold,
              ],
            ),
            onTap: () => context.push('/characters'),
            delay: 900,
          ),
          _AnimatedHomeCard(
            title: 'Campagne',
            icon: FontAwesomeIcons.diceD20,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.accentBrown,
                AppTheme.accentCrimson,
              ],
            ),
            onTap: () => context.push('/campaigns'),
            delay: 1000,
          ),
          _AnimatedHomeCard(
            title: 'Calendario',
            icon: FontAwesomeIcons.calendar,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.accentGold,
                AppTheme.accentDarkGold,
              ],
            ),
            onTap: () => context.push('/sessions/calendar'),
            delay: 1100,
          ),
          _AnimatedHomeCard(
            title: 'Party',
            icon: FontAwesomeIcons.users,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.accentCrimson,
                AppTheme.accentBrown,
              ],
            ),
            onTap: () => context.push('/parties'),
            delay: 1200,
          ),
        ]),
      ),
    );
  }

  Widget _buildKnightItem(Map<String, dynamic> knight) {
    return InkWell(
      onTap: () => context.push('/knights/${knight['id']}'),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        knight['name'] ?? '',
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        knight['title'] ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.accentGold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentGold),
                  ),
                  child: Text(
                    'Lv. ${knight['level'] ?? 0}',
                    style: const TextStyle(
                      color: AppTheme.accentGold,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _buildStatChip(
                  icon: FontAwesomeIcons.heart,
                  label: 'HP',
                  value: '${knight['health'] ?? 0}/${knight['max_health'] ?? 0}',
                  color: AppTheme.accentCrimson,
                ),
                _buildStatChip(
                  icon: FontAwesomeIcons.gavel,
                  label: 'ATK',
                  value: '${knight['attack'] ?? 0}',
                  color: AppTheme.accentGold,
                ),
                _buildStatChip(
                  icon: FontAwesomeIcons.shield,
                  label: 'DEF',
                  value: '${knight['defense'] ?? 0}',
                  color: AppTheme.accentBrown,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeaponItem(Map<String, dynamic> weapon) {
    final rarity = weapon['rarity'] ?? 'common';
    final rarityColor = AppTheme.getRarityColor(rarity);

    return InkWell(
      onTap: () => context.push('/weapons/${weapon['id']}'),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: rarityColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: rarityColor, width: 2),
              ),
              child: Center(
                child: FaIcon(FontAwesomeIcons.gavel, size: 24, color: AppTheme.textPrimary),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          weapon['name'] ?? '',
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: rarityColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          rarity.toUpperCase(),
                          style: TextStyle(
                            color: rarityColor,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    weapon['type'] ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildStatBadge(
                        icon: Icons.trending_up,
                        value: '+${weapon['attack_bonus'] ?? 0}',
                        label: 'ATK',
                        color: AppTheme.accentGold,
                      ),
                      const SizedBox(width: 6),
                      _buildStatBadge(
                        icon: Icons.build,
                        value: '${weapon['durability'] ?? 0}%',
                        label: 'DUR',
                        color: AppTheme.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(
            '$label: $value',
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 4),
        Text(
          '$value $label',
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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

class _AnimatedStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final int delay;
  final AnimationController animationController;

  const _AnimatedStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.delay,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final animationValue = Curves.easeOutCubic.transform(
          ((animationController.value * 1000 - delay) / 400).clamp(0.0, 1.0),
        );
        
        return Opacity(
          opacity: animationValue,
          child: Transform.scale(
            scale: 0.8 + (0.2 * animationValue),
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - animationValue)),
              child: _StatCard(
                icon: icon,
                label: label,
                value: value,
                color: color,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedHomeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;
  final int delay;

  const _AnimatedHomeCard({
    required this.title,
    required this.icon,
    required this.gradient,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return AppAnimations.fadeScaleIn(
      duration: AppAnimations.mediumDuration,
      beginScale: 0.7,
      endScale: 1.0,
      delay: Duration(milliseconds: delay),
      child: _HomeCard(
        title: title,
        icon: icon,
        gradient: gradient,
        onTap: onTap,
      ),
    );
  }
}

class _SmallKnightCard extends StatelessWidget {
  final Map<String, dynamic> knight;

  const _SmallKnightCard({required this.knight});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: AppTheme.accentGold.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => context.push('/knights/${knight['id']}'),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.secondaryDark,
                AppTheme.primaryDark,
                AppTheme.accentGold.withOpacity(0.15),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(12),
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
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: AppTheme.goldGradient,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.accentGold,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentGold.withOpacity(0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.userNinja,
                        size: 16,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.accentGold.withOpacity(0.3),
                          AppTheme.accentDarkGold.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppTheme.accentGold,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentGold.withOpacity(0.3),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      'Lv.${knight['level'] ?? 0}',
                      style: const TextStyle(
                        color: AppTheme.accentGold,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: AppTheme.primaryDark,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                knight['name'] ?? '',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppTheme.textPrimary,
                  shadows: [
                    Shadow(
                      color: AppTheme.primaryDark.withOpacity(0.8),
                      blurRadius: 2,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                knight['title'] ?? '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _SmallStatChip(
                    icon: FontAwesomeIcons.heart,
                    value: '${knight['health'] ?? 0}',
                    color: AppTheme.accentCrimson,
                  ),
                  _SmallStatChip(
                    icon: FontAwesomeIcons.gavel,
                    value: '${knight['attack'] ?? 0}',
                    color: AppTheme.accentGold,
                  ),
                  _SmallStatChip(
                    icon: FontAwesomeIcons.shield,
                    value: '${knight['defense'] ?? 0}',
                    color: AppTheme.accentBrown,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallWeaponCard extends StatelessWidget {
  final Map<String, dynamic> weapon;

  const _SmallWeaponCard({required this.weapon});

  @override
  Widget build(BuildContext context) {
    final rarity = weapon['rarity'] ?? 'common';
    final rarityColor = AppTheme.getRarityColor(rarity);

    return Card(
      elevation: 6,
      shadowColor: rarityColor.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => context.push('/weapons/${weapon['id']}'),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.secondaryDark,
                AppTheme.primaryDark,
                rarityColor.withOpacity(0.2),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: rarityColor.withOpacity(0.6),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: rarityColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          rarityColor,
                          rarityColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: rarityColor.withOpacity(0.8),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: rarityColor.withOpacity(0.5),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.gavel,
                        size: 18,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          rarityColor.withOpacity(0.4),
                          rarityColor.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: rarityColor,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: rarityColor.withOpacity(0.4),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      rarity.toUpperCase().substring(0, rarity.length > 3 ? 3 : rarity.length),
                      style: TextStyle(
                        color: rarityColor,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: AppTheme.primaryDark,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                weapon['name'] ?? '',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: AppTheme.textPrimary,
                  shadows: [
                    Shadow(
                      color: AppTheme.primaryDark.withOpacity(0.8),
                      blurRadius: 2,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                weapon['type'] ?? '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.accentGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: AppTheme.accentGold.withOpacity(0.4),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.trending_up, size: 12, color: AppTheme.accentGold),
                    const SizedBox(width: 4),
                    Text(
                      '+${weapon['attack_bonus'] ?? 0}',
                      style: TextStyle(
                        color: AppTheme.accentGold,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: AppTheme.primaryDark.withOpacity(0.5),
                            blurRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SmallStatChip extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;

  const _SmallStatChip({
    required this.icon,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 9, color: color),
          const SizedBox(width: 3),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: AppTheme.primaryDark.withOpacity(0.5),
                  blurRadius: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

