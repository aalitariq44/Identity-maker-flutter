import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';

class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  /// اختيار صورة من الكمبيوتر
  Future<String?> pickImageFromComputer() async {
    if (kIsWeb) {
      // في الويب، استخدم file_picker للحصول على base64
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'bmp', 'gif', 'webp'],
        allowMultiple: false,
        withData: true, // للحصول على البيانات في الويب
      );

      if (result != null && result.files.single.bytes != null) {
        final bytes = result.files.single.bytes!;
        final base64String =
            'data:image/${result.files.single.extension};base64,${base64Encode(bytes)}';
        return base64String;
      }
    } else {
      // في الموبايل، احفظ الملف محليًا
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'bmp', 'gif', 'webp'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        // نسخ الصورة إلى مجلد التطبيق المحلي
        return await _saveImageLocally(result.files.single.path!);
      }
    }
    return null;
  }

  /// حفظ الصورة محلياً في مجلد التطبيق
  Future<String> _saveImageLocally(String sourcePath) async {
    if (kIsWeb) {
      // في الويب، لا نحتاج إلى حفظ محلي، أعد المسار كما هو
      return sourcePath;
    } else {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(
        path.join(appDir.path, 'identity_maker', 'images'),
      );

      // إنشاء المجلد إذا لم يكن موجوداً
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      // إنشاء اسم فريد للصورة
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}${path.extension(sourcePath)}';
      final destinationPath = path.join(imagesDir.path, fileName);

      // نسخ الصورة
      final sourceFile = File(sourcePath);
      await sourceFile.copy(destinationPath);

      return destinationPath;
    }
  }

  /// التحقق من وجود الصورة
  bool imageExists(String imagePath) {
    if (kIsWeb) {
      // في الويب، تحقق إذا كان base64 أو URL
      return imagePath.isNotEmpty &&
          (imagePath.startsWith('data:image') || imagePath.startsWith('http'));
    } else {
      return File(imagePath).existsSync();
    }
  }

  /// حذف الصورة
  Future<bool> deleteImage(String imagePath) async {
    if (kIsWeb) {
      // في الويب، لا يمكن حذف الصور المحملة، فقط أعد true
      return true;
    } else {
      try {
        final file = File(imagePath);
        if (await file.exists()) {
          await file.delete();
          return true;
        }
      } catch (e) {
        print('خطأ في حذف الصورة: $e');
      }
      return false;
    }
  }

  /// الحصول على بيانات الصورة كـ Uint8List
  Future<Uint8List?> getImageBytes(String imagePath) async {
    if (kIsWeb) {
      if (imagePath.startsWith('data:image')) {
        final base64Data = imagePath.split(',')[1];
        return base64Decode(base64Data);
      } else {
        // للـ URLs، لا يمكن الحصول على البيانات محليًا
        return null;
      }
    } else {
      try {
        final file = File(imagePath);
        if (await file.exists()) {
          return await file.readAsBytes();
        }
      } catch (e) {
        print('خطأ في قراءة الصورة: $e');
      }
      return null;
    }
  }

  /// التحقق من صحة امتداد الصورة
  bool isValidImageExtension(String path) {
    final validExtensions = ['.jpg', '.jpeg', '.png', '.bmp', '.gif', '.webp'];
    final extension = path.toLowerCase();
    return validExtensions.any((ext) => extension.endsWith(ext));
  }

  /// الحصول على حجم الصورة
  Future<Size?> getImageSize(String imagePath) async {
    if (kIsWeb) {
      // في الويب، لا يمكن الحصول على الحجم بسهولة، أعد null
      return null;
    } else {
      try {
        final file = File(imagePath);
        if (await file.exists()) {
          // يمكن استخدام مكتبة image لفك تشفير الصورة والحصول على الأبعاد
          // لكن هذا يتطلب إضافة مكتبة image إلى pubspec.yaml
          return null; // سيتم تنفيذ هذا لاحقاً إذا لزم الأمر
        }
      } catch (e) {
        print('خطأ في قراءة حجم الصورة: $e');
      }
      return null;
    }
  }

  /// تنظيف الصور غير المستخدمة
  Future<void> cleanupUnusedImages(List<String> usedImagePaths) async {
    if (kIsWeb) {
      // في الويب، لا يوجد ملفات محلية لتنظيفها
      return;
    } else {
      try {
        final appDir = await getApplicationDocumentsDirectory();
        final imagesDir = Directory(
          path.join(appDir.path, 'identity_maker', 'images'),
        );

        if (await imagesDir.exists()) {
          final files = await imagesDir.list().toList();
          for (final file in files) {
            if (file is File && !usedImagePaths.contains(file.path)) {
              await file.delete();
            }
          }
        }
      } catch (e) {
        print('خطأ في تنظيف الصور: $e');
      }
    }
  }
}

// فئة مساعدة لحجم الصورة
class Size {
  final double width;
  final double height;

  const Size(this.width, this.height);

  @override
  String toString() => 'Size($width, $height)';
}
