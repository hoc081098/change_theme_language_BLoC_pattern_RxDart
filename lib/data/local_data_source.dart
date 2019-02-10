import 'package:change_theme_language_bloc/data/models/theme_locale_model.dart';

abstract class LocalDataSource {
  Future<bool> saveTheme(ThemeModel theme);

  Future<ThemeModel> getTheme();

  Future<bool> saveLocale(LocaleModel locale);

  Future<LocaleModel> getLocale();
}
