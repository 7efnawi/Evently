import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_theme_provider.dart';
import '../../providers/app_language_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_style.dart';
import '../../utils/app_images.dart';
import '../../widgets/custom_elevated_button.dart';
import 'widgets/toggle_selector_widget.dart';
import 'onboarding_screen.dart';

class OnboardingSetupScreen extends StatelessWidget {
  const OnboardingSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final languageProvider = context.watch<AppLanguageProvider>();
    final isDark = themeProvider.isDarkMode;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor:
          isDark ? AppColor.backgroundDark : AppColor.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text('Evently', style: AppStyle.logo36),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: SvgPicture.asset(
                    AppImages.onboarding1,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.personalizeExperience,
                style: AppStyle.bold20.copyWith(
                  color: isDark ? AppColor.white : AppColor.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.personalizeSubtitle,
                style: AppStyle.regular14.copyWith(
                  color: isDark ? AppColor.white : AppColor.textBaseDark,
                ),
              ),
              const SizedBox(height: 20),
              ToggleSelectorWidget(
                title: l10n.language,
                titleStyle: AppStyle.bold20.copyWith(
                  color: isDark ? AppColor.white : AppColor.primary,
                ),
                isFirstSelected: languageProvider.isEnglish,
                onFirstSelected: () => languageProvider.changeLanguage('en'),
                onSecondSelected: () => languageProvider.changeLanguage('ar'),
                firstOption: Text(
                  'EN',
                  style: AppStyle.bold14.copyWith(
                    color: languageProvider.isEnglish
                        ? AppColor.white
                        : AppColor.primary,
                  ),
                ),
                secondOption: Text(
                  'عربي',
                  style: AppStyle.bold14.copyWith(
                    color: !languageProvider.isEnglish
                        ? AppColor.white
                        : AppColor.primary,
                  ),
                ),
              ),
              ToggleSelectorWidget(
                title: l10n.theme,
                titleStyle: AppStyle.bold20.copyWith(
                  color: isDark ? AppColor.white : AppColor.primary,
                ),
                isFirstSelected: !isDark,
                onFirstSelected: () =>
                    themeProvider.changeTheme(ThemeMode.light),
                onSecondSelected: () =>
                    themeProvider.changeTheme(ThemeMode.dark),
                firstOption: Icon(
                  Icons.wb_sunny_outlined,
                  key: const Key('theme_light_button'),
                  size: 20,
                  color: !isDark ? AppColor.white : AppColor.primary,
                ),
                secondOption: Icon(
                  Icons.nightlight_round_outlined,
                  key: const Key('theme_dark_button'),
                  size: 20,
                  color: isDark ? AppColor.white : AppColor.primary,
                ),
              ),
              const SizedBox(height: 16),
              CustomElevatedButton(
                title: l10n.start,
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OnboardingScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
