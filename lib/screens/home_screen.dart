import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../liturgical_theme.dart';
import '../models/event_model.dart';
import '../models/mass_time_model.dart';
import '../models/parish_model.dart';
import '../services/auth_service.dart';
import '../services/catholic_news_service.dart';
import '../services/liturgical_service.dart';
import '../services/parish_service.dart';
import 'parish_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final litService = LiturgicalService();
    final authService = AuthService();

    return ListenableBuilder(
      listenable: Listenable.merge([litService, authService]),
      builder: (context, _) {
        if (litService.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: litService.primaryColor),
                const SizedBox(height: 16),
                const Text(
                  'Loading your dashboard...',
                  style: TextStyle(color: AppColors.muted, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          );
        }

        final now = DateTime.now();
        final String todayDate = DateFormat('EEEE, MMMM d, yyyy').format(now);

        final profile = authService.currentProfile;
        final user = authService.currentUser;
        final assignedParishId = profile?.assignedParishId;

        final userName = profile?.fullName?.isNotEmpty == true
            ? profile!.fullName!.split(' ').first
            : (user?.email?.split('@').first ?? 'Friend');

        return ListView(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 118),
          children: [
            // Top App Bar
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
                  child: const Icon(Icons.notifications_none, size: 22, color: AppColors.ink),
                ),
              ],
            ),
            
            // Greeting & Date
            const SizedBox(height: 26),
            Text(
              todayDate,
              style: const TextStyle(color: AppColors.muted, fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            Text(
              'Welcome back,\n$userName.',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 22),

            // Catholic Faith Overview Card
            _buildCatholicFaithCard(context, litService),

            const SizedBox(height: 16),

            // Global Catholic World News Section
            _buildGlobalCatholicNewsSection(context, litService),

            const SizedBox(height: 20),

            // Home Parish Section or Prompt
            if (assignedParishId != null && assignedParishId.isNotEmpty)
              FutureBuilder<ParishModel?>(
                future: ParishService().getParishById(assignedParishId),
                builder: (context, snapshot) {
                  final parish = snapshot.data;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Home Church Info Card
                      _buildHomeParishInfoCard(context, parish, litService),

                      const SizedBox(height: 18),

                      // Mass Schedule Card
                      _buildMassScheduleCard(context, assignedParishId, litService),

                      const SizedBox(height: 22),

                      // Upcoming Events
                      _buildEventsSection(context, assignedParishId, litService),
                    ],
                  );
                },
              )
            else
              _buildNoHomeParishCard(context, litService),
          ],
        );
      },
    );
  }

  /// Card displaying Catholic Church Liturgical Season & Faith Information
  Widget _buildCatholicFaithCard(BuildContext context, LiturgicalService litService) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: litService.primaryColor.withValues(alpha: 0.2)),
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
            padding: const EdgeInsets.fromLTRB(22, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.auto_awesome, color: litService.primaryColor, size: 18),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'THE CATHOLIC CHURCH',
                              style: TextStyle(
                                color: litService.primaryColor,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.3,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: litService.paleColor,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        litService.liturgicalColor.toUpperCase(),
                        style: TextStyle(
                          color: litService.darkColor,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  litService.liturgyTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontFamily: 'Newsreader',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'The Catholic Church is the mystical body of Christ on Earth, united in the Eucharist, Scripture, and Holy Tradition under the Pastoral care of the Bishops and the Pope.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _buildQuickTag(Icons.menu_book_outlined, 'Daily Readings', litService),
                    const SizedBox(width: 8),
                    _buildQuickTag(Icons.church, 'Universal Church', litService),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTag(IconData icon, String label, LiturgicalService litService) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: litService.paleColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: litService.darkColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: litService.darkColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Card displaying information about the user's Home Parish
  Widget _buildHomeParishInfoCard(BuildContext context, ParishModel? parish, LiturgicalService litService) {
    if (parish == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ParishDetailScreen(parish: parish)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.line),
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
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: litService.paleColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.church, color: litService.primaryColor, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'MY HOME PARISH',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.chevron_right, size: 18, color: AppColors.muted),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        parish.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontFamily: 'Newsreader',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (parish.diocese != null && parish.diocese!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          parish.diocese!,
                          style: const TextStyle(
                            color: AppColors.green,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const Divider(color: AppColors.line, height: 26),
            _buildInfoRow(Icons.location_on_outlined, parish.formattedAddress),
            if (parish.phone != null && parish.phone!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow(Icons.phone_outlined, parish.phone!),
            ],
            if (parish.website != null && parish.website!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow(Icons.language_outlined, parish.website!),
            ],
            if (parish.parishPriestName != null && parish.parishPriestName!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow(Icons.person_outline, 'Pastor: ${parish.parishPriestName!}'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.green),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: AppColors.ink, fontSize: 12, height: 1.3),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildNoHomeParishCard(BuildContext context, LiturgicalService litService) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.line),
            boxShadow: const [
              BoxShadow(color: Color(0x14203527), blurRadius: 28, offset: Offset(0, 8)),
            ],
          ),
          child: Column(
            children: [
              Icon(Icons.church_outlined, size: 48, color: litService.primaryColor),
              const SizedBox(height: 12),
              Text(
                'Select Your Home Parish',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              const Text(
                'Connect to a local parish community to see Mass times, events, and parish contact details here on your dashboard.',
                style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.4),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildEventsSection(context, null, litService),
      ],
    );
  }

  Widget _buildMassScheduleCard(BuildContext context, String parishId, LiturgicalService litService) {
    return FutureBuilder<List<MassTimeModel>>(
      future: ParishService().getMassTimesForParish(parishId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.line),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.green),
            ),
          );
        }

        final times = snapshot.data ?? [];
        if (times.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: litService.paleColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.church_outlined, color: litService.primaryColor, size: 20),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    'No Mass times added to database yet for this parish.',
                    style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.3),
                  ),
                ),
              ],
            ),
          );
        }

        // Group mass times by displayType (e.g. Sunday, Weekday, Confession, Adoration)
        Map<String, List<MassTimeModel>> groupedTimes = {};
        for (var mt in times) {
          groupedTimes.putIfAbsent(mt.displayType, () => []).add(mt);
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12203527),
                blurRadius: 24,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: litService.paleColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.church, color: litService.primaryColor, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'MASS SCHEDULE',
                        style: TextStyle(
                          color: litService.darkColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.goldPale,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      '${times.length} ${times.length == 1 ? 'TIME' : 'TIMES'}',
                      style: const TextStyle(
                        color: Color(0xFF8C7144),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
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
                                color: categoryName == 'Sunday' ? litService.primaryColor : AppColors.gold,
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
                                    Icon(Icons.access_time_filled, size: 14, color: litService.primaryColor),
                                    const SizedBox(width: 8),
                                    Text(
                                      mt.timeOnlyFormatted,
                                      style: TextStyle(
                                        color: litService.darkColor,
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
    );
  }

  Widget _buildEventsSection(BuildContext context, String? parishId, LiturgicalService litService) {
    return FutureBuilder<List<EventModel>>(
      future: ParishService().getUpcomingEvents(parishId: parishId),
      builder: (context, snapshot) {
        final events = snapshot.data ?? [];
        if (events.isEmpty) {
          return const SizedBox.shrink();
        }

        final firstEvent = events.first;
        final dateFormatted = DateFormat('MMMM d · h:mm a').format(firstEvent.startTime);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Upcoming Events', style: Theme.of(context).textTheme.titleMedium),
                  Text('View all', style: TextStyle(color: litService.primaryColor, fontSize: 12, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
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
                        'UPCOMING EVENT',
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
                      firstEvent.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontSize: 24),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14, color: Colors.white),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            '$dateFormatted ${firstEvent.locationName != null ? "· ${firstEvent.locationName}" : ""}',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGlobalCatholicNewsSection(BuildContext context, LiturgicalService litService) {
    final newsService = CatholicNewsService();
    return FutureBuilder<List<CatholicNewsItem>>(
      future: newsService.fetchCatholicNews(),
      builder: (context, snapshot) {
        final newsList = snapshot.data ?? [];
        if (newsList.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.public, color: litService.primaryColor, size: 18),
                      const SizedBox(width: 8),
                      Text('Catholic World News', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                  Text('Vatican Feed', style: TextStyle(color: litService.primaryColor, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(
              height: 172,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: newsList.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final item = newsList[index];
                  return GestureDetector(
                    onTap: () async {
                      if (item.link.isNotEmpty) {
                        final uri = Uri.parse(item.link);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        }
                      }
                    },
                    child: Container(
                      width: 260,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.line),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: const [
                          BoxShadow(color: Color(0x0C203527), blurRadius: 16, offset: Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: litService.paleColor,
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: Text(
                                  'VATICAN NEWS',
                                  style: TextStyle(
                                    color: litService.darkColor,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.open_in_new, size: 14, color: AppColors.muted),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontFamily: 'Newsreader',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.ink,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.description,
                            style: const TextStyle(color: AppColors.muted, fontSize: 11, height: 1.3),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
