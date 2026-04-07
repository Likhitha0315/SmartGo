// lib/screens/login_screen.dart
// UI matches document screenshot page 35: taxi emoji, SmartGo title,
// phone input, blue Login button, Register link

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../services/auth_provider.dart';
import '../widgets/widgets.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneCtrl = TextEditingController();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final phone = _phoneCtrl.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      showError(context, 'Enter a valid 10-digit phone number');
      return;
    }
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(phone);
    if (!ok && mounted) {
      showError(context, auth.error ?? 'Login failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            // Matches document: content centered with white card feel
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 80),

                // ── TAXI EMOJI (matches doc screenshot: yellow taxi) ────
                const Text(
                  '🚕',
                  style: TextStyle(fontSize: 80),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // ── APP NAME (matches doc: large bold "SmartGo") ─────────
                const Text(
                  'SmartGo',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // ── CARD CONTAINER (matches doc: rounded card with inputs) ─
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Phone input (matches doc: phone icon + "Phone Number")
                      PhoneInputField(
                        controller: _phoneCtrl,
                        hintText: 'Phone Number',
                      ),

                      const SizedBox(height: 20),

                      // Login button (matches doc: blue rounded "Login")
                      Consumer<AuthProvider>(
                        builder: (_, auth, __) => BlueButton(
                          label: 'Login',
                          onPressed: _handleLogin,
                          loading: auth.loading,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── REGISTER LINK (matches doc: underlined "Register") ────
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textLink,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.textLink,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Small subtitle
                const Text(
                  'Easy Travel Application',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textHint,
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
