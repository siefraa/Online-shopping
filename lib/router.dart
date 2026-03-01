import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'providers/providers.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/customer/home_screen.dart';
import 'screens/customer/product_detail_screen.dart';
import 'screens/customer/checkout_screen.dart';
import 'screens/customer/order_success_screen.dart';
import 'screens/customer/orders_screen.dart';
import 'screens/customer/notifications_screen.dart';
import 'screens/admin/admin_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/product/:id', builder: (_, s) => ProductDetailScreen(productId: s.pathParameters['id']!)),
      GoRoute(path: '/checkout', builder: (_, __) => const CheckoutScreen()),
      GoRoute(path: '/order-success/:id', builder: (_, s) => OrderSuccessScreen(orderId: s.pathParameters['id']!)),
      GoRoute(path: '/orders', builder: (_, __) => const OrdersScreen()),
      GoRoute(path: '/notifications', builder: (_, __) => const NotificationsScreen()),
      GoRoute(path: '/admin', builder: (_, __) => const AdminShell()),
    ],
  );
});