import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/map_screen.dart';

void main() {
  runApp(const ParishApp());
}

class ParishApp extends StatelessWidget {
  const ParishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parish Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
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
    const HomeScreen(),
    const MapScreen(),
    const Center(child: Text('Leader Dashboard (Coming Soon)', style: TextStyle(fontSize: 18))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Parishes'),
          BottomNavigationBarItem(icon: Icon(Icons.admin_panel_settings), label: 'Leader'),
        ],
      ),
    );
  }
}