// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

School _$SchoolFromJson(Map<String, dynamic> json) => School(
  id: (json['id'] as num?)?.toInt(),
  nameArabic: json['nameArabic'] as String,
  nameEnglish: json['nameEnglish'] as String,
  address: json['address'] as String,
  phone: json['phone'] as String,
  principal: json['principal'] as String,
  logoPath: json['logoPath'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$SchoolToJson(School instance) => <String, dynamic>{
  'id': instance.id,
  'nameArabic': instance.nameArabic,
  'nameEnglish': instance.nameEnglish,
  'address': instance.address,
  'phone': instance.phone,
  'principal': instance.principal,
  'logoPath': instance.logoPath,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
