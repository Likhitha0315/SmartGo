// lib/screens/select_vehicle_screen.dart
// Matches document screenshots:
// Page 37 right: "Select Vehicle" - Bus, Car, Bike, Auto with Book buttons
// Page 39 left:  "Available Vehicles" - Bus ₹25, Car ₹50, Bike ₹20, Shared Auto ₹15

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../services/supabase_service.dart';
import '../services/auth_provider.dart';
import '../models/vehicle_model.dart';
import '../widgets/widgets.dart';
import 'payment_screen.dart';

class SelectVehicleScreen extends StatefulWidget {
  final String fromLocation;
  final String toLocation;

  const SelectVehicleScreen({
    super.key,
    required this.fromLocation,
    required this.toLocation,
  });

  @override
  State<SelectVehicleScreen> createState() => _SelectVehicleScreenState();
}

class _SelectVehicleScreenState extends State<SelectVehicleScreen> {
  final _svc = SupabaseService();
  List<Vehicle> _vehicles = [];
  bool _loading = true;
  String? _error;

  // Static vehicles matching document exactly:
  // Bus ₹25, Car ₹50, Bike ₹20, Shared Auto ₹15
  final List<Map<String, dynamic>> _staticVehicles = [
    {'type': 'bus',         'emoji': '🚌', 'name': 'Bus',         'fare': 25.0, 'driver': 'Ramu Naidu',    'phone': '9876543210'},
    {'type': 'car',         'emoji': '🚗', 'name': 'Car',         'fare': 50.0, 'driver': 'Suresh Kumar',  'phone': '9876543211'},
    {'type': 'bike',        'emoji': '🏍️', 'name': 'Bike',        'fare': 20.0, 'driver': 'Venkat Rao',    'phone': '9876543212'},
    {'type': 'shared_auto', 'emoji': '🛺', 'name': 'Shared Auto', 'fare': 15.0, 'driver': 'Krishna Reddy', 'phone': '9876543213'},
  ];

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    setState(() => _loading = true);
    try {
      final loaded = await _svc.getAvailableVehicles(
        from: widget.fromLocation,
        to:   widget.toLocation,
      );
      setState(() {
        _vehicles = loaded;
        _loading  = false;
      });
    } catch (e) {
      // Fall back to static display if DB not connected
      setState(() { _loading = false; _error = e.toString(); });
    }
  }

  void _bookVehicle(Map<String, dynamic> vData) {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;

    // Create a Vehicle object from static data
    final vehicle = Vehicle(
      id:            'v_${vData['type']}',
      driverId:      'driver_${vData['type']}',
      driverName:    vData['driver'] as String,
      driverPhone:   vData['phone'] as String,
      vehicleType:   vData['type'] as String,
      vehicleNumber: 'AP16XX0001',
      farePerKm:     (vData['fare'] as double) / 5,
      fromLocation:  widget.fromLocation,
      toLocation:    widget.toLocation,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          vehicle:      vehicle,
          fromLocation: widget.fromLocation,
          toLocation:   widget.toLocation,
          fare:         vData['fare'] as double,
        ),
      ),
    );
  }

  void _bookFromDB(Vehicle vehicle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          vehicle:      vehicle,
          fromLocation: widget.fromLocation,
          toLocation:   widget.toLocation,
          fare:         vehicle.estimatedFare,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine title: "Slect Vehicle" from doc page 37, "Available Vehicles" from doc page 39
    final hasRoute = widget.fromLocation.isNotEmpty && widget.toLocation.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SmartAppBar(
        title: hasRoute ? 'Available Vehicles' : 'Select Vehicle',
      ),
      body: Column(
        children: [
          // Route info banner (if locations provided)
          if (hasRoute)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFFEBF5FF),
              child: Row(
                children: [
                  const Text('📍', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${widget.fromLocation} → ${widget.toLocation}',
                      style: AppTextStyles.subheading.copyWith(
                          color: AppColors.primaryDark),
                    ),
                  ),
                ],
              ),
            ),

          // Vehicle list
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary),
                  )
                : RefreshIndicator(
                    onRefresh: _loadVehicles,
                    color: AppColors.primary,
                    child: ListView(
                      children: [
                        // Show DB vehicles if loaded, otherwise static
                        if (_vehicles.isNotEmpty)
                          ..._vehicles.map((v) => VehicleListTile(
                            vehicle: v,
                            onBook: () => _bookFromDB(v),
                          ))
                        else
                          // Static fallback matching document exactly
                          ..._staticVehicles.map((v) => _StaticVehicleTile(
                            emoji:   v['emoji'] as String,
                            name:    v['name'] as String,
                            fare:    v['fare'] as double,
                            onBook:  () => _bookVehicle(v),
                          )),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── STATIC VEHICLE TILE (pixel-matches document screenshot) ────────────────
class _StaticVehicleTile extends StatelessWidget {
  final String emoji;
  final String name;
  final double fare;
  final VoidCallback onBook;

  const _StaticVehicleTile({
    required this.emoji,
    required this.name,
    required this.fare,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(color: AppColors.border, width: 0.8),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          // Emoji icon (matches doc: bus/car/bike/auto emojis)
          Text(emoji, style: const TextStyle(fontSize: 30)),
          const SizedBox(width: 16),
          // Vehicle name + fare
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.vehicleName),
                const SizedBox(height: 2),
                Text(
                  'Fare: ₹${fare.toStringAsFixed(0)}',
                  style: AppTextStyles.fareText,
                ),
              ],
            ),
          ),
          // BOOK button (matches doc: solid blue "Book")
          SizedBox(
            width: 72,
            height: 34,
            child: ElevatedButton(
              onPressed: onBook,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: EdgeInsets.zero,
                elevation: 0,
              ),
              child: const Text(
                'Book',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
