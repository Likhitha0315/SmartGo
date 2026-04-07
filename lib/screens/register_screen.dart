// lib/screens/register_screen.dart
// Matches document screenshot page 37 (left side):
// "Create Account" heading, form fields, Register button, Login link

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../services/auth_provider.dart';
import '../widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey   = GlobalKey<FormState>();
  final _nameCtrl  = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _expCtrl   = TextEditingController();
  String _serviceType = 'passenger';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _expCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final ok   = await auth.register(
      fullName:          _nameCtrl.text.trim(),
      phone:             _phoneCtrl.text.trim(),
      serviceType:       _serviceType,
      drivingExperience: _serviceType == 'driver' && _expCtrl.text.isNotEmpty
          ? int.tryParse(_expCtrl.text.trim())
          : null,
    );

    if (!ok && mounted) {
      showError(context, auth.error ?? 'Registration failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ── BACK BUTTON + TITLE ROW ───────────────────────────────
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: AppColors.textPrimary),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(width: 4),
                  const Text('Create Account', style: AppTextStyles.heading),
                ],
              ),

              const SizedBox(height: 24),

              // ── ICON (matches doc: grid/register icon) ────────────────
              Center(
                child: Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF2FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('📝', style: TextStyle(fontSize: 32)),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ── CREATE ACCOUNT HEADING ────────────────────────────────
              const Center(
                child: Text('Create Account', style: AppTextStyles.heading),
              ),

              const SizedBox(height: 28),

              // ── FORM (matches doc screenshot exactly) ─────────────────
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Full Name
                    SmartTextField(
                      controller: _nameCtrl,
                      hintText: 'Full Name',
                      prefixIcon: Icons.person_outline,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Enter your name' : null,
                    ),

                    const SizedBox(height: 16),

                    // Phone Number
                    SmartTextField(
                      controller: _phoneCtrl,
                      hintText: 'Phone Number',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Enter phone number';
                        if (v.trim().length < 10) return 'Enter 10-digit number';
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Service Type dropdown
                    // (matches doc: "Select Type of Service" dropdown)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _serviceType,
                          isExpanded: true,
                          hint: const Text(
                            'Select Type of Service',
                            style: TextStyle(
                                color: AppColors.textHint, fontSize: 15),
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down,
                              color: AppColors.textSecondary),
                          items: const [
                            DropdownMenuItem(
                              value: 'passenger',
                              child: Text('Passenger',
                                  style: TextStyle(fontSize: 15)),
                            ),
                            DropdownMenuItem(
                              value: 'driver',
                              child: Text('Driver',
                                  style: TextStyle(fontSize: 15)),
                            ),
                          ],
                          onChanged: (v) =>
                              setState(() => _serviceType = v ?? 'passenger'),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Driving Experience (matches doc screenshot)
                    SmartTextField(
                      controller: _expCtrl,
                      hintText: 'Driving Experience (in years)',
                      prefixIcon: Icons.info_outline,
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(height: 28),

                    // Register button
                    Consumer<AuthProvider>(
                      builder: (_, auth, __) => BlueButton(
                        label: 'Register',
                        onPressed: _handleRegister,
                        loading: auth.loading,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Login link (matches doc: underlined "Login")
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textLink,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.textLink,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
