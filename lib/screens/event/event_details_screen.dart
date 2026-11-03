import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/event_model.dart';
import '../../providers/app_events_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_images.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_style.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventModel? event;
  final String? eventId;

  const EventDetailsScreen({super.key, this.event, this.eventId});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = context.l10n;

    EventModel? currentEvent = event;
    if (currentEvent == null) {
      final id = eventId ??
          (ModalRoute.of(context)?.settings.arguments is String
              ? ModalRoute.of(context)!.settings.arguments as String
              : null);
      if (id != null) {
        currentEvent =
            context.watch<AppEventsProvider>().getEventById(id);
      } else if (ModalRoute.of(context)?.settings.arguments is EventModel) {
        currentEvent =
            ModalRoute.of(context)!.settings.arguments as EventModel;
      }
    }

    if (currentEvent == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.eventDetails)),
        body: const Center(child: Text('Event not found')),
      );
    }

    final dateStr = DateFormat('dd MMMM yyyy').format(currentEvent.dateTime);
    final timeStr = DateFormat('hh:mm a').format(currentEvent.dateTime);

    return Scaffold(
      backgroundColor:
          isDark ? AppColor.backgroundDark : AppColor.backgroundLight,
      appBar: AppBar(
        title: Text(l10n.eventDetails, style: AppStyle.bold20),
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
              Navigator.pushNamed(context, AppRoutes.editEvent,
                  arguments: currentEvent);
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
                  title: Text(l10n.deleteConfirmTitle),
                  content: Text(l10n.deleteConfirmMsg),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogCtx),
                      child: Text(l10n.cancel),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.dangerRed,
                      ),
                      onPressed: () async {
                        Navigator.pop(dialogCtx);
                        await context
                            .read<AppEventsProvider>()
                            .deleteEvent(currentEvent!.id);
                        if (context.mounted) {
                          Navigator.maybePop(context);
                        }
                      },
                      child: Text(
                        l10n.delete,
                        style: const TextStyle(color: AppColor.white),
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
                currentEvent.imagePath,
                height: 203,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              currentEvent.title,
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
                      currentEvent.location,
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
            Text(l10n.description, style: AppStyle.bold16),
            const SizedBox(height: 8),
            Text(
              currentEvent.description,
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
