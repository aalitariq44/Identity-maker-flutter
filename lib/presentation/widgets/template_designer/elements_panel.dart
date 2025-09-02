import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../providers/template_designer_provider.dart';

class ElementsPanel extends StatelessWidget {
  const ElementsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TemplateDesignerProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    'العناصر',
                    style: FluentTheme.of(context).typography.subtitle,
                  ),
                  const Spacer(),
                  Text(
                    '${provider.elements.length}',
                    style: FluentTheme.of(context).typography.caption,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Quick Add Section
              _buildQuickAddSection(provider),
              const SizedBox(height: 16),

              // Elements List
              Expanded(child: _buildElementsList(provider)),
            ],
          ),
        );
      },
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
        Text(
          'نصوص',
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
        Text(
          'صور',
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

  Widget _buildElementsList(TemplateDesignerProvider provider) {
    if (provider.elements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FluentIcons.stack,
              size: 48,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'لا توجد عناصر',
              style: TextStyle(
                color: Colors.grey.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'أضف عنصر لبدء التصميم',
              style: TextStyle(
                color: Colors.grey.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    // Sort elements by zIndex
    final sortedElements = List.from(provider.elements)
      ..sort((a, b) => b.zIndex.compareTo(a.zIndex));

    return ListView.builder(
      itemCount: sortedElements.length,
      itemBuilder: (context, index) {
        final element = sortedElements[index];
        final isSelected = provider.selectedElement?.id == element.id;

        return _buildElementItem(provider, element, isSelected);
      },
    );
  }

  Widget _buildElementItem(
    TemplateDesignerProvider provider,
    element,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Card(
        backgroundColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
        borderColor: isSelected ? Colors.blue : null,
        child: ListTile(
          leading: _getElementIcon(element),
          title: Text(
            _getElementTitle(element),
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          subtitle: Text(
            _getElementSubtitle(element),
            style: TextStyle(fontSize: 10),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Visibility Toggle
              IconButton(
                icon: Icon(
                  element.properties['visible'] == false
                      ? FluentIcons.hide
                      : FluentIcons.view,
                  size: 12,
                ),
                onPressed: () => _toggleElementVisibility(provider, element),
              ),
              // More Options
              DropDownButton(
                leading: Icon(FluentIcons.more, size: 12),
                items: [
                  MenuFlyoutItem(
                    leading: Icon(FluentIcons.copy),
                    text: Text('نسخ'),
                    onPressed: () => provider.duplicateElement(element.id),
                  ),
                  MenuFlyoutItem(
                    leading: Icon(FluentIcons.up),
                    text: Text('للمقدمة'),
                    onPressed: () => provider.bringToFront(element.id),
                  ),
                  MenuFlyoutItem(
                    leading: Icon(FluentIcons.down),
                    text: Text('للخلف'),
                    onPressed: () => provider.sendToBack(element.id),
                  ),
                  MenuFlyoutSeparator(),
                  MenuFlyoutItem(
                    leading: Icon(FluentIcons.delete),
                    text: Text('حذف'),
                    onPressed: () => provider.deleteElement(element.id),
                  ),
                ],
              ),
            ],
          ),
          onPressed: () => provider.selectElement(element),
        ),
      ),
    );
  }

  Icon _getElementIcon(element) {
    switch (element.type) {
      case 'text':
        return Icon(FluentIcons.text_field, size: 16);
      case 'image':
        final source = element.properties['source'] as String? ?? '';
        if (source == 'student_photo') {
          return Icon(FluentIcons.contact, size: 16);
        } else if (source == 'school_logo') {
          return Icon(FluentIcons.education, size: 16);
        }
        return Icon(FluentIcons.photo2, size: 16);
      case 'shape':
        final shapeType = element.properties['shapeType'] as String? ?? '';
        if (shapeType == 'circle') {
          return Icon(FluentIcons.radio_btn_on, size: 16);
        } else if (shapeType == 'line') {
          return Icon(FluentIcons.line, size: 16);
        }
        return Icon(FluentIcons.stop, size: 16);
      default:
        return Icon(FluentIcons.unknown_solid, size: 16);
    }
  }

  String _getElementTitle(element) {
    switch (element.type) {
      case 'text':
        final text = element.properties['text'] as String? ?? '';
        if (text.length > 20) {
          return '${text.substring(0, 20)}...';
        }
        return text.isEmpty ? 'نص فارغ' : text;
      case 'image':
        final source = element.properties['source'] as String? ?? '';
        switch (source) {
          case 'student_photo':
            return 'صورة الطالب';
          case 'school_logo':
            return 'شعار المدرسة';
          default:
            return 'صورة مخصصة';
        }
      case 'shape':
        final shapeType = element.properties['shapeType'] as String? ?? '';
        switch (shapeType) {
          case 'circle':
            return 'دائرة';
          case 'line':
            return 'خط';
          default:
            return 'مستطيل';
        }
      default:
        return 'عنصر غير معروف';
    }
  }

  String _getElementSubtitle(element) {
    return 'الموضع: ${element.x.toStringAsFixed(1)}, ${element.y.toStringAsFixed(1)} سم '
        '• الحجم: ${element.width.toStringAsFixed(1)}×${element.height.toStringAsFixed(1)} سم';
  }

  void _toggleElementVisibility(TemplateDesignerProvider provider, element) {
    final updatedProperties = Map<String, dynamic>.from(element.properties);
    updatedProperties['visible'] =
        !(updatedProperties['visible'] as bool? ?? true);

    final updatedElement = element.copyWith(properties: updatedProperties);
    provider.updateSelectedElement(updatedElement);
  }
}
