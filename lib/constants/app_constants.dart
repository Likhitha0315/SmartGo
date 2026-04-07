// lib/constants/app_constants.dart

import 'package:flutter/material.dart';

// ─── SUPABASE CONFIG ─────────────────────────────────────────────────────────
// Replace with your actual Supabase project values from:
// https://app.supabase.com → Your Project → Settings → API
const String supabaseUrl = 'https://iheffufpcwaaesydgqar.supabase.co';
const String supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImloZWZmdWZwY3dhYWVzeWRncWFyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU0NzI4NjcsImV4cCI6MjA5MTA0ODg2N30.Lqq1eUVpvOBfRBvNom5uujEBt94xzy_ihDVl5Lz6cmk';

// ─── APP INFO ─────────────────────────────────────────────────────────────────
const String appName = 'SmartGo';
const String appTagline = 'Easy Travel Application';
const String appVersion = '1.0.0';

// ─── COLORS (matching document screenshots: white bg, blue accent) ──────────
class AppColors {
  // Primary blue — exact shade from screenshots
  static const Color primary = Color(0xFF4A90E2);
  static const Color secondary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF2C6DC7);
  static const Color primaryLight = Color(0xFF7FB3F0);

  // Backgrounds
  static const Color background = Color(0xFFFFFFFF);
  static const Color scaffoldBg = Color(0xFFF5F5F5);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color inputBg = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textBlue = Color(0xFF4A90E2);
  static const Color textLink = Color(0xFF2C6DC7);

  // Borders
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderFocus = Color(0xFF4A90E2);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);

  // Vehicle type colors
  static const Color busColor = Color(0xFF4A90E2);
  static const Color carColor = Color(0xFF4A90E2);
  static const Color bikeColor = Color(0xFF4A90E2);
  static const Color autoColor = Color(0xFF4A90E2);

  // SOS red
  static const Color sosRed = Color(0xFFE53935);
}

// ─── TEXT STYLES (clean, readable for rural users) ──────────────────────────
class AppTextStyles {
  static const TextStyle appTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.3,
  );

  static const TextStyle linkText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textLink,
    decoration: TextDecoration.underline,
  );

  static const TextStyle vehicleName = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle fareText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle priceHighlight = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textBlue,
  );
}

// ─── THEME ────────────────────────────────────────────────────────────────────
ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: false,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.scaffoldBg,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primaryDark,
      surface: AppColors.cardBg,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 0,
        textStyle: AppTextStyles.buttonText,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBg,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
        borderSide: const BorderSide(color: AppColors.borderFocus, width: 2),
      ),
      hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 15),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardBg,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border, width: 0.5),
      ),
      margin: const EdgeInsets.only(bottom: 10),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 0.8,
    ),
  );
}

// ─── VEHICLE TYPES ────────────────────────────────────────────────────────────
class VehicleType {
  final String id;
  final String name;
  final String emoji;
  final double baseFare;

  const VehicleType({
    required this.id,
    required this.name,
    required this.emoji,
    required this.baseFare,
  });
}

const List<VehicleType> vehicleTypes = [
  VehicleType(id: 'bus', name: 'Bus', emoji: '🚌', baseFare: 25),
  VehicleType(id: 'car', name: 'Car', emoji: '🚗', baseFare: 50),
  VehicleType(id: 'bike', name: 'Bike', emoji: '🏍️', baseFare: 20),
  VehicleType(
      id: 'shared_auto', name: 'Shared Auto', emoji: '🛺', baseFare: 15),
];

// ─── PAYMENT METHODS ──────────────────────────────────────────────────────────
class PaymentMethod {
  final String id;
  final String name;
  final String icon;

  const PaymentMethod(
      {required this.id, required this.name, required this.icon});
}

const List<PaymentMethod> paymentMethods = [
  PaymentMethod(id: 'upi', name: 'UPI', icon: '🔢'),
  PaymentMethod(id: 'phonepe', name: 'PhonePe', icon: '📱'),
  PaymentMethod(id: 'gpay', name: 'Google Pay', icon: '💳'),
  PaymentMethod(id: 'card', name: 'Credit/Debit Card', icon: '💳'),
  PaymentMethod(id: 'netbank', name: 'Net Banking', icon: '🌐'),
];

// ─── ROUTES (Namburu area routes from document) ───────────────────────────────
const List<Map<String, String>> commonRoutes = [
  {'from': 'Nambur', 'to': 'Guntur', 'distance': '15 km'},
  {'from': 'Nambur', 'to': 'Pedakakani', 'distance': '5 km'},
  {'from': 'Guntur', 'to': 'Nambur', 'distance': '15 km'},
  {'from': 'Pedakakani', 'to': 'Nambur', 'distance': '5 km'},
  {'from': 'Nambur', 'to': 'Vijayawada', 'distance': '35 km'},
];
