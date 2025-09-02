import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/dimensions.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/app_localizations.dart';
import '../../../providers/school_provider.dart';
import '../../../providers/student_provider.dart';
import '../../../providers/template_provider.dart';
import '../../../providers/export_provider.dart';
import '../../../widgets/common/rtl_widgets.dart';

class DashboardStats extends StatefulWidget {
  const DashboardStats({super.key});

  @override
  State<DashboardStats> createState() => _DashboardStatsState();
}

class _DashboardStatsState extends State<DashboardStats> {
  @override
  void initState() {
    super.initState();
    // Load data after the current build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final schoolProvider = context.read<SchoolProvider>();
    final studentProvider = context.read<StudentProvider>();
    final templateProvider = context.read<TemplateProvider>();
    final exportProvider = context.read<ExportProvider>();

    schoolProvider.loadSchools();
    studentProvider.loadStudents();
    templateProvider.loadTemplates();
    exportProvider.loadExportRecords();
  }

  @override
  Widget build(BuildContext context) {
    return RtlContainer(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: AppColors.border),
      ),
      child: RtlColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LocalizedText(
            (l) => l.statistics,
            style: FluentTheme.of(context).typography.subtitle,
          ),
          const SizedBox(height: AppDimensions.marginLarge),
          Expanded(
            child:
                Consumer4<
                  SchoolProvider,
                  StudentProvider,
                  TemplateProvider,
                  ExportProvider
                >(
                  builder:
                      (
                        context,
                        schoolProvider,
                        studentProvider,
                        templateProvider,
                        exportProvider,
                        child,
                      ) {
                        final exportStats = exportProvider
                            .getExportStatistics();

                        return GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: AppDimensions.marginMedium,
                          crossAxisSpacing: AppDimensions.marginMedium,
                          childAspectRatio: 1.5,
                          children: [
                            _buildStatCard(
                              context,
                              (l) => l.schools,
                              schoolProvider.schools.length.toString(),
                              FluentIcons.education,
                              AppColors.primary,
                            ),
                            _buildStatCard(
                              context,
                              (l) => l.students,
                              studentProvider.students.length.toString(),
                              FluentIcons.people,
                              AppColors.secondary,
                            ),
                            _buildStatCard(
                              context,
                              (l) => l.templates,
                              templateProvider.templates.length.toString(),
                              FluentIcons.design,
                              AppColors.success,
                            ),
                            _buildStatCard(
                              context,
                              (l) => l.export,
                              exportStats['totalExports'].toString(),
                              FluentIcons.export,
                              AppColors.warning,
                            ),
                          ],
                        );
                      },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String Function(AppLocalizations) titleCallback,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: RtlColumn(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: AppDimensions.marginSmall),
          Text(
            value,
            style: FluentTheme.of(context).typography.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.marginTiny),
          LocalizedText(
            titleCallback,
            style: FluentTheme.of(
              context,
            ).typography.body?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
