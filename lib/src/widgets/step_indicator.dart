import 'package:flutter/material.dart';
import '../models/form_step.dart';

class StepIndicator extends StatelessWidget {
  final List<FormStep> steps;
  final int currentStep;
  final Color primaryColor;
  final double lineHeight;
  final double indicatorSize;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const StepIndicator({
    super.key,
    required this.steps,
    required this.currentStep,
    required this.primaryColor,
    this.lineHeight = 2,
    this.indicatorSize = 24,
    this.titleStyle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(steps.length * 2 - 1, (index) {
            if (index.isEven) {
              final stepIndex = index ~/ 2;
              return Expanded(
                child: _StepDot(
                  step: steps[stepIndex],
                  isActive: stepIndex == currentStep,
                  isCompleted: stepIndex < currentStep,
                  primaryColor: primaryColor,
                  size: indicatorSize,
                ),
              );
            } else {
              return Expanded(
                child: _StepLine(
                  isCompleted: index ~/ 2 < currentStep,
                  primaryColor: primaryColor,
                  height: lineHeight,
                ),
              );
            }
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: steps.map((step) {
            final index = steps.indexOf(step);
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    Text(
                      step.title,
                      style: titleStyle?.copyWith(
                        color: index <= currentStep ? primaryColor : Colors.grey,
                      ) ?? Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: index <= currentStep ? primaryColor : Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (step.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        step.subtitle!,
                        style: subtitleStyle ?? Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _StepDot extends StatelessWidget {
  final FormStep step;
  final bool isActive;
  final bool isCompleted;
  final Color primaryColor;
  final double size;

  const _StepDot({
    required this.step,
    required this.isActive,
    required this.isCompleted,
    required this.primaryColor,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isCompleted || isActive ? primaryColor : Colors.grey.shade300,
        shape: BoxShape.circle,
        border: Border.all(
          color: isActive ? primaryColor : Colors.transparent,
          width: 2,
        ),
      ),
      child: isCompleted
        ? Icon(
            Icons.check,
            color: Colors.white,
            size: size * 0.6,
          )
        : Center(
            child: Text(
              (steps.indexOf(step) + 1).toString(),
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
                fontSize: size * 0.5,
              ),
            ),
          ),
    );
  }
}

class _StepLine extends StatelessWidget {
  final bool isCompleted;
  final Color primaryColor;
  final double height;

  const _StepLine({
    required this.isCompleted,
    required this.primaryColor,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: isCompleted ? primaryColor : Colors.grey.shade300,
    );
  }
} 