import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/animations/app_animations.dart';
import '../../../data/services/campaign_service.dart';
import '../../../data/models/campaign.dart';
import '../../../widgets/campaign_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Campaign> _recentCampaigns = [];
  List<Map<String, dynamic>> _upcomingSessions = [];
  bool _isLoading = true;
  final CampaignService _service = CampaignService();

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
      final campaigns = await _service.getAll();
      
      final now = DateTime.now();
      final upcomingSessions = <Map<String, dynamic>>[];
      
      for (var campaign in campaigns) {
        final sessions = campaign.sessions as List<dynamic>? ?? [];
        for (var session in sessions) {
          try {
            final sessionDate = DateTime.parse(session['date'] ?? '');
            if (sessionDate.isAfter(now)) {
              final sessionWithCampaign = Map<String, dynamic>.from(session);
              sessionWithCampaign['campaign_name'] = campaign.name;
              sessionWithCampaign['campaign_id'] = campaign.id;
              upcomingSessions.add(sessionWithCampaign);
            }
          } catch (e) {
          }
        }
      }
      
      upcomingSessions.sort((a, b) {
        try {
          final dateA = DateTime.parse(a['date'] ?? '');
          final dateB = DateTime.parse(b['date'] ?? '');
          return dateA.compareTo(dateB);
        } catch (e) {
          return 0;
        }
      });

      if (mounted) {
        setState(() {
          _recentCampaigns = campaigns.length > 3 
              ? campaigns.sublist(0, 3) 
              : campaigns;
          _upcomingSessions = upcomingSessions.length > 5 
              ? upcomingSessions.sublist(0, 5) 
              : upcomingSessions;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: AppTheme.getPrimaryBackgroundFromContext(context),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.getBackgroundGradientFromContext(context),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadHomeData,
                child: CustomScrollView(
                  slivers: [
                    _buildWelcomeSection(),
                    _buildUpcomingSessionsSection(),
                    _buildRecentCampaignsSection(),
                    _buildQuickActionsSection(),
                    _buildQuickEncyclopediaSection(),
                    _buildNotificationsSection(),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 80),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final goldColor = AppTheme.getAccentGoldFromContext(context);
    final brownColor = AppTheme.getAccentBrownFromContext(context);
    
    return SliverToBoxAdapter(
      child: AppAnimations.fadeSlideIn(
        duration: AppAnimations.longDuration,
        offset: const Offset(0, -30),
        fromTop: true,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: AppTheme.getMedievalGradientFromContext(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: goldColor,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: goldColor.withOpacity(0.3),
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
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isLight 
                      ? Colors.white.withOpacity(0.25)
                      : Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: goldColor.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.crown,
                    size: 64,
                    color: isLight ? brownColor : goldColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Welcome to Dark Fantasy Compendium',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: isLight 
                    ? const Color(0xFF2C1810) // Marrone scuro per light mode
                    : Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: isLight 
                        ? Colors.white.withOpacity(0.8)
                        : Colors.black.withOpacity(0.8),
                      blurRadius: 4,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Manage your D&D campaigns and dark fantasy content',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isLight 
                    ? const Color(0xFF4A3A2A) // Marrone medio per light mode
                    : Colors.white70,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      color: isLight 
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black.withOpacity(0.6),
                      blurRadius: 3,
                      offset: const Offset(0.5, 0.5),
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

  Widget _buildUpcomingSessionsSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.calendar,
                        color: AppTheme.getAccentGoldFromContext(context),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Upcoming Sessions',
                          style: Theme.of(context).textTheme.headlineSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/sessions/calendar'),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('View Calendar'),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_upcomingSessions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: AppTheme.getSecondaryBackgroundFromContext(context),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text('No upcoming sessions'),
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _upcomingSessions.length,
                itemBuilder: (context, index) {
                  final session = _upcomingSessions[index];
                  return _buildSessionCard(session);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> session) {
    DateTime? sessionDate;
    try {
      sessionDate = DateTime.parse(session['date'] ?? '');
    } catch (e) {
      sessionDate = null;
    }

    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        color: AppTheme.getSecondaryBackgroundFromContext(context),
        child: InkWell(
          onTap: () {
            if (session['campaign_id'] != null) {
              context.push('/campaigns/${session['campaign_id']}');
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.getAccentGoldFromContext(context).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.getAccentGoldFromContext(context),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          sessionDate != null
                              ? DateFormat('dd').format(sessionDate)
                              : '?',
                          style: TextStyle(
                            color: AppTheme.getAccentGoldFromContext(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session['title'] ?? 'Session',
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (session['campaign_name'] != null)
                            Text(
                              session['campaign_name'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme.getTextSecondaryFromContext(context),
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (sessionDate != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('dd MMMM yyyy', 'it_IT').format(sessionDate),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.getAccentGoldFromContext(context),
                        ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentCampaignsSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.flag,
                        color: AppTheme.getAccentGoldFromContext(context),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Recent Campaigns',
                          style: Theme.of(context).textTheme.headlineSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/campaigns'),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('View All'),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_recentCampaigns.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: AppTheme.getSecondaryBackgroundFromContext(context),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text('No campaigns found'),
                  ),
                ),
              ),
            )
          else
            ..._recentCampaigns.map((campaign) {
              final campMap = {
                'id': campaign.id,
                'name': campaign.name,
                'description': campaign.description,
                'dungeon_master': campaign.dungeonMaster,
                'current_level': campaign.currentLevel,
                'image_path': campaign.imagePath,
                'icon_path': campaign.iconPath,
              };
              return CampaignCard(campaign: campMap);
            }),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.bolt,
                  color: AppTheme.getAccentGoldFromContext(context),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _QuickActionButton(
                  icon: FontAwesomeIcons.userLarge,
                  label: 'Create\nCharacter',
                  onTap: () => context.push('/characters/new'),
                ),
                _QuickActionButton(
                  icon: FontAwesomeIcons.flag,
                  label: 'New\nCampaign',
                  onTap: () => context.push('/campaigns/new'),
                ),
                _QuickActionButton(
                  icon: FontAwesomeIcons.calendar,
                  label: 'View\nCalendar',
                  onTap: () => context.push('/sessions/calendar'),
                ),
                _QuickActionButton(
                  icon: FontAwesomeIcons.map,
                  label: 'Add\nMap',
                  onTap: () => context.push('/maps/new'),
                ),
                _QuickActionButton(
                  icon: FontAwesomeIcons.feather,
                  label: 'New\nLore',
                  onTap: () => context.push('/lores/new'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickEncyclopediaSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.book,
                        color: AppTheme.getAccentGoldFromContext(context),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Quick Reference',
                          style: Theme.of(context).textTheme.headlineSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => context.push('/encyclopedia'),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('View All'),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _EncyclopediaQuickLink(
                  icon: FontAwesomeIcons.hatWizard,
                  label: 'Classes',
                  route: '/dnd-classes',
                ),
                _EncyclopediaQuickLink(
                  icon: FontAwesomeIcons.wandSparkles,
                  label: 'Spells',
                  route: '/spells',
                ),
                _EncyclopediaQuickLink(
                  icon: FontAwesomeIcons.shieldHalved,
                  label: 'Knights',
                  route: '/knights',
                ),
                _EncyclopediaQuickLink(
                  icon: FontAwesomeIcons.gavel,
                  label: 'Weapons',
                  route: '/weapons',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.bell,
                  color: AppTheme.getAccentGoldFromContext(context),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Notifications',
                    style: Theme.of(context).textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              color: AppTheme.getSecondaryBackgroundFromContext(context),
              child: Padding(
                padding: const EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'No notifications',
                      style: TextStyle(color: AppTheme.getTextSecondaryFromContext(context)),
                    ),
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        color: AppTheme.getSecondaryBackgroundFromContext(context),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  icon,
                  color: AppTheme.getAccentGoldFromContext(context),
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EncyclopediaQuickLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;

  const _EncyclopediaQuickLink({
    required this.icon,
    required this.label,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.getSecondaryBackgroundFromContext(context),
      child: InkWell(
        onTap: () => context.push(route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                icon,
                color: AppTheme.getAccentGoldFromContext(context),
                size: 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
