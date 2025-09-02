import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar', 'SA');
  bool _isRtl = true;

  Locale get locale => _locale;
  bool get isRtl => _isRtl;

  LocaleProvider() {
    _loadLocale();
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'ar';
    final countryCode = prefs.getString('country_code') ?? 'SA';
    
    _locale = Locale(languageCode, countryCode);
    _isRtl = languageCode == 'ar';
    notifyListeners();
  }

  void setLocale(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    _isRtl = locale.languageCode == 'ar';
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    await prefs.setString('country_code', locale.countryCode ?? '');
    
    notifyListeners();
  }

  void toggleLanguage() {
    if (_locale.languageCode == 'ar') {
      setLocale(const Locale('en', 'US'));
    } else {
      setLocale(const Locale('ar', 'SA'));
    }
  }

  TextDirection get textDirection => _isRtl ? TextDirection.rtl : TextDirection.ltr;
}
