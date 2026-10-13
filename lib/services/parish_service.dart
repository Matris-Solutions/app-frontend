import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/parish_model.dart';

class ParishService {
  final SupabaseClient _client;

  ParishService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Fetches all active parishes ordered by name.
  Future<List<ParishModel>> getAllParishes() async {
    try {
      final response = await _client
          .from('parishes')
          .select()
          .eq('is_active', true)
          .order('name', ascending: true);

      final dataList = response as List<dynamic>;
      return dataList
          .map((json) => ParishModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch parishes: $e');
    }
  }

  /// Searches active parishes by name, city, or province using Supabase text search filters.
  Future<List<ParishModel>> searchParishes(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      return getAllParishes();
    }

    try {
      final response = await _client
          .from('parishes')
          .select()
          .eq('is_active', true)
          .or('name.ilike.%$cleanQuery%,city.ilike.%$cleanQuery%,province.ilike.%$cleanQuery%')
          .order('name', ascending: true);

      final dataList = response as List<dynamic>;
      return dataList
          .map((json) => ParishModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to search parishes: $e');
    }
  }
}
