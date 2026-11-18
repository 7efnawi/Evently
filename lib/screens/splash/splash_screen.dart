import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/app_auth_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_style.dart';
import '../../utils/app_routes.dart';

class SplashScreen extends StatefulWidget {
  final int navigationDelayMs;

  const SplashScreen({
    super.key,
    this.navigationDelayMs = 2000,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startRoutingTimer();
  }

  void _startRoutingTimer() {
    _timer = Timer(
      Duration(milliseconds: widget.navigationDelayMs),
      _checkDestination,
    );
  }

  Future<void> _checkDestination() async {
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('is_first_time') ?? true;

    if (!mounted) return;
    if (isFirstTime) {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      return;
    }

    bool isAuthenticated = false;
    try {
      final authProvider = Provider.of<AppAuthProvider>(context, listen: false);
      isAuthenticated = authProvider.isAuthenticated;
    } catch (_) {
      // If Provider is not mounted in an isolated widget test
    }

    if (!mounted) return;
    if (isAuthenticated) {
      Navigator.pushReplacementNamed(context, AppRoutes.mainLayout);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColor.backgroundDark : AppColor.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Evently',
                    style: AppStyle.logo36.copyWith(fontSize: 48),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                children: [
                  Text(
                    'Supervised by Route',
                    style: AppStyle.regular14.copyWith(
                      color: isDark ? AppColor.white : AppColor.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
