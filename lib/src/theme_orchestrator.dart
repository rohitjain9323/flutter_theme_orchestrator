import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:rxdart/rxdart.dart';
import 'theme_state.dart';
import 'theme_storage.dart';

class ThemeOrchestrator extends StatefulWidget {
  final Widget Function(BuildContext context, ThemeData theme) builder;
  final ThemeData? fallbackTheme;
  final ThemeState? initialThemeState;
  final ThemeStorage? storage;
  final Duration transitionDuration;
  final bool enableDynamicColors;

  const ThemeOrchestrator({
    super.key,
    required this.builder,
    this.fallbackTheme,
    this.initialThemeState,
    this.storage,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.enableDynamicColors = true,
  });

  static ThemeOrchestratorState of(BuildContext context) {
    final state = context.findAncestorStateOfType<ThemeOrchestratorState>();
    if (state == null) {
      throw FlutterError(
        'ThemeOrchestrator.of() called with a context that does not contain a ThemeOrchestrator.',
      );
    }
    return state;
  }

  @override
  ThemeOrchestratorState createState() => ThemeOrchestratorState();
}

class ThemeOrchestratorState extends State<ThemeOrchestrator> {
  late final BehaviorSubject<ThemeState> _themeStateController;
  Timer? _scheduleTimer;
  
  @override
  void initState() {
    super.initState();
    _themeStateController = BehaviorSubject<ThemeState>();
    _initializeTheme();
  }

  Future<void> _initializeTheme() async {
    ThemeState initialState;
    
    if (widget.storage != null) {
      initialState = await widget.storage!.loadThemeState() ?? 
        widget.initialThemeState ?? 
        ThemeState.defaultLight();
    } else {
      initialState = widget.initialThemeState ?? ThemeState.defaultLight();
    }

    _themeStateController.add(initialState);
  }

  Future<void> setThemeState(ThemeState newState, {bool persist = true}) async {
    if (persist && widget.storage != null) {
      await widget.storage!.saveThemeState(newState);
    }
    _themeStateController.add(newState);
  }

  Future<void> toggleThemeMode() async {
    final currentState = _themeStateController.value;
    final newMode = currentState.themeMode == ThemeMode.light 
      ? ThemeMode.dark 
      : ThemeMode.light;
    
    await setThemeState(currentState.copyWith(themeMode: newMode));
  }

  Future<void> scheduleThemeChange(
    ThemeState newState, 
    DateTime scheduledTime,
  ) async {
    _scheduleTimer?.cancel();
    
    final duration = scheduledTime.difference(DateTime.now());
    if (duration.isNegative) return;

    _scheduleTimer = Timer(duration, () {
      setThemeState(newState);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeState>(
      stream: _themeStateController.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return widget.builder(
            context, 
            widget.fallbackTheme ?? ThemeData.light(),
          );
        }

        final themeState = snapshot.data!;

        return DynamicColorBuilder(
          builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
            ThemeData theme;
            
            if (widget.enableDynamicColors && 
                (lightDynamic != null || darkDynamic != null)) {
              theme = themeState.createThemeData(
                lightDynamicScheme: lightDynamic,
                darkDynamicScheme: darkDynamic,
              );
            } else {
              theme = themeState.createThemeData();
            }

            return AnimatedTheme(
              data: theme,
              duration: widget.transitionDuration,
              child: widget.builder(context, theme),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _scheduleTimer?.cancel();
    _themeStateController.close();
    super.dispose();
  }
} 