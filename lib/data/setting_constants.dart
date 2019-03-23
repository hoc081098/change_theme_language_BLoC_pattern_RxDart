import 'package:change_theme_language_bloc/data/models/locale_model.dart';
import 'package:change_theme_language_bloc/data/models/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';

///
/// Class holders setting constants like themes, locales
///
class SettingConstants implements BaseBloc {
  final List<LocaleModel> locales;
  final List<ThemeModel> themes;

  const SettingConstants._(this.locales, this.themes);

  factory SettingConstants() {
    const locales = <LocaleModel>[
      LocaleModel('Tiếng Việt', Locale('vi', ''), 'assets/images/vi.png'),
      LocaleModel('English', Locale('en', ''), 'assets/images/en.png'),
    ];

    final themes = <ThemeModel>[
      ThemeModel('Dark theme', ThemeData.dark()),
      ThemeModel('Blue theme', ThemeData.light()),
      ThemeModel('Pink theme', ThemeData(primarySwatch: Colors.pink)),
      ThemeModel('Teal theme', ThemeData(primarySwatch: Colors.teal)),
      ThemeModel('Amber theme', ThemeData(primarySwatch: Colors.amber)),
      ThemeModel('Purple theme', ThemeData(primarySwatch: Colors.purple)),
      ThemeModel(
          'Deep orange theme', ThemeData(primarySwatch: Colors.deepOrange)),
      ThemeModel(
          'Deep purple theme', ThemeData(primarySwatch: Colors.deepPurple)),
      ThemeModel('Orange theme', ThemeData(primarySwatch: Colors.orange)),
      ThemeModel(
          'Light green theme', ThemeData(primarySwatch: Colors.lightGreen)),
      ThemeModel(
          'Light blue theme', ThemeData(primarySwatch: Colors.lightBlue)),
    ];
    return SettingConstants._(locales, themes);
  }

  ///
  /// Returns the first theme [ThemeModel] whose name is equal to [name]
  /// Throw [StateError] if not found
  ///
  ThemeModel findThemeByName(String name) =>
      themes.firstWhere((e) => e.name == name);

  ///
  /// Returns the first locale [LocaleModel] whose title is equal to [title]
  /// Throw [StateError] if not found
  ///
  LocaleModel findLocaleByTitle(String title) =>
      locales.firstWhere((e) => e.title == title);

  ///
  /// Do nothing :v
  /// 
  @override
  void dispose() => null;
}
