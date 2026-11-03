import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_style.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBarColor = isDark ? AppColor.cardDark : AppColor.primary;
    final l10n = context.l10n;

    return BottomAppBar(
      color: navBarColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              icon: AppImages.icHome,
              label: l10n.home,
              isSelected: selectedIndex == 0,
            ),
            _buildNavItem(
              index: 1,
              icon: AppImages.icMapPin,
              label: l10n.map,
              isSelected: selectedIndex == 1,
            ),
            const SizedBox(width: 48), // Space for centered FAB notch
            _buildNavItem(
              index: 2,
              icon: AppImages.icHeart,
              label: l10n.love,
              isSelected: selectedIndex == 2,
            ),
            _buildNavItem(
              index: 3,
              icon: AppImages.icProfile,
              label: l10n.profile,
              isSelected: selectedIndex == 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String icon,
    required String label,
    required bool isSelected,
  }) {
    final color =
        isSelected ? AppColor.white : AppColor.white.withValues(alpha: 0.65);

    return InkWell(
      onTap: () => onTabSelected(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppStyle.bold12.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
