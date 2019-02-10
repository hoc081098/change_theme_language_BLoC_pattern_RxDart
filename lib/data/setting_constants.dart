import 'package:change_theme_language_bloc/data/models/theme_locale_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_pattern/flutter_bloc_pattern.dart';

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

  ThemeModel findThemeByName(String name) {
    return themes.firstWhere((e) => e.name == name);
  }

  LocaleModel findLocaleByTitle(String title) {
    return locales.firstWhere((e) => e.title == title);
  }

  @override
  void dispose() => null;
}
