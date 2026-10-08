import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/liturgical_service.dart';
import '../liturgical_theme.dart';

class DailyReadingsScreen extends StatelessWidget {
  const DailyReadingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by App Shell
      body: ListenableBuilder(
        listenable: LiturgicalService(),
        builder: (context, _) {
          final service = LiturgicalService();
          if (service.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: service.primaryColor),
                  const SizedBox(height: 16),
                  const Text(
                    'Loading daily readings...',
                    style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          }
          
          if (service.dailyReadings.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Unable to load readings for today. Please check your internet connection.',
                  style: TextStyle(color: service.primaryColor, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(22, 50, 22, 118), // Top padding for safe area, bottom for nav bar
            children: [
              Text(
                'DAILY READINGS',
                style: TextStyle(
                  color: service.primaryColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                todayDate, 
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22), 
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                service.liturgyTitle, 
                style: const TextStyle(fontSize: 14, color: AppColors.muted), 
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              
              for (int i = 0; i < service.dailyReadings.length; i++) ...[
                _ReadingSection(
                  title: service.dailyReadings[i].title,
                  citation: service.dailyReadings[i].citation,
                  text: service.dailyReadings[i].text,
                  primaryColorDark: service.darkColor,
                ),
                if (i < service.dailyReadings.length - 1)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.0),
                    child: Divider(color: AppColors.line, thickness: 1),
                  )
                else
                  const SizedBox(height: 10),
              ],

              // Copyright Text
              const SizedBox(height: 20),
              const Divider(color: AppColors.line),
              const SizedBox(height: 20),
              const Text(
                'The English translation of the Psalm Responses from Lectionary for Mass © 1969, 1981, 1997, International Commission on English in the Liturgy Corporation. All rights reserved.\n\nLectionary for Mass for Use in the Dioceses of the United States, second typical edition, Copyright © 2001, 1998, 1997, 1986, 1970 Confraternity of Christian Doctrine; Psalm refrain © 1968, 1981, 1997, International Committee on English in the Liturgy, Inc. All rights reserved. Neither this work nor any part of it may be reproduced, distributed, performed or displayed in any medium, including electronic or digital, without permission in writing from the copyright owner.',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.muted,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
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
  final Color primaryColorDark;

  const _ReadingSection({
    required this.title, 
    required this.citation, 
    required this.text,
    required this.primaryColorDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(), 
          style: TextStyle(
            fontSize: 12, 
            color: primaryColorDark, 
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        if (citation.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            citation, 
            style: const TextStyle(
              fontSize: 14, 
              fontFamily: 'Newsreader', 
              fontStyle: FontStyle.italic, 
              color: AppColors.muted,
            ),
          ),
        ],
        const SizedBox(height: 12),
        Text(
          text, 
          style: const TextStyle(
            fontFamily: 'Newsreader',
            fontSize: 18, 
            height: 1.6,
            color: AppColors.ink,
          ),
          softWrap: true,
        ),
      ],
    );
  }
}
