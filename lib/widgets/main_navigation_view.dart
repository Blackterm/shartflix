import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../modules/home/home_view.dart';
import '../modules/profile/profile_view.dart';
import 'limited_offer_bottom_sheet.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int currentIndex = 0;
  final GlobalKey<NavigatorState> profileKey = GlobalKey<NavigatorState>();
  bool hasShownBottomSheet = false;

  void _onTabChanged(int index) {
    setState(() {
      currentIndex = index;
    });

    // Show bottom sheet only when switching to profile tab for the first time
    if (index == 1 && !hasShownBottomSheet) {
      hasShownBottomSheet = true;
      _showLimitedOfferBottomSheet();
    }
  }

  void _showLimitedOfferBottomSheet() {
    // Show bottom sheet after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && currentIndex == 1) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const LimitedOfferBottomSheet(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Sayfalar
          IndexedStack(
            index: currentIndex,
            children: [
              const HomeView(), // Home içeriği (bottom navigation olmadan)
              // ProfileView'ı unique key ile her seferinde yeniden oluştur
              ProfileView(key: ValueKey('profile_$currentIndex')),
            ],
          ),
          // Sabit Bottom Navigation
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNavigation(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.8),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Anasayfa Button
          GestureDetector(
            onTap: () => _onTabChanged(0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: currentIndex == 0 ? Colors.white.withOpacity(0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'home'.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Profil Button
          GestureDetector(
            onTap: () => _onTabChanged(1),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: currentIndex == 1 ? Colors.white.withOpacity(0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'profile'.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
