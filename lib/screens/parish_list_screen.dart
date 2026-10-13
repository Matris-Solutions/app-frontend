import 'package:flutter/material.dart';
import '../liturgical_theme.dart';
import '../models/parish_model.dart';
import '../services/parish_service.dart';
import 'parish_detail_screen.dart';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  final ParishService _parishService = ParishService();
  String _query = '';
  late Future<List<ParishModel>> _parishesFuture;

  @override
  void initState() {
    super.initState();
    _parishesFuture = _parishService.getAllParishes();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _query = value;
      _parishesFuture = _parishService.searchParishes(_query);
    });
  }

  void _refreshParishes() {
    setState(() {
      _parishesFuture = _parishService.searchParishes(_query);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  onChanged: _onSearchChanged,
                  style: const TextStyle(fontSize: 13, color: AppColors.ink),
                  decoration: const InputDecoration(
                    hintText: 'Search by parish or location',
                    hintStyle: TextStyle(color: Color(0xFF909991), fontSize: 13),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
              if (_query.isNotEmpty)
                GestureDetector(
                  onTap: () => _onSearchChanged(''),
                  child: const Icon(Icons.close, size: 18, color: AppColors.muted),
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

        // Supabase FutureBuilder Data Presentation
        FutureBuilder<List<ParishModel>>(
          future: _parishesFuture,
          builder: (context, snapshot) {
            // Loading State
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.green),
                ),
              );
            }

            // Error State
            if (snapshot.hasError) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                child: Column(
                  children: [
                    const Icon(Icons.error_outline, size: 36, color: Colors.redAccent),
                    const SizedBox(height: 10),
                    Text(
                      'Error loading parishes',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 18,
                            color: Colors.redAccent,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _refreshParishes,
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            final parishes = snapshot.data ?? [];

            // Empty State
            if (parishes.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
                child: Column(
                  children: [
                    const Icon(Icons.church, size: 36, color: AppColors.green),
                    const SizedBox(height: 10),
                    Text(
                      'No parishes found',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 20,
                            color: AppColors.green,
                          ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Try another parish name or location.',
                      style: TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              );
            }

            // Success State - Parishes List
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 11),
                  child: Text(
                    '${parishes.length} ${parishes.length == 1 ? 'parish' : 'parishes'} found',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ...parishes.map((parish) => _buildParishCard(parish)),
              ],
            );
          },
        ),
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

  Widget _buildParishCard(ParishModel parish) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ParishDetailScreen(parish: parish),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 11),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0x12203527)),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0E203527),
              blurRadius: 18,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: parish.imageUrl != null && parish.imageUrl!.isNotEmpty
                  ? Image.network(
                      parish.imageUrl!,
                      width: 82,
                      height: 82,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
                    )
                  : _buildFallbackImage(),
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
                      if (parish.isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
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
                    parish.formattedAddress,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 10,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (parish.diocese != null && parish.diocese!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      parish.diocese!,
                      style: const TextStyle(
                        color: AppColors.green,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      width: 82,
      height: 82,
      color: AppColors.greenPale,
      child: const Icon(
        Icons.church,
        color: AppColors.green,
        size: 32,
      ),
    );
  }
}
