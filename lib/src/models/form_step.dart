import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'form_step.g.dart';

@JsonSerializable()
class FormStep {
  final String id;
  final String title;
  final String? subtitle;
  final Map<String, dynamic> data;
  final bool isValid;
  final bool isOptional;
  final List<String>? dependsOn;
  final Map<String, String>? validationErrors;

  const FormStep({
    required this.id,
    required this.title,
    this.subtitle,
    this.data = const {},
    this.isValid = false,
    this.isOptional = false,
    this.dependsOn,
    this.validationErrors,
  });

  FormStep copyWith({
    String? id,
    String? title,
    String? subtitle,
    Map<String, dynamic>? data,
    bool? isValid,
    bool? isOptional,
    List<String>? dependsOn,
    Map<String, String>? validationErrors,
  }) {
    return FormStep(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      data: data ?? this.data,
      isValid: isValid ?? this.isValid,
      isOptional: isOptional ?? this.isOptional,
      dependsOn: dependsOn ?? this.dependsOn,
      validationErrors: validationErrors ?? this.validationErrors,
    );
  }

  factory FormStep.fromJson(Map<String, dynamic> json) => 
    _$FormStepFromJson(json);

  Map<String, dynamic> toJson() => _$FormStepToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FormStep &&
      other.id == id &&
      other.title == title &&
      other.subtitle == subtitle &&
      other.isValid == isValid &&
      other.isOptional == isOptional;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      subtitle,
      isValid,
      isOptional,
    );
  }
} 