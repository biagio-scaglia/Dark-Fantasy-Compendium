import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/animations/app_animations.dart';
import '../../../services/api_service.dart';
import '../../../widgets/campaign_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recentCampaigns = [];
  List<dynamic> _upcomingSessions = [];
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
      final campaigns = await apiService.getAll('campaigns');
      
      final now = DateTime.now();
      final upcomingSessions = <Map<String, dynamic>>[];
      
      for (var campaign in campaigns) {
        final sessions = campaign['sessions'] as List<dynamic>? ?? [];
        for (var session in sessions) {
          try {
            final sessionDate = DateTime.parse(session['date'] ?? '');
            if (sessionDate.isAfter(now)) {
              final sessionWithCampaign = Map<String, dynamic>.from(session);
              sessionWithCampaign['campaign_name'] = campaign['name'];
              sessionWithCampaign['campaign_id'] = campaign['id'];
              upcomingSessions.add(sessionWithCampaign);
            }
          } catch (e) {
            // Skip invalid dates
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
        backgroundColor: AppTheme.primaryDark,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.darkGradient,
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
    return SliverToBoxAdapter(
      child: AppAnimations.fadeSlideIn(
        duration: AppAnimations.longDuration,
        offset: const Offset(0, -30),
        fromTop: true,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
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
                child: const FaIcon(
                  FontAwesomeIcons.crown,
                  size: 64,
                  color: AppTheme.accentGold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome to Dark Fantasy Compendium',
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Manage your D&D campaigns and dark fantasy content',
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
                      const FaIcon(
                        FontAwesomeIcons.calendar,
                        color: AppTheme.accentGold,
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
                color: AppTheme.secondaryDark,
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
        color: AppTheme.secondaryDark,
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
                        color: AppTheme.accentGold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.accentGold,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          sessionDate != null
                              ? DateFormat('dd').format(sessionDate)
                              : '?',
                          style: const TextStyle(
                            color: AppTheme.accentGold,
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
                                    color: AppTheme.textSecondary,
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
                          color: AppTheme.accentGold,
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
                      const FaIcon(
                        FontAwesomeIcons.flag,
                        color: AppTheme.accentGold,
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
                color: AppTheme.secondaryDark,
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text('No campaigns found'),
                  ),
                ),
              ),
            )
          else
            ..._recentCampaigns.map((campaign) => CampaignCard(campaign: campaign)),
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
                const FaIcon(
                  FontAwesomeIcons.bolt,
                  color: AppTheme.accentGold,
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
                      const FaIcon(
                        FontAwesomeIcons.book,
                        color: AppTheme.accentGold,
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
                const FaIcon(
                  FontAwesomeIcons.bell,
                  color: AppTheme.accentGold,
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
              color: AppTheme.secondaryDark,
              child: const Padding(
                padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'No notifications',
                      style: TextStyle(color: AppTheme.textSecondary),
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
        color: AppTheme.secondaryDark,
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
                  color: AppTheme.accentGold,
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
      color: AppTheme.secondaryDark,
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
                color: AppTheme.accentGold,
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
