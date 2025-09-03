import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../providers/template_designer_provider.dart';
import '../../../data/models/template.dart';

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
                            if (provider.canvasZoom > 0.5) _buildGrid(provider),
                            // Template elements
                            ...provider.elements.map(
                              (element) => _buildElement(provider, element),
                            ),
                            // Selection overlay
                            if (provider.selectedElement != null)
                              _buildSelectionOverlay(
                                provider,
                                provider.selectedElement!,
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
    // Convert screen coordinates to canvas coordinates
    final RenderBox box = context.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(details.globalPosition);

    // Check if any element was clicked
    TemplateElement? clickedElement;
    for (final element in provider.elements.reversed) {
      if (_isPointInElement(localPosition, element, provider)) {
        clickedElement = element;
        break;
      }
    }

    provider.selectElement(clickedElement);
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

  bool _isPointInElement(
    Offset point,
    TemplateElement element,
    TemplateDesignerProvider provider,
  ) {
    final elementX = element.x * _cmToPx * provider.canvasZoom;
    final elementY = element.y * _cmToPx * provider.canvasZoom;
    final elementWidth = element.width * _cmToPx * provider.canvasZoom;
    final elementHeight = element.height * _cmToPx * provider.canvasZoom;

    return point.dx >= elementX &&
        point.dx <= elementX + elementWidth &&
        point.dy >= elementY &&
        point.dy <= elementY + elementHeight;
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
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: _getBackgroundColor(provider.backgroundProperties),
    );
  }

  Widget _buildGrid(TemplateDesignerProvider provider) {
    return CustomPaint(
      size: Size(
        provider.templateWidth * _cmToPx,
        provider.templateHeight * _cmToPx,
      ),
      painter: GridPainter(zoom: provider.canvasZoom, cmToPx: _cmToPx),
    );
  }

  Widget _buildElement(
    TemplateDesignerProvider provider,
    TemplateElement element,
  ) {
    return Positioned(
      left: element.x * _cmToPx,
      top: element.y * _cmToPx,
      width: element.width * _cmToPx,
      height: element.height * _cmToPx,
      child: GestureDetector(
        onTap: () => provider.selectElement(element),
        onPanUpdate: (details) {
          final deltaX = details.delta.dx / _cmToPx;
          final deltaY = details.delta.dy / _cmToPx;
          provider.moveElement(element.id, deltaX, deltaY);
        },
        child: _buildElementContent(element),
      ),
    );
  }

  Widget _buildElementContent(TemplateElement element) {
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

    Widget imageWidget;

    if (source == 'student_photo') {
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
          child: Icon(FluentIcons.contact, color: Colors.blue, size: 24),
        ),
      );
    } else if (source == 'school_logo') {
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
          child: Icon(FluentIcons.education, color: Colors.green, size: 24),
        ),
      );
    } else {
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
        child: const Center(
          child: Icon(FluentIcons.photo2, color: Colors.grey, size: 24),
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

  Widget _buildSelectionOverlay(
    TemplateDesignerProvider provider,
    TemplateElement element,
  ) {
    return Positioned(
      left: element.x * _cmToPx - 4,
      top: element.y * _cmToPx - 4,
      width: element.width * _cmToPx + 8,
      height: element.height * _cmToPx + 8,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 2),
        ),
        child: Stack(
          children: [
            // Resize handles
            ..._buildResizeHandles(provider, element),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildResizeHandles(
    TemplateDesignerProvider provider,
    TemplateElement element,
  ) {
    const handleSize = 8.0;

    return [
      // Top-left
      Positioned(
        left: -handleSize / 2,
        top: -handleSize / 2,
        child: _buildResizeHandle(() {
          // TODO: Implement corner resize
        }),
      ),
      // Top-right
      Positioned(
        right: -handleSize / 2,
        top: -handleSize / 2,
        child: _buildResizeHandle(() {
          // TODO: Implement corner resize
        }),
      ),
      // Bottom-left
      Positioned(
        left: -handleSize / 2,
        bottom: -handleSize / 2,
        child: _buildResizeHandle(() {
          // TODO: Implement corner resize
        }),
      ),
      // Bottom-right
      Positioned(
        right: -handleSize / 2,
        bottom: -handleSize / 2,
        child: _buildResizeHandle(() {
          // TODO: Implement corner resize
        }),
      ),
    ];
  }

  Widget _buildResizeHandle(VoidCallback onResize) {
    return GestureDetector(
      onPanUpdate: (details) => onResize(),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Colors.blue,
          border: Border.all(color: Colors.white, width: 1),
          shape: BoxShape.circle,
        ),
      ),
    );
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
}

class GridPainter extends CustomPainter {
  final double zoom;
  final double cmToPx;

  GridPainter({required this.zoom, required this.cmToPx});

  @override
  void paint(Canvas canvas, Size size) {
    if (zoom < 0.8) return; // Don't show grid when zoomed out too much

    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 0.5;

    // Draw grid lines every 0.5 cm
    const gridSpacing = 0.5;
    final spacing = gridSpacing * cmToPx;

    // Vertical lines
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
