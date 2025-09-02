class ExportRecord {
  final int? id;
  final String fileName;
  final List<int> studentIds;
  final int templateId;
  final String filePath;
  final int totalStudents;
  final DateTime exportedAt;
  final Map<String, dynamic> exportSettings;

  const ExportRecord({
    this.id,
    required this.fileName,
    required this.studentIds,
    required this.templateId,
    required this.filePath,
    required this.totalStudents,
    required this.exportedAt,
    required this.exportSettings,
  });

  factory ExportRecord.fromMap(Map<String, dynamic> map) {
    return ExportRecord(
      id: map['id'] as int?,
      fileName: map['file_name'] as String,
      studentIds: (map['student_ids'] as String)
          .split(',')
          .map((e) => int.parse(e))
          .toList(),
      templateId: map['template_id'] as int,
      filePath: map['file_path'] as String,
      totalStudents: map['total_students'] as int,
      exportedAt: DateTime.parse(map['exported_at'] as String),
      exportSettings: Map<String, dynamic>.from(
        map['export_settings'] as Map? ?? {},
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'file_name': fileName,
      'student_ids': studentIds.join(','),
      'template_id': templateId,
      'file_path': filePath,
      'total_students': totalStudents,
      'exported_at': exportedAt.toIso8601String(),
      'export_settings': exportSettings,
    };
  }

  ExportRecord copyWith({
    int? id,
    String? fileName,
    List<int>? studentIds,
    int? templateId,
    String? filePath,
    int? totalStudents,
    DateTime? exportedAt,
    Map<String, dynamic>? exportSettings,
  }) {
    return ExportRecord(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      studentIds: studentIds ?? List.from(this.studentIds),
      templateId: templateId ?? this.templateId,
      filePath: filePath ?? this.filePath,
      totalStudents: totalStudents ?? this.totalStudents,
      exportedAt: exportedAt ?? this.exportedAt,
      exportSettings: exportSettings ?? Map.from(this.exportSettings),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ExportRecord &&
        other.id == id &&
        other.fileName == fileName &&
        other.templateId == templateId &&
        other.filePath == filePath;
  }

  @override
  int get hashCode {
    return Object.hash(id, fileName, templateId, filePath);
  }

  @override
  String toString() {
    return 'ExportRecord(id: $id, fileName: $fileName, totalStudents: $totalStudents)';
  }
}
