import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  final SupabaseClient _client = Supabase.instance.client;

  User? _currentUser;
  ProfileModel? _currentProfile;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  ProfileModel? get currentProfile => _currentProfile;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;

  AuthService._internal() {
    _currentUser = _client.auth.currentUser;
    if (_currentUser != null) {
      fetchProfile();
    }
    
    _client.auth.onAuthStateChange.listen((data) {
      _currentUser = data.session?.user;
      if (_currentUser != null) {
        fetchProfile();
      } else {
        _currentProfile = null;
        notifyListeners();
      }
    });
  }

  Future<void> fetchProfile() async {
    if (_currentUser == null) return;
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', _currentUser!.id)
          .maybeSingle();

      if (response != null) {
        _currentProfile = ProfileModel.fromJson(
          response,
          userMetadata: _currentUser!.userMetadata,
        );
      } else {
        // Create profile if missing
        _currentProfile = ProfileModel(
          id: _currentUser!.id,
          email: _currentUser!.email,
          fullName: _currentUser!.userMetadata?['full_name']?.toString(),
          phone: _currentUser!.userMetadata?['phone']?.toString(),
          assignedParishId: _currentUser!.userMetadata?['assigned_parish_id']?.toString(),
        );
        try {
          await _client.from('profiles').upsert(_currentProfile!.toJson());
        } catch (e) {
          debugPrint('Profile auto-creation handled: $e');
        }
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    String? fullName,
    String? phone,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final AuthResponse res = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          if (fullName != null && fullName.isNotEmpty) 'full_name': fullName,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
        },
      );

      final user = res.user;
      final session = res.session;

      if (user != null) {
        final profile = ProfileModel(
          id: user.id,
          fullName: fullName,
          email: email,
          phone: phone,
          role: 'regular_user',
        );

        _currentUser = user;
        _currentProfile = profile;

        if (session != null) {
          try {
            await _client.from('profiles').upsert(profile.toJson());
          } catch (e) {
            debugPrint('Note: Profile creation saved in metadata / trigger: $e');
          }
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final AuthResponse res = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      _currentUser = res.user;
      if (_currentUser != null) {
        await fetchProfile();
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateHomeParish(String parishId) async {
    if (_currentUser == null) {
      throw Exception('You must be signed in to select a home parish.');
    }

    try {
      // 1. Try updating the database table `profiles`
      await _client.from('profiles').update({
        'assigned_parish_id': parishId,
      }).eq('id', _currentUser!.id);
    } catch (e) {
      debugPrint('Database profile update rejected by trigger, falling back to user_metadata: $e');
      // 2. Fallback to Supabase Auth user_metadata if database trigger prevents updating profiles table
      await _client.auth.updateUser(
        UserAttributes(data: {'assigned_parish_id': parishId}),
      );
    }

    if (_currentProfile != null) {
      _currentProfile = ProfileModel(
        id: _currentProfile!.id,
        fullName: _currentProfile!.fullName,
        email: _currentProfile!.email,
        phone: _currentProfile!.phone,
        role: _currentProfile!.role,
        assignedParishId: parishId,
      );
    } else {
      await fetchProfile();
    }
    notifyListeners();
  }

  Future<void> updateProfileInfo({String? fullName, String? phone}) async {
    if (_currentUser == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      await _client.auth.updateUser(
        UserAttributes(
          data: {
            if (fullName != null) 'full_name': fullName,
            if (phone != null) 'phone': phone,
          },
        ),
      );

      try {
        await _client.from('profiles').update({
          if (fullName != null) 'full_name': fullName,
          if (phone != null) 'phone': phone,
        }).eq('id', _currentUser!.id);
      } catch (e) {
        debugPrint('Profile table update rejected: $e');
      }

      await fetchProfile();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePassword(String newPassword) async {
    if (_currentUser == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _client.auth.resetPasswordForEmail(
        email.trim(),
      );
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _client.auth.signOut();
      _currentUser = null;
      _currentProfile = null;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
