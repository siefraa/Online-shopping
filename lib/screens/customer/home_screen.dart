import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:badges/badges.dart' as badges;
import '../../data/mock_data.dart';
import '../../providers/providers.dart';
import '../../utils/app_theme.dart';
import '../../widgets/product_card.dart';
import '../../widgets/common_widgets.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _tab = 0;
  final _pages = const [_ShopTab(), _SearchTab(), _CartTab(), _WishlistTab(), _ProfileTab()];

  @override
  Widget build(BuildContext context) {
    final cartCount = ref.watch(cartProvider.notifier).itemCount;
    final notifUnread = ref.watch(notificationsProvider.notifier).unread;

    return Scaffold(
      body: IndexedStack(index: _tab, children: _pages),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, -4))]),
        child: SafeArea(child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _NavItem(icon: Icons.store_outlined, activeIcon: Icons.store, label: 'Shop', index: 0, current: _tab, onTap: (i) => setState(() => _tab = i)),
            _NavItem(icon: Icons.search_outlined, activeIcon: Icons.search, label: 'Search', index: 1, current: _tab, onTap: (i) => setState(() => _tab = i)),
            _NavItem(icon: Icons.shopping_cart_outlined, activeIcon: Icons.shopping_cart, label: 'Cart', index: 2, current: _tab, badge: cartCount > 0 ? '$cartCount' : null, onTap: (i) => setState(() => _tab = i)),
            _NavItem(icon: Icons.favorite_outline, activeIcon: Icons.favorite, label: 'Saved', index: 3, current: _tab, onTap: (i) => setState(() => _tab = i)),
            _NavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile', index: 4, current: _tab, badge: notifUnread > 0 ? '$notifUnread' : null, onTap: (i) => setState(() => _tab = i)),
          ]),
        ))),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon, activeIcon;
  final String label;
  final int index, current;
  final String? badge;
  final void Function(int) onTap;
  const _NavItem({required this.icon, required this.activeIcon, required this.label,
    required this.index, required this.current, required this.onTap, this.badge});
  @override
  Widget build(BuildContext context) {
    final active = index == current;
    final child = Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(active ? activeIcon : icon, color: active ? AppColors.primary : AppColors.textLight, size: 24),
      const SizedBox(height: 3),
      Text(label, style: TextStyle(fontSize: 10, fontWeight: active ? FontWeight.w700 : FontWeight.w400,
        color: active ? AppColors.primary : AppColors.textLight)),
      if (active) Container(margin: const EdgeInsets.only(top: 3), width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
    ]);
    return GestureDetector(
      onTap: () => onTap(index),
      child: badge != null
        ? badges.Badge(badgeContent: Text(badge!, style: const TextStyle(color: Colors.white, fontSize: 9)), child: child)
        : child);
  }
}

// ── Shop Tab ──────────────────────────────────────────────────────
class _ShopTab extends ConsumerStatefulWidget {
  const _ShopTab();
  @override
  ConsumerState<_ShopTab> createState() => _ShopTabState();
}

class _ShopTabState extends ConsumerState<_ShopTab> {
  final _banners = [
    {'title':'Weekend\nFresh Picks','sub':'Farm to table, same-day','emoji':'🌿','c1':0xFF1B5E20,'c2':0xFF43A047},
    {'title':'Seafood\nFriday 🐟','sub':'Fresh catch every week','emoji':'🌊','c1':0xFF0D47A1,'c2':0xFF1976D2},
    {'title':'Mama\nSpecials 🍲','sub':'Traditional favourites','emoji':'🥘','c1':0xFFBF360C,'c2':0xFFE64A19},
  ];
  int _bannerIdx = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    final filtered = ref.watch(filteredProductsProvider);
    final cat = ref.watch(categoryFilterProvider);

    return CustomScrollView(slivers: [
      // App bar
      SliverToBoxAdapter(child: Container(
        color: AppColors.background,
        padding: const EdgeInsets.fromLTRB(20, 52, 20, 16),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [const Icon(Icons.location_on, color: AppColors.primary, size: 14),
              const SizedBox(width: 4),
              const Text('Dar es Salaam', style: TextStyle(fontSize: 12, color: AppColors.textGrey, fontWeight: FontWeight.w500))]),
            const SizedBox(height: 4),
            Text('Hello, ${user?.name.split(' ')[0] ?? 'Shopper'} 👋',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textDark)),
          ]),
          GestureDetector(onTap: () => context.push('/notifications'),
            child: Container(width: 44, height: 44, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)]),
              child: const Icon(Icons.notifications_outlined, color: AppColors.textDark))),
        ]))),

      // Banners
      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
        child: Column(children: [
          SizedBox(height: 160, child: PageView.builder(
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _bannerIdx = i),
            itemBuilder: (_, i) {
              final b = _banners[i];
              return Container(
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(colors: [Color(b['c1'] as int), Color(b['c2'] as int)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                child: Stack(children: [
                  Positioned(right: 20, top: 0, bottom: 0, child: Center(child: Text(b['emoji'] as String, style: TextStyle(
  fontSize: 70,
  color: Colors.black.withOpacity(0.6),
)))),
                  Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text(b['sub'] as String, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(b['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800, height: 1.2)),
                    const SizedBox(height: 12),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                      child: const Text('Shop Now →', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700))),
                  ])),
                ]));
            })),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(_banners.length, (i) =>
            Container(margin: const EdgeInsets.only(right: 6), width: _bannerIdx == i ? 20 : 6, height: 6,
              decoration: BoxDecoration(color: _bannerIdx == i ? AppColors.primary : AppColors.divider, borderRadius: BorderRadius.circular(3))))),
        ]))),

      // Quick stats
      SliverToBoxAdapter(child: SizedBox(height: 80, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _QuickStat('🚚', 'Free Delivery', '>TZS 20k'),
          _QuickStat('⏱', '2-4 Hours', 'Fast delivery'),
          _QuickStat('🌿', '100% Fresh', 'Guaranteed'),
          _QuickStat('💳', 'M-Pesa', 'Easy pay'),
        ]))),

      // Categories
      SliverToBoxAdapter(child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionHeader(title: 'Categories'),
          SizedBox(height: 44, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 20),
            children: MockData.categories.map((c) {
              final active = c == cat;
              return GestureDetector(
                onTap: () => ref.read(categoryFilterProvider.notifier).state = c,
                child: Container(margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
                  child: Text(c, style: TextStyle(color: active ? Colors.white : AppColors.textGrey, fontWeight: FontWeight.w600, fontSize: 13))));
            }).toList())),
        ]))),

      // Products grid
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        sliver: filtered.isEmpty
          ? const SliverToBoxAdapter(child: EmptyState(emoji:'🥦', title:'No products found', subtitle:'Try a different category'))
          : SliverGrid(
              delegate: SliverChildBuilderDelegate((ctx, i) {
                final p = filtered[i];
                return ProductCard(product: p, onTap: () => context.push('/product/${p.id}'));
              }, childCount: filtered.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.62))),
    ]);
  }
}

class _QuickStat extends StatelessWidget {
  final String emoji, title, sub;
  const _QuickStat(this.emoji, this.title, this.sub);
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(right: 12),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(emoji, style: const TextStyle(fontSize: 22)),
      const SizedBox(width: 8),
      Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textDark)),
        Text(sub, style: const TextStyle(fontSize: 10, color: AppColors.textGrey)),
      ]),
    ]));
}

// ── Search Tab ────────────────────────────────────────────────────
class _SearchTab extends ConsumerStatefulWidget {
  const _SearchTab();
  @override
  ConsumerState<_SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends ConsumerState<_SearchTab> {
  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final q = ref.watch(searchQueryProvider);
    final filtered = ref.watch(filteredProductsProvider);

    return SafeArea(child: Column(children: [
      Padding(padding: const EdgeInsets.all(20), child: Column(children: [
        Text('Search', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 16),
        TextField(
          controller: _ctrl,
          onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
          decoration: InputDecoration(
            hintText: 'Search products, categories...',
            prefixIcon: const Icon(Icons.search, color: AppColors.textGrey),
            suffixIcon: q.isNotEmpty ? GestureDetector(onTap: () { _ctrl.clear(); ref.read(searchQueryProvider.notifier).state = ''; },
              child: const Icon(Icons.clear, color: AppColors.textGrey)) : null)),
      ])),
      Expanded(child: q.isEmpty
        ? _SearchSuggestions(onTap: (s) { _ctrl.text = s; ref.read(searchQueryProvider.notifier).state = s; })
        : GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.62),
            itemCount: filtered.length,
            itemBuilder: (_, i) => ProductCard(product: filtered[i], onTap: () => context.push('/product/${filtered[i].id}')))),
    ]));
  }
}

class _SearchSuggestions extends StatelessWidget {
  final void Function(String) onTap;
  const _SearchSuggestions({required this.onTap});
  @override
  Widget build(BuildContext context) {
    final suggestions = ['Avocado','Tomatoes','Chicken','Milk','Rice','Mango','Eggs','Fish'];
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Popular searches', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 12),
        Wrap(spacing: 10, runSpacing: 10, children: suggestions.map((s) =>
          GestureDetector(onTap: () => onTap(s),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
              child: Text(s, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))))).toList()),
      ]));
  }
}

// ── Cart Tab ──────────────────────────────────────────────────────
class _CartTab extends ConsumerWidget {
  const _CartTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);

    return SafeArea(child: Column(children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('My Cart 🛒', style: Theme.of(context).textTheme.displaySmall),
        if (cart.isNotEmpty) TextButton(onPressed: () => notifier.clear(), child: const Text('Clear', style: TextStyle(color: AppColors.error))),
      ])),
      Expanded(child: cart.isEmpty
        ? const EmptyState(emoji:'🛒', title:'Cart is empty', subtitle:'Add some fresh products to get started!')
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: cart.length,
            itemBuilder: (_, i) {
              final item = cart[i];
              return Container(margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
                child: Row(children: [
                  Container(width: 60, height: 60, decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(14)),
                    child: Center(child: Text(item.product.emoji, style: const TextStyle(fontSize: 30)))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    Text(item.product.unit, style: const TextStyle(color: AppColors.textGrey, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(formatTZS(item.product.price), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: 14)),
                  ])),
                  Row(children: [
                    _CartQtyBtn(icon: Icons.remove, onTap: () => notifier.remove(item.product.id)),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15))),
                    _CartQtyBtn(icon: Icons.add, dark: true, onTap: () => notifier.add(item.product)),
                  ]),
                ]));
            })),
      if (cart.isNotEmpty) Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, -4))]),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Subtotal', style: TextStyle(color: AppColors.textGrey)),
            Text(formatTZS(notifier.subtotal), style: const TextStyle(fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 6),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Delivery', style: TextStyle(color: AppColors.textGrey)),
            Text(notifier.deliveryFee == 0 ? 'FREE' : formatTZS(notifier.deliveryFee),
              style: TextStyle(fontWeight: FontWeight.w600, color: notifier.deliveryFee == 0 ? AppColors.success : AppColors.textDark)),
          ]),
          const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider()),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Total', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            Text(formatTZS(notifier.total), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.primary)),
          ]),
          const SizedBox(height: 14),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () => context.push('/checkout'),
            child: const Text('Proceed to Checkout'))),
        ])),
    ]));
  }
}

class _CartQtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool dark;
  const _CartQtyBtn({required this.icon, required this.onTap, this.dark = false});
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap,
    child: Container(width: 30, height: 30,
      decoration: BoxDecoration(color: dark ? AppColors.primary : AppColors.background, borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, size: 16, color: dark ? Colors.white : AppColors.textDark)));
}

// ── Wishlist Tab ──────────────────────────────────────────────────
class _WishlistTab extends ConsumerWidget {
  const _WishlistTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wish = ref.watch(wishlistProvider);
    return SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Text('Saved Items ❤️', style: Theme.of(context).textTheme.displaySmall)),
      Expanded(child: wish.isEmpty
        ? const EmptyState(emoji:'❤️', title:'No saved items', subtitle:'Tap the heart on any product to save it here.')
        : GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.62),
            itemCount: wish.length,
            itemBuilder: (_, i) => ProductCard(product: wish[i], onTap: () => context.push('/product/${wish[i].id}')))),
    ]));
  }
}

// ── Profile Tab ───────────────────────────────────────────────────
class _ProfileTab extends ConsumerWidget {
  const _ProfileTab();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    if (user == null) return const Center(child: CircularProgressIndicator());
    final orders = ref.watch(ordersProvider);
    final myOrders = orders.where((o) => o.userId == user.id).toList();

    return SafeArea(child: SingleChildScrollView(child: Column(children: [
      // Header
      Container(margin: const EdgeInsets.all(20), padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF43A047)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(24)),
        child: Row(children: [
          Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: Center(child: Text(user.name[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700)))),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(user.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
            Text(user.email, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
            const SizedBox(height: 4),
            Text(user.phone.isNotEmpty ? user.phone : 'No phone added', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
          ])),
        ])),

      // Stats
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(children: [
          _StatCard('${myOrders.length}', 'Orders'),
          const SizedBox(width: 12),
          _StatCard(formatTZS(myOrders.fold(0.0, (s, o) => s + o.total)), 'Spent'),
          const SizedBox(width: 12),
          _StatCard('${ref.watch(wishlistProvider).length}', 'Saved'),
        ])),

      const SizedBox(height: 16),
      _MenuItem(icon: Icons.receipt_long_outlined, label: 'My Orders', onTap: () => context.push('/orders')),
      _MenuItem(icon: Icons.location_on_outlined, label: 'Delivery Address', onTap: () => _editAddress(context, ref, user.address)),
      _MenuItem(icon: Icons.notifications_outlined, label: 'Notifications', badge: ref.watch(notificationsProvider.notifier).unread, onTap: () => context.push('/notifications')),
      _MenuItem(icon: Icons.help_outline, label: 'Help & Support', onTap: () {}),
      _MenuItem(icon: Icons.info_outline, label: 'About Twende Markiti', onTap: () {}),
      const SizedBox(height: 8),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        child: SizedBox(width: double.infinity, child: ElevatedButton.icon(
          onPressed: () { ref.read(authProvider.notifier).logout(); context.go('/login'); },
          icon: const Icon(Icons.logout),
          label: const Text('Sign Out'),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white)))),
      const SizedBox(height: 24),
    ])));
  }

  void _editAddress(BuildContext context, WidgetRef ref, String current) {
    final ctrl = TextEditingController(text: current);
    showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Delivery Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'Enter your delivery address', prefixIcon: Icon(Icons.location_on_outlined))),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () { ref.read(authProvider.notifier).updateAddress(ctrl.text); Navigator.pop(context); },
            child: const Text('Save Address'))),
        ])));
  }
}

class _StatCard extends StatelessWidget {
  final String value, label;
  const _StatCard(this.value, this.label);
  @override
  Widget build(BuildContext context) => Expanded(child: Container(
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
    child: Column(children: [
      Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.textDark), maxLines: 1, overflow: TextOverflow.ellipsis),
      const SizedBox(height: 2),
      Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
    ])));
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final int badge;
  const _MenuItem({required this.icon, required this.label, required this.onTap, this.badge = 0});
  @override
  Widget build(BuildContext context) => GestureDetector(onTap: onTap,
    child: Container(margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4), padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)]),
      child: Row(children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 14),
        Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14))),
        if (badge > 0) Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(10)),
          child: Text('$badge', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
        const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textLight),
      ])));
}