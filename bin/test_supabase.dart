import 'package:supabase/supabase.dart';

void main() async {
  final client = SupabaseClient(
    'https://wrpqjclzljawjelybtxq.supabase.co',
    'sb_publishable_dzsj1dBP9dKnlFlZGnZ9BA_YP_ef5TG',
  );

  final rpcNames = [
    'set_home_parish',
    'assign_parish',
    'set_parish',
    'join_parish',
    'update_user_parish',
    'update_home_parish',
    'change_assigned_parish',
    'set_assigned_parish',
  ];

  for (final name in rpcNames) {
    try {
      await client.rpc(name, params: {'p_parish_id': '00000000-0000-0000-0000-000000000000'});
      print('RPC $name exists!');
    } catch (e) {
      final msg = e.toString();
      if (!msg.contains('Could not find the function') && !msg.contains('404')) {
        print('RPC $name produced: $msg');
      }
    }
  }
}
