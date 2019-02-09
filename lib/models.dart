import 'package:flutter/material.dart';

class ThemeModel {
  final String name;
  final ThemeData themeData;

  const ThemeModel(this.name, this.themeData);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          themeData == other.themeData;

  @override
  int get hashCode => name.hashCode ^ themeData.hashCode;

  @override
  String toString() => 'ThemeModel{name: $name}';
}

class LocaleModel {
  final String title;
  final Locale locale;
  final String icon;

  const LocaleModel(this.title, this.locale, this.icon);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocaleModel &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          locale == other.locale &&
          icon == other.icon;

  @override
  int get hashCode => title.hashCode ^ locale.hashCode ^ icon.hashCode;

  @override
  String toString() =>
      'LocaleModel{title: $title, locale: $locale, icon: $icon}';
}
