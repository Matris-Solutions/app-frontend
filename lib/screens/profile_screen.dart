import 'package:flutter/material.dart';
import '../liturgical_theme.dart';
import 'parish_detail_screen.dart';

class MemberProfileScreen extends StatelessWidget {
  const MemberProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 118),
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'YOUR ACCOUNT',
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Profile',
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
                  BoxShadow(color: Color(0x14203527), blurRadius: 28, offset: Offset(0, 8)),
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

        // Member Identity
        Padding(
          padding: const EdgeInsets.only(top: 24, bottom: 20),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: const [
                        BoxShadow(color: Color(0x3328553A), blurRadius: 24, offset: Offset(0, 8)),
                      ],
                      gradient: const RadialGradient(
                        center: Alignment(-0.3, -0.44),
                        radius: 0.28,
                        colors: [Color(0x2EFFFFFF), AppColors.green],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'TM',
                      style: TextStyle(fontFamily: 'Newsreader', fontSize: 27, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                  Positioned(
                    right: 3,
                    bottom: 5,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.parchment, width: 3),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              const Text('Tristen Murphy', style: TextStyle(fontFamily: 'Newsreader', fontSize: 27, fontWeight: FontWeight.w600, color: AppColors.ink)),
              const SizedBox(height: 3),
              const Text('tristen.murphy@example.com', style: TextStyle(color: AppColors.muted, fontSize: 11)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.greenPale,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Text(
                  'PARISH MEMBER',
                  style: TextStyle(
                    color: AppColors.greenDark,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Faith Summary
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(17),
            boxShadow: const [BoxShadow(color: Color(0x14203527), blurRadius: 28, offset: Offset(0, 8))],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: const [
                    Text('12', style: TextStyle(color: AppColors.greenDark, fontFamily: 'Newsreader', fontSize: 21, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text('Saved events', style: TextStyle(color: AppColors.muted, fontSize: 8)),
                  ],
                ),
              ),
              Container(width: 1, height: 30, color: AppColors.line),
              Expanded(
                child: Column(
                  children: const [
                    Text('4', style: TextStyle(color: AppColors.greenDark, fontFamily: 'Newsreader', fontSize: 21, fontWeight: FontWeight.bold)),
                    SizedBox(height: 2),
                    Text('Ministries', style: TextStyle(color: AppColors.muted, fontSize: 8)),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Home Parish Card
        const SizedBox(height: 14),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ParishDetailScreen())),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1676247675471-318c831785cd?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=85&w=1080',
                    width: 58,
                    height: 58,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MY HOME PARISH',
                        style: TextStyle(color: AppColors.gold, fontSize: 8, fontWeight: FontWeight.w700, letterSpacing: 0.8),
                      ),
                      const SizedBox(height: 2),
                      const Text('St. Patrick\'s', style: TextStyle(fontFamily: 'Newsreader', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink)),
                      const SizedBox(height: 3),
                      Row(
                        children: const [
                          Icon(Icons.location_on, size: 13, color: AppColors.muted),
                          SizedBox(width: 3),
                          Text('Cedar Grove · 0.8 mi', style: TextStyle(color: AppColors.muted, fontSize: 9)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, size: 19, color: AppColors.ink),
              ],
            ),
          ),
        ),

        // My Parish Hub Section
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.only(left: 2, bottom: 9),
          child: Text('My Parish Hub', style: TextStyle(fontFamily: 'Newsreader', fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.ink)),
        ),
        _buildMenuSection([
          _MenuItem(Icons.calendar_today, 'My events', 'Registrations and saved events', false, badgeText: '3'),
          _MenuItem(Icons.church, 'My ministries', 'Groups, schedules, and service', true),
        ]),

        // Account Section
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.only(left: 2, bottom: 9),
          child: Text('Account', style: TextStyle(fontFamily: 'Newsreader', fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.ink)),
        ),
        _buildMenuSection([
          _MenuItem(Icons.person_outline, 'Personal information', 'Name, email, phone, and address', false),
          _MenuItem(Icons.notifications_none, 'Notifications', 'Mass reminders, news, and events', false),
        ]),

        // Support Section
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.only(left: 2, bottom: 9),
          child: Text('Support', style: TextStyle(fontFamily: 'Newsreader', fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.ink)),
        ),
        _buildMenuSection([
          _MenuItem(Icons.lock_outline, 'Privacy & security', 'Password and data preferences', false),
        ]),

        // Sign Out Button
        const SizedBox(height: 22),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF9F6),
            border: Border.all(color: const Color(0xFFEAD8D1)),
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: const Text(
            'Sign out',
            style: TextStyle(color: Color(0xFF9A4B3B), fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ),
        
        const SizedBox(height: 13),
        const Text(
          'Parish Hub · Version 1.0.0',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF9AA19C), fontSize: 8),
        ),
      ],
    );
  }

  Widget _buildMenuSection(List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Color(0x0B203527), blurRadius: 18, offset: Offset(0, 5))],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final int idx = entry.key;
          final _MenuItem item = entry.value;
          return Column(
            children: [
              if (idx > 0) Container(height: 1, color: AppColors.line),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 37,
                      height: 37,
                      decoration: BoxDecoration(
                        color: item.isGold ? AppColors.goldPale : AppColors.greenPale,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(item.icon, size: 19, color: item.isGold ? const Color(0xFF8D6B2F) : AppColors.green),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.ink)),
                          const SizedBox(height: 2),
                          Text(item.subtitle, style: const TextStyle(color: AppColors.muted, fontSize: 9), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    if (item.badgeText != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(item.badgeText!, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 8),
                    ],
                    const Icon(Icons.chevron_right, size: 17, color: AppColors.ink),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isGold;
  final String? badgeText;

  _MenuItem(this.icon, this.title, this.subtitle, this.isGold, {this.badgeText});
}
