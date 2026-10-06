import 'package:flutter/material.dart';
import '../liturgical_theme.dart';
import 'parish_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 118),
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ORDINARY TIME · WEEK XI',
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Parish Hub',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14203527),
                    blurRadius: 28,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.notifications_none, size: 22, color: AppColors.ink),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        
        // Greeting
        const SizedBox(height: 30),
        const Text(
          'Tuesday, June 17',
          style: TextStyle(color: AppColors.muted, fontSize: 13),
        ),
        const SizedBox(height: 7),
        Text(
          'Welcome back,\nTristen.',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 22),

        // Readings Card
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0x144A7C59)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14203527),
                blurRadius: 28,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 5,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 21, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DAILY READINGS',
                              style: TextStyle(
                                color: AppColors.green,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.3,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Liturgy of the Word',
                              style: Theme.of(context).textTheme.titleMedium,
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
                          child: const Icon(Icons.add, color: AppColors.green, size: 16), // Cross icon
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildReading(
                      'First Reading',
                      '2 Corinthians 8:1–9',
                      '“Though he was rich, for your sake he became poor.”',
                      context,
                    ),
                    _buildReading(
                      'Responsorial Psalm',
                      'Psalm 146:2, 5–9',
                      'Praise the Lord, my soul!',
                      context,
                    ),
                    _buildReading(
                      'Gospel',
                      'Matthew 5:43–48',
                      '“Love your enemies and pray for those who persecute you.”',
                      context,
                      isLast: true,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        Text(
                          'Read full readings',
                          style: TextStyle(
                            color: AppColors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 3),
                        Icon(Icons.chevron_right, size: 16, color: AppColors.green),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Section row
        Padding(
          padding: const EdgeInsets.only(top: 28, bottom: 13, left: 1, right: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Around the parish', style: Theme.of(context).textTheme.titleMedium),
              const Text('View all', style: TextStyle(color: AppColors.green, fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
        ),

        // Event Card
        Container(
          height: 192,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14203527),
                blurRadius: 28,
                offset: Offset(0, 8),
              ),
            ],
            image: const DecorationImage(
              image: NetworkImage('https://images.unsplash.com/photo-1464207687429-7505649dae38?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=85&w=1080'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xC70E1C13)],
                stops: [0.18, 1.0],
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.gold,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: const Text(
                    'REGISTRATION OPEN',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.9,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Youth Retreat',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontSize: 26),
                ),
                const SizedBox(height: 2),
                Row(
                  children: const [
                    Icon(Icons.calendar_today, size: 15, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      'July 18–20 · Camp St. Francis',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Church Tile
        const SizedBox(height: 14),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ParishDetailScreen()));
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.greenPale,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.church, color: AppColors.green),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MY HOME CHURCH',
                        style: TextStyle(
                          color: AppColors.gold,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.9,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'St. Patrick\'s',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontFamily: 'Newsreader',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Sunday Mass · 9:00 AM',
                        style: TextStyle(color: AppColors.muted, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, size: 19, color: AppColors.ink),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReading(String label, String reference, String quote, BuildContext context, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.only(top: 14, bottom: 12),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.greenDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                reference,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontFamily: 'Newsreader',
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            quote,
            style: const TextStyle(
              fontFamily: 'Newsreader',
              fontSize: 16,
              height: 1.4,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
