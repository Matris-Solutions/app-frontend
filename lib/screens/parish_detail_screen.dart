import 'dart:ui';
import 'package:flutter/material.dart';
import '../liturgical_theme.dart';
import '../models/parish_model.dart';
import '../models/mass_time_model.dart';
import '../services/parish_service.dart';
import '../services/auth_service.dart';
import 'auth_screen.dart';

class ParishDetailScreen extends StatelessWidget {
  final ParishModel? parish;

  const ParishDetailScreen({super.key, this.parish});

  @override
  Widget build(BuildContext context) {
    final String title = parish?.name ?? "Unknown Parish";
    final String address = parish?.formattedAddress ?? 'No address provided';
    final String? phone = parish?.phone;
    final String imageUrl = (parish?.imageUrl != null && parish!.imageUrl!.isNotEmpty)
        ? parish!.imageUrl!
        : 'https://images.unsplash.com/photo-1762967020958-6b2118ef93b3?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=85&w=1080';
    final String subtitleLabel = (parish?.diocese != null && parish!.diocese!.isNotEmpty)
        ? parish!.diocese!.toUpperCase()
        : 'WELCOME HOME';

    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 105),
        children: [
          // Hero Image Header
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.34 < 250
                ? 250
                : MediaQuery.of(context).size.height * 0.34,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.greenPale,
                    child: const Center(
                      child: Icon(Icons.church, size: 64, color: AppColors.green),
                    ),
                  ),
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
                        color: Color(0xEBFFFFFF),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x14203527),
                            blurRadius: 28,
                            offset: Offset(0, 8),
                          ),
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
                        color: const Color(0xE64A7C59),
                        child: Text(
                          subtitleLabel,
                          style: const TextStyle(
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

          // Body Details
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
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
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(fontSize: 28),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: AppColors.greenPale,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.church, color: AppColors.green, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 17),
                _buildContactRow(Icons.location_on_outlined, address),
                if (phone != null && phone.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _buildContactRow(Icons.phone_outlined, phone),
                ],
                if (parish?.email != null && parish!.email!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _buildContactRow(Icons.email_outlined, parish!.email!),
                ],
                if (parish?.website != null && parish!.website!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _buildContactRow(Icons.language_outlined, parish!.website!),
                ],
                if (parish?.parishPriestName != null && parish!.parishPriestName!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _buildContactRow(Icons.person_outline, 'Pastor: ${parish!.parishPriestName!}'),
                ],

                if (parish != null) ...[
                  const SizedBox(height: 16),
                  _buildHomeParishButton(context, parish!),
                ],

                const SizedBox(height: 16),
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

                // Activities Tags Section
                if (parish != null && parish!.activities.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text('Ministries & Activities', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: parish!.activities.map((act) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.greenPale,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.green.withOpacity(0.2)),
                        ),
                        child: Text(
                          act,
                          style: const TextStyle(
                            color: AppColors.greenDark,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],

                const SizedBox(height: 20),

                // Worship Schedule Card
                if (parish != null)
                  FutureBuilder<List<MassTimeModel>>(
                    future: ParishService().getMassTimesForParish(parish!.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: AppColors.green),
                        );
                      }
                      
                      if (snapshot.hasError) {
                        return const Text(
                          'Unable to load mass times.',
                          style: TextStyle(color: Colors.red),
                        );
                      }
                      
                      final massTimes = snapshot.data ?? [];
                      if (massTimes.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(19),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.line),
                            borderRadius: BorderRadius.circular(19),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.access_time, color: AppColors.green, size: 20),
                              SizedBox(width: 10),
                              Text(
                                'No Mass times listed for this parish yet.',
                                style: TextStyle(color: AppColors.muted, fontSize: 12),
                              ),
                            ],
                          ),
                        );
                      }

                      // Group by displayType
                      Map<String, List<MassTimeModel>> groupedTimes = {};
                      for (var mt in massTimes) {
                        groupedTimes.putIfAbsent(mt.displayType, () => []).add(mt);
                      }

                      return Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.line),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x14203527),
                              blurRadius: 28,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.church, color: AppColors.green, size: 18),
                                SizedBox(width: 10),
                                Text(
                                  'WORSHIP SCHEDULE',
                                  style: TextStyle(
                                    color: AppColors.greenDark,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),

                            ...groupedTimes.entries.map((entry) {
                              final categoryName = entry.key;
                              final categoryTimes = entry.value;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: AppColors.parchment,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: AppColors.line),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: categoryName == 'Sunday' ? AppColors.green : AppColors.gold,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              categoryName.toUpperCase(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.8,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      ...categoryTimes.map((mt) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 6),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(Icons.access_time_filled, size: 14, color: AppColors.green),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    mt.timeOnlyFormatted,
                                                    style: const TextStyle(
                                                      color: AppColors.greenDark,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    mt.dayName,
                                                    style: const TextStyle(
                                                      color: AppColors.ink,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  if (mt.language.isNotEmpty && mt.language != 'English') ...[
                                                    const Spacer(),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: AppColors.goldPale,
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: Text(
                                                        mt.language,
                                                        style: const TextStyle(color: Color(0xFF8C7144), fontSize: 9, fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                              if (mt.notes != null && mt.notes!.isNotEmpty) ...[
                                                const SizedBox(height: 3),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 22),
                                                  child: Text(
                                                    mt.notes!,
                                                    style: const TextStyle(
                                                      color: AppColors.muted,
                                                      fontSize: 12,
                                                      height: 1.3,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  ),

                // News Section
                Padding(
                  padding: const EdgeInsets.only(top: 26, bottom: 13, left: 1, right: 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Recent News', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.ink)),
                      Text('All news', style: TextStyle(color: AppColors.green, fontSize: 12, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                _buildNewsCard(
                  'JUN',
                  '22',
                  'Parish Feast Day Picnic',
                  'Join us after the 11:00 AM Mass for food, fellowship, and family activities.',
                ),
                _buildNewsCard(
                  'JUN',
                  '26',
                  'Evening of Adoration',
                  'Quiet prayer and Eucharistic adoration from 7:00–8:00 PM.',
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeParishButton(BuildContext context, ParishModel parish) {
    final authService = AuthService();
    return ListenableBuilder(
      listenable: authService,
      builder: (context, _) {
        final isHome = authService.currentProfile?.assignedParishId == parish.id;
        final isAuthenticated = authService.isAuthenticated;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              if (!isAuthenticated) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                );
                return;
              }

              try {
                await authService.updateHomeParish(parish.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isHome
                          ? '${parish.name} is set as your home parish!'
                          : 'Set ${parish.name} as your home parish!'),
                      backgroundColor: AppColors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error updating home parish: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            icon: Icon(
              isHome ? Icons.home : Icons.home_outlined,
              color: isHome ? Colors.white : AppColors.green,
              size: 18,
            ),
            label: Text(
              isHome ? 'YOUR HOME PARISH' : 'SET AS MY HOME PARISH',
              style: TextStyle(
                color: isHome ? Colors.white : AppColors.green,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isHome ? AppColors.green : AppColors.greenPale,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: isHome ? AppColors.green : AppColors.green.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.green),
        const SizedBox(width: 9),
        Expanded(
          child: Text(text, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
        ),
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
                Text(
                  day,
                  style: const TextStyle(
                    color: AppColors.green,
                    fontFamily: 'Newsreader',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Newsreader',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                  ),
                ),
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
