// lib/models/booking_model.dart

class Booking {
  final String id;
  final String userId;
  final String vehicleId;
  final String driverName;
  final String driverPhone;
  final String vehicleType;
  final String fromLocation;
  final String toLocation;
  final double fare;
  final String paymentMethod;
  final String status; // pending | confirmed | completed | cancelled
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.driverName,
    required this.driverPhone,
    required this.vehicleType,
    required this.fromLocation,
    required this.toLocation,
    required this.fare,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  String get vehicleEmoji {
    switch (vehicleType) {
      case 'bus':         return '🚌';
      case 'car':         return '🚗';
      case 'bike':        return '🏍️';
      case 'shared_auto': return '🛺';
      default:            return '🚗';
    }
  }

  factory Booking.fromJson(Map<String, dynamic> j) => Booking(
    id:            j['id'] as String,
    userId:        j['user_id'] as String? ?? '',
    vehicleId:     j['vehicle_id'] as String? ?? '',
    driverName:    j['driver_name'] as String? ?? '',
    driverPhone:   j['driver_phone'] as String? ?? '',
    vehicleType:   j['vehicle_type'] as String? ?? '',
    fromLocation:  j['from_location'] as String? ?? '',
    toLocation:    j['to_location'] as String? ?? '',
    fare:          (j['fare'] as num?)?.toDouble() ?? 0.0,
    paymentMethod: j['payment_method'] as String? ?? '',
    status:        j['status'] as String? ?? 'pending',
    createdAt: DateTime.parse(
      j['created_at'] as String? ?? DateTime.now().toIso8601String(),
    ),
  );

  Map<String, dynamic> toJson() => {
    'user_id':        userId,
    'vehicle_id':     vehicleId,
    'driver_name':    driverName,
    'driver_phone':   driverPhone,
    'vehicle_type':   vehicleType,
    'from_location':  fromLocation,
    'to_location':    toLocation,
    'fare':           fare,
    'payment_method': paymentMethod,
    'status':         status,
  };
}
