import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../../data/models/template.dart';
import '../../providers/template_provider.dart';
import '../template_designer/template_designer_page.dart';

class TemplateManagementPage extends StatefulWidget {
  const TemplateManagementPage({super.key});

  @override
  State<TemplateManagementPage> createState() => _TemplateManagementPageState();
}

class _TemplateManagementPageState extends State<TemplateManagementPage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load templates when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TemplateProvider>().loadTemplates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: const Text('إدارة القوالب'),
        commandBar: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FilledButton(
              onPressed: () => _openTemplateDesigner(context, null),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(FluentIcons.add, size: 16),
                  SizedBox(width: 8),
                  Text('قالب جديد'),
                ],
              ),
            ),
          ],
        ),
      ),
      content: Consumer<TemplateProvider>(
        builder: (context, templateProvider, child) {
          if (templateProvider.isLoading) {
            return const Center(child: ProgressRing());
          }

          if (templateProvider.errorMessage != null) {
            return Center(
              child: InfoBar(
                title: const Text('خطأ'),
                content: Text(templateProvider.errorMessage!),
                severity: InfoBarSeverity.error,
              ),
            );
          }

          final templates = templateProvider.searchTemplates(_searchQuery);

          return Column(
            children: [
              // Search and Filter Bar
              _buildSearchAndFilters(templateProvider),
              const SizedBox(height: 16),

              // Templates Grid
              Expanded(
                child: templates.isEmpty
                    ? _buildEmptyState()
                    : _buildTemplatesGrid(templates),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchAndFilters(TemplateProvider templateProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Search Box
          Expanded(
            flex: 2,
            child: TextBox(
              placeholder: 'البحث في القوالب...',
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              prefix: const Icon(FluentIcons.search),
            ),
          ),
          const SizedBox(width: 16),

          // Orientation Filter
          ComboBox<String>(
            placeholder: const Text('جميع الاتجاهات'),
            items: const [
              ComboBoxItem(value: '', child: Text('جميع الاتجاهات')),
              ComboBoxItem(value: 'horizontal', child: Text('أفقي')),
              ComboBoxItem(value: 'vertical', child: Text('عمودي')),
            ],
            onChanged: (value) {
              // TODO: Implement orientation filter
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FluentIcons.design, size: 64, color: Colors.grey[120]),
          const SizedBox(height: 24),
          Text(
            'لا توجد قوالب',
            style: FluentTheme.of(
              context,
            ).typography.subtitle?.copyWith(color: Colors.grey[120]),
          ),
          const SizedBox(height: 8),
          Text(
            'ابدأ بإنشاء قالب جديد لتصميم هويات الطلاب',
            style: FluentTheme.of(
              context,
            ).typography.body?.copyWith(color: Colors.grey[100]),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => _openTemplateDesigner(context, null),
            child: const Text('إنشاء قالب جديد'),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatesGrid(List<Template> templates) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        return _buildTemplateCard(templates[index]);
      },
    );
  }

  Widget _buildTemplateCard(Template template) {
    return Card(
      child: GestureDetector(
        onTap: () => _openTemplateDesigner(context, template),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Template Preview
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[10],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[50]),
                  ),
                  child: Stack(
                    children: [
                      // Preview Content
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FluentIcons.design,
                              size: 32,
                              color: Colors.grey[100],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${template.width.toStringAsFixed(1)}×${template.height.toStringAsFixed(1)} سم',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[120],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Orientation Badge
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: template.orientation == 'horizontal'
                                ? Colors.blue.withOpacity(0.1)
                                : Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            template.orientation == 'horizontal'
                                ? 'أفقي'
                                : 'عمودي',
                            style: TextStyle(
                              fontSize: 8,
                              color: template.orientation == 'horizontal'
                                  ? Colors.blue
                                  : Colors.green,
                            ),
                          ),
                        ),
                      ),

                      // Actions Menu
                      Positioned(
                        top: 8,
                        left: 8,
                        child: DropDownButton(
                          leading: Icon(FluentIcons.more, size: 12),
                          items: [
                            MenuFlyoutItem(
                              leading: const Icon(FluentIcons.edit),
                              text: const Text('تعديل'),
                              onPressed: () =>
                                  _openTemplateDesigner(context, template),
                            ),
                            MenuFlyoutItem(
                              leading: const Icon(FluentIcons.copy),
                              text: const Text('نسخ'),
                              onPressed: () => _duplicateTemplate(template),
                            ),
                            MenuFlyoutSeparator(),
                            MenuFlyoutItem(
                              leading: const Icon(FluentIcons.delete),
                              text: const Text('حذف'),
                              onPressed: () => _deleteTemplate(template),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Template Info
              Text(
                template.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              Row(
                children: [
                  Icon(FluentIcons.stack, size: 12, color: Colors.grey[120]),
                  const SizedBox(width: 4),
                  Text(
                    '${template.elements.length} عنصر',
                    style: TextStyle(fontSize: 11, color: Colors.grey[120]),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(template.updatedAt),
                    style: TextStyle(fontSize: 10, color: Colors.grey[100]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openTemplateDesigner(BuildContext context, Template? template) {
    Navigator.of(context).push(
      FluentPageRoute(
        builder: (context) => TemplateDesignerPage(initialTemplate: template),
      ),
    );
  }

  void _duplicateTemplate(Template template) {
    final duplicatedTemplate = template.copyWith(
      id: null,
      name: '${template.name} - نسخة',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    context.read<TemplateProvider>().addTemplate(duplicatedTemplate);
  }

  void _deleteTemplate(Template template) {
    showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('حذف القالب'),
        content: Text('هل أنت متأكد من حذف القالب "${template.name}"؟'),
        actions: [
          Button(
            child: const Text('إلغاء'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FilledButton(
            child: const Text('حذف'),
            onPressed: () {
              if (template.id != null) {
                context.read<TemplateProvider>().deleteTemplate(template.id!);
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
