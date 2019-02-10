import 'package:change_theme_language_bloc/data/local_data_source.dart';
import 'package:change_theme_language_bloc/data/models/theme_locale_model.dart';
import 'package:change_theme_language_bloc/data/setting_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSourceImpl implements LocalDataSource {
  static const _kThemeKey = 'com.hoc.change_theme_language_bloc.theme';
  static const _kLocaleKey = 'com.hoc.change_theme_language_bloc.locale';

  final SettingConstants settingConstants;

  const LocalDataSourceImpl(this.settingConstants);

  @override
  Future<bool> saveLocale(LocaleModel locale) async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences.setString(_kLocaleKey, locale.title);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> saveTheme(ThemeModel theme) async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences.setString(_kThemeKey, theme.name);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<LocaleModel> getLocale() async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      return settingConstants
          .findLocaleByTitle(sharedPreferences.getString(_kLocaleKey));
    } catch (e) {
      return settingConstants.locales[0];
    }
  }

  @override
  Future<ThemeModel> getTheme() async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      return settingConstants
          .findThemeByName(sharedPreferences.getString(_kThemeKey));
    } catch (e) {
      return settingConstants.themes[0];
    }
  }
}
