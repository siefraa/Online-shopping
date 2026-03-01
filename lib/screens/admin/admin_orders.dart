import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../utils/app_theme.dart';
import '../../widgets/order_status_badge.dart';

class AdminOrdersScreen extends ConsumerStatefulWidget {
  const AdminOrdersScreen({super.key});
  @override
  ConsumerState<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends ConsumerState<AdminOrdersScreen> {
  OrderStatus? _filter;

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersProvider).where((o) => _filter == null || o.status == _filter).toList();

    return SafeArea(child: Column(children: [
      Container(color: AppColors.adminPrimary, padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Orders', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          SizedBox(height: 36, child: ListView(scrollDirection: Axis.horizontal, children: [
            _FilterChip('All', _filter == null, () => setState(() => _filter = null)),
            ...OrderStatus.values.map((s) => _FilterChip(s.label, _filter == s, () => setState(() => _filter = s))),
          ])),
        ])),

      Expanded(child: orders.isEmpty
        ? const Center(child: Text('No orders'))
        : ListView.builder(padding: const EdgeInsets.all(16), itemCount: orders.length, itemBuilder: (_, i) {
            final o = orders[i];
            return Container(margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(o.id, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.adminPrimary)),
                  OrderStatusBadge(status: o.status),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.person_outline, size: 14, color: AppColors.textGrey),
                  const SizedBox(width: 4),
                  Text(o.userName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 12),
                  const Icon(Icons.phone_outlined, size: 14, color: AppColors.textGrey),
                  const SizedBox(width: 4),
                  Text(o.userPhone, style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                ]),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textGrey),
                  const SizedBox(width: 4),
                  Expanded(child: Text(o.deliveryAddress, style: const TextStyle(fontSize: 12, color: AppColors.textGrey), maxLines: 1, overflow: TextOverflow.ellipsis)),
                ]),
                const SizedBox(height: 8),
                Text(o.items.map((e) => '${e.product.emoji} ${e.product.name} ×${e.quantity}').join(' · '),
                  style: const TextStyle(fontSize: 12, color: AppColors.textGrey), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(formatTZS(o.total), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.adminPrimary)),
                    Text(o.paymentMethod, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
                  ]),
                  if (o.status != OrderStatus.delivered && o.status != OrderStatus.cancelled)
                    DropdownButton<OrderStatus>(
                      value: o.status, underline: const SizedBox(),
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.adminPrimary),
                      items: OrderStatus.values.where((s) => s != OrderStatus.cancelled).map((s) =>
                        DropdownMenuItem(value: s, child: Text('${s.emoji} ${s.label}'))).toList(),
                      onChanged: (s) { if (s != null) ref.read(ordersProvider.notifier).updateStatus(o.id, s); }),
                ]),
                const SizedBox(height: 4),
                Text(timeAgo(o.createdAt), style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
              ]));
          })),
    ]));
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _FilterChip(this.label, this.active, this.onTap);
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap,
    child: Container(margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(color: active ? Colors.white : Colors.white24, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
        color: active ? AppColors.adminPrimary : Colors.white))));
}