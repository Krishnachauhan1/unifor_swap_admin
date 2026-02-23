import 'package:get/get.dart';

class DashboardController extends GetxController {
  var isLoading = false.obs;
  var selectedIndex = 0.obs;

  // Stats
  var totalProducts = 0.obs;
  var totalOrders = 0.obs;
  var totalRevenue = 0.0.obs;
  var totalUsers = 0.obs;
  var newItemsCount = 0.obs;
  var usedItemsCount = 0.obs;
  var pendingOrders = 0.obs;

  get lowStockProducts => null;

  get totalSchools => null;

  @override
  void onInit() {
    super.onInit();
    loadStats();
  }

  void loadStats() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 800), () {
      totalProducts.value = 1247;
      totalOrders.value = 342;
      totalRevenue.value = 285600.0;
      totalUsers.value = 890;
      newItemsCount.value = 720;
      usedItemsCount.value = 527;
      pendingOrders.value = 18;
      isLoading.value = false;
    });
  }
}
