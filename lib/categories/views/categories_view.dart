import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniform_swap_admin/app_colors.dart';
import 'package:uniform_swap_admin/categories/controllers/category_controller.dart';
import '../models/category_model.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(
      init: CategoryController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F6FA),
          body: Column(
            children: [

              /// 🔹 RESPONSIVE HEADER
              LayoutBuilder(
                builder: (context, constraints) {
                  final isMobile = constraints.maxWidth < 600;

                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    color: Colors.white,
                    child: isMobile
                        ? Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Category Management',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Categories: ${controller.totalCategories} | Sub: ${controller.totalSubCategories}",
                          style:
                          const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    AppColors.primary,
                                  foregroundColor: Colors.white
                                ),
                                onPressed: () {
                                  _showAddCategoryDialog(
                                      controller);
                                },
                                child: const Text(
                                    'Add Category'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    AppColors.primary,
                                    foregroundColor: Colors.white),
                                onPressed: () {
                                  _showAddSubCategoryDialog(
                                      controller);
                                },
                                child:
                                const Text('Add Sub'),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                        : Row(
                      children: [
                        const Text(
                          'Category Management',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          "Categories: ${controller.totalCategories} | SubCategories: ${controller.totalSubCategories}",
                          style:
                          const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                              AppColors.primary,
                              foregroundColor: Colors.white),
                          onPressed: () {
                            _showAddCategoryDialog(
                                controller);
                          },
                          child: const Text(
                              'Add Categories'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                              AppColors.primary,
                              foregroundColor: Colors.white),
                          onPressed: () {
                            _showAddSubCategoryDialog(
                                controller);
                          },
                          child: const Text(
                              'Add Sub Categories'),
                        ),
                      ],
                    ),
                  );
                },
              ),

              /// 🔹 SEARCH
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ConstrainedBox(
                    constraints:
                    const BoxConstraints(maxWidth: 500),
                    child: TextField(
                      onChanged: (val) {
                        controller.searchQuery = val;
                        controller.update();
                      },
                      decoration: InputDecoration(
                        hintText: "Search categories...",
                        prefixIcon:
                        const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /// 🔹 BODY
              Expanded(
                child: controller.isLoading
                    ? const Center(
                    child:
                    CircularProgressIndicator())
                    : _CategoryList(
                    categories:
                    controller.filteredCategories),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 🔹 ADD CATEGORY
  void _showAddCategoryDialog(
      CategoryController controller) {
    final nameController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text("Add Category"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
              labelText: "Category Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty)
                return;
              controller
                  .addCategory(nameController.text.trim());
              Get.back();
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  /// 🔹 ADD SUB CATEGORY
  void _showAddSubCategoryDialog(
      CategoryController controller) {
    final nameController = TextEditingController();
    String? selectedCategory;

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Add Sub Category"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                DropdownButtonFormField<String>(
                  hint: const Text("Select Category"),
                  value: selectedCategory,
                  items: controller.categories.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat.id.toString(),
                      child: Text(cat.name),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedCategory = val;
                    });
                  },
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: "Sub Category Name"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedCategory == null ||
                      nameController.text.trim().isEmpty) {
                    return;
                  }

                  controller.addSubCategory(
                    selectedCategory!,
                    nameController.text.trim(),
                  );

                  Get.back();
                },
                child: const Text("Add"),
              )
            ],
          );
        },
      ),
    );
  }
}

/// 🔹 CATEGORY LIST
class _CategoryList extends StatelessWidget {
  final List<CategoryModel> categories;

  const _CategoryList({required this.categories});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(
      builder: (controller) {
        if (categories.isEmpty) {
          return const Center(
              child: Text("No Categories Found"));
        }

        return Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (_, index) {
              final cat = categories[index];
              final expanded =
                  controller.expandedCategories[cat.id] ??
                      false;

              return Column(
                children: [

                  /// CATEGORY
                  ListTile(
                    onTap: () =>
                        controller.toggleCategory(cat.id),
                    title: Text(
                      cat.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red),
                          onPressed: () =>
                              controller
                                  .deleteCategory(cat.id),
                        ),
                        Icon(expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),

                  /// SUB CATEGORIES
                  if (expanded)
                    ...cat.subCategories.map((sub) {
                      return ListTile(
                        contentPadding:
                        const EdgeInsets.only(left: 40),
                        title: Text(sub.name),
                      );
                    }),
                ],
              );
            },
          ),
        );
      },
    );
  }
}