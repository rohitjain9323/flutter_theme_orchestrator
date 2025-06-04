import 'package:flutter/material.dart';
import 'package:flutter_theme_orchestrator/flutter_theme_orchestrator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeOrchestrator(
      storage: SharedPrefsThemeStorage(),
      initialThemeState: ThemeState.defaultLight(),
      builder: (context, theme) {
        return MaterialApp(
          title: 'Theme Orchestrator Demo',
          theme: theme,
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Orchestrator Demo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildThemeModeSection(context),
          const SizedBox(height: 24),
          _buildColorSection(context),
          const SizedBox(height: 24),
          _buildScheduleSection(context),
          const SizedBox(height: 24),
          _buildCustomizationSection(context),
        ],
      ),
    );
  }

  Widget _buildThemeModeSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Mode',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () => ThemeOrchestrator.of(context).setThemeState(
                    ThemeState.defaultLight(),
                  ),
                  icon: const Icon(Icons.light_mode),
                  label: const Text('Light'),
                ),
                ElevatedButton.icon(
                  onPressed: () => ThemeOrchestrator.of(context).setThemeState(
                    ThemeState.defaultDark(),
                  ),
                  icon: const Icon(Icons.dark_mode),
                  label: const Text('Dark'),
                ),
                ElevatedButton.icon(
                  onPressed: () => ThemeOrchestrator.of(context).toggleThemeMode(),
                  icon: const Icon(Icons.contrast),
                  label: const Text('Toggle'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSection(BuildContext context) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Primary Color',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: colors.map((color) {
                return InkWell(
                  onTap: () {
                    ThemeOrchestrator.of(context).setThemeState(
                      ThemeState(
                        themeMode: ThemeMode.system,
                        primaryColor: color,
                      ),
                    );
                  },
                  child: CircleAvatar(
                    backgroundColor: color,
                    radius: 20,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme Scheduling',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                final futureTime = DateTime.now().add(
                  const Duration(seconds: 5),
                );
                ThemeOrchestrator.of(context).scheduleThemeChange(
                  ThemeState.defaultDark(),
                  futureTime,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Dark theme scheduled in 5 seconds'),
                  ),
                );
              },
              icon: const Icon(Icons.schedule),
              label: const Text('Schedule Dark Theme (5s)'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomizationSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customization',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                ThemeOrchestrator.of(context).setThemeState(
                  ThemeState(
                    themeMode: ThemeMode.system,
                    primaryColor: Colors.deepPurple,
                    secondaryColor: Colors.amber,
                    tertiaryColor: Colors.teal,
                    fontScale: 1.2,
                    fontFamily: 'Roboto',
                    customProperties: {
                      'customSpacing': 16.0,
                      'borderRadius': 8.0,
                    },
                  ),
                );
              },
              icon: const Icon(Icons.style),
              label: const Text('Apply Custom Theme'),
            ),
          ],
        ),
      ),
    );
  }
} 