// lib/services/supabase_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../models/vehicle_model.dart';
import '../models/booking_model.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._();
  factory SupabaseService() => _instance;
  SupabaseService._();

  SupabaseClient get _db => Supabase.instance.client;
  User? get authUser => _db.auth.currentUser;

  // ── AUTH ──────────────────────────────────────────────────────────────────

  /// Register with phone number (OTP-less for demo — uses phone as pseudo-email)
  Future<AppUser?> register({
    required String fullName,
    required String phone,
    required String serviceType,
    int? drivingExperience,
  }) async {
    // Use phone@smartgo.app as email for Supabase Auth
    final email    = '${phone.replaceAll(' ', '')}@smartgo.app';
    final password = 'SmartGo@${phone.substring(phone.length - 4)}';

    final res = await _db.auth.signUp(email: email, password: password);
    if (res.user == null) throw Exception('Registration failed');

    await _db.from('smartgo_users').insert({
      'id':                 res.user!.id,
      'full_name':          fullName,
      'phone':              phone,
      'service_type':       serviceType,
      'driving_experience': drivingExperience,
    });

    // If driver, add to vehicles table as available
    if (serviceType == 'driver') {
      await _db.from('vehicles').insert({
        'driver_id':     res.user!.id,
        'driver_name':   fullName,
        'driver_phone':  phone,
        'vehicle_type':  'shared_auto',
        'vehicle_number': 'AP16XX${phone.substring(phone.length - 4)}',
        'fare_per_km':   5.0,
        'is_available':  true,
        'from_location': 'Nambur',
        'to_location':   'Guntur',
      });
    }

    return getProfile(res.user!.id);
  }

  /// Login with phone number
  Future<AppUser?> login(String phone) async {
    final email    = '${phone.replaceAll(' ', '')}@smartgo.app';
    final password = 'SmartGo@${phone.substring(phone.length - 4)}';

    final res = await _db.auth.signInWithPassword(
      email: email, password: password,
    );
    if (res.user == null) throw Exception('Login failed');
    return getProfile(res.user!.id);
  }

  Future<void> signOut() => _db.auth.signOut();

  Future<AppUser?> getProfile(String uid) async {
    final data = await _db
        .from('smartgo_users')
        .select()
        .eq('id', uid)
        .maybeSingle();
    if (data == null) return null;
    return AppUser.fromJson(data);
  }

  Future<AppUser?> getCurrentUser() async {
    final u = authUser;
    if (u == null) return null;
    return getProfile(u.id);
  }

  // ── VEHICLES ──────────────────────────────────────────────────────────────

  Future<List<Vehicle>> getAvailableVehicles({
    String? from,
    String? to,
  }) async {
    dynamic q = _db
        .from('vehicles')
        .select()
        .eq('is_available', true);

    final data = await q as List<dynamic>;
    final all = data.map((e) => Vehicle.fromJson(e as Map<String, dynamic>)).toList();

    // Filter by route if provided
    if (from != null && to != null && from.isNotEmpty && to.isNotEmpty) {
      return all.where((v) =>
        v.fromLocation.toLowerCase().contains(from.toLowerCase()) ||
        v.toLocation.toLowerCase().contains(to.toLowerCase())
      ).toList();
    }
    return all;
  }

  Future<List<Vehicle>> getVehiclesByType(String vehicleType) async {
    final data = await _db
        .from('vehicles')
        .select()
        .eq('vehicle_type', vehicleType)
        .eq('is_available', true) as List<dynamic>;
    return data.map((e) => Vehicle.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> insertSampleVehicles() async {
    // Check if already seeded
    final existing = await _db.from('vehicles').select('id').limit(1) as List;
    if (existing.isNotEmpty) return;

    await _db.from('vehicles').insert([
      {'driver_id': '00000000-0000-0000-0000-000000000001', 'driver_name': 'Ramu Naidu',   'driver_phone': '9876543210', 'vehicle_type': 'bus',         'vehicle_number': 'AP16AB1234', 'fare_per_km': 3.0,  'is_available': true,  'from_location': 'Nambur',    'to_location': 'Guntur',     'distance_km': 15},
      {'driver_id': '00000000-0000-0000-0000-000000000002', 'driver_name': 'Suresh Kumar', 'driver_phone': '9876543211', 'vehicle_type': 'car',         'vehicle_number': 'AP16CD5678', 'fare_per_km': 8.0,  'is_available': true,  'from_location': 'Nambur',    'to_location': 'Guntur',     'distance_km': 15},
      {'driver_id': '00000000-0000-0000-0000-000000000003', 'driver_name': 'Venkat Rao',   'driver_phone': '9876543212', 'vehicle_type': 'bike',        'vehicle_number': 'AP16EF9012', 'fare_per_km': 4.0,  'is_available': true,  'from_location': 'Nambur',    'to_location': 'Pedakakani', 'distance_km': 5},
      {'driver_id': '00000000-0000-0000-0000-000000000004', 'driver_name': 'Krishna Reddy','driver_phone': '9876543213', 'vehicle_type': 'shared_auto', 'vehicle_number': 'AP16GH3456', 'fare_per_km': 3.0,  'is_available': true,  'from_location': 'Nambur',    'to_location': 'Guntur',     'distance_km': 15},
      {'driver_id': '00000000-0000-0000-0000-000000000005', 'driver_name': 'Prasad Babu',  'driver_phone': '9876543214', 'vehicle_type': 'bus',         'vehicle_number': 'AP16IJ7890', 'fare_per_km': 3.0,  'is_available': false, 'from_location': 'Pedakakani','to_location': 'Guntur',     'distance_km': 10},
    ]);
  }

  // ── BOOKINGS ──────────────────────────────────────────────────────────────

  Future<Booking> createBooking({
    required String userId,
    required Vehicle vehicle,
    required String fromLocation,
    required String toLocation,
    required double fare,
    required String paymentMethod,
  }) async {
    final data = await _db.from('bookings').insert({
      'user_id':        userId,
      'vehicle_id':     vehicle.id,
      'driver_name':    vehicle.driverName,
      'driver_phone':   vehicle.driverPhone,
      'vehicle_type':   vehicle.vehicleType,
      'from_location':  fromLocation,
      'to_location':    toLocation,
      'fare':           fare,
      'payment_method': paymentMethod,
      'status':         'confirmed',
    }).select().single();

    return Booking.fromJson(data);
  }

  Future<List<Booking>> getUserBookings(String userId) async {
    final data = await _db
        .from('bookings')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false) as List<dynamic>;
    return data.map((e) => Booking.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ── FEEDBACK ──────────────────────────────────────────────────────────────

  Future<void> submitFeedback({
    required String userId,
    required String message,
    required int rating,
  }) async {
    await _db.from('feedback').insert({
      'user_id': userId,
      'message': message,
      'rating':  rating,
    });
  }

  // ── SOS ───────────────────────────────────────────────────────────────────

  Future<void> sendSOS({
    required String userId,
    required String location,
    required String message,
  }) async {
    await _db.from('sos_alerts').insert({
      'user_id':  userId,
      'location': location,
      'message':  message,
      'status':   'active',
    });
  }
}
