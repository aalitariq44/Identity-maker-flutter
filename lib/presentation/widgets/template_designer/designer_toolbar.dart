import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../providers/template_designer_provider.dart';

class DesignerToolbar extends StatelessWidget {
  const DesignerToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TemplateDesignerProvider>(
      builder: (context, provider, child) {
        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: FluentTheme.of(context).cardColor,
            border: Border(
              bottom: BorderSide(
                color: FluentTheme.of(context).resources.cardStrokeColorDefault,
              ),
            ),
          ),
          child: Row(
            children: [
              // Quick Add Elements
              _buildQuickAddSection(provider),
              Container(
                height: 30,
                width: 1,
                color: FluentTheme.of(context).resources.cardStrokeColorDefault,
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),

              // Zoom Controls
              _buildZoomSection(provider),
              Container(
                height: 30,
                width: 1,
                color: FluentTheme.of(context).resources.cardStrokeColorDefault,
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),

              // Alignment Tools
              _buildAlignmentSection(provider),
              Container(
                height: 30,
                width: 1,
                color: FluentTheme.of(context).resources.cardStrokeColorDefault,
                margin: const EdgeInsets.symmetric(horizontal: 8),
              ),

              // Layer Controls
              _buildLayerSection(provider),

              const Spacer(),

              // View Controls
              _buildViewSection(provider, context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickAddSection(TemplateDesignerProvider provider) {
    return Row(
      children: [
        Text(
          'إضافة عنصر:',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 8),

        // Add Text
        Tooltip(
          message: 'إضافة نص',
          child: Button(
            onPressed: () => _showAddTextDialog(provider),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(FluentIcons.text_field, size: 16),
                const SizedBox(width: 4),
                Text('نص', style: TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 4),

        // Add Image
        Tooltip(
          message: 'إضافة صورة',
          child: DropDownButton(
            leading: Icon(FluentIcons.photo2, size: 16),
            items: [
              MenuFlyoutItem(
                leading: Icon(FluentIcons.contact),
                text: Text('صورة الطالب'),
                onPressed: () =>
                    provider.addImageElement(source: 'student_photo'),
              ),
              MenuFlyoutItem(
                leading: Icon(FluentIcons.education),
                text: Text('شعار المدرسة'),
                onPressed: () =>
                    provider.addImageElement(source: 'school_logo'),
              ),
              MenuFlyoutItem(
                leading: Icon(FluentIcons.photo2),
                text: Text('صورة مخصصة'),
                onPressed: () =>
                    provider.addImageElement(source: 'custom_image'),
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),

        // Add Shape
        Tooltip(
          message: 'إضافة شكل',
          child: DropDownButton(
            leading: Icon(FluentIcons.shapes, size: 16),
            items: [
              MenuFlyoutItem(
                leading: Icon(FluentIcons.stop),
                text: Text('مربع'),
                onPressed: () =>
                    provider.addShapeElement(shapeType: 'rectangle'),
              ),
              MenuFlyoutItem(
                leading: Icon(FluentIcons.radio_btn_on),
                text: Text('دائرة'),
                onPressed: () => provider.addShapeElement(shapeType: 'circle'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildZoomSection(TemplateDesignerProvider provider) {
    return Row(
      children: [
        Text(
          'التكبير:',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 8),

        // Zoom Out
        Tooltip(
          message: 'تصغير',
          child: Button(
            onPressed: () => provider.setCanvasZoom(provider.canvasZoom - 0.1),
            child: Icon(FluentIcons.remove, size: 16),
          ),
        ),
        const SizedBox(width: 4),

        // Zoom Percentage
        Container(
          width: 60,
          child: Text(
            '${(provider.canvasZoom * 100).round()}%',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11),
          ),
        ),
        const SizedBox(width: 4),

        // Zoom In
        Tooltip(
          message: 'تكبير',
          child: Button(
            onPressed: () => provider.setCanvasZoom(provider.canvasZoom + 0.1),
            child: Icon(FluentIcons.add, size: 16),
          ),
        ),
        const SizedBox(width: 4),

        // Fit to Window
        Tooltip(
          message: 'ملائمة للنافذة',
          child: Button(
            onPressed: () => provider.resetCanvasView(),
            child: Icon(FluentIcons.fit_page, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildAlignmentSection(TemplateDesignerProvider provider) {
    final hasSelection = provider.selectedElement != null;

    return Row(
      children: [
        Text(
          'محاذاة:',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 8),

        // Align Left
        Tooltip(
          message: 'محاذاة لليسار',
          child: Button(
            onPressed: hasSelection
                ? () => _alignElement(provider, 'left')
                : null,
            child: Icon(FluentIcons.align_left, size: 16),
          ),
        ),
        const SizedBox(width: 2),

        // Align Center
        Tooltip(
          message: 'محاذاة للوسط',
          child: Button(
            onPressed: hasSelection
                ? () => _alignElement(provider, 'center')
                : null,
            child: Icon(FluentIcons.align_center, size: 16),
          ),
        ),
        const SizedBox(width: 2),

        // Align Right
        Tooltip(
          message: 'محاذاة لليمين',
          child: Button(
            onPressed: hasSelection
                ? () => _alignElement(provider, 'right')
                : null,
            child: Icon(FluentIcons.align_right, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildLayerSection(TemplateDesignerProvider provider) {
    final hasSelection = provider.selectedElement != null;

    return Row(
      children: [
        Text(
          'طبقات:',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 8),

        // Bring to Front
        Tooltip(
          message: 'إحضار للمقدمة',
          child: Button(
            onPressed: hasSelection
                ? () => provider.bringToFront(provider.selectedElement!.id)
                : null,
            child: Icon(FluentIcons.up, size: 16),
          ),
        ),
        const SizedBox(width: 2),

        // Send to Back
        Tooltip(
          message: 'إرسال للخلف',
          child: Button(
            onPressed: hasSelection
                ? () => provider.sendToBack(provider.selectedElement!.id)
                : null,
            child: Icon(FluentIcons.down, size: 16),
          ),
        ),
        const SizedBox(width: 4),

        // Duplicate
        Tooltip(
          message: 'نسخ العنصر',
          child: Button(
            onPressed: hasSelection
                ? () => provider.duplicateElement(provider.selectedElement!.id)
                : null,
            child: Icon(FluentIcons.copy, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildViewSection(
    TemplateDesignerProvider provider,
    BuildContext context,
  ) {
    return Row(
      children: [
        Text(
          'عرض:',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 8),

        // Clear All
        Tooltip(
          message: 'مسح الكل',
          child: Button(
            onPressed: provider.elements.isNotEmpty
                ? () => _showClearAllDialog(provider, context)
                : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(FluentIcons.clear, size: 16),
                const SizedBox(width: 4),
                Text('مسح الكل', style: TextStyle(fontSize: 11)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showAddTextDialog(TemplateDesignerProvider provider) {
    // This would show a dialog to add text with properties
    provider.addTextElement(text: 'نص جديد');
  }

  void _alignElement(TemplateDesignerProvider provider, String alignment) {
    final element = provider.selectedElement;
    if (element == null) return;

    double newX = element.x;

    switch (alignment) {
      case 'left':
        newX = 0;
        break;
      case 'center':
        newX = (provider.templateWidth - element.width) / 2;
        break;
      case 'right':
        newX = provider.templateWidth - element.width;
        break;
    }

    provider.moveElement(element.id, newX - element.x, 0);
  }

  void _showClearAllDialog(
    TemplateDesignerProvider provider,
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (context) => ContentDialog(
        title: Text('مسح جميع العناصر', style: TextStyle(color: Colors.black)),
        content: Text(
          'هل أنت متأكد من مسح جميع العناصر من القالب؟',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Button(
            child: Text('إلغاء', style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FilledButton(
            child: Text('مسح', style: TextStyle(color: Colors.black)),
            onPressed: () {
              provider.clearAll();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
