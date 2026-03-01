import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../utils/app_theme.dart';

class AdminCustomersScreen extends ConsumerWidget {
  const AdminCustomersScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(customersProvider);
    return SafeArea(child: Column(children: [
      Container(color: AppColors.adminPrimary, width: double.infinity, padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: const Text('Customers', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800))),
      Expanded(child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: customers.length, itemBuilder: (_, i) {
        final c = customers[i];
        return Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
          child: Row(children: [
            CircleAvatar(radius: 24, backgroundColor: AppColors.adminPrimary,
              child: Text(c.name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20))),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(c.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              Text(c.email, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
              Text(c.phone, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(formatTZS(c.totalSpent), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.adminPrimary, fontSize: 13)),
              Text('${c.totalOrders} orders', style: const TextStyle(color: AppColors.textGrey, fontSize: 11)),
              Text('Since ${c.joinedAt.year}', style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
            ]),
          ]));
      })),
    ]));
  }
}