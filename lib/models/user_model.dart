// lib/models/user_model.dart

class AppUser {
  final String id;
  final String fullName;
  final String phone;
  final String serviceType; // 'passenger' | 'driver'
  final int? drivingExperience;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.serviceType,
    this.drivingExperience,
    required this.createdAt,
  });

  bool get isDriver => serviceType == 'driver';
  String get firstName => fullName.split(' ').first;

  factory AppUser.fromJson(Map<String, dynamic> j) => AppUser(
    id: j['id'] as String,
    fullName: j['full_name'] as String? ?? '',
    phone: j['phone'] as String? ?? '',
    serviceType: j['service_type'] as String? ?? 'passenger',
    drivingExperience: j['driving_experience'] as int?,
    createdAt: DateTime.parse(
      j['created_at'] as String? ?? DateTime.now().toIso8601String(),
    ),
  );

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'phone': phone,
    'service_type': serviceType,
    'driving_experience': drivingExperience,
  };
}
