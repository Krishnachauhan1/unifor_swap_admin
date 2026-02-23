import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniform_swap_admin/app_colors.dart';
import 'package:uniform_swap_admin/dashboard/dashboard_controller.dart';
import 'package:uniform_swap_admin/products/controllers/product_controller.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final c = Get.find<ProductController>();
  final dc = Get.find<DashboardController>();
  final _formKey = GlobalKey<FormState>();

  String _condition = 'new';
  String? _selectedCategory;
  String? _selectedSubCategory;
  String? _selectedSection;
  bool _isActive = true;

  List<Map<String, dynamic>> get _subCategories {
    if (_selectedCategory == null) return [];
    final cat = dc.schoolCategories
        .firstWhereOrNull((c) => c['name'] == _selectedCategory);
    return List<Map<String, dynamic>>.from(cat?['subCategories'] ?? []);
  }

  List<String> get _sections {
    if (_selectedSubCategory == null) return [];
    final sub = _subCategories
        .firstWhereOrNull((s) => s['name'] == _selectedSubCategory);
    return List<String>.from(sub?['sections'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add New Product'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionCard(
                title: 'Basic Information',
                icon: Icons.info_outline,
                children: [
                  _label('Product Name *'),
                  TextFormField(
                    controller: c.nameCtrl,
                    decoration: _dec('Enter product name'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  _label('Description'),
                  TextFormField(
                    controller: c.descCtrl,
                    maxLines: 3,
                    decoration: _dec('Enter product description'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Price (₹) *'),
                            TextFormField(
                              controller: c.priceCtrl,
                              keyboardType: TextInputType.number,
                              decoration: _dec('0.00'),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Stock Quantity *'),
                            TextFormField(
                              controller: c.stockCtrl,
                              keyboardType: TextInputType.number,
                              decoration: _dec('0'),
                              validator: (v) => v!.isEmpty ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _sectionCard(
                title: 'Category',
                icon: Icons.category_outlined,
                children: [
                  _label('Category *'),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: _dec('Select Category'),
                    items: dc.schoolCategories
                        .map((c) => DropdownMenuItem(
                            value: c['name'] as String,
                            child: Text('${c['icon']} ${c['name']}')))
                        .toList(),
                    onChanged: (v) => setState(() {
                      _selectedCategory = v;
                      _selectedSubCategory = null;
                      _selectedSection = null;
                    }),
                    validator: (v) => v == null ? 'Required' : null,
                  ),
                  if (_selectedCategory != null) ...[
                    const SizedBox(height: 16),
                    _label('Sub-Category *'),
                    DropdownButtonFormField<String>(
                      value: _selectedSubCategory,
                      decoration: _dec('Select Sub-Category'),
                      items: _subCategories
                          .map((s) => DropdownMenuItem(
                              value: s['name'] as String,
                              child: Text(s['name'] as String)))
                          .toList(),
                      onChanged: (v) => setState(() {
                        _selectedSubCategory = v;
                        _selectedSection = null;
                      }),
                    ),
                  ],
                  if (_selectedSubCategory != null && _sections.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _label('Section'),
                    DropdownButtonFormField<String>(
                      value: _selectedSection,
                      decoration: _dec('Select Section'),
                      items: _sections
                          .map(
                              (s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedSection = v),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16),
              _sectionCard(
                title: 'Product Details',
                icon: Icons.tune,
                children: [
                  _label('Condition'),
                  Row(
                    children: [
                      _ConditionOption(
                        label: '🆕 New',
                        value: 'new',
                        selected: _condition == 'new',
                        onTap: () => setState(() => _condition = 'new'),
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 12),
                      _ConditionOption(
                        label: '♻️ Used',
                        value: 'used',
                        selected: _condition == 'used',
                        onTap: () => setState(() => _condition = 'used'),
                        color: AppColors.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Size (optional)'),
                            TextFormField(
                              controller: c.sizeCtrl,
                              decoration: _dec('e.g. M, L, XL, 30'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Color (optional)'),
                            TextFormField(
                              controller: c.colorCtrl,
                              decoration: _dec('e.g. White, Navy Blue'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Switch(
                        value: _isActive,
                        onChanged: (v) => setState(() => _isActive = v),
                        activeColor: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      const Text('Active / Visible to users',
                          style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: Get.back,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFFDDDDDD)),
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Add Product',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard(
      {required String title,
      required IconData icon,
      required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: AppColors.textPrimary)),
    );
  }

  InputDecoration _dec(String hint) => InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFEEEEEE))),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        filled: true,
        fillColor: AppColors.background,
      );

  void _submit() {
    if (_formKey.currentState!.validate()) {
      c.addProduct({
        'name': c.nameCtrl.text.trim(),
        'description': c.descCtrl.text.trim(),
        'price': double.tryParse(c.priceCtrl.text) ?? 0,
        'stock': int.tryParse(c.stockCtrl.text) ?? 0,
        'condition': _condition,
        // 'size': c.sizeCtrl.text,
        // 'color': c.colorCtrl.text,
        'is_active': _isActive,
      });
      Get.back();
    }
  }
}

class _ConditionOption extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  const _ConditionOption({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.12) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: selected ? color : const Color(0xFFDDDDDD),
              width: selected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: color,
                size: 18),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    color: selected ? color : AppColors.textSecondary,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class AppColors {
  static const primary = Color(0xFFFF9800);
  static const secondary = Color(0xFF009688);
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFF9800);
  static const error = Color(0xFFB00020);
  static const textHint = Color(0xFF9E9E9E);
  static const textSecondary = Color(0xFF757575);
  static const textPrimary = Color(0xFF212121);
  static const background = Color(0xFFF5F5F5);
}
