import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_colors.dart';
import '../../categories/controllers/category_controller.dart';
import '../controllers/product_controller.dart';
import '../models/product_model.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ProductController());
    final catCtrl = Get.put(CategoryController());
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Products',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          actions: [
            IconButton(
              onPressed: () => _showAddProductDialog(context, ctrl, catCtrl),
              icon: const Icon(Icons.add_circle_rounded,
                  color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (v) => ctrl.searchQuery.value = v,
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: AppColors.primary),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: AppColors.primary)),
                        filled: true,
                        fillColor: AppColors.background,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Filter chips
                    Row(
                      children: [
                        _filterChip('All', 'all', ctrl),
                        const SizedBox(width: 8),
                        _filterChip('New', 'new', ctrl),
                        const SizedBox(width: 8),
                        _filterChip('Used', 'used', ctrl),
                      ],
                    )
                  ],
                ),
              ),
              const Divider(height: 1),
              // Products List
              Expanded(
                child: Obx(() {
                  if (ctrl.isLoading.value) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary));
                  }
                  final products = ctrl.filteredProducts;
                  if (products.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined,
                              size: 64, color: AppColors.textHint),
                          SizedBox(height: 16),
                          Text('No products found',
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 16)),
                        ],
                      ),
                    );
                  }
                  final crossAxisCount = constraints.maxWidth > 1400
                      ? 5
                      : constraints.maxWidth > 1100
                          ? 4
                          : constraints.maxWidth > 800
                              ? 3
                              : constraints.maxWidth > 500
                                  ? 2
                                  : 1;

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.0,
                    ),
                    itemCount: products.length,
                    itemBuilder: (_, i) =>
                        _ProductCard(product: products[i], ctrl: ctrl),
                  );
                }),
              ),
            ],
          );
        }));
  }

  Widget _filterChip(String label, String value, ProductController ctrl) {
    return Obx(() {
      final selected = ctrl.filterCondition.value == value;
      return FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => ctrl.filterCondition.value = value,
        selectedColor: AppColors.primary.withOpacity(0.15),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: selected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
        side: BorderSide(
            color: selected ? AppColors.primary : Colors.grey.shade300),
      );
    });
  }

  void _showAddProductDialog(BuildContext context, ProductController ctrl,
      CategoryController catCtrl) {
    ctrl.nameCtrl.clear();
    ctrl.descCtrl.clear();
    ctrl.priceCtrl.clear();
    ctrl.stockCtrl.clear();
    ctrl.conditionVal.value = 'new';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add New Product'),
        content: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: ctrl.nameCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Product Name *',
                        prefixIcon: Icon(Icons.inventory_2_outlined,
                            color: AppColors.primary))),
                const SizedBox(height: 12),
                TextField(
                    controller: ctrl.descCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Description',
                        prefixIcon: Icon(Icons.description_outlined,
                            color: AppColors.primary)),
                    maxLines: 2),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                            controller: ctrl.priceCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Price (₹) *',
                                prefixIcon: Icon(Icons.currency_rupee,
                                    color: AppColors.primary)))),
                    const SizedBox(width: 12),
                    Expanded(
                        child: TextField(
                            controller: ctrl.stockCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: 'Stock',
                                prefixIcon: Icon(Icons.numbers,
                                    color: AppColors.primary)))),
                  ],
                ),
                const SizedBox(height: 12),
                Obx(() => Row(
                      children: [
                        const Text('Condition: ',
                            style: TextStyle(color: AppColors.textSecondary)),
                        const SizedBox(width: 12),
                        ChoiceChip(
                          label: const Text('New'),
                          selected: ctrl.conditionVal.value == 'new',
                          onSelected: (_) => ctrl.conditionVal.value = 'new',
                          selectedColor: const Color(0xFF4CAF50),
                        ),
                        const SizedBox(width: 8),
                        ChoiceChip(
                          label: const Text('Used'),
                          selected: ctrl.conditionVal.value == 'used',
                          onSelected: (_) => ctrl.conditionVal.value = 'used',
                          selectedColor: const Color(0xFF795548),
                        ),
                      ],
                    )),
                const SizedBox(height: 12),
                Obx(() => DropdownButtonFormField<int>(
                      value: ctrl.selectedCategoryId.value,
                      decoration: const InputDecoration(
                          labelText: 'Category',
                          prefixIcon: Icon(Icons.category_rounded,
                              color: AppColors.primary)),
                      items: catCtrl.categories
                          .map((c) => DropdownMenuItem(
                              value: c.id, child: Text(c.name)))
                          .toList(),
                      onChanged: (v) => ctrl.selectedCategoryId.value = v,
                    )),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
              onPressed: ctrl.products, child: const Text('Add Product')),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final ProductController ctrl;
  const _ProductCard({required this.product, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final isNew = product.condition == 'new';
    final stockColor = product.stock == 0
        ? AppColors.error
        : product.stock < 5
            ? AppColors.warning
            : AppColors.success;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.textPrimary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () => ctrl.deleteProduct(product.id),
                  icon: const Icon(Icons.delete_outline,
                      color: AppColors.error, size: 18),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            if (product.schoolName != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(Icons.school_outlined,
                        size: 12, color: AppColors.textHint),
                    const SizedBox(width: 4),
                    Text(product.schoolName!,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textHint)),
                  ],
                ),
              ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '₹${product.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primary),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: isNew
                            ? const Color(0xFF4CAF50).withOpacity(0.12)
                            : const Color(0xFF795548).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isNew ? 'NEW' : 'USED',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isNew
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFF795548)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: stockColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Stock: ${product.stock}',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: stockColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
