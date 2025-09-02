import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../providers/school_provider.dart';
import '../../../data/models/school.dart';
import '../common/loading_widget.dart';
import '../common/error_widget.dart';
import 'add_school_dialog.dart';
import 'school_card.dart';

class SchoolManagementPanel extends StatefulWidget {
  const SchoolManagementPanel({super.key});

  @override
  State<SchoolManagementPanel> createState() => _SchoolManagementPanelState();
}

class _SchoolManagementPanelState extends State<SchoolManagementPanel> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SchoolProvider>(
      builder: (context, schoolProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with search and add button
            _buildHeader(context, schoolProvider),
            const SizedBox(height: 16),

            // Error display
            if (schoolProvider.errorMessage != null)
              CustomErrorWidget(
                message: schoolProvider.errorMessage!,
                onRetry: () => schoolProvider.loadSchools(),
                onDismiss: null, // Remove clear error for now
              ),

            // Content
            Expanded(child: _buildContent(schoolProvider)),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, SchoolProvider schoolProvider) {
    return Row(
      children: [
        // Title
        const Text(
          'إدارة المدارس',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Spacer(),

        // Search box
        SizedBox(
          width: 300,
          child: TextBox(
            controller: _searchController,
            placeholder: 'البحث في المدارس...',
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
                      schoolProvider.loadSchools();
                    },
                  )
                : null,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
              if (value.isEmpty) {
                schoolProvider.loadSchools();
              } else {
                schoolProvider.searchSchools(value);
              }
            },
          ),
        ),
        const SizedBox(width: 16),

        // Add school button
        FilledButton(
          onPressed: () => _showAddSchoolDialog(context),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(FluentIcons.add),
              SizedBox(width: 8),
              Text('إضافة مدرسة'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent(SchoolProvider schoolProvider) {
    if (schoolProvider.isLoading) {
      return const CustomLoadingWidget(message: 'جاري تحميل المدارس...');
    }

    if (schoolProvider.schools.isEmpty) {
      return _buildEmptyState();
    }

    return _buildSchoolGrid(schoolProvider.schools);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(FluentIcons.education, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? 'لا توجد مدارس مضافة بعد'
                : 'لم يتم العثور على مدارس مطابقة للبحث',
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          if (_searchQuery.isEmpty)
            FilledButton(
              onPressed: () => _showAddSchoolDialog(context),
              child: const Text('إضافة أول مدرسة'),
            ),
        ],
      ),
    );
  }

  Widget _buildSchoolGrid(List<School> schools) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: schools.length,
      itemBuilder: (context, index) {
        return SchoolCard(
          school: schools[index],
          onEdit: () => _showEditSchoolDialog(context, schools[index]),
          onDelete: () => _confirmDeleteSchool(context, schools[index]),
        );
      },
    );
  }

  void _showAddSchoolDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const AddSchoolDialog());
  }

  void _showEditSchoolDialog(BuildContext context, School school) {
    showDialog(
      context: context,
      builder: (context) => AddSchoolDialog(school: school),
    );
  }

  void _confirmDeleteSchool(BuildContext context, School school) {
    showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف مدرسة "${school.nameArabic}"؟'),
        actions: [
          Button(
            child: const Text('إلغاء'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await context.read<SchoolProvider>().deleteSchool(
                school.id!,
              );
              if (success && context.mounted) {
                _showSuccessMessage(context, 'تم حذف المدرسة بنجاح');
              }
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _showSuccessMessage(BuildContext context, String message) {
    // Show a simple dialog for success message
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
