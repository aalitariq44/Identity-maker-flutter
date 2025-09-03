import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../../providers/template_designer_provider.dart';
import '../../../data/models/template.dart';
import '../../../core/constants/image_fit_constants.dart';

class ElementPropertiesPanel extends StatefulWidget {
  const ElementPropertiesPanel({super.key});

  @override
  State<ElementPropertiesPanel> createState() => _ElementPropertiesPanelState();
}

class _ElementPropertiesPanelState extends State<ElementPropertiesPanel> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TemplateDesignerProvider>(
      builder: (context, provider, child) {
        final selectedElement = provider.selectedElement;
        
        if (selectedElement == null) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'اختر عنصراً لتعديل خصائصه',
                  style: FluentTheme.of(context).typography.body,
                ),
              ),
            ),
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'خصائص العنصر',
                  style: FluentTheme.of(context).typography.subtitle,
                ),
                const SizedBox(height: 16),
                
                // خصائص عامة
                _buildGeneralProperties(provider, selectedElement),
                const SizedBox(height: 16),
                
                // خصائص خاصة بنوع العنصر
                if (selectedElement.type == 'image')
                  _buildImageProperties(provider, selectedElement),
                if (selectedElement.type == 'text')
                  _buildTextProperties(provider, selectedElement),
                if (selectedElement.type == 'shape')
                  _buildShapeProperties(provider, selectedElement),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGeneralProperties(TemplateDesignerProvider provider, TemplateElement element) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('الموقع والحجم'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InfoLabel(
                label: 'X (سم)',
                child: NumberBox<double>(
                  value: element.x,
                  onChanged: (value) {
                    if (value != null) {
                      final newElement = element.copyWith(x: value);
                      provider.updateSelectedElement(newElement);
                    }
                  },
                  mode: SpinButtonPlacementMode.inline,
                  smallChange: 0.1,
                  largeChange: 1.0,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InfoLabel(
                label: 'Y (سم)',
                child: NumberBox<double>(
                  value: element.y,
                  onChanged: (value) {
                    if (value != null) {
                      final newElement = element.copyWith(y: value);
                      provider.updateSelectedElement(newElement);
                    }
                  },
                  mode: SpinButtonPlacementMode.inline,
                  smallChange: 0.1,
                  largeChange: 1.0,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InfoLabel(
                label: 'العرض (سم)',
                child: NumberBox<double>(
                  value: element.width,
                  onChanged: (value) {
                    if (value != null && value > 0) {
                      final newElement = element.copyWith(width: value);
                      provider.updateSelectedElement(newElement);
                    }
                  },
                  mode: SpinButtonPlacementMode.inline,
                  smallChange: 0.1,
                  largeChange: 1.0,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InfoLabel(
                label: 'الارتفاع (سم)',
                child: NumberBox<double>(
                  value: element.height,
                  onChanged: (value) {
                    if (value != null && value > 0) {
                      final newElement = element.copyWith(height: value);
                      provider.updateSelectedElement(newElement);
                    }
                  },
                  mode: SpinButtonPlacementMode.inline,
                  smallChange: 0.1,
                  largeChange: 1.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageProperties(TemplateDesignerProvider provider, TemplateElement element) {
    final properties = element.properties;
    final source = properties['source'] as String? ?? '';
    final imageType = properties['imageType'] as String?;
    final fit = properties['fit'] as String? ?? 'contain';
    final borderRadius = (properties['borderRadius'] as num?)?.toDouble() ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('خصائص الصورة'),
        const SizedBox(height: 8),
        
        // اختيار مصدر الصورة
        Row(
          children: [
            Expanded(
              child: ComboBox<String>(
                value: imageType == 'custom' ? 'custom' : source,
                items: [
                  const ComboBoxItem(value: 'student_photo', child: Text('صورة الطالب')),
                  const ComboBoxItem(value: 'school_logo', child: Text('شعار المدرسة')),
                  const ComboBoxItem(value: 'custom', child: Text('صورة مخصصة')),
                ],
                onChanged: (value) {
                  if (value == 'custom') {
                    provider.updateElementImage(element.id);
                  } else if (value != null) {
                    final newProperties = Map<String, dynamic>.from(properties);
                    newProperties['source'] = value;
                    newProperties['imageType'] = 'builtin';
                    final newElement = element.copyWith(properties: newProperties);
                    provider.updateSelectedElement(newElement);
                  }
                },
              ),
            ),
            if (imageType == 'custom') ...[
              const SizedBox(width: 8),
              Button(
                onPressed: () => provider.updateElementImage(element.id),
                child: const Text('تغيير'),
              ),
            ],
          ],
        ),
        
        const SizedBox(height: 12),
        
        // نوع العرض
        InfoLabel(
          label: 'نوع العرض',
          child: ComboBox<String>(
            value: fit,
            items: ImageFitConstants.getAllFitTypes().map((fitType) {
              return ComboBoxItem<String>(
                value: fitType,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ImageFitConstants.getFitLabel(fitType)),
                    Text(
                      ImageFitConstants.getFitDescription(fitType),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[100],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                final newProperties = Map<String, dynamic>.from(properties);
                newProperties['fit'] = value;
                final newElement = element.copyWith(properties: newProperties);
                provider.updateSelectedElement(newElement);
              }
            },
          ),
        ),
        
        const SizedBox(height: 12),
        
        // انحناء الحواف
        InfoLabel(
          label: 'انحناء الحواف',
          child: NumberBox<double>(
            value: borderRadius,
            onChanged: (value) {
              if (value != null && value >= 0) {
                final newProperties = Map<String, dynamic>.from(properties);
                newProperties['borderRadius'] = value;
                final newElement = element.copyWith(properties: newProperties);
                provider.updateSelectedElement(newElement);
              }
            },
            mode: SpinButtonPlacementMode.inline,
            smallChange: 1.0,
            largeChange: 5.0,
          ),
        ),
      ],
    );
  }

  Widget _buildTextProperties(TemplateDesignerProvider provider, TemplateElement element) {
    final properties = element.properties;
    final text = properties['text'] as String? ?? '';
    final fontSize = (properties['fontSize'] as num?)?.toDouble() ?? 14.0;
    final fontFamily = properties['fontFamily'] as String? ?? 'NotoSansArabic';
    final fontWeight = properties['fontWeight'] as String? ?? 'normal';
    final color = properties['color'] as String? ?? '#000000';
    final textAlign = properties['textAlign'] as String? ?? 'right';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('خصائص النص'),
        const SizedBox(height: 8),
        
        // النص
        InfoLabel(
          label: 'النص',
          child: TextBox(
            controller: TextEditingController(text: text),
            onChanged: (value) {
              final newProperties = Map<String, dynamic>.from(properties);
              newProperties['text'] = value;
              final newElement = element.copyWith(properties: newProperties);
              provider.updateSelectedElement(newElement);
            },
            maxLines: 3,
          ),
        ),
        
        const SizedBox(height: 12),
        
        // حجم الخط
        InfoLabel(
          label: 'حجم الخط',
          child: NumberBox<double>(
            value: fontSize,
            onChanged: (value) {
              if (value != null && value > 0) {
                final newProperties = Map<String, dynamic>.from(properties);
                newProperties['fontSize'] = value;
                final newElement = element.copyWith(properties: newProperties);
                provider.updateSelectedElement(newElement);
              }
            },
            mode: SpinButtonPlacementMode.inline,
            smallChange: 1.0,
            largeChange: 2.0,
          ),
        ),
        
        const SizedBox(height: 12),
        
        // عائلة الخط
        InfoLabel(
          label: 'نوع الخط',
          child: ComboBox<String>(
            value: fontFamily,
            items: const [
              ComboBoxItem(value: 'NotoSansArabic', child: Text('نوتو العربية')),
              ComboBoxItem(value: 'Roboto', child: Text('روبوتو')),
            ],
            onChanged: (value) {
              if (value != null) {
                final newProperties = Map<String, dynamic>.from(properties);
                newProperties['fontFamily'] = value;
                final newElement = element.copyWith(properties: newProperties);
                provider.updateSelectedElement(newElement);
              }
            },
          ),
        ),
        
        const SizedBox(height: 12),
        
        // وزن الخط
        InfoLabel(
          label: 'وزن الخط',
          child: ComboBox<String>(
            value: fontWeight,
            items: const [
              ComboBoxItem(value: 'normal', child: Text('عادي')),
              ComboBoxItem(value: 'bold', child: Text('عريض')),
              ComboBoxItem(value: 'w300', child: Text('خفيف')),
              ComboBoxItem(value: 'w500', child: Text('متوسط')),
              ComboBoxItem(value: 'w700', child: Text('عريض جداً')),
            ],
            onChanged: (value) {
              if (value != null) {
                final newProperties = Map<String, dynamic>.from(properties);
                newProperties['fontWeight'] = value;
                final newElement = element.copyWith(properties: newProperties);
                provider.updateSelectedElement(newElement);
              }
            },
          ),
        ),
        
        const SizedBox(height: 12),
        
        // محاذاة النص
        InfoLabel(
          label: 'محاذاة النص',
          child: ComboBox<String>(
            value: textAlign,
            items: const [
              ComboBoxItem(value: 'right', child: Text('يمين')),
              ComboBoxItem(value: 'center', child: Text('وسط')),
              ComboBoxItem(value: 'left', child: Text('يسار')),
              ComboBoxItem(value: 'justify', child: Text('ضبط')),
            ],
            onChanged: (value) {
              if (value != null) {
                final newProperties = Map<String, dynamic>.from(properties);
                newProperties['textAlign'] = value;
                final newElement = element.copyWith(properties: newProperties);
                provider.updateSelectedElement(newElement);
              }
            },
          ),
        ),
        
        const SizedBox(height: 12),
        
        // لون النص
        InfoLabel(
          label: 'لون النص',
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: _parseColor(color),
                  border: Border.all(color: Colors.grey[100]),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextBox(
                  controller: TextEditingController(text: color),
                  placeholder: '#000000',
                  onChanged: (value) {
                    if (value.startsWith('#') && value.length == 7) {
                      final newProperties = Map<String, dynamic>.from(properties);
                      newProperties['color'] = value;
                      final newElement = element.copyWith(properties: newProperties);
                      provider.updateSelectedElement(newElement);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShapeProperties(TemplateDesignerProvider provider, TemplateElement element) {
    final properties = element.properties;
    final shapeType = properties['shapeType'] as String? ?? 'rectangle';
    final fillColor = properties['fillColor'] as String? ?? '#CCCCCC';
    final strokeColor = properties['strokeColor'] as String? ?? '#000000';
    final strokeWidth = (properties['strokeWidth'] as num?)?.toDouble() ?? 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('خصائص الشكل'),
        const SizedBox(height: 8),
        
        // نوع الشكل
        InfoLabel(
          label: 'نوع الشكل',
          child: ComboBox<String>(
            value: shapeType,
            items: const [
              ComboBoxItem(value: 'rectangle', child: Text('مستطيل')),
              ComboBoxItem(value: 'circle', child: Text('دائرة')),
            ],
            onChanged: (value) {
              if (value != null) {
                final newProperties = Map<String, dynamic>.from(properties);
                newProperties['shapeType'] = value;
                final newElement = element.copyWith(properties: newProperties);
                provider.updateSelectedElement(newElement);
              }
            },
          ),
        ),
        
        const SizedBox(height: 12),
        
        // لون التعبئة
        InfoLabel(
          label: 'لون التعبئة',
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: _parseColor(fillColor),
                  border: Border.all(color: Colors.grey[100]),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextBox(
                  controller: TextEditingController(text: fillColor),
                  placeholder: '#CCCCCC',
                  onChanged: (value) {
                    if (value.startsWith('#') && value.length == 7) {
                      final newProperties = Map<String, dynamic>.from(properties);
                      newProperties['fillColor'] = value;
                      final newElement = element.copyWith(properties: newProperties);
                      provider.updateSelectedElement(newElement);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        
        // لون الحدود
        InfoLabel(
          label: 'لون الحدود',
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: _parseColor(strokeColor),
                  border: Border.all(color: Colors.grey[100]),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextBox(
                  controller: TextEditingController(text: strokeColor),
                  placeholder: '#000000',
                  onChanged: (value) {
                    if (value.startsWith('#') && value.length == 7) {
                      final newProperties = Map<String, dynamic>.from(properties);
                      newProperties['strokeColor'] = value;
                      final newElement = element.copyWith(properties: newProperties);
                      provider.updateSelectedElement(newElement);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        
        // سمك الحدود
        InfoLabel(
          label: 'سمك الحدود',
          child: NumberBox<double>(
            value: strokeWidth,
            onChanged: (value) {
              if (value != null && value >= 0) {
                final newProperties = Map<String, dynamic>.from(properties);
                newProperties['strokeWidth'] = value;
                final newElement = element.copyWith(properties: newProperties);
                provider.updateSelectedElement(newElement);
              }
            },
            mode: SpinButtonPlacementMode.inline,
            smallChange: 0.5,
            largeChange: 1.0,
          ),
        ),
      ],
    );
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.black;
    }
  }
}
