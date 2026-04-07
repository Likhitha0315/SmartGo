// lib/screens/location_screen.dart
// Matches document screenshot page 38:
// "Enter Locations" title, blue pin + "Current Location",
// red pin + "Drop Location", "Show Available Vehicles" blue button

import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/widgets.dart';
import 'select_vehicle_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _fromCtrl = TextEditingController();
  final _toCtrl   = TextEditingController();

  @override
  void dispose() {
    _fromCtrl.dispose();
    _toCtrl.dispose();
    super.dispose();
  }

  void _handleSearch() {
    final from = _fromCtrl.text.trim();
    final to   = _toCtrl.text.trim();

    if (from.isEmpty) {
      showError(context, 'Enter your current location');
      return;
    }
    if (to.isEmpty) {
      showError(context, 'Enter your drop location');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectVehicleScreen(
          fromLocation: from,
          toLocation: to,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SmartAppBar(title: 'Enter Locations'),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // ── CURRENT LOCATION (blue pin, matches doc) ──────────────
            // Label shown above field (matches doc right screenshot)
            const Text(
              'Current Location',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: 6),
            LocationInputField(
              controller: _fromCtrl,
              hintText: 'Enter pickup location',
              dotColor: AppColors.primary,   // blue dot
              labelText: null,
            ),

            const SizedBox(height: 20),

            // ── DROP LOCATION (red pin, matches doc) ──────────────────
            const Text(
              'Drop Location',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textHint,
              ),
            ),
            const SizedBox(height: 6),
            LocationInputField(
              controller: _toCtrl,
              hintText: 'Enter drop location',
              dotColor: AppColors.error,    // red dot
              labelText: null,
            ),

            const SizedBox(height: 8),

            // ── QUICK FILL CHIPS ───────────────────────────────────────
            Wrap(
              spacing: 8,
              children: commonRoutes.map((route) => GestureDetector(
                onTap: () {
                  setState(() {
                    _fromCtrl.text = route['from']!;
                    _toCtrl.text   = route['to']!;
                  });
                },
                child: Chip(
                  label: Text(
                    '${route['from']} → ${route['to']}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: const Color(0xFFEBF5FF),
                  side: const BorderSide(color: AppColors.primaryLight),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
              )).toList(),
            ),

            const Spacer(),

            // ── SHOW AVAILABLE VEHICLES BUTTON (matches doc: blue rounded) ─
            BlueButton(
              label: 'Show Available Vehicles',
              onPressed: _handleSearch,
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
