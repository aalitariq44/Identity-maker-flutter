import 'package:fluent_ui/fluent_ui.dart';
import '../../data/models/export_record.dart';
import '../../data/models/student.dart';
import '../../data/models/template.dart';
import '../../core/database/database_provider.dart';

class ExportProvider extends ChangeNotifier {
  final DatabaseProvider _databaseProvider = DatabaseProvider();

  List<ExportRecord> _exportRecords = [];
  bool _isLoading = false;
  bool _isExporting = false;
  String? _errorMessage;
  double _exportProgress = 0.0;

  // Getters
  List<ExportRecord> get exportRecords => _exportRecords;
  bool get isLoading => _isLoading;
  bool get isExporting => _isExporting;
  String? get errorMessage => _errorMessage;
  double get exportProgress => _exportProgress;

  // Load export records
  Future<void> loadExportRecords() async {
    try {
      _setLoading(true);
      final recordMaps = await _databaseProvider.getExportRecords();
      _exportRecords = recordMaps
          .map((map) => ExportRecord.fromMap(map))
          .toList();
      _clearError();
    } catch (e) {
      _setError('خطأ في تحميل سجلات التصدير: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Export student IDs to PDF
  Future<bool> exportStudentIds({
    required List<Student> students,
    required Template template,
    required String outputPath,
    Map<String, dynamic>? settings,
  }) async {
    try {
      _setExporting(true);
      _setExportProgress(0.0);

      // TODO: Implement actual PDF generation
      // This is a placeholder implementation

      // Simulate progress
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 100));
        _setExportProgress(i / 100.0);
      }

      // Create export record
      final exportRecord = ExportRecord(
        fileName: _generateFileName(students.length, template.name),
        studentIds: students.map((s) => s.id!).toList(),
        templateId: template.id!,
        filePath: outputPath,
        totalStudents: students.length,
        exportedAt: DateTime.now(),
        exportSettings: settings ?? {},
      );

      // Save to database
      final id = await _databaseProvider.insertExportRecord(
        exportRecord.toMap(),
      );
      final newRecord = exportRecord.copyWith(id: id);
      _exportRecords.insert(0, newRecord);

      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('خطأ في تصدير الهويات: ${e.toString()}');
      return false;
    } finally {
      _setExporting(false);
      _setExportProgress(0.0);
    }
  }

  // Delete export record
  Future<bool> deleteExportRecord(int recordId) async {
    try {
      _setLoading(true);
      await _databaseProvider.deleteExportRecord(recordId);
      _exportRecords.removeWhere((record) => record.id == recordId);
      _clearError();
      notifyListeners();
      return true;
    } catch (e) {
      _setError('خطأ في حذف سجل التصدير: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get export statistics
  Map<String, dynamic> getExportStatistics() {
    final totalExports = _exportRecords.length;
    final totalStudentsExported = _exportRecords.fold<int>(
      0,
      (sum, record) => sum + record.totalStudents,
    );

    final today = DateTime.now();
    final todayExports = _exportRecords.where((record) {
      return record.exportedAt.year == today.year &&
          record.exportedAt.month == today.month &&
          record.exportedAt.day == today.day;
    }).length;

    final thisWeekExports = _exportRecords.where((record) {
      final weekAgo = today.subtract(const Duration(days: 7));
      return record.exportedAt.isAfter(weekAgo);
    }).length;

    return {
      'totalExports': totalExports,
      'totalStudentsExported': totalStudentsExported,
      'todayExports': todayExports,
      'thisWeekExports': thisWeekExports,
    };
  }

  // Search export records
  List<ExportRecord> searchExportRecords(String query) {
    if (query.isEmpty) return _exportRecords;

    return _exportRecords.where((record) {
      return record.fileName.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Filter export records by date range
  List<ExportRecord> filterByDateRange(DateTime startDate, DateTime endDate) {
    return _exportRecords.where((record) {
      return record.exportedAt.isAfter(startDate) &&
          record.exportedAt.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  // Generate filename for export
  String _generateFileName(int studentCount, String templateName) {
    final now = DateTime.now();
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}';
    return 'هويات_${templateName}_${studentCount}طالب_${dateStr}_$timeStr.pdf';
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setExporting(bool exporting) {
    _isExporting = exporting;
    notifyListeners();
  }

  void _setExportProgress(double progress) {
    _exportProgress = progress;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear all data
  void clear() {
    _exportRecords.clear();
    _errorMessage = null;
    _isLoading = false;
    _isExporting = false;
    _exportProgress = 0.0;
    notifyListeners();
  }
}
