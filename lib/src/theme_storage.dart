import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_state.dart';

abstract class ThemeStorage {
  Future<ThemeState?> loadThemeState();
  Future<void> saveThemeState(ThemeState state);
  Future<void> clearThemeState();
}

class SharedPrefsThemeStorage extends ThemeStorage {
  static const String _themeStateKey = 'flutter_theme_orchestrator_state';
  
  @override
  Future<ThemeState?> loadThemeState() async {
    final prefs = await SharedPreferences.getInstance();
    final stateJson = prefs.getString(_themeStateKey);
    if (stateJson == null) return null;
    
    try {
      final Map<String, dynamic> json = jsonDecode(stateJson);
      return ThemeState.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveThemeState(ThemeState state) async {
    final prefs = await SharedPreferences.getInstance();
    final stateJson = jsonEncode(state.toJson());
    await prefs.setString(_themeStateKey, stateJson);
  }

  @override
  Future<void> clearThemeState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_themeStateKey);
  }
}

class InMemoryThemeStorage extends ThemeStorage {
  ThemeState? _currentState;

  @override
  Future<ThemeState?> loadThemeState() async => _currentState;

  @override
  Future<void> saveThemeState(ThemeState state) async {
    _currentState = state;
  }

  @override
  Future<void> clearThemeState() async {
    _currentState = null;
  }
} 