import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../data/services/campaign_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/svg_icon_widget.dart';
import 'session_form_page.dart';

class SessionsCalendarPage extends StatefulWidget {
  const SessionsCalendarPage({super.key});

  @override
  State<SessionsCalendarPage> createState() => _SessionsCalendarPageState();
}

class _SessionsCalendarPageState extends State<SessionsCalendarPage> {
  Map<String, List<dynamic>> calendarData = {};
  DateTime _selectedDate = DateTime.now();
  bool isLoading = true;
  String? error;
  bool _localeInitialized = false;
  final CampaignService _service = CampaignService();

  @override
  void initState() {
    super.initState();
    _initializeLocale();
  }

  Future<void> _initializeLocale() async {
    await initializeDateFormatting('it_IT', null);
    if (mounted) {
      setState(() {
        _localeInitialized = true;
      });
      _loadCalendar();
    }
  }

  Future<void> _loadCalendar() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final campaigns = await _service.getAll();
      final calendarDataMap = <String, List<dynamic>>{};
      
      // Raccogli tutte le sessioni da tutte le campagne
      for (final campaign in campaigns) {
        if (campaign.sessions != null) {
          for (final session in campaign.sessions!) {
            final dateStr = session['date'] as String?;
            if (dateStr != null) {
              try {
                final sessionDate = DateTime.parse(dateStr);
                if (sessionDate.year == _selectedDate.year && sessionDate.month == _selectedDate.month) {
                  final dateKey = DateFormat('yyyy-MM-dd').format(sessionDate);
                  if (!calendarDataMap.containsKey(dateKey)) {
                    calendarDataMap[dateKey] = [];
                  }
                  calendarDataMap[dateKey]!.add({
                    ...session,
                    'campaign_id': campaign.id,
                    'campaign_name': campaign.name,
                  });
                }
              } catch (e) {
                // Ignora errori di parsing date
              }
            }
          }
        }
      }
      
      setState(() {
        calendarData = calendarDataMap;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _changeMonth(int delta) {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + delta, 1);
      _loadCalendar();
    });
  }

  List<DateTime> _getDaysInMonth() {
    final firstDay = DateTime(_selectedDate.year, _selectedDate.month, 1);
    final lastDay = DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    final days = <DateTime>[];
    
    // Aggiungi giorni del mese precedente per completare la prima settimana
    final firstWeekday = firstDay.weekday;
    for (int i = firstWeekday - 1; i > 0; i--) {
      days.add(firstDay.subtract(Duration(days: i)));
    }
    
    // Aggiungi tutti i giorni del mese
    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(_selectedDate.year, _selectedDate.month, i));
    }
    
    // Aggiungi giorni del mese successivo per completare l'ultima settimana
    final lastWeekday = lastDay.weekday;
    for (int i = 1; i <= 7 - lastWeekday; i++) {
      days.add(DateTime(_selectedDate.year, _selectedDate.month + 1, i));
    }
    
    return days;
  }

  List<dynamic> _getSessionsForDate(DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    return calendarData[dateStr] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    if (!_localeInitialized) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: const Text('Session Calendar'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Calendario Sessioni'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateSessionDialog(),
            tooltip: 'New Session',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error', style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCalendar,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Header con navigazione mese
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => _changeMonth(-1),
              ),
              Text(
                DateFormat('MMMM yyyy', 'it_IT').format(_selectedDate),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => _changeMonth(1),
              ),
            ],
          ),
        ),
        // Calendario
        Expanded(
          child: _buildCalendar(),
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    final days = _getDaysInMonth();
    final weekDays = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];
    
    return Column(
      children: [
        // Intestazione giorni settimana
        Row(
          children: weekDays.map((day) => Expanded(
            child: Center(
              child: Text(
                day,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )).toList(),
        ),
        const Divider(),
        // Griglia calendario
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final date = days[index];
              final isCurrentMonth = date.month == _selectedDate.month;
              final sessions = _getSessionsForDate(date);
              final isToday = date.year == DateTime.now().year &&
                             date.month == DateTime.now().month &&
                             date.day == DateTime.now().day;
              
              return GestureDetector(
                onTap: () {
                  if (sessions.isNotEmpty) {
                    _showSessionsDialog(date, sessions);
                  } else {
                    _showCreateSessionDialog(date: date);
                  }
                },
                onLongPress: () {
                  _showCreateSessionDialog(date: date);
                },
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isCurrentMonth
                        ? (isToday ? AppTheme.getAccentGoldFromContext(context).withOpacity(0.3) : Colors.transparent)
                        : Colors.grey.withOpacity(0.1),
                    border: Border.all(
                      color: isToday ? AppTheme.getAccentGoldFromContext(context) : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          color: isCurrentMonth ? AppTheme.getTextPrimaryFromContext(context) : Colors.grey,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (sessions.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppTheme.getAccentGoldFromContext(context),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showSessionsDialog(DateTime date, List<dynamic> sessions) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(DateFormat('dd MMMM yyyy', 'it_IT').format(date)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: SvgIconWidget(
                    iconPath: 'delapouite/dice-twenty-faces-twenty.svg',
                    size: 24,
                    color: AppTheme.getAccentGoldFromContext(context),
                    useThemeColor: false,
                  ),
                  title: Text(session['title'] ?? 'Untitled Session'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (session['campaign_name'] != null)
                        Text('Campagna: ${session['campaign_name']}'),
                      if (session['experience_awarded'] != null && session['experience_awarded'] > 0)
                        Text('XP: ${session['experience_awarded']}'),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/campaigns/${session['campaign_id']}');
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Chiudi'),
          ),
        ],
      ),
    );
  }

  void _showCreateSessionDialog({DateTime? date}) async {
    // Prima mostra un dialog per selezionare la campagna
    final campaigns = await _loadCampaigns();
    if (campaigns.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Create a campaign first to add sessions'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    int? selectedCampaignId;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleziona Campagna'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: campaigns.length,
            itemBuilder: (context, index) {
              final campaign = campaigns[index];
              final campaignName = campaign is Map ? campaign['name'] : campaign.name;
              final campaignDm = campaign is Map ? campaign['dungeon_master'] : campaign.dungeonMaster;
              final campaignId = campaign is Map ? campaign['id'] : campaign.id;
              return ListTile(
                title: Text(campaignName ?? ''),
                subtitle: Text('DM: ${campaignDm ?? ''}'),
                onTap: () {
                  selectedCampaignId = campaignId as int;
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );

    if (selectedCampaignId != null && mounted) {
      context.push('/sessions/new?campaignId=$selectedCampaignId${date != null ? '&date=${DateFormat('yyyy-MM-dd').format(date)}' : ''}');
    }
  }

  Future<List<dynamic>> _loadCampaigns() async {
    try {
      final campaigns = await _service.getAll();
      return campaigns.map((c) => c.toJson()).toList();
    } catch (e) {
      return [];
    }
  }
}

