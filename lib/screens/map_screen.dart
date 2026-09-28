import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parish Locator'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map_outlined, size: 100, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            const Text(
              'Map Integration Pending', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
          ],
        ),
      ),
    );
  }
}