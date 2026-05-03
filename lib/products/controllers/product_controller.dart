import 'package:get/get.dart';
import 'package:uniform_swap_admin/api_calls.dart';
import 'package:uniform_swap_admin/apis.dart';
import 'package:uniform_swap_admin/products/models/product_model.dart';

class ProductController extends GetxController {

  List<ProductModel> products = [];
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    getProducts();
  }

  Future<void> getProducts() async {
    try {
      isLoading = true;
      update(); // 🔥 refresh UI

      final res = await ApiService.get(schoolItemsApi);
      print('product list $res');

      if (res['success'] == true) {
        final List list = res['data'];
        products =
            list.map((e) => ProductModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading = false;
      update(); // 🔥 refresh UI again
    }
  }

  Future<void> approveProduct(int id) async {
    try {
      isLoading = true;
      update();

      final res = await ApiService.patch(
          "school-items/$id/approve",
          {'is_approved':true}
      );
      print('error is $res');


      if (res['success'] == true) {
        products.removeWhere((p) => p.id == id);
        Get.snackbar("Success", "Product Approved");
      }
    } catch (e) {
      print('error is $e');
      print("Approve Error: $e");
    } finally {
      isLoading = false;
      update();
    }
  }

  
}