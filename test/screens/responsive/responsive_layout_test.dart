import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evently/l10n/app_localizations.dart';
import 'package:evently/providers/app_auth_provider.dart';
import 'package:evently/providers/app_events_provider.dart';
import 'package:evently/providers/app_language_provider.dart';
import 'package:evently/providers/app_theme_provider.dart';
import 'package:evently/screens/auth/login_screen.dart';
import 'package:evently/screens/auth/register_screen.dart';
import 'package:evently/screens/event/create_event_screen.dart';
import 'package:evently/screens/home/home_screen.dart';
import 'package:evently/screens/favorites/favorites_tab.dart';
import 'package:evently/screens/map/map_tab.dart';
import 'package:evently/screens/profile/profile_tab.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildConstrainedApp({
    required Widget child,
    double textScaleFactor = 1.0,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => AppThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
        ChangeNotifierProvider(create: (_) => AppEventsProvider()),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ar')],
        home: MediaQuery(
          data: MediaQueryData(
            size: const Size(360, 640), // Small budget device viewport
            textScaler: TextScaler.linear(textScaleFactor),
          ),
          child: Scaffold(body: child),
        ),
      ),
    );
  }

  group('Responsive Layout & Text Scaling Tests (360x640)', () {
    testWidgets('LoginScreen renders without overflow on small device', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildConstrainedApp(child: const LoginScreen()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('RegisterScreen renders without overflow on small device', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildConstrainedApp(child: const RegisterScreen()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('HomeScreen renders cleanly with large text scale factor 1.25', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildConstrainedApp(
          child: const HomeScreen(),
          textScaleFactor: 1.25,
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('CreateEventScreen renders cleanly in scrollable view', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildConstrainedApp(child: const CreateEventScreen()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('FavoritesTab, MapTab, and ProfileTab render without overflow', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildConstrainedApp(child: const FavoritesTab()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(buildConstrainedApp(child: const MapTab()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(buildConstrainedApp(child: const ProfileTab()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
