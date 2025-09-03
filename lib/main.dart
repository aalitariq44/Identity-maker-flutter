import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'app.dart';

// Conditional imports for different platforms
import 'main_io.dart' if (dart.library.html) 'main_web.dart';

void main() {
  // Initialize platform-specific configurations
  initializePlatform();
  
  runApp(const IdentityMakerApp());
}
