// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExportRecord _$ExportRecordFromJson(Map<String, dynamic> json) => ExportRecord(
  id: (json['id'] as num?)?.toInt(),
  fileName: json['fileName'] as String,
  studentIds: (json['studentIds'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  templateId: (json['templateId'] as num).toInt(),
  filePath: json['filePath'] as String,
  totalStudents: (json['totalStudents'] as num).toInt(),
  exportedAt: DateTime.parse(json['exportedAt'] as String),
  exportSettings: json['exportSettings'] as Map<String, dynamic>,
);

Map<String, dynamic> _$ExportRecordToJson(ExportRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fileName': instance.fileName,
      'studentIds': instance.studentIds,
      'templateId': instance.templateId,
      'filePath': instance.filePath,
      'totalStudents': instance.totalStudents,
      'exportedAt': instance.exportedAt.toIso8601String(),
      'exportSettings': instance.exportSettings,
    };
