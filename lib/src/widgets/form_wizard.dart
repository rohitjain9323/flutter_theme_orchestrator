import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../controllers/form_wizard_controller.dart';
import '../models/form_step.dart';
import 'step_indicator.dart';

class FormWizard extends StatelessWidget {
  final List<FormStep> steps;
  final Widget Function(BuildContext context, FormStep step) stepBuilder;
  final bool allowBackNavigation;
  final bool validateOnChange;
  final Function(Map<String, dynamic>)? onComplete;
  final Color? primaryColor;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final Duration transitionDuration;
  final Curve transitionCurve;

  const FormWizard({
    super.key,
    required this.steps,
    required this.stepBuilder,
    this.allowBackNavigation = true,
    this.validateOnChange = true,
    this.onComplete,
    this.primaryColor,
    this.backgroundColor,
    this.padding,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.transitionCurve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FormWizardController(
        steps: steps,
        allowBackNavigation: allowBackNavigation,
        validateOnChange: validateOnChange,
        onComplete: onComplete,
      ),
      child: FormWizardContent(
        stepBuilder: stepBuilder,
        primaryColor: primaryColor ?? Theme.of(context).primaryColor,
        backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        padding: padding ?? const EdgeInsets.all(16),
        transitionDuration: transitionDuration,
        transitionCurve: transitionCurve,
      ),
    );
  }
}

class FormWizardContent extends StatelessWidget {
  final Widget Function(BuildContext context, FormStep step) stepBuilder;
  final Color primaryColor;
  final Color backgroundColor;
  final EdgeInsets padding;
  final Duration transitionDuration;
  final Curve transitionCurve;

  const FormWizardContent({
    super.key,
    required this.stepBuilder,
    required this.primaryColor,
    required this.backgroundColor,
    required this.padding,
    required this.transitionDuration,
    required this.transitionCurve,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FormWizardController>();

    return Column(
      children: [
        StepIndicator(
          steps: controller.steps,
          currentStep: controller.currentStepIndex,
          primaryColor: primaryColor,
        )
        .animate()
        .fadeIn(duration: transitionDuration, curve: transitionCurve),
        
        const SizedBox(height: 24),
        
        Expanded(
          child: StreamBuilder<int>(
            stream: controller.currentStepStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              
              return stepBuilder(context, controller.currentStep)
                .animate()
                .fadeIn(
                  duration: transitionDuration,
                  curve: transitionCurve,
                )
                .slideX(
                  begin: 0.1,
                  duration: transitionDuration,
                  curve: transitionCurve,
                );
            },
          ),
        ),
        
        const SizedBox(height: 24),
        
        _buildNavigationButtons(context),
      ],
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    final controller = context.watch<FormWizardController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (controller.canMoveBack())
          TextButton(
            onPressed: controller.previousStep,
            child: const Text('Previous'),
          )
        else
          const SizedBox(width: 80),

        StreamBuilder<double>(
          stream: controller.progressStream,
          builder: (context, snapshot) {
            return Text(
              '${((snapshot.data ?? 0) * 100).round()}%',
              style: Theme.of(context).textTheme.bodyLarge,
            );
          },
        ),

        if (!controller.isLastStep)
          ElevatedButton(
            onPressed: controller.canMoveNext() ? controller.nextStep : null,
            child: const Text('Next'),
          )
        else
          ElevatedButton(
            onPressed: () => controller.complete(),
            child: const Text('Complete'),
          ),
      ],
    )
    .animate()
    .fadeIn(duration: transitionDuration, curve: transitionCurve)
    .slideY(
      begin: 0.1,
      duration: transitionDuration,
      curve: transitionCurve,
    );
  }
} 