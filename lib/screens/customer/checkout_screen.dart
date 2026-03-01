import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../utils/app_theme.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});
  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _address = TextEditingController();
  String _payMethod = 'M-Pesa';
  bool _placing = false;

  final _payMethods = ['M-Pesa', 'Airtel Money', 'Tigo Pesa', 'Cash on Delivery'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider);
      if (user != null && user.address.isNotEmpty) _address.text = user.address;
    });
  }

  void _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _placing = true);
    await Future.delayed(const Duration(seconds: 1));
    final cart = ref.read(cartProvider);
    final notifier = ref.read(cartProvider.notifier);
    final user = ref.read(authProvider)!;
    final order = AppOrder(
      id: 'ORD-${const Uuid().v4().substring(0, 6).toUpperCase()}',
      userId: user.id, userName: user.name, userPhone: user.phone,
      items: cart.map((e) => OrderItem(product: e.product, quantity: e.quantity, price: e.product.price)).toList(),
      subtotal: notifier.subtotal, deliveryFee: notifier.deliveryFee, total: notifier.total,
      deliveryAddress: _address.text, paymentMethod: _payMethod,
    );
    ref.read(ordersProvider.notifier).addOrder(order);
    notifier.clear();
    if (mounted) context.go('/order-success/${order.id}');
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout'), leading: GestureDetector(onTap: () => context.pop(), child: const Icon(Icons.arrow_back_ios_new, size: 18))),
      body: Form(key: _formKey, child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
            child: Column(children: [
              ...cart.map((item) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [
                Text(item.product.emoji, style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(child: Text('${item.product.name} x${item.quantity}', style: const TextStyle(fontSize: 13))),
                Text(formatTZS(item.total), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              ]))),
              const Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Delivery', style: TextStyle(color: AppColors.textGrey)),
                Text(notifier.deliveryFee == 0 ? 'FREE' : formatTZS(notifier.deliveryFee),
                  style: TextStyle(fontWeight: FontWeight.w600, color: notifier.deliveryFee == 0 ? AppColors.success : null)),
              ]),
              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Total', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                Text(formatTZS(notifier.total), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.primary)),
              ]),
            ])),

          const SizedBox(height: 24),
          const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 10),
          TextFormField(controller: _address, maxLines: 2,
            decoration: const InputDecoration(hintText: 'e.g. Kinondoni, Dar es Salaam, near...', prefixIcon: Icon(Icons.location_on_outlined)),
            validator: (v) => v!.isNotEmpty ? null : 'Address is required'),

          const SizedBox(height: 24),
          const Text('Payment Method', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 10),
          ..._payMethods.map((m) => GestureDetector(onTap: () => setState(() => _payMethod = m),
            child: Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _payMethod == m ? AppColors.primary : Colors.transparent, width: 2),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
              child: Row(children: [
                Text(_payMethod == m ? '🟢' : '⚪', style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 12),
                Text(m, style: TextStyle(fontWeight: FontWeight.w600, color: _payMethod == m ? AppColors.primary : AppColors.textDark)),
              ])))),

          const SizedBox(height: 24),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: _placing ? null : _placeOrder,
            child: _placing ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('Place Order 🛒'))),
        ]))));
  }
}