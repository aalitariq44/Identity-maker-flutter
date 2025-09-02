class AppConstants {
  // App Info
  static const String appName = 'مصمم هويات الطلاب';
  static const String appVersion = '1.0.0';

  // Database
  static const String databaseName = 'identity_maker.db';
  static const int databaseVersion = 1;

  // Tables
  static const String schoolsTable = 'schools';
  static const String studentsTable = 'students';
  static const String exportRecordsTable = 'export_records';

  // Template Defaults
  static const double defaultTemplateWidth = 8.5; // cm
  static const double defaultTemplateHeight = 5.4; // cm
  static const String defaultTemplateOrientation = 'horizontal';

  // Export Settings
  static const String exportFormat = 'pdf';
  static const double a4Width = 21.0; // cm
  static const double a4Height = 29.7; // cm

  // File Paths
  static const String templatesPath = 'assets/templates/';
  static const String logosPath = 'assets/images/logos/';
  static const String fontsPath = 'assets/fonts/';

  // Supported File Types
  static const List<String> supportedImageFormats = ['png', 'jpg', 'jpeg'];
  static const List<String> supportedTemplateFormats = ['json'];
}
