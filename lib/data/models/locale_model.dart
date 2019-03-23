
import 'dart:ui';

///
/// Locale model, wrap [Locale] from dart:ui library
///
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
