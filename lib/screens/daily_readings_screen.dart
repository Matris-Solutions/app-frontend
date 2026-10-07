import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/liturgical_service.dart';

class DailyReadingsScreen extends StatelessWidget {
  const DailyReadingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Readings'),
      ),
      body: ListenableBuilder(
        listenable: LiturgicalService(),
        builder: (context, _) {
          final service = LiturgicalService();
          if (service.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (service.dailyReadings.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Unable to load readings for today. Please check your internet connection.',
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              Text(todayDate, style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text(service.liturgyTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              const Divider(height: 40, thickness: 1),
              
              ...service.dailyReadings.map((reading) => _ReadingSection(
                title: reading.title,
                citation: reading.citation,
                text: reading.text,
              )),
            ],
          );
        }
      ),
    );
  }
}

class _ReadingSection extends StatelessWidget {
  final String title;
  final String citation;
  final String text;

  const _ReadingSection({required this.title, required this.citation, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(citation, style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey)),
          const SizedBox(height: 12),
          Text(text, style: const TextStyle(fontSize: 16, height: 1.6)),
        ],
      ),
    );
  }
}