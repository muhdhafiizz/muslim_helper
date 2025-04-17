import 'package:flutter/material.dart';
import 'package:hadith_reader/core/app_color.dart';
import 'package:hadith_reader/providers/bottom_navbar_provier.dart';
import 'package:hadith_reader/screen/home_page_view.dart';
import 'package:hadith_reader/screen/profile_page_view.dart';
import 'package:hadith_reader/screen/qibla_finder_page.dart';
import 'package:hadith_reader/widgets/feature_not_ready_page.dart';
import 'package:provider/provider.dart';

class BottomNavView extends StatelessWidget {
  BottomNavView({super.key});

  final List<Widget> _screens = [
    const HomePageView(),
    const FeatureNotReadyPage(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BottomNavProvider>(context);

    return Scaffold(
      body: _screens[controller.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: controller.selectedIndex,
        onTap: controller.changeTab,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.secondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.compass_calibration_rounded), label: "Qibla"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
