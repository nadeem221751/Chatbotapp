import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'English';
  Locale _currentLocale = const Locale('en');

  String get currentLanguage => _currentLanguage;
  Locale get currentLocale => _currentLocale;

  final Map<String, Locale> _languageMap = {
    'English': const Locale('en'),
    'Hindi': const Locale('hi'),
    'Tamil': const Locale('ta'),
    'Telugu': const Locale('te'),
    'Bengali': const Locale('bn'),
    'Marathi': const Locale('mr'),
    'Gujarati': const Locale('gu'),
    'Kannada': const Locale('kn'),
    'Malayalam': const Locale('ml'),
    'Punjabi': const Locale('pa'),
    'Odia': const Locale('or'),
    'Assamese': const Locale('as'),
    'Urdu': const Locale('ur'),
  };

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('language') ?? 'English';
    _currentLocale = _languageMap[_currentLanguage] ?? const Locale('en');
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    _currentLanguage = language;
    _currentLocale = _languageMap[language] ?? const Locale('en');
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    
    notifyListeners();
  }

  List<String> get availableLanguages => _languageMap.keys.toList();
}
