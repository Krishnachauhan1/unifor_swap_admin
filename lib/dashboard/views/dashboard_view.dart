import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_colors.dart';
import '../../authentication/controllers/auth_controller.dart';
import '../../categories/controllers/category_controller.dart';
import '../../categories/views/category_view.dart';
import '../controllers/dashboard_controller.dart';
import 'home_view.dart';
import '../../products/views/product_list_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(DashboardController());
    Get.put(CategoryController());
    final authCtrl = Get.put(AuthController());

    final pages = [
      const HomeView(),
      const CategoryView(),
       ProductsScreen(),
    ];

    final navItems = [
      {'icon': Icons.dashboard_rounded, 'label': 'Dashboard'},
      {'icon': Icons.category_rounded, 'label': 'Categories'},
      {'icon': Icons.inventory_2_rounded, 'label': 'Products'},
    ];

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          return Row(
            children: [
              if (isWide)
                Obx(() => NavigationRail(
                  selectedIndex: ctrl.selectedIndex.value,
                  onDestinationSelected: (i) => ctrl.selectedIndex.value = i,
                  backgroundColor: Colors.white,
                  elevation: 4,
                  extended: constraints.maxWidth > 1100,
                  minWidth: 70,
                  minExtendedWidth: 220,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.school_rounded, color: Colors.white, size: 26),
                        ),
                        if (constraints.maxWidth > 1100) ...[
                          const SizedBox(height: 8),
                          const Text('UniformSwap', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
                          const Text('Admin', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ],
                    ),
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: InkWell(
                      onTap: authCtrl.logout,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.logout_rounded, color: AppColors.error, size: 22),
                      ),
                    ),
                  ),
                  destinations: navItems.map((item) => NavigationRailDestination(
                    icon: Icon(item['icon'] as IconData),
                    selectedIcon: Icon(item['icon'] as IconData, color: AppColors.primary),
                    label: Text(item['label'] as String),
                  )).toList(),
                )),
              if (isWide) const VerticalDivider(width: 1, thickness: 1),
              Expanded(
                child: Obx(() => pages[ctrl.selectedIndex.value]),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 700) return const SizedBox.shrink();
          return Obx(() => NavigationBar(
            selectedIndex: ctrl.selectedIndex.value,
            onDestinationSelected: (i) => ctrl.selectedIndex.value = i,
            backgroundColor: Colors.white,
            indicatorColor: AppColors.primary.withOpacity(0.15),
            destinations: navItems.map((item) => NavigationDestination(
              icon: Icon(item['icon'] as IconData, color: AppColors.textHint),
              selectedIcon: Icon(item['icon'] as IconData, color: AppColors.primary),
              label: item['label'] as String,
            )).toList(),
          ));
        },
      ),
    );
  }
}