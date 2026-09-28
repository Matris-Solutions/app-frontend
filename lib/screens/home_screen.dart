import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Welcome back', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Home Church', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('St. Patrick\'s Parish', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Next Mass: Sunday, 9:00 AM', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Today\'s Readings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300)
            ),
            child: const Text(
              '"The Lord is my shepherd, I lack nothing. He makes me lie down in green pastures..."\n\nPsalm 23:1-2',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}