import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../models/event_model.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_style.dart';

class CategoryChipSelector extends StatelessWidget {
  final EventCategory selectedCategory;
  final ValueChanged<EventCategory> onCategoryChanged;
  final bool includeAll;

  const CategoryChipSelector({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
    this.includeAll = false,
  });

  @override
  Widget build(BuildContext context) {
    final categories = includeAll
        ? EventCategory.values
        : EventCategory.values.where((c) => c != EventCategory.all).toList();

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;

          return InkWell(
            onTap: () => onCategoryChanged(category),
            borderRadius: BorderRadius.circular(46),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColor.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(46),
                border: Border.all(
                  color: AppColor.primary,
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    category.iconPath,
                    width: 20,
                    height: 20,
                    colorFilter: ColorFilter.mode(
                      isSelected ? AppColor.white : AppColor.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category.displayName,
                    style: AppStyle.bold16.copyWith(
                      color: isSelected ? AppColor.white : AppColor.primary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
