// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'constants/app_constants.dart';
import 'services/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Transparent status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Supabase
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const SmartGoApp(),
    ),
  );
}

class SmartGoApp extends StatelessWidget {
  const SmartGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const _AppEntry(),
    );
  }
}

// ─── APP ENTRY: checks auth and routes ───────────────────────────────────────
class _AppEntry extends StatefulWidget {
  const _AppEntry();

  @override
  State<_AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<_AppEntry> {
  bool _initialized = false;
  bool _authed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    final auth = context.read<AuthProvider>();
    final ok = await auth.init();
    setState(() {
      _initialized = true;
      _authed = ok;
    });

    // Listen to auth changes (login / logout)
    auth.addListener(() {
      if (mounted) setState(() => _authed = auth.isAuthed);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) return const _SplashScreen();
    return _authed ? const HomeScreen() : const LoginScreen();
  }
}

// ─── SPLASH SCREEN ────────────────────────────────────────────────────────────
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Large taxi emoji matching document
            const Text('🚕', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            const Text(
              'SmartGo',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Easy Travel Application',
              style: TextStyle(fontSize: 16, color: AppColors.textHint),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
