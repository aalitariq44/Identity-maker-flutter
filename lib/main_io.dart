import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';

void initializePlatform() {
  // Initialize sqflite for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    databaseFactory = databaseFactoryFfi;
  }
}
