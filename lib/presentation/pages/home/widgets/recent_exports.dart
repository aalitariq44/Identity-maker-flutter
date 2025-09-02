import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/dimensions.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/utils/app_localizations.dart';
import '../../../../data/models/export_record.dart';
import '../../../providers/export_provider.dart';
import '../../../widgets/common/rtl_widgets.dart';

class RecentExports extends StatefulWidget {
  const RecentExports({super.key});

  @override
  State<RecentExports> createState() => _RecentExportsState();
}

class _RecentExportsState extends State<RecentExports> {
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
          RtlRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LocalizedText(
                (l) => l.recentExports,
                style: FluentTheme.of(context).typography.subtitle,
              ),
              Button(
                onPressed: () {
                  // Navigate to exports page
                },
                child: LocalizedText((l) => 'عرض الكل'),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.marginLarge),
          Expanded(
            child: Consumer<ExportProvider>(
              builder: (context, exportProvider, child) {
                if (exportProvider.isLoading) {
                  return const Center(child: ProgressRing());
                }

                if (exportProvider.exportRecords.isEmpty) {
                  return Center(
                    child: RtlColumn(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FluentIcons.export,
                          size: 48,
                          color: AppColors.textHint,
                        ),
                        const SizedBox(height: AppDimensions.marginMedium),
                        LocalizedText(
                          (l) => 'لا توجد عمليات تصدير حتى الآن',
                          style: FluentTheme.of(context).typography.body
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                final recentExports = exportProvider.exportRecords
                    .take(5)
                    .toList();

                return ListView.separated(
                  itemCount: recentExports.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppDimensions.marginSmall),
                  itemBuilder: (context, index) {
                    final export = recentExports[index];
                    return _buildExportItem(export);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportItem(ExportRecord export) {
    return RtlContainer(
      padding: const EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: RtlRow(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: Icon(FluentIcons.pdf, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: AppDimensions.marginMedium),
          Expanded(
            child: RtlColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  export.fileName,
                  style: FluentTheme.of(
                    context,
                  ).typography.body?.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimensions.marginTiny),
                Text(
                  '${export.totalStudents} طالب - ${_formatDateTime(export.exportedAt)}',
                  style: FluentTheme.of(context).typography.caption?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(FluentIcons.more),
            onPressed: () {
              _showExportOptions(context, export);
            },
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }

  void _showExportOptions(BuildContext context, ExportRecord export) {
    showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('خيارات التصدير'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Button(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Open file
              },
              child: Row(
                children: [
                  const Icon(FluentIcons.open_file),
                  const SizedBox(width: 8),
                  const Text('فتح الملف'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Button(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Open folder
              },
              child: Row(
                children: [
                  const Icon(FluentIcons.folder_open),
                  const SizedBox(width: 8),
                  const Text('فتح المجلد'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Button(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteExport(context, export);
              },
              child: Row(
                children: [
                  const Icon(FluentIcons.delete),
                  const SizedBox(width: 8),
                  const Text('حذف السجل'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Button(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  void _deleteExport(BuildContext context, ExportRecord export) {
    showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف سجل التصدير؟'),
        actions: [
          Button(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final exportProvider = context.read<ExportProvider>();
              await exportProvider.deleteExportRecord(export.id!);
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}
