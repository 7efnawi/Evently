import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app_auth_provider.dart';
import '../../providers/app_theme_provider.dart';
import '../../providers/app_language_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_style.dart';
import '../../utils/app_images.dart';
import '../../utils/app_routes.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/profile_setting_item.dart';
import 'widgets/language_bottom_sheet.dart';
import 'widgets/theme_bottom_sheet.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.watch<AppThemeProvider>();
    final languageProvider = context.watch<AppLanguageProvider>();
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor:
          isDark ? AppColor.backgroundDark : AppColor.backgroundLight,
      body: Column(
        children: [
          const ProfileHeaderCard(),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProfileSettingItem(
                    title: l10n.language,
                    selectedValue: languageProvider.isEnglish
                        ? l10n.english
                        : l10n.arabic,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const LanguageBottomSheet(),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ProfileSettingItem(
                    title: l10n.theme,
                    selectedValue:
                        themeProvider.isDark ? l10n.dark : l10n.light,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const ThemeBottomSheet(),
                      );
                    },
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    onPressed: () async {
                      await context.read<AppAuthProvider>().logout();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.login,
                          (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.dangerRed,
                      foregroundColor: AppColor.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      elevation: 0,
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AppImages.icExit,
                          colorFilter: const ColorFilter.mode(
                              AppColor.white, BlendMode.srcIn),
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          l10n.logout,
                          style:
                              AppStyle.bold20.copyWith(color: AppColor.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
