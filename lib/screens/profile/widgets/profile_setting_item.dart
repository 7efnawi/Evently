import 'package:flutter/material.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_style.dart';

class ProfileSettingItem extends StatelessWidget {
  final String title;
  final String selectedValue;
  final VoidCallback onTap;

  const ProfileSettingItem({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppStyle.bold20.copyWith(
            color: isDark ? AppColor.white : AppColor.textBaseDark,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? AppColor.cardDark : AppColor.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColor.primary, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedValue,
                  style: AppStyle.bold16.copyWith(color: AppColor.primary),
                ),
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppColor.primary,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
