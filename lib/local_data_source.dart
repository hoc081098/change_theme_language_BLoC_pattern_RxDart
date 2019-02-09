import 'package:change_theme_language_bloc/models.dart';

abstract class LocalDataSource {
  Future<bool> saveTheme(ThemeModel theme);

  Future<ThemeModel> getTheme();

  Future<bool> saveLocale(LocaleModel locale);

  Future<LocaleModel> getLocale();
}
