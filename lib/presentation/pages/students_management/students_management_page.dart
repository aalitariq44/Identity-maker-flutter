import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../providers/school_provider.dart';
import '../../providers/student_provider.dart';
import '../../widgets/school_widgets/school_management_panel.dart';
import '../../widgets/student_widgets/student_management_panel.dart';

class StudentsManagementPage extends StatefulWidget {
  const StudentsManagementPage({super.key});

  @override
  State<StudentsManagementPage> createState() => _StudentsManagementPageState();
}

class _StudentsManagementPageState extends State<StudentsManagementPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  void _loadInitialData() {
    final schoolProvider = context.read<SchoolProvider>();
    final studentProvider = context.read<StudentProvider>();

    schoolProvider.loadSchools();
    studentProvider.loadStudentsWithSchoolInfo();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      content: ScaffoldPage(
        header: PageHeader(
          title: Text(
            'إدارة الطلاب والمدارس',
            style: TextStyle(color: Colors.black),
          ),
        ),
        content: Row(
          children: [
            // Navigation Panel
            Container(
              width: 200,
              color: const Color(0xFFF3F2F1),
              child: Column(
                children: [
                  _buildNavigationItem(
                    icon: FluentIcons.education,
                    title: 'المدارس',
                    isSelected: _selectedIndex == 0,
                    onTap: () => setState(() => _selectedIndex = 0),
                  ),
                  _buildNavigationItem(
                    icon: FluentIcons.people,
                    title: 'الطلاب',
                    isSelected: _selectedIndex == 1,
                    onTap: () => setState(() => _selectedIndex = 1),
                  ),
                ],
              ),
            ),
            // Content Area
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: _buildSelectedPanel(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedPanel() {
    switch (_selectedIndex) {
      case 0:
        return const SchoolManagementPanel();
      case 1:
        return const StudentManagementPanel();
      default:
        return const SchoolManagementPanel();
    }
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0078D4) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF323130),
              size: 16,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
