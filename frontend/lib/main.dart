import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/router/app_router.dart';
import 'core/error/error_handler.dart';
import 'core/security/secure_local_data_service.dart';
import 'core/accessibility/accessibility_helper.dart';
import 'core/deep_links/deep_link_service.dart';
import 'utils/logger.dart';

void main() async {
  // Initialize error handling
  AppErrorHandler().initialize();
  
  // Run in error zone
  runZonedGuarded(
    () async {
      // Initialize Flutter bindings inside the zone
      WidgetsFlutterBinding.ensureInitialized();
      
      // Initialize date formatting
      await initializeDateFormatting('it_IT', null);
      
      // Initialize secure data service
      try {
        await SecureLocalDataService().initialize();
        AppLogger.info('Secure data service initialized');
      } catch (e, stack) {
        AppLogger.error('Failed to initialize secure data service', e, stack);
      }

      // Initialize deep link service
      try {
        DeepLinkService().initialize();
        AppLogger.info('Deep link service initialized');
      } catch (e, stack) {
        AppLogger.error('Failed to initialize deep link service', e, stack);
      }

      AppLogger.info('Application initialized successfully');
      
      runApp(const DarkFantasyApp());
    },
    (error, stack) {
      AppErrorHandler.handleZoneError(error, stack);
    },
  );
}

class DarkFantasyApp extends StatelessWidget {
  const DarkFantasyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            title: 'Dark Fantasy Compendium',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            // Enable text scaling support (80-200%)
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: AccessibilityHelper.clampTextScaler(
                    MediaQuery.of(context).textScaler,
                  ),
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}


