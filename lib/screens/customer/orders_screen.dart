import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../utils/app_theme.dart';
import '../../widgets/order_status_badge.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final orders = ref.watch(ordersProvider);
    final myOrders = user != null ? orders.where((o) => o.userId == user.id).toList() : orders;

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders'), leading: GestureDetector(onTap: () => context.pop(), child: const Icon(Icons.arrow_back_ios_new, size: 18))),
      body: myOrders.isEmpty
        ? const Center(child: Text('No orders yet'))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: myOrders.length,
            itemBuilder: (_, i) {
              final o = myOrders[i];
              return GestureDetector(
                onTap: () => _showOrderDetail(context, o),
                child: Container(margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)]),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text(o.id, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.primary)),
                      OrderStatusBadge(status: o.status),
                    ]),
                    const SizedBox(height: 8),
                    Text(o.items.map((item) => '${item.product.emoji} ${item.product.name}').join(', '),
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.textGrey, fontSize: 13)),
                    const SizedBox(height: 8),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('${o.items.length} items · ${o.paymentMethod}', style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                      Text(formatTZS(o.total), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textDark)),
                    ]),
                    const SizedBox(height: 6),
                    Text(timeAgo(o.createdAt), style: const TextStyle(color: AppColors.textLight, fontSize: 11)),
                  ])));
            }));
  }

  void _showOrderDetail(BuildContext context, AppOrder order) {
    showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => DraggableScrollableSheet(expand: false, initialChildSize: 0.85,
        builder: (_, ctrl) => SingleChildScrollView(controller: ctrl, child: Padding(padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(order.id, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              OrderStatusBadge(status: order.status),
            ]),
            const SizedBox(height: 4),
            Text(timeAgo(order.createdAt), style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
            const SizedBox(height: 20),
            const Text('Items', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            const SizedBox(height: 8),
            ...order.items.map((item) => Padding(padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                Text(item.product.emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  Text('${item.product.unit} × ${item.quantity}', style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                ])),
                Text(formatTZS(item.total), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              ]))),
            const Divider(height: 24),
            _Row('Delivery address', order.deliveryAddress),
            _Row('Payment', order.paymentMethod),
            _Row('Delivery fee', order.deliveryFee == 0 ? 'FREE' : formatTZS(order.deliveryFee)),
            const Divider(height: 16),
            _Row('Total', formatTZS(order.total), bold: true),
            const SizedBox(height: 24),
            const Text('Order Timeline', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            const SizedBox(height: 12),
            _OrderTimeline(status: order.status),
          ])))));
  }
}

class _Row extends StatelessWidget {
  final String label, value;
  final bool bold;
  const _Row(this.label, this.value, {this.bold = false});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 6),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(color: bold ? AppColors.textDark : AppColors.textGrey, fontWeight: bold ? FontWeight.w700 : FontWeight.w400, fontSize: bold ? 15 : 13)),
      Text(value, style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w500, fontSize: bold ? 16 : 13, color: bold ? AppColors.primary : AppColors.textDark)),
    ]));
}

class _OrderTimeline extends StatelessWidget {
  final OrderStatus status;
  const _OrderTimeline({required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = [OrderStatus.pending, OrderStatus.confirmed, OrderStatus.preparing, OrderStatus.outForDelivery, OrderStatus.delivered];
    final currentIdx = steps.indexOf(status);

    return Column(children: List.generate(steps.length, (i) {
      final s = steps[i];
      final done = i <= currentIdx;
      return TimelineTile(
        isFirst: i == 0, isLast: i == steps.length - 1,
        indicatorStyle: IndicatorStyle(width: 24, height: 24,
          indicator: Container(decoration: BoxDecoration(color: done ? AppColors.primary : AppColors.divider, shape: BoxShape.circle),
            child: Center(child: Icon(done ? Icons.check : Icons.circle, size: 12, color: Colors.white)))),
        beforeLineStyle: LineStyle(color: done ? AppColors.primary : AppColors.divider, thickness: 2),
        afterLineStyle: LineStyle(color: (i < currentIdx) ? AppColors.primary : AppColors.divider, thickness: 2),
        endChild: Padding(padding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
          child: Text('${s.emoji} ${s.label}', style: TextStyle(fontWeight: done ? FontWeight.w600 : FontWeight.w400,
            color: done ? AppColors.textDark : AppColors.textLight))));
    }));
  }
}