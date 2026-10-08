import 'dart:ui';
import 'package:flutter/material.dart';
import 'liturgical_theme.dart';
import 'screens/home_screen.dart';
import 'screens/parish_list_screen.dart';
import 'screens/map_screen.dart';
import 'screens/profile_screen.dart';

import 'screens/daily_readings_screen.dart';

import 'services/liturgical_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final litService = LiturgicalService();
  await litService.fetchDashboardData();
  
  runApp(const ParishHubApp());
}

class ParishHubApp extends StatelessWidget {
  const ParishHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LiturgicalService(),
      builder: (context, _) {
        return MaterialApp(
          title: 'Parish Hub',
          theme: ParishTheme.getTheme(LiturgicalService().primaryColor),
          debugShowCheckedModeBanner: false,
          home: const MainNavigator(),
        );
      },
    );
  }
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const DailyReadingsScreen(),
    const DirectoryScreen(),
    const MapScreen(),
    const MemberProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LiturgicalService(),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
        children: [
          // Background Gradient matching App Shell
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.6, -0.8), // 20% 10%
                  radius: 0.6, // roughly 30%
                  colors: [
                    LiturgicalService().primaryColor.withValues(alpha: 0.13),
                    AppColors.parchment,
                  ],
                ),
              ),
            ),
          ),
          
          // Current Screen
          SafeArea(
            bottom: false,
            child: _screens[_currentIndex],
          ),
          
          // Custom Bottom Navigation Bar
          Positioned(
            left: 14,
            right: 14,
            bottom: 12 + MediaQuery.of(context).padding.bottom,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: Container(
                  height: 74,
                  padding: const EdgeInsets.only(top: 8, bottom: 7, left: 8, right: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.96),
                    borderRadius: BorderRadius.circular(23),
                    border: Border.all(color: LiturgicalService().darkColor.withValues(alpha: 0.09)),
                    boxShadow: [
                      BoxShadow(
                        color: LiturgicalService().darkColor.withValues(alpha: 0.16),
                        blurRadius: 34,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildNavItem(0, 'Home', Icons.home_outlined, Icons.home),
                      _buildNavItem(1, 'Readings', Icons.menu_book_outlined, Icons.menu_book),
                      _buildNavItem(2, 'Parishes', Icons.church_outlined, Icons.church),
                      _buildNavItem(3, 'Map', Icons.map_outlined, Icons.map),
                      _buildNavItem(4, 'Profile', Icons.person_outline, Icons.person),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
      },
    );
  }

  Widget _buildNavItem(int index, String label, IconData iconData, IconData activeIconData) {
    final bool isActive = _currentIndex == index;
    final litService = LiturgicalService();
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 35,
            height: 30,
            decoration: BoxDecoration(
              color: isActive ? litService.paleColor : Colors.transparent,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              isActive ? activeIconData : iconData,
              color: isActive ? litService.darkColor : const Color(0xFF8B958E),
              size: 21,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: isActive ? litService.darkColor : const Color(0xFF8B958E),
            ),
          ),
        ],
      ),
    );
  }
}
