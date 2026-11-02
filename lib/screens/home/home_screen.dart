import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/event_model.dart';
import '../../providers/app_events_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_style.dart';
import 'widgets/event_card.dart';
import 'widgets/home_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<EventModel> events = context.watch<AppEventsProvider>().filteredEvents;

    return Scaffold(
      backgroundColor: isDark ? AppColor.backgroundDark : AppColor.backgroundLight,
      body: Column(
        children: [
          const HomeHeader(),
          Expanded(
            child: events.isEmpty
                ? Center(
                    child: Text(
                      'No events found',
                      style: AppStyle.medium16.copyWith(
                        color: isDark ? AppColor.white : AppColor.textSecondary,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return EventCard(
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
        ],
      ),
    );
  }
}
