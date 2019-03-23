import 'package:flutter/material.dart';

///
/// Theme model, wrap [ThemeData] from material library
///
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
