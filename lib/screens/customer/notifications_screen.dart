import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/providers.dart';
import '../../utils/app_theme.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifs = ref.watch(notificationsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications'), leading: GestureDetector(onTap: () => context.pop(), child: const Icon(Icons.arrow_back_ios_new, size: 18)),
        actions: [TextButton(onPressed: () => ref.read(notificationsProvider.notifier).markAllRead(), child: const Text('Mark all read'))]),
      body: notifs.isEmpty
        ? const Center(child: Text('No notifications'))
        : ListView.builder(padding: const EdgeInsets.all(16), itemCount: notifs.length, itemBuilder: (_, i) {
            final n = notifs[i];
            return GestureDetector(
              onTap: () => ref.read(notificationsProvider.notifier).markRead(n.id),
              child: Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: n.isRead ? Colors.white : AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16), border: Border.all(color: n.isRead ? Colors.transparent : AppColors.primary.withOpacity(0.2))),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(width: 40, height: 40, decoration: BoxDecoration(
                    color: n.type == 'order' ? AppColors.success.withOpacity(0.1) : AppColors.accent.withOpacity(0.1), shape: BoxShape.circle),
                    child: Center(child: Text(n.type == 'order' ? '📦' : '🎉', style: const TextStyle(fontSize: 18)))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(n.title, style: TextStyle(fontWeight: n.isRead ? FontWeight.w500 : FontWeight.w700, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(n.message, style: const TextStyle(color: AppColors.textGrey, fontSize: 13, height: 1.4)),
                    const SizedBox(height: 6),
                    Text(timeAgo(n.createdAt), style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
                  ])),
                  if (!n.isRead) Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 4), decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                ])));
          }));
  }
}