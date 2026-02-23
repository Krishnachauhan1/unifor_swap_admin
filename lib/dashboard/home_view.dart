import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniform_swap_admin/app_colors.dart';
import 'package:uniform_swap_admin/dashboard/dashboard_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DashboardController>();
    final isWide = MediaQuery.of(context).size.width > 1100;
    final isMedium = MediaQuery.of(context).size.width > 600;

    return Obx(() {
      if (c.isLoading.value) {
        return const Center(
            child: CircularProgressIndicator(color: AppColors.primary));
      }

      return RefreshIndicator(
        onRefresh: c.fetchStats,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE65100), AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome back, Admin! 👋',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Here\'s what\'s happening with your store today.',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.storefront,
                        color: Colors.white30, size: 60),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Stats row
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isWide
                    ? 4
                    : isMedium
                        ? 2
                        : 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: isWide ? 1.6 : 1.4,
                children: [
                  _StatCard(
                    icon: Icons.inventory_2,
                    label: 'Products',
                    value: c.totalProducts.value.toString(),
                    color: AppColors.primary,
                    subtitle: '${c.lowStockProducts.value} low stock',
                    subtitleColor: AppColors.warning,
                  ),
                  _StatCard(
                    icon: Icons.school,
                    label: 'Schools',
                    value: c.totalSchools.value.toString(),
                    color: AppColors.secondary,
                    subtitle: 'Registered',
                    subtitleColor: AppColors.textSecondary,
                  ),
                  _StatCard(
                    icon: Icons.receipt_long,
                    label: 'Orders',
                    value: c.totalOrders.value.toString(),
                    color: const Color(0xFF3F51B5),
                    subtitle: '${c.pendingOrders.value} pending',
                    subtitleColor: AppColors.pending,
                  ),
                  _StatCard(
                    icon: Icons.currency_rupee,
                    label: 'Revenue',
                    value: '₹${_formatNum(c.totalRevenue.value.toInt())}',
                    color: AppColors.success,
                    subtitle: 'Total earnings',
                    subtitleColor: AppColors.textSecondary,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Category overview
              const Text(
                'Category Overview',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
              const SizedBox(height: 14),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isWide
                    ? 4
                    : isMedium
                        ? 3
                        : 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
                children: c.schoolCategories.map((cat) {
                  return _CategoryTile(
                    emoji: cat['icon'],
                    name: cat['name'],
                    count: (cat['subCategories'] as List).length,
                    color: Color(cat['color']),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Quick actions
              const Text(
                'Quick Actions',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _QuickAction(
                      icon: Icons.add_box,
                      label: 'Add Product',
                      color: AppColors.primary),
                  _QuickAction(
                      icon: Icons.add_business,
                      label: 'Add School',
                      color: AppColors.secondary),
                  _QuickAction(
                      icon: Icons.category,
                      label: 'Add Category',
                      color: const Color(0xFF3F51B5)),
                  _QuickAction(
                      icon: Icons.download,
                      label: 'Export Data',
                      color: AppColors.success),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  String _formatNum(int n) {
    if (n >= 100000) return '${(n / 100000).toStringAsFixed(1)}L';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final String subtitle;
  final Color subtitleColor;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.subtitle,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),

          Spacer(),

          // Text Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 1),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: subtitleColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String emoji;
  final String name;
  final int count;
  final Color color;

  const _CategoryTile(
      {required this.emoji,
      required this.name,
      required this.count,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '$count subcategories',
                  style: TextStyle(
                      fontSize: 10, color: color, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickAction(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(label,
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.w600, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
