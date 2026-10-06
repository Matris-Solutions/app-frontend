import 'package:flutter/material.dart';
import '../liturgical_theme.dart';
import 'parish_detail_screen.dart';

class Parish {
  final String name;
  final String address;
  final String mass;
  final String distance;
  final String image;

  Parish(this.name, this.address, this.mass, this.distance, this.image);
}

final List<Parish> parishes = [
  Parish("St. Patrick's", "451 Maple Avenue, Cedar Grove", "Today · 5:30 PM", "0.8 mi", "https://images.unsplash.com/photo-1676247675471-318c831785cd?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=85&w=1080"),
  Parish("Sacred Heart Church", "218 Willow Street, Brookfield", "Tomorrow · 7:00 AM", "2.0 mi", "https://images.unsplash.com/photo-1624573830079-7fd9ce354be5?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=85&w=1080"),
  Parish("Our Lady of Grace", "72 Chapel Lane, Fairview", "Today · 6:00 PM", "3.4 mi", "https://images.unsplash.com/photo-1613686224427-29b757c04e0d?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=85&w=1080"),
  Parish("St. Joseph Parish", "905 Garden Road, Riverside", "Sunday · 8:30 AM", "4.1 mi", "https://images.unsplash.com/photo-1615732224643-b000ac40c8b6?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&q=85&w=1080"),
];

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = parishes.where((p) => p.name.toLowerCase().contains(_query.toLowerCase())).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 26, 22, 118),
      children: [
        // Header
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'FIND YOUR COMMUNITY',
              style: TextStyle(
                color: AppColors.green,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.3,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Discover Parishes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),

        // Search Bar
        Container(
          height: 54,
          margin: const EdgeInsets.only(top: 24),
          padding: const EdgeInsets.symmetric(horizontal: 17),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14203527),
                blurRadius: 28,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 20, color: AppColors.muted),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  onChanged: (value) => setState(() => _query = value),
                  style: const TextStyle(fontSize: 13, color: AppColors.ink),
                  decoration: const InputDecoration(
                    hintText: 'Search by parish or location',
                    hintStyle: TextStyle(color: Color(0xFF909991), fontSize: 13),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Filter Row
        Padding(
          padding: const EdgeInsets.only(top: 13, bottom: 21),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Nearby', true),
                const SizedBox(width: 8),
                _buildFilterChip('Mass today', false),
                const SizedBox(width: 8),
                _buildFilterChip('Confession', false),
              ],
            ),
          ),
        ),

        // Result Label
        Padding(
          padding: const EdgeInsets.only(bottom: 11),
          child: Text(
            '${filtered.length} parishes near you',
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Parish List
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
            child: Column(
              children: [
                const Icon(Icons.church, size: 30, color: AppColors.green),
                const SizedBox(height: 10),
                Text('No parishes found', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20, color: AppColors.green)),
                const SizedBox(height: 4),
                const Text('Try another parish name or location.', style: TextStyle(color: AppColors.muted, fontSize: 12)),
              ],
            ),
          )
        else
          ...filtered.asMap().entries.map((entry) {
            final int idx = entry.key;
            final Parish parish = entry.value;
            return _buildParishCard(parish, idx == 0);
          }),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.green : Colors.white,
        border: Border.all(color: isActive ? AppColors.green : AppColors.line),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : AppColors.muted,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildParishCard(Parish parish, bool isFirst) {
    return GestureDetector(
      onTap: isFirst ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ParishDetailScreen())) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 11),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0x12203527)), // rgba(32, 53, 39, 0.07)
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0E203527), // 0.055
              blurRadius: 18,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Image.network(
                    parish.image,
                    width: 82,
                    height: 82,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              parish.name,
                              style: const TextStyle(
                                fontFamily: 'Newsreader',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.ink,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.greenPale,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: const Text(
                              'ACTIVE',
                              style: TextStyle(
                                color: AppColors.greenDark,
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        parish.address,
                        style: const TextStyle(color: AppColors.muted, fontSize: 10, height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 9),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14, color: AppColors.green),
                          const SizedBox(width: 4),
                          Text(
                            'Next Mass: ${parish.mass}',
                            style: const TextStyle(color: AppColors.green, fontSize: 9, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              right: 1,
              bottom: 1,
              child: Text(
                parish.distance,
                style: const TextStyle(color: AppColors.muted, fontSize: 9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
