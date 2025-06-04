// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormStep _$FormStepFromJson(Map<String, dynamic> json) => FormStep(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      data: json['data'] as Map<String, dynamic>? ?? const {},
      isValid: json['isValid'] as bool? ?? false,
      isOptional: json['isOptional'] as bool? ?? false,
      dependsOn: (json['dependsOn'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      validationErrors:
          (json['validationErrors'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$FormStepToJson(FormStep instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'data': instance.data,
      'isValid': instance.isValid,
      'isOptional': instance.isOptional,
      'dependsOn': instance.dependsOn,
      'validationErrors': instance.validationErrors,
    };
