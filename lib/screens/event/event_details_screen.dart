import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/app_events_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_images.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_style.dart';

class EventDetailsScreen extends StatelessWidget {
  final String? eventId;

  const EventDetailsScreen({super.key, this.eventId});

  @override
  Widget build(BuildContext context) {
    final effectiveId =
        eventId ?? ModalRoute.of(context)?.settings.arguments as String?;
    final event =
        context.watch<AppEventsProvider>().getEventById(effectiveId ?? '');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (event == null) {
      return Scaffold(
        backgroundColor:
            isDark ? AppColor.backgroundDark : AppColor.backgroundLight,
        appBar: AppBar(
          title: Text('Event Details', style: AppStyle.bold20),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
        body: Center(
          child: Text(
            'Event not found',
            style: AppStyle.medium16.copyWith(
              color: isDark ? AppColor.white : AppColor.textSecondary,
            ),
          ),
        ),
      );
    }

    final dateStr = DateFormat('dd MMMM yyyy').format(event.dateTime);
    final timeStr = DateFormat('hh:mm a').format(event.dateTime);

    return Scaffold(
      backgroundColor:
          isDark ? AppColor.backgroundDark : AppColor.backgroundLight,
      appBar: AppBar(
        title: Text('Event Details', style: AppStyle.bold20),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
        actions: [
          IconButton(
            key: const Key('edit_event_btn'),
            icon: SvgPicture.asset(
              AppImages.icEdit,
              colorFilter: ColorFilter.mode(
                isDark ? AppColor.white : AppColor.textBaseDark,
                BlendMode.srcIn,
              ),
              width: 22,
              height: 22,
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.editEvent, arguments: event);
            },
          ),
          IconButton(
            key: const Key('delete_event_btn'),
            icon: SvgPicture.asset(
              AppImages.icDelete,
              colorFilter:
                  const ColorFilter.mode(AppColor.dangerRed, BlendMode.srcIn),
              width: 22,
              height: 22,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogCtx) => AlertDialog(
                  title: const Text('Delete Event'),
                  content:
                      const Text('Are you sure you want to delete this event?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogCtx),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.dangerRed,
                      ),
                      onPressed: () async {
                        Navigator.pop(dialogCtx);
                        await context
                            .read<AppEventsProvider>()
                            .deleteEvent(event.id);
                        if (context.mounted) {
                          Navigator.maybePop(context);
                        }
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: AppColor.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                event.imagePath,
                height: 203,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              event.title,
              style: AppStyle.bold24.copyWith(color: AppColor.primary),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColor.cardDark : AppColor.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColor.primary, width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset(
                      AppImages.icCalendar,
                      colorFilter: const ColorFilter.mode(
                        AppColor.white,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateStr,
                        style: AppStyle.bold16.copyWith(color: AppColor.primary),
                      ),
                      const SizedBox(height: 4),
                      Text(timeStr, style: AppStyle.medium14),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColor.cardDark : AppColor.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColor.primary, width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset(
                      AppImages.icMapPin,
                      colorFilter: const ColorFilter.mode(
                        AppColor.white,
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      event.location,
                      style: AppStyle.bold16.copyWith(color: AppColor.primary),
                    ),
                  ),
                  SvgPicture.asset(
                    AppImages.icArrowRight,
                    colorFilter: const ColorFilter.mode(
                      AppColor.primary,
                      BlendMode.srcIn,
                    ),
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Description', style: AppStyle.bold16),
            const SizedBox(height: 8),
            Text(
              event.description,
              style: AppStyle.medium14.copyWith(
                color: isDark ? AppColor.white : AppColor.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
