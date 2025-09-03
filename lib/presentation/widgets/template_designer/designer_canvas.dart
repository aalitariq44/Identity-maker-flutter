import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:math' as math;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../providers/template_designer_provider.dart';
import '../../../data/models/template.dart';
import '../../../core/constants/image_fit_constants.dart';

class DesignerCanvas extends StatefulWidget {
  const DesignerCanvas({super.key});

  @override
  State<DesignerCanvas> createState() => _DesignerCanvasState();
}

class _DesignerCanvasState extends State<DesignerCanvas> {
  static const double _cmToPx = 37.795; // 1 cm = 37.795 pixels at 96 DPI
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Consumer<TemplateDesignerProvider>(
      builder: (context, provider, child) {
        final canvasWidth =
            provider.templateWidth * _cmToPx * provider.canvasZoom;
        final canvasHeight =
            provider.templateHeight * _cmToPx * provider.canvasZoom;

        return Listener(
          onPointerSignal: (pointerSignal) {
            if (pointerSignal is PointerScrollEvent) {
              _handleScroll(provider, pointerSignal);
            }
          },
          child: RawKeyboardListener(
            focusNode: _focusNode,
            onKey: (RawKeyEvent event) {
              if (event is RawKeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.delete) {
                if (provider.selectedElement != null) {
                  provider.deleteSelectedElement();
                }
              }
            },
            child: GestureDetector(
              onTapDown: (details) {
                _focusNode.requestFocus();
                _handleCanvasTap(provider, details);
              },
              onPanUpdate: (details) => _handleCanvasPan(provider, details),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: const Color(0xFFE0E0E0),
                child: Center(
                  child: Transform.translate(
                    offset: provider.canvasOffset,
                    child: Transform.scale(
                      scale: provider.canvasZoom,
                      child: Container(
                        width: canvasWidth / provider.canvasZoom,
                        height: canvasHeight / provider.canvasZoom,
                        decoration: BoxDecoration(
                          color: _getBackgroundColor(
                            provider.backgroundProperties,
                          ),
                          border: Border.all(
                            color: const Color(0xFFE0E0E0),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Background
                            _buildBackground(provider),
                            // Grid overlay
                            if (provider.showGrid && provider.canvasZoom > 0.5)
                              _buildGrid(provider),
                            // Template elements
                            ...provider.elements.map(
                              (element) => _buildElement(provider, element),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleScroll(
    TemplateDesignerProvider provider,
    PointerScrollEvent event,
  ) {
    const zoomSensitivity = 0.001;
    final zoomDelta = -event.scrollDelta.dy * zoomSensitivity;
    final newZoom = provider.canvasZoom + zoomDelta;
    provider.setCanvasZoom(newZoom);
  }

  void _handleCanvasTap(
    TemplateDesignerProvider provider,
    TapDownDetails details,
  ) {
    _focusNode.requestFocus();

    // Convert tap position to template coordinates (in cm)
    final tapX =
        (details.localPosition.dx - provider.canvasOffset.dx) /
        (provider.canvasZoom * _cmToPx);
    final tapY =
        (details.localPosition.dy - provider.canvasOffset.dy) /
        (provider.canvasZoom * _cmToPx);

    // Check if tap is within template bounds
    if (tapX >= 0 &&
        tapX <= provider.templateWidth &&
        tapY >= 0 &&
        tapY <= provider.templateHeight) {
      // Check if tap is on any element
      TemplateElement? tappedElement;
      for (final element in provider.elements) {
        if (tapX >= element.x &&
            tapX <= element.x + element.width &&
            tapY >= element.y &&
            tapY <= element.y + element.height) {
          tappedElement = element;
          break;
        }
      }

      if (tappedElement != null) {
        provider.selectElement(tappedElement);
      } else {
        provider.selectElement(null);
      }
    } else {
      provider.selectElement(null);
    }
  }

  void _handleCanvasPan(
    TemplateDesignerProvider provider,
    DragUpdateDetails details,
  ) {
    if (provider.selectedElement != null) {
      // Move selected element
      final deltaX = details.delta.dx / (_cmToPx * provider.canvasZoom);
      final deltaY = details.delta.dy / (_cmToPx * provider.canvasZoom);
      provider.moveElement(provider.selectedElement!.id, deltaX, deltaY);
    } else {
      // Pan canvas
      provider.setCanvasOffset(provider.canvasOffset + details.delta);
    }
  }

  Color _getBackgroundColor(Map<String, dynamic> backgroundProperties) {
    final colorHex = backgroundProperties['color'] as String? ?? '#FFFFFF';
    try {
      return Color(int.parse(colorHex.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.white;
    }
  }

  Widget _buildBackground(TemplateDesignerProvider provider) {
    final properties = provider.backgroundProperties;
    final color = _getBackgroundColor(properties);
    final opacity = (properties['opacity'] as num?)?.toDouble() ?? 1.0;
    final image = properties['image'] as String?;
    final imageType = properties['imageType'] as String?;
    final imageFit = properties['imageFit'] as String? ?? 'cover';

    // الحاوية الأساسية بلون الخلفية
    Widget backgroundWidget = Container(
      width: double.infinity,
      height: double.infinity,
      color: color.withOpacity(opacity),
    );

    if (image != null && image != 'none') {
      Widget imageWidget;

      if (imageType == 'custom' && !kIsWeb && File(image).existsSync()) {
        // عرض الصورة المخصصة من الكمبيوتر
        imageWidget = Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(File(image)),
              fit: ImageFitConstants.getBoxFitFromString(imageFit),
            ),
          ),
        );
      } else if (imageType == 'custom' &&
          kIsWeb &&
          image.startsWith('data:image')) {
        // عرض الصورة من base64 في الويب
        final base64Data = image.split(',')[1];
        final bytes = base64Decode(base64Data);
        imageWidget = Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(bytes),
              fit: ImageFitConstants.getBoxFitFromString(imageFit),
            ),
          ),
        );
      } else if (imageType == 'custom' &&
          kIsWeb &&
          (image.startsWith('http') || image.startsWith('https'))) {
        // عرض الصورة من URL في الويب
        imageWidget = Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(image),
              fit: ImageFitConstants.getBoxFitFromString(imageFit),
            ),
          ),
        );
      } else {
        // عرض رمز مؤقت للصور غير الموجودة
        imageWidget = Container(
          width: double.infinity,
          height: double.infinity,
          color: color.withOpacity(opacity),
          child: Center(
            child: Icon(
              FluentIcons.photo2,
              color: Colors.grey.withOpacity(0.3),
              size: 48,
            ),
          ),
        );
      }

      // دمج لون الخلفية مع الصورة إذا كان هناك شفافية
      if (opacity < 1.0) {
        backgroundWidget = Stack(children: [backgroundWidget, imageWidget]);
      } else {
        backgroundWidget = imageWidget;
      }
    }

    return backgroundWidget;
  }

  Widget _buildGrid(TemplateDesignerProvider provider) {
    return CustomPaint(
      size: Size(
        provider.templateWidth * _cmToPx,
        provider.templateHeight * _cmToPx,
      ),
      painter: GridPainter(
        zoom: provider.canvasZoom,
        cmToPx: _cmToPx,
        spacing: provider.gridSpacing,
        color: provider.gridColor,
      ),
    );
  }

  Widget _buildElement(
    TemplateDesignerProvider provider,
    TemplateElement element,
  ) {
    final isSelected = provider.selectedElement?.id == element.id;

    return Positioned(
      left: element.x * _cmToPx,
      top: element.y * _cmToPx,
      width: element.width * _cmToPx,
      height: element.height * _cmToPx,
      child: Stack(
        children: [
          // Element content
          GestureDetector(
            onTapDown: (_) {}, // Prevent event from bubbling to parent
            onTap: () => provider.selectElement(element),
            onPanStart: (_) => provider.selectElement(element),
            onPanUpdate: (details) {
              final deltaX = details.delta.dx / _cmToPx;
              final deltaY = details.delta.dy / _cmToPx;
              provider.moveElement(element.id, deltaX, deltaY);
            },
            child: Container(
              decoration: isSelected
                  ? BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2.0),
                    )
                  : null,
              child: _buildElementContent(element),
            ),
          ),

          // Selection handles (only show when selected)
          if (isSelected) ...[
            // Corner resize handles
            _buildResizeHandle(element, 'top-left', provider),
            _buildResizeHandle(element, 'top-right', provider),
            _buildResizeHandle(element, 'bottom-left', provider),
            _buildResizeHandle(element, 'bottom-right', provider),

            // Rotation handle
            _buildRotationHandle(element, provider),
          ],
        ],
      ),
    );
  }

  Widget _buildElementContent(TemplateElement element) {
    final rotation = element.rotation;

    Widget content = Container(
      width: double.infinity,
      height: double.infinity,
      child: _buildElementTypeContent(element),
    );

    if (rotation != 0) {
      content = Transform.rotate(angle: rotation, child: content);
    }

    return content;
  }

  Widget _buildElementTypeContent(TemplateElement element) {
    switch (element.type) {
      case 'text':
        return _buildTextElement(element);
      case 'image':
        return _buildImageElement(element);
      case 'shape':
        return _buildShapeElement(element);
      default:
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 2),
          ),
          child: Center(
            child: Text('عنصر غير معروف', style: TextStyle(color: Colors.red)),
          ),
        );
    }
  }

  Widget _buildTextElement(TemplateElement element) {
    final properties = element.properties;
    final text = properties['text'] as String? ?? '';
    final fontSize = (properties['fontSize'] as num?)?.toDouble() ?? 14.0;
    final fontFamily = properties['fontFamily'] as String? ?? 'NotoSansArabic';
    final fontWeight = _parseFontWeight(
      properties['fontWeight'] as String? ?? 'normal',
    );
    final color = _parseColor(properties['color'] as String? ?? '#000000');
    final textAlign = _parseTextAlign(
      properties['textAlign'] as String? ?? 'right',
    );

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(2),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          color: color,
        ),
        textAlign: textAlign,
        textDirection: fontFamily == 'NotoSansArabic'
            ? TextDirection.rtl
            : TextDirection.ltr,
      ),
    );
  }

  Widget _buildImageElement(TemplateElement element) {
    final properties = element.properties;
    final source = properties['source'] as String? ?? '';
    final borderRadius =
        (properties['borderRadius'] as num?)?.toDouble() ?? 0.0;
    final imageType = properties['imageType'] as String?;
    final fit = properties['fit'] as String? ?? 'contain';

    Widget imageWidget;

    if (imageType == 'custom' && !kIsWeb && File(source).existsSync()) {
      // عرض الصورة المخصصة من الكمبيوتر
      imageWidget = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          image: DecorationImage(
            image: FileImage(File(source)),
            fit: ImageFitConstants.getBoxFitFromString(fit),
          ),
        ),
      );
    } else if (imageType == 'custom' &&
        kIsWeb &&
        source.startsWith('data:image')) {
      // عرض الصورة من base64 في الويب
      final base64Data = source.split(',')[1];
      final bytes = base64Decode(base64Data);
      imageWidget = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          image: DecorationImage(
            image: MemoryImage(bytes),
            fit: ImageFitConstants.getBoxFitFromString(fit),
          ),
        ),
      );
    } else if (imageType == 'custom' &&
        kIsWeb &&
        (source.startsWith('http') || source.startsWith('https'))) {
      // عرض الصورة من URL في الويب
      imageWidget = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          image: DecorationImage(
            image: NetworkImage(source),
            fit: ImageFitConstants.getBoxFitFromString(fit),
          ),
        ),
      );
    } else if (source == 'student_photo') {
      // صورة الطالب المؤقتة
      imageWidget = Container(
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: Colors.blue,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FluentIcons.contact, color: Colors.blue, size: 24),
              const SizedBox(height: 4),
              Text(
                'صورة الطالب',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 10,
                  fontFamily: 'NotoSansArabic',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else if (source == 'school_logo') {
      // شعار المدرسة المؤقت
      imageWidget = Container(
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: Colors.green,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FluentIcons.education, color: Colors.green, size: 24),
              const SizedBox(height: 4),
              Text(
                'شعار المدرسة',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 10,
                  fontFamily: 'NotoSansArabic',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else {
      // صورة عامة أو غير موجودة
      imageWidget = Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: Colors.grey,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(FluentIcons.photo2, color: Colors.grey, size: 24),
              const SizedBox(height: 4),
              Text(
                'اختر صورة',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  fontFamily: 'NotoSansArabic',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: imageWidget,
    );
  }

  Widget _buildShapeElement(TemplateElement element) {
    final properties = element.properties;
    final shapeType = properties['shapeType'] as String? ?? 'rectangle';
    final fillColor = _parseColor(
      properties['fillColor'] as String? ?? '#CCCCCC',
    );
    final strokeColor = _parseColor(
      properties['strokeColor'] as String? ?? '#000000',
    );
    final strokeWidth = (properties['strokeWidth'] as num?)?.toDouble() ?? 1.0;

    switch (shapeType) {
      case 'circle':
        return Container(
          decoration: BoxDecoration(
            color: fillColor,
            shape: BoxShape.circle,
            border: Border.all(color: strokeColor, width: strokeWidth),
          ),
        );
      case 'rectangle':
      default:
        return Container(
          decoration: BoxDecoration(
            color: fillColor,
            border: Border.all(color: strokeColor, width: strokeWidth),
          ),
        );
    }
  }

  // Helper methods for parsing properties
  FontWeight _parseFontWeight(String weight) {
    switch (weight.toLowerCase()) {
      case 'bold':
        return FontWeight.bold;
      case 'w100':
        return FontWeight.w100;
      case 'w200':
        return FontWeight.w200;
      case 'w300':
        return FontWeight.w300;
      case 'w400':
      case 'normal':
        return FontWeight.w400;
      case 'w500':
        return FontWeight.w500;
      case 'w600':
        return FontWeight.w600;
      case 'w700':
        return FontWeight.w700;
      case 'w800':
        return FontWeight.w800;
      case 'w900':
        return FontWeight.w900;
      default:
        return FontWeight.normal;
    }
  }

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceAll('#', '0xFF')));
    } catch (e) {
      return Colors.black;
    }
  }

  TextAlign _parseTextAlign(String align) {
    switch (align.toLowerCase()) {
      case 'left':
        return TextAlign.left;
      case 'center':
        return TextAlign.center;
      case 'right':
        return TextAlign.right;
      case 'justify':
        return TextAlign.justify;
      default:
        return TextAlign.right;
    }
  }

  Widget _buildResizeHandle(
    TemplateElement element,
    String corner,
    TemplateDesignerProvider provider,
  ) {
    double left = 0;
    double top = 0;

    switch (corner) {
      case 'top-left':
        left = -6;
        top = -6;
        break;
      case 'top-right':
        left = element.width * _cmToPx - 6;
        top = -6;
        break;
      case 'bottom-left':
        left = -6;
        top = element.height * _cmToPx - 6;
        break;
      case 'bottom-right':
        left = element.width * _cmToPx - 6;
        top = element.height * _cmToPx - 6;
        break;
    }

    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onPanUpdate: (details) {
          final deltaX = details.delta.dx / _cmToPx;
          final deltaY = details.delta.dy / _cmToPx;
          provider.resizeElementFromCorner(element.id, deltaX, deltaY, corner);
        },
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(color: Colors.white, width: 1),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildRotationHandle(
    TemplateElement element,
    TemplateDesignerProvider provider,
  ) {
    return Positioned(
      left: (element.width * _cmToPx) / 2 - 6,
      top: -30,
      child: GestureDetector(
        onPanStart: (details) {
          // Store initial rotation for relative rotation calculation
        },
        onPanUpdate: (details) {
          // Calculate rotation based on drag direction relative to element center
          final elementCenterX =
              element.x * _cmToPx + (element.width * _cmToPx) / 2;
          final elementCenterY =
              element.y * _cmToPx + (element.height * _cmToPx) / 2;

          final dragX = details.globalPosition.dx;
          final dragY = details.globalPosition.dy;

          final angle = math.atan2(
            dragY - elementCenterY,
            dragX - elementCenterX,
          );
          provider.rotateElement(element.id, angle);
        },
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(color: Colors.white, width: 1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(FluentIcons.rotate, size: 8, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final double zoom;
  final double cmToPx;
  final double spacing;
  final Color color;

  GridPainter({
    required this.zoom,
    required this.cmToPx,
    required this.spacing,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (zoom < 0.8) return; // Don't show grid when zoomed out too much

    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.5;

    // Draw grid lines every spacing cm
    final spacingPx = spacing * cmToPx;

    // Vertical lines
    for (double x = 0; x <= size.width; x += spacingPx) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y <= size.height; y += spacingPx) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
