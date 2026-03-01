import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_theme.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;
  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: Padding(padding: const EdgeInsets.all(40), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 120, height: 120, decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), shape: BoxShape.circle),
        child: const Center(child: Text('🎉', style: TextStyle(fontSize: 60)))),
      const SizedBox(height: 28),
      const Text('Order Placed!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textDark)),
      const SizedBox(height: 8),
      Text('Order #$orderId', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 16)),
      const SizedBox(height: 12),
      const Text('Your fresh groceries are being prepared and will be delivered to you soon. 🚚', style: TextStyle(color: AppColors.textGrey, height: 1.6, fontSize: 15), textAlign: TextAlign.center),
      const SizedBox(height: 40),
      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => context.push('/orders'), child: const Text('Track My Order'))),
      const SizedBox(height: 12),
      SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => context.go('/home'), child: const Text('Continue Shopping'))),
    ]))));
}