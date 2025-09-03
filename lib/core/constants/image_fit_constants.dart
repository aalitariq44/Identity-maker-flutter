import 'package:flutter/material.dart';

/// ثوابت لأنواع عرض الصور المختلفة
class ImageFitConstants {
  static const Map<String, BoxFit> fitTypes = {
    'contain': BoxFit.contain,
    'cover': BoxFit.cover,
    'fill': BoxFit.fill,
    'fitWidth': BoxFit.fitWidth,
    'fitHeight': BoxFit.fitHeight,
    'scaleDown': BoxFit.scaleDown,
    'none': BoxFit.none,
  };

  static const Map<String, String> fitLabels = {
    'contain': 'احتواء كامل',
    'cover': 'تغطية كاملة',
    'fill': 'ملء كامل',
    'fitWidth': 'ملائمة العرض',
    'fitHeight': 'ملائمة الارتفاع',
    'scaleDown': 'تصغير فقط',
    'none': 'بدون تعديل',
  };

  static const Map<String, String> fitDescriptions = {
    'contain': 'عرض الصورة كاملة داخل الإطار مع الحفاظ على النسبة',
    'cover': 'ملء الإطار بالكامل مع قص أجزاء من الصورة إذا لزم الأمر',
    'fill': 'تمديد الصورة لملء الإطار بالكامل (قد يشوه النسبة)',
    'fitWidth': 'ملائمة عرض الصورة مع عرض الإطار',
    'fitHeight': 'ملائمة ارتفاع الصورة مع ارتفاع الإطار',
    'scaleDown': 'تصغير الصورة فقط إذا كانت أكبر من الإطار',
    'none': 'عرض الصورة بحجمها الأصلي',
  };

  /// الحصول على BoxFit من النص
  static BoxFit getBoxFitFromString(String? fitString) {
    return fitTypes[fitString] ?? BoxFit.contain;
  }

  /// الحصول على قائمة بجميع أنواع الـ fit
  static List<String> getAllFitTypes() {
    return fitTypes.keys.toList();
  }

  /// الحصول على التسمية المحلية لنوع الـ fit
  static String getFitLabel(String fitType) {
    return fitLabels[fitType] ?? fitType;
  }

  /// الحصول على وصف نوع الـ fit
  static String getFitDescription(String fitType) {
    return fitDescriptions[fitType] ?? '';
  }
}
