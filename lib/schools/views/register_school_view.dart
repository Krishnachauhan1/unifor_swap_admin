import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniform_swap_admin/app_colors.dart';
import 'package:uniform_swap_admin/schools/controllers/school_controller.dart';

class RegisterSchoolView extends StatelessWidget {
  const RegisterSchoolView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SchoolController>();
    final formKey = GlobalKey<FormState>();
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final isDesktop = width >= 1024;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text(
          'Register School',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isDesktop ? 820 : 720),
          child: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              children: [
                _SectionCard(
                  title: 'Basic Information',
                  icon: Icons.school_outlined,
                  children: [
                    TextFormField(
                      controller: c.nameCtrl,
                      decoration: _inputDecoration('School Name', required: true),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'School name is required' : null,
                    ),
                    const SizedBox(height: 16),
                    Obx(() => DropdownButtonFormField<String>(
                          value: c.selectedBoard.value,
                          decoration: _inputDecoration('Board / Curriculum'),
                          items: SchoolController.boardOptions
                              .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                              .toList(),
                          onChanged: (v) => c.selectedBoard.value = v,
                        )),
                    const SizedBox(height: 16),
                    isMobile
                        ? Column(
                            children: [
                              TextFormField(
                                controller: c.emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                decoration: _inputDecoration('Email'),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) return null;
                                  if (!GetUtils.isEmail(v.trim())) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: c.phoneCtrl,
                                keyboardType: TextInputType.phone,
                                decoration: _inputDecoration('Phone'),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: c.emailCtrl,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: _inputDecoration('Email'),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) return null;
                                    if (!GetUtils.isEmail(v.trim())) {
                                      return 'Enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: c.phoneCtrl,
                                  keyboardType: TextInputType.phone,
                                  decoration: _inputDecoration('Phone'),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Location',
                  icon: Icons.location_on_outlined,
                  children: [
                    TextFormField(
                      controller: c.addressCtrl,
                      maxLines: 2,
                      decoration: _inputDecoration('Full Address'),
                    ),
                    const SizedBox(height: 16),
                    isMobile
                        ? Column(
                            children: [
                              TextFormField(
                                controller: c.cityCtrl,
                                decoration: _inputDecoration('City'),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: c.stateCtrl,
                                decoration: _inputDecoration('State'),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: c.cityCtrl,
                                  decoration: _inputDecoration('City'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: c.stateCtrl,
                                  decoration: _inputDecoration('State'),
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: c.pincodeCtrl,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration('Pincode'),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return null;
                        if (v.trim().length != 6) return 'Pincode must be 6 digits';
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Branding',
                  icon: Icons.image_outlined,
                  children: [
                    Obx(() => isMobile
                        ? Column(
                            children: [
                              _ImagePicker(
                                label: 'School Logo',
                                hint: 'Upload logo (optional)',
                                bytes: c.logoBytes.value,
                                onPick: () => _pickImage(c, isLogo: true),
                                onClear: () {
                                  c.logoBytes.value = null;
                                  c.logoFileName.value = null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _ImagePicker(
                                label: 'Banner Image',
                                hint: 'Upload banner (optional)',
                                bytes: c.bannerBytes.value,
                                onPick: () => _pickImage(c, isLogo: false),
                                onClear: () {
                                  c.bannerBytes.value = null;
                                  c.bannerFileName.value = null;
                                },
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: _ImagePicker(
                                  label: 'School Logo',
                                  hint: 'Upload logo (optional)',
                                  bytes: c.logoBytes.value,
                                  onPick: () => _pickImage(c, isLogo: true),
                                  onClear: () {
                                    c.logoBytes.value = null;
                                    c.logoFileName.value = null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _ImagePicker(
                                  label: 'Banner Image',
                                  hint: 'Upload banner (optional)',
                                  bytes: c.bannerBytes.value,
                                  onPick: () => _pickImage(c, isLogo: false),
                                  onClear: () {
                                    c.bannerBytes.value = null;
                                    c.bannerFileName.value = null;
                                  },
                                ),
                              ),
                            ],
                          )),
                  ],
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Status',
                  icon: Icons.toggle_on_outlined,
                  children: [
                    Obx(() => SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Active'),
                          subtitle: const Text('School visible on the platform'),
                          value: c.isActive.value,
                          activeColor: AppColors.primary,
                          onChanged: (v) => c.isActive.value = v,
                        )),
                    Obx(() => SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Featured'),
                          subtitle: const Text('Highlight this school on homepage'),
                          value: c.isFeatured.value,
                          activeColor: AppColors.primary,
                          onChanged: (v) => c.isFeatured.value = v,
                        )),
                  ],
                ),
                const SizedBox(height: 24),
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: c.isSubmitting.value
                            ? null
                            : () async {
                                if (!formKey.currentState!.validate()) return;
                                final ok = await c.registerSchool();
                                if (ok) Get.back();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: c.isSubmitting.value
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Register School',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    )),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      c.resetForm();
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {bool required = false}) {
    return InputDecoration(
      labelText: required ? '$label *' : label,
      filled: true,
      fillColor: AppColors.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  Future<void> _pickImage(SchoolController c, {required bool isLogo}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.first.bytes == null) return;

    if (isLogo) {
      c.logoBytes.value = result.files.first.bytes;
      c.logoFileName.value = result.files.first.name;
    } else {
      c.bannerBytes.value = result.files.first.bytes;
      c.bannerFileName.value = result.files.first.name;
    }
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}

class _ImagePicker extends StatelessWidget {
  final String label;
  final String hint;
  final Uint8List? bytes;
  final VoidCallback onPick;
  final VoidCallback onClear;

  const _ImagePicker({
    required this.label,
    required this.hint,
    required this.bytes,
    required this.onPick,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onPick,
          child: Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: bytes == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload_outlined,
                            size: 32, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text(
                          hint,
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(bytes!, fit: BoxFit.cover),
                  ),
          ),
        ),
        if (bytes != null) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.close, size: 16),
            label: const Text('Remove'),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
          ),
        ],
      ],
    );
  }
}
