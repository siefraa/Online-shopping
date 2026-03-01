import 'package:flutter/material.dart';
import '../models/models.dart';
import '../utils/app_theme.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;
  const OrderStatusBadge({super.key, required this.status});

  Color get color {
    switch (status) {
      case OrderStatus.pending: return AppColors.warning;
      case OrderStatus.confirmed: return Colors.blue;
      case OrderStatus.preparing: return Colors.orange;
      case OrderStatus.outForDelivery: return Colors.purple;
      case OrderStatus.delivered: return AppColors.success;
      case OrderStatus.cancelled: return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
    child: Text('${status.emoji} ${status.label}',
      style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)));
}