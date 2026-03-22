import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniform_swap_admin/advertisement/advertisement_screen.dart';
import 'package:uniform_swap_admin/app_colors.dart';
import 'package:uniform_swap_admin/authentication/controllers/auth_controller.dart';
import 'package:uniform_swap_admin/categories/views/categories_view.dart';
import 'package:uniform_swap_admin/dashboard/dashboard_controller.dart';
import 'package:uniform_swap_admin/dashboard/home_view.dart';
import 'package:uniform_swap_admin/products/views/product_list_view.dart';
import 'package:uniform_swap_admin/schools/views/schools_view.dart' hide AppColors;

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final dashController = Get.put(DashboardController());
  final authController = Get.find<AuthController>();
  int _selectedIndex = 0;
  bool _sidebarExpanded = true;

  final List<_NavItem> navItems = [
    _NavItem(
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard,
        label: 'Dashboard'),
    _NavItem(
        icon: Icons.inventory_2_outlined,
        selectedIcon: Icons.inventory_2,
        label: 'Products'),
    _NavItem(
        icon: Icons.category_outlined,
        selectedIcon: Icons.category,
        label: 'Categories'),
    _NavItem(
        icon: Icons.school_outlined,
        selectedIcon: Icons.school,
        label: 'Schools'),
    _NavItem(
        icon: Icons.campaign_outlined,
        selectedIcon: Icons.campaign,
        label: 'Advertisement'),
  ];

  List<Widget> get _pages => [
        const HomeView(),
         ProductsScreen(),
        const CategoriesView(),
        const SchoolsView(),
        const AdvertisementScreen(),
      ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    if (!isWide) return _mobileLayout();

    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(child: _pages[_selectedIndex]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    final width = _sidebarExpanded ? 240.0 : 72.0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(2, 0))
        ],
      ),
      child: Column(
        children: [
          // Logo area
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFE65100), AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.school, color: Colors.white, size: 28),
                if (_sidebarExpanded) ...[
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('UniformSwap',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        Text('Admin',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Nav items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                for (int i = 0; i < navItems.length; i++)
                  _buildNavItem(navItems[i], i),
              ],
            ),
          ),

          // Collapse button & logout
          const Divider(color: Colors.white12, height: 1),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                InkWell(
                  onTap: () =>
                      setState(() => _sidebarExpanded = !_sidebarExpanded),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: _sidebarExpanded
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.center,
                      children: [
                        Icon(
                          _sidebarExpanded
                              ? Icons.chevron_left
                              : Icons.chevron_right,
                          color: Colors.white54,
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: authController.logout,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Icon(Icons.logout,
                            color: Colors.white54, size: 20),
                        if (_sidebarExpanded) ...[
                          const SizedBox(width: 12),
                          const Text('Logout',
                              style: TextStyle(
                                  color: Colors.white54, fontSize: 13)),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(_NavItem item, int index) {
    final isSelected = _selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(
                    color: AppColors.primary.withOpacity(0.3), width: 1)
                : null,
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? item.selectedIcon : item.icon,
                color: isSelected ? AppColors.primary : Colors.white54,
                size: 22,
              ),
              if (_sidebarExpanded) ...[
                const SizedBox(width: 14),
                Text(
                  item.label,
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : Colors.white54,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          Text(
            navItems[_selectedIndex].label,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.admin_panel_settings,
                    color: AppColors.primary, size: 16),
                SizedBox(width: 6),
                Text('Admin',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Text(navItems[_selectedIndex].label),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: authController.logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primary.withOpacity(0.15),
        destinations: navItems
            .map((item) => NavigationDestination(
                  icon: Icon(item.icon),
                  selectedIcon:
                      Icon(item.selectedIcon, color: AppColors.primary),
                  label: item.label,
                ))
            .toList(),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  _NavItem(
      {required this.icon, required this.selectedIcon, required this.label});
}
