import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

// ── Auth ─────────────────────────────────────────────────────────
final authProvider = StateNotifierProvider<AuthNotifier, AppUser?>((ref) => AuthNotifier());

class AuthNotifier extends StateNotifier<AppUser?> {
  AuthNotifier() : super(null);

  bool login(String email, String password) {
    if (email == 'admin@twende.co.tz' && password == 'admin123') {
      state = AppUser(id:'admin',name:'Admin Twende',email:email,phone:'+255700000000',role:'admin');
      return true;
    }
    final user = MockData.customers.where((u) => u.email == email).firstOrNull;
    if (user != null) { state = user; return true; }
    if (email.isNotEmpty && password.length >= 6) {
      state = AppUser(id:'u_new',name:email.split('@')[0],email:email,phone:'',role:'customer');
      return true;
    }
    return false;
  }

  void register(String name, String email, String phone, String password) {
    state = AppUser(id:'u_${DateTime.now().millisecondsSinceEpoch}',name:name,email:email,phone:phone,role:'customer');
  }

  void logout() => state = null;
  void updateAddress(String address) { if (state != null) state = AppUser(id:state!.id,name:state!.name,email:state!.email,phone:state!.phone,address:address,role:state!.role,joinedAt:state!.joinedAt,totalSpent:state!.totalSpent,totalOrders:state!.totalOrders); }
}

// ── Products ─────────────────────────────────────────────────────
final productsProvider = StateNotifierProvider<ProductsNotifier, List<Product>>((ref) => ProductsNotifier());

class ProductsNotifier extends StateNotifier<List<Product>> {
  ProductsNotifier() : super(MockData.products);

  void addProduct(Product p) => state = [...state, p];
  void updateProduct(Product p) => state = state.map((e) => e.id == p.id ? p : e).toList();
  void deleteProduct(String id) => state = state.where((e) => e.id != id).toList();
  void toggleActive(String id) => state = state.map((e) => e.id == id ? e.copyWith(isActive: !e.isActive) : e).toList();
}

final categoryFilterProvider = StateProvider<String>((ref) => 'All');
final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productsProvider);
  final cat = ref.watch(categoryFilterProvider);
  final q = ref.watch(searchQueryProvider).toLowerCase();
  return products.where((p) {
    if (!p.isActive) return false;
    final matchCat = cat == 'All' || p.category == cat;
    final matchQ = q.isEmpty || p.name.toLowerCase().contains(q) || p.category.toLowerCase().contains(q);
    return matchCat && matchQ;
  }).toList();
});

// ── Cart ──────────────────────────────────────────────────────────
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) => CartNotifier());

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void add(Product p) {
    final idx = state.indexWhere((e) => e.product.id == p.id);
    if (idx >= 0) { if (idx >= 0) {
  final updated = [...state];
  updated[idx].quantity++;
  state = updated;
} } 
    else { state = [...state, CartItem(product: p)]; }
  }

  void remove(String id) {
    final idx = state.indexWhere((e) => e.product.id == id);
    if (idx < 0) return;
    final updated = [...state];
    if (updated[idx].quantity > 1) updated[idx].quantity--;
    else updated.removeAt(idx);
    state = updated;
  }

  void removeAll(String id) => state = state.where((e) => e.product.id != id).toList();
  void clear() => state = [];

  double get subtotal => state.fold(0, (s, e) => s + e.total);
  double get deliveryFee => state.isEmpty ? 0 : (subtotal >= 20000 ? 0 : 2000);
  double get total => subtotal + deliveryFee;
  int get itemCount => state.fold(0, (s, e) => s + e.quantity);
}

final cartCountProvider = Provider<int>((ref) => ref.watch(cartProvider.notifier).itemCount);

// ── Orders ────────────────────────────────────────────────────────
final ordersProvider = StateNotifierProvider<OrdersNotifier, List<AppOrder>>((ref) => OrdersNotifier());

class OrdersNotifier extends StateNotifier<List<AppOrder>> {
  OrdersNotifier() : super(MockData.generateOrders());

  void addOrder(AppOrder order) => state = [order, ...state];
  void updateStatus(String id, OrderStatus status) =>
      state = state.map((e) => e.id == id ? (e..status = status) : e).toList();
  void cancelOrder(String id) => updateStatus(id, OrderStatus.cancelled);

  List<AppOrder> ordersForUser(String userId) => state.where((o) => o.userId == userId).toList();
  double get totalRevenue => state.where((o) => o.status == OrderStatus.delivered).fold(0, (s, e) => s + e.total);
  int get pendingCount => state.where((o) => o.status == OrderStatus.pending).length;
  int get todayOrderCount => state.where((o) => o.createdAt.day == DateTime.now().day).length;
}

// ── Wishlist ──────────────────────────────────────────────────────
final wishlistProvider = StateNotifierProvider<WishlistNotifier, List<Product>>((ref) => WishlistNotifier());

class WishlistNotifier extends StateNotifier<List<Product>> {
  WishlistNotifier() : super([]);
  void toggle(Product p) {
    if (state.any((e) => e.id == p.id)) state = state.where((e) => e.id != p.id).toList();
    else state = [...state, p];
  }
  bool contains(String id) => state.any((e) => e.id == id);
}

// ── Notifications ─────────────────────────────────────────────────
final notificationsProvider = StateNotifierProvider<NotifNotifier, List<AppNotification>>((ref) => NotifNotifier());
class NotifNotifier extends StateNotifier<List<AppNotification>> {
  NotifNotifier() : super(MockData.notifications);
  void markRead(String id) => state = state.map((n) => n.id == id ? (n..isRead = true) : n).toList();
  void markAllRead() => state = state.map((n) => n..isRead = true).toList();
  int get unread => state.where((n) => !n.isRead).length;
}

// ── Customers (admin) ─────────────────────────────────────────────
final customersProvider = StateNotifierProvider<CustomersNotifier, List<AppUser>>((ref) => CustomersNotifier());
class CustomersNotifier extends StateNotifier<List<AppUser>> {
  CustomersNotifier() : super(MockData.customers);
}

// ── Reviews ───────────────────────────────────────────────────────
final reviewsProvider = StateProvider<List<Review>>((ref) => MockData.reviews);