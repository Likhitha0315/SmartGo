// lib/services/auth_provider.dart

import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import 'supabase_service.dart';

class AuthProvider extends ChangeNotifier {
  final _svc = SupabaseService();

  AppUser? _user;
  bool _loading = false;
  String? _error;

  AppUser? get user    => _user;
  bool    get loading  => _loading;
  String? get error    => _error;
  bool    get isAuthed => _user != null;

  void _busy(bool v)        { _loading = v; notifyListeners(); }
  void _fail(dynamic e)     { _error = _parseErr(e); notifyListeners(); }
  void clearError()         { _error = null; notifyListeners(); }

  Future<bool> init() async {
    _busy(true);
    try {
      _user = await _svc.getCurrentUser();
      return _user != null;
    } catch (_) { return false; }
    finally { _busy(false); }
  }

  Future<bool> login(String phone) async {
    if (phone.trim().length < 10) {
      _error = 'Enter a valid 10-digit phone number';
      notifyListeners();
      return false;
    }
    _busy(true); _error = null;
    try {
      _user = await _svc.login(phone.trim());
      notifyListeners();
      return true;
    } catch (e) { _fail(e); return false; }
    finally { _busy(false); }
  }

  Future<bool> register({
    required String fullName,
    required String phone,
    required String serviceType,
    int? drivingExperience,
  }) async {
    _busy(true); _error = null;
    try {
      _user = await _svc.register(
        fullName: fullName,
        phone: phone.trim(),
        serviceType: serviceType,
        drivingExperience: drivingExperience,
      );
      notifyListeners();
      return true;
    } catch (e) { _fail(e); return false; }
    finally { _busy(false); }
  }

  Future<void> signOut() async {
    _busy(true);
    try { await _svc.signOut(); _user = null; notifyListeners(); }
    finally { _busy(false); }
  }

  String _parseErr(dynamic e) {
    final s = e.toString().toLowerCase();
    if (s.contains('user already registered') || s.contains('already exists'))
      return 'Phone already registered. Please login.';
    if (s.contains('invalid login') || s.contains('invalid credentials'))
      return 'Phone number not registered. Please sign up.';
    if (s.contains('network') || s.contains('socket'))
      return 'No internet connection. Check your network.';
    return 'Something went wrong. Please try again.';
  }
}
