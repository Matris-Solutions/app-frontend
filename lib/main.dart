import 'package:flutter/material.dart';
import 'liturgical_theme.dart';
import 'screens/home_screen.dart';
import 'screens/parish_list_screen.dart';
import 'screens/map_screen.dart';

void main() {
  runApp(const ParishHubApp());
}

class ParishHubApp extends StatelessWidget {
  const ParishHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parish Hub',
      theme: ParishTheme.getTheme(DateTime.now()),
      debugShowCheckedModeBanner: false,
      home: const MainNavigator(),
    );
  }
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State {
  int _currentIndex = 0;

  final List _screens = [
    const DashboardScreen(),
    const ParishListScreen(),
    const MapScreen(),
    const Center(child: Text('Profile Screen Pending')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.church), label: 'Parishes'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}