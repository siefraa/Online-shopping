import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_theme.dart';
import 'admin_dashboard.dart';
import 'admin_products.dart';
import 'admin_orders.dart';
import 'admin_customers.dart';
import 'admin_settings.dart';

class AdminShell extends ConsumerStatefulWidget {
  const AdminShell({super.key});
  @override
  ConsumerState<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends ConsumerState<AdminShell> {
  int _tab = 0;
  final _pages = const [AdminDashboard(), AdminProductsScreen(), AdminOrdersScreen(), AdminCustomersScreen(), AdminSettingsScreen()];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: _pages[_tab],
    bottomNavigationBar: NavigationBar(
      selectedIndex: _tab,
      onDestinationSelected: (i) => setState(() => _tab = i),
      backgroundColor: Colors.white,
      indicatorColor: AppColors.adminPrimary.withOpacity(0.1),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
        NavigationDestination(icon: Icon(Icons.inventory_2_outlined), selectedIcon: Icon(Icons.inventory_2), label: 'Products'),
        NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long), label: 'Orders'),
        NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Customers'),
        NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Settings'),
      ]));
}