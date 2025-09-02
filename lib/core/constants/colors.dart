import 'package:fluent_ui/fluent_ui.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF005A9F);
  static const Color primaryLight = Color(0xFF2E7BCF);
  static const Color primaryDark = Color(0xFF003B6B);

  // Secondary Colors
  static const Color secondary = Color(0xFF00B4D8);
  static const Color secondaryLight = Color(0xFF48CAE4);
  static const Color secondaryDark = Color(0xFF0077B6);

  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderFocus = Color(0xFF005A9F);

  // Sidebar Colors
  static const Color sidebarBackground = Color(0xFF2C3E50);
  static const Color sidebarSelected = Color(0xFF34495E);
  static const Color sidebarText = Color(0xFFECF0F1);

  // Template Designer Colors
  static const Color canvasBackground = Color(0xFFF8F9FA);
  static const Color gridLine = Color(0xFFE9ECEF);
  static const Color selectedElement = Color(0xFF007ACC);
  static const Color elementBorder = Color(0xFFDEE2E6);
}

class AppColorSchemes {
  static AccentColor get primaryAccent => AccentColor.swatch(const {
    'darkest': AppColors.primaryDark,
    'darker': Color(0xFF004080),
    'dark': Color(0xFF0066CC),
    'normal': AppColors.primary,
    'light': AppColors.primaryLight,
    'lighter': Color(0xFF66B3FF),
    'lightest': Color(0xFFB3D9FF),
  });
}
