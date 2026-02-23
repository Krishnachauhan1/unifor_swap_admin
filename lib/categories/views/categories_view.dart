import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniform_swap_admin/app_colors.dart';
import 'package:uniform_swap_admin/dashboard/dashboard_controller.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<DashboardController>();
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: Colors.white,
            child: Row(
              children: [
                const Text(
                  'Category Management',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showAddCategoryDialog(context),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Category'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category list
                      SizedBox(
                        width: 320,
                        child: _CategoryTreePanel(categories: c.schoolCategories),
                      ),
                      Container(width: 1, color: const Color(0xFFEEEEEE)),
                      // Detail panel placeholder
                      const Expanded(child: _CategoryDetailPanel()),
                    ],
                  )
                : _CategoryTreePanel(categories: c.schoolCategories),
          ),
        ],
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    Get.dialog(AlertDialog(
      title: const Text('Add New Category'),
      content: TextField(
        controller: nameCtrl,
        decoration: const InputDecoration(labelText: 'Category Name', hintText: 'e.g. Science Equipment'),
      ),
      actions: [
        TextButton(onPressed: Get.back, child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            Get.back();
            Get.snackbar('Success', 'Category added successfully',
                backgroundColor: AppColors.success, colorText: Colors.white);
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('Add', style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
  }
}

class _CategoryTreePanel extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  const _CategoryTreePanel({required this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const Divider(height: 1, indent: 16, endIndent: 16),
        itemBuilder: (_, i) => _CategoryExpansionTile(category: categories[i]),
      ),
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
