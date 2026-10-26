import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/app_language_provider.dart';
import 'providers/app_theme_provider.dart';
import 'screens/onboarding/onboarding_setup_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'utils/app_routes.dart';
import 'utils/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
      ],
      child: const EventlyApp(),
    ),
  );
}

class EventlyApp extends StatelessWidget {
  const EventlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      Provider.of<AppThemeProvider>(context, listen: false);
      Provider.of<AppLanguageProvider>(context, listen: false);
      return _buildMaterialApp(context);
    } catch (_) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppThemeProvider()),
          ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
        ],
        child: Builder(
          builder: (innerContext) => _buildMaterialApp(innerContext),
        ),
      );
    }
  }

  Widget _buildMaterialApp(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final languageProvider = context.watch<AppLanguageProvider>();

    return MaterialApp(
      title: 'Evently',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      locale: languageProvider.appLocale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.onboarding: (_) => const OnboardingSetupScreen(),
        AppRoutes.login: (_) =>
            const Scaffold(body: Center(child: Text('Login Screen'))),
      },
    );
  }
}
