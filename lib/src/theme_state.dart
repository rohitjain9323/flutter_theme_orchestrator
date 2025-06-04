import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'color_converter.dart';
import 'theme_mode_converter.dart';

part 'theme_state.g.dart';

@JsonSerializable()
class ThemeState {
  @ThemeModeConverter()
  final ThemeMode themeMode;
  
  @ColorConverter()
  final Color primaryColor;
  
  @ColorConverter()
  final Color? secondaryColor;
  
  @ColorConverter()
  final Color? tertiaryColor;
  
  final bool useMaterial3;
  final double? fontScale;
  final String? fontFamily;
  final Map<String, dynamic>? customProperties;

  const ThemeState({
    required this.themeMode,
    required this.primaryColor,
    this.secondaryColor,
    this.tertiaryColor,
    this.useMaterial3 = true,
    this.fontScale,
    this.fontFamily,
    this.customProperties,
  });

  factory ThemeState.defaultLight() => ThemeState(
    themeMode: ThemeMode.light,
    primaryColor: Colors.blue,
    useMaterial3: true,
  );

  factory ThemeState.defaultDark() => ThemeState(
    themeMode: ThemeMode.dark,
    primaryColor: Colors.blue,
    useMaterial3: true,
  );

  ThemeState copyWith({
    ThemeMode? themeMode,
    Color? primaryColor,
    Color? secondaryColor,
    Color? tertiaryColor,
    bool? useMaterial3,
    double? fontScale,
    String? fontFamily,
    Map<String, dynamic>? customProperties,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      tertiaryColor: tertiaryColor ?? this.tertiaryColor,
      useMaterial3: useMaterial3 ?? this.useMaterial3,
      fontScale: fontScale ?? this.fontScale,
      fontFamily: fontFamily ?? this.fontFamily,
      customProperties: customProperties ?? this.customProperties,
    );
  }

  ThemeData createThemeData({
    ColorScheme? lightDynamicScheme,
    ColorScheme? darkDynamicScheme,
  }) {
    final isDark = themeMode == ThemeMode.dark;
    final dynamicScheme = isDark ? darkDynamicScheme : lightDynamicScheme;

    ColorScheme colorScheme;
    if (dynamicScheme != null) {
      colorScheme = dynamicScheme;
    } else {
      colorScheme = ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
      );
    }

    var theme = ThemeData(
      colorScheme: colorScheme,
      useMaterial3: useMaterial3,
      fontFamily: fontFamily,
    );

    if (fontScale != null) {
      theme = theme.copyWith(
        textTheme: theme.textTheme.apply(
          fontSizeFactor: fontScale!,
        ),
      );
    }

    return theme;
  }

  // JSON serialization
  factory ThemeState.fromJson(Map<String, dynamic> json) => 
    _$ThemeStateFromJson(json);
  
  Map<String, dynamic> toJson() => _$ThemeStateToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThemeState &&
      other.themeMode == themeMode &&
      other.primaryColor == primaryColor &&
      other.secondaryColor == secondaryColor &&
      other.tertiaryColor == tertiaryColor &&
      other.useMaterial3 == useMaterial3 &&
      other.fontScale == fontScale &&
      other.fontFamily == fontFamily;
  }

  @override
  int get hashCode {
    return Object.hash(
      themeMode,
      primaryColor,
      secondaryColor,
      tertiaryColor,
      useMaterial3,
      fontScale,
      fontFamily,
    );
  }
} 