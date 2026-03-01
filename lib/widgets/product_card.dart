import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../utils/app_theme.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  final VoidCallback onTap;
  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final qty = cart.where((e) => e.product.id == product.id).firstOrNull?.quantity ?? 0;
    final isWished = ref.watch(wishlistProvider.notifier).contains(product.id);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // top area
          Stack(children: [
            Container(height: 110, decoration: BoxDecoration(
              color: AppColors.background, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
              child: Center(child: Text(product.emoji, style: const TextStyle(fontSize: 52)))),
            if (product.discount > 0)
              Positioned(top: 8, left: 8, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.accentRed, borderRadius: BorderRadius.circular(8)),
                child: Text('-${product.discount.toStringAsFixed(0)}%', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)))),
            Positioned(top: 8, right: 8, child: GestureDetector(
              onTap: () => ref.read(wishlistProvider.notifier).toggle(product),
              child: Container(width: 30, height: 30, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)]),
                child: Icon(isWished ? Icons.favorite : Icons.favorite_border, size: 16, color: isWished ? AppColors.accentRed : AppColors.textLight)))),
          ]),
          Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (product.badge.isNotEmpty)
              Container(margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(product.badge, style: const TextStyle(color: AppColors.primary, fontSize: 9, fontWeight: FontWeight.w700))),
            Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
            const SizedBox(height: 2),
            Text(product.unit, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.star_rounded, color: AppColors.warning, size: 13),
              const SizedBox(width: 2),
              Text(product.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textDark)),
              Text(' (${product.reviews})', style: const TextStyle(fontSize: 10, color: AppColors.textLight)),
            ]),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(formatTZS(product.price), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textDark)),
                if (product.originalPrice != null)
                  Text(formatTZS(product.originalPrice!), style: const TextStyle(fontSize: 10, color: AppColors.textLight, decoration: TextDecoration.lineThrough)),
              ]),
              qty == 0
                ? GestureDetector(
                    onTap: () => ref.read(cartProvider.notifier).add(product),
                    child: Container(width: 32, height: 32, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.add, color: Colors.white, size: 18)))
                : Row(children: [
                    _QtyBtn(icon: Icons.remove, onTap: () => ref.read(cartProvider.notifier).remove(product.id)),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Text('$qty', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14))),
                    _QtyBtn(icon: Icons.add, dark: true, onTap: () => ref.read(cartProvider.notifier).add(product)),
                  ]),
            ]),
          ])),
        ]),
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool dark;
  const _QtyBtn({required this.icon, required this.onTap, this.dark = false});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(width: 28, height: 28,
      decoration: BoxDecoration(color: dark ? AppColors.primary : AppColors.background, shape: BoxShape.circle),
      child: Icon(icon, size: 16, color: dark ? Colors.white : AppColors.textDark)));
}