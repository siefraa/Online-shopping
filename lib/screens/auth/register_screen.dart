import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/providers.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    ref.read(authProvider.notifier).register(_name.text.trim(), _email.text.trim(), _phone.text.trim(), _pass.text);
    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 20),
        GestureDetector(onTap: () => context.go('/login'), child: const Icon(Icons.arrow_back_ios_new, size: 20)),
        const SizedBox(height: 32),
        Text('Create Account', style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 6),
        const Text('Join Twende Markiti today', style: TextStyle(color: AppColors.textGrey, fontSize: 15)),
        const SizedBox(height: 36),
        AppTextField(hint: 'Full name', icon: Icons.person_outline, controller: _name,
          validator: (v) => v!.isNotEmpty ? null : 'Required'),
        const SizedBox(height: 14),
        AppTextField(hint: 'Email address', icon: Icons.email_outlined, controller: _email, keyboardType: TextInputType.emailAddress,
          validator: (v) => v!.contains('@') ? null : 'Invalid email'),
        const SizedBox(height: 14),
        AppTextField(hint: 'Phone (+255...)', icon: Icons.phone_outlined, controller: _phone, keyboardType: TextInputType.phone,
          validator: (v) => v!.length >= 9 ? null : 'Enter valid phone'),
        const SizedBox(height: 14),
        AppTextField(hint: 'Password', icon: Icons.lock_outline, controller: _pass, obscure: true,
          validator: (v) => v!.length >= 6 ? null : 'Min 6 characters'),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: _loading ? null : _register,
          child: _loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Create Account'))),
        const SizedBox(height: 16),
        Center(child: GestureDetector(onTap: () => context.go('/login'),
          child: RichText(text: const TextSpan(
            text: 'Already have an account? ', style: TextStyle(color: AppColors.textGrey, fontSize: 14),
            children: [TextSpan(text: 'Sign in', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))])))),
      ])))));
}