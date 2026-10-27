import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/app_auth_provider.dart';
import 'providers/app_language_provider.dart';
import 'providers/app_theme_provider.dart';
import 'screens/auth/forget_password_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main_layout/main_layout_screen.dart';
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
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
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

        },
      );
    }

    try {
      Provider.of<AppThemeProvider>(context, listen: false);
      Provider.of<AppLanguageProvider>(context, listen: false);
      Provider.of<AppAuthProvider>(context, listen: false);
      return appBuilder(context);
    } catch (_) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppThemeProvider()),
          ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
          ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ],
        child: Builder(builder: appBuilder),
      );
    }
  }
}
