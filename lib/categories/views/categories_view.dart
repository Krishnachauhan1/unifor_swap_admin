import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniform_swap_admin/app_colors.dart';
import 'package:uniform_swap_admin/categories/controllers/category_controller.dart';
import '../models/category_model.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return GetBuilder<CategoryController>(
      init: CategoryController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F6FA),

          body: Column(
            children: [

              /// 🔹 HEADER
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                color: Colors.white,
                child: Row(
                  children: [
                    const Text(
                      'Category Management',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),

                    /// Stats
                    Text(
                      "Categories: ${controller.totalCategories} | SubCategories: ${controller.totalSubCategories}",
                      style: const TextStyle(fontSize: 13),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textPrimary
                        ),
                        onPressed: () {
                          _showAddCategoryDialog(controller);
                        },
                        child: const Text('Add Categories'),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textPrimary
                        ),
                        onPressed: () {
                          _showAddSubCategoryDialog(controller);
                        },
                        child: const Text('Add Sub Categories'),
                      )
                    ),
                  ],
                ),
              ),

              /// 🔹 SEARCH
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: (val) {
                    controller.searchQuery = val;
                    controller.update();
                  },
                  decoration: InputDecoration(
                    hintText: "Search categories...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),

              /// 🔹 BODY
              // Expanded(
              //   child: controller.isLoading
              //       ? const Center(child: CircularProgressIndicator())
              //       : isWide
              //       ? Row(
              //     children: [
              //       SizedBox(
              //         width: 400,
              //         child: _CategoryList(
              //             categories:
              //             controller.filteredCategories),
              //       ),
              //       // Container(
              //       //     width: 1, color: Colors.grey.shade300),
              //       // const Expanded(
              //       //     child: _CategoryDetailPanel()),
              //     ],
              //   )
              //       : _CategoryList(
              //       categories:
              //       controller.filteredCategories),
              // ),
              Expanded(
                child: _CategoryList(
                    categories:
                    controller.filteredCategories),
              ),
            ],
          ),
        );
      },
    );
  }
  void _showAddCategoryDialog(CategoryController controller) {
    final nameController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text("Add Category"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: "Category Name",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) return;
              controller.addCategory(nameController.text.trim());
              Get.back();
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  void _showAddSubCategoryDialog(CategoryController controller) {
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

                /// SubCategory Name
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Sub Category Name",
                  ),
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

class _CategoryList extends StatelessWidget {
  final List<CategoryModel> categories;

  const _CategoryList({required this.categories});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: CategoryController(),
      builder: (controller) {
        if (categories.isEmpty) {
          return const Center(child: Text("No Categories Found"));
        }
        return Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (_, index) {
              final cat = categories[index];
              final expanded =
                  controller.expandedCategories[cat.id] ?? false;

              return Column(
                children: [

                  /// 🔹 CATEGORY TILE
                  ListTile(
                    onTap: () => controller.toggleCategory(cat.id),
                    title: Text(cat.name,
                        style:
                        const TextStyle(fontWeight: FontWeight.w600)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red),
                          onPressed: () =>
                              controller.deleteCategory(cat.id),
                        ),
                        Icon(expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down),
                      ],
                    ),
                  ),

                  /// 🔹 SUB CATEGORIES
                  if (expanded)
                    ...cat.subCategories.map((sub) {
                      return Column(
                        children: [
                          ListTile(
                            contentPadding:
                            const EdgeInsets.only(left: 40),
                            onTap: () =>
                                controller.toggleSubCategory(sub.id),
                            title: Text(sub.name),

                          ),
                        ],
                      );
                    }),
                ],
              );
            },
          ),
        );
      }
    );
  }
}

class _CategoryExpansionTile extends StatefulWidget {
  final Map<String, dynamic> category;
  const _CategoryExpansionTile({required this.category});

  @override
  State<_CategoryExpansionTile> createState() => _CategoryExpansionTileState();
}

class _CategoryExpansionTileState extends State<_CategoryExpansionTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final color = Color(widget.category['color']);
    final subCats = widget.category['subCategories'] as List<dynamic>;

    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(widget.category['icon'], style: const TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.category['name'],
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      Text(
                        '${subCats.length} sub-categories',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add, size: 18, color: AppColors.primary),
                      tooltip: 'Add Sub-category',
                      onPressed: () => _showAddSubCatDialog(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          ...subCats.map((sub) => _SubCategoryTile(subCategory: sub as Map<String, dynamic>, parentColor: color)),
      ],
    );
  }

  void _showAddSubCatDialog(BuildContext context) {
    final ctrl = TextEditingController();
    Get.dialog(AlertDialog(
      title: Text('Add Sub-category to ${widget.category['name']}'),
      content: TextField(controller: ctrl, decoration: const InputDecoration(labelText: 'Sub-category Name')),
      actions: [
        TextButton(onPressed: Get.back, child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            Get.back();
            Get.snackbar('Success', 'Sub-category added', backgroundColor: AppColors.success, colorText: Colors.white);
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('Add', style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
  }
}

class _SubCategoryTile extends StatefulWidget {
  final Map<String, dynamic> subCategory;
  final Color parentColor;
  const _SubCategoryTile({required this.subCategory, required this.parentColor});

  @override
  State<_SubCategoryTile> createState() => _SubCategoryTileState();
}

class _SubCategoryTileState extends State<_SubCategoryTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final sections = widget.subCategory['sections'] as List<dynamic>? ?? [];

    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            color: AppColors.background.withOpacity(0.5),
            padding: const EdgeInsets.only(left: 68, right: 16, top: 10, bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.parentColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.subCategory['name'],
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                      ),
                      Text(
                        '${sections.length} sections',
                        style: const TextStyle(color: AppColors.textHint, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 16, color: AppColors.secondary),
                  onPressed: () {},
                  tooltip: 'Add Section',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                Icon(
                  _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.textHint,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          ...sections.map((section) => _SectionTile(name: section.toString(), color: widget.parentColor)),
      ],
    );
  }
}

class _SectionTile extends StatelessWidget {
  final String name;
  final Color color;
  const _SectionTile({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 100, right: 16, top: 8, bottom: 8),
      child: Row(
        children: [
          Icon(Icons.fiber_manual_record, size: 6, color: color.withOpacity(0.5)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(name, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ),
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.edit_outlined, size: 14, color: AppColors.textHint),
                ),
              ),
              const SizedBox(width: 4),
              InkWell(
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.delete_outline, size: 14, color: AppColors.error),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryDetailPanel extends StatelessWidget {
  const _CategoryDetailPanel();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Select a category to view details',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
