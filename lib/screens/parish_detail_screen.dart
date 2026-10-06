import 'dart:ui';
import 'package:flutter/material.dart';
import '../liturgical_theme.dart';

class ParishDetailScreen extends StatelessWidget {
  const ParishDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 105),
        children: [
          // Hero
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.34 < 250 ? 250 : MediaQuery.of(context).size.height * 0.34,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1762967020958-6b2118ef93b3?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=85&w=1080',
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xC70E1C13)],
                      stops: [0.18, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  top: 22 + MediaQuery.of(context).padding.top,
                  left: 19,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: Color(0xEBFFFFFF), // rgba(255, 255, 255, 0.92)
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Color(0x14203527), blurRadius: 28, offset: Offset(0, 8)),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back, color: AppColors.ink),
                    ),
                  ),
                ),
                Positioned(
                  left: 22,
                  bottom: 20,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                        color: const Color(0xE64A7C59), // rgba(74, 124, 89, 0.9)
                        child: const Text(
                          'MY HOME PARISH',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.9,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'WELCOME HOME',
                          style: TextStyle(
                            color: AppColors.green,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.3,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'St. Patrick\'s',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32),
                        ),
                      ],
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.greenPale,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: AppColors.green, size: 20), // Cross icon placeholder
                    ),
                  ],
                ),
                const SizedBox(height: 17),
                _buildContactRow(Icons.location_on_outlined, '451 Maple Avenue, Cedar Grove'),
                const SizedBox(height: 10),
                _buildContactRow(Icons.phone_outlined, '(555) 014-1888'),
                
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(Icons.directions, 'Directions', true),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: _buildActionButton(Icons.phone, 'Call office', false),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Schedule Card
                Container(
                  padding: const EdgeInsets.all(19),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.line),
                    borderRadius: BorderRadius.circular(19),
                    boxShadow: const [
                      BoxShadow(color: Color(0x14203527), blurRadius: 28, offset: Offset(0, 8)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Worship schedule', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 17),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(color: AppColors.greenPale, borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.add, color: AppColors.green, size: 19),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Sunday Mass', style: TextStyle(fontFamily: 'Newsreader', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink)),
                                const SizedBox(height: 5),
                                _buildScheduleLine('Sunday', '9:00 AM · 11:00 AM'),
                                const SizedBox(height: 5),
                                _buildScheduleLine('Saturday Vigil', '5:30 PM'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 1,
                        margin: const EdgeInsets.only(top: 15, left: 51),
                        color: AppColors.line,
                      ),
                      const SizedBox(height: 17),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(color: AppColors.goldPale, borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.access_time, color: Color(0xFF8D6B2F), size: 18),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Reconciliation', style: TextStyle(fontFamily: 'Newsreader', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink)),
                                const SizedBox(height: 5),
                                _buildScheduleLine('Saturday', '3:30–4:45 PM'),
                                const SizedBox(height: 5),
                                const Text('Or by appointment', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // News Section
                Padding(
                  padding: const EdgeInsets.only(top: 26, bottom: 13, left: 1, right: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent News', style: Theme.of(context).textTheme.titleMedium),
                      const Text('All news', style: TextStyle(color: AppColors.green, fontSize: 12, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                _buildNewsCard('JUN', '22', 'Parish Feast Day Picnic', 'Join us after the 11:00 AM Mass for food, fellowship, and family activities.'),
                _buildNewsCard('JUN', '26', 'Evening of Adoration', 'Quiet prayer and Eucharistic adoration from 7:00–8:00 PM.', isLast: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.green),
        const SizedBox(width: 9),
        Text(text, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, bool isPrimary) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.green : Colors.white,
        border: isPrimary ? null : Border.all(color: AppColors.greenPale),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: isPrimary ? Colors.white : AppColors.green),
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              color: isPrimary ? Colors.white : AppColors.green,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleLine(String day, String time) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: AppColors.muted, fontSize: 11, fontFamily: 'DM Sans'),
        children: [
          TextSpan(text: '$day ', style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.ink)),
          TextSpan(text: time),
        ],
      ),
    );
  }

  Widget _buildNewsCard(String month, String day, String title, String body, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.greenPale,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(month, style: const TextStyle(color: AppColors.green, fontSize: 8, fontWeight: FontWeight.w700)),
                Text(day, style: const TextStyle(color: AppColors.green, fontFamily: 'Newsreader', fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontFamily: 'Newsreader', fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.ink)),
                const SizedBox(height: 4),
                Text(body, style: const TextStyle(color: AppColors.muted, fontSize: 10, height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
