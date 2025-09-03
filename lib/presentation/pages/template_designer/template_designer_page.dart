import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/template_provider.dart';
import '../../providers/template_designer_provider.dart';
import '../../widgets/template_designer/designer_canvas.dart';
import '../../widgets/template_designer/designer_toolbar.dart';
import '../../widgets/template_designer/elements_panel.dart';
import '../../widgets/template_designer/background_settings_panel.dart';
import '../../widgets/template_designer/element_properties_panel.dart';
import '../../../data/models/template.dart';

class TemplateDesignerPage extends StatefulWidget {
  final Template? initialTemplate;

  const TemplateDesignerPage({super.key, this.initialTemplate});

  @override
  State<TemplateDesignerPage> createState() => _TemplateDesignerPageState();
}

class _TemplateDesignerPageState extends State<TemplateDesignerPage> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          TemplateDesignerProvider()..loadTemplate(widget.initialTemplate),
      child: Consumer<TemplateDesignerProvider>(
        builder: (context, designerProvider, child) {
          return ScaffoldPage(
            header: const TemplateDesignerHeader(),
            content: Row(
              children: [
                // Left Panel - Elements
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: FluentTheme.of(context).cardColor,
                    border: Border(
                      right: BorderSide(
                        color: FluentTheme.of(
                          context,
                        ).resources.cardStrokeColorDefault,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Tab Buttons
                      Row(
                        children: [
                          Expanded(
                            child: Button(
                              onPressed: () =>
                                  setState(() => _currentTabIndex = 0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _currentTabIndex == 0
                                      ? FluentTheme.of(
                                          context,
                                        ).accentColor.withOpacity(0.1)
                                      : null,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: _currentTabIndex == 0
                                          ? FluentTheme.of(context).accentColor
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FluentIcons.settings, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      'إعدادات',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Button(
                              onPressed: () =>
                                  setState(() => _currentTabIndex = 1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _currentTabIndex == 1
                                      ? FluentTheme.of(
                                          context,
                                        ).accentColor.withOpacity(0.1)
                                      : null,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: _currentTabIndex == 1
                                          ? FluentTheme.of(context).accentColor
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FluentIcons.photo2, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      'خلفية',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Button(
                              onPressed: () =>
                                  setState(() => _currentTabIndex = 2),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _currentTabIndex == 2
                                      ? FluentTheme.of(
                                          context,
                                        ).accentColor.withOpacity(0.1)
                                      : null,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: _currentTabIndex == 2
                                          ? FluentTheme.of(context).accentColor
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(FluentIcons.stack, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      'طبقات',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Tab Content
                      Expanded(
                        child: _getTabContent(
                          _currentTabIndex,
                          designerProvider,
                        ),
                      ),
                    ],
                  ),
                ),
                // Center - Canvas
                Expanded(
                  child: Container(
                    color: const Color(0xFFF5F5F5),
                    child: Column(
                      children: [
                        // Toolbar
                        const DesignerToolbar(),
                        // Canvas
                        Expanded(child: Center(child: const DesignerCanvas())),
                      ],
                    ),
                  ),
                ),
                // Right Panel - Properties
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: FluentTheme.of(context).cardColor,
                    border: Border(
                      left: BorderSide(
                        color: FluentTheme.of(
                          context,
                        ).resources.cardStrokeColorDefault,
                      ),
                    ),
                  ),
                  child: ElementPropertiesPanel(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _getTabContent(int index, TemplateDesignerProvider provider) {
    switch (index) {
      case 0:
        return SingleChildScrollView(
          child: _buildTemplateSettings(context, provider),
        );
      case 1:
        return BackgroundSettingsPanel();
      case 2:
        return const ElementsPanel();
      default:
        return SingleChildScrollView(
          child: _buildTemplateSettings(context, provider),
        );
    }
  }
}

Widget _buildTemplateSettings(
  BuildContext context,
  TemplateDesignerProvider provider,
) {
  return Container(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إعدادات القالب',
          style: FluentTheme.of(context).typography.subtitle,
        ),
        const SizedBox(height: 12),

        // Template Name
        InfoLabel(
          label: 'اسم القالب',
          child: TextBox(
            controller: provider.templateNameController,
            placeholder: 'أدخل اسم القالب',
            onChanged: (value) => provider.updateTemplateName(value),
          ),
        ),
        const SizedBox(height: 12),

        // Dimensions
        Row(
          children: [
            Expanded(
              child: InfoLabel(
                label: 'العرض (سم)',
                child: NumberBox<double>(
                  value: provider.templateWidth,
                  onChanged: (value) => provider.updateTemplateDimensions(
                    width: value ?? provider.templateWidth,
                  ),
                  min: 1.0,
                  max: 30.0,
                  smallChange: 0.1,
                  largeChange: 1.0,
                  mode: SpinButtonPlacementMode.inline,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InfoLabel(
                label: 'الارتفاع (سم)',
                child: NumberBox<double>(
                  value: provider.templateHeight,
                  onChanged: (value) => provider.updateTemplateDimensions(
                    height: value ?? provider.templateHeight,
                  ),
                  min: 1.0,
                  max: 30.0,
                  smallChange: 0.1,
                  largeChange: 1.0,
                  mode: SpinButtonPlacementMode.inline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Orientation
        InfoLabel(
          label: 'الاتجاه',
          child: ComboBox<String>(
            value: provider.templateOrientation,
            items: const [
              ComboBoxItem(value: 'horizontal', child: Text('أفقي')),
              ComboBoxItem(value: 'vertical', child: Text('عمودي')),
            ],
            onChanged: (value) =>
                provider.updateTemplateOrientation(value ?? 'horizontal'),
          ),
        ),
        const SizedBox(height: 12),

        // Quick Size Presets
        InfoLabel(
          label: 'أحجام جاهزة',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSizePreset(provider, 'ماستر كارد', 8.56, 5.398),
              _buildSizePreset(provider, 'بطاقة عمل', 9.0, 5.0),
              _buildSizePreset(provider, 'A7', 10.5, 7.4),
              _buildSizePreset(
                provider,
                'مخصص',
                provider.templateWidth,
                provider.templateHeight,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Quick Add Section
        _buildQuickAddSection(provider),
      ],
    ),
  );
}

Widget _buildQuickAddSection(TemplateDesignerProvider provider) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إضافة عنصر جديد',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 12),

          // Text Elements
          _buildAddTextSection(provider),
          const SizedBox(height: 8),

          // Image Elements
          _buildAddImageSection(provider),
          const SizedBox(height: 8),

          // Shape Elements
          _buildAddShapeSection(provider),
        ],
      ),
    ),
  );
}

Widget _buildAddTextSection(TemplateDesignerProvider provider) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('نصوص', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      const SizedBox(height: 4),
      GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: [
          _buildQuickAddButton(
            'اسم الطالب',
            FluentIcons.contact,
            () => provider.addTextElement(
              text: 'الاسم: {student_name}',
              properties: {'fontWeight': 'bold'},
            ),
          ),
          _buildQuickAddButton(
            'اسم المدرسة',
            FluentIcons.education,
            () => provider.addTextElement(
              text: '{school_name_arabic}',
              properties: {'fontSize': 16, 'fontWeight': 'bold'},
            ),
          ),
          _buildQuickAddButton(
            'الصف',
            FluentIcons.number_field,
            () => provider.addTextElement(text: 'الصف: {student_grade}'),
          ),
          _buildQuickAddButton(
            'تاريخ الميلاد',
            FluentIcons.calendar,
            () => provider.addTextElement(
              text: 'تاريخ الميلاد: {student_birth_date}',
              properties: {'fontSize': 10},
            ),
          ),
          _buildQuickAddButton(
            'نص مخصص',
            FluentIcons.text_field,
            () => provider.addTextElement(text: 'نص جديد'),
          ),
        ],
      ),
    ],
  );
}

Widget _buildAddImageSection(TemplateDesignerProvider provider) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('صور', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      const SizedBox(height: 4),
      GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: [
          _buildQuickAddButton(
            'صورة الطالب',
            FluentIcons.contact,
            () => provider.addImageElement(
              source: 'student_photo',
              width: 1.5,
              height: 2.0,
            ),
          ),
          _buildQuickAddButton(
            'شعار المدرسة',
            FluentIcons.education,
            () => provider.addImageElement(
              source: 'school_logo',
              width: 2.0,
              height: 2.0,
            ),
          ),
          _buildQuickAddButton(
            'صورة مخصصة',
            FluentIcons.photo2,
            () => provider.addImageElement(source: 'custom_image'),
          ),
        ],
      ),
    ],
  );
}

Widget _buildAddShapeSection(TemplateDesignerProvider provider) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'أشكال',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 4),
      GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: [
          _buildQuickAddButton(
            'مستطيل',
            FluentIcons.stop,
            () => provider.addShapeElement(shapeType: 'rectangle'),
          ),
          _buildQuickAddButton(
            'دائرة',
            FluentIcons.radio_btn_on,
            () => provider.addShapeElement(shapeType: 'circle'),
          ),
          _buildQuickAddButton(
            'خط',
            FluentIcons.line,
            () => provider.addShapeElement(shapeType: 'line', height: 0.1),
          ),
        ],
      ),
    ],
  );
}

Widget _buildQuickAddButton(
  String label,
  IconData icon,
  VoidCallback onPressed,
) {
  return Button(
    onPressed: onPressed,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 9),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

Widget _buildSizePreset(
  TemplateDesignerProvider provider,
  String name,
  double width,
  double height,
) {
  final isSelected =
      (provider.templateWidth - width).abs() < 0.1 &&
      (provider.templateHeight - height).abs() < 0.1;

  return Button(
    onPressed: () =>
        provider.updateTemplateDimensions(width: width, height: height),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        name,
        style: TextStyle(fontSize: 10, color: isSelected ? Colors.blue : null),
      ),
    ),
  );
}

class TemplateDesignerHeader extends StatelessWidget {
  const TemplateDesignerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TemplateDesignerProvider>(
      builder: (context, provider, child) {
        return CommandBar(
          primaryItems: [
            CommandBarBuilderItem(
              builder: (context, mode, w) =>
                  Tooltip(message: 'حفظ القالب', child: w),
              wrappedItem: CommandBarButton(
                icon: const Icon(FluentIcons.save),
                label: Text('حفظ', style: TextStyle(color: Colors.black)),
                onPressed: () => _saveTemplate(context, provider),
              ),
            ),
            CommandBarBuilderItem(
              builder: (context, mode, w) =>
                  Tooltip(message: 'معاينة الهوية', child: w),
              wrappedItem: CommandBarButton(
                icon: const Icon(FluentIcons.view),
                label: Text('معاينة', style: TextStyle(color: Colors.black)),
                onPressed: () => _previewTemplate(context, provider),
              ),
            ),
            CommandBarBuilderItem(
              builder: (context, mode, w) =>
                  Tooltip(message: 'استيراد قالب', child: w),
              wrappedItem: CommandBarButton(
                icon: const Icon(FluentIcons.open_file),
                label: Text('استيراد', style: TextStyle(color: Colors.black)),
                onPressed: () => _importTemplate(context, provider),
              ),
            ),
            CommandBarBuilderItem(
              builder: (context, mode, w) =>
                  Tooltip(message: 'تصدير القالب', child: w),
              wrappedItem: CommandBarButton(
                icon: const Icon(FluentIcons.download),
                label: Text('تصدير', style: TextStyle(color: Colors.black)),
                onPressed: () => _exportTemplate(context, provider),
              ),
            ),
          ],
          secondaryItems: [
            CommandBarButton(
              icon: const Icon(FluentIcons.undo),
              label: Text('تراجع', style: TextStyle(color: Colors.black)),
              onPressed: provider.canUndo ? () => provider.undo() : null,
            ),
            CommandBarButton(
              icon: const Icon(FluentIcons.redo),
              label: Text('إعادة', style: TextStyle(color: Colors.black)),
              onPressed: provider.canRedo ? () => provider.redo() : null,
            ),
            CommandBarButton(
              icon: const Icon(FluentIcons.delete),
              label: Text(
                'حذف العنصر المحدد',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: provider.selectedElement != null
                  ? () => provider.deleteSelectedElement()
                  : null,
            ),
          ],
        );
      },
    );
  }

  void _saveTemplate(
    BuildContext context,
    TemplateDesignerProvider provider,
  ) async {
    final templateProvider = context.read<TemplateProvider>();
    final template = provider.buildTemplate();

    final success = await templateProvider.addTemplate(template);

    if (success && context.mounted) {
      showDialog(
        context: context,
        builder: (context) => ContentDialog(
          title: Text('تم الحفظ', style: TextStyle(color: Colors.black)),
          content: Text(
            'تم حفظ القالب بنجاح',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            Button(
              child: Text('موافق', style: TextStyle(color: Colors.black)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  void _previewTemplate(
    BuildContext context,
    TemplateDesignerProvider provider,
  ) {
    // TODO: Implement template preview
    showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: Text('معاينة', style: TextStyle(color: Colors.black)),
        content: Text(
          'سيتم تنفيذ ميزة المعاينة قريباً',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Button(
            child: Text('موافق', style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _importTemplate(
    BuildContext context,
    TemplateDesignerProvider provider,
  ) {
    // TODO: Implement template import
    showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: Text('استيراد', style: TextStyle(color: Colors.black)),
        content: Text(
          'سيتم تنفيذ ميزة الاستيراد قريباً',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Button(
            child: Text('موافق', style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _exportTemplate(
    BuildContext context,
    TemplateDesignerProvider provider,
  ) {
    // TODO: Implement template export
    showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: Text('تصدير', style: TextStyle(color: Colors.black)),
        content: Text(
          'سيتم تنفيذ ميزة التصدير قريباً',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Button(
            child: Text('موافق', style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
