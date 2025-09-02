import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../../data/models/student.dart';
import '../../providers/student_provider.dart';
import '../../providers/school_provider.dart';

class AddStudentDialog extends StatefulWidget {
  final Student? student; // null for adding, not null for editing

  const AddStudentDialog({super.key, this.student});

  @override
  State<AddStudentDialog> createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends State<AddStudentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  DateTime? _birthDate;
  int? _selectedSchoolId;
  String? _photoPath;
  String? _selectedGrade;
  bool _isLoading = false;

  bool get isEditing => widget.student != null;

  // Grade options
  final List<String> _gradeOptions = [
    // Primary grades
    'الأول الابتدائي',
    'الثاني الابتدائي',
    'الثالث الابتدائي',
    'الرابع الابتدائي',
    'الخامس الابتدائي',
    'السادس الابتدائي',
    // Intermediate grades
    'الأول المتوسط',
    'الثاني المتوسط',
    'الثالث المتوسط',
    // Secondary grades
    'الرابع العلمي',
    'الرابع الأدبي',
    'الخامس العلمي',
    'الخامس الأدبي',
    'السادس العلمي',
    'السادس الأدبي',
  ];

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _loadStudentData();
    }
  }

  void _loadStudentData() {
    final student = widget.student!;
    _nameController.text = student.name;
    _selectedGrade = student.grade;
    _birthDate = student.birthDate;
    _selectedSchoolId = student.schoolId;
    _photoPath = student.photoPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SchoolProvider>(
      builder: (context, schoolProvider, child) {
        return ContentDialog(
          title: Text(isEditing ? 'تعديل الطالب' : 'إضافة طالب جديد'),
          content: SizedBox(
            width: 500,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Photo selection
                    _buildPhotoSelection(),
                    const SizedBox(height: 16),

                    // Student name
                    InfoLabel(
                      label: 'اسم الطالب *',
                      child: TextBox(
                        controller: _nameController,
                        placeholder: 'أدخل اسم الطالب',
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Birth date
                    InfoLabel(
                      label: 'تاريخ الميلاد *',
                      child: DatePicker(
                        selected: _birthDate,
                        onChanged: (date) {
                          setState(() {
                            _birthDate = date;
                          });
                        },
                        showDay: true,
                        showMonth: true,
                        showYear: true,
                        locale: const Locale('ar', 'SA'),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Grade
                    InfoLabel(
                      label: 'الصف *',
                      child: ComboBox<String>(
                        placeholder: const Text('اختر صف الطالب'),
                        value: _selectedGrade,
                        items: _gradeOptions.map((grade) {
                          return ComboBoxItem<String>(
                            value: grade,
                            child: Text(grade),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedGrade = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    // School selection
                    InfoLabel(
                      label: 'المدرسة *',
                      child: ComboBox<int>(
                        placeholder: const Text('اختر المدرسة'),
                        value: _selectedSchoolId,
                        items: schoolProvider.schools.map((school) {
                          return ComboBoxItem<int>(
                            value: school.id!,
                            child: Text(school.nameArabic),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSchoolId = value;
                          });
                        },
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
              onPressed: _isLoading ? null : _saveStudent,
              child: _isLoading
                  ? const ProgressRing()
                  : Text(isEditing ? 'حفظ التغييرات' : 'إضافة الطالب'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPhotoSelection() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onTap: _selectPhoto,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_photoPath != null && _photoPath!.isNotEmpty)
              _buildPhotoPreview()
            else
              _buildPhotoPlaceholder(),
            const SizedBox(height: 8),
            const Text(
              'اضغط لاختيار صورة الطالب',
              style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPreview() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color(0xFFE3F2FD),
      ),
      child: const Icon(
        FluentIcons.contact,
        size: 30,
        color: Color(0xFF1976D2),
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Icon(
        FluentIcons.add_friend,
        size: 30,
        color: Color(0xFF999999),
      ),
    );
  }

  Future<void> _selectPhoto() async {
    try {
      // This is a simplified version. In a real app, you'd use image_picker
      setState(() {
        _photoPath = '/path/to/selected/photo.jpg'; // Placeholder
      });
    } catch (e) {
      _showErrorMessage('فشل في اختيار الصورة: $e');
    }
  }

  void _saveStudent() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final studentProvider = context.read<StudentProvider>();
      bool success;

      if (isEditing) {
        final updatedStudent = widget.student!.copyWith(
          name: _nameController.text.trim(),
          birthDate: _birthDate!,
          grade: _selectedGrade!,
          schoolId: _selectedSchoolId!,
          photoPath: _photoPath,
        );
        success = await studentProvider.updateStudent(updatedStudent);
      } else {
        final newStudent = Student(
          name: _nameController.text.trim(),
          birthDate: _birthDate!,
          grade: _selectedGrade!,
          schoolId: _selectedSchoolId!,
          photoPath: _photoPath,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        success = await studentProvider.addStudent(newStudent);
      }

      if (success && mounted) {
        Navigator.of(context).pop();
        _showSuccessMessage(
          isEditing ? 'تم تحديث الطالب بنجاح' : 'تم إضافة الطالب بنجاح',
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
    if (_nameController.text.trim().isEmpty) {
      _showErrorMessage('يرجى إدخال اسم الطالب');
      return false;
    }
    if (_birthDate == null) {
      _showErrorMessage('يرجى اختيار تاريخ الميلاد');
      return false;
    }
    if (_selectedGrade == null || _selectedGrade!.isEmpty) {
      _showErrorMessage('يرجى اختيار صف الطالب');
      return false;
    }
    if (_selectedSchoolId == null) {
      _showErrorMessage('يرجى اختيار المدرسة');
      return false;
    }
    return true;
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => ContentDialog(
          title: const Text('خطأ', style: TextStyle(color: Colors.black)),
          content: Text(message, style: TextStyle(color: Colors.black)),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('موافق', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }

  void _showSuccessMessage(String message) {
    // This would typically show a toast or snackbar
  }
}
