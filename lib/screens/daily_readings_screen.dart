import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyReadingsScreen extends StatelessWidget {
  const DailyReadingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Readings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Text(todayDate, style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 10),
          const Text('Liturgy of the Word', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const Divider(height: 40, thickness: 1),
          
          _ReadingSection(
            title: 'First Reading',
            citation: 'Isaiah 55:10-11',
            text: 'Thus says the LORD:\nJust as from the heavens the rain and snow come down and do not return there till they have watered the earth, making it fertile and fruitful... so shall my word be that goes forth from my mouth; my word shall not return to me void, but shall do my will, achieving the end for which I sent it.',
          ),
          
          _ReadingSection(
            title: 'Responsorial Psalm',
            citation: 'Psalm 34:4-5, 6-7, 16-17, 18-19',
            text: 'R. (18b) The Lord delivers the just from all their distress.\n\nGlorify the LORD with me, let us together extol his name. I sought the LORD, and he answered me and delivered me from all my fears.',
          ),
          
          _ReadingSection(
            title: 'Gospel',
            citation: 'Matthew 6:7-15',
            text: 'Jesus said to his disciples:\n"In praying, do not babble like the pagans, who think that they will be heard because of their many words. Do not be like them. Your Father knows what you need before you ask him. This is how you are to pray:\n\nOur Father who art in heaven, hallowed be thy name..."',
          ),
        ],
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