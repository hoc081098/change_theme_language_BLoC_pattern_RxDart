import 'package:change_theme_language_bloc/data/models/locale_model.dart';
import 'package:change_theme_language_bloc/data/models/theme_model.dart';

import 'package:built_value/built_value.dart';

part 'setting_state.g.dart';

abstract class SettingsState
    implements Built<SettingsState, SettingsStateBuilder> {
  ThemeModel get themeModel;
  LocaleModel get localeModel;

  SettingsState._();

  factory SettingsState([updates(SettingsStateBuilder b)]) = _$SettingsState;
}
