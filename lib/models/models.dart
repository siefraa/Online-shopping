class Product {
  final String id, name, description, category, unit, emoji, badge;
  final double price, rating;
  final double? originalPrice;
  final int reviews, stock;
  final bool isActive;
  final DateTime createdAt;

  Product({
    required this.id, required this.name, required this.description,
    required this.price, this.originalPrice, required this.category,
    required this.unit, required this.emoji, this.rating = 4.5,
    this.reviews = 0, this.stock = 100, this.badge = '',
    this.isActive = true, DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  double get discount => originalPrice != null ? ((originalPrice! - price) / originalPrice! * 100) : 0;

  Product copyWith({String? name, String? description, double? price,
    double? originalPrice, String? category, String? unit, String? emoji,
    double? rating, int? reviews, int? stock, String? badge, bool? isActive}) {
    return Product(id: id, name: name ?? this.name, description: description ?? this.description,
      price: price ?? this.price, originalPrice: originalPrice ?? this.originalPrice,
      category: category ?? this.category, unit: unit ?? this.unit, emoji: emoji ?? this.emoji,
      rating: rating ?? this.rating, reviews: reviews ?? this.reviews, stock: stock ?? this.stock,
      badge: badge ?? this.badge, isActive: isActive ?? this.isActive, createdAt: createdAt);
  }
}

class CartItem {
  final Product product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
  double get total => product.price * quantity;
}

class AppUser {
  final String id, name, email, phone, role;
  String address;
  final DateTime joinedAt;
  double totalSpent;
  int totalOrders;
  AppUser({required this.id, required this.name, required this.email,
    required this.phone, this.address = '', this.role = 'customer',
    DateTime? joinedAt, this.totalSpent = 0, this.totalOrders = 0})
      : joinedAt = joinedAt ?? DateTime.now();
}

enum OrderStatus { pending, confirmed, preparing, outForDelivery, delivered, cancelled }

extension OrderStatusExt on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending: return 'Pending';
      case OrderStatus.confirmed: return 'Confirmed';
      case OrderStatus.preparing: return 'Preparing';
      case OrderStatus.outForDelivery: return 'Out for Delivery';
      case OrderStatus.delivered: return 'Delivered';
      case OrderStatus.cancelled: return 'Cancelled';
    }
  }
  String get emoji {
    switch (this) {
      case OrderStatus.pending: return '🕐';
      case OrderStatus.confirmed: return '✅';
      case OrderStatus.preparing: return '👨‍🍳';
      case OrderStatus.outForDelivery: return '🚚';
      case OrderStatus.delivered: return '🎉';
      case OrderStatus.cancelled: return '❌';
    }
  }
}

class OrderItem {
  final Product product;
  final int quantity;
  final double price;
  OrderItem({required this.product, required this.quantity, required this.price});
  double get total => price * quantity;
}

class AppOrder {
  final String id, userId, userName, userPhone, deliveryAddress, paymentMethod;
  final List<OrderItem> items;
  final double subtotal, deliveryFee, total;
  OrderStatus status;
  final DateTime createdAt;
  String? notes;
  AppOrder({
    required this.id, required this.userId, required this.userName,
    required this.userPhone, required this.items, required this.subtotal,
    required this.deliveryFee, required this.total, required this.deliveryAddress,
    required this.paymentMethod, this.status = OrderStatus.pending,
    DateTime? createdAt, this.notes,
  }) : createdAt = createdAt ?? DateTime.now();
}

class AppNotification {
  final String id, title, message, type;
  bool isRead;
  final DateTime createdAt;
  AppNotification({required this.id, required this.title, required this.message,
    required this.type, this.isRead = false, DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();
}

class Review {
  final String id, userId, userName, productId, comment;
  final double rating;
  final DateTime createdAt;
  Review({required this.id, required this.userId, required this.userName,
    required this.productId, required this.rating, required this.comment,
    DateTime? createdAt}) : createdAt = createdAt ?? DateTime.now();
}