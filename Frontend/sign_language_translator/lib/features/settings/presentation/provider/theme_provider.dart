import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dynamic_color/dynamic_color.dart';

enum ThemeModeOption { system, light, dark }
enum ColorOption { automatic, blue, green, deepPurple, red, deepOrange, amber, blueGrey, cyan, pink }

extension ThemeModeOptionExtension on ThemeModeOption {
  String get displayName {
    switch (this) {
      case ThemeModeOption.system:
        return 'Modo del Sistema';
      case ThemeModeOption.light:
        return 'Modo Claro';
      case ThemeModeOption.dark:
        return 'Modo Oscuro';
    }
  }
}

extension ColorOptionExtension on ColorOption {
  String get displayName {
    switch (this) {
      case ColorOption.automatic:
        return 'Automático';
      case ColorOption.blue:
        return 'Azul';
      case ColorOption.green:
        return 'Verde';
      case ColorOption.deepPurple:
        return 'Morado';
      case ColorOption.red:
        return 'Rojo';
      case ColorOption.deepOrange:
        return 'Naranja';
      case ColorOption.amber:
        return 'Ámbar';
      case ColorOption.blueGrey:
        return 'Azul Grisáceo';
      case ColorOption.cyan:
        return 'Cian';
      case ColorOption.pink:
        return 'Rosa';      
      // ignore: unreachable_switch_default
      default:
        return 'Morado'; // Color por defecto
    }
  }
}

class ThemeProvider with ChangeNotifier {
  ThemeModeOption _themeMode = ThemeModeOption.system;
  ColorOption _colorOption = ColorOption.automatic;
  Color? _systemColor;

  ThemeModeOption get themeMode => _themeMode;
  ColorOption get colorOption => _colorOption;
  Color? get primaryColor => _colorOption == ColorOption.automatic ? _systemColor : getColorFromOption(_colorOption);

  ThemeProvider() {
    _loadPreferences();
    DynamicColorPlugin.getCorePalette().then((palette) {
      if (palette != null) {
        _systemColor = Color(palette.primary.get(50));
        notifyListeners();
      }
    });
  }

  Color getColorFromOption(ColorOption option) {
    switch (option) {
      case ColorOption.blue:
        return Colors.blue;
      case ColorOption.green:
        return Colors.green;
      case ColorOption.deepPurple:
        return Colors.deepPurple;
      case ColorOption.red:
        return Colors.redAccent;
      case ColorOption.deepOrange:
        return Colors.deepOrange;
      case ColorOption.amber:
        return Colors.amber;
      case ColorOption.blueGrey:
        return Colors.blueGrey;
      case ColorOption.cyan:
        return Colors.cyan;
      case ColorOption.pink:
        return Colors.pinkAccent;
      default:
        return Colors.deepPurple; // Color por defecto
    }
  }

  Future<void> setThemeMode(ThemeModeOption mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('themeMode', mode.index);
  }

  Future<void> setColorOption(ColorOption color) async {
    _colorOption = color;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('colorOption', color.index);
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _themeMode = ThemeModeOption.values[prefs.getInt('themeMode') ?? 0];
    _colorOption = ColorOption.values[prefs.getInt('colorOption') ?? 0];
    notifyListeners();
  }
}
