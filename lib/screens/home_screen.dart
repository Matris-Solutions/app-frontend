import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../liturgical_theme.dart';
import 'parish_detail_screen.dart';
import '../services/liturgical_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: LiturgicalService(),
      builder: (context, _) {
        final litService = LiturgicalService();
        
        if (litService.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: litService.primaryColor),
                const SizedBox(height: 16),
                const Text(
                  'Preparing your daily liturgy...',
                  style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }

        final now = DateTime.now();
        final String todayDate = DateFormat('EEEE, MMMM d').format(now);

        return ListView(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 118),
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        litService.liturgyTitle.toUpperCase(),
                        style: TextStyle(
                          color: litService.primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Parish Hub',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
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
            Text(
              todayDate,
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
            ),
            const SizedBox(height: 7),
            Text(
              'Welcome back,\nTristen.',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 22),

            // Readings Card (Dynamic Colors & Data)
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: litService.primaryColor.withValues(alpha: 0.15)),
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
                      decoration: BoxDecoration(
                        color: litService.primaryColor,
                        borderRadius: const BorderRadius.only(
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
                                    color: litService.primaryColor,
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
                              decoration: BoxDecoration(
                                color: litService.paleColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.add, color: litService.primaryColor, size: 16), // Cross icon
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        
                        // Render dynamic readings
                        ...litService.dailyReadings.asMap().entries.map((entry) {
                          int idx = entry.key;
                          var reading = entry.value;
                          bool isLast = idx == litService.dailyReadings.length - 1;
                          return _buildReading(
                            reading.title,
                            reading.citation,
                            reading.text,
                            context,
                            litService.darkColor,
                            isLast: isLast,
                          );
                        }),

                        if (litService.hasError) ...[
                          const SizedBox(height: 10),
                          const Text(
                            'Using fallback readings due to network error.',
                            style: TextStyle(color: Colors.red, fontSize: 10, fontStyle: FontStyle.italic),
                          ),
                        ],

                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              'Read full readings',
                              style: TextStyle(
                                color: litService.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Icon(Icons.chevron_right, size: 16, color: litService.primaryColor),
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
                  Text('View all', style: TextStyle(color: litService.primaryColor, fontSize: 12, fontWeight: FontWeight.w700)),
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
                        color: litService.paleColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.church, color: litService.primaryColor),
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
      },
    );
  }

  Widget _buildReading(String label, String reference, String quote, BuildContext context, Color primaryColorDark, {bool isLast = false}) {
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
                style: TextStyle(
                  color: primaryColorDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  reference,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontFamily: 'Newsreader',
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

