// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThemeState _$ThemeStateFromJson(Map<String, dynamic> json) => ThemeState(
      themeMode:
          const ThemeModeConverter().fromJson(json['themeMode'] as String),
      primaryColor: const ColorConverter()
          .fromJson((json['primaryColor'] as num).toInt()),
      secondaryColor: _$JsonConverterFromJson<int, Color>(
          json['secondaryColor'], const ColorConverter().fromJson),
      tertiaryColor: _$JsonConverterFromJson<int, Color>(
          json['tertiaryColor'], const ColorConverter().fromJson),
      useMaterial3: json['useMaterial3'] as bool? ?? true,
      fontScale: (json['fontScale'] as num?)?.toDouble(),
      fontFamily: json['fontFamily'] as String?,
      customProperties: json['customProperties'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ThemeStateToJson(ThemeState instance) =>
    <String, dynamic>{
      'themeMode': const ThemeModeConverter().toJson(instance.themeMode),
      'primaryColor': const ColorConverter().toJson(instance.primaryColor),
      'secondaryColor': _$JsonConverterToJson<int, Color>(
          instance.secondaryColor, const ColorConverter().toJson),
      'tertiaryColor': _$JsonConverterToJson<int, Color>(
          instance.tertiaryColor, const ColorConverter().toJson),
      'useMaterial3': instance.useMaterial3,
      'fontScale': instance.fontScale,
      'fontFamily': instance.fontFamily,
      'customProperties': instance.customProperties,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
