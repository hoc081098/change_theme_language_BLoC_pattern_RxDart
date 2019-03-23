import 'package:change_theme_language_bloc/data/local_data_source.dart';
import 'package:change_theme_language_bloc/data/models/locale_model.dart';
import 'package:change_theme_language_bloc/data/models/theme_model.dart';
import 'package:change_theme_language_bloc/data/setting_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSourceImpl implements LocalDataSource {
  static const _kThemeKey = 'com.hoc.change_theme_language_bloc.theme';
  static const _kLocaleKey = 'com.hoc.change_theme_language_bloc.locale';

  final SettingConstants _settingConstants;
  final Future<SharedPreferences> _sharedPrefFuture;

  const LocalDataSourceImpl(this._settingConstants, this._sharedPrefFuture);

  @override
  Future<bool> saveLocale(LocaleModel locale) async {
    try {
      final sharedPreferences = await _sharedPrefFuture;
      return sharedPreferences.setString(_kLocaleKey, locale.title);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> saveTheme(ThemeModel theme) async {
    try {
      final sharedPreferences = await _sharedPrefFuture;
      return sharedPreferences.setString(_kThemeKey, theme.name);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<LocaleModel> getLocale() async {
    try {
      final sharedPreferences = await _sharedPrefFuture;
      return _settingConstants
          .findLocaleByTitle(sharedPreferences.getString(_kLocaleKey));
    } catch (e) {
      return _settingConstants.locales[0];
    }
  }

  @override
  Future<ThemeModel> getTheme() async {
    try {
      final sharedPreferences = await _sharedPrefFuture;
      return _settingConstants
          .findThemeByName(sharedPreferences.getString(_kThemeKey));
    } catch (e) {
      return _settingConstants.themes[0];
    }
  }
}
