// lib/widgets/widgets.dart

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../models/vehicle_model.dart';

// ─── PRIMARY BLUE BUTTON (matches document screenshots) ─────────────────────
class BlueButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  const BlueButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 52,
    child: ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 0,
      ),
      child: loading
          ? const SizedBox(
              width: 24, height: 24,
              child: CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2.5,
              ),
            )
          : Text(label, style: AppTextStyles.buttonText),
    ),
  );
}

// ─── PHONE INPUT FIELD (matches document screenshots) ────────────────────────
class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.hintText = 'Phone Number',
  });

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    keyboardType: TextInputType.phone,
    style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
    decoration: InputDecoration(
      hintText: hintText,
      prefixIcon: const Icon(Icons.phone, color: AppColors.textSecondary, size: 22),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );
}

// ─── TEXT INPUT FIELD ────────────────────────────────────────────────────────
class SmartTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscure;

  const SmartTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscure,
    style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
    validator: validator,
    decoration: InputDecoration(
      hintText: hintText,
      prefixIcon: Icon(prefixIcon, color: AppColors.textSecondary, size: 22),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );
}

// ─── VEHICLE LIST TILE (matches "Available Vehicles" screen in document) ─────
class VehicleListTile extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback onBook;

  const VehicleListTile({
    super.key,
    required this.vehicle,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 1),
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(color: AppColors.border, width: 0.8),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Vehicle emoji icon
          Text(vehicle.emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 16),
          // Name + fare
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vehicle.displayName, style: AppTextStyles.vehicleName),
                const SizedBox(height: 2),
                Text(
                  'Fare: ₹${vehicle.estimatedFare.toStringAsFixed(0)}',
                  style: AppTextStyles.fareText,
                ),
              ],
            ),
          ),
          // BOOK button (blue, matches screenshots exactly)
          SizedBox(
            width: 72,
            height: 34,
            child: ElevatedButton(
              onPressed: onBook,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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

// ─── PAYMENT METHOD TILE ──────────────────────────────────────────────────────
class PaymentTile extends StatelessWidget {
  final String icon;
  final String name;
  final VoidCallback onPay;

  const PaymentTile({
    super.key,
    required this.icon,
    required this.name,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(color: AppColors.border, width: 0.8),
      ),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4FF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(icon, style: const TextStyle(fontSize: 20)),
        ),
      ),
      title: Text(name, style: AppTextStyles.subheading),
      trailing: TextButton(
        onPressed: onPay,
        child: const Text(
          'Pay',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}

// ─── LOCATION INPUT (matches "Enter Locations" screen) ───────────────────────
class LocationInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color dotColor;
  final String? labelText;

  const LocationInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.dotColor,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
    decoration: InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: Padding(
        padding: const EdgeInsets.all(14),
        child: Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
  );
}

// ─── BACK APPBAR ──────────────────────────────────────────────────────────────
class SmartAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const SmartAppBar({super.key, required this.title, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
      onPressed: () => Navigator.pop(context),
    ),
    title: Text(title, style: AppTextStyles.heading),
    actions: actions,
    bottom: const PreferredSize(
      preferredSize: Size.fromHeight(1),
      child: Divider(height: 1, color: AppColors.border),
    ),
  );
}

// ─── ERROR SNACKBAR HELPER ────────────────────────────────────────────────────
void showError(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}

void showSuccess(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
