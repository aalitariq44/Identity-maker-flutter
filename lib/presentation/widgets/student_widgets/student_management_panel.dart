import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../providers/student_provider.dart';
import '../../providers/school_provider.dart';
import '../../../data/models/student.dart';
import '../common/loading_widget.dart';
import '../common/error_widget.dart';
import 'add_student_dialog.dart';
import 'student_card.dart';

class StudentManagementPanel extends StatefulWidget {
  const StudentManagementPanel({super.key});

  @override
  State<StudentManagementPanel> createState() => _StudentManagementPanelState();
}

class _StudentManagementPanelState extends State<StudentManagementPanel> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int? _selectedSchoolId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<StudentProvider, SchoolProvider>(
      builder: (context, studentProvider, schoolProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with search and filters
            _buildHeader(context, studentProvider, schoolProvider),
            const SizedBox(height: 16),

            // Error display
            if (studentProvider.errorMessage != null)
              CustomErrorWidget(
                message: studentProvider.errorMessage!,
                onRetry: () => studentProvider.loadStudentsWithSchoolInfo(),
              ),

            // Content
            Expanded(child: _buildContent(studentProvider)),
          ],
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    StudentProvider studentProvider,
    SchoolProvider schoolProvider,
  ) {
    return Column(
      children: [
        Row(
          children: [
            // Title
            const Text(
              'إدارة الطلاب',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Spacer(),

            // Add student button
            FilledButton(
              onPressed: schoolProvider.schools.isNotEmpty
                  ? () => _showAddStudentDialog(context)
                  : null,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(FluentIcons.add),
                  SizedBox(width: 8),
                  Text('إضافة طالب'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Filters row
        Row(
          children: [
            // Search box
            SizedBox(
              width: 300,
              child: TextBox(
                controller: _searchController,
                placeholder: 'البحث في الطلاب...',
                prefix: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(FluentIcons.search),
                ),
                suffix: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(FluentIcons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                          studentProvider.loadStudentsWithSchoolInfo();
                        },
                      )
                    : null,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                  // TODO: Implement search functionality
                },
              ),
            ),
            const SizedBox(width: 16),

            // School filter
            SizedBox(
              width: 200,
              child: ComboBox<int?>(
                placeholder: const Text('تصفية حسب المدرسة'),
                value: _selectedSchoolId,
                items: [
                  const ComboBoxItem<int?>(
                    value: null,
                    child: Text('جميع المدارس'),
                  ),
                  ...schoolProvider.schools.map(
                    (school) => ComboBoxItem<int?>(
                      value: school.id,
                      child: Text(school.nameArabic),
                    ),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedSchoolId = value;
                  });
                  if (value == null) {
                    studentProvider.loadStudentsWithSchoolInfo();
                  } else {
                    studentProvider.loadStudentsBySchool(value);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent(StudentProvider studentProvider) {
    if (studentProvider.isLoading) {
      return const CustomLoadingWidget(message: 'جاري تحميل الطلاب...');
    }

    if (studentProvider.students.isEmpty) {
      return _buildEmptyState();
    }

    return _buildStudentGrid(studentProvider.students);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(FluentIcons.people, size: 64, color: Color(0xFF999999)),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'لم يتم العثور على طلاب مطابقين للبحث'
                : _selectedSchoolId != null
                ? 'لا توجد طلاب في هذه المدرسة'
                : 'لا توجد طلاب مضافين بعد',
            style: const TextStyle(fontSize: 18, color: Color(0xFF999999)),
          ),
          const SizedBox(height: 16),
          if (_searchQuery.isEmpty && _selectedSchoolId == null)
            FilledButton(
              onPressed: () => _showAddStudentDialog(context),
              child: const Text('إضافة أول طالب'),
            ),
        ],
      ),
    );
  }

  Widget _buildStudentGrid(List<Student> students) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: students.length,
      itemBuilder: (context, index) {
        return StudentCard(
          student: students[index],
          onEdit: () => _showEditStudentDialog(context, students[index]),
          onDelete: () => _confirmDeleteStudent(context, students[index]),
        );
      },
    );
  }

  void _showAddStudentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddStudentDialog(),
    );
  }

  void _showEditStudentDialog(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (context) => AddStudentDialog(student: student),
    );
  }

  void _confirmDeleteStudent(BuildContext context, Student student) {
    showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف الطالب "${student.name}"؟'),
        actions: [
          Button(
            child: const Text('إلغاء'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await context
                  .read<StudentProvider>()
                  .deleteStudent(student.id!);
              if (success && context.mounted) {
                _showSuccessMessage(context, 'تم حذف الطالب بنجاح');
              }
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('نجح'),
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
