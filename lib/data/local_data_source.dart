import 'package:change_theme_language_bloc/data/models/locale_model.dart';
import 'package:change_theme_language_bloc/data/models/theme_model.dart';

///
/// Local data source, is used to persist setting values
///
abstract class LocalDataSource {
  ///
  /// Save [theme] to persistent storage
  /// return [Future], success if value is [true], [false] otherwise
  ///
  Future<bool> saveTheme(ThemeModel theme);

  ///
  /// Get theme from persistent storage
  ///
  Future<ThemeModel> getTheme();

  /// Save [locale] to persistent storage
  /// return [Future], success if value is [true], [false] otherwise
  ///
  Future<bool> saveLocale(LocaleModel locale);

  ///
  /// Get theme from persistent storage
  ///
  Future<LocaleModel> getLocale();
}
