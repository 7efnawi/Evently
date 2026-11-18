import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/app_auth_provider.dart';
import 'providers/app_events_provider.dart';
import 'providers/app_language_provider.dart';
import 'providers/app_theme_provider.dart';
import 'screens/auth/forget_password_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/event/create_event_screen.dart';
import 'screens/event/edit_event_screen.dart';
import 'screens/event/event_details_screen.dart';
import 'screens/main_layout/main_layout_screen.dart';
import 'screens/onboarding/onboarding_setup_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'utils/app_routes.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (_) {}
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProxyProvider<AppAuthProvider, AppEventsProvider>(
          create: (_) => AppEventsProvider(),
          update: (_, auth, events) {
            final provider = events ?? AppEventsProvider();
            provider.updateUid(auth.currentUser?.id);
            return provider;
          },
        ),
      ],
      child: const EventlyApp(),
    ),
  );
}

class EventlyApp extends StatelessWidget {
  const EventlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget appBuilder(BuildContext ctx) {
      final themeProvider = ctx.watch<AppThemeProvider>();
      final languageProvider = ctx.watch<AppLanguageProvider>();

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
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (_) => const SplashScreen(),
          AppRoutes.onboarding: (_) => const OnboardingSetupScreen(),
          AppRoutes.login: (_) => const LoginScreen(),
          AppRoutes.register: (_) => const RegisterScreen(),
          AppRoutes.forgetPassword: (_) => const ForgetPasswordScreen(),
          AppRoutes.mainLayout: (_) => const MainLayoutScreen(),
          AppRoutes.createEvent: (_) => const CreateEventScreen(),
          AppRoutes.eventDetails: (_) => const EventDetailsScreen(),
          AppRoutes.editEvent: (_) => const EditEventScreen(),
        },
      );
    }

    try {
      Provider.of<AppThemeProvider>(context, listen: false);
      Provider.of<AppLanguageProvider>(context, listen: false);
      Provider.of<AppAuthProvider>(context, listen: false);
      Provider.of<AppEventsProvider>(context, listen: false);
      return appBuilder(context);
    } catch (_) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppThemeProvider()),
          ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
          ChangeNotifierProvider(create: (_) => AppAuthProvider()),
          ChangeNotifierProxyProvider<AppAuthProvider, AppEventsProvider>(
            create: (_) => AppEventsProvider(),
            update: (_, auth, events) {
              final provider = events ?? AppEventsProvider();
              provider.updateUid(auth.currentUser?.id);
              return provider;
            },
          ),
        ],
        child: Builder(builder: appBuilder),
      );
    }
  }
}
