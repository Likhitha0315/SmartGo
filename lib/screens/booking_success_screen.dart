// lib/screens/booking_success_screen.dart

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/vehicle_model.dart';
import 'home_screen.dart';

class BookingSuccessScreen extends StatelessWidget {
  final Vehicle vehicle;
  final String fromLocation;
  final String toLocation;
  final double fare;
  final String paymentMethod;

  const BookingSuccessScreen({
    super.key,
    required this.vehicle,
    required this.fromLocation,
    required this.toLocation,
    required this.fare,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success icon
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FFF4),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.success, width: 2),
                ),
                child: const Center(
                  child: Text('✅', style: TextStyle(fontSize: 48)),
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Booking Confirmed!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),
              Text(
                'Your ${vehicle.displayName} has been booked.',
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Details card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _DetailRow(label: 'Vehicle', value: '${vehicle.emoji} ${vehicle.displayName}'),
                    _DetailRow(label: 'From',    value: fromLocation),
                    _DetailRow(label: 'To',      value: toLocation),
                    _DetailRow(label: 'Driver',  value: vehicle.driverName),
                    _DetailRow(label: 'Contact', value: vehicle.driverPhone),
                    _DetailRow(label: 'Fare',    value: '₹${fare.toStringAsFixed(2)}'),
                    _DetailRow(label: 'Payment', value: paymentMethod, isLast: true),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (_) => false,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _DetailRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textSecondary)),
            Text(value,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ],
        ),
      ),
      if (!isLast)
        const Divider(height: 1, color: AppColors.border),
    ],
  );
}
