# Flutter Theme Orchestrator

A powerful Flutter theme management system with support for dynamic colors, theme scheduling, transitions, and persistence.

[![pub package](https://img.shields.io/pub/v/flutter_theme_orchestrator.svg)](https://pub.dev/packages/flutter_theme_orchestrator)

## Features

- 🎨 **Dynamic Colors Support**: Seamlessly integrate with Material You/Dynamic Colors
- 📅 **Theme Scheduling**: Schedule theme changes based on time or events
- 🔄 **Smooth Transitions**: Beautiful animations when switching between themes
- 💾 **Theme Persistence**: Save and restore theme preferences
- 🎯 **Type-safe**: Fully typed API for better development experience
- 📱 **Platform Support**: Works on Android, iOS, Web, Desktop

## Getting Started

Add the package to your pubspec.yaml:

```yaml
dependencies:
  flutter_theme_orchestrator: ^0.1.0
```

## Usage

### Basic Setup

```dart
import 'package:flutter_theme_orchestrator/flutter_theme_orchestrator.dart';

void main() {
  runApp(
    ThemeOrchestrator(
      child: MyApp(),
      initialTheme: ThemeData.light(),
    ),
  );
}
```

### Dynamic Theme Switching

```dart
// Switch theme with smooth transition
ThemeOrchestrator.of(context).setTheme(ThemeData.dark());

// Toggle between light and dark
ThemeOrchestrator.of(context).toggleTheme();
```

### Theme Scheduling

```dart
// Schedule dark theme from 8 PM to 6 AM
ThemeOrchestrator.of(context).scheduleTheme(
  ThemeSchedule(
    startTime: TimeOfDay(hour: 20, minute: 0),
    endTime: TimeOfDay(hour: 6, minute: 0),
    theme: ThemeData.dark(),
  ),
);
```

### Dynamic Colors

```dart
ThemeOrchestrator.of(context).setDynamicColorsEnabled(true);
```

## Advanced Usage

Check out the [example](example) folder for a complete demo app showcasing all features.

For detailed documentation, visit our [Wiki](https://github.com/rohitjain9323/flutter_theme_orchestrator/wiki).

## Contributing

Contributions are welcome! Please read our [contributing guidelines](CONTRIBUTING.md) to get started.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
