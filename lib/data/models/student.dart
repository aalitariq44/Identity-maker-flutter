class Student {
  final int? id;
  final String name;
  final DateTime birthDate;
  final String grade;
  final int schoolId;
  final String? photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Student({
    this.id,
    required this.name,
    required this.birthDate,
    required this.grade,
    required this.schoolId,
    this.photoPath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as int?,
      name: map['name'] as String,
      birthDate: DateTime.parse(map['birth_date'] as String),
      grade: map['grade'] as String,
      schoolId: map['school_id'] as int,
      photoPath: map['photo_path'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birth_date': birthDate.toIso8601String(),
      'grade': grade,
      'school_id': schoolId,
      'photo_path': photoPath,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Student copyWith({
    int? id,
    String? name,
    DateTime? birthDate,
    String? grade,
    int? schoolId,
    String? photoPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      grade: grade ?? this.grade,
      schoolId: schoolId ?? this.schoolId,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Student &&
        other.id == id &&
        other.name == name &&
        other.birthDate == birthDate &&
        other.grade == grade &&
        other.schoolId == schoolId &&
        other.photoPath == photoPath;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, birthDate, grade, schoolId, photoPath);
  }

  @override
  String toString() {
    return 'Student(id: $id, name: $name, grade: $grade)';
  }
}
