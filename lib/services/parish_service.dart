import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/parish_model.dart';
import '../models/mass_time_model.dart';
import '../models/event_model.dart';

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

  /// Fetches a single parish by ID.
  Future<ParishModel?> getParishById(String parishId) async {
    try {
      final response = await _client
          .from('parishes')
          .select()
          .eq('id', parishId)
          .maybeSingle();

      if (response != null) {
        return ParishModel.fromJson(response);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch parish: $e');
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

  /// Fetches all mass times for a specific parish ID.
  Future<List<MassTimeModel>> getMassTimesForParish(String parishId) async {
    try {
      final response = await _client
          .from('mass_times')
          .select()
          .eq('parish_id', parishId)
          .order('day_of_week', ascending: true, nullsFirst: false)
          .order('mass_time', ascending: true);

      final dataList = response as List<dynamic>;
      return dataList
          .map((json) => MassTimeModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch mass times: $e');
    }
  }

  /// Fetches upcoming events (either for a specific parish or globally across all parishes).
  Future<List<EventModel>> getUpcomingEvents({String? parishId}) async {
    try {
      var query = _client.from('events').select();
      if (parishId != null && parishId.isNotEmpty) {
        query = query.eq('parish_id', parishId);
      }
      
      final response = await query
          .order('start_time', ascending: true)
          .limit(5);

      final dataList = response as List<dynamic>;
      return dataList
          .map((json) => EventModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
