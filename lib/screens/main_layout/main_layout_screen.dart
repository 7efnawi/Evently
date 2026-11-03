import 'package:flutter/material.dart';
import '../../utils/app_color.dart';
import '../../utils/app_routes.dart';
import '../favorites/favorites_tab.dart';
import '../home/home_screen.dart';
import '../map/map_tab.dart';
import '../profile/profile_tab.dart';
import 'widgets/custom_bottom_nav_bar.dart';

class MainLayoutScreen extends StatefulWidget {
  const MainLayoutScreen({super.key});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    HomeScreen(),
    MapTab(),
    FavoritesTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.createEvent);
        },
        backgroundColor: AppColor.primary,
        elevation: 4,
        shape: const CircleBorder(
          side: BorderSide(color: AppColor.white, width: 4),
        ),
        child: const Icon(Icons.add, color: AppColor.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _currentIndex,
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
