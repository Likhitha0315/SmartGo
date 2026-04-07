// lib/screens/home_screen.dart
// Main dashboard - navigation hub after login

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../services/auth_provider.dart';
import '../widgets/widgets.dart';
import 'location_screen.dart';
import 'select_vehicle_screen.dart';
import 'my_bookings_screen.dart';
import 'sos_screen.dart';
import 'feedback_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Text(
              '🚕 ',
              style: TextStyle(fontSize: 22),
            ),
            const Text(
              'SmartGo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── WELCOME BANNER ─────────────────────────────────────────
            Container(
              width: double.infinity,
              color: AppColors.primary,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${user?.firstName ?? 'Traveller'}! 👋',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Where do you want to go today?',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── BOOK A RIDE CARD ───────────────────────────────────────
            _SectionTitle(title: 'Book a Ride'),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _MenuCard(
                title: 'Find Transport',
                subtitle: 'Bus, Car, Bike, Auto',
                emoji: '🚌',
                color: const Color(0xFFEBF5FF),
                borderColor: const Color(0xFFB3D7FF),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LocationScreen()),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _MenuCard(
                title: 'Select Vehicle Type',
                subtitle: 'Browse by vehicle',
                emoji: '🛺',
                color: const Color(0xFFEBF5FF),
                borderColor: const Color(0xFFB3D7FF),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SelectVehicleScreen(
                      fromLocation: 'Nambur',
                      toLocation: 'Guntur',
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── MY TRIPS ───────────────────────────────────────────────
            _SectionTitle(title: 'My Trips'),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _MenuCard(
                title: 'My Bookings',
                subtitle: 'View your rides',
                emoji: '📋',
                color: const Color(0xFFF0FFF4),
                borderColor: const Color(0xFFB3F0C9),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyBookingsScreen()),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── SUPPORT ────────────────────────────────────────────────
            _SectionTitle(title: 'Support & Safety'),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _SmallMenuCard(
                      title: 'SOS Alert',
                      emoji: '🆘',
                      color: const Color(0xFFFFF0F0),
                      borderColor: const Color(0xFFFFB3B3),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SOSScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SmallMenuCard(
                      title: 'Feedback',
                      emoji: '💬',
                      color: const Color(0xFFFFFBEB),
                      borderColor: const Color(0xFFFFE083),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const FeedbackScreen()),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── COMMON ROUTES ──────────────────────────────────────────
            _SectionTitle(title: 'Popular Routes'),
            const SizedBox(height: 12),

            ...commonRoutes.take(4).map((route) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SelectVehicleScreen(
                      fromLocation: route['from']!,
                      toLocation: route['to']!,
                    ),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Text('📍', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${route['from']} → ${route['to']}',
                          style: AppTextStyles.subheading,
                        ),
                      ),
                      Text(
                        route['distance']!,
                        style: AppTextStyles.body,
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios,
                          size: 14, color: AppColors.textHint),
                    ],
                  ),
                ),
              ),
            )),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
        letterSpacing: 0.3,
      ),
    ),
  );
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
  final Color borderColor;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.subheading),
                const SizedBox(height: 3),
                Text(subtitle, style: AppTextStyles.body),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              size: 16, color: AppColors.textHint),
        ],
      ),
    ),
  );
}

class _SmallMenuCard extends StatelessWidget {
  final String title;
  final String emoji;
  final Color color;
  final Color borderColor;
  final VoidCallback onTap;

  const _SmallMenuCard({
    required this.title,
    required this.emoji,
    required this.color,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(title,
              style: AppTextStyles.subheading.copyWith(fontSize: 14),
              textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}
