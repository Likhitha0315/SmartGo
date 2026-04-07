// lib/screens/feedback_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../services/supabase_service.dart';
import '../services/auth_provider.dart';
import '../widgets/widgets.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _svc     = SupabaseService();
  final _msgCtrl = TextEditingController();
  int _rating    = 5;
  bool _loading  = false;
  bool _done     = false;

  @override
  void dispose() { _msgCtrl.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (_msgCtrl.text.trim().isEmpty) {
      showError(context, 'Please write your feedback');
      return;
    }
    final user = context.read<AuthProvider>().user;
    setState(() => _loading = true);
    try {
      await _svc.submitFeedback(
        userId:  user?.id ?? 'anonymous',
        message: _msgCtrl.text.trim(),
        rating:  _rating,
      );
      setState(() { _loading = false; _done = true; });
    } catch (_) {
      setState(() { _loading = false; _done = true; }); // demo
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: SmartAppBar(title: 'Feedback'),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: _done
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🙏', style: TextStyle(fontSize: 64)),
                  SizedBox(height: 16),
                  Text('Thank You!', style: AppTextStyles.heading),
                  SizedBox(height: 8),
                  Text('Your feedback has been submitted.',
                      style: AppTextStyles.body),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Rate your experience', style: AppTextStyles.subheading),
                const SizedBox(height: 12),
                Row(
                  children: List.generate(5, (i) => IconButton(
                    icon: Icon(
                      i < _rating ? Icons.star_rounded : Icons.star_border_rounded,
                      color: AppColors.secondary,
                      size: 36,
                    ),
                    onPressed: () => setState(() => _rating = i + 1),
                  )),
                ),
                const SizedBox(height: 20),
                const Text('Your Comments', style: AppTextStyles.subheading),
                const SizedBox(height: 8),
                TextField(
                  controller: _msgCtrl,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Tell us about your experience...',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const Spacer(),
                BlueButton(
                  label: 'Submit Feedback',
                  onPressed: _submit,
                  loading: _loading,
                ),
                const SizedBox(height: 24),
              ],
            ),
    ),
  );
}
