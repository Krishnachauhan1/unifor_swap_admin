import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uniform_swap_admin/apis.dart';
import 'package:uniform_swap_admin/app_colors.dart';
import 'package:uniform_swap_admin/products/controllers/product_controller.dart';
import 'package:uniform_swap_admin/products/models/product_model.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});


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
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250, // 👈 card max width
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 0.75, // 👈 adjust height ratio
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
    final imageUrl = product.images.isNotEmpty
        ? imageBaseUrl + product.images.first
        : null;


    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 300; // adaptive check

        return GestureDetector(
          onTap: () => _openProductDialog(product, ctrl),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isWeb ? 16 : 12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: isWeb ? 12 : 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// IMAGE
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(isWeb ? 16 : 12),
                  ),
                  child: AspectRatio(
                    aspectRatio: isWeb ? 1.6 : 1.2, // responsive ratio
                    child: imageUrl != null
                        ? Image.network(
                      imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,

                      /// loading
                      loadingBuilder:
                          (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },

                      /// error
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
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
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(Icons.image, size: 40),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(isWeb ? 14 : 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// TITLE
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isWeb ? 14 : 12,
                        ),
                      ),

                      SizedBox(height: isWeb ? 8 : 6),

                      /// PRICE
                      Text(
                        "₹ ${product.price}",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: isWeb ? 13 : 11,
                        ),
                      ),

                      SizedBox(height: isWeb ? 8 : 6),

                      /// SCHOOL
                      Text(
                        product.schoolName ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isWeb ? 12 : 10,
                          color: Colors.grey,
                        ),
                      ),

                      SizedBox(height: isWeb ? 8 : 6),

                      /// STATUS
                      _statusBadge(product),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
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

    print(imageBaseUrl+product.images.first);
    print(product.name);
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
                              final imageUrl = imageBaseUrl + product.images[index];

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
                                        print("IMAGE ERROR: $error");
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