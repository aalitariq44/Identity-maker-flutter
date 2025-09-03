import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../providers/template_designer_provider.dart';
import '../../../core/constants/image_fit_constants.dart';

class BackgroundSettingsPanel extends StatefulWidget {
  const BackgroundSettingsPanel({super.key});

  @override
  State<BackgroundSettingsPanel> createState() =>
      _BackgroundSettingsPanelState();
}

class _BackgroundSettingsPanelState extends State<BackgroundSettingsPanel> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TemplateDesignerProvider>(
      builder: (context, provider, child) {
        final backgroundProps = provider.backgroundProperties;
        final hasImage =
            backgroundProps['image'] != null &&
            backgroundProps['image'] != 'none';

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'إعدادات الخلفية',
                  style: FluentTheme.of(context).typography.subtitle,
                ),
                const SizedBox(height: 16),

                // لون الخلفية
                _buildColorSection(provider, backgroundProps),
                const SizedBox(height: 16),

                // الشفافية
                _buildOpacitySection(provider, backgroundProps),
                const SizedBox(height: 16),

                // قسم الصورة
                _buildImageSection(provider, backgroundProps, hasImage),

                // إعدادات عرض الصورة
                if (hasImage) ...[
                  const SizedBox(height: 16),
                  _buildImageFitSection(provider, backgroundProps),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildColorSection(
    TemplateDesignerProvider provider,
    Map<String, dynamic> props,
  ) {
    final colorHex = props['color'] as String? ?? '#FFFFFF';
    final color = _parseColor(colorHex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('لون الخلفية'),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: Colors.grey[100]),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextBox(
                placeholder: '#FFFFFF',
                controller: TextEditingController(text: colorHex),
                onChanged: (value) {
                  if (value.startsWith('#') && value.length == 7) {
                    provider.updateBackgroundProperties({
                      ...props,
                      'color': value,
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // ألوان سريعة
        Wrap(
          spacing: 8,
          children:
              [
                    '#FFFFFF',
                    '#F5F5F5',
                    '#E0E0E0',
                    '#BDBDBD',
                    '#2196F3',
                    '#4CAF50',
                    '#FF9800',
                    '#F44336',
                    '#9C27B0',
                    '#607D8B',
                    '#795548',
                    '#000000',
                  ]
                  .map(
                    (colorValue) =>
                        _buildQuickColorButton(provider, props, colorValue),
                  )
                  .toList(),
        ),
      ],
    );
  }

  Widget _buildOpacitySection(
    TemplateDesignerProvider provider,
    Map<String, dynamic> props,
  ) {
    final opacity = (props['opacity'] as num?)?.toDouble() ?? 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('الشفافية'), Text('${(opacity * 100).round()}%')],
        ),
        const SizedBox(height: 8),
        Slider(
          value: opacity,
          min: 0.0,
          max: 1.0,
          divisions: 20,
          onChanged: (value) {
            provider.updateBackgroundProperties({...props, 'opacity': value});
          },
        ),
      ],
    );
  }

  Widget _buildImageSection(
    TemplateDesignerProvider provider,
    Map<String, dynamic> props,
    bool hasImage,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('صورة الخلفية'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Button(
                onPressed: () => provider.pickCustomBackgroundImage(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(FluentIcons.photo2),
                    const SizedBox(width: 8),
                    Text(hasImage ? 'تغيير الصورة' : 'اختيار صورة'),
                  ],
                ),
              ),
            ),
            if (hasImage) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(FluentIcons.delete),
                onPressed: () => provider.removeBackgroundImage(),
              ),
            ],
          ],
        ),
        if (hasImage) ...[
          const SizedBox(height: 8),
          Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[100]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FluentIcons.accept, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'تم اختيار الصورة',
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImageFitSection(
    TemplateDesignerProvider provider,
    Map<String, dynamic> props,
  ) {
    final currentFit = props['imageFit'] as String? ?? 'cover';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('نوع عرض الصورة'),
        const SizedBox(height: 8),
        ComboBox<String>(
          value: currentFit,
          items: ImageFitConstants.getAllFitTypes().map((fitType) {
            return ComboBoxItem<String>(
              value: fitType,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ImageFitConstants.getFitLabel(fitType)),
                  Text(
                    ImageFitConstants.getFitDescription(fitType),
                    style: TextStyle(fontSize: 12, color: Colors.grey[100]),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              provider.updateBackgroundImageFit(value);
            }
          },
        ),
      ],
    );
  }

  Widget _buildQuickColorButton(
    TemplateDesignerProvider provider,
    Map<String, dynamic> props,
    String colorValue,
  ) {
    final color = _parseColor(colorValue);
    final isSelected = props['color'] == colorValue;

    return GestureDetector(
      onTap: () {
        provider.updateBackgroundProperties({...props, 'color': colorValue});
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[100],
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: isSelected
            ? Icon(
                FluentIcons.accept,
                color: color.computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.white,
                size: 16,
              )
            : null,
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.white;
    }
  }
}
