import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_colors.dart';
import '../../categories/controllers/category_controller.dart';
import '../controllers/dashboard_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<DashboardController>();
    final catCtrl = Get.find<CategoryController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Dashboard Overview',
          style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: const Text('A',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, Color(0xFFFF6D00)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.primary.withOpacity(0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6))
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Welcome back, Admin! 👋",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text("Manage your school uniform marketplace",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 13)),
                        ],
                      ),
                    ),
                    const Icon(Icons.school_rounded,
                        color: Colors.white, size: 52),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Stats Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  double ratio;

                  if (constraints.maxWidth > 1200) {
                    ratio = 2.6; // large desktop
                  } else if (constraints.maxWidth > 900) {
                    ratio = 2.2; // normal desktop
                  } else if (constraints.maxWidth > 600) {
                    ratio = 1.8; // tablet
                  } else {
                    ratio = 1.4; // mobile
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 260,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: ratio,
                    ),
                    itemCount: 8,
                    itemBuilder: (_, i) {
                      final stats = [
                        _statCard(
                            "Total Products",
                            ctrl.totalProducts.value.toString(),
                            Icons.inventory_2_rounded,
                            AppColors.primary),
                        _statCard(
                            "Total Orders",
                            ctrl.totalOrders.value.toString(),
                            Icons.shopping_cart_rounded,
                            AppColors.secondary),
                        _statCard(
                            "Revenue",
                            "₹${(ctrl.totalRevenue.value / 1000).toStringAsFixed(1)}K",
                            Icons.currency_rupee_rounded,
                            const Color(0xFF4CAF50)),
                        _statCard("Users", ctrl.totalUsers.value.toString(),
                            Icons.people_rounded, const Color(0xFF9C27B0)),
                        _statCard(
                            "New Items",
                            ctrl.newItemsCount.value.toString(),
                            Icons.fiber_new_rounded,
                            AppColors.primary),
                        _statCard(
                            "Used Items",
                            ctrl.usedItemsCount.value.toString(),
                            Icons.recycling_rounded,
                            const Color(0xFF795548)),
                        _statCard(
                            "Categories",
                            catCtrl.totalCategories.toString(),
                            Icons.category_rounded,
                            AppColors.secondary),
                        _statCard(
                            "Pending Orders",
                            ctrl.pendingOrders.value.toString(),
                            Icons.pending_actions_rounded,
                            const Color(0xFFFFC107)),
                      ];

                      return stats[i];
                    },
                  );
                },
              ),
              const SizedBox(height: 28),

              // Category Quick Summary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Category Summary",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  TextButton.icon(
                    onPressed: () =>
                        Get.find<DashboardController>().selectedIndex.value = 1,
                    icon: const Icon(Icons.arrow_forward_rounded,
                        size: 16, color: AppColors.primary),
                    label: const Text("View All",
                        style: TextStyle(color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() {
                final cats = catCtrl.categories;
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cats.length > 6 ? 6 : cats.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final cat = cats[i];
                    final total = cat.subCategories.fold(
                        0,
                        (s, sub) =>
                            s +
                            sub.sections
                                .fold(0, (s2, sec) => s2 + sec.productCount));
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(cat.icon, style: const TextStyle(fontSize: 28)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(cat.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: AppColors.textPrimary)),
                                Text(
                                    "${cat.subCategories.length} subcategories",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("$total items",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary)),
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                width: 80,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: (total / 150).clamp(0.05, 1.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      constraints: const BoxConstraints(minHeight: 110),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),

          const SizedBox(width: 12),

          // ⭐ IMPORTANT FIX
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
