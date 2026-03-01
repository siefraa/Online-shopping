import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/providers.dart';
import '../../utils/app_theme.dart';

class AdminSettingsScreen extends ConsumerWidget {
  const AdminSettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(child: SingleChildScrollView(child: Column(children: [
      Container(color: AppColors.adminPrimary, width: double.infinity, padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(children: [
          const CircleAvatar(radius: 40, backgroundColor: Colors.white24,
            child: Text('👨‍💼', style: TextStyle(fontSize: 40))),
          const SizedBox(height: 12),
          const Text('Admin Twende', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
          const Text('admin@twende.co.tz', style: TextStyle(color: Colors.white70, fontSize: 13)),
        ])),

      const SizedBox(height: 16),
      _Section('App Settings', [
        _Item(Icons.store_outlined, 'Shop Profile', 'Manage store info'),
        _Item(Icons.delivery_dining_outlined, 'Delivery Settings', 'Zones & fees'),
        _Item(Icons.payment_outlined, 'Payment Methods', 'Manage payment options'),
        _Item(Icons.percent_outlined, 'Discounts & Promo', 'Create promo codes'),
      ]),
      _Section('Communication', [
        _Item(Icons.notifications_outlined, 'Push Notifications', 'Send alerts to customers'),
        _Item(Icons.sms_outlined, 'SMS Settings', 'Configure SMS gateway'),
      ]),
      _Section('Account', [
        _Item(Icons.lock_outline, 'Change Password', 'Update admin password'),
        _Item(Icons.people_outline, 'Admin Users', 'Manage admin access'),
      ]),
      Padding(padding: const EdgeInsets.all(20),
        child: SizedBox(width: double.infinity, child: ElevatedButton.icon(
          onPressed: () { ref.read(authProvider.notifier).logout(); context.go('/login'); },
          icon: const Icon(Icons.logout), label: const Text('Sign Out'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white)))),
      const SizedBox(height: 8),
      Text('Twende Markiti v1.0.0', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
      const SizedBox(height: 24),
    ])));
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> items;
  const _Section(this.title, this.items);
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textGrey))),
      Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
        child: Column(children: items)),
      const SizedBox(height: 16),
    ]));
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String title, sub;
  const _Item(this.icon, this.title, this.sub);
  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon, color: AppColors.adminPrimary),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
    subtitle: Text(sub, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textLight),
    onTap: () {});
}