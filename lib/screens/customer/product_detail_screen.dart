import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../utils/app_theme.dart';
import '../../data/mock_data.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref
        .watch(productsProvider)
        .where((p) => p.id == productId)
        .firstOrNull;

    if (product == null) {
      return const Scaffold(
        body: Center(child: Text('Product not found')),
      );
    }

    final cart = ref.watch(cartProvider);

    final qty = cart
            .where((e) => e.product.id == product.id)
            .firstOrNull
            ?.quantity ??
        0;

    final isWished =
        ref.watch(wishlistProvider.notifier).contains(product.id);

    final reviews = ref
        .watch(reviewsProvider)
        .where((r) => r.productId == productId)
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// APP BAR
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                    )
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 16,
                ),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () =>
                    ref.read(wishlistProvider.notifier).toggle(product),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      isWished
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: isWished
                          ? AppColors.accentRed
                          : AppColors.textGrey,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.background,
                child: Center(
                  child: Text(
                    product.emoji,
                    style: const TextStyle(fontSize: 120),
                  ),
                ),
              ),
            ),
          ),

          /// BODY
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding:
                  const EdgeInsets.fromLTRB(24, 24, 24, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// NAME
                  Text(
                    product.name,
                    style:
                        Theme.of(context).textTheme.displaySmall,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    product.description,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// REVIEWS
                  if (reviews.isNotEmpty) ...[
                    const Text(
                      'Customer Reviews',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ...reviews.map(
                      (r) => Container(
                        margin:
                            const EdgeInsets.only(bottom: 12),
                        padding:
                            const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor:
                                      AppColors.primary,
                                  child: Text(
                                    r.userName[0],
                                    style:
                                        const TextStyle(
                                      color: Colors.white,
                                      fontWeight:
                                          FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(r.userName),
                                const Spacer(),
                                Text(
                                  timeAgo(r.createdAt),
                                  style:
                                      const TextStyle(
                                    fontSize: 11,
                                    color:
                                        AppColors.textLight,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(r.comment),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),

      /// BOTTOM CART
      bottomSheet: Container(
        padding:
            const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 16,
              offset: Offset(0, -4),
            )
          ],
        ),
        child: qty == 0
            ? SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => ref
                      .read(cartProvider.notifier)
                      .add(product),
                  icon:
                      const Icon(Icons.add_shopping_cart),
                  label:
                      const Text('Add to Cart'),
                ),
              )
            : Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          context.push('/checkout'),
                      child:
                          const Text('Checkout'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}