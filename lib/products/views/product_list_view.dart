import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uniform_swap_admin/apis.dart';
import 'package:uniform_swap_admin/app_colors.dart';
import 'package:uniform_swap_admin/products/controllers/product_controller.dart';
import 'package:uniform_swap_admin/products/models/product_model.dart';

class ProductsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      init: ProductController(),
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text("School Items"),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          body: ctrl.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ctrl.products.isEmpty
              ? _emptyState()
              : GridView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: ctrl.products.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 1.85,
            ),
            itemBuilder: (context, index) {
              final product = ctrl.products[index];
              return _productCard(product, ctrl);
            },
          ),
        );
      },
    );
  }

  Widget _productCard(ProductModel product, ProductController ctrl) {
    final imageUrl = product.images.isNotEmpty ? imageBaseUrl + product.images.first : null;

    return GestureDetector(
      onTap: () => _openProductDialog(product, ctrl),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14)),
              child: imageUrl != null
                  ? Image.network(
                imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,

                /// 🔥 SHOW LOADING
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 120,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                },

                /// 🔥 SHOW PLACEHOLDER ON ERROR
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 120,
                    color: Colors.grey.shade200,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              )
                  : Container(
                height: 120,
                color: Colors.grey.shade200,
                child: const Center(
                  child: Icon(Icons.image, size: 40),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// TITLE
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  /// PRICE
                  Text(
                    "₹ ${product.price}",
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 6),

                  /// SCHOOL
                  Text(
                    product.schoolName ?? "",
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey),
                  ),

                  const SizedBox(height: 6),

                  /// STATUS BADGE
                  _statusBadge(product),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(ProductModel product) {
    if (product.isSold) {
      return _badge("Sold", Colors.red);
    }

    if (product.isApproved) {
      return _badge("Approved", Colors.green);
    }

    return _badge("Pending", Colors.orange);
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20)),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color),
      ),
    );
  }

  void _openProductDialog(ProductModel product, ProductController ctrl) {
    final PageController pageController = PageController();


    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔥 IMAGE SLIDER
              if (product.images.isNotEmpty)
                StatefulBuilder(
                  builder: (context, setState) {
                    int currentPage = 0;

                    return Column(
                      children: [
                        SizedBox(
                          height: 220,
                          child: PageView.builder(
                            controller: pageController,
                            itemCount: product.images.length,
                            onPageChanged: (index) {
                              currentPage = index;
                              setState(() {});
                            },
                            itemBuilder: (context, index) {
                              final imageUrl =
                                  imageBaseUrl + product.images[index];

                              return ClipRRect(
                                borderRadius:
                                const BorderRadius.vertical(
                                    top: Radius.circular(16)),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,

                                  /// LOADING
                                  loadingBuilder:
                                      (context, child, progress) {
                                    if (progress == null) return child;
                                    return const Center(
                                      child:
                                      CircularProgressIndicator(),
                                    );
                                  },

                                  /// ERROR PLACEHOLDER
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade200,
                                      child: const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 8),

                        /// DOTS INDICATOR
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: List.generate(
                            product.images.length,
                                (index) => Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 4),
                              width: currentPage == index ? 10 : 8,
                              height: currentPage == index ? 10 : 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentPage == index
                                    ? Colors.black
                                    : Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      product.name,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 10),

                    Text("Price: ₹ ${product.price}"),
                    Text("Condition: ${product.condition}"),
                    Text("Stock: ${product.stock}"),
                    Text("School: ${product.schoolName ?? ""}"),
                    Text("Seller: ${product.userName ?? ""}"),
                    Text(
                      "Posted: ${DateFormat('dd MMM yyyy').format(product.createdAt)}",
                    ),

                    const SizedBox(height: 10),

                    Text(product.description),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: Get.back,
                            child: const Text("Close"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (!product.isApproved)
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                              onPressed: () {
                                ctrl.approveProduct(product.id);
                                Get.back();
                              },
                              child: const Text("Approve"),
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Text("No Products Found"),
    );
  }
}