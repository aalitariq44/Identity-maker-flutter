// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String,
  birthDate: DateTime.parse(json['birthDate'] as String),
  grade: json['grade'] as String,
  schoolId: (json['schoolId'] as num).toInt(),
  photoPath: json['photoPath'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'birthDate': instance.birthDate.toIso8601String(),
  'grade': instance.grade,
  'schoolId': instance.schoolId,
  'photoPath': instance.photoPath,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
