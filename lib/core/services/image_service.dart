import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  /// اختيار صورة من الكمبيوتر
  Future<String?> pickImageFromComputer() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'bmp', 'gif', 'webp'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        // نسخ الصورة إلى مجلد التطبيق المحلي
        return await _saveImageLocally(result.files.single.path!);
      }
    } catch (e) {
      print('خطأ في اختيار الصورة: $e');
    }
    return null;
  }

  /// حفظ الصورة محلياً في مجلد التطبيق
  Future<String> _saveImageLocally(String sourcePath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(path.join(appDir.path, 'identity_maker', 'images'));
    
    // إنشاء المجلد إذا لم يكن موجوداً
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    // إنشاء اسم فريد للصورة
    final fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(sourcePath)}';
    final destinationPath = path.join(imagesDir.path, fileName);

    // نسخ الصورة
    final sourceFile = File(sourcePath);
    await sourceFile.copy(destinationPath);

    return destinationPath;
  }

  /// التحقق من وجود الصورة
  bool imageExists(String imagePath) {
    return File(imagePath).existsSync();
  }

  /// حذف الصورة
  Future<bool> deleteImage(String imagePath) async {
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

  /// الحصول على بيانات الصورة كـ Uint8List
  Future<Uint8List?> getImageBytes(String imagePath) async {
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

  /// التحقق من صحة امتداد الصورة
  bool isValidImageExtension(String path) {
    final validExtensions = ['.jpg', '.jpeg', '.png', '.bmp', '.gif', '.webp'];
    final extension = path.toLowerCase();
    return validExtensions.any((ext) => extension.endsWith(ext));
  }

  /// الحصول على حجم الصورة
  Future<Size?> getImageSize(String imagePath) async {
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

  /// تنظيف الصور غير المستخدمة
  Future<void> cleanupUnusedImages(List<String> usedImagePaths) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory(path.join(appDir.path, 'identity_maker', 'images'));
      
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

// فئة مساعدة لحجم الصورة
class Size {
  final double width;
  final double height;

  const Size(this.width, this.height);

  @override
  String toString() => 'Size($width, $height)';
}
