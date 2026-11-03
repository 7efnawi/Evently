import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/app_theme_provider.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_style.dart';

class ThemeBottomSheet extends StatelessWidget {
  const ThemeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final isDarkSelected = themeProvider.isDark;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: isDark ? AppColor.cardDark : AppColor.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItem(
            context: context,
            title: l10n.light,
            isSelected: !isDarkSelected,
            onTap: () {
              context.read<AppThemeProvider>().changeTheme(ThemeMode.light);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 16),
          _buildItem(
            context: context,
            title: l10n.dark,
            isSelected: isDarkSelected,
            onTap: () {
              context.read<AppThemeProvider>().changeTheme(ThemeMode.dark);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: isSelected
                  ? AppStyle.bold20.copyWith(color: AppColor.primary)
                  : AppStyle.bold20.copyWith(
                      color: isDark ? AppColor.white : AppColor.textBaseDark,
                    ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                color: AppColor.primary,
                size: 26,
              ),
          ],
        ),
      ),
    );
  }
}
