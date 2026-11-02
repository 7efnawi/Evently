import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../models/event_model.dart';
import '../../../providers/app_auth_provider.dart';
import '../../../providers/app_events_provider.dart';
import '../../../providers/app_language_provider.dart';
import '../../../providers/app_theme_provider.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_style.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppAuthProvider>().currentUser;
    final userName = user?.name.isNotEmpty == true ? user!.name : 'John Safwat';
    final themeProvider = context.watch<AppThemeProvider>();
    final languageProvider = context.watch<AppLanguageProvider>();
    final eventsProvider = context.watch<AppEventsProvider>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 16),
      decoration: const BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back ✨',
                    style: AppStyle.regular14.copyWith(color: AppColor.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    userName,
                    style: AppStyle.bold24.copyWith(color: AppColor.white),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      themeProvider.changeTheme(
                        themeProvider.isDark ? ThemeMode.light : ThemeMode.dark,
                      );
                    },
                    icon: SvgPicture.asset(
                      AppImages.icSun,
                      colorFilter: const ColorFilter.mode(AppColor.white, BlendMode.srcIn),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      languageProvider.changeLanguage(
                        languageProvider.isEnglish ? 'ar' : 'en',
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        languageProvider.isEnglish ? 'EN' : 'AR',
                        style: AppStyle.bold14.copyWith(color: AppColor.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              SvgPicture.asset(
                AppImages.icMapPin,
                colorFilter: const ColorFilter.mode(AppColor.white, BlendMode.srcIn),
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 6),
              Text(
                'Cairo , Egypt',
                style: AppStyle.medium14.copyWith(color: AppColor.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: EventCategory.values.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = EventCategory.values[index];
                final isSelected = category == eventsProvider.selectedCategory;

                return InkWell(
                  onTap: () => eventsProvider.setCategory(category),
                  borderRadius: BorderRadius.circular(46),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColor.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(46),
                      border: Border.all(
                        color: AppColor.white,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          category.iconPath,
                          width: 18,
                          height: 18,
                          colorFilter: ColorFilter.mode(
                            isSelected ? AppColor.primary : AppColor.white,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          category.displayName,
                          style: AppStyle.bold14.copyWith(
                            color: isSelected ? AppColor.primary : AppColor.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
