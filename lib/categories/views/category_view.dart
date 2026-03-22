import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_colors.dart';
import '../controllers/category_controller.dart';
import '../models/category_model.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(
      builder: (ctrl) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Category Management',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => _showAddCategoryDialog(context, ctrl),
                icon: const Icon(Icons.add_circle_rounded,
                    color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Column(
            children: [
              // Stats Bar
              Container(
                color: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    _statChip(ctrl.totalCategories.toString(),
                        "Categories", AppColors.primary),
                    const SizedBox(width: 10),
                    _statChip(ctrl.totalSubCategories.toString(),
                        "Sub-cats", AppColors.secondary),
                  ],
                ),
              ),

              // Search
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextField(
                  onChanged: (v) {
                    ctrl.searchQuery = v;
                    ctrl.update();
                  },
                  decoration: InputDecoration(
                    hintText:
                    'Search categories, subcategories...',
                    prefixIcon: const Icon(Icons.search,
                        color: AppColors.primary),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: AppColors.background,
                  ),
                ),
              ),

              const Divider(height: 1),

              // Category List
              Expanded(
                child: ctrl.isLoading
                    ? const Center(
                  child: CircularProgressIndicator(
                      color: AppColors.primary),
                )
                    : ctrl.filteredCategories.isEmpty
                    ? const Center(
                    child: Text("No categories found"))
                    : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount:
                  ctrl.filteredCategories.length,
                  itemBuilder: (context, i) =>
                      _CategoryCard(
                          cat: ctrl.filteredCategories[i],
                          ctrl: ctrl),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _statChip(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16, color: color)),
            Text(label,
                style: TextStyle(fontSize: 10, color: color.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context, CategoryController ctrl) {
    ctrl.nameCtrl.clear();
    ctrl.descCtrl.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Add New Category"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: ctrl.nameCtrl,
                decoration: const InputDecoration(
                    labelText: 'Category Name',
                    prefixIcon: Icon(Icons.category_rounded,
                        color: AppColors.primary))),
            const SizedBox(height: 12),
            TextField(
                controller: ctrl.descCtrl,
                decoration: const InputDecoration(
                    labelText: 'Description',
                    prefixIcon: Icon(Icons.description_outlined,
                        color: AppColors.primary)),
                maxLines: 2),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(onPressed:
          (){}, child: const Text('Add')),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel cat;
  final CategoryController ctrl;

  const _CategoryCard({required this.cat, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final isExpanded =
        ctrl.expandedCategories[cat.id] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              ctrl.toggleCategory(cat.id);
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      cat.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Column(
              children: cat.subCategories
                  .map((sub) => _SubCategoryTile(
                sub: sub,
                ctrl: ctrl,
              ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}
class _SubCategoryTile extends StatelessWidget {
  final SubCategoryModel sub;
  final CategoryController ctrl;
  const _SubCategoryTile({required this.sub, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final totalProducts =
        sub.sections.fold(0, (s, sec) => s + sec.productCount);
    return Obx(() {
      final isExpanded = ctrl.expandedSubCategories[sub.id] ?? false;
      return Container(
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () => ctrl.toggleSubCategory(sub.id),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: AppColors.secondary, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(sub.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColors.textPrimary)),
                    ),
                    Text(
                        "${sub.sections.length} sections • $totalProducts items",
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textSecondary)),
                    const SizedBox(width: 6),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: AppColors.secondary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Column(
                  children: sub.sections
                      .map((sec) => _SectionTile(section: sec))
                      .toList(),
                ),
              ),
          ],
        ),
      );
    });
  }
}

class _SectionTile extends StatelessWidget {
  final SectionModel section;
  const _SectionTile({required this.section});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.arrow_right_rounded,
              color: AppColors.textHint, size: 18),
          const SizedBox(width: 6),
          Expanded(
            child: Text(section.name,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textPrimary)),
          ),
          // Stock badges
          if (section.hasNew) _badge("NEW", const Color(0xFF4CAF50)),
          const SizedBox(width: 4),
          if (section.hasUsed) _badge("USED", const Color(0xFF795548)),
          const SizedBox(width: 8),
          // Stock indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _stockColor(section.productCount).withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              "${section.productCount}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: _stockColor(section.productCount),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(4)),
      child: Text(text,
          style: TextStyle(
              fontSize: 9, fontWeight: FontWeight.bold, color: color)),
    );
  }

  Color _stockColor(int count) {
    if (count == 0) return const Color(0xFFB00020);
    if (count < 10) return const Color(0xFFFF9800);
    return const Color(0xFF4CAF50);
  }
}
