import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../utils/app_theme.dart';
import '../../data/mock_data.dart';

class AdminProductsScreen extends ConsumerStatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  ConsumerState<AdminProductsScreen> createState() =>
      _AdminProductsScreenState();
}

class _AdminProductsScreenState
    extends ConsumerState<AdminProductsScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final products = ref
        .watch(productsProvider)
        .where((p) =>
            p.name.toLowerCase().contains(
                _search.toLowerCase()))
        .toList();

    return SafeArea(
      child: Column(
        children: [
          /// HEADER
          Container(
            color: AppColors.adminPrimary,
            padding:
                const EdgeInsets.fromLTRB(
                    20, 16, 20, 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                  children: [
                    const Text(
                      'Products',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () =>
                          _showProductForm(
                              context,
                              ref,
                              null),
                      icon:
                          const Icon(Icons.add),
                      label:
                          const Text('Add'),
                      style:
                          ElevatedButton
                              .styleFrom(
                        backgroundColor:
                            Colors.white,
                        foregroundColor:
                            AppColors
                                .adminPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  onChanged: (v) =>
                      setState(
                          () => _search = v),
                  decoration:
                      InputDecoration(
                    filled: true,
                    fillColor:
                        Colors.white,
                    hintText:
                        'Search products...',
                    prefixIcon:
                        const Icon(
                            Icons.search),
                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                                  12),
                      borderSide:
                          BorderSide
                              .none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// PRODUCT LIST
          Expanded(
            child: ListView.builder(
              padding:
                  const EdgeInsets.all(
                      16),
              itemCount:
                  products.length,
              itemBuilder:
                  (_, i) {
                final p =
                    products[i];

                return Container(
                  margin:
                      const EdgeInsets
                          .only(
                              bottom:
                                  12),
                  padding:
                      const EdgeInsets
                          .all(14),
                  decoration:
                      BoxDecoration(
                    color:
                        Colors.white,
                    borderRadius:
                        BorderRadius
                            .circular(
                                16),
                  ),
                  child: Row(
                    children: [
                      Text(
                        p.emoji,
                        style:
                            const TextStyle(
                                fontSize:
                                    26),
                      ),
                      const SizedBox(
                          width: 12),
                      Expanded(
                        child:
                            Text(
                          p.name,
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight
                                    .w600,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                            Icons.edit),
                        onPressed: () =>
                            _showProductForm(
                                context,
                                ref,
                                p),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color:
                              AppColors
                                  .error,
                        ),
                        onPressed: () =>
                            ref
                                .read(
                                    productsProvider
                                        .notifier)
                                .deleteProduct(
                                    p.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ FIXED BOTTOM SHEET
  void _showProductForm(
      BuildContext ctx,
      WidgetRef ref,
      Product? existing) {
    final nameC =
        TextEditingController(
            text:
                existing?.name);
    final priceC =
        TextEditingController(
            text: existing
                ?.price
                .toString());

    String cat =
        existing?.category ??
            MockData
                .categories[1];

    showModalBottomSheet(
      context: ctx,
      isScrollControlled:
          true,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top:
              Radius.circular(
                  24),
        ),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder:
              (ctx, setState) {
            return Padding(
              padding:
                  EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(
                        ctx)
                    .viewInsets
                    .bottom +
                    20,
              ),
              child:
                  SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize
                          .min,
                  children: [
                    Text(
                      existing ==
                              null
                          ? 'Add Product'
                          : 'Edit Product',
                      style:
                          const TextStyle(
                        fontSize:
                            18,
                        fontWeight:
                            FontWeight
                                .w800,
                      ),
                    ),
                    const SizedBox(
                        height:
                            16),

                    TextField(
                      controller:
                          nameC,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Product Name',
                      ),
                    ),

                    const SizedBox(
                        height:
                            12),

                    TextField(
                      controller:
                          priceC,
                      keyboardType:
                          TextInputType
                              .number,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Price',
                      ),
                    ),

                    const SizedBox(
                        height:
                            20),

                    SizedBox(
                      width: double
                          .infinity,
                      child:
                          ElevatedButton(
                        onPressed:
                            () {
                          final product =
                              Product(
                            id: existing
                                    ?.id ??
                                const Uuid()
                                    .v4(),
                            name: nameC
                                .text,
                            description:
                                '',
                            price: double.tryParse(
                                    priceC.text) ??
                                0,
                            category:
                                cat,
                            unit:
                                '',
                            emoji:
                                '🛒',
                            badge:
                                '',
                            stock:
                                100,
                          );

                          if (existing ==
                              null) {
                            ref
                                .read(
                                    productsProvider
                                        .notifier)
                                .addProduct(
                                    product);
                          } else {
                            ref
                                .read(
                                    productsProvider
                                        .notifier)
                                .updateProduct(
                                    product);
                          }

                          Navigator.pop(
                              ctx);
                        },
                        child: Text(
                          existing ==
                                  null
                              ? 'Add Product'
                              : 'Save',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}