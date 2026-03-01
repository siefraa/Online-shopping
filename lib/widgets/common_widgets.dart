import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionHeader({super.key, required this.title, this.action, this.onAction});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: Theme.of(context).textTheme.headlineSmall),
      if (action != null) GestureDetector(onTap: onAction,
        child: Text(action!, style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600))),
    ]));
}

class AppTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  const AppTextField({super.key, required this.hint, required this.icon,
    required this.controller, this.obscure = false,
    this.keyboardType = TextInputType.text, this.validator});
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller, obscureText: obscure, keyboardType: keyboardType, validator: validator,
    decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: AppColors.textGrey, size: 20)));
}

class LoadingOverlay extends StatelessWidget {
  final String message;
  const LoadingOverlay({super.key, this.message = 'Loading...'});
  @override
  Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    const CircularProgressIndicator(color: AppColors.primary),
    const SizedBox(height: 12),
    Text(message, style: const TextStyle(color: AppColors.textGrey)),
  ]));
}

class EmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  const EmptyState({super.key, required this.emoji, required this.title, required this.subtitle, this.actionLabel, this.onAction});
  @override
  Widget build(BuildContext context) => Center(child: Padding(
    padding: const EdgeInsets.all(40),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text(emoji, style: const TextStyle(fontSize: 60)),
      const SizedBox(height: 16),
      Text(title, style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
      const SizedBox(height: 8),
      Text(subtitle, style: const TextStyle(color: AppColors.textGrey), textAlign: TextAlign.center),
      if (actionLabel != null) ...[
        const SizedBox(height: 24),
        ElevatedButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    ])));
}