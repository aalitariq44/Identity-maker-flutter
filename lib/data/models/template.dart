class TemplateElement {
  final String id;
  final String type; // 'text', 'image', 'shape'
  final double x;
  final double y;
  final double width;
  final double height;
  final Map<String, dynamic> properties;
  final int zIndex;

  const TemplateElement({
    required this.id,
    required this.type,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.properties,
    this.zIndex = 0,
  });

  factory TemplateElement.fromJson(Map<String, dynamic> json) {
    return TemplateElement(
      id: json['id'] as String,
      type: json['type'] as String,
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      properties: Map<String, dynamic>.from(json['properties'] as Map),
      zIndex: json['zIndex'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'properties': properties,
      'zIndex': zIndex,
    };
  }

  TemplateElement copyWith({
    String? id,
    String? type,
    double? x,
    double? y,
    double? width,
    double? height,
    Map<String, dynamic>? properties,
    int? zIndex,
  }) {
    return TemplateElement(
      id: id ?? this.id,
      type: type ?? this.type,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      properties: properties ?? Map.from(this.properties),
      zIndex: zIndex ?? this.zIndex,
    );
  }

  // Helper methods for rotation
  double get rotation => (properties['rotation'] as num?)?.toDouble() ?? 0.0;

  TemplateElement copyWithRotation(double rotation) {
    final newProperties = Map<String, dynamic>.from(properties);
    newProperties['rotation'] = rotation;
    return copyWith(properties: newProperties);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TemplateElement &&
        other.id == id &&
        other.type == type &&
        other.x == x &&
        other.y == y &&
        other.width == width &&
        other.height == height &&
        other.zIndex == zIndex;
  }

  @override
  int get hashCode {
    return Object.hash(id, type, x, y, width, height, zIndex);
  }

  @override
  String toString() {
    return 'TemplateElement(id: $id, type: $type, x: $x, y: $y)';
  }
}

class Template {
  final int? id;
  final String name;
  final double width; // in cm
  final double height; // in cm
  final String orientation; // 'horizontal' or 'vertical'
  final List<TemplateElement> elements;
  final Map<String, dynamic> backgroundProperties;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Template({
    this.id,
    required this.name,
    required this.width,
    required this.height,
    required this.orientation,
    required this.elements,
    required this.backgroundProperties,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Template.fromJson(Map<String, dynamic> json) {
    return Template(
      id: json['id'] as int?,
      name: json['name'] as String,
      width: (json['width'] as num).toDouble(),
      height: (json['height'] as num).toDouble(),
      orientation: json['orientation'] as String,
      elements: (json['elements'] as List<dynamic>)
          .map((e) => TemplateElement.fromJson(e as Map<String, dynamic>))
          .toList(),
      backgroundProperties: Map<String, dynamic>.from(
        json['backgroundProperties'] as Map,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'width': width,
      'height': height,
      'orientation': orientation,
      'elements': elements.map((e) => e.toJson()).toList(),
      'backgroundProperties': backgroundProperties,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Template.fromMap(Map<String, dynamic> map) {
    return Template(
      id: map['id'] as int?,
      name: map['name'] as String,
      width: (map['width'] as num).toDouble(),
      height: (map['height'] as num).toDouble(),
      orientation: map['orientation'] as String,
      elements: (map['elements'] as List<dynamic>)
          .map((e) => TemplateElement.fromJson(e as Map<String, dynamic>))
          .toList(),
      backgroundProperties: Map<String, dynamic>.from(
        map['background_properties'] as Map,
      ),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'width': width,
      'height': height,
      'orientation': orientation,
      'elements': elements.map((e) => e.toJson()).toList(),
      'background_properties': backgroundProperties,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Template copyWith({
    int? id,
    String? name,
    double? width,
    double? height,
    String? orientation,
    List<TemplateElement>? elements,
    Map<String, dynamic>? backgroundProperties,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Template(
      id: id ?? this.id,
      name: name ?? this.name,
      width: width ?? this.width,
      height: height ?? this.height,
      orientation: orientation ?? this.orientation,
      elements: elements ?? List.from(this.elements),
      backgroundProperties:
          backgroundProperties ?? Map.from(this.backgroundProperties),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Template &&
        other.id == id &&
        other.name == name &&
        other.width == width &&
        other.height == height &&
        other.orientation == orientation;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, width, height, orientation);
  }

  @override
  String toString() {
    return 'Template(id: $id, name: $name, ${width}x$height cm)';
  }
}
