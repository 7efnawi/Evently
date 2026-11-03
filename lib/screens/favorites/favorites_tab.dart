import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../providers/app_events_provider.dart';
import '../../utils/app_color.dart';
import '../../utils/app_images.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_style.dart';
import '../home/widgets/event_card.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allFavorites = context.watch<AppEventsProvider>().favoriteEvents;

    final displayedFavorites = _searchQuery.isEmpty
        ? allFavorites
        : allFavorites
            .where((event) =>
                event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                event.description
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      backgroundColor:
          isDark ? AppColor.backgroundDark : AppColor.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColor.primary, width: 1.5),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.trim();
                    });
                  },
                  style: AppStyle.bold14.copyWith(
                    color: isDark ? AppColor.white : AppColor.textBaseDark,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search for Event',
                    hintStyle:
                        AppStyle.bold14.copyWith(color: AppColor.primary),
                    prefixIcon: SvgPicture.asset(
                      AppImages.icSearch,
                      width: 22,
                      height: 22,
                      fit: BoxFit.scaleDown,
                      colorFilter: const ColorFilter.mode(
                        AppColor.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear,
                                color: AppColor.primary),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: allFavorites.isEmpty
                    ? Center(
                        child: Text(
                          'No favorite events yet',
                          style: AppStyle.medium16.copyWith(
                            color: isDark
                                ? AppColor.white
                                : AppColor.textSecondary,
                          ),
                        ),
                      )
                    : displayedFavorites.isEmpty
                        ? Center(
                            child: Text(
                              'No events match your search',
                              style: AppStyle.medium16.copyWith(
                                color: isDark
                                    ? AppColor.white
                                    : AppColor.textSecondary,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: displayedFavorites.length,
                            itemBuilder: (context, index) {
                              final event = displayedFavorites[index];
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
        ),
      ),
    );
  }
}
