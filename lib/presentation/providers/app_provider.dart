import 'package:fluent_ui/fluent_ui.dart';

class AppProvider extends ChangeNotifier {
  int _selectedPageIndex = 0;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isDarkMode = false;

  // Getters
  int get selectedPageIndex => _selectedPageIndex;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isDarkMode => _isDarkMode;

  // Navigation
  void setSelectedPageIndex(int index) {
    _selectedPageIndex = index;
    notifyListeners();
  }

  // Loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Error handling
  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Theme
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }

  // Utility methods
  void showError(String message) {
    setError(message);
    // Auto clear error after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      clearError();
    });
  }

  Future<T?> executeAsync<T>(Future<T> Function() operation) async {
    try {
      setLoading(true);
      clearError();
      final result = await operation();
      return result;
    } catch (e) {
      showError(e.toString());
      return null;
    } finally {
      setLoading(false);
    }
  }
}
