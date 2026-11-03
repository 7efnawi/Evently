import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../models/event_model.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_style.dart';

class MapEventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;

  const MapEventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? AppColor.cardDark : AppColor.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColor.primary, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                event.imagePath,
                width: 90,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    event.title,
                    style: AppStyle.bold14.copyWith(
                      color: isDark ? AppColor.white : AppColor.textBaseDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SvgPicture.asset(
                        AppImages.icMapPin,
                        width: 16,
                        height: 16,
                        colorFilter: const ColorFilter.mode(
                          AppColor.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: AppStyle.bold12.copyWith(
                            color: isDark
                                ? AppColor.white
                                : AppColor.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
