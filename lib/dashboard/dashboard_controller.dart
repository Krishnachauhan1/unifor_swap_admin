import 'package:get/get.dart';
import 'package:uniform_swap_admin/api_calls.dart';
import 'package:uniform_swap_admin/apis.dart';

class DashboardController extends GetxController {
  var isLoading = false.obs;
  var totalProducts = 0.obs;
  var totalCategories = 0.obs;
  var totalSchools = 0.obs;
  var totalOrders = 0.obs;
  var totalRevenue = 0.0.obs;
  var pendingOrders = 0.obs;
  var lowStockProducts = 0.obs;
  var activeUsers = 0.obs;
  var recentOrders = <Map<String, dynamic>>[].obs;

  // Predefined school categories with full hierarchy

  @override
  void onInit() {
    super.onInit();
    fetchStats();
  }

  Future<void> fetchStats() async {
    try {
      isLoading.value = true;




      final res = await ApiService.get(dashboardApi);








      if (res != null && res['data'] != null) {
        final data = res['data'];
        totalProducts.value = data['total_products'] ?? 0;
        totalCategories.value = data['total_categories'] ?? 0;
        totalSchools.value = data['total_schools'] ?? 0;
        totalOrders.value = data['total_orders'] ?? 0;
        totalRevenue.value = double.tryParse(data['total_revenue']?.toString() ?? '0') ?? 0;
        pendingOrders.value = data['pending_orders'] ?? 0;
        lowStockProducts.value = data['low_stock'] ?? 0;
        activeUsers.value = data['active_users'] ?? 0;
        recentOrders.value = List<Map<String, dynamic>>.from(data['recent_orders'] ?? []);
      }
    } catch (e) {
      // Use mock data if API fails
      totalProducts.value = 248;
      totalCategories.value = 11;
      totalSchools.value = 34;
      totalOrders.value = 1290;
      totalRevenue.value = 542350;
      pendingOrders.value = 18;
      lowStockProducts.value = 7;
      activeUsers.value = 423;
    } finally {
      isLoading.value = false;
    }
  }
}
