import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../providers/app_events_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_images.dart';
import '../../utils/app_routes.dart';
import 'widgets/map_event_card.dart';

class MapTab extends StatelessWidget {
  const MapTab({super.key});

  @override
  Widget build(BuildContext context) {
    final events = context.watch<AppEventsProvider>().events;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppImages.mapPreview,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FloatingActionButton.small(
                  key: const Key('gps_locate_btn'),
                  onPressed: () {
                    // Center on user location action
                  },
                  backgroundColor: AppColor.primary,
                  child: SvgPicture.asset(
                    AppImages.icCompass,
                    colorFilter: const ColorFilter.mode(
                      AppColor.white,
                      BlendMode.srcIn,
                    ),
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
            ),
          ),
          if (events.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 95,
              child: SizedBox(
                height: 100,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: events.length,
                  separatorBuilder: (_, index) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return MapEventCard(
                      event: event,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.eventDetails,
                          arguments: event.id,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
