import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uniform_swap_admin/app_colors.dart';
import 'package:uniform_swap_admin/schools/controllers/school_controller.dart';

/// Opens register school screen with controller ready (safe on mobile).
void openRegisterSchoolForm() {
  if (!Get.isRegistered<SchoolController>()) {
    Get.put(SchoolController(), permanent: true);
  }
  Get.find<SchoolController>().resetForm();
  Get.to(() => const RegisterSchoolView());
}

class RegisterSchoolView extends StatefulWidget {
  const RegisterSchoolView({super.key});

  @override
  State<RegisterSchoolView> createState() => _RegisterSchoolViewState();
}

class _RegisterSchoolViewState extends State<RegisterSchoolView> {
  final _formKey = GlobalKey<FormState>();
  late final SchoolController c;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<SchoolController>()) {
      Get.put(SchoolController(), permanent: true);
    }
    c = Get.find<SchoolController>();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  InputDecoration _inputDecoration(String label, {bool required = false}) {
    return InputDecoration(
      labelText: required ? '$label *' : label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  Future<void> _pickImage({required bool isLogo}) async {
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
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final isDesktop = width >= 1024;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
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
      body: Form(
        key: _formKey,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(
            isMobile ? 16 : 24,
            isMobile ? 16 : 24,
            isMobile ? 16 : 24,
            24 + bottomInset,
          ),
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isDesktop ? 820 : 720),
                child: Column(
                  children: [
                    _SectionCard(
                      title: 'Basic Information',
                      icon: Icons.school_outlined,
                      children: [
                        TextFormField(
                          controller: c.nameCtrl,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: _inputDecoration('School Name', required: true),
                          textInputAction: TextInputAction.next,
                          validator: (v) => v == null || v.trim().isEmpty
                              ? 'School name is required'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: c.selectedBoard.value,
                          decoration: _inputDecoration('Board / Curriculum'),
                          items: SchoolController.boardOptions
                              .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                              .toList(),
                          onChanged: (v) {
                            c.selectedBoard.value = v;
                            _refresh();
                          },
                        ),
                        const SizedBox(height: 16),
                        if (isMobile)
                          Column(
                            children: [
                              TextFormField(
                                controller: c.emailCtrl,
                                style: const TextStyle(color: AppColors.textPrimary),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
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
                                style: const TextStyle(color: AppColors.textPrimary),
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                decoration: _inputDecoration('Phone'),
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: c.emailCtrl,
                                  style: const TextStyle(color: AppColors.textPrimary),
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
                                  style: const TextStyle(color: AppColors.textPrimary),
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
                          style: const TextStyle(color: AppColors.textPrimary),
                          maxLines: 2,
                          textInputAction: TextInputAction.next,
                          decoration: _inputDecoration('Full Address'),
                        ),
                        const SizedBox(height: 16),
                        if (isMobile)
                          Column(
                            children: [
                              TextFormField(
                                controller: c.cityCtrl,
                                style: const TextStyle(color: AppColors.textPrimary),
                                textInputAction: TextInputAction.next,
                                decoration: _inputDecoration('City'),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: c.stateCtrl,
                                style: const TextStyle(color: AppColors.textPrimary),
                                textInputAction: TextInputAction.next,
                                decoration: _inputDecoration('State'),
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: c.cityCtrl,
                                  style: const TextStyle(color: AppColors.textPrimary),
                                  decoration: _inputDecoration('City'),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: c.stateCtrl,
                                  style: const TextStyle(color: AppColors.textPrimary),
                                  decoration: _inputDecoration('State'),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: c.pincodeCtrl,
                          style: const TextStyle(color: AppColors.textPrimary),
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
                        if (isMobile)
                          Column(
                            children: [
                              _ImagePicker(
                                label: 'School Logo',
                                hint: 'Upload logo (optional)',
                                bytes: c.logoBytes.value,
                                onPick: () => _pickImage(isLogo: true),
                                onClear: () {
                                  c.logoBytes.value = null;
                                  c.logoFileName.value = null;
                                  _refresh();
                                },
                              ),
                              const SizedBox(height: 16),
                              _ImagePicker(
                                label: 'Banner Image',
                                hint: 'Upload banner (optional)',
                                bytes: c.bannerBytes.value,
                                onPick: () => _pickImage(isLogo: false),
                                onClear: () {
                                  c.bannerBytes.value = null;
                                  c.bannerFileName.value = null;
                                  _refresh();
                                },
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: _ImagePicker(
                                  label: 'School Logo',
                                  hint: 'Upload logo (optional)',
                                  bytes: c.logoBytes.value,
                                  onPick: () => _pickImage(isLogo: true),
                                  onClear: () {
                                    c.logoBytes.value = null;
                                    c.logoFileName.value = null;
                                    _refresh();
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _ImagePicker(
                                  label: 'Banner Image',
                                  hint: 'Upload banner (optional)',
                                  bytes: c.bannerBytes.value,
                                  onPick: () => _pickImage(isLogo: false),
                                  onClear: () {
                                    c.bannerBytes.value = null;
                                    c.bannerFileName.value = null;
                                    _refresh();
                                  },
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'Status',
                      icon: Icons.toggle_on_outlined,
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Active'),
                          subtitle: const Text('School visible on the platform'),
                          value: c.isActive.value,
                          activeColor: AppColors.primary,
                          onChanged: (v) {
                            c.isActive.value = v;
                            _refresh();
                          },
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Featured'),
                          subtitle: const Text('Highlight this school on homepage'),
                          value: c.isFeatured.value,
                          activeColor: AppColors.primary,
                          onChanged: (v) {
                            c.isFeatured.value = v;
                            _refresh();
                          },
                        ),
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
                                    if (!_formKey.currentState!.validate()) return;
                                    final ok = await c.registerSchool();
                                    if (ok && mounted) Get.back();
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
          ],
        ),
      ),
    );
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
      width: double.infinity,
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
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPick,
            borderRadius: BorderRadius.circular(10),
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
