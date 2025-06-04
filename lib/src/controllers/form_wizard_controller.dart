import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../models/form_step.dart';

class FormWizardController extends ChangeNotifier {
  final List<FormStep> steps;
  final bool allowBackNavigation;
  final bool validateOnChange;
  final Function(Map<String, dynamic>)? onComplete;

  final BehaviorSubject<int> _currentStepController;
  final BehaviorSubject<Map<String, dynamic>> _formDataController;
  
  int get currentStepIndex => _currentStepController.value;
  FormStep get currentStep => steps[currentStepIndex];
  Map<String, dynamic> get formData => _formDataController.value;
  bool get isFirstStep => currentStepIndex == 0;
  bool get isLastStep => currentStepIndex == steps.length - 1;
  double get progress => (currentStepIndex + 1) / steps.length;

  Stream<int> get currentStepStream => _currentStepController.stream;
  Stream<Map<String, dynamic>> get formDataStream => _formDataController.stream;
  Stream<double> get progressStream => currentStepStream.map((index) => (index + 1) / steps.length);

  FormWizardController({
    required this.steps,
    this.allowBackNavigation = true,
    this.validateOnChange = true,
    this.onComplete,
  }) : 
    _currentStepController = BehaviorSubject<int>.seeded(0),
    _formDataController = BehaviorSubject<Map<String, dynamic>>.seeded({});

  void updateStepData(String stepId, Map<String, dynamic> data) {
    final newData = Map<String, dynamic>.from(formData);
    newData[stepId] = data;
    _formDataController.add(newData);
    
    if (validateOnChange) {
      validateCurrentStep();
    }
    notifyListeners();
  }

  bool validateCurrentStep() {
    final step = steps[currentStepIndex];
    if (step.isOptional) return true;

    // Check dependencies
    if (step.dependsOn != null) {
      for (final dependencyId in step.dependsOn!) {
        if (!formData.containsKey(dependencyId)) {
          return false;
        }
      }
    }

    // Custom validation can be added here
    return true;
  }

  bool canMoveNext() {
    if (isLastStep) return false;
    if (!validateCurrentStep()) return false;
    return true;
  }

  bool canMoveBack() {
    if (!allowBackNavigation) return false;
    if (isFirstStep) return false;
    return true;
  }

  void nextStep() {
    if (!canMoveNext()) return;
    _currentStepController.add(currentStepIndex + 1);
    notifyListeners();
  }

  void previousStep() {
    if (!canMoveBack()) return;
    _currentStepController.add(currentStepIndex - 1);
    notifyListeners();
  }

  void goToStep(int index) {
    if (index < 0 || index >= steps.length) return;
    if (!allowBackNavigation && index < currentStepIndex) return;
    _currentStepController.add(index);
    notifyListeners();
  }

  Future<bool> complete() async {
    if (!isLastStep) return false;
    if (!validateCurrentStep()) return false;

    if (onComplete != null) {
      onComplete!(formData);
    }
    return true;
  }

  @override
  void dispose() {
    _currentStepController.close();
    _formDataController.close();
    super.dispose();
  }
} 