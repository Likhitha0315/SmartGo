// lib/screens/my_bookings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../services/supabase_service.dart';
import '../services/auth_provider.dart';
import '../models/booking_model.dart';
import '../widgets/widgets.dart';
import 'package:intl/intl.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final _svc = SupabaseService();
  List<Booking> _bookings = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = context.read<AuthProvider>().user;
    if (user == null) return;
    setState(() => _loading = true);
    try {
      final data = await _svc.getUserBookings(user.id);
      setState(() { _bookings = data; _loading = false; });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.scaffoldBg,
    appBar: SmartAppBar(title: 'My Bookings'),
    body: _loading
        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
        : _bookings.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('📋', style: TextStyle(fontSize: 56)),
                    SizedBox(height: 16),
                    Text('No bookings yet', style: AppTextStyles.subheading),
                    SizedBox(height: 8),
                    Text('Book a ride to see it here', style: AppTextStyles.body),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _load,
                color: AppColors.primary,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _bookings.length,
                  itemBuilder: (_, i) => _BookingCard(booking: _bookings[i]),
                ),
              ),
  );
}

class _BookingCard extends StatelessWidget {
  final Booking booking;
  const _BookingCard({required this.booking});

  Color get _statusColor {
    switch (booking.status) {
      case 'confirmed':  return AppColors.success;
      case 'completed':  return AppColors.primary;
      case 'cancelled':  return AppColors.error;
      default:           return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(booking.vehicleEmoji,
                  style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.vehicleType.toUpperCase(),
                        style: AppTextStyles.vehicleName),
                    Text(
                      '${booking.fromLocation} → ${booking.toLocation}',
                      style: AppTextStyles.body,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: _statusColor.withOpacity(0.4)),
                ),
                child: Text(
                  booking.status.toUpperCase(),
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _statusColor),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Driver: ${booking.driverName}',
                  style: AppTextStyles.body),
              Text('₹${booking.fare.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('dd MMM yyyy, hh:mm a').format(booking.createdAt),
            style: const TextStyle(fontSize: 12, color: AppColors.textHint),
          ),
        ],
      ),
    ),
  );
}
