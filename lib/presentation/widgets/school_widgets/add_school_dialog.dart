import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../../data/models/school.dart';
import '../../providers/school_provider.dart';

class AddSchoolDialog extends StatefulWidget {
  final School? school; // null for adding, not null for editing

  const AddSchoolDialog({super.key, this.school});

  @override
  State<AddSchoolDialog> createState() => _AddSchoolDialogState();
}

class _AddSchoolDialogState extends State<AddSchoolDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameArabicController = TextEditingController();
  final _nameEnglishController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _principalController = TextEditingController();

  String? _logoPath;
  bool _isLoading = false;

  bool get isEditing => widget.school != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _loadSchoolData();
    }
  }

  void _loadSchoolData() {
    final school = widget.school!;
    _nameArabicController.text = school.nameArabic;
    _nameEnglishController.text = school.nameEnglish;
    _addressController.text = school.address;
    _phoneController.text = school.phone;
    _principalController.text = school.principal;
    _logoPath = school.logoPath;
  }

  @override
  void dispose() {
    _nameArabicController.dispose();
    _nameEnglishController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _principalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(isEditing ? 'تعديل المدرسة' : 'إضافة مدرسة جديدة'),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo selection
                _buildLogoSelection(),
                const SizedBox(height: 16),

                // Arabic name
                InfoLabel(
                  label: 'اسم المدرسة بالعربية *',
                  child: TextBox(
                    controller: _nameArabicController,
                    placeholder: 'أدخل اسم المدرسة بالعربية',
                  ),
                ),
                const SizedBox(height: 12),

                // English name
                InfoLabel(
                  label: 'اسم المدرسة بالإنجليزية *',
                  child: TextBox(
                    controller: _nameEnglishController,
                    placeholder: 'Enter school name in English',
                  ),
                ),
                const SizedBox(height: 12),

                // Address
                InfoLabel(
                  label: 'عنوان المدرسة *',
                  child: TextBox(
                    controller: _addressController,
                    placeholder: 'أدخل عنوان المدرسة',
                    maxLines: 2,
                  ),
                ),
                const SizedBox(height: 12),

                // Phone
                InfoLabel(
                  label: 'رقم هاتف المدرسة *',
                  child: TextBox(
                    controller: _phoneController,
                    placeholder: 'أدخل رقم هاتف المدرسة',
                  ),
                ),
                const SizedBox(height: 12),

                // Principal
                InfoLabel(
                  label: 'اسم مدير المدرسة *',
                  child: TextBox(
                    controller: _principalController,
                    placeholder: 'أدخل اسم مدير المدرسة',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Button(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _saveSchool,
          child: _isLoading
              ? const ProgressRing()
              : Text(isEditing ? 'حفظ التغييرات' : 'إضافة المدرسة'),
        ),
      ],
    );
  }

  Widget _buildLogoSelection() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onTap: _selectLogo,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_logoPath != null && _logoPath!.isNotEmpty)
              _buildLogoPreview()
            else
              _buildLogoPlaceholder(),
            const SizedBox(height: 8),
            const Text(
              'اضغط لاختيار شعار المدرسة (PNG)',
              style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoPreview() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: FileImage(File(_logoPath!)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildLogoPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        FluentIcons.add_friend,
        size: 30,
        color: Color(0xFF999999),
      ),
    );
  }

  Future<void> _selectLogo() async {
    try {
      // This is a simplified version. In a real app, you'd use image_picker
      // For now, we'll just simulate logo selection
      setState(() {
        _logoPath = '/path/to/selected/logo.png'; // Placeholder
      });
    } catch (e) {
      _showErrorMessage('فشل في اختيار الصورة: $e');
    }
  }

  void _saveSchool() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final schoolProvider = context.read<SchoolProvider>();
      bool success;

      if (isEditing) {
        final updatedSchool = widget.school!.copyWith(
          nameArabic: _nameArabicController.text.trim(),
          nameEnglish: _nameEnglishController.text.trim(),
          address: _addressController.text.trim(),
          phone: _phoneController.text.trim(),
          principal: _principalController.text.trim(),
          logoPath: _logoPath,
        );
        success = await schoolProvider.updateSchool(updatedSchool);
      } else {
        final newSchool = School(
          nameArabic: _nameArabicController.text.trim(),
          nameEnglish: _nameEnglishController.text.trim(),
          address: _addressController.text.trim(),
          phone: _phoneController.text.trim(),
          principal: _principalController.text.trim(),
          logoPath: _logoPath,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        success = await schoolProvider.addSchool(newSchool);
      }

      if (success && mounted) {
        Navigator.of(context).pop();
        _showSuccessMessage(
          isEditing ? 'تم تحديث المدرسة بنجاح' : 'تم إضافة المدرسة بنجاح',
        );
      }
    } catch (e) {
      _showErrorMessage('حدث خطأ: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _validateForm() {
    if (_nameArabicController.text.trim().isEmpty) {
      _showErrorMessage('يرجى إدخال اسم المدرسة بالعربية');
      return false;
    }
    if (_nameEnglishController.text.trim().isEmpty) {
      _showErrorMessage('يرجى إدخال اسم المدرسة بالإنجليزية');
      return false;
    }
    if (_addressController.text.trim().isEmpty) {
      _showErrorMessage('يرجى إدخال عنوان المدرسة');
      return false;
    }
    if (_phoneController.text.trim().isEmpty) {
      _showErrorMessage('يرجى إدخال رقم هاتف المدرسة');
      return false;
    }
    if (_principalController.text.trim().isEmpty) {
      _showErrorMessage('يرجى إدخال اسم مدير المدرسة');
      return false;
    }
    return true;
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => ContentDialog(
          title: const Text('خطأ'),
          content: Text(message),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('موافق'),
            ),
          ],
        ),
      );
    }
  }

  void _showSuccessMessage(String message) {
    // This would typically show a toast or snackbar
    // For FluentUI, we can show a temporary info bar
  }
}
