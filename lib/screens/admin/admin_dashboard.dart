import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/providers.dart';
import '../../utils/app_theme.dart';

/// IMPORTANT FIX
enum OrderStatus {
  pending,
  processing,
  delivered,
  cancelled,
}

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersNotifier = ref.read(ordersProvider.notifier);
    final orders = ref.watch(ordersProvider);
    final products = ref.watch(productsProvider);
    final customers = ref.watch(customersProvider);

    final delivered =
        orders.where((o) => o.status == OrderStatus.delivered).length;

    final revenue = ordersNotifier.totalRevenue;
    final pending = ordersNotifier.pendingCount;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.adminPrimary,
                    AppColors.adminAccent
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Admin Panel',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13),
                      ),
                      Text(
                        'Twende Markiti',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '👨‍💼',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ],
              ),
            ),

            /// STATS
            Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                children: [
                  _StatCard(
                    'Total Revenue',
                    formatTZS(revenue),
                    '📈',
                    const Color(0xFF1B5E20),
                    '${orders.length} orders',
                  ),
                  _StatCard(
                    'Pending Orders',
                    '$pending',
                    '🕐',
                    const Color(0xFFE65100),
                    'Need attention',
                  ),
                  _StatCard(
                    'Products',
                    '${products.length}',
                    '🛒',
                    const Color(0xFF0D47A1),
                    '${products.where((p) => p.stock < 10).length} low stock',
                  ),
                  _StatCard(
                    'Customers',
                    '${customers.length}',
                    '👥',
                    const Color(0xFF6A1B9A),
                    '$delivered completed',
                  ),
                ],
              ),
            ),

            /// CHART TITLE
            const Padding(
              padding:
                  EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Text(
                'Revenue (Last 7 Days)',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15),
              ),
            ),

            /// CHART
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                  )
                ],
              ),
              child: LineChart(
                LineChartData(
                  gridData:
                      const FlGridData(show: false),
                  borderData:
                      FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, m) {
                          const days = [
                            'M',
                            'T',
                            'W',
                            'T',
                            'F',
                            'S',
                            'S'
                          ];
                          return Text(
                            days[v.toInt()],
                            style:
                                const TextStyle(
                              fontSize: 10,
                              color:
                                  AppColors.textGrey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 15000),
                        FlSpot(1, 28000),
                        FlSpot(2, 22000),
                        FlSpot(3, 45000),
                        FlSpot(4, 31000),
                        FlSpot(5, 58000),
                        FlSpot(6, 42000),
                      ],
                      isCurved: true,
                      color:
                          AppColors.adminPrimary,
                      barWidth: 3,
                      dotData:
                          const FlDotData(
                              show: false),
                      belowBarData:
                          BarAreaData(
                        show: true,
                        color: AppColors
                            .adminPrimary
                            .withOpacity(0.08),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/// STAT CARD
class _StatCard extends StatelessWidget {
  final String title, value, emoji, sub;
  final Color color;

  const _StatCard(
      this.title, this.value, this.emoji, this.color, this.sub);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.04),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                emoji,
                style:
                    const TextStyle(fontSize: 22),
              ),
              Container(
                padding:
                    const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color:
                      color.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.trending_up,
                  size: 14,
                  color: color,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontWeight:
                  FontWeight.w600,
              fontSize: 12,
              color:
                  AppColors.textDark,
            ),
          ),
          Text(
            sub,
            style: const TextStyle(
              fontSize: 10,
              color:
                  AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}