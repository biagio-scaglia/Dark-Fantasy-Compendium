import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'services/api_service.dart';

void main() {
  runApp(const DarkFantasyApp());
}

class DarkFantasyApp extends StatelessWidget {
  const DarkFantasyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(
          create: (_) => ApiService(baseUrl: 'http://localhost:8000/api/v1'),
        ),
      ],
      child: MaterialApp.router(
        title: 'Dark Fantasy Compendium',
        theme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

