// lib/models/vehicle_model.dart

class Vehicle {
  final String id;
  final String driverId;
  final String driverName;
  final String driverPhone;
  final String vehicleType; // bus | car | bike | shared_auto
  final String vehicleNumber;
  final double farePerKm;
  final bool isAvailable;
  final String fromLocation;
  final String toLocation;
  final double? distanceKm;

  Vehicle({
    required this.id,
    required this.driverId,
    required this.driverName,
    required this.driverPhone,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.farePerKm,
    this.isAvailable = true,
    required this.fromLocation,
    required this.toLocation,
    this.distanceKm,
  });

  String get emoji {
    switch (vehicleType) {
      case 'bus':         return '🚌';
      case 'car':         return '🚗';
      case 'bike':        return '🏍️';
      case 'shared_auto': return '🛺';
      default:            return '🚗';
    }
  }

  String get displayName {
    switch (vehicleType) {
      case 'bus':         return 'Bus';
      case 'car':         return 'Car';
      case 'bike':        return 'Bike';
      case 'shared_auto': return 'Shared Auto';
      default:            return vehicleType;
    }
  }

  double get estimatedFare {
    // Base fares matching document screenshot: Bus ₹25, Car ₹50, Bike ₹20, Auto ₹15
    switch (vehicleType) {
      case 'bus':         return 25.0;
      case 'car':         return 50.0;
      case 'bike':        return 20.0;
      case 'shared_auto': return 15.0;
      default:            return 25.0;
    }
  }

  factory Vehicle.fromJson(Map<String, dynamic> j) => Vehicle(
    id:            j['id'] as String,
    driverId:      j['driver_id'] as String? ?? '',
    driverName:    j['driver_name'] as String? ?? 'Driver',
    driverPhone:   j['driver_phone'] as String? ?? '',
    vehicleType:   j['vehicle_type'] as String? ?? 'car',
    vehicleNumber: j['vehicle_number'] as String? ?? '',
    farePerKm:     (j['fare_per_km'] as num?)?.toDouble() ?? 5.0,
    isAvailable:   j['is_available'] as bool? ?? true,
    fromLocation:  j['from_location'] as String? ?? '',
    toLocation:    j['to_location'] as String? ?? '',
    distanceKm:    (j['distance_km'] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'driver_id':      driverId,
    'driver_name':    driverName,
    'driver_phone':   driverPhone,
    'vehicle_type':   vehicleType,
    'vehicle_number': vehicleNumber,
    'fare_per_km':    farePerKm,
    'is_available':   isAvailable,
    'from_location':  fromLocation,
    'to_location':    toLocation,
    'distance_km':    distanceKm,
  };
}
