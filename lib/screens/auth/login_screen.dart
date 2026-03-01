import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/providers.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;
  String? _error;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _error = null; });
    await Future.delayed(const Duration(milliseconds: 800));
    final ok = ref.read(authProvider.notifier).login(_email.text.trim(), _pass.text);
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      final user = ref.read(authProvider)!;
      context.go(user.role == 'admin' ? '/admin' : '/home');
    } else {
      setState(() => _error = 'Invalid email or password. Try again.');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 20),
        GestureDetector(onTap: () => context.go('/onboarding'), child: const Icon(Icons.arrow_back_ios_new, size: 20)),
        const SizedBox(height: 32),
        const Text('🛒', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 12),
        Text('Welcome back!', style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 6),
        const Text('Sign in to continue shopping', style: TextStyle(color: AppColors.textGrey, fontSize: 15)),
        const SizedBox(height: 36),
        AppTextField(hint: 'Email address', icon: Icons.email_outlined, controller: _email, keyboardType: TextInputType.emailAddress,
          validator: (v) => v!.contains('@') ? null : 'Enter a valid email'),
        const SizedBox(height: 14),
        AppTextField(hint: 'Password', icon: Icons.lock_outline, controller: _pass, obscure: true,
          validator: (v) => v!.length >= 6 ? null : 'Min 6 characters'),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Text(_error!, style: const TextStyle(color: AppColors.error, fontSize: 13)))],
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: _loading ? null : _login,
          child: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Sign In'))),
        const SizedBox(height: 16),
        Center(child: GestureDetector(onTap: () => context.go('/register'),
          child: RichText(text: const TextSpan(
            text: "Don't have an account? ", style: TextStyle(color: AppColors.textGrey, fontSize: 14),
            children: [TextSpan(text: 'Create one', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))])))),
        const SizedBox(height: 32),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.06), borderRadius: BorderRadius.circular(14)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Demo Accounts:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            const SizedBox(height: 6),
            _DemoTile('Admin', 'admin@twende.co.tz', 'admin123', () { _email.text='admin@twende.co.tz'; _pass.text='admin123'; }),
            _DemoTile('Customer', 'amina@example.com', 'any6+chars', () { _email.text='amina@example.com'; _pass.text='password123'; }),
          ])),
      ])))));
}

class _DemoTile extends StatelessWidget {
  final String role, email, pass;
  final VoidCallback onTap;
  const _DemoTile(this.role, this.email, this.pass, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap,
    child: Padding(padding: const EdgeInsets.only(top: 4),
      child: Text('$role: $email / $pass', style: const TextStyle(fontSize: 12, color: AppColors.primary))));
}